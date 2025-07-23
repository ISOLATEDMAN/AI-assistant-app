



// lib/screens/chat_screen.dart

import 'package:ass_app/core/ParticularBg.dart';
import 'package:ass_app/models/particule.dart';
import 'package:ass_app/services/ChatService.dart';
import 'package:ass_app/widgets/buildInputArea.dart';
import 'package:ass_app/widgets/meetingcard.dart';
import 'package:ass_app/widgets/messbubble.dart';
import 'package:ass_app/widgets/typeInd.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // State
  final TextEditingController _textController = TextEditingController();
  final ChatService _chatService = ChatService();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _serverConnected = false;
  MeetingInfo? _currentMeeting;
  List<Particle> _particles = [];

  // Animation Controllers
  late AnimationController _connectionStatusController;
  late AnimationController _typingIndicatorController;
  late AnimationController _sendButtonController;
  late AnimationController _particleController;
  late AnimationController _meetingCardController;
  
  // Animations
  late Animation<double> _connectionPulseAnimation;
  late Animation<double> _sendButtonScaleAnimation;
  late Animation<double> _meetingCardAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeParticles();
    _checkServerConnection();
    _addInitialMessage();
  }

  void _initializeAnimations() {
    _connectionStatusController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _typingIndicatorController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _sendButtonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _particleController = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
    _meetingCardController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    
    _connectionPulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(CurvedAnimation(parent: _connectionStatusController, curve: Curves.easeInOut));
    _sendButtonScaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(parent: _sendButtonController, curve: Curves.easeInOut));
    _meetingCardAnimation = CurvedAnimation(parent: _meetingCardController, curve: Curves.easeOut);
  }

  void _initializeParticles() {
    _particles = List.generate(20, (index) => Particle(
      x: math.Random().nextDouble(), y: math.Random().nextDouble(),
      size: math.Random().nextDouble() * 4 + 1, speed: math.Random().nextDouble() * 0.02 + 0.01,
      opacity: math.Random().nextDouble() * 0.3 + 0.1,
    ));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _connectionStatusController.dispose();
    _typingIndicatorController.dispose();
    _sendButtonController.dispose();
    _particleController.dispose();
    _meetingCardController.dispose();
    _chatService.dispose();
    super.dispose();
  }

  void _addInitialMessage() {
    _messages.add(ChatMessage(role: 'assistant', content: "Hello! I'm Martin from LeadMate CRM. How can I help you today?"));
  }

  Future<void> _checkServerConnection() async {
    final isConnected = await _chatService.checkConnection();
    if (!mounted) return;
    setState(() => _serverConnected = isConnected);
    if (isConnected) {
      _connectionStatusController.stop();
    } else {
      _connectionStatusController.repeat(reverse: true);
      _showSnackBar('Could not connect to server.', isError: true);
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _textController.text.trim();
    if (messageText.isEmpty || _isLoading) return;

    _sendButtonController.forward().then((_) => _sendButtonController.reverse());
    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(role: 'user', content: messageText));
      _isLoading = true;
    });
    _typingIndicatorController.repeat();
    _scrollToBottom();

    try {
      final historyForAPI = _messages.where((m) => m != _messages.first).toList();
      final response = await _chatService.sendMessageWithMeeting(message: messageText, history: historyForAPI);
      if (!mounted) return;

      setState(() {
        _messages.add(ChatMessage(role: 'assistant', content: response.message));
        if (response.meeting != null) {
          _currentMeeting = response.meeting;
          _meetingCardController.forward();
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _messages.add(ChatMessage(role: 'assistant', content: "I'm having trouble connecting. Please try again.")));
      _showSnackBar('Failed to send message: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        _typingIndicatorController.stop();
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: Colors.grey.shade50,
        child: Stack(
          children: [
            ParticleBackground(particles: _particles, particleController: _particleController),
            Column(
              children: [
                if (_currentMeeting != null)
                  FadeTransition(
                    opacity: _meetingCardAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(_meetingCardAnimation),
                      child: MeetingCard(
                        meeting: _currentMeeting!,
                        onJoin: () async => await _chatService.joinMeeting(_currentMeeting!.meetingLink),
                        onAddToCalendar: () async => await _chatService.addToCalendar(_currentMeeting!.calendarLink),
                        onClose: () => setState(() {
                          _meetingCardController.reverse();
                          _currentMeeting = null;
                        }),
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return TypingIndicator(controller: _typingIndicatorController);
                      }
                      return MessageBubble(message: _messages[index]);
                    },
                  ),
                ),
                ChatInputArea(
                  controller: _textController,
                  isLoading: _isLoading,
                  isConnected: _serverConnected,
                  onSend: _sendMessage,
                  sendButtonScaleAnimation: _sendButtonScaleAnimation,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('LeadMate Chat', style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.purple.shade400]))),
      actions: [
        ScaleTransition(
          scale: _serverConnected ? const AlwaysStoppedAnimation(1.0) : _connectionPulseAnimation,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(_serverConnected ? Icons.cloud_done : Icons.cloud_off, color: _serverConnected ? Colors.lightGreenAccent : Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
