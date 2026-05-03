import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/trivia.dart';
import '../services/supabase_service.dart';

/// Trivia service backed by Supabase `trivia_questions` table.
///
/// Falls back to the local `assets/trivia_questions.json` when the
/// Supabase table has no active questions or is unreachable.
class TriviaService {
  List<TriviaQuestion>? _localCache;
  final _rand = Random();

  /// Get a random subset of questions for a round.
  /// Tries Supabase first, falls back to local JSON.
  Future<List<TriviaQuestion>> getRoundQuestions({int count = 5}) async {
    try {
      final data = await SupabaseService.client
          .from('trivia_questions')
          .select()
          .eq('is_active', true);

      final questions = (data as List)
          .map((row) => TriviaQuestion.fromSupabase(row))
          .toList();

      if (questions.isNotEmpty) {
        questions.shuffle(_rand);
        return questions.take(count).toList();
      }
    } catch (e) {
      debugPrint('TriviaService.getRoundQuestions Supabase error: $e');
    }

    // Fallback to local JSON asset
    return _getLocalQuestions(count: count);
  }

  /// Create a trivia session in Supabase (if authenticated).
  Future<String?> createSession({String? matchId}) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return null;

    try {
      final data = await SupabaseService.client
          .from('user_trivia_sessions')
          .insert({
            'user_id': userId,
          })
          .select('id')
          .single();

      return data['id'] as String;
    } catch (e) {
      debugPrint('TriviaService.createSession error: $e');
      return null;
    }
  }

  /// Submit an answer for a trivia question.
  Future<void> submitAnswer({
    required String sessionId,
    required String questionId,
    required String selectedOption,
    required bool isCorrect,
    required int xpEarned,
  }) async {
    try {
      await SupabaseService.client.from('user_trivia_answers').insert({
        'session_id': sessionId,
        'question_id': questionId,
        'selected_option': selectedOption,
        'is_correct': isCorrect,
      });
    } catch (e) {
      debugPrint('TriviaService.submitAnswer error: $e');
    }
  }

  /// Complete a trivia session with the final score.
  Future<void> completeSession({
    required String sessionId,
    required int score,
  }) async {
    try {
      await SupabaseService.client
          .from('user_trivia_sessions')
          .update({
            'completed': true,
            'score': score,
          })
          .eq('id', sessionId);
    } catch (e) {
      debugPrint('TriviaService.completeSession error: $e');
    }
  }

  // ── Local JSON fallback ──

  Future<List<TriviaQuestion>> _getLocalQuestions({int count = 5}) async {
    if (_localCache == null) {
      try {
        final jsonString =
            await rootBundle.loadString('assets/trivia_questions.json');
        final List<dynamic> jsonList =
            json.decode(jsonString) as List<dynamic>;
        _localCache = jsonList
            .map((e) => TriviaQuestion.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('TriviaService: local JSON load failed: $e');
        _localCache = [];
      }
    }
    final shuffled = List<TriviaQuestion>.from(_localCache!)..shuffle(_rand);
    return shuffled.take(count).toList();
  }
}
