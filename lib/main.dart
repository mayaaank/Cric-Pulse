import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'config/supabase_config.dart';
import 'providers/auth_provider.dart';
import 'providers/live_scores_provider.dart';
import 'providers/matches_provider.dart';
import 'providers/rankings_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/poll_provider.dart';
import 'providers/trivia_provider.dart';
import 'providers/predict_provider.dart';
import 'providers/chat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  final authProvider = AuthProvider();
  authProvider.init();

  final settingsProvider = SettingsProvider();
  await settingsProvider.load();

  final liveScoresProvider = LiveScoresProvider();
  liveScoresProvider.init();

  final matchesProvider = MatchesProvider();
  matchesProvider.init();

  final pollProvider = PollProvider();
  pollProvider.init();

  final predictProvider = PredictProvider();
  predictProvider.setLiveProvider(liveScoresProvider);

  final chatProvider = ChatProvider();
  chatProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: liveScoresProvider),
        ChangeNotifierProvider.value(value: matchesProvider),
        ChangeNotifierProvider(create: (_) => RankingsProvider()),
        ChangeNotifierProvider.value(value: pollProvider),
        ChangeNotifierProvider(create: (_) => TriviaProvider()),
        ChangeNotifierProvider.value(value: predictProvider),
        ChangeNotifierProvider.value(value: chatProvider),
      ],
      child: const CricPulseApp(),
    ),
  );
}
