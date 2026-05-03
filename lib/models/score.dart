class BatsmanScore {
  final String name;
  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final bool isStriker;

  const BatsmanScore({
    required this.name,
    required this.runs,
    required this.balls,
    required this.fours,
    required this.sixes,
    required this.isStriker,
  });

  double get strikeRate => balls > 0 ? (runs / balls * 100) : 0.0;
}

class BowlerScore {
  final String name;
  final double overs;
  final int maidens;
  final int runsConceded;
  final int wickets;

  const BowlerScore({
    required this.name,
    required this.overs,
    required this.maidens,
    required this.runsConceded,
    required this.wickets,
  });

  double get economy => overs > 0 ? (runsConceded / overs) : 0.0;
}

class InningsData {
  final int inningsNumber;
  final String battingTeamId;
  final int runs;
  final int wickets;
  final double overs;
  final bool isCompleted;
  final List<BatsmanScore> batsmen;
  final List<BowlerScore> bowlers;
  final List<String> recentBalls;
  final BatsmanScore? striker;
  final BatsmanScore? nonStriker;
  final BowlerScore? currentBowler;

  const InningsData({
    required this.inningsNumber,
    required this.battingTeamId,
    required this.runs,
    required this.wickets,
    required this.overs,
    required this.isCompleted,
    required this.batsmen,
    required this.bowlers,
    required this.recentBalls,
    this.striker,
    this.nonStriker,
    this.currentBowler,
  });

  String get scoreString => '$runs/$wickets';
  String get oversString => '${overs.toStringAsFixed(1)} ov';

  InningsData copyWith({
    int? runs,
    int? wickets,
    double? overs,
    List<String>? recentBalls,
    BatsmanScore? striker,
    BatsmanScore? nonStriker,
    BowlerScore? currentBowler,
    List<BatsmanScore>? batsmen,
    List<BowlerScore>? bowlers,
    bool? isCompleted,
  }) {
    return InningsData(
      inningsNumber: inningsNumber,
      battingTeamId: battingTeamId,
      runs: runs ?? this.runs,
      wickets: wickets ?? this.wickets,
      overs: overs ?? this.overs,
      isCompleted: isCompleted ?? this.isCompleted,
      batsmen: batsmen ?? this.batsmen,
      bowlers: bowlers ?? this.bowlers,
      recentBalls: recentBalls ?? this.recentBalls,
      striker: striker ?? this.striker,
      nonStriker: nonStriker ?? this.nonStriker,
      currentBowler: currentBowler ?? this.currentBowler,
    );
  }
}
