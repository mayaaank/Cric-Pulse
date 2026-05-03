import 'dart:async';
import 'dart:math';
import '../models/match.dart';
import '../models/player.dart';
import '../models/score.dart';
import '../models/team.dart';

class MockDataService {
  static final _rand = Random();

  static final List<Team> teams = [
    const Team(id: 'PBKS', name: 'Punjab Kings', shortCode: 'PBKS', flagEmoji: '🔴', iccRanking: 1, matchesPlayed: 8, wins: 6),
    const Team(id: 'RCB', name: 'Royal Challengers Bengaluru', shortCode: 'RCB', flagEmoji: '🔴', iccRanking: 2, matchesPlayed: 9, wins: 6),
    const Team(id: 'SRH', name: 'Sunrisers Hyderabad', shortCode: 'SRH', flagEmoji: '🟠', iccRanking: 3, matchesPlayed: 9, wins: 6),
    const Team(id: 'RR', name: 'Rajasthan Royals', shortCode: 'RR', flagEmoji: '🩷', iccRanking: 4, matchesPlayed: 10, wins: 6),
    const Team(id: 'GT', name: 'Gujarat Titans', shortCode: 'GT', flagEmoji: '🔵', iccRanking: 5, matchesPlayed: 9, wins: 5),
    const Team(id: 'DC', name: 'Delhi Capitals', shortCode: 'DC', flagEmoji: '🔵', iccRanking: 6, matchesPlayed: 9, wins: 4),
    const Team(id: 'CSK', name: 'Chennai Super Kings', shortCode: 'CSK', flagEmoji: '🟡', iccRanking: 7, matchesPlayed: 9, wins: 4),
    const Team(id: 'KKR', name: 'Kolkata Knight Riders', shortCode: 'KKR', flagEmoji: '🟣', iccRanking: 8, matchesPlayed: 8, wins: 2),
    const Team(id: 'MI', name: 'Mumbai Indians', shortCode: 'MI', flagEmoji: '🔵', iccRanking: 9, matchesPlayed: 9, wins: 2),
    const Team(id: 'LSG', name: 'Lucknow Super Giants', shortCode: 'LSG', flagEmoji: '🟡', iccRanking: 10, matchesPlayed: 8, wins: 2),
  ];

  static Team _t(String id) => teams.firstWhere((t) => t.id == id);

