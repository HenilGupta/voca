import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// Data Model
// ---------------------------------------------------------------------------

class UserProfile {
  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.age,
    required this.location,
    required this.occupation,
    required this.interests,
    required this.personalityTraits,
    required this.photoUrl,
    required this.photoDescription,
    required this.bio,
  });

  String name;
  String email;
  String phone;
  String gender;
  int age;
  String location;
  String occupation;
  List<String> interests;
  List<String> personalityTraits;
  String photoUrl;
  String photoDescription;
  String bio;
}

// Demo/prefilled data
final _demoProfile = UserProfile(
  name: 'Sophia',
  email: 'sophia@example.com',
  phone: '+91 9999999999',
  gender: 'Female',
  age: 25,
  location: 'San Francisco, CA',
  occupation: 'Product Designer',
  interests: ['Hiking', 'Coding', 'Travel', 'Photography'],
  personalityTraits: ['Ambitious', 'Thoughtful', 'Creative', 'Adventurous'],
  photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330'
      '?auto=format&fit=crop&w=400&q=80',
  photoDescription:
      'Sophia smiling outdoors with natural sunlight in the background, wearing a casual denim jacket.',
  bio:
      'I love exploring new places, learning new technologies, and meeting people with different perspectives. Always up for a hiking adventure or coffee chat! 🎵',
);

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile _profile;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _occupationController;
  late TextEditingController _photoDescriptionController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _profile = UserProfile(
      name: _demoProfile.name,
      email: _demoProfile.email,
      phone: _demoProfile.phone,
      gender: _demoProfile.gender,
      age: _demoProfile.age,
      location: _demoProfile.location,
      occupation: _demoProfile.occupation,
      interests: List.from(_demoProfile.interests),
      personalityTraits: List.from(_demoProfile.personalityTraits),
      photoUrl: _demoProfile.photoUrl,
      photoDescription: _demoProfile.photoDescription,
      bio: _demoProfile.bio,
    );

    _nameController = TextEditingController(text: _profile.name);
    _emailController = TextEditingController(text: _profile.email);
    _phoneController = TextEditingController(text: _profile.phone);
    _locationController = TextEditingController(text: _profile.location);
    _occupationController = TextEditingController(text: _profile.occupation);
    _photoDescriptionController =
        TextEditingController(text: _profile.photoDescription);
    _bioController = TextEditingController(text: _profile.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _occupationController.dispose();
    _photoDescriptionController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    _profile.name = _nameController.text;
    _profile.email = _emailController.text;
    _profile.phone = _phoneController.text;
    _profile.location = _locationController.text;
    _profile.occupation = _occupationController.text;
    _profile.photoDescription = _photoDescriptionController.text;
    _profile.bio = _bioController.text;
  }

  void _showLogoutConfirmation() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70, fontSize: 14.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w600),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF4566),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.goNamed('login');
              },
              child: const Text('Logout'),
            ),
          ],
        );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFFF4566), size: 24),
            tooltip: 'Logout',
            onPressed: _showLogoutConfirmation,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Photo section
          _PhotoSection(
            photoUrl: _profile.photoUrl,
            onUploadTap: () {
              // Hook up image picker here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Image picker would open here'),
                  backgroundColor: Color(0xFF2D1F4E),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Photo description section
          _EditableField(
            label: 'Photo Description',
            controller: _photoDescriptionController,
            maxLines: 2,
            hint: 'AI-generated or edit your photo description',
          ),

          const SizedBox(height: 18),

          // Name
          _EditableField(
            label: 'Name',
            controller: _nameController,
            hint: 'Your full name',
          ),

          const SizedBox(height: 14),

          // Email
          _EditableField(
            label: 'Email',
            controller: _emailController,
            hint: 'your@email.com',
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 14),

          // Phone
          _EditableField(
            label: 'Phone',
            controller: _phoneController,
            hint: '+91 9999999999',
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 14),

          // Gender
          _DropdownField(
            label: 'Gender',
            value: _profile.gender,
            items: ['Female', 'Male', 'Non-binary', 'Prefer to say'],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _profile.gender = val;
                });
              }
            },
          ),

          const SizedBox(height: 14),

          // Age
          _AgeField(
            age: _profile.age,
            onChanged: (val) {
              setState(() {
                _profile.age = val;
              });
            },
          ),

          const SizedBox(height: 14),

          // Location
          _EditableField(
            label: 'Location',
            controller: _locationController,
            hint: 'City, State/Country',
          ),

          const SizedBox(height: 14),

          // Occupation
          _EditableField(
            label: 'Occupation',
            controller: _occupationController,
            hint: 'Your job title',
          ),

          const SizedBox(height: 20),

          // Interests
          _TagsField(
            label: 'Interests',
            tags: _profile.interests,
            onTagsChanged: (tags) {
              setState(() {
                _profile.interests = tags;
              });
            },
          ),

          const SizedBox(height: 18),

          // Personality traits
          _TagsField(
            label: 'Personality Traits',
            tags: _profile.personalityTraits,
            onTagsChanged: (traits) {
              setState(() {
                _profile.personalityTraits = traits;
              });
            },
          ),

          const SizedBox(height: 20),

          // Bio/Summary
          _EditableField(
            label: 'Bio / Summary',
            controller: _bioController,
            maxLines: 4,
            hint: 'Tell us about yourself...',
          ),

          const SizedBox(height: 28),

          // Save button
          GestureDetector(
            onTap: () {
              _updateProfile();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: Color(0xFF34D66E),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9B4DFF), Color(0xFF5E17EB)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B2FFF).withOpacity(0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Save Profile',
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

          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(
        onMatchesPressed: () {
          context.goNamed('profile');
        },
        onChatPressed: () {
          context.goNamed('chat-history');
        },
        onProfilePressed: () {
          // Already on profile screen
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Photo Section
// ---------------------------------------------------------------------------

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({
    required this.photoUrl,
    required this.onUploadTap,
  });

  final String photoUrl;
  final VoidCallback onUploadTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 1 / 1.2,
            child: Image.network(
              photoUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF1C1C26),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white30,
                  size: 80,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: onUploadTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF7A3FD4)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_camera_rounded,
                    color: Color(0xFFCBA6FF), size: 20),
                SizedBox(width: 8),
                Text(
                  'Upload Photo',
                  style: TextStyle(
                    color: Color(0xFFCBA6FF),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Editable Field
// ---------------------------------------------------------------------------

class _EditableField extends StatelessWidget {
  const _EditableField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.hint = '',
    this.keyboardType = TextInputType.text,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final String hint;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2D1F4E)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 14.5),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white30),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Dropdown Field
// ---------------------------------------------------------------------------

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2D1F4E)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              dropdownColor: const Color(0xFF2D1F4E),
              underline: const SizedBox(),
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Age Field (Slider)
// ---------------------------------------------------------------------------

