import 'dart:async';
import 'package:flutter/material.dart';
import '../models/poll.dart';
import '../services/poll_service.dart';

class PollProvider extends ChangeNotifier {
  final PollService _service = PollService();
  List<Poll> _polls = [];
  Set<String> _votedPolls = {};
  StreamSubscription<List<Poll>>? _sub;
  bool _loading = true;

  List<Poll> get polls => _polls;
  bool get loading => _loading;
  bool hasVoted(String pollId) => _votedPolls.contains(pollId);

  void init() {
    _loadInitial();
    _sub = _service.pollStream().listen((updated) {
      _polls = updated;
      notifyListeners();
    });
  }

  Future<void> _loadInitial() async {
    _loading = true;
    notifyListeners();

    _polls = await _service.getActivePolls();
    _votedPolls = await _service.loadVotedPollIds();

    _loading = false;
    notifyListeners();
  }

  Future<void> vote(String pollId, String option) async {
    if (_votedPolls.contains(pollId)) return;

    final poll = _polls.firstWhere((p) => p.id == pollId);

    try {
      await _service.vote(pollId, option, poll);
      _votedPolls.add(pollId);
      notifyListeners();
    } catch (e) {
      debugPrint('PollProvider.vote error: $e');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