  static final List<Player> players = [
    Player(id: 'p1', name: 'Abhishek Sharma', teamId: 'SRH', role: PlayerRole.batsman, battingRank: 1, bowlingRank: 0, battingStats: const BattingStats(matches: 9, innings: 9, runs: 380, highScore: 75, average: 42.2, strikeRate: 212.29, fifties: 3, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p2', name: 'KL Rahul', teamId: 'DC', role: PlayerRole.wicketKeeper, battingRank: 2, bowlingRank: 0, battingStats: const BattingStats(matches: 9, innings: 9, runs: 358, highScore: 84, average: 39.8, strikeRate: 145.5, fifties: 3, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p3', name: 'Vaibhav Suryavanshi', teamId: 'RR', role: PlayerRole.batsman, battingRank: 3, bowlingRank: 0, battingStats: const BattingStats(matches: 10, innings: 10, runs: 357, highScore: 102, average: 35.7, strikeRate: 234.86, fifties: 1, hundreds: 1), bowlingStats: const BowlingStats(matches: 10, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p4', name: 'Virat Kohli', teamId: 'RCB', role: PlayerRole.batsman, battingRank: 4, bowlingRank: 0, battingStats: const BattingStats(matches: 9, innings: 9, runs: 351, highScore: 92, average: 58.50, strikeRate: 156.4, fifties: 4, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p5', name: 'Heinrich Klaasen', teamId: 'SRH', role: PlayerRole.wicketKeeper, battingRank: 5, bowlingRank: 0, battingStats: const BattingStats(matches: 9, innings: 9, runs: 349, highScore: 78, average: 38.8, strikeRate: 178.2, fifties: 3, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p6', name: 'Ruturaj Gaikwad', teamId: 'CSK', role: PlayerRole.batsman, battingRank: 6, bowlingRank: 0, battingStats: const BattingStats(matches: 9, innings: 9, runs: 298, highScore: 67, average: 33.1, strikeRate: 148.3, fifties: 2, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p7', name: 'Shreyas Iyer', teamId: 'PBKS', role: PlayerRole.batsman, battingRank: 7, bowlingRank: 0, battingStats: const BattingStats(matches: 8, innings: 8, runs: 279, highScore: 68, average: 69.75, strikeRate: 158.5, fifties: 3, hundreds: 0), bowlingStats: const BowlingStats(matches: 8, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p8', name: 'Sanju Samson', teamId: 'CSK', role: PlayerRole.wicketKeeper, battingRank: 8, bowlingRank: 0, battingStats: const BattingStats(matches: 9, innings: 8, runs: 265, highScore: 54, average: 38.0, strikeRate: 142.8, fifties: 1, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p9', name: 'Shubman Gill', teamId: 'GT', role: PlayerRole.batsman, battingRank: 9, bowlingRank: 0, battingStats: const BattingStats(matches: 9, innings: 9, runs: 312, highScore: 71, average: 34.7, strikeRate: 152.0, fifties: 2, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p10', name: 'Sai Sudharsan', teamId: 'GT', role: PlayerRole.batsman, battingRank: 10, bowlingRank: 0, battingStats: const BattingStats(matches: 9, innings: 9, runs: 290, highScore: 85, average: 32.2, strikeRate: 141.5, fifties: 2, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p11', name: 'Rohit Sharma', teamId: 'MI', role: PlayerRole.batsman, battingRank: 11, bowlingRank: 0, battingStats: const BattingStats(matches: 9, innings: 9, runs: 245, highScore: 56, average: 27.2, strikeRate: 138.2, fifties: 1, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p12', name: 'Sunil Narine', teamId: 'KKR', role: PlayerRole.allRounder, battingRank: 12, bowlingRank: 3, battingStats: const BattingStats(matches: 8, innings: 8, runs: 198, highScore: 48, average: 24.8, strikeRate: 165.0, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 8, wickets: 9, economy: 6.66, average: 24.8, bestFigures: '3/18')),
    Player(id: 'p13', name: 'Hardik Pandya', teamId: 'MI', role: PlayerRole.allRounder, battingRank: 13, bowlingRank: 6, battingStats: const BattingStats(matches: 9, innings: 8, runs: 195, highScore: 45, average: 27.8, strikeRate: 162.5, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 8, economy: 8.5, average: 28.5, bestFigures: '3/24')),
    Player(id: 'p14', name: 'Rishabh Pant', teamId: 'LSG', role: PlayerRole.wicketKeeper, battingRank: 14, bowlingRank: 0, battingStats: const BattingStats(matches: 8, innings: 8, runs: 220, highScore: 62, average: 27.5, strikeRate: 155.0, fifties: 1, hundreds: 0), bowlingStats: const BowlingStats(matches: 8, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p15', name: 'Riyan Parag', teamId: 'RR', role: PlayerRole.allRounder, battingRank: 15, bowlingRank: 8, battingStats: const BattingStats(matches: 10, innings: 9, runs: 215, highScore: 42, average: 26.9, strikeRate: 152.0, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 10, wickets: 4, economy: 8.2, average: 32.0, bestFigures: '2/15')),
    Player(id: 'p16', name: 'Bhuvneshwar Kumar', teamId: 'RCB', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 1, battingStats: const BattingStats(matches: 9, innings: 1, runs: 2, highScore: 2, average: 2.0, strikeRate: 66.7, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 14, economy: 7.2, average: 16.85, bestFigures: '4/22')),
    Player(id: 'p17', name: 'Anshul Kamboj', teamId: 'CSK', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 1, battingStats: const BattingStats(matches: 9, innings: 2, runs: 5, highScore: 4, average: 2.5, strikeRate: 71.4, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 14, economy: 7.8, average: 18.2, bestFigures: '3/19')),
    Player(id: 'p18', name: 'Eshan Malinga', teamId: 'SRH', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 1, battingStats: const BattingStats(matches: 9, innings: 1, runs: 0, highScore: 0, average: 0.0, strikeRate: 0.0, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 14, economy: 7.5, average: 17.5, bestFigures: '4/28')),
    Player(id: 'p19', name: 'Jofra Archer', teamId: 'RR', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 4, battingStats: const BattingStats(matches: 10, innings: 2, runs: 8, highScore: 6, average: 4.0, strikeRate: 88.9, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 10, wickets: 13, economy: 7.9, average: 20.5, bestFigures: '3/20')),
    Player(id: 'p20', name: 'Prince Yadav', teamId: 'LSG', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 4, battingStats: const BattingStats(matches: 8, innings: 1, runs: 0, highScore: 0, average: 0.0, strikeRate: 0.0, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 8, wickets: 13, economy: 8.1, average: 19.2, bestFigures: '4/18')),
    Player(id: 'p21', name: 'Kagiso Rabada', teamId: 'GT', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 4, battingStats: const BattingStats(matches: 9, innings: 1, runs: 3, highScore: 3, average: 3.0, strikeRate: 75.0, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 13, economy: 7.6, average: 18.8, bestFigures: '3/16')),
    Player(id: 'p22', name: 'Arshdeep Singh', teamId: 'PBKS', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 6, battingStats: const BattingStats(matches: 8, innings: 1, runs: 0, highScore: 0, average: 0.0, strikeRate: 0.0, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 8, wickets: 11, economy: 7.4, average: 20.1, bestFigures: '3/22')),
    Player(id: 'p23', name: 'Jasprit Bumrah', teamId: 'MI', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 7, battingStats: const BattingStats(matches: 9, innings: 0, runs: 0, highScore: 0, average: 0.0, strikeRate: 0.0, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 11, economy: 6.8, average: 19.5, bestFigures: '3/20')),
    Player(id: 'p24', name: 'Rashid Khan', teamId: 'GT', role: PlayerRole.allRounder, battingRank: 16, bowlingRank: 5, battingStats: const BattingStats(matches: 9, innings: 7, runs: 142, highScore: 38, average: 23.7, strikeRate: 168.0, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 9, wickets: 10, economy: 7.0, average: 21.5, bestFigures: '3/22')),
    Player(id: 'p25', name: 'Ravindra Jadeja', teamId: 'RR', role: PlayerRole.allRounder, battingRank: 17, bowlingRank: 8, battingStats: const BattingStats(matches: 10, innings: 8, runs: 175, highScore: 40, average: 25.0, strikeRate: 148.3, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 10, wickets: 8, economy: 7.0, average: 24.5, bestFigures: '2/18')),
  ];

  static final now = DateTime.now();

  static List<Match> getMatches() {
    return [
      Match(
        id: 'm1',
        homeTeam: Team(id: 'PBKS', name: 'Punjab Kings', shortCode: 'PBKS', flagEmoji: '🔴', iccRanking: 1, matchesPlayed: 8, wins: 6),
        awayTeam: Team(id: 'GT', name: 'Gujarat Titans', shortCode: 'GT', flagEmoji: '🔵', iccRanking: 5, matchesPlayed: 9, wins: 5),
        venue: 'Narendra Modi Stadium, Ahmedabad',
        dateTime: DateTime(2026, 5, 3, 19, 30),
        status: MatchStatus.live,
        format: MatchFormat.t20,
        innings1: InningsData(
          inningsNumber: 1,
          battingTeamId: 'GT',
          runs: 148,
          wickets: 5,
          overs: 14.3,
          isCompleted: false,
          batsmen: [
            const BatsmanScore(name: 'S. Sudharsan', runs: 62, balls: 41, fours: 7, sixes: 2, isStriker: false),
            const BatsmanScore(name: 'R. Tewatia', runs: 28, balls: 14, fours: 2, sixes: 2, isStriker: true),
          ],
          bowlers: [
            const BowlerScore(name: 'Arshdeep Singh', overs: 3.0, maidens: 0, runsConceded: 24, wickets: 2),
          ],
          recentBalls: ['1', '4', '0', '6', '2', '1'],
          striker: const BatsmanScore(name: 'R. Tewatia', runs: 28, balls: 14, fours: 2, sixes: 2, isStriker: true),
          nonStriker: const BatsmanScore(name: 'S. Sudharsan', runs: 62, balls: 41, fours: 7, sixes: 2, isStriker: false),
          currentBowler: const BowlerScore(name: 'Arshdeep Singh', overs: 3.3, maidens: 0, runsConceded: 28, wickets: 2),
        ),
        innings2: null,
      ),
      Match(
        id: 'm2',
        homeTeam: Team(id: 'SRH', name: 'Sunrisers Hyderabad', shortCode: 'SRH', flagEmoji: '🟠', iccRanking: 3, matchesPlayed: 9, wins: 6),
        awayTeam: Team(id: 'KKR', name: 'Kolkata Knight Riders', shortCode: 'KKR', flagEmoji: '🟣', iccRanking: 8, matchesPlayed: 8, wins: 2),
        venue: 'Rajiv Gandhi International Stadium, Hyderabad',
        dateTime: DateTime(2026, 5, 3, 15, 30),
        status: MatchStatus.completed,
        format: MatchFormat.t20,
        result: 'Sunrisers Hyderabad won by 35 runs',
        innings1: InningsData(
          inningsNumber: 1,
          battingTeamId: 'SRH',
          runs: 218,
          wickets: 4,
          overs: 20.0,
          isCompleted: true,
          batsmen: [
            const BatsmanScore(name: 'A. Sharma', runs: 82, balls: 38, fours: 8, sixes: 6, isStriker: false),
            const BatsmanScore(name: 'H. Klaasen', runs: 64, balls: 32, fours: 4, sixes: 5, isStriker: false),
          ],
          bowlers: [],
          recentBalls: ['4', '6', '1', '0', 'W', '4'],
        ),
        innings2: InningsData(
          inningsNumber: 2,
          battingTeamId: 'KKR',
          runs: 183,
          wickets: 8,
          overs: 20.0,
          isCompleted: true,
          batsmen: [
            const BatsmanScore(name: 'S. Narine', runs: 45, balls: 24, fours: 5, sixes: 3, isStriker: false),
            const BatsmanScore(name: 'R. Powell', runs: 38, balls: 22, fours: 2, sixes: 3, isStriker: false),
          ],
          bowlers: [],
          recentBalls: ['1', '0', '4', 'W', '2', '1'],
        ),
      ),
      Match(
        id: 'm3',
        homeTeam: Team(id: 'CSK', name: 'Chennai Super Kings', shortCode: 'CSK', flagEmoji: '🟡', iccRanking: 7, matchesPlayed: 9, wins: 4),
        awayTeam: Team(id: 'MI', name: 'Mumbai Indians', shortCode: 'MI', flagEmoji: '🔵', iccRanking: 9, matchesPlayed: 9, wins: 2),
        venue: 'MA Chidambaram Stadium, Chennai',
        dateTime: DateTime(2026, 5, 2, 19, 30),
        status: MatchStatus.completed,
        format: MatchFormat.t20,
        result: 'Chennai Super Kings won by 8 wickets',
        innings1: InningsData(
          inningsNumber: 1,
          battingTeamId: 'MI',
          runs: 159,
          wickets: 7,
          overs: 20.0,
          isCompleted: true,
          batsmen: [
            const BatsmanScore(name: 'R. Sharma', runs: 57, balls: 37, fours: 4, sixes: 3, isStriker: false),
            const BatsmanScore(name: 'S. Yadav', runs: 21, balls: 12, fours: 3, sixes: 1, isStriker: false),
          ],
          bowlers: [
            const BowlerScore(name: 'A. Kamboj', overs: 4.0, maidens: 0, runsConceded: 32, wickets: 2),
          ],
          recentBalls: ['1', '0', 'W', '4', '2', '1'],
        ),
        innings2: InningsData(
          inningsNumber: 2,
          battingTeamId: 'CSK',
          runs: 160,
          wickets: 2,
          overs: 18.1,
          isCompleted: true,
          batsmen: [
            const BatsmanScore(name: 'R. Gaikwad', runs: 67, balls: 48, fours: 5, sixes: 2, isStriker: true),
            const BatsmanScore(name: 'S. Samson', runs: 54, balls: 40, fours: 4, sixes: 3, isStriker: true),
          ],
          bowlers: [
            const BowlerScore(name: 'J. Bumrah', overs: 4.0, maidens: 0, runsConceded: 28, wickets: 1),
          ],
          recentBalls: ['4', '1', '2', '0', '1', '4'],
        ),
      ),
      Match(
        id: 'm4',
        homeTeam: Team(id: 'RR', name: 'Rajasthan Royals', shortCode: 'RR', flagEmoji: '🩷', iccRanking: 4, matchesPlayed: 10, wins: 6),
        awayTeam: Team(id: 'DC', name: 'Delhi Capitals', shortCode: 'DC', flagEmoji: '🔵', iccRanking: 6, matchesPlayed: 9, wins: 4),
        venue: 'Sawai Mansingh Stadium, Jaipur',
        dateTime: DateTime(2026, 5, 1, 19, 30),
        status: MatchStatus.completed,
        format: MatchFormat.t20,
        result: 'Delhi Capitals won by 7 wickets',
        innings1: InningsData(
          inningsNumber: 1,
          battingTeamId: 'RR',
          runs: 225,
          wickets: 6,
          overs: 20.0,
          isCompleted: true,
          batsmen: [
            const BatsmanScore(name: 'V. Suryavanshi', runs: 88, balls: 34, fours: 6, sixes: 8, isStriker: false),
            const BatsmanScore(name: 'R. Parag', runs: 42, balls: 24, fours: 3, sixes: 2, isStriker: false),
          ],
          bowlers: [],
          recentBalls: ['6', '4', '1', 'W', '4', '2'],
        ),
        innings2: InningsData(
          inningsNumber: 2,
          battingTeamId: 'DC',
          runs: 226,
          wickets: 3,
          overs: 20.0,
          isCompleted: true,
          batsmen: [
            const BatsmanScore(name: 'KL Rahul', runs: 84, balls: 48, fours: 8, sixes: 4, isStriker: false),
            const BatsmanScore(name: 'T. Stubbs', runs: 56, balls: 28, fours: 4, sixes: 3, isStriker: false),
          ],
          bowlers: [],
          recentBalls: ['4', '1', '6', '2', '1', '4'],
        ),
      ),
      Match(
        id: 'm5',
        homeTeam: Team(id: 'RCB', name: 'Royal Challengers Bengaluru', shortCode: 'RCB', flagEmoji: '🔴', iccRanking: 2, matchesPlayed: 9, wins: 6),
        awayTeam: Team(id: 'GT', name: 'Gujarat Titans', shortCode: 'GT', flagEmoji: '🔵', iccRanking: 5, matchesPlayed: 9, wins: 5),
        venue: 'M. Chinnaswamy Stadium, Bengaluru',
        dateTime: DateTime(2026, 4, 30, 19, 30),
        status: MatchStatus.completed,
        format: MatchFormat.t20,
        result: 'Gujarat Titans won by 4 wickets',
        innings1: InningsData(
          inningsNumber: 1,
          battingTeamId: 'RCB',
          runs: 155,
          wickets: 10,
          overs: 19.2,
          isCompleted: true,
          batsmen: [
            const BatsmanScore(name: 'V. Kohli', runs: 52, balls: 38, fours: 5, sixes: 2, isStriker: false),
            const BatsmanScore(name: 'R. Patidar', runs: 34, balls: 22, fours: 3, sixes: 2, isStriker: false),
          ],
          bowlers: [],
          recentBalls: ['0', 'W', '1', '0', 'W', '0'],
        ),
        innings2: InningsData(
          inningsNumber: 2,
          battingTeamId: 'GT',
          runs: 158,
          wickets: 6,
          overs: 15.5,
          isCompleted: true,
          batsmen: [
            const BatsmanScore(name: 'S. Gill', runs: 48, balls: 32, fours: 6, sixes: 1, isStriker: false),
            const BatsmanScore(name: 'S. Sudharsan', runs: 42, balls: 28, fours: 4, sixes: 2, isStriker: false),
          ],
          bowlers: [],
          recentBalls: ['1', '4', '0', '2', '1', '4'],
        ),
      ),
      Match(
        id: 'm6',
        homeTeam: Team(id: 'DC', name: 'Delhi Capitals', shortCode: 'DC', flagEmoji: '🔵', iccRanking: 6, matchesPlayed: 9, wins: 4),
        awayTeam: Team(id: 'RCB', name: 'Royal Challengers Bengaluru', shortCode: 'RCB', flagEmoji: '🔴', iccRanking: 2, matchesPlayed: 9, wins: 6),
        venue: 'Arun Jaitley Stadium, Delhi',
        dateTime: DateTime(2026, 4, 28, 19, 30),
        status: MatchStatus.completed,
        format: MatchFormat.t20,
        result: 'Royal Challengers Bengaluru won by 9 wickets',
        innings1: InningsData(
          inningsNumber: 1,
          battingTeamId: 'DC',
          runs: 75,
          wickets: 10,
          overs: 16.3,
          isCompleted: true,
          batsmen: [
            const BatsmanScore(name: 'KL Rahul', runs: 22, balls: 18, fours: 3, sixes: 0, isStriker: false),
            const BatsmanScore(name: 'T. Stubbs', runs: 15, balls: 14, fours: 1, sixes: 1, isStriker: false),
          ],
          bowlers: [],
          recentBalls: ['0', 'W', '0', 'W', '0', 'W'],
        ),
        innings2: InningsData(
          inningsNumber: 2,
          battingTeamId: 'RCB',
          runs: 77,
          wickets: 1,
          overs: 6.3,
          isCompleted: true,
          batsmen: [
            const BatsmanScore(name: 'V. Kohli', runs: 42, balls: 18, fours: 4, sixes: 3, isStriker: false),
            const BatsmanScore(name: 'P. Salt', runs: 32, balls: 14, fours: 3, sixes: 2, isStriker: false),
          ],
          bowlers: [],
          recentBalls: ['6', '4', '1', '4', '0', '4'],
        ),
      ),
      Match(
        id: 'm7',
        homeTeam: Team(id: 'MI', name: 'Mumbai Indians', shortCode: 'MI', flagEmoji: '🔵', iccRanking: 9, matchesPlayed: 9, wins: 2),
        awayTeam: Team(id: 'LSG', name: 'Lucknow Super Giants', shortCode: 'LSG', flagEmoji: '🟡', iccRanking: 10, matchesPlayed: 8, wins: 2),
        venue: 'Wankhede Stadium, Mumbai',
        dateTime: DateTime(2026, 5, 4, 19, 30),
        status: MatchStatus.upcoming,
        format: MatchFormat.t20,
      ),
      Match(
        id: 'm8',
        homeTeam: Team(id: 'DC', name: 'Delhi Capitals', shortCode: 'DC', flagEmoji: '🔵', iccRanking: 6, matchesPlayed: 9, wins: 4),
        awayTeam: Team(id: 'CSK', name: 'Chennai Super Kings', shortCode: 'CSK', flagEmoji: '🟡', iccRanking: 7, matchesPlayed: 9, wins: 4),
        venue: 'Arun Jaitley Stadium, Delhi',
        dateTime: DateTime(2026, 5, 5, 19, 30),
        status: MatchStatus.upcoming,
        format: MatchFormat.t20,
      ),
      Match(
        id: 'm9',
        homeTeam: Team(id: 'SRH', name: 'Sunrisers Hyderabad', shortCode: 'SRH', flagEmoji: '🟠', iccRanking: 3, matchesPlayed: 9, wins: 6),
        awayTeam: Team(id: 'PBKS', name: 'Punjab Kings', shortCode: 'PBKS', flagEmoji: '🔴', iccRanking: 1, matchesPlayed: 8, wins: 6),
        venue: 'Rajiv Gandhi International Stadium, Hyderabad',
        dateTime: DateTime(2026, 5, 5, 19, 30),
        status: MatchStatus.upcoming,
        format: MatchFormat.t20,
      ),
      Match(
        id: 'm10',
        homeTeam: Team(id: 'LSG', name: 'Lucknow Super Giants', shortCode: 'LSG', flagEmoji: '🟡', iccRanking: 10, matchesPlayed: 8, wins: 2),
        awayTeam: Team(id: 'RCB', name: 'Royal Challengers Bengaluru', shortCode: 'RCB', flagEmoji: '🔴', iccRanking: 2, matchesPlayed: 9, wins: 6),
        venue: 'BRSABV Ekana Cricket Stadium, Lucknow',
        dateTime: DateTime(2026, 5, 7, 19, 30),
        status: MatchStatus.upcoming,
        format: MatchFormat.t20,
      ),
      Match(
        id: 'm11',
        homeTeam: Team(id: 'DC', name: 'Delhi Capitals', shortCode: 'DC', flagEmoji: '🔵', iccRanking: 6, matchesPlayed: 9, wins: 4),
        awayTeam: Team(id: 'KKR', name: 'Kolkata Knight Riders', shortCode: 'KKR', flagEmoji: '🟣', iccRanking: 8, matchesPlayed: 8, wins: 2),
        venue: 'Arun Jaitley Stadium, Delhi',
        dateTime: DateTime(2026, 5, 8, 19, 30),
        status: MatchStatus.upcoming,
        format: MatchFormat.t20,
      ),
      Match(
        id: 'm12',
        homeTeam: Team(id: 'RR', name: 'Rajasthan Royals', shortCode: 'RR', flagEmoji: '🩷', iccRanking: 4, matchesPlayed: 10, wins: 6),
        awayTeam: Team(id: 'GT', name: 'Gujarat Titans', shortCode: 'GT', flagEmoji: '🔵', iccRanking: 5, matchesPlayed: 9, wins: 5),
        venue: 'Sawai Mansingh Stadium, Jaipur',
        dateTime: DateTime(2026, 5, 9, 19, 30),
        status: MatchStatus.upcoming,
        format: MatchFormat.t20,
      ),
      Match(
        id: 'm13',
        homeTeam: Team(id: 'CSK', name: 'Chennai Super Kings', shortCode: 'CSK', flagEmoji: '🟡', iccRanking: 7, matchesPlayed: 9, wins: 4),
        awayTeam: Team(id: 'LSG', name: 'Lucknow Super Giants', shortCode: 'LSG', flagEmoji: '🟡', iccRanking: 10, matchesPlayed: 8, wins: 2),
        venue: 'MA Chidambaram Stadium, Chennai',
        dateTime: DateTime(2026, 5, 10, 15, 30),
        status: MatchStatus.upcoming,
        format: MatchFormat.t20,
      ),
      Match(
        id: 'm14',
        homeTeam: Team(id: 'RCB', name: 'Royal Challengers Bengaluru', shortCode: 'RCB', flagEmoji: '🔴', iccRanking: 2, matchesPlayed: 9, wins: 6),
        awayTeam: Team(id: 'MI', name: 'Mumbai Indians', shortCode: 'MI', flagEmoji: '🔵', iccRanking: 9, matchesPlayed: 9, wins: 2),
        venue: 'Shaheed Veer Narayan Singh Stadium, Raipur',
        dateTime: DateTime(2026, 5, 10, 19, 30),
        status: MatchStatus.upcoming,
        format: MatchFormat.t20,
      ),
      Match(
        id: 'm15',
        homeTeam: Team(id: 'MI', name: 'Mumbai Indians', shortCode: 'MI', flagEmoji: '🔵', iccRanking: 9, matchesPlayed: 9, wins: 2),
        awayTeam: Team(id: 'SRH', name: 'Sunrisers Hyderabad', shortCode: 'SRH', flagEmoji: '🟠', iccRanking: 3, matchesPlayed: 9, wins: 6),
        venue: 'Wankhede Stadium, Mumbai',
        dateTime: DateTime(2026, 4, 26, 19, 30),
        status: MatchStatus.completed,
        format: MatchFormat.t20,
        result: 'Sunrisers Hyderabad won by 6 wickets',
        innings1: InningsData(
          inningsNumber: 1,
          battingTeamId: 'MI',
          runs: 243,
          wickets: 5,
          overs: 20.0,
          isCompleted: true,
          batsmen: [
            const BatsmanScore(name: 'R. Sharma', runs: 68, balls: 32, fours: 5, sixes: 6, isStriker: false),
            const BatsmanScore(name: 'H. Pandya', runs: 45, balls: 22, fours: 3, sixes: 4, isStriker: false),
          ],
          bowlers: [],
          recentBalls: ['6', '4', '1', '4', '2', '6'],
        ),
        innings2: InningsData(
          inningsNumber: 2,
          battingTeamId: 'SRH',
          runs: 249,
          wickets: 4,
          overs: 18.4,
          isCompleted: true,
          batsmen: [
            const BatsmanScore(name: 'A. Sharma', runs: 92, balls: 42, fours: 7, sixes: 8, isStriker: false),
            const BatsmanScore(name: 'H. Klaasen', runs: 78, balls: 35, fours: 5, sixes: 6, isStriker: false),
          ],
          bowlers: [],
          recentBalls: ['4', '6', '1', '4', '2', '4'],
        ),
      ),
    ];
  }

  static Stream<Map<String, InningsData>> liveScoreStream() {
    return Stream.periodic(const Duration(seconds: 5), (_) {
      final outcomes = ['0', '1', '1', '2', '4', '4', '6', 'W', '0', '1', '2', '0'];
      final Map<String, InningsData> updates = {};
      for (final m in getMatches().where((m) => m.status == MatchStatus.live)) {
        final inn = m.activeInnings;
        if (inn == null || inn.isCompleted) continue;
        final ball = outcomes[_rand.nextInt(outcomes.length)];
        int addRuns = 0;
        int addWickets = 0;
        if (ball == 'W') {
          addWickets = 1;
        } else {
          addRuns = int.parse(ball);
        }
        final newBalls = [...inn.recentBalls, ball];
        if (newBalls.length > 6) newBalls.removeAt(0);
        double newOvers = inn.overs;
        final currentBall = ((newOvers * 10) % 10).round();
        if (currentBall >= 5) {
          newOvers = (newOvers.floor() + 1).toDouble();
        } else {
          newOvers = newOvers.floor() + (currentBall + 1) / 10;
        }
        updates[m.id] = inn.copyWith(
          runs: inn.runs + addRuns,
          wickets: inn.wickets + addWickets,
          overs: newOvers,
          recentBalls: newBalls,
        );
      }
      return updates;
    });
  }
}
