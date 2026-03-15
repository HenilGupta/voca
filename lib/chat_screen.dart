import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// Data models
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

class _QuestionItem {
  const _QuestionItem({
    required this.question,
    required this.options,
  });

  final String question;
  final List<String> options;
}

const List<_QuestionItem> _hardcodedQuestions = [
  _QuestionItem(
    question: 'What is your music taste?',
    options: ['Pop', 'Rock', 'Indie', 'R&B'],
  ),
  _QuestionItem(
    question: 'Which weather do you like?',
    options: ['Sunny', 'Rainy', 'Snowy', 'Cloudy'],
  ),
  _QuestionItem(
    question: 'Which sport do you play?',
    options: ['Football', 'Tennis', 'Badminton', 'Swimming'],
  ),
  _QuestionItem(
    question: 'Which type of place do you like to visit?',
    options: ['Beach', 'Mountains', 'City', 'Countryside'],
  ),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.matchName,
    required this.matchPhotoUrl,
  });

  final String matchName;
  final String matchPhotoUrl;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [];

  static const int _maxQuestionRounds = 6;
  int _questionRound = 0;
  bool _isMyTurnToAsk = true;
  bool _chatUnlocked = false;

  _QuestionItem? _activeQuestion;
  _MessageSender? _activeQuestionFrom;

  @override
  void initState() {
    super.initState();
    _showNextQuestion();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _timeNow() {
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');
    final amPm = now.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $amPm';
  }

  _QuestionItem _pickQuestionForRound(int round) {
    return _hardcodedQuestions[round % _hardcodedQuestions.length];
  }

  void _showNextQuestion() {
    if (_questionRound >= _maxQuestionRounds) {
      setState(() {
        _chatUnlocked = true;
        _activeQuestion = null;
        _activeQuestionFrom = null;
        _messages.add(
          _ChatMessage(
            text:
            'Great! You both answered enough questions. Chat is now unlocked 🎉',
            sender: _MessageSender.them,
            time: _timeNow(),
          ),
        );
      });
      _scrollToBottom();
      return;
    }

    final sender = _isMyTurnToAsk ? _MessageSender.me : _MessageSender.them;
    final q = _pickQuestionForRound(_questionRound);

    setState(() {
      _activeQuestion = q;
      _activeQuestionFrom = sender;
      _messages.add(
        _ChatMessage(
          text: q.question,
          sender: sender,
          time: _timeNow(),
        ),
      );
    });

    _scrollToBottom();
  }

  void _onOptionTap(String selectedOption) {
    if (_activeQuestion == null || _activeQuestionFrom == null) return;

    // The responder is the opposite side from who asked the question.
    final responder =
    _activeQuestionFrom == _MessageSender.me ? _MessageSender.them : _MessageSender.me;

    setState(() {
      _messages.add(
        _ChatMessage(
          text: selectedOption,
          sender: responder,
          time: _timeNow(),
        ),
      );

      _questionRound += 1;
      _isMyTurnToAsk = !_isMyTurnToAsk;
      _activeQuestion = null;
      _activeQuestionFrom = null;
    });

    _scrollToBottom();

    Future<void>.delayed(const Duration(milliseconds: 350), _showNextQuestion);
  }

  void _sendTextMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || !_chatUnlocked) return;

    setState(() {
      _messages.add(
        _ChatMessage(
          text: text,
          sender: _MessageSender.me,
          time: _timeNow(),
        ),
      );
      _messageController.clear();
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _goToProfileInfo() {
    context.pushNamed(
      'profile-info',
      queryParameters: {
        'name': widget.matchName,
        'photo': widget.matchPhotoUrl,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionProgress = '${_questionRound.clamp(0, _maxQuestionRounds)}/$_maxQuestionRounds';

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      appBar: _ChatAppBar(
        name: widget.matchName,
        photoUrl: widget.matchPhotoUrl,
        onProfileTap: _goToProfileInfo,
      ),
      body: Column(
        children: [
          _TopBanner(
            chatUnlocked: _chatUnlocked,
            progressText: questionProgress,
            name: widget.matchName,
          ),
          Expanded(
            child: _MessageList(
              messages: _messages,
              matchPhotoUrl: widget.matchPhotoUrl,
              scrollController: _scrollController,
            ),
          ),
          if (!_chatUnlocked && _activeQuestion != null)
            _QuestionOptionsCard(
              question: _activeQuestion!,
              askedBy: _activeQuestionFrom!,
              onOptionTap: _onOptionTap,
            ),
          if (_chatUnlocked)
            _MessageInputBar(
              controller: _messageController,
              onSendTap: _sendTextMessage,
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// App Bar
// ---------------------------------------------------------------------------

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ChatAppBar({
    required this.name,
    required this.photoUrl,
    required this.onProfileTap,
  });

  final String name;
  final String photoUrl;
  final VoidCallback onProfileTap;

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
      title: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onProfileTap,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(photoUrl),
              backgroundColor: const Color(0xFF2D1F4E),
            ),
            const SizedBox(width: 10),
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
                  'Tap to view profile',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: Colors.white70),
          onPressed: () {},
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Top Banner
// ---------------------------------------------------------------------------

class _TopBanner extends StatelessWidget {
  const _TopBanner({
    required this.chatUnlocked,
    required this.progressText,
    required this.name,
  });

  final bool chatUnlocked;
  final String progressText;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2D1F4E), Color(0xFF13131C)],
        ),
      ),
      child: Text(
        chatUnlocked
            ? 'Chat unlocked with $name. You can now send text and voice messages.'
            : 'Question round: $progressText. Answer each other to unlock chat.',
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Message List
// ---------------------------------------------------------------------------

class _MessageList extends StatelessWidget {
  const _MessageList({
    required this.messages,
    required this.matchPhotoUrl,
    required this.scrollController,
  });

  final List<_ChatMessage> messages;
  final String matchPhotoUrl;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isMe = msg.sender == _MessageSender.me;
        return _MessageBubble(
          message: msg,
          isMe: isMe,
          matchPhotoUrl: matchPhotoUrl,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Message Bubble
// ---------------------------------------------------------------------------

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.matchPhotoUrl,
  });

  final _ChatMessage message;
  final bool isMe;
  final String matchPhotoUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(matchPhotoUrl),
              backgroundColor: const Color(0xFF2D1F4E),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.68,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                        color: (isMe ? const Color(0xFF7B2FFF) : Colors.black)
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
// Question Options Card
// ---------------------------------------------------------------------------

class _QuestionOptionsCard extends StatelessWidget {
  const _QuestionOptionsCard({
    required this.question,
    required this.askedBy,
    required this.onOptionTap,
  });

  final _QuestionItem question;
  final _MessageSender askedBy;
  final ValueChanged<String> onOptionTap;

  @override
  Widget build(BuildContext context) {
    final responderName = askedBy == _MessageSender.me ? 'Match' : 'You';

    return Container(
      width: double.infinity,
      color: const Color(0xFF13131C),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A24),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2D1F4E)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$responderName, choose one option:',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: question.options
                  .map(
                    (option) => GestureDetector(
                  onTap: () => onOptionTap(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D1F4E),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFF7A3FD4)),
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(
                        color: Color(0xFFCBA6FF),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Message Input Bar (Unlocked state)
// ---------------------------------------------------------------------------

class _MessageInputBar extends StatelessWidget {
  const _MessageInputBar({
    required this.controller,
    required this.onSendTap,
  });

  final TextEditingController controller;
  final VoidCallback onSendTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF13131C),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
      child: Row(
        children: [
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white12),
              ),
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white, fontSize: 14.5),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.white30),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Semantics(
            label: 'Send message',
            button: true,
            child: GestureDetector(
              onTap: onSendTap,
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