class _AgeField extends StatelessWidget {
  const _AgeField({
    required this.age,
    required this.onChanged,
  });

  final int age;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Age',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              '$age',
              style: const TextStyle(
                color: Color(0xFFCBA6FF),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFF9B4DFF),
            inactiveTrackColor: const Color(0xFF2D1F4E),
            thumbColor: const Color(0xFF9B4DFF),
            trackHeight: 6,
            thumbShape:
                const RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 4),
          ),
          child: Slider(
            value: age.toDouble(),
            min: 18,
            max: 80,
            divisions: 62,
            onChanged: (val) {
              onChanged(val.toInt());
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tags Field (Interests/Traits)
// ---------------------------------------------------------------------------

class _TagsField extends StatefulWidget {
  const _TagsField({
    required this.label,
    required this.tags,
    required this.onTagsChanged,
  });

  final String label;
  final List<String> tags;
  final ValueChanged<List<String>> onTagsChanged;

  @override
  State<_TagsField> createState() => _TagsFieldState();
}

class _TagsFieldState extends State<_TagsField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _controller.text.trim();
    if (tag.isNotEmpty && !widget.tags.contains(tag)) {
      setState(() {
        widget.tags.add(tag);
        widget.onTagsChanged(widget.tags);
        _controller.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      widget.tags.remove(tag);
      widget.onTagsChanged(widget.tags);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2D1F4E)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add ${widget.label.toLowerCase()}',
                          hintStyle: const TextStyle(color: Colors.white30),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _addTag(),
                      ),
                    ),
                    GestureDetector(
                      onTap: _addTag,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D1F4E),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF7A3FD4)),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Color(0xFFCBA6FF),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.tags
                        .map(
                          (tag) => _TagChip(
                            tag: tag,
                            onRemove: () => _removeTag(tag),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tag Chip
// ---------------------------------------------------------------------------

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.tag,
    required this.onRemove,
  });

  final String tag;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1F4E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF7A3FD4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: const TextStyle(
              color: Color(0xFFCBA6FF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              color: Color(0xFFCBA6FF),
              size: 16,
            ),
          ),
        ],
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
              isActive: false,
              onTap: onChatPressed,
            ),
            // Profile button
            _NavBarItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              isActive: true,
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
