import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/poll.dart';
import '../services/supabase_service.dart';

/// Poll service backed by Supabase tables: `polls`, `poll_votes`.
///
/// Falls back to local mock data when the user is not authenticated
/// or Supabase is unreachable.
class PollService {
  /// Fetch all active polls.
  Future<List<Poll>> getActivePolls() async {
    try {
      final data = await SupabaseService.client
          .from('polls')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (data as List).map((row) => Poll.fromSupabase(row)).toList();
    } catch (e) {
      debugPrint('PollService.getActivePolls error: $e');
      return _mockPolls();
    }
  }

  /// Real-time stream of active polls. Every DB change triggers a new list.
  Stream<List<Poll>> pollStream() {
    try {
      return SupabaseService.client
          .from('polls')
          .stream(primaryKey: ['id'])
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .map((rows) => rows.map((row) => Poll.fromSupabase(row)).toList())
          .handleError((error) {
            debugPrint('PollService.pollStream realtime error: $error');
            // Yield nothing or mock data on error so it doesn't crash
          });
    } catch (e) {
      debugPrint('PollService.pollStream error: $e');
      // Fallback: emit mock once
      return Stream.value(_mockPolls());
    }
  }

  /// Cast a vote. The DB trigger `trigger_update_poll_counts`
  /// auto-increments `option_a_votes` / `option_b_votes`.
  Future<void> vote(String pollId, String optionLabel, Poll poll) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return;

    final voteKey = optionLabel == poll.optionA ? 'option_a' : 'option_b';

    await SupabaseService.client.from('poll_votes').insert({
      'poll_id': pollId,
      'user_id': userId,
      'vote': voteKey,
    });
  }

  /// Check whether the current user has already voted on a poll.
  Future<bool> hasUserVoted(String pollId) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return false;

    try {
      final data = await SupabaseService.client
          .from('poll_votes')
          .select('id')
          .eq('poll_id', pollId)
          .eq('user_id', userId)
          .maybeSingle();

      return data != null;
    } catch (_) {
      return false;
    }
  }

  /// Load all poll IDs that the current user has voted on.
  Future<Set<String>> loadVotedPollIds() async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return {};

    try {
      final data = await SupabaseService.client
          .from('poll_votes')
          .select('poll_id')
          .eq('user_id', userId);

      return (data as List)
          .map((row) => row['poll_id'] as String)
          .toSet();
    } catch (_) {
      return {};
    }
  }

  // ── Fallback mock data ──

  static List<Poll> _mockPolls() {
    return [
      Poll(
        id: 'mock-poll-1',
        question: 'Will this over go for 10+ runs?',
        optionA: 'Yes',
        optionB: 'No',
        optionAVotes: 142,
        optionBVotes: 218,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        matchId: null,
      ),
      Poll(
        id: 'mock-poll-2',
        question: 'Will Bumrah take a wicket in his next over?',
        optionA: 'Yes',
        optionB: 'No',
        optionAVotes: 312,
        optionBVotes: 178,
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
        matchId: null,
      ),
    ];
  }
}
