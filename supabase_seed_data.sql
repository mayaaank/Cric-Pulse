-- ============================================================
-- SEED DATA for Cric-Pulse Supabase Database
-- Run this in the Supabase SQL Editor (Dashboard > SQL Editor)
-- ============================================================

-- 1. SAMPLE MATCHES
INSERT INTO matches (id, title, team1_name, team2_name, team1_flag_url, team2_flag_url, venue, match_type, status, started_at) VALUES
  (gen_random_uuid(), 'PBKS vs RCB', 'Punjab Kings', 'Royal Challengers Bengaluru', '🔴', '🔴', 'Dharamsala', 'T20', 'live', NOW() - INTERVAL '1 hour'),
  (gen_random_uuid(), 'CSK vs MI', 'Chennai Super Kings', 'Mumbai Indians', '🟡', '🔵', 'Chepauk', 'T20', 'live', NOW() - INTERVAL '2 hours'),
  (gen_random_uuid(), 'KKR vs SRH', 'Kolkata Knight Riders', 'Sunrisers Hyderabad', '🟣', '🟠', 'Eden Gardens', 'T20', 'upcoming', NOW() + INTERVAL '3 hours'),
  (gen_random_uuid(), 'GT vs RR', 'Gujarat Titans', 'Rajasthan Royals', '🔵', '🩷', 'Ahmedabad', 'T20', 'completed', NOW() - INTERVAL '1 day'),
  (gen_random_uuid(), 'DC vs LSG', 'Delhi Capitals', 'Lucknow Super Giants', '🔵', '🟡', 'Arun Jaitley Stadium', 'T20', 'upcoming', NOW() + INTERVAL '1 day');

-- 2. SAMPLE POLLS (linked to the first match — update match_id after insert)
-- We'll use a CTE to get the first live match
WITH live_match AS (
  SELECT id FROM matches WHERE status = 'live' LIMIT 1
)
INSERT INTO polls (id, match_id, question, option_a, option_b, is_active, expires_at) VALUES
  (gen_random_uuid(), (SELECT id FROM live_match), 'Will this over go for 10+ runs?', 'Yes', 'No', true, NOW() + INTERVAL '30 minutes'),
  (gen_random_uuid(), (SELECT id FROM live_match), 'Will there be a wicket in the next 3 overs?', 'Yes, wicket incoming!', 'No, batsmen will survive', true, NOW() + INTERVAL '1 hour'),
  (gen_random_uuid(), (SELECT id FROM live_match), 'Who will score more in the powerplay?', 'Batting team crosses 60', 'Batting team stays under 60', true, NOW() + INTERVAL '45 minutes'),
  (gen_random_uuid(), NULL, 'Who will win IPL 2025?', 'Punjab Kings', 'Royal Challengers Bengaluru', true, NOW() + INTERVAL '7 days'),
  (gen_random_uuid(), NULL, 'Best T20 batter this season?', 'Abhishek Sharma', 'Virat Kohli', true, NOW() + INTERVAL '7 days');

-- 3. SAMPLE TRIVIA QUESTIONS
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

-- 4. SAMPLE PREDICTION ROUNDS (linked to live matches)
WITH live_matches AS (
  SELECT id, ROW_NUMBER() OVER (ORDER BY started_at) AS rn
  FROM matches WHERE status = 'live'
)
INSERT INTO prediction_rounds (id, match_id, over_number, ball_number, status) VALUES
  (gen_random_uuid(), (SELECT id FROM live_matches WHERE rn = 1), 12, 4, 'open'),
  (gen_random_uuid(), (SELECT id FROM live_matches WHERE rn = 1), 12, 3, 'settled');

-- ============================================================
-- DONE! Your app now has seed data.
-- ============================================================
