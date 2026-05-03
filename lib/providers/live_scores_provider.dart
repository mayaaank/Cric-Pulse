import 'dart:async';
import 'package:flutter/material.dart';
import '../models/match.dart';
import '../models/score.dart';
import '../services/mock_data_service.dart';

class LiveScoresProvider extends ChangeNotifier {
  List<Match> _matches = [];
  StreamSubscription<Map<String, InningsData>>? _sub;

  List<Match> get liveMatches =>
      _matches.where((m) => m.status == MatchStatus.live).toList();

  List<Match> get allMatches => _matches;

  void init() {
    _matches = MockDataService.getMatches();
    notifyListeners();
    _sub = MockDataService.liveScoreStream().listen(_onUpdate);
  }

  void _onUpdate(Map<String, InningsData> updates) {
    bool changed = false;
    for (int i = 0; i < _matches.length; i++) {
      final update = updates[_matches[i].id];
      if (update != null) {
        final m = _matches[i];
        if (update.inningsNumber == 2) {
          _matches[i] = m.copyWith(innings2: update);
        } else {
          _matches[i] = m.copyWith(innings1: update);
        }
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  Future<void> refresh() async {
    _matches = MockDataService.getMatches();
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
