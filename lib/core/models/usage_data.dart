import 'package:equatable/equatable.dart';

/// Model for tracking app usage following mental health principles
class UsageData extends Equatable {
  final DateTime date;
  final Duration totalUsageTime;
  final int sessionCount;
  final List<SessionData> sessions;
  final Map<String, int> moduleUsage; // moduleId -> minutes spent
  final int engagementScore; // 1-5 scale based on interaction

  const UsageData({
    required this.date,
    required this.totalUsageTime,
    required this.sessionCount,
    required this.sessions,
    required this.moduleUsage,
    required this.engagementScore,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'totalUsageTime': totalUsageTime.inMinutes,
        'sessionCount': sessionCount,
        'sessions': sessions.map((s) => s.toJson()).toList(),
        'moduleUsage': moduleUsage,
        'engagementScore': engagementScore,
      };

  factory UsageData.fromJson(Map<String, dynamic> json) => UsageData(
        date: DateTime.parse(json['date']),
        totalUsageTime: Duration(minutes: json['totalUsageTime']),
        sessionCount: json['sessionCount'],
        sessions: (json['sessions'] as List)
            .map((s) => SessionData.fromJson(s))
            .toList(),
        moduleUsage: Map<String, int>.from(json['moduleUsage']),
        engagementScore: json['engagementScore'],
      );

  UsageData copyWith({
    DateTime? date,
    Duration? totalUsageTime,
    int? sessionCount,
    List<SessionData>? sessions,
    Map<String, int>? moduleUsage,
    int? engagementScore,
  }) {
    return UsageData(
      date: date ?? this.date,
      totalUsageTime: totalUsageTime ?? this.totalUsageTime,
      sessionCount: sessionCount ?? this.sessionCount,
      sessions: sessions ?? this.sessions,
      moduleUsage: moduleUsage ?? this.moduleUsage,
      engagementScore: engagementScore ?? this.engagementScore,
    );
  }

  @override
  List<Object?> get props => [
        date,
        totalUsageTime,
        sessionCount,
        sessions,
        moduleUsage,
        engagementScore,
      ];
}

class SessionData extends Equatable {
  final DateTime startTime;
  final DateTime? endTime;
  final Duration duration;
  final String? moduleId;

  const SessionData({
    required this.startTime,
    this.endTime,
    required this.duration,
    this.moduleId,
  });

  Map<String, dynamic> toJson() => {
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'duration': duration.inMinutes,
        'moduleId': moduleId,
      };

  factory SessionData.fromJson(Map<String, dynamic> json) => SessionData(
        startTime: DateTime.parse(json['startTime']),
        endTime: json['endTime'] != null
            ? DateTime.parse(json['endTime'])
            : null,
        duration: Duration(minutes: json['duration']),
        moduleId: json['moduleId'],
      );

  @override
  List<Object?> get props => [startTime, endTime, duration, moduleId];
}
