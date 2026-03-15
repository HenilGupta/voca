import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// Data model (UI-only, no business logic)
// ---------------------------------------------------------------------------

class ProfileModel {
  const ProfileModel({
    required this.name,
    required this.age,
    required this.bio,
    required this.interests,
    required this.photoUrl,
    required this.photoDescription,
    required this.voiceDuration,
  });

  final String name;
  final int age;
  final String bio;
  final List<String> interests;
  final String photoUrl;
  final String photoDescription;
  final String voiceDuration;
}

const _demoProfile = ProfileModel(
  name: 'Sophia',
  age: 25,
  bio: 'Loves hiking, coffee dates ☕ and finding hidden city gems.',
  interests: ['Travel', 'Foodie', 'Music', 'Hiking'],
  photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330'
      '?auto=format&fit=crop&w=800&q=80',
  photoDescription:
      'Sophia smiling outdoors with sunlight in the background.',
  voiceDuration: '0:12',
);

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class DatingScreen extends StatelessWidget {
  const DatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _ProfileCard(profile: _demoProfile),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile Card
// ---------------------------------------------------------------------------

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.55),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          children: [
            // ── Photo ──────────────────────────────────────────────────────
            Expanded(
              flex: 58,
              child: _PhotoSection(profile: profile),
            ),
            // ── Info + Voice ───────────────────────────────────────────────
            _InfoSection(profile: profile),
            // ── Action Buttons ─────────────────────────────────────────────
            _ActionBar(profile: profile),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Photo Section
// ---------------------------------------------------------------------------

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background photo
        Image.network(
          profile.photoUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              color: const Color(0xFF1C1C26),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFB66DFF),
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF1C1C26),
            child: const Icon(Icons.person, color: Colors.white30, size: 80),
          ),
        ),

        // Bottom gradient for readability
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.50, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.65),
                ],
              ),
            ),
          ),
        ),

        // Photo description accessibility button (top-right)
        Positioned(
          top: 14,
          right: 14,
          child: _PhotoDescriptionButton(
            description: profile.photoDescription,
          ),
        ),

        // Name + age floating at bottom-left of photo
        Positioned(
          left: 18,
          bottom: 18,
          child: _PhotoNameOverlay(profile: profile),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Photo Description Accessibility Button
// ---------------------------------------------------------------------------

class _PhotoDescriptionButton extends StatelessWidget {
  const _PhotoDescriptionButton({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Photo description',
      button: true,
      child: GestureDetector(
        onTap: () => _showDescription(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.52),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image_search_rounded,
                  color: Colors.white, size: 15),
              SizedBox(width: 5),
              Text(
                'Photo Description',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDescription(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1C1C2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Photo Description',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Name overlay on photo
// ---------------------------------------------------------------------------

class _PhotoNameOverlay extends StatelessWidget {
  const _PhotoNameOverlay({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${profile.name}, ${profile.age}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
            shadows: [
              Shadow(blurRadius: 8, color: Colors.black54),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Info Section
// ---------------------------------------------------------------------------

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A1A24),
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bio + chips
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bio
                Text(
                  profile.bio,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                // Interest tags
                Wrap(
                  spacing: 7,
                  runSpacing: 6,
                  children: profile.interests
                      .map((tag) => _InterestChip(label: tag))
                      .toList(),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Voice intro button
          _VoiceIntroButton(duration: profile.voiceDuration),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Interest Chip
// ---------------------------------------------------------------------------

class _InterestChip extends StatelessWidget {
  const _InterestChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1F4E),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF7A3FD4), width: 1),
      ),
      child: Text(
        '# $label',
        style: const TextStyle(
          color: Color(0xFFCBA6FF),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Voice Intro Button
// ---------------------------------------------------------------------------

class _VoiceIntroButton extends StatelessWidget {
  const _VoiceIntroButton({required this.duration});

  final String duration;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Play voice introduction, duration $duration',
      button: true,
      child: GestureDetector(
        onTap: () {
          // Hook up audio playback here
        },
        child: Container(
          width: 62,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF9B4DFF), Color(0xFF5E17EB)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B2FFF).withOpacity(0.45),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(height: 5),
              Text(
                '🔊 $duration',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action Bar
// ---------------------------------------------------------------------------

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF13131C),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Row(
        children: [
          // Pass
          Expanded(
            child: _ActionButton(
              label: 'Pass',
              emoji: '❌',
              backgroundColor: const Color(0xFF1E1E2C),
              borderColor: const Color(0xFFFF4566),
              labelColor: const Color(0xFFFF4566),
              onTap: () {},
            ),
          ),
          const SizedBox(width: 16),
          // Like
          Expanded(
            child: _ActionButton(
              label: 'Like',
              emoji: '❤️',
              backgroundColor: const Color(0xFF1E2C1E),
              borderColor: const Color(0xFF34D66E),
              labelColor: const Color(0xFF34D66E),
              onTap: () => _onLike(context),
            ),
          ),
        ],
      ),
    );
  }

  void _onLike(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(scale: Tween(begin: 0.88, end: 1.0).animate(
          CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
        ), child: child),
      ),
      pageBuilder: (dialogContext, _, __) => _MatchOverlay(
        profile: profile,
        onStartChat: () {
          Navigator.of(dialogContext).pop();
          context.goNamed(
            'chat',
            queryParameters: {
              'name': profile.name,
              'photo': profile.photoUrl,
              'age': profile.age.toString(),
              'bio': profile.bio,
              'interests': profile.interests.join('|'),
              'voice': profile.voiceDuration,
            },
          );
        },
        onKeepSwiping: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action Button
// ---------------------------------------------------------------------------

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.emoji,
    required this.backgroundColor,
    required this.borderColor,
    required this.labelColor,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final Color backgroundColor;
  final Color borderColor;
  final Color labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1.6),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.22),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Match Overlay (shown after Like tap)
// ---------------------------------------------------------------------------

class _MatchOverlay extends StatelessWidget {
  const _MatchOverlay({
    required this.profile,
    required this.onStartChat,
    required this.onKeepSwiping,
  });

  final ProfileModel profile;
  final VoidCallback onStartChat;
  final VoidCallback onKeepSwiping;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.88),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulsing hearts
              const Text('💜', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 18),
              const Text(
                "It's a Match!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 15,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: 'You and '),
                    TextSpan(
                      text: profile.name,
                      style: const TextStyle(
                        color: Color(0xFFCBA6FF),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ' liked each other.\nStart a conversation!'),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Avatars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _MatchAvatar(
                    photoUrl: 'https://images.unsplash.com/photo-1511367461989'
                        '-f85a21fda167?auto=format&fit=crop&w=200&q=80',
                    label: 'You',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('❤️', style: TextStyle(fontSize: 32)),
                  ),
                  _MatchAvatar(
                    photoUrl: profile.photoUrl,
                    label: profile.name,
                  ),
                ],
              ),

              const SizedBox(height: 42),

              // Send Message button
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: onStartChat,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9B4DFF), Color(0xFF5E17EB)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B2FFF).withOpacity(0.45),
                          blurRadius: 16,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_rounded,
                            color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Send a Message',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Keep Swiping
              TextButton(
                onPressed: onKeepSwiping,
                child: const Text(
                  'Keep Swiping',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchAvatar extends StatelessWidget {
  const _MatchAvatar({required this.photoUrl, required this.label});

  final String photoUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF9B4DFF),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B2FFF).withOpacity(0.4),
                blurRadius: 14,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              photoUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.person,
                color: Colors.white30,
                size: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
