import 'dart:async';
import 'dart:math';
import '../models/poll.dart';

/// Poll service — uses local mock with simulated real-time updates.
/// Swap internals for Supabase real-time when project is connected.
class PollService {
  static final _rand = Random();

  static final List<Poll> _mockPolls = [
    Poll(
      id: 'poll1',
      question: 'Will this over go for 10+ runs?',
      options: ['Yes', 'No'],
      votes: {'Yes': 142, 'No': 218},
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      matchId: 'm1',
    ),
    Poll(
      id: 'poll2',
      question: 'Who will score the next boundary?',
      options: ['S. Smith', 'G. Maxwell', 'Neither'],
      votes: {'S. Smith': 87, 'G. Maxwell': 134, 'Neither': 45},
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      matchId: 'm1',
    ),
    Poll(
      id: 'poll3',
      question: 'Will Bumrah take a wicket in his next over?',
      options: ['Yes', 'No'],
      votes: {'Yes': 312, 'No': 178},
      createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      matchId: 'm1',
    ),
    Poll(
      id: 'poll4',
      question: 'What will be the total score of this innings?',
      options: ['Under 160', '160-180', '180-200', 'Over 200'],
      votes: {'Under 160': 56, '160-180': 123, '180-200': 198, 'Over 200': 89},
      createdAt: DateTime.now(),
      matchId: 'm1',
    ),
    Poll(
      id: 'poll5',
      question: 'Will Pakistan chase the target?',
      options: ['Yes, easily', 'Yes, close match', 'No'],
      votes: {'Yes, easily': 34, 'Yes, close match': 167, 'No': 245},
      createdAt: DateTime.now(),
      matchId: 'm2',
    ),
  ];

  List<Poll> getActivePolls() => List.from(_mockPolls);

  /// Simulates real-time vote updates.
  Stream<List<Poll>> pollStream() {
    return Stream.periodic(const Duration(seconds: 3), (_) {
      for (int i = 0; i < _mockPolls.length; i++) {
        final poll = _mockPolls[i];
        final newVotes = Map<String, int>.from(poll.votes);
        // Randomly add votes to simulate real-time
        final optionIndex = _rand.nextInt(poll.options.length);
        final option = poll.options[optionIndex];
        newVotes[option] = (newVotes[option] ?? 0) + _rand.nextInt(5) + 1;
        _mockPolls[i] = poll.copyWith(votes: newVotes);
      }
      return List<Poll>.from(_mockPolls);
    });
  }

  /// Vote on a poll.
  Future<Poll> vote(String pollId, String option) async {
    final idx = _mockPolls.indexWhere((p) => p.id == pollId);
    if (idx == -1) throw Exception('Poll not found');
    final poll = _mockPolls[idx];
    final newVotes = Map<String, int>.from(poll.votes);
    newVotes[option] = (newVotes[option] ?? 0) + 1;
    _mockPolls[idx] = poll.copyWith(votes: newVotes);
    return _mockPolls[idx];
  }
}
