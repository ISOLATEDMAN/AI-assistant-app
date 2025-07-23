
import 'package:ass_app/services/ChatService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MeetingCard extends StatelessWidget {
  final MeetingInfo meeting;
  final VoidCallback onJoin;
  final VoidCallback onAddToCalendar;
  final VoidCallback onClose;

  const MeetingCard({
    super.key,
    required this.meeting,
    required this.onJoin,
    required this.onAddToCalendar,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.teal.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.video_call, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              const Text('Meeting Scheduled!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(onPressed: onClose, icon: const Icon(Icons.close, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Scheduled for: ${meeting.scheduledFor}', style: const TextStyle(color: Colors.white70)),
          Text('Type: ${meeting.meetingType}', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onJoin,
                  icon: const Icon(Icons.videocam, size: 18),
                  label: const Text('Join'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onAddToCalendar,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.2), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Icon(Icons.calendar_today, size: 18),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: meeting.meetingLink));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Meeting link copied!'), backgroundColor: Colors.green));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.2), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Icon(Icons.copy, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


