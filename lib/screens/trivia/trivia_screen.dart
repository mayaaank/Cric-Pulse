import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trivia_provider.dart';
import '../../widgets/glass_card.dart';

class TriviaScreen extends StatelessWidget {
  const TriviaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Consumer<TriviaProvider>(
      builder: (context, prov, _) {
        if (prov.loading) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: cs.primaryContainer),
                  const SizedBox(height: 16),
                  Text('Loading questions...', style: tt.bodyMedium),
                ],
              ),
            ),
          );
        }

        if (prov.currentRound == null) {
          return _StartScreen(cs: cs, tt: tt, prov: prov);
        }

        if (prov.isRoundComplete) {
          return _ResultScreen(cs: cs, tt: tt, prov: prov);
        }

        return _QuestionScreen(cs: cs, tt: tt, prov: prov);
      },
    );
  }
}

class _StartScreen extends StatelessWidget {
  final ColorScheme cs;
  final TextTheme tt;
  final TriviaProvider prov;

  const _StartScreen({required this.cs, required this.tt, required this.prov});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.quiz, size: 80, color: cs.primaryContainer),
                const SizedBox(height: 24),
                Text('Cricket Trivia', style: tt.headlineLarge!.copyWith(color: cs.primary)),
                const SizedBox(height: 8),
                Text(
                  'Test your cricket knowledge!',
                  style: tt.bodyLarge!.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Text(
                  '5 questions per round',
                  style: tt.bodySmall,
                ),
                if (prov.roundsPlayed > 0) ...[
                  const SizedBox(height: 24),
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('${prov.roundsPlayed}',
                                style: tt.headlineMedium!.copyWith(color: cs.primaryContainer)),
                            Text('Rounds', style: tt.labelSmall),
                          ],
                        ),
                        Column(
                          children: [
                            Text('${prov.totalXp}',
                                style: tt.headlineMedium!.copyWith(color: cs.tertiary)),
                            Text('Total XP', style: tt.labelSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => prov.startNewRound(),
                    child: Text(
                      prov.roundsPlayed > 0 ? 'Play Again' : 'Start Round',
                      style: tt.labelLarge!.copyWith(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionScreen extends StatelessWidget {
  final ColorScheme cs;
  final TextTheme tt;
  final TriviaProvider prov;

  const _QuestionScreen({required this.cs, required this.tt, required this.prov});

  @override
  Widget build(BuildContext context) {
    final question = prov.currentQuestion!;
    final qIndex = prov.currentQuestionIndex;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Progress
              Row(
                children: [
                  Text(
                    'Round ${prov.currentRound!.roundNumber}',
                    style: tt.labelLarge!.copyWith(color: cs.primaryContainer),
                  ),
                  const Spacer(),
                  Text(
                    '${qIndex + 1}/${prov.questionsPerRound}',
                    style: tt.labelLarge!.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (qIndex + 1) / prov.questionsPerRound,
                  minHeight: 4,
                  backgroundColor: cs.surfaceContainerHigh,
                  color: cs.primaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              // Difficulty badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _difficultyColor(question.difficulty, cs).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  question.difficulty.toUpperCase(),
                  style: tt.labelSmall!.copyWith(
                    color: _difficultyColor(question.difficulty, cs),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Score
              Row(
                children: [
                  Icon(Icons.star, color: cs.tertiary, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    'Score: ${prov.currentRound!.score}',
                    style: tt.labelLarge!.copyWith(color: cs.tertiary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Question
              Text(question.question, style: tt.headlineSmall),
              const SizedBox(height: 24),
              // Options
              ...List.generate(question.options.length, (i) {
                final isSelected = prov.selectedAnswer == i;
                final isCorrect = question.isCorrect(i);
                final showResult = prov.answered;

                Color borderColor = cs.outlineVariant;
                Color bgColor = Colors.transparent;

                if (showResult) {
                  if (isCorrect) {
                    borderColor = cs.secondary;
                    bgColor = cs.secondary.withValues(alpha: 0.1);
                  } else if (isSelected && !isCorrect) {
                    borderColor = cs.error;
                    bgColor = cs.error.withValues(alpha: 0.1);
                  }
                } else if (isSelected) {
                  borderColor = cs.primaryContainer;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: prov.answered ? null : () => prov.selectAnswer(i),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: showResult && isCorrect
                                  ? cs.secondary.withValues(alpha: 0.2)
                                  : cs.surfaceContainerHigh,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: showResult
                                  ? Icon(
                                      isCorrect ? Icons.check : (isSelected ? Icons.close : null),
                                      size: 16,
                                      color: isCorrect ? cs.secondary : cs.error,
                                    )
                                  : Text(
                                      String.fromCharCode(65 + i),
                                      style: tt.labelLarge!.copyWith(
                                        color: isSelected ? cs.primaryContainer : cs.onSurfaceVariant,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              question.options[i],
                              style: tt.bodyMedium!.copyWith(
                                color: showResult && isCorrect
                                    ? cs.secondary
                                    : cs.onSurface,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              // Explanation
              if (prov.answered && question.explanation != null) ...[
                const SizedBox(height: 8),
                GlassCard(
                  borderRadius: 12,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb, color: cs.tertiary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          question.explanation!,
                          style: tt.bodySmall!.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // Next button
              if (prov.answered)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (qIndex < prov.questionsPerRound - 1) {
                        prov.nextQuestion();
                      } else {
                        prov.finishRound();
                      }
                    },
                    child: Text(
                      qIndex < prov.questionsPerRound - 1 ? 'Next Question' : 'See Results',
                      style: tt.labelLarge!.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Color _difficultyColor(String d, ColorScheme cs) {
    switch (d) {
      case 'easy':
        return cs.secondary;
      case 'hard':
        return cs.error;
      default:
        return cs.tertiary;
    }
  }
}

class _ResultScreen extends StatelessWidget {
  final ColorScheme cs;
  final TextTheme tt;
  final TriviaProvider prov;

  const _ResultScreen({required this.cs, required this.tt, required this.prov});

  @override
  Widget build(BuildContext context) {
    final round = prov.currentRound!;
    final correct = round.answers.entries
        .where((e) {
          final q = round.questions.firstWhere((q) => q.id == e.key);
          return q.isCorrect(e.value);
        })
        .length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  correct >= 4 ? Icons.emoji_events : Icons.sports_score,
                  size: 72,
                  color: correct >= 4 ? cs.tertiary : cs.primaryContainer,
                ),
                const SizedBox(height: 24),
                Text('Round Complete!', style: tt.headlineLarge!.copyWith(color: cs.primary)),
                const SizedBox(height: 24),
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        '$correct/${round.totalQuestions}',
                        style: tt.displayLarge!.copyWith(color: cs.primaryContainer),
                      ),
                      Text('Correct Answers', style: tt.bodyMedium),
                      const SizedBox(height: 16),
                      Divider(color: cs.outlineVariant.withValues(alpha: 0.3)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('+${round.score}',
                                  style: tt.headlineMedium!.copyWith(color: cs.tertiary)),
                              Text('XP Earned', style: tt.labelSmall),
                            ],
                          ),
                          Column(
                            children: [
                              Text('${prov.totalXp}',
                                  style: tt.headlineMedium!.copyWith(color: cs.primary)),
                              Text('Total XP', style: tt.labelSmall),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => prov.startNewRound(),
                    child: Text(
                      'Play Next Round',
                      style: tt.labelLarge!.copyWith(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => prov.reset(),
                  child: Text('Back to Menu', style: tt.labelLarge!.copyWith(color: cs.onSurfaceVariant)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
