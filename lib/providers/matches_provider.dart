import 'package:flutter/material.dart';
import '../models/match.dart';
import '../services/mock_data_service.dart';

class MatchesProvider extends ChangeNotifier {
  List<Match> _allMatches = [];
  int _selectedTab = 0;

  List<Match> get allMatches => _allMatches;
  int get selectedTab => _selectedTab;

  static const tabLabels = ['All', 'Live', 'Upcoming', 'Completed'];

  List<Match> get filteredMatches {
    switch (_selectedTab) {
      case 1:
        return _allMatches.where((m) => m.status == MatchStatus.live).toList();
      case 2:
        return _allMatches.where((m) => m.status == MatchStatus.upcoming).toList();
      case 3:
        return _allMatches.where((m) => m.status == MatchStatus.completed).toList();
      default:
        return _allMatches;
    }
  }

  void init() {
    _allMatches = MockDataService.getMatches();
    notifyListeners();
  }

  void setTab(int idx) {
    _selectedTab = idx;
    notifyListeners();
  }

  void updateMatches(List<Match> matches) {
    _allMatches = matches;
    notifyListeners();
  }
}
