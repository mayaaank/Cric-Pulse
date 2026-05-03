import 'score.dart';
import 'team.dart';

export 'team.dart';

enum MatchStatus { live, upcoming, completed }

enum MatchFormat { t20, odi, test }

class Match {
  final String id;
  final Team homeTeam;
  final Team awayTeam;
  final String venue;
  final DateTime dateTime;
  final MatchStatus status;
  final MatchFormat format;
  final String? result;
  final InningsData? innings1;
  final InningsData? innings2;

  const Match({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.venue,
    required this.dateTime,
    required this.status,
    required this.format,
    this.result,
    this.innings1,
    this.innings2,
  });

  String get formatLabel {
    switch (format) {
      case MatchFormat.t20:
        return 'T20';
      case MatchFormat.odi:
        return 'ODI';
      case MatchFormat.test:
        return 'TEST';
    }
  }

  String get statusLabel {
    switch (status) {
      case MatchStatus.live:
        return 'LIVE';
      case MatchStatus.upcoming:
        return 'UPCOMING';
      case MatchStatus.completed:
        return 'COMPLETED';
    }
  }

  InningsData? get activeInnings =>
      innings2 != null && !innings2!.isCompleted ? innings2 : innings1;

  Match copyWith({
    InningsData? innings1,
    InningsData? innings2,
    String? result,
    MatchStatus? status,
  }) {
    return Match(
      id: id,
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      venue: venue,
      dateTime: dateTime,
      status: status ?? this.status,
      format: format,
      result: result ?? this.result,
      innings1: innings1 ?? this.innings1,
      innings2: innings2 ?? this.innings2,
    );
  }
}
