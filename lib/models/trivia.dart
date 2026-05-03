/// Trivia question matching the Supabase `trivia_questions` table.
///
/// Uses option_a/b/c/d with correct_option ('A','B','C','D') to match the DB,
/// but exposes [options] list and [correctIndex] for backward compatibility
/// with the existing TriviaScreen UI.
class TriviaQuestion {
  final String id;
  final String category;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctOption; // 'A', 'B', 'C', 'D'
  final String difficulty;
  final int xpReward;
  final bool isActive;
  final String? explanation;

  const TriviaQuestion({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    this.category = 'general',
    this.difficulty = 'medium',
    this.xpReward = 10,
    this.isActive = true,
    this.explanation,
  });

  /// Backward-compatible list of option labels.
  List<String> get options => [optionA, optionB, optionC, optionD];

  /// Backward-compatible correct index (0-based).
  int get correctIndex {
    switch (correctOption) {
      case 'A':
        return 0;
      case 'B':
        return 1;
      case 'C':
        return 2;
      case 'D':
        return 3;
      default:
        return 0;
    }
  }

  bool isCorrect(int index) => index == correctIndex;

  /// Construct from Supabase row.
  factory TriviaQuestion.fromSupabase(Map<String, dynamic> map) {
    return TriviaQuestion(
      id: map['id'] as String,
      category: map['category'] as String? ?? 'general',
      question: map['question'] as String,
      optionA: map['option_a'] as String,
      optionB: map['option_b'] as String,
      optionC: map['option_c'] as String,
      optionD: map['option_d'] as String,
      correctOption: map['correct_option'] as String? ?? 'A',
      difficulty: map['difficulty'] as String? ?? 'medium',
      xpReward: map['xp_reward'] as int? ?? 10,
      isActive: map['is_active'] as bool? ?? true,
    );
  }

  /// Legacy JSON factory (for the local trivia_questions.json asset).
  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    // The local JSON uses `options` array + `correctIndex` int
    if (json.containsKey('options')) {
      final opts = List<String>.from(json['options'] as List);
      final ci = json['correctIndex'] as int? ?? 0;
      const letters = ['A', 'B', 'C', 'D'];
      return TriviaQuestion(
        id: json['id'] as String,
        question: json['question'] as String,
        optionA: opts.isNotEmpty ? opts[0] : '',
        optionB: opts.length > 1 ? opts[1] : '',
        optionC: opts.length > 2 ? opts[2] : '',
        optionD: opts.length > 3 ? opts[3] : '',
        correctOption: ci < letters.length ? letters[ci] : 'A',
        explanation: json['explanation'] as String?,
        difficulty: json['difficulty'] as String? ?? 'medium',
      );
    }
    // Otherwise treat as Supabase row
    return TriviaQuestion.fromSupabase(json);
  }
}

class TriviaRound {
  final int roundNumber;
  final List<TriviaQuestion> questions;
  final Map<String, int> answers; // questionId -> selected index
  int score;

  TriviaRound({
    required this.roundNumber,
    required this.questions,
    Map<String, int>? answers,
    this.score = 0,
  }) : answers = answers ?? {};

  int get totalQuestions => questions.length;
  int get answeredCount => answers.length;
  bool get isComplete => answeredCount >= totalQuestions;

  void answer(String questionId, int selectedIndex) {
    answers[questionId] = selectedIndex;
    final q = questions.firstWhere((q) => q.id == questionId);
    if (q.isCorrect(selectedIndex)) {
      score += q.xpReward;
    }
  }
}
