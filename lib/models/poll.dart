class Poll {
  final String id;
  final String question;
  final List<String> options;
  final Map<String, int> votes;
  final DateTime createdAt;
  final String? matchId;

  const Poll({
    required this.id,
    required this.question,
    required this.options,
    required this.votes,
    required this.createdAt,
    this.matchId,
  });

  int get totalVotes => votes.values.fold(0, (a, b) => a + b);

  double percentage(String option) {
    if (totalVotes == 0) return 0;
    return (votes[option] ?? 0) / totalVotes * 100;
  }

  Poll copyWith({Map<String, int>? votes}) {
    return Poll(
      id: id,
      question: question,
      options: options,
      votes: votes ?? this.votes,
      createdAt: createdAt,
      matchId: matchId,
    );
  }

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json['id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      votes: Map<String, int>.from(json['votes'] as Map? ?? {}),
      createdAt: DateTime.parse(json['created_at'] as String),
      matchId: json['match_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'votes': votes,
      'created_at': createdAt.toIso8601String(),
      'match_id': matchId,
    };
  }
}
