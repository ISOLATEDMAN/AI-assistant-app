import 'package:flutter/material.dart';

class ChatInputArea extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final bool isConnected;
  final VoidCallback onSend;
  final Animation<double> sendButtonScaleAnimation;

  const ChatInputArea({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.isConnected,
    required this.onSend,
    required this.sendButtonScaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(25)),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'Type your message...', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                  onSubmitted: (_) => onSend(),
                  enabled: !isLoading && isConnected,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 12),
            AnimatedBuilder(
              animation: sendButtonScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: sendButtonScaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.purple.shade400]),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: (isLoading || !isConnected) ? null : onSend,
                      icon: isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}