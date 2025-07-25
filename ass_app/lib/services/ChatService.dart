import 'dart:async';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

// --- Data Models (Unchanged) ---

class ChatMessage {
  final String role;
  final String content;

  ChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() {
    return {'role': role, 'content': content};
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] ?? '',
      content: json['content'] ?? '',
    );
  }
}

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
      scheduledFor: json['scheduledFor'] ?? '',
      meetingType: json['meetingType'] ?? 'Demo',
    );
  }
}

class MeetingDetails {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String preferredDate;
  final String preferredTime;
  final String meetingType;
  final String notes;
  final String status;
  final String createdAt;
  final String meetingLink;
  final String calendarLink;

  MeetingDetails({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.preferredDate,
    required this.preferredTime,
    required this.meetingType,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.meetingLink,
    required this.calendarLink,
  });

  factory MeetingDetails.fromJson(Map<String, dynamic> json) {
    return MeetingDetails(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      preferredDate: json['preferredDate'] ?? '',
      preferredTime: json['preferredTime'] ?? '',
      meetingType: json['meetingType'] ?? '',
      notes: json['notes'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      meetingLink: json['meetingLink'] ?? '',
      calendarLink: json['calendarLink'] ?? '',
    );
  }
}

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


// --- Refactored ChatService with Dio ---

class ChatService {
  static const String _baseUrl = 'https://ai-assistant-backend-eta.vercel.app';
  late final Dio _dio;

  ChatService() {
    // Configure Dio instance with base options
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
  }

  /// Handles Dio exceptions and converts them to a user-friendly message.
  String _handleError(DioException e) {
    print('Dio error: ${e.message}');
    if (e.type == DioExceptionType.connectionTimeout || 
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Network error: The connection timed out.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Network error: Could not connect to server. Please check your connection and if the server is running.';
    }
    if (e.response != null) {
      // Extract error message from server response if available
      final errorData = e.response!.data as Map<String, dynamic>?;
      final serverMessage = errorData?['error'] ?? 'An unknown server error occurred.';
      return 'Server error (${e.response!.statusCode}): $serverMessage';
    }
    return 'An unexpected error occurred: ${e.message}';
  }

  /// Send message and potentially receive meeting info
  Future<ChatResponse> sendMessageWithMeeting({
    required String message,
    required List<ChatMessage> history,
  }) async {
    try {
      final body = {
        'message': message,
        'history': history.map((msg) => msg.toJson()).toList(),
      };

      final response = await _dio.post('/chat', data: body);

      return ChatResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Backward compatibility method
  Future<String> sendMessage({
    required String message,
    required List<ChatMessage> history,
  }) async {
    final response = await sendMessageWithMeeting(
      message: message,
      history: history,
    );
    return response.message;
  }

  /// Get all meetings
  Future<List<MeetingDetails>> getAllMeetings() async {
    try {
      final response = await _dio.get('/meetings');
      final meetingsList = response.data['meetings'] as List<dynamic>;
      
      return meetingsList
          .map((meeting) => MeetingDetails.fromJson(meeting as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    } catch (e) {
      throw Exception('Error fetching meetings: ${e.toString()}');
    }
  }

  /// Get specific meeting
  Future<MeetingDetails> getMeeting(String meetingId) async {
    try {
      final response = await _dio.get('/meetings/$meetingId');
      final meetingData = response.data['meeting'] as Map<String, dynamic>;
      return MeetingDetails.fromJson(meetingData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Meeting not found');
      }
      throw Exception(_handleError(e));
    } catch (e) {
      throw Exception('Error fetching meeting: ${e.toString()}');
    }
  }

  /// Cancel meeting
  Future<void> cancelMeeting(String meetingId) async {
    try {
      await _dio.delete('/meetings/$meetingId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Meeting not found');
      }
      throw Exception(_handleError(e));
    } catch (e) {
      throw Exception('Error canceling meeting: ${e.toString()}');
    }
  }

  /// Reschedule meeting
  Future<MeetingDetails> rescheduleMeeting({
    required String meetingId,
    String? preferredDate,
    String? preferredTime,
  }) async {
    try {
      final body = {
        if (preferredDate != null) 'preferredDate': preferredDate,
        if (preferredTime != null) 'preferredTime': preferredTime,
      };

      final response = await _dio.put('/meetings/$meetingId', data: body);
      final meetingData = response.data['meeting'] as Map<String, dynamic>;
      return MeetingDetails.fromJson(meetingData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Meeting not found');
      }
      throw Exception(_handleError(e));
    } catch (e) {
      throw Exception('Error rescheduling meeting: ${e.toString()}');
    }
  }

  /// Launch meeting link
  Future<void> joinMeeting(String meetingLink) async {
    final uri = Uri.parse(meetingLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch meeting link: $meetingLink');
    }
  }

  /// Add to calendar
  Future<void> addToCalendar(String calendarLink) async {
    final uri = Uri.parse(calendarLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not open calendar link: $calendarLink');
    }
  }

  /// Check server connection
  Future<bool> checkConnection() async {
    try {
      // Use a lightweight endpoint like the base URL for the health check.
      await _dio.get('/', options: Options(receiveTimeout: const Duration(seconds: 5)));
      return true;
    } catch (e) {
      print('Connection check failed: $e');
      return false;
    }
  }

  /// Dispose of the Dio client
  void dispose() {
    _dio.close();
  }
}