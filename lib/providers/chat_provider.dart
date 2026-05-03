import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class ChatProvider extends ChangeNotifier {
  final GeminiService _service = GeminiService();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  bool get isConfigured => _service.isConfigured;

  static const quickQuestions = [
    'What is DRS?',
    'Explain LBW rule',
    'Kohli career stats',
    'How does Powerplay work?',
    'What is a googly?',
    'Fastest century in ODIs?',
  ];

  void initialize({String? apiKey}) {
    if (apiKey != null && apiKey.isNotEmpty) {
      _service.initialize(apiKey);
    }
    // Add welcome message
    _messages.add(ChatMessage(
      text: '🏏 Hey! I\'m **CricBot** — your AI cricket companion!\n\n'
          'Ask me anything about cricket rules, player stats, match history, '
          'or game strategies. I\'m here to help!\n\n'
          'Try tapping one of the quick questions below to get started.',
      isUser: false,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.sendMessage(text);
      _messages.add(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      _messages.add(ChatMessage(
        text: 'Sorry, something went wrong. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    _service.resetChat();
    _messages.add(ChatMessage(
      text: '🏏 Chat cleared! Ask me anything about cricket.',
      isUser: false,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }
}
