class TriviaQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;
  final String difficulty;

  const TriviaQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
    this.difficulty = 'medium',
  });

  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    return TriviaQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String?,
      difficulty: json['difficulty'] as String? ?? 'medium',
    );
  }

  bool isCorrect(int index) => index == correctIndex;
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
      score += _xpForDifficulty(q.difficulty);
    }
  }

  int _xpForDifficulty(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return 10;
      case 'hard':
        return 30;
      default:
        return 20;
    }
  }
}
