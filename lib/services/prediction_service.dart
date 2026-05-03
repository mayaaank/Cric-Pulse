import 'package:flutter/foundation.dart';
import '../services/supabase_service.dart';

/// Service for prediction rounds and user predictions via Supabase.
///
/// Tables: `prediction_rounds`, `user_predictions`.
class PredictionService {
  /// DB outcome strings matching the CHECK constraint.
  static const outcomeValues = [
    'dot', 'single', 'double', 'triple',
    'four', 'six', 'wicket', 'wide', 'no_ball',
  ];

  /// Get the currently open prediction round.
  Future<Map<String, dynamic>?> getOpenRound(String matchId) async {
    try {
      final data = await SupabaseService.client
          .from('prediction_rounds')
          .select()
          // .eq('match_id', matchId) // Avoid filtering by mock match ID (m1) which breaks UUID constraint
          .eq('status', 'open')
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      return data;
    } catch (e) {
      debugPrint('PredictionService.getOpenRound error: $e');
      return null;
    }
  }

  /// Submit a prediction for the current round.
  Future<void> submitPrediction({
    required String roundId,
    required String predictedOutcome,
  }) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return;

    try {
      await SupabaseService.client.from('user_predictions').insert({
        'round_id': roundId,
        'user_id': userId,
        'predicted_outcome': predictedOutcome,
      });
    } catch (e) {
      debugPrint('PredictionService.submitPrediction error: $e');
    }
  }

  /// Fetch prediction history for the current user.
  Future<List<Map<String, dynamic>>> getPredictionHistory({int limit = 20}) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return [];

    try {
      final data = await SupabaseService.client
          .from('user_predictions')
          .select('*, prediction_rounds(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('PredictionService.getPredictionHistory error: $e');
      return [];
    }
  }

  /// Real-time stream of prediction rounds.
  Stream<List<Map<String, dynamic>>> roundStream(String matchId) {
    return SupabaseService.client
        .from('prediction_rounds')
        .stream(primaryKey: ['id'])
        // .eq('match_id', matchId)
        .order('created_at', ascending: false)
        .handleError((error) {
          debugPrint('PredictionService.roundStream realtime error: $error');
        });
  }

  /// Fetch user_stats for the current user.
  Future<Map<String, dynamic>?> getUserStats() async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return null;

    try {
      return await SupabaseService.client
          .from('user_stats')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
    } catch (e) {
      debugPrint('PredictionService.getUserStats error: $e');
      return null;
    }
  }
}
