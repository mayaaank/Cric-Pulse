import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/glass_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<ChatProvider>().sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Consumer<ChatProvider>(
      builder: (context, prov, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      Icon(Icons.smart_toy, color: cs.tertiary, size: 24),
                      const SizedBox(width: 8),
                      Text('CricBot',
                          style: tt.headlineMedium!.copyWith(color: cs.primary)),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.refresh, color: cs.onSurfaceVariant),
                        onPressed: prov.clearChat,
                        tooltip: 'Clear chat',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Your AI Cricket Companion',
                      style: tt.bodySmall!.copyWith(color: cs.onSurfaceVariant)),
                ),
                const SizedBox(height: 12),
                // Messages
                Expanded(
                  child: ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: prov.messages.length + (prov.isLoading ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == prov.messages.length && prov.isLoading) {
                        return _TypingIndicator(cs: cs);
                      }
                      final msg = prov.messages[i];
                      return ChatBubble(
                        text: msg.text,
                        isUser: msg.isUser,
                        timestamp: msg.timestamp,
                      );
                    },
                  ),
                ),
                // Quick questions
                if (prov.messages.length <= 2)
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: ChatProvider.quickQuestions
                          .map((q) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ActionChip(
                                  label: Text(q,
                                      style: tt.labelSmall!
                                          .copyWith(color: cs.primary)),
                                  backgroundColor: cs.surfaceContainerHigh,
                                  side: BorderSide(
                                      color: cs.outlineVariant.withValues(alpha: 0.5)),
                                  onPressed: () {
                                    prov.sendMessage(q);
                                    _scrollToBottom();
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 8),
                // Input bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: GlassCard(
                    borderRadius: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: tt.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Ask about cricket...',
                              hintStyle: tt.bodyMedium!
                                  .copyWith(color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            onSubmitted: (_) => _send(),
                            textInputAction: TextInputAction.send,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: IconButton(
                            onPressed: _send,
                            icon: Icon(Icons.send, color: cs.primaryContainer),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  cs.primaryContainer.withValues(alpha: 0.15),
                              shape: const CircleBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  final ColorScheme cs;
  const _TypingIndicator({required this.cs});

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 12),
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: widget.cs.onSurfaceVariant
                        .withValues(alpha: 0.3 + (_ctrl.value * 0.5 * ((i + 1) / 3))),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
