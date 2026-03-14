import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Data models (UI-only)
// ---------------------------------------------------------------------------

enum _MessageSender { me, them }

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.sender,
    required this.time,
  });

  final String text;
  final _MessageSender sender;
  final String time;
}

const _demoMessages = <_ChatMessage>[
  _ChatMessage(
    text: "Hey! I really liked your voice intro 🎙️",
    sender: _MessageSender.me,
    time: '10:02 AM',
  ),
  _ChatMessage(
    text: "Aww thank you! Yours was so warm too 😊",
    sender: _MessageSender.them,
    time: '10:03 AM',
  ),
  _ChatMessage(
    text: "So you're into hiking? I know a great trail nearby 🥾",
    sender: _MessageSender.me,
    time: '10:04 AM',
  ),
  _ChatMessage(
    text: "No way! Tell me more ☕",
    sender: _MessageSender.them,
    time: '10:05 AM',
  ),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.matchName,
    required this.matchPhotoUrl,
  });

  final String matchName;
  final String matchPhotoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      appBar: _ChatAppBar(name: matchName, photoUrl: matchPhotoUrl),
      body: Column(
        children: [
          // Match banner
          const _MatchBanner(),
          // Messages list
          const Expanded(child: _MessageList()),
          // Input bar
          const _MessageInputBar(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// App Bar
// ---------------------------------------------------------------------------

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ChatAppBar({required this.name, required this.photoUrl});

  final String name;
  final String photoUrl;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF13131C),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(photoUrl),
            backgroundColor: const Color(0xFF2D1F4E),
          ),
          const SizedBox(width: 10),
          // Name + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'Active now',
                style: TextStyle(
                  color: Color(0xFF34D66E),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Voice call button
        Semantics(
          label: 'Voice call',
          button: true,
          child: IconButton(
            icon: const Icon(
              Icons.mic_rounded,
              color: Color(0xFFB66DFF),
              size: 26,
            ),
            onPressed: () {},
          ),
        ),
        // More options
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: Colors.white70),
          onPressed: () {},
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Match Banner
// ---------------------------------------------------------------------------

class _MatchBanner extends StatelessWidget {
  const _MatchBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2D1F4E), Color(0xFF13131C)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.white70),
              children: [
                TextSpan(text: "You and "),
                TextSpan(
                  text: "Sophia",
                  style: TextStyle(
                    color: Color(0xFFCBA6FF),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: " liked each other — start the conversation!"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Message List
// ---------------------------------------------------------------------------

class _MessageList extends StatelessWidget {
  const _MessageList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _demoMessages.length,
      itemBuilder: (context, index) {
        final msg = _demoMessages[index];
        final isMe = msg.sender == _MessageSender.me;
        return _MessageBubble(message: msg, isMe: isMe);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Message Bubble
// ---------------------------------------------------------------------------

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMe});

  final _ChatMessage message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            // Them avatar
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330'
                '?auto=format&fit=crop&w=100&q=80',
              ),
              backgroundColor: Color(0xFF2D1F4E),
            ),
            const SizedBox(width: 8),
          ],
          // Bubble
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.68,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: isMe
                        ? const LinearGradient(
                            colors: [Color(0xFF9B4DFF), Color(0xFF5E17EB)],
                          )
                        : null,
                    color: isMe ? null : const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isMe
                                ? const Color(0xFF7B2FFF)
                                : Colors.black)
                            .withOpacity(0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.white70,
                      fontSize: 14.5,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message.time,
                  style: const TextStyle(
                    color: Colors.white30,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Message Input Bar
// ---------------------------------------------------------------------------

class _MessageInputBar extends StatelessWidget {
  const _MessageInputBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF13131C),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
      child: Row(
        children: [
          // Voice message button
          Semantics(
            label: 'Send voice message',
            button: true,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9B4DFF), Color(0xFF5E17EB)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B2FFF).withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white12),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white, fontSize: 14.5),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type a message…',
                  hintStyle: TextStyle(color: Colors.white30),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Send button
          Semantics(
            label: 'Send message',
            button: true,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF2D1F4E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF7A3FD4)),
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Color(0xFFCBA6FF),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
