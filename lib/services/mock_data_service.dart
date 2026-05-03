import 'dart:async';
import 'dart:math';
import '../models/match.dart';
import '../models/player.dart';
import '../models/score.dart';

class MockDataService {
  static final _rand = Random();

  static final List<Team> teams = [
    const Team(id: 'IND', name: 'India', shortCode: 'IND', flagEmoji: '🇮🇳', iccRanking: 1, matchesPlayed: 48, wins: 38),
    const Team(id: 'AUS', name: 'Australia', shortCode: 'AUS', flagEmoji: '🇦🇺', iccRanking: 2, matchesPlayed: 45, wins: 34),
    const Team(id: 'ENG', name: 'England', shortCode: 'ENG', flagEmoji: '🏴󠁧󠁢󠁥󠁮󠁧󠁿', iccRanking: 3, matchesPlayed: 42, wins: 30),
    const Team(id: 'PAK', name: 'Pakistan', shortCode: 'PAK', flagEmoji: '🇵🇰', iccRanking: 4, matchesPlayed: 40, wins: 25),
    const Team(id: 'NZ', name: 'New Zealand', shortCode: 'NZ', flagEmoji: '🇳🇿', iccRanking: 5, matchesPlayed: 38, wins: 24),
  ];

  static Team _t(String id) => teams.firstWhere((t) => t.id == id);

