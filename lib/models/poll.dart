/// Poll model matching the Supabase `polls` table schema.
///
/// Uses a two-option structure (option_a / option_b) to match the DB,
/// but exposes [options] and [votes] getters for backward compatibility
/// with the existing PollCard widget.
class Poll {
  final String id;
  final String? matchId;
  final String question;
  final String optionA;
  final String optionB;
  final int optionAVotes;
  final int optionBVotes;
  final bool isActive;
  final DateTime? expiresAt;
  final DateTime createdAt;

  const Poll({
    required this.id,
    this.matchId,
    required this.question,
    required this.optionA,
    required this.optionB,
    this.optionAVotes = 0,
    this.optionBVotes = 0,
    this.isActive = true,
    this.expiresAt,
    required this.createdAt,
  });

  /// Total vote count.
  int get totalVotes => optionAVotes + optionBVotes;

  /// Backward-compatible list of option labels.
  List<String> get options => [optionA, optionB];

  /// Backward-compatible votes map keyed by option label.
  Map<String, int> get votes => {
        optionA: optionAVotes,
        optionB: optionBVotes,
      };

  /// Returns the vote key ('A' or 'B') for the given option label.
  String voteKeyFor(String optionLabel) {
    if (optionLabel == optionA) return 'A';
    return 'B';
  }

  /// Percentage for a given option label.
  double percentage(String option) {
    if (totalVotes == 0) return 0;
    return (votes[option] ?? 0) / totalVotes * 100;
  }

  Poll copyWith({int? optionAVotes, int? optionBVotes}) {
    return Poll(
      id: id,
      matchId: matchId,
      question: question,
      optionA: optionA,
      optionB: optionB,
      optionAVotes: optionAVotes ?? this.optionAVotes,
      optionBVotes: optionBVotes ?? this.optionBVotes,
      isActive: isActive,
      expiresAt: expiresAt,
      createdAt: createdAt,
    );
  }

  /// Parse a Supabase row into a Poll.
  factory Poll.fromSupabase(Map<String, dynamic> map) {
    return Poll(
      id: map['id'] as String,
      matchId: map['match_id'] as String?,
      question: map['question'] as String,
      optionA: map['option_a'] as String,
      optionB: map['option_b'] as String,
      optionAVotes: map['option_a_votes'] as int? ?? 0,
      optionBVotes: map['option_b_votes'] as int? ?? 0,
      isActive: map['is_active'] as bool? ?? true,
      expiresAt: map['expires_at'] != null
          ? DateTime.parse(map['expires_at'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Legacy JSON factory (kept for backward compat / tests).
  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll.fromSupabase(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'match_id': matchId,
      'question': question,
      'option_a': optionA,
      'option_b': optionB,
      'option_a_votes': optionAVotes,
      'option_b_votes': optionBVotes,
      'is_active': isActive,
      'expires_at': expiresAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
