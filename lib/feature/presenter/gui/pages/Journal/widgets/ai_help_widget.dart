import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AIHelpWidget extends StatefulWidget {
  const AIHelpWidget({Key? key}) : super(key: key);

  @override
  _AIHelpWidgetState createState() => _AIHelpWidgetState();
}

class _AIHelpWidgetState extends State<AIHelpWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final PanelController _panelController = PanelController();
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final userMessage = _textController.text.trim();
    if (userMessage.isNotEmpty) {
      setState(() {
        _messages.add({'role': 'user', 'message': userMessage});
      });
      _textController.clear();

      // Simulate an AI response (replace with actual API call)
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add({
            'role': 'ai',
            'message':
                'Hello! How can I assist you today? This is a simulated response.'
          });
        });
      });
    }
  }

  void _togglePanel() {
    if (_panelController.isPanelOpen) {
      _panelController.close();
    } else {
      _panelController.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Sliding Up Panel
        SlidingUpPanel(
          controller: _panelController,
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),
          panel: _buildChatPanel(context),
        ),
        // Floating AI Chatbot Button with Pulse Animation
        Positioned(
          bottom: 20,
          right: 20,
          child: ScaleTransition(
            scale: _pulseAnimation,
            child: GestureDetector(
              onTap: _togglePanel,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Panel Header
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.waving_hand,
                        color: Colors.green, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'AI Assistant',
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.green),
                  onPressed: () => _panelController.close(),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1.0),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return ListTile(
                  leading: isUser
                      ? const Icon(Icons.person, color: Colors.blue)
                      : const Icon(Icons.smart_toy, color: Colors.green),
                  title: Text(
                    message['message'] ?? '',
                    style: TextStyle(
                      color: isUser ? Colors.black : Colors.green.shade700,
                      fontWeight: isUser ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.green),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
