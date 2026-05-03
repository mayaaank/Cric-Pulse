import 'package:flutter/foundation.dart';
import '../services/supabase_service.dart';

/// Leaderboard entry combining profile + stats data.
class LeaderboardEntry {
  final String userId;
  final String username;
  final String? displayName;
  final int totalXp;
  final int level;

  const LeaderboardEntry({
    required this.userId,
    required this.username,
    this.displayName,
    required this.totalXp,
    required this.level,
  });

  String get name => displayName ?? username;

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      userId: map['id'] as String,
      username: map['username'] as String? ?? 'unknown',
      displayName: map['display_name'] as String?,
      totalXp: map['total_xp'] as int? ?? 0,
      level: map['level'] as int? ?? 1,
    );
  }
}

/// Service for fetching leaderboard data from Supabase.
class LeaderboardService {
  /// Get the top users ordered by total XP.
  Future<List<LeaderboardEntry>> getTopUsers({int limit = 20}) async {
    try {
      final data = await SupabaseService.client
          .from('profiles')
          .select('id, username, display_name, total_xp, level')
          .order('total_xp', ascending: false)
          .limit(limit);

      return (data as List)
          .map((row) => LeaderboardEntry.fromMap(row))
          .toList();
    } catch (e) {
      debugPrint('LeaderboardService.getTopUsers error: $e');
      return [];
    }
  }

  /// Get the current user's stats.
  Future<Map<String, dynamic>?> getMyStats() async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return null;

    try {
      return await SupabaseService.client
          .from('user_stats')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
    } catch (e) {
      debugPrint('LeaderboardService.getMyStats error: $e');
      return null;
    }
  }
}
