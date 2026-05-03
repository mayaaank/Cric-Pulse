import 'dart:async';
import 'package:flutter/material.dart';
import '../models/prediction.dart';
import '../providers/live_scores_provider.dart';

class PredictProvider extends ChangeNotifier {
  LiveScoresProvider? _liveProvider;
  final List<Prediction> _predictions = [];
  PredictionStats _stats = const PredictionStats();
  BallOutcome? _pendingPrediction;
  bool _waitingForResult = false;
  int _coins = 500;
  int _stake = 50;

  // Current match info
  String _currentMatchId = 'm1';
  String _currentOverInfo = 'Over 22.4';
  String _currentBowler = 'Bumrah';
  String _currentBatsman = 'Warner';

  List<Prediction> get predictions => List.unmodifiable(_predictions);
  PredictionStats get stats => _stats;
  BallOutcome? get pendingPrediction => _pendingPrediction;
  bool get waitingForResult => _waitingForResult;
  int get coins => _coins;
  int get stake => _stake;
  String get currentOverInfo => _currentOverInfo;
  String get currentBowler => _currentBowler;
  String get currentBatsman => _currentBatsman;
  String get currentMatchId => _currentMatchId;

  void setLiveProvider(LiveScoresProvider provider) {
    _liveProvider = provider;
    _updateMatchContext();
  }

  void _updateMatchContext() {
    if (_liveProvider == null) return;
    final live = _liveProvider!.liveMatches;
    if (live.isEmpty) return;
    final match = live.first;
    _currentMatchId = match.id;
    final inn = match.activeInnings;
    if (inn != null) {
      _currentOverInfo = 'Over ${inn.overs.toStringAsFixed(1)}';
      if (inn.currentBowler != null) {
        _currentBowler = inn.currentBowler!.name;
      }
      if (inn.striker != null) {
        _currentBatsman = inn.striker!.name;
      }
    }
  }

  void makePrediction(BallOutcome outcome) {
    if (_waitingForResult) return;

    _pendingPrediction = outcome;
    _waitingForResult = true;
    notifyListeners();

    // Simulate ball result after a delay
    Future.delayed(const Duration(seconds: 3), () {
      _resolvePrediction();
    });
  }

  void _resolvePrediction() {
    if (_pendingPrediction == null) return;

    // Determine actual outcome from live data or simulate
    final actual = _getActualOutcome();

    final prediction = Prediction(
      predicted: _pendingPrediction!,
      actual: actual,
      xpEarned: _pendingPrediction == actual
          ? Prediction.xpForOutcome(_pendingPrediction!) * _stats.multiplier
          : 0,
      timestamp: DateTime.now(),
      overInfo: _currentOverInfo,
    );

    final resolved = prediction;
    _predictions.insert(0, resolved);

    if (resolved.isCorrect) {
      final xp = resolved.xpEarned;
      _stats = _stats.copyWith(
        totalPredictions: _stats.totalPredictions + 1,
        correctPredictions: _stats.correctPredictions + 1,
        totalXp: _stats.totalXp + xp,
        currentStreak: _stats.currentStreak + 1,
        bestStreak: (_stats.currentStreak + 1) > _stats.bestStreak
            ? _stats.currentStreak + 1
            : _stats.bestStreak,
      );
      _coins += _stake * 2;
    } else {
      _stats = _stats.copyWith(
        totalPredictions: _stats.totalPredictions + 1,
        currentStreak: 0,
      );
      _coins -= _stake;
      if (_coins < 0) _coins = 0;
    }

    _pendingPrediction = null;
    _waitingForResult = false;
    _updateMatchContext();
    notifyListeners();
  }

  BallOutcome _getActualOutcome() {
    // Try to get from live data, fallback to simulation
    if (_liveProvider != null) {
      final live = _liveProvider!.liveMatches;
      if (live.isNotEmpty) {
        final inn = live.first.activeInnings;
        if (inn != null && inn.recentBalls.isNotEmpty) {
          final lastBall = inn.recentBalls.last;
          return _parseBallOutcome(lastBall);
        }
      }
    }
    // Simulate
    final outcomes = [
      BallOutcome.dot,
      BallOutcome.dot,
      BallOutcome.runs,
      BallOutcome.runs,
      BallOutcome.boundary,
      BallOutcome.wicket,
    ];
    outcomes.shuffle();
    return outcomes.first;
  }

  BallOutcome _parseBallOutcome(String ball) {
    switch (ball) {
      case '0':
        return BallOutcome.dot;
      case '4':
      case '6':
        return BallOutcome.boundary;
      case 'W':
        return BallOutcome.wicket;
      default:
        return BallOutcome.runs;
    }
  }

  void setStake(int value) {
    if (value > 0 && value <= _coins) {
      _stake = value;
      notifyListeners();
    }
  }
}
