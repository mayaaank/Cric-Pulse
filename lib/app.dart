import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'screens/shell_screen.dart';
import 'screens/match_detail/match_detail_screen.dart';
import 'screens/predict/predict_screen.dart';
import 'screens/trivia/trivia_screen.dart';
import 'screens/polls/polls_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/leaderboard/leaderboard_screen.dart';

class CricPulseApp extends StatelessWidget {
  const CricPulseApp({super.key});

  static final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ShellScreen(),
      ),
      GoRoute(
        path: '/match/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MatchDetailScreen(matchId: id);
        },
      ),
      GoRoute(
        path: '/predict',
        builder: (context, state) => const Scaffold(body: PredictScreen()),
      ),
      GoRoute(
        path: '/trivia',
        builder: (context, state) => const Scaffold(body: TriviaScreen()),
      ),
      GoRoute(
        path: '/polls',
        builder: (context, state) => const Scaffold(body: PollsScreen()),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const Scaffold(body: ChatScreen()),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const Scaffold(body: LeaderboardScreen()),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CricPulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      routerConfig: _router,
    );
  }
}
