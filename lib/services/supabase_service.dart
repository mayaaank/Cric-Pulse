import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized Supabase access for the entire app.
///
/// Usage:
///   final client = SupabaseService.client;
///   final data = await client.from('polls').select();
class SupabaseService {
  SupabaseService._();

  /// The main Supabase client instance.
  static SupabaseClient get client => Supabase.instance.client;

  /// Shorthand for the auth module.
  static GoTrueClient get auth => client.auth;

  /// Currently signed-in user (nullable).
  static User? get currentUser => auth.currentUser;

  /// Current user's UUID (nullable).
  static String? get currentUserId => currentUser?.id;

  /// Whether a user is currently authenticated.
  static bool get isAuthenticated => currentUser != null;
}
