import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/team.dart';
import '../services/mock_data_service.dart';

enum RankingCategory { batsmen, bowlers, teams }

class RankingsProvider extends ChangeNotifier {
  RankingCategory _category = RankingCategory.batsmen;
  int _sortColumn = 0;
  bool _sortAsc = true;

  RankingCategory get category => _category;
  int get sortColumn => _sortColumn;
  bool get sortAsc => _sortAsc;

  static const categoryLabels = ['Batsmen', 'Bowlers', 'Teams'];

  void setCategory(int idx) {
    _category = RankingCategory.values[idx];
    _sortColumn = 0;
    _sortAsc = true;
    notifyListeners();
  }

  void toggleSort(int col) {
    if (_sortColumn == col) {
      _sortAsc = !_sortAsc;
    } else {
      _sortColumn = col;
      _sortAsc = true;
    }
    notifyListeners();
  }

  List<Player> get rankedBatsmen {
    final list = MockDataService.players
        .where((p) => p.battingRank > 0)
        .toList();
    list.sort((a, b) {
      int cmp;
      switch (_sortColumn) {
        case 0:
          cmp = a.battingRank.compareTo(b.battingRank);
          break;
        case 1:
          cmp = a.battingStats.runs.compareTo(b.battingStats.runs);
          break;
        case 2:
          cmp = a.battingStats.average.compareTo(b.battingStats.average);
          break;
        case 3:
          cmp = a.battingStats.strikeRate.compareTo(b.battingStats.strikeRate);
          break;
        case 4:
          cmp = a.battingStats.hundreds.compareTo(b.battingStats.hundreds);
          break;
        default:
          cmp = a.battingRank.compareTo(b.battingRank);
      }
      return _sortAsc ? cmp : -cmp;
    });
    return list;
  }

  List<Player> get rankedBowlers {
    final list = MockDataService.players
        .where((p) => p.bowlingRank > 0)
        .toList();
    list.sort((a, b) {
      int cmp;
      switch (_sortColumn) {
        case 0:
          cmp = a.bowlingRank.compareTo(b.bowlingRank);
          break;
        case 1:
          cmp = a.bowlingStats.wickets.compareTo(b.bowlingStats.wickets);
          break;
        case 2:
          cmp = a.bowlingStats.economy.compareTo(b.bowlingStats.economy);
          break;
        case 3:
          cmp = a.bowlingStats.average.compareTo(b.bowlingStats.average);
          break;
        default:
          cmp = a.bowlingRank.compareTo(b.bowlingRank);
      }
      return _sortAsc ? cmp : -cmp;
    });
    return list;
  }

  List<Team> get rankedTeams {
    final list = List<Team>.from(MockDataService.teams);
    list.sort((a, b) {
      int cmp;
      switch (_sortColumn) {
        case 0:
          cmp = a.iccRanking.compareTo(b.iccRanking);
          break;
        case 1:
          cmp = a.wins.compareTo(b.wins);
          break;
        case 2:
          cmp = a.matchesPlayed.compareTo(b.matchesPlayed);
          break;
        case 3:
          cmp = a.winPercentage.compareTo(b.winPercentage);
          break;
        default:
          cmp = a.iccRanking.compareTo(b.iccRanking);
      }
      return _sortAsc ? cmp : -cmp;
    });
    return list;
  }
}
