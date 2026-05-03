enum BallOutcome { dot, boundary, wicket, runs }

class Prediction {
  final BallOutcome predicted;
  final BallOutcome? actual;
  final int xpEarned;
  final DateTime timestamp;
  final String overInfo;

  const Prediction({
    required this.predicted,
    this.actual,
    this.xpEarned = 0,
    required this.timestamp,
    required this.overInfo,
  });

  bool get isCorrect => actual != null && predicted == actual;
  bool get isResolved => actual != null;

  Prediction resolve(BallOutcome actualOutcome) {
    final correct = predicted == actualOutcome;
    return Prediction(
      predicted: predicted,
      actual: actualOutcome,
      xpEarned: correct ? xpForOutcome(predicted) : 0,
      timestamp: timestamp,
      overInfo: overInfo,
    );
  }

  static int xpForOutcome(BallOutcome outcome) {
    switch (outcome) {
      case BallOutcome.dot:
        return 10;
      case BallOutcome.runs:
        return 25;
      case BallOutcome.boundary:
        return 50;
      case BallOutcome.wicket:
        return 100;
    }
  }

  static String labelFor(BallOutcome outcome) {
    switch (outcome) {
      case BallOutcome.dot:
        return 'DOT';
      case BallOutcome.boundary:
        return 'FOUR/SIX';
      case BallOutcome.wicket:
        return 'WICKET';
      case BallOutcome.runs:
        return '1, 2 or 3';
    }
  }

  /// Convert BallOutcome to a Supabase-compatible string.
  static String toSupabaseOutcome(BallOutcome outcome) {
    switch (outcome) {
      case BallOutcome.dot:
        return 'dot';
      case BallOutcome.boundary:
        return 'four'; // maps to four/six
      case BallOutcome.wicket:
        return 'wicket';
      case BallOutcome.runs:
        return 'single'; // maps to 1/2/3
    }
  }

  /// Parse a Supabase outcome string to a BallOutcome.
  static BallOutcome fromSupabaseOutcome(String outcome) {
    switch (outcome) {
      case 'dot':
        return BallOutcome.dot;
      case 'four':
      case 'six':
        return BallOutcome.boundary;
      case 'wicket':
        return BallOutcome.wicket;
      case 'single':
      case 'double':
      case 'triple':
        return BallOutcome.runs;
      default:
        return BallOutcome.dot;
    }
  }
}

class PredictionStats {
  final int totalPredictions;
  final int correctPredictions;
  final int totalXp;
  final int currentStreak;
  final int bestStreak;

  const PredictionStats({
    this.totalPredictions = 0,
    this.correctPredictions = 0,
    this.totalXp = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
  });

  double get accuracy =>
      totalPredictions > 0 ? correctPredictions / totalPredictions * 100 : 0;

  int get multiplier {
    if (currentStreak >= 5) return 3;
    if (currentStreak >= 3) return 2;
    return 1;
  }

  PredictionStats copyWith({
    int? totalPredictions,
    int? correctPredictions,
    int? totalXp,
    int? currentStreak,
    int? bestStreak,
  }) {
    return PredictionStats(
      totalPredictions: totalPredictions ?? this.totalPredictions,
      correctPredictions: correctPredictions ?? this.correctPredictions,
      totalXp: totalXp ?? this.totalXp,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
    );
  }

  /// Build from Supabase `user_stats` row.
  factory PredictionStats.fromSupabase(Map<String, dynamic> map) {
    return PredictionStats(
      totalPredictions: map['predictions_total'] as int? ?? 0,
      correctPredictions: map['predictions_correct'] as int? ?? 0,
      totalXp: 0, // XP is on the profile
      currentStreak: map['current_streak'] as int? ?? 0,
      bestStreak: map['best_streak'] as int? ?? 0,
    );
  }
}
