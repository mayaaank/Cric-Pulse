import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/trivia.dart';

class TriviaService {
  List<TriviaQuestion>? _allQuestions;
  final _rand = Random();

  Future<List<TriviaQuestion>> loadQuestions() async {
    if (_allQuestions != null) return _allQuestions!;
    final jsonString = await rootBundle.loadString('assets/trivia_questions.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    _allQuestions = jsonList
        .map((e) => TriviaQuestion.fromJson(e as Map<String, dynamic>))
        .toList();
    return _allQuestions!;
  }

  /// Get a random subset of questions for a round.
  Future<List<TriviaQuestion>> getRoundQuestions({int count = 5}) async {
    final all = await loadQuestions();
    final shuffled = List<TriviaQuestion>.from(all)..shuffle(_rand);
    return shuffled.take(count).toList();
  }
}
