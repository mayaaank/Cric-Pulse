enum PlayerRole { batsman, bowler, allRounder, wicketKeeper }

class BattingStats {
  final int matches;
  final int innings;
  final int runs;
  final int highScore;
  final double average;
  final double strikeRate;
  final int fifties;
  final int hundreds;

  const BattingStats({
    required this.matches,
    required this.innings,
    required this.runs,
    required this.highScore,
    required this.average,
    required this.strikeRate,
    required this.fifties,
    required this.hundreds,
  });
}

class BowlingStats {
  final int matches;
  final int wickets;
  final double economy;
  final double average;
  final String bestFigures;

  const BowlingStats({
    required this.matches,
    required this.wickets,
    required this.economy,
    required this.average,
    required this.bestFigures,
  });
}

class Player {
  final String id;
  final String name;
  final String teamId;
  final PlayerRole role;
  final int battingRank;
  final int bowlingRank;
  final BattingStats battingStats;
  final BowlingStats bowlingStats;

  const Player({
    required this.id,
    required this.name,
    required this.teamId,
    required this.role,
    required this.battingRank,
    required this.bowlingRank,
    required this.battingStats,
    required this.bowlingStats,
  });
}
