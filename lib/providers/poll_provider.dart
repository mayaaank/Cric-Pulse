import 'dart:async';
import 'package:flutter/material.dart';
import '../models/poll.dart';
import '../services/poll_service.dart';

class PollProvider extends ChangeNotifier {
  final PollService _service = PollService();
  List<Poll> _polls = [];
  final Set<String> _votedPolls = {};
  StreamSubscription<List<Poll>>? _sub;

  List<Poll> get polls => _polls;
  bool hasVoted(String pollId) => _votedPolls.contains(pollId);

  void init() {
    _polls = _service.getActivePolls();
    notifyListeners();
    _sub = _service.pollStream().listen((updated) {
      _polls = updated;
      notifyListeners();
    });
  }

  Future<void> vote(String pollId, String option) async {
    if (_votedPolls.contains(pollId)) return;
    _votedPolls.add(pollId);
    await _service.vote(pollId, option);
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
