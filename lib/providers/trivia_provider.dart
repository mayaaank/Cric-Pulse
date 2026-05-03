import 'package:flutter/material.dart';
import '../models/trivia.dart';
import '../services/trivia_service.dart';

class TriviaProvider extends ChangeNotifier {
  final TriviaService _service = TriviaService();

  TriviaRound? _currentRound;
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _totalXp = 0;
  int _roundsPlayed = 0;
  bool _loading = false;
  String? _sessionId;

  TriviaRound? get currentRound => _currentRound;
  int get currentQuestionIndex => _currentQuestionIndex;
  int? get selectedAnswer => _selectedAnswer;
  bool get answered => _answered;
  int get totalXp => _totalXp;
  int get roundsPlayed => _roundsPlayed;
  bool get loading => _loading;

  TriviaQuestion? get currentQuestion {
    if (_currentRound == null) return null;
    if (_currentQuestionIndex >= _currentRound!.questions.length) return null;
    return _currentRound!.questions[_currentQuestionIndex];
  }

  bool get isRoundComplete => _currentRound?.isComplete ?? false;
  int get questionsPerRound => _currentRound?.totalQuestions ?? 5;

  Future<void> startNewRound() async {
    _loading = true;
    notifyListeners();

    final questions = await _service.getRoundQuestions(count: 5);
    _roundsPlayed++;
    _currentRound = TriviaRound(
      roundNumber: _roundsPlayed,
      questions: questions,
    );
    _currentQuestionIndex = 0;
    _selectedAnswer = null;
    _answered = false;

    // Create a session in Supabase (returns null if not logged in)
    _sessionId = await _service.createSession();

    _loading = false;
    notifyListeners();
  }

  void selectAnswer(int index) {
    if (_answered || currentQuestion == null) return;
    _selectedAnswer = index;
    _answered = true;
    _currentRound!.answer(currentQuestion!.id, index);

    // Submit answer to Supabase
    if (_sessionId != null) {
      final q = currentQuestion!;
      const letters = ['A', 'B', 'C', 'D'];
      final selectedLetter = index < letters.length ? letters[index] : 'A';
      final isCorrect = q.isCorrect(index);
      final xpEarned = isCorrect ? q.xpReward : 0;

      _service.submitAnswer(
        sessionId: _sessionId!,
        questionId: q.id,
        selectedOption: selectedLetter,
        isCorrect: isCorrect,
        xpEarned: xpEarned,
      );
    }

    notifyListeners();
  }

  void nextQuestion() {
    if (_currentRound == null) return;
    if (_currentQuestionIndex < _currentRound!.totalQuestions - 1) {
      _currentQuestionIndex++;
      _selectedAnswer = null;
      _answered = false;
      notifyListeners();
    }
  }

  void finishRound() {
    if (_currentRound != null) {
      _totalXp += _currentRound!.score;

      // Complete the session in Supabase
      if (_sessionId != null) {
        _service.completeSession(
          sessionId: _sessionId!,
          score: _currentRound!.score,
        );
      }

      notifyListeners();
    }
  }

  void reset() {
    _currentRound = null;
    _currentQuestionIndex = 0;
    _selectedAnswer = null;
    _answered = false;
    _sessionId = null;
    notifyListeners();
  }
}
