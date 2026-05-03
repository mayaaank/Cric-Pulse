import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
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
  // Pass your Gemini API key here to enable AI responses:
  // chatProvider.initialize(apiKey: 'YOUR_GEMINI_API_KEY');
  chatProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
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
