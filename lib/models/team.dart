class Team {
  final String id;
  final String name;
  final String shortCode;
  final String flagEmoji;
  final int iccRanking;
  final int matchesPlayed;
  final int wins;

  const Team({
    required this.id,
    required this.name,
    required this.shortCode,
    required this.flagEmoji,
    required this.iccRanking,
    required this.matchesPlayed,
    required this.wins,
  });

  int get losses => matchesPlayed - wins;
  double get winPercentage =>
      matchesPlayed > 0 ? (wins / matchesPlayed * 100) : 0.0;
}
