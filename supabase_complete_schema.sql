-- ==============================================================================
-- CRIC-PULSE COMPLETE SUPABASE SCHEMA
-- Copy and paste this entire script into the Supabase SQL Editor and click RUN.
-- ==============================================================================

-- ==========================================
-- 1. DROP EXISTING TABLES (Reset)
-- ==========================================
DROP TABLE IF EXISTS user_predictions CASCADE;
DROP TABLE IF EXISTS prediction_rounds CASCADE;
DROP TABLE IF EXISTS user_trivia_answers CASCADE;
DROP TABLE IF EXISTS user_trivia_sessions CASCADE;
DROP TABLE IF EXISTS trivia_questions CASCADE;
DROP TABLE IF EXISTS poll_votes CASCADE;
DROP TABLE IF EXISTS polls CASCADE;
DROP TABLE IF EXISTS matches CASCADE;
DROP TABLE IF EXISTS user_stats CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;

-- ==========================================
-- 2. CREATE CORE TABLES
-- ==========================================

-- A. Profiles (Linked to Supabase Auth)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  total_xp INT DEFAULT 0,
  level INT DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- B. User Stats (For Leaderboard)
CREATE TABLE user_stats (
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE PRIMARY KEY,
  correct_predictions INT DEFAULT 0,
  total_predictions INT DEFAULT 0,
  polls_answered INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- C. Matches (Live Ticker Data)
CREATE TABLE matches (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  team1_name TEXT NOT NULL,
  team2_name TEXT NOT NULL,
  team1_flag_url TEXT,
  team2_flag_url TEXT,
  venue TEXT,
  match_type TEXT CHECK (match_type IN ('T20', 'ODI', 'TEST')),
  status TEXT CHECK (status IN ('upcoming', 'live', 'completed')),
  current_innings JSONB DEFAULT '{"batting_team": null, "score": null, "wickets": null, "overs": null}',
  started_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- D. Polls
CREATE TABLE polls (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  match_id UUID REFERENCES matches ON DELETE CASCADE,
  question TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_a_votes INT DEFAULT 0,
  option_b_votes INT DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- E. Poll Votes (Tracks who voted for what)
CREATE TABLE poll_votes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  poll_id UUID REFERENCES polls ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  vote TEXT CHECK (vote IN ('option_a', 'option_b')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(poll_id, user_id) -- A user can only vote once per poll
);

-- F. Trivia Questions
CREATE TABLE trivia_questions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  category TEXT DEFAULT 'cricket',
  question TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  option_d TEXT NOT NULL,
  correct_option TEXT CHECK (correct_option IN ('A', 'B', 'C', 'D')),
  difficulty TEXT CHECK (difficulty IN ('easy', 'medium', 'hard')),
  xp_reward INT DEFAULT 10,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- G. User Trivia Sessions (Tracks daily plays)
CREATE TABLE user_trivia_sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  score INT DEFAULT 0,
  completed BOOLEAN DEFAULT false,
  played_at TIMESTAMPTZ DEFAULT NOW()
);

-- H. User Trivia Answers (Individual answers)
CREATE TABLE user_trivia_answers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id UUID REFERENCES user_trivia_sessions ON DELETE CASCADE,
  question_id UUID REFERENCES trivia_questions ON DELETE CASCADE,
  selected_option TEXT CHECK (selected_option IN ('A', 'B', 'C', 'D')),
  is_correct BOOLEAN,
  time_taken_seconds INT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(session_id, question_id)
);

-- I. Prediction Rounds (Linked to Match events like "Over 12 Ball 4")
CREATE TABLE prediction_rounds (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  match_id UUID REFERENCES matches ON DELETE CASCADE,
  over_number INT,
  ball_number INT,
  status TEXT CHECK (status IN ('open', 'closed', 'settled')),
  actual_outcome TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- J. User Predictions (What the user guessed)
CREATE TABLE user_predictions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  round_id UUID REFERENCES prediction_rounds ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  predicted_outcome TEXT CHECK (predicted_outcome IN ('dot', 'single', 'double', 'triple', 'four', 'six', 'wicket', 'wide', 'no_ball')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(round_id, user_id) -- One prediction per round per user
);


-- ==========================================
-- 3. CREATE FUNCTIONS & TRIGGERS
-- ==========================================

-- A. Auto-Create Profile on Signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, username, display_name)
  VALUES (
    new.id,
    COALESCE(new.raw_user_meta_data->>'username', 'user_' || substr(new.id::text, 1, 8)),
    COALESCE(new.raw_user_meta_data->>'display_name', 'Cricket Fan')
  );
  
  -- Also initialize their stats row
  INSERT INTO public.user_stats (user_id, correct_predictions, total_predictions, polls_answered)
  VALUES (new.id, 0, 0, 0);
  
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


-- B. Auto-increment Poll Counts
CREATE OR REPLACE FUNCTION update_poll_counts()
RETURNS trigger AS $$
BEGIN
  IF NEW.vote = 'option_a' THEN
    UPDATE polls SET option_a_votes = option_a_votes + 1 WHERE id = NEW.poll_id;
  ELSIF NEW.vote = 'option_b' THEN
    UPDATE polls SET option_b_votes = option_b_votes + 1 WHERE id = NEW.poll_id;
  END IF;
  
  -- Increment polls_answered for the user
  UPDATE user_stats SET polls_answered = polls_answered + 1 WHERE user_id = NEW.user_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_poll_counts ON poll_votes;
CREATE TRIGGER trigger_update_poll_counts
  AFTER INSERT ON poll_votes
  FOR EACH ROW EXECUTE FUNCTION update_poll_counts();


-- C. Auto-increment User XP on Correct Trivia
CREATE OR REPLACE FUNCTION update_trivia_xp()
RETURNS trigger AS $$
BEGIN
  IF NEW.is_correct = true THEN
    UPDATE profiles 
    SET total_xp = total_xp + (SELECT xp_reward FROM trivia_questions WHERE id = NEW.question_id)
    WHERE id = (SELECT user_id FROM user_trivia_sessions WHERE id = NEW.session_id);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_trivia_xp ON user_trivia_answers;
CREATE TRIGGER trigger_update_trivia_xp
  AFTER INSERT ON user_trivia_answers
  FOR EACH ROW EXECUTE FUNCTION update_trivia_xp();


-- ==========================================
-- 4. ENABLE REALTIME
-- ==========================================
-- This prevents the "channelError" in Flutter when using .stream()
alter publication supabase_realtime add table polls;
alter publication supabase_realtime add table prediction_rounds;


-- ==========================================
-- 5. INSERT SEED DATA
-- ==========================================
INSERT INTO matches (id, title, team1_name, team2_name, team1_flag_url, team2_flag_url, venue, match_type, status, started_at) VALUES
  (gen_random_uuid(), 'PBKS vs RCB', 'Punjab Kings', 'Royal Challengers Bengaluru', '🔴', '🔴', 'Dharamsala', 'T20', 'live', NOW() - INTERVAL '1 hour'),
  (gen_random_uuid(), 'CSK vs MI', 'Chennai Super Kings', 'Mumbai Indians', '🟡', '🔵', 'Chepauk', 'T20', 'live', NOW() - INTERVAL '2 hours'),
  (gen_random_uuid(), 'KKR vs SRH', 'Kolkata Knight Riders', 'Sunrisers Hyderabad', '🟣', '🟠', 'Eden Gardens', 'T20', 'upcoming', NOW() + INTERVAL '3 hours'),
  (gen_random_uuid(), 'GT vs RR', 'Gujarat Titans', 'Rajasthan Royals', '🔵', '🩷', 'Ahmedabad', 'T20', 'completed', NOW() - INTERVAL '1 day'),
  (gen_random_uuid(), 'DC vs LSG', 'Delhi Capitals', 'Lucknow Super Giants', '🔵', '🟡', 'Arun Jaitley Stadium', 'T20', 'upcoming', NOW() + INTERVAL '1 day');

WITH live_match AS (
  SELECT id FROM matches WHERE status = 'live' LIMIT 1
)
INSERT INTO polls (id, match_id, question, option_a, option_b, is_active, expires_at) VALUES
  (gen_random_uuid(), (SELECT id FROM live_match), 'Will this over go for 10+ runs?', 'Yes', 'No', true, NOW() + INTERVAL '30 minutes'),
  (gen_random_uuid(), (SELECT id FROM live_match), 'Will there be a wicket in the next 3 overs?', 'Yes, wicket incoming!', 'No, batsmen will survive', true, NOW() + INTERVAL '1 hour'),
  (gen_random_uuid(), (SELECT id FROM live_match), 'Who will score more in the powerplay?', 'Batting team crosses 60', 'Batting team stays under 60', true, NOW() + INTERVAL '45 minutes'),
  (gen_random_uuid(), NULL, 'Who will win IPL 2025?', 'Punjab Kings', 'Royal Challengers Bengaluru', true, NOW() + INTERVAL '7 days'),
  (gen_random_uuid(), NULL, 'Best T20 batter this season?', 'Abhishek Sharma', 'Virat Kohli', true, NOW() + INTERVAL '7 days');

INSERT INTO trivia_questions (id, category, question, option_a, option_b, option_c, option_d, correct_option, difficulty, xp_reward, is_active) VALUES
  (gen_random_uuid(), 'IPL', 'Which team has won the most IPL titles?', 'Mumbai Indians', 'Chennai Super Kings', 'Kolkata Knight Riders', 'Royal Challengers Bengaluru', 'A', 'easy', 10, true),
  (gen_random_uuid(), 'IPL', 'Who scored the fastest century in IPL history?', 'Chris Gayle', 'AB de Villiers', 'David Warner', 'KL Rahul', 'A', 'medium', 15, true),
  (gen_random_uuid(), 'cricket', 'What is the highest individual score in T20 Internationals?', '172 by Aaron Finch', '175 by Chris Gayle', '156 by Rohit Sharma', '162 by Hazratullah Zazai', 'A', 'hard', 20, true),
  (gen_random_uuid(), 'cricket', 'Who holds the record for most wickets in Test cricket?', 'Shane Warne', 'James Anderson', 'Muttiah Muralitharan', 'Anil Kumble', 'C', 'medium', 15, true),
  (gen_random_uuid(), 'IPL', 'Which player has scored the most runs in IPL history?', 'Rohit Sharma', 'Virat Kohli', 'David Warner', 'Suresh Raina', 'B', 'easy', 10, true),
  (gen_random_uuid(), 'cricket', 'In which year was the first Cricket World Cup held?', '1975', '1979', '1983', '1971', 'A', 'easy', 10, true),
  (gen_random_uuid(), 'IPL', 'Who took the first hat-trick in IPL?', 'Lakshmipathy Balaji', 'Amit Mishra', 'Shane Warne', 'Harbhajan Singh', 'A', 'hard', 20, true),
  (gen_random_uuid(), 'cricket', 'Which bowler has the best bowling figures in a single Test innings?', 'Jim Laker', 'Anil Kumble', 'Muttiah Muralitharan', 'Shane Warne', 'A', 'hard', 20, true),
  (gen_random_uuid(), 'IPL', 'What is the highest team total in an IPL match?', '287/3', '263/5', '277/3', '270/4', 'C', 'medium', 15, true),
  (gen_random_uuid(), 'cricket', 'Who hit six sixes in a single over in international cricket?', 'Yuvraj Singh', 'Herschelle Gibbs', 'Both A and B', 'Chris Gayle', 'C', 'medium', 15, true);

WITH live_matches AS (
  SELECT id, ROW_NUMBER() OVER (ORDER BY started_at) AS rn
  FROM matches WHERE status = 'live'
)
INSERT INTO prediction_rounds (id, match_id, over_number, ball_number, status) VALUES
  (gen_random_uuid(), (SELECT id FROM live_matches WHERE rn = 1), 12, 4, 'open'),
  (gen_random_uuid(), (SELECT id FROM live_matches WHERE rn = 1), 12, 3, 'settled');

-- ==========================================
-- 6. DISABLE RLS (For local development/testing)
-- In production, you would set up policies.
-- ==========================================
-- Since this is just getting it working, let's make sure the client can read/write
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_stats DISABLE ROW LEVEL SECURITY;
ALTER TABLE matches DISABLE ROW LEVEL SECURITY;
ALTER TABLE polls DISABLE ROW LEVEL SECURITY;
ALTER TABLE poll_votes DISABLE ROW LEVEL SECURITY;
ALTER TABLE trivia_questions DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_trivia_sessions DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_trivia_answers DISABLE ROW LEVEL SECURITY;
ALTER TABLE prediction_rounds DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_predictions DISABLE ROW LEVEL SECURITY;
