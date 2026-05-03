import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

/// User profile data from the `profiles` table.
class UserProfile {
  final String id;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final int totalXp;
  final int level;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.totalXp = 0,
    this.level = 1,
    required this.createdAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      username: map['username'] as String? ?? 'unknown',
      displayName: map['display_name'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      totalXp: map['total_xp'] as int? ?? 0,
      level: map['level'] as int? ?? 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

/// Manages Supabase auth state and user profile.
///
/// The login/signup UI is handled by a teammate — this provider only
/// exposes the auth state, profile data, and sign-out capability.
class AuthProvider extends ChangeNotifier {
  User? _user;
  UserProfile? _profile;
  bool _loading = true;
  StreamSubscription<AuthState>? _authSub;

  User? get user => _user;
  UserProfile? get profile => _profile;
  bool get loading => _loading;
  bool get isLoggedIn => _user != null;
  String? get userId => _user?.id;

  /// Call once at app start to listen for auth changes.
  void init() {
    _user = SupabaseService.currentUser;
    if (_user != null) {
      _loadProfile();
    } else {
      // Auto-login anonymously so database features still work without an Auth UI
      SupabaseService.client.auth.signInAnonymously().catchError((e) {
        debugPrint('Auto anonymous login failed: $e');
      });
      _loading = false;
      notifyListeners();
    }

    _authSub = SupabaseService.auth.onAuthStateChange.listen((data) {
      final newUser = data.session?.user;
      if (newUser?.id != _user?.id) {
        _user = newUser;
        if (_user != null) {
          _loadProfile();
        } else {
          _profile = null;
          _loading = false;
          notifyListeners();
        }
      }
    });
  }

  /// Fetch the user's profile from the `profiles` table.
  Future<void> _loadProfile() async {
    if (_user == null) return;
    _loading = true;
    notifyListeners();

    try {
      final data = await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', _user!.id)
          .maybeSingle();

      if (data != null) {
        _profile = UserProfile.fromMap(data);
      }
    } catch (e) {
      debugPrint('AuthProvider: failed to load profile: $e');
    }

    _loading = false;
    notifyListeners();
  }

  /// Reload profile (useful after XP changes).
  Future<void> refreshProfile() async => _loadProfile();

  /// Sign out the current user.
  Future<void> signOut() async {
    await SupabaseService.auth.signOut();
    _user = null;
    _profile = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
