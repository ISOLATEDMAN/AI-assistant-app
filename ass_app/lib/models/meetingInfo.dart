class MeetingInfo {
  final String id;
  final String meetingLink;
  final String calendarLink;
  final String scheduledFor;
  final String meetingType;

  MeetingInfo({
    required this.id,
    required this.meetingLink,
    required this.calendarLink,
    required this.scheduledFor,
    required this.meetingType,
  });

  factory MeetingInfo.fromJson(Map<String, dynamic> json) {
    return MeetingInfo(
      id: json['id'] ?? '',
      meetingLink: json['meetingLink'] ?? '',
      calendarLink: json['calendarLink'] ?? '',
      scheduledFor: json['scheduledFor'] ?? 'TBD',
      meetingType: json['meetingType'] ?? 'Demo',
    );
  }
}

/// A model to hold the combined response from the chat service.
class ChatResponse {
  final String message;
  final MeetingInfo? meeting;

  ChatResponse({required this.message, this.meeting});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      message: json['message'] ?? '',
      meeting: json['meeting'] != null
          ? MeetingInfo.fromJson(json['meeting'])
          : null,
    );
  }
}