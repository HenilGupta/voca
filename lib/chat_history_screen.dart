import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// Data Models
// ---------------------------------------------------------------------------

class ChatHistoryUser {
  const ChatHistoryUser({
    required this.id,
    required this.name,
    required this.age,
    required this.photoUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isOnline,
    required this.bio,
    required this.interests,
    required this.voiceDuration,
  });

  final String id;
  final String name;
  final int age;
  final String photoUrl;
  final String lastMessage;
  final String lastMessageTime;
  final bool isOnline;
  final String bio;
  final List<String> interests;
  final String voiceDuration;
}

const List<ChatHistoryUser> _demoUsers = [
  ChatHistoryUser(
    id: '1',
    name: 'Sophia',
    age: 25,
    photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330'
        '?auto=format&fit=crop&w=400&q=80',
    lastMessage: 'That sounds amazing! When are you free? 🎉',
    lastMessageTime: '2 min ago',
    isOnline: true,
    bio: 'Loves hiking, coffee dates ☕ and finding hidden city gems.',
    interests: ['Travel', 'Foodie', 'Music', 'Hiking'],
    voiceDuration: '0:12',
  ),
  ChatHistoryUser(
    id: '2',
    name: 'Emma',
    age: 23,
    photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d'
        '?auto=format&fit=crop&w=400&q=80',
    lastMessage: 'I had a great time chatting with you!',
    lastMessageTime: '1 hour ago',
    isOnline: false,
    bio: 'Artist and adventure seeker. Love museums and nature walks.',
    interests: ['Art', 'Travel', 'Photography'],
    voiceDuration: '0:15',
  ),
  ChatHistoryUser(
    id: '3',
    name: 'Olivia',
    age: 26,
    photoUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80'
        '?auto=format&fit=crop&w=400&q=80',
    lastMessage: 'Let me know when you want to grab coffee!',
    lastMessageTime: '5 hours ago',
    isOnline: true,
    bio: 'Entrepreneur, yoga enthusiast, book lover. Always up for new experiences.',
    interests: ['Yoga', 'Reading', 'Business', 'Travel'],
    voiceDuration: '0:18',
  ),
  ChatHistoryUser(
    id: '4',
    name: 'Isabella',
    age: 24,
    photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330'
        '?auto=format&fit=crop&w=400&q=80',
    lastMessage: 'Looking forward to hearing from you soon! 😊',
    lastMessageTime: '1 day ago',
    isOnline: false,
    bio: 'Music producer and festival lover. Let\'s create memories together!',
    interests: ['Music', 'Festivals', 'Dancing', 'Social'],
    voiceDuration: '0:14',
  ),
  ChatHistoryUser(
    id: '5',
    name: 'Mia',
    age: 25,
    photoUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80'
        '?auto=format&fit=crop&w=400&q=80',
    lastMessage: 'Thanks for the hiking recommendations! 🥾',
    lastMessageTime: '2 days ago',
    isOnline: true,
    bio: 'Outdoor enthusiast, coffee addict, adventure planner.',
    interests: ['Hiking', 'Coffee', 'Adventure', 'Photography'],
    voiceDuration: '0:13',
  ),
];

// ---------------------------------------------------------------------------
// Chat History Screen
// ---------------------------------------------------------------------------

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  void _goToChat(BuildContext context, ChatHistoryUser user) {
    context.pushNamed(
      'chat',
      queryParameters: {
        'name': user.name,
        'photo': user.photoUrl,
        'age': user.age.toString(),
        'bio': user.bio,
        'interests': user.interests.join('|'),
        'voice': user.voiceDuration,
        'chatUnlocked': 'true', // Mark chat as unlocked (no Q&A needed)
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF13131C),
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _demoUsers.length,
        itemBuilder: (context, index) {
          final user = _demoUsers[index];
          return _ChatHistoryCard(
            user: user,
            onTap: () => _goToChat(context, user),
          );
        },
      ),
      bottomNavigationBar: _BottomNavBar(
        onMatchesPressed: () {
          context.goNamed('profile');
        },
        onChatPressed: () {
          // Already on chat history screen
        },
        onProfilePressed: () {
          context.goNamed('profile-screen');
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Chat History Card
// ---------------------------------------------------------------------------

class _ChatHistoryCard extends StatelessWidget {
  const _ChatHistoryCard({
    required this.user,
    required this.onTap,
  });

  final ChatHistoryUser user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2D1F4E)),
        ),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                ClipOval(
                  child: Image.network(
                    user.photoUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 60,
                      height: 60,
                      color: const Color(0xFF2D1F4E),
                      child: const Icon(Icons.person, color: Colors.white30),
                    ),
                  ),
                ),
                if (user.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF34D66E),
                        border: Border.all(color: const Color(0xFF0F0F14), width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${user.name}, ${user.age}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        user.lastMessageTime,
                        style: const TextStyle(
                          color: Colors.white30,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Chat icon
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white30,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom Navigation Bar
// ---------------------------------------------------------------------------

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.onMatchesPressed,
    required this.onChatPressed,
    required this.onProfilePressed,
  });

  final VoidCallback onMatchesPressed;
  final VoidCallback onChatPressed;
  final VoidCallback onProfilePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF13131C),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Matchs button
            _NavBarItem(
              icon: Icons.favorite_rounded,
              label: 'Matchs',
              isActive: false,
              onTap: onMatchesPressed,
            ),
            // Chat button
            _NavBarItem(
              icon: Icons.message_rounded,
              label: 'Chat',
              isActive: true,
              onTap: onChatPressed,
            ),
            // Profile button
            _NavBarItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              isActive: false,
              onTap: onProfilePressed,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Navigation Bar Item
// ---------------------------------------------------------------------------

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF9B4DFF) : Colors.white54,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF9B4DFF) : Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (isActive)
            Container(
              width: 24,
              height: 2,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF9B4DFF),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
        ],
      ),
    );
  }
}

