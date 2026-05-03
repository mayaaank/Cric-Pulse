import 'package:google_generative_ai/google_generative_ai.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class GeminiService {
  GenerativeModel? _model;
  ChatSession? _chat;

  static const _systemPrompt = '''
You are CricBot, an expert cricket companion AI. You help fans understand:
- Cricket rules, terminology, and playing conditions
- Player statistics, records, and career highlights
- Match history, series results, and tournament formats
- Strategies, tactics, and game situations
- ICC rankings, point systems, and qualification criteria

Guidelines:
- Be enthusiastic and engaging — you're chatting with cricket fans!
- Use cricket terminology naturally but explain complex terms when needed
- Keep responses concise (2-3 paragraphs max) unless asked for detail
- Use emojis sparingly for emphasis 🏏
- If you don't know something specific, say so honestly
- Reference real cricket facts and statistics
''';

  bool get isConfigured => _model != null;

  void initialize(String apiKey) {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(_systemPrompt),
    );
    _chat = _model!.startChat();
  }

  Future<String> sendMessage(String message) async {
    if (_chat == null) {
      return _getMockResponse(message);
    }

    try {
      final response = await _chat!.sendMessage(Content.text(message));
      return response.text ?? 'Sorry, I couldn\'t generate a response.';
    } catch (e) {
      return 'Oops! Something went wrong. Please try again. ($e)';
    }
  }

  /// Fallback mock responses when no API key is configured.
  String _getMockResponse(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('lbw') || lower.contains('leg before')) {
      return '🏏 **LBW (Leg Before Wicket)** is one of cricket\'s most debated dismissals!\n\n'
          'A batsman is out LBW when the ball would have hit the stumps but was intercepted by the batsman\'s body (usually the pad). '
          'Key conditions: the ball must pitch in line or outside off stump, and impact must be in line with the stumps (unless the batsman isn\'t playing a shot).\n\n'
          'The DRS system with ball-tracking technology has made LBW decisions much more accurate in modern cricket!';
    }

    if (lower.contains('drs') || lower.contains('review')) {
      return '📺 **DRS (Decision Review System)** allows teams to challenge on-field umpire decisions.\n\n'
          'Each team gets a limited number of unsuccessful reviews per innings (usually 2 in Tests, 1 in ODIs/T20Is). '
          'It uses ball-tracking (Hawk-Eye), UltraEdge for snickometer, and Hot Spot to check decisions.\n\n'
          'Fun fact: DRS was first used in a Test between India and Sri Lanka in 2008!';
    }

    if (lower.contains('kohli') || lower.contains('virat')) {
      return '👑 **Virat Kohli** is one of cricket\'s modern greats!\n\n'
          'Key stats: 50+ ODI centuries, 13,000+ ODI runs, averaging nearly 58 in ODIs. '
          'He\'s the fastest to 8,000, 9,000, 10,000, 11,000, and 12,000 ODI runs.\n\n'
          'Known for his aggressive batting, incredible chase record, and passionate celebrations! 🔥';
    }

    if (lower.contains('powerplay')) {
      return '⚡ **Powerplay** refers to fielding restrictions in limited-overs cricket.\n\n'
          'In ODIs: Overs 1-10 are the mandatory powerplay (only 2 fielders outside the 30-yard circle). '
          'Overs 11-40 allow 4 fielders outside, and overs 41-50 allow 5.\n\n'
          'In T20Is: Overs 1-6 are the powerplay with only 2 fielders outside the 30-yard circle.';
    }

    return '🏏 Great question! As CricBot, I\'m here to help with all things cricket.\n\n'
        'I can explain rules, share player stats, discuss match strategies, and more. '
        'Try asking me about specific topics like "What is DRS?", "Tell me about Virat Kohli", '
        'or "How does the Powerplay work?"\n\n'
        'What would you like to know? 🎯';
  }

  void resetChat() {
    if (_model != null) {
      _chat = _model!.startChat();
    }
  }
}
