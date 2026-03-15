import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// Filter Model
// ---------------------------------------------------------------------------

class FilterPreferences {
  FilterPreferences({
    required this.genders,
    required this.ageRange,
    required this.locations,
    required this.occupations,
    required this.interests,
  });

  List<String> genders;
  RangeValues ageRange;
  List<String> locations;
  List<String> occupations;
  List<String> interests;
}

// Demo filter data
final _demoFilterPreferences = FilterPreferences(
  genders: ['Female'],
  ageRange: const RangeValues(20, 35),
  locations: ['San Francisco', 'Oakland', 'Berkeley'],
  occupations: ['Designer', 'Engineer', 'Product Manager'],
  interests: ['Travel', 'Hiking', 'Music'],
);

// Available options for filtering
const _availableGenders = ['Female', 'Male', 'Non-binary'];
const _availableLocations = ['San Francisco', 'Oakland', 'Berkeley', 'Los Angeles', 'New York'];
const _availableOccupations = [
  'Designer',
  'Engineer',
  'Product Manager',
  'Entrepreneur',
  'Teacher',
  'Doctor',
  'Artist',
  'Writer',
];
const _availableInterests = [
  'Travel',
  'Hiking',
  'Music',
  'Reading',
  'Coding',
  'Photography',
  'Sports',
  'Yoga',
  'Cooking',
  'Gaming',
];

// ---------------------------------------------------------------------------
// Filter Screen
// ---------------------------------------------------------------------------

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late FilterPreferences _filters;

  @override
  void initState() {
    super.initState();
    _filters = FilterPreferences(
      genders: List.from(_demoFilterPreferences.genders),
      ageRange: _demoFilterPreferences.ageRange,
      locations: List.from(_demoFilterPreferences.locations),
      occupations: List.from(_demoFilterPreferences.occupations),
      interests: List.from(_demoFilterPreferences.interests),
    );
  }

  void _applyFilters() {
    // Save filters and navigate back
    Navigator.of(context).pop(_filters);
  }

  void _resetFilters() {
    setState(() {
      _filters = FilterPreferences(
        genders: [],
        ageRange: const RangeValues(18, 80),
        locations: [],
        occupations: [],
        interests: [],
      );
    });
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
          'Filters',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text(
              'Reset',
              style: TextStyle(
                color: Color(0xFFCBA6FF),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Gender Filter
          _FilterSection(
            title: 'Gender',
            children: [
              _MultiSelectChips(
                options: _availableGenders,
                selectedOptions: _filters.genders,
                onSelectionChanged: (selected) {
                  setState(() {
                    _filters.genders = selected;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Age Range Filter
          _FilterSection(
            title: 'Age Range',
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_filters.ageRange.start.toInt()} - ${_filters.ageRange.end.toInt()} years',
                        style: const TextStyle(
                          color: Color(0xFFCBA6FF),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  RangeSlider(
                    values: _filters.ageRange,
                    min: 18,
                    max: 80,
                    divisions: 62,
                    activeColor: const Color(0xFF9B4DFF),
                    inactiveColor: const Color(0xFF2D1F4E),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _filters.ageRange = values;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Location Filter
          _FilterSection(
            title: 'Location',
            children: [
              _MultiSelectChips(
                options: _availableLocations,
                selectedOptions: _filters.locations,
                onSelectionChanged: (selected) {
                  setState(() {
                    _filters.locations = selected;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Occupation Filter
          _FilterSection(
            title: 'Occupation',
            children: [
              _MultiSelectChips(
                options: _availableOccupations,
                selectedOptions: _filters.occupations,
                onSelectionChanged: (selected) {
                  setState(() {
                    _filters.occupations = selected;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Interests Filter
          _FilterSection(
            title: 'Interests',
            children: [
              _MultiSelectChips(
                options: _availableInterests,
                selectedOptions: _filters.interests,
                onSelectionChanged: (selected) {
                  setState(() {
                    _filters.interests = selected;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Apply button
          GestureDetector(
            onTap: _applyFilters,
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
                    'Apply Filters',
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
    );
  }
}

// ---------------------------------------------------------------------------
// Filter Section
// ---------------------------------------------------------------------------

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Multi-Select Chips
// ---------------------------------------------------------------------------

class _MultiSelectChips extends StatelessWidget {
  const _MultiSelectChips({
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
  });

  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onSelectionChanged;

  void _toggleOption(String option) {
    final updated = List<String>.from(selectedOptions);
    if (updated.contains(option)) {
      updated.remove(option);
    } else {
      updated.add(option);
    }
    onSelectionChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options
          .map(
            (option) => GestureDetector(
              onTap: () => _toggleOption(option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selectedOptions.contains(option)
                      ? const Color(0xFF9B4DFF)
                      : const Color(0xFF1E1E2C),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selectedOptions.contains(option)
                        ? const Color(0xFF5E17EB)
                        : const Color(0xFF2D1F4E),
                    width: 2,
                  ),
                  boxShadow: selectedOptions.contains(option)
                      ? [
                          BoxShadow(
                            color: const Color(0xFF7B2FFF).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedOptions.contains(option))
                      const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    if (selectedOptions.contains(option))
                      const SizedBox(width: 6),
                    Text(
                      option,
                      style: TextStyle(
                        color: selectedOptions.contains(option)
                            ? Colors.white
                            : Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