  static final List<Player> players = [
    Player(id: 'p1', name: 'Virat Kohli', teamId: 'IND', role: PlayerRole.batsman, battingRank: 1, bowlingRank: 0, battingStats: const BattingStats(matches: 280, innings: 270, runs: 13200, highScore: 183, average: 57.8, strikeRate: 93.5, fifties: 72, hundreds: 50), bowlingStats: const BowlingStats(matches: 280, wickets: 4, economy: 5.2, average: 62.0, bestFigures: '1/15')),
    Player(id: 'p2', name: 'Rohit Sharma', teamId: 'IND', role: PlayerRole.batsman, battingRank: 3, bowlingRank: 0, battingStats: const BattingStats(matches: 260, innings: 250, runs: 10800, highScore: 264, average: 49.2, strikeRate: 89.2, fifties: 48, hundreds: 32), bowlingStats: const BowlingStats(matches: 260, wickets: 8, economy: 5.8, average: 58.0, bestFigures: '2/32')),
    Player(id: 'p3', name: 'Jasprit Bumrah', teamId: 'IND', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 1, battingStats: const BattingStats(matches: 80, innings: 20, runs: 50, highScore: 10, average: 3.2, strikeRate: 40.0, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 80, wickets: 145, economy: 4.2, average: 21.8, bestFigures: '6/19')),
    Player(id: 'p4', name: 'Steve Smith', teamId: 'AUS', role: PlayerRole.batsman, battingRank: 2, bowlingRank: 0, battingStats: const BattingStats(matches: 170, innings: 165, runs: 9200, highScore: 164, average: 58.1, strikeRate: 87.3, fifties: 41, hundreds: 30), bowlingStats: const BowlingStats(matches: 170, wickets: 3, economy: 5.5, average: 70.0, bestFigures: '1/10')),
    Player(id: 'p5', name: 'Pat Cummins', teamId: 'AUS', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 2, battingStats: const BattingStats(matches: 75, innings: 40, runs: 680, highScore: 56, average: 18.4, strikeRate: 72.0, fifties: 1, hundreds: 0), bowlingStats: const BowlingStats(matches: 75, wickets: 162, economy: 4.8, average: 23.5, bestFigures: '5/38')),
    Player(id: 'p6', name: 'Joe Root', teamId: 'ENG', role: PlayerRole.batsman, battingRank: 4, bowlingRank: 0, battingStats: const BattingStats(matches: 160, innings: 155, runs: 8700, highScore: 180, average: 51.2, strikeRate: 85.0, fifties: 45, hundreds: 28), bowlingStats: const BowlingStats(matches: 160, wickets: 18, economy: 4.9, average: 42.0, bestFigures: '2/22')),
    Player(id: 'p7', name: 'Ben Stokes', teamId: 'ENG', role: PlayerRole.allRounder, battingRank: 8, bowlingRank: 6, battingStats: const BattingStats(matches: 110, innings: 105, runs: 4500, highScore: 135, average: 38.5, strikeRate: 96.2, fifties: 26, hundreds: 12), bowlingStats: const BowlingStats(matches: 110, wickets: 80, economy: 5.6, average: 34.2, bestFigures: '4/40')),
    Player(id: 'p8', name: 'Babar Azam', teamId: 'PAK', role: PlayerRole.batsman, battingRank: 5, bowlingRank: 0, battingStats: const BattingStats(matches: 120, innings: 118, runs: 5800, highScore: 158, average: 53.2, strikeRate: 88.9, fifties: 32, hundreds: 19), bowlingStats: const BowlingStats(matches: 120, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p9', name: 'Shaheen Afridi', teamId: 'PAK', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 3, battingStats: const BattingStats(matches: 60, innings: 15, runs: 45, highScore: 8, average: 3.5, strikeRate: 55.0, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 60, wickets: 115, economy: 4.9, average: 24.2, bestFigures: '6/35')),
    Player(id: 'p10', name: 'Kane Williamson', teamId: 'NZ', role: PlayerRole.batsman, battingRank: 6, bowlingRank: 0, battingStats: const BattingStats(matches: 170, innings: 165, runs: 8100, highScore: 200, average: 54.5, strikeRate: 82.1, fifties: 42, hundreds: 26), bowlingStats: const BowlingStats(matches: 170, wickets: 12, economy: 5.0, average: 45.0, bestFigures: '2/18')),
    Player(id: 'p11', name: 'Trent Boult', teamId: 'NZ', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 4, battingStats: const BattingStats(matches: 95, innings: 30, runs: 160, highScore: 21, average: 6.2, strikeRate: 62.0, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 95, wickets: 185, economy: 4.5, average: 22.6, bestFigures: '5/21')),
    Player(id: 'p12', name: 'KL Rahul', teamId: 'IND', role: PlayerRole.wicketKeeper, battingRank: 7, bowlingRank: 0, battingStats: const BattingStats(matches: 75, innings: 72, runs: 3200, highScore: 132, average: 45.8, strikeRate: 86.0, fifties: 18, hundreds: 8), bowlingStats: const BowlingStats(matches: 75, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p13', name: 'Mitchell Starc', teamId: 'AUS', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 5, battingStats: const BattingStats(matches: 80, innings: 35, runs: 520, highScore: 52, average: 16.2, strikeRate: 88.0, fifties: 1, hundreds: 0), bowlingStats: const BowlingStats(matches: 80, wickets: 170, economy: 5.0, average: 25.1, bestFigures: '6/28')),
    Player(id: 'p14', name: 'Ravindra Jadeja', teamId: 'IND', role: PlayerRole.allRounder, battingRank: 10, bowlingRank: 7, battingStats: const BattingStats(matches: 190, innings: 120, runs: 2800, highScore: 87, average: 32.5, strikeRate: 85.4, fifties: 14, hundreds: 0), bowlingStats: const BowlingStats(matches: 190, wickets: 220, economy: 4.8, average: 29.5, bestFigures: '5/36')),
    Player(id: 'p15', name: 'Devon Conway', teamId: 'NZ', role: PlayerRole.batsman, battingRank: 9, bowlingRank: 0, battingStats: const BattingStats(matches: 40, innings: 38, runs: 1800, highScore: 122, average: 48.6, strikeRate: 81.5, fifties: 12, hundreds: 5), bowlingStats: const BowlingStats(matches: 40, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p16', name: 'Marnus Labuschagne', teamId: 'AUS', role: PlayerRole.batsman, battingRank: 11, bowlingRank: 0, battingStats: const BattingStats(matches: 55, innings: 52, runs: 2600, highScore: 163, average: 50.2, strikeRate: 78.8, fifties: 15, hundreds: 8), bowlingStats: const BowlingStats(matches: 55, wickets: 5, economy: 5.1, average: 48.0, bestFigures: '2/11')),
    Player(id: 'p17', name: 'Mark Wood', teamId: 'ENG', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 8, battingStats: const BattingStats(matches: 30, innings: 10, runs: 55, highScore: 15, average: 6.1, strikeRate: 75.0, fifties: 0, hundreds: 0), bowlingStats: const BowlingStats(matches: 30, wickets: 55, economy: 5.5, average: 28.8, bestFigures: '4/33')),
    Player(id: 'p18', name: 'Mohammad Rizwan', teamId: 'PAK', role: PlayerRole.wicketKeeper, battingRank: 12, bowlingRank: 0, battingStats: const BattingStats(matches: 80, innings: 78, runs: 3400, highScore: 115, average: 44.7, strikeRate: 88.5, fifties: 22, hundreds: 5), bowlingStats: const BowlingStats(matches: 80, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p19', name: 'Shubman Gill', teamId: 'IND', role: PlayerRole.batsman, battingRank: 13, bowlingRank: 0, battingStats: const BattingStats(matches: 40, innings: 38, runs: 1950, highScore: 126, average: 52.7, strikeRate: 91.0, fifties: 10, hundreds: 6), bowlingStats: const BowlingStats(matches: 40, wickets: 0, economy: 0, average: 0, bestFigures: '-')),
    Player(id: 'p20', name: 'Tim Southee', teamId: 'NZ', role: PlayerRole.bowler, battingRank: 0, bowlingRank: 9, battingStats: const BattingStats(matches: 100, innings: 50, runs: 980, highScore: 77, average: 22.0, strikeRate: 92.0, fifties: 2, hundreds: 0), bowlingStats: const BowlingStats(matches: 100, wickets: 195, economy: 5.1, average: 26.3, bestFigures: '7/34')),
  ];

  static final now = DateTime.now();

  static List<Match> getMatches() {
    return [
      Match(id: 'm1', homeTeam: _t('IND'), awayTeam: _t('AUS'), venue: 'Wankhede Stadium, Mumbai', dateTime: now, status: MatchStatus.live, format: MatchFormat.t20,
        innings1: InningsData(inningsNumber: 1, battingTeamId: 'IND', runs: 185, wickets: 4, overs: 20.0, isCompleted: true, batsmen: [], bowlers: [], recentBalls: ['1', '4', '0', 'W', '6', '2']),
        innings2: InningsData(inningsNumber: 2, battingTeamId: 'AUS', runs: 142, wickets: 3, overs: 16.2, isCompleted: false,
          batsmen: [const BatsmanScore(name: 'S. Smith', runs: 68, balls: 42, fours: 6, sixes: 3, isStriker: true), const BatsmanScore(name: 'G. Maxwell', runs: 31, balls: 18, fours: 2, sixes: 2, isStriker: false)],
          bowlers: [const BowlerScore(name: 'J. Bumrah', overs: 4, maidens: 1, runsConceded: 28, wickets: 2)],
          recentBalls: ['1', '4', '0', '6', '2', '1'],
          striker: const BatsmanScore(name: 'S. Smith', runs: 68, balls: 42, fours: 6, sixes: 3, isStriker: true),
          nonStriker: const BatsmanScore(name: 'G. Maxwell', runs: 31, balls: 18, fours: 2, sixes: 2, isStriker: false),
          currentBowler: const BowlerScore(name: 'J. Bumrah', overs: 3.2, maidens: 1, runsConceded: 28, wickets: 2))),
      Match(id: 'm2', homeTeam: _t('ENG'), awayTeam: _t('PAK'), venue: 'Lord\'s, London', dateTime: now, status: MatchStatus.live, format: MatchFormat.odi,
        innings1: InningsData(inningsNumber: 1, battingTeamId: 'ENG', runs: 310, wickets: 7, overs: 50.0, isCompleted: true, batsmen: [], bowlers: [], recentBalls: []),
        innings2: InningsData(inningsNumber: 2, battingTeamId: 'PAK', runs: 198, wickets: 4, overs: 34.3, isCompleted: false,
          batsmen: [const BatsmanScore(name: 'B. Azam', runs: 82, balls: 88, fours: 8, sixes: 1, isStriker: true), const BatsmanScore(name: 'M. Rizwan', runs: 45, balls: 52, fours: 3, sixes: 1, isStriker: false)],
          bowlers: [const BowlerScore(name: 'M. Wood', overs: 7, maidens: 0, runsConceded: 52, wickets: 2)],
          recentBalls: ['0', '1', '4', '0', '2', '1'],
          striker: const BatsmanScore(name: 'B. Azam', runs: 82, balls: 88, fours: 8, sixes: 1, isStriker: true),
          nonStriker: const BatsmanScore(name: 'M. Rizwan', runs: 45, balls: 52, fours: 3, sixes: 1, isStriker: false),
          currentBowler: const BowlerScore(name: 'M. Wood', overs: 7.3, maidens: 0, runsConceded: 52, wickets: 2))),
      Match(id: 'm3', homeTeam: _t('NZ'), awayTeam: _t('IND'), venue: 'Eden Park, Auckland', dateTime: now, status: MatchStatus.live, format: MatchFormat.t20,
        innings1: InningsData(inningsNumber: 1, battingTeamId: 'NZ', runs: 168, wickets: 6, overs: 20.0, isCompleted: true, batsmen: [], bowlers: [], recentBalls: []),
        innings2: InningsData(inningsNumber: 2, battingTeamId: 'IND', runs: 95, wickets: 2, overs: 11.4, isCompleted: false,
          batsmen: [const BatsmanScore(name: 'V. Kohli', runs: 52, balls: 38, fours: 5, sixes: 2, isStriker: true), const BatsmanScore(name: 'S. Gill', runs: 28, balls: 22, fours: 3, sixes: 1, isStriker: false)],
          bowlers: [const BowlerScore(name: 'T. Boult', overs: 3, maidens: 0, runsConceded: 22, wickets: 1)],
          recentBalls: ['4', '1', '6', '0', '0', '2'],
          striker: const BatsmanScore(name: 'V. Kohli', runs: 52, balls: 38, fours: 5, sixes: 2, isStriker: true),
          nonStriker: const BatsmanScore(name: 'S. Gill', runs: 28, balls: 22, fours: 3, sixes: 1, isStriker: false),
          currentBowler: const BowlerScore(name: 'T. Boult', overs: 3.4, maidens: 0, runsConceded: 22, wickets: 1))),
      Match(id: 'm4', homeTeam: _t('AUS'), awayTeam: _t('ENG'), venue: 'MCG, Melbourne', dateTime: now.add(const Duration(days: 2)), status: MatchStatus.upcoming, format: MatchFormat.odi),
      Match(id: 'm5', homeTeam: _t('PAK'), awayTeam: _t('NZ'), venue: 'Gaddafi Stadium, Lahore', dateTime: now.add(const Duration(days: 4)), status: MatchStatus.upcoming, format: MatchFormat.t20),
      Match(id: 'm6', homeTeam: _t('IND'), awayTeam: _t('ENG'), venue: 'Chinnaswamy Stadium, Bangalore', dateTime: now.add(const Duration(days: 7)), status: MatchStatus.upcoming, format: MatchFormat.test),
      Match(id: 'm7', homeTeam: _t('NZ'), awayTeam: _t('PAK'), venue: 'Basin Reserve, Wellington', dateTime: now.add(const Duration(days: 10)), status: MatchStatus.upcoming, format: MatchFormat.odi),
      Match(id: 'm8', homeTeam: _t('IND'), awayTeam: _t('PAK'), venue: 'Narendra Modi Stadium, Ahmedabad', dateTime: now.subtract(const Duration(days: 2)), status: MatchStatus.completed, format: MatchFormat.t20, result: 'India won by 7 wickets',
        innings1: InningsData(inningsNumber: 1, battingTeamId: 'PAK', runs: 158, wickets: 8, overs: 20.0, isCompleted: true, batsmen: [], bowlers: [], recentBalls: []),
        innings2: InningsData(inningsNumber: 2, battingTeamId: 'IND', runs: 162, wickets: 3, overs: 18.2, isCompleted: true, batsmen: [], bowlers: [], recentBalls: [])),
      Match(id: 'm9', homeTeam: _t('AUS'), awayTeam: _t('NZ'), venue: 'SCG, Sydney', dateTime: now.subtract(const Duration(days: 5)), status: MatchStatus.completed, format: MatchFormat.odi, result: 'Australia won by 45 runs',
        innings1: InningsData(inningsNumber: 1, battingTeamId: 'AUS', runs: 298, wickets: 6, overs: 50.0, isCompleted: true, batsmen: [], bowlers: [], recentBalls: []),
        innings2: InningsData(inningsNumber: 2, battingTeamId: 'NZ', runs: 253, wickets: 10, overs: 47.3, isCompleted: true, batsmen: [], bowlers: [], recentBalls: [])),
      Match(id: 'm10', homeTeam: _t('ENG'), awayTeam: _t('AUS'), venue: 'The Oval, London', dateTime: now.subtract(const Duration(days: 8)), status: MatchStatus.completed, format: MatchFormat.test, result: 'England won by 3 wickets',
        innings1: InningsData(inningsNumber: 1, battingTeamId: 'AUS', runs: 326, wickets: 10, overs: 88.2, isCompleted: true, batsmen: [], bowlers: [], recentBalls: []),
        innings2: InningsData(inningsNumber: 2, battingTeamId: 'ENG', runs: 329, wickets: 7, overs: 92.5, isCompleted: true, batsmen: [], bowlers: [], recentBalls: [])),
      Match(id: 'm11', homeTeam: _t('PAK'), awayTeam: _t('IND'), venue: 'Dubai International Stadium', dateTime: now.subtract(const Duration(days: 12)), status: MatchStatus.completed, format: MatchFormat.odi, result: 'Pakistan won by 5 runs',
        innings1: InningsData(inningsNumber: 1, battingTeamId: 'PAK', runs: 280, wickets: 8, overs: 50.0, isCompleted: true, batsmen: [], bowlers: [], recentBalls: []),
        innings2: InningsData(inningsNumber: 2, battingTeamId: 'IND', runs: 275, wickets: 9, overs: 50.0, isCompleted: true, batsmen: [], bowlers: [], recentBalls: [])),
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
