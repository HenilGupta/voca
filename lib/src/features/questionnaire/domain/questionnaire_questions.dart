import 'question_model.dart';

/// The full set of questions presented during the questionnaire flow.
///
/// This list is currently hard-coded but is designed so that it can be
/// replaced with an API response in the future by simply mapping
/// [QuestionModel.fromJson] over the response body.
const List<QuestionModel> defaultQuestions = [
  // ── About You ──────────────────────────────────────────────
  QuestionModel(
    id: 'about',
    question: 'Tell me about yourself',
    type: QuestionType.text,
    hint: 'Share something interesting about you…',
  ),
  QuestionModel(
    id: 'age',
    question: 'How old are you?',
    type: QuestionType.number,
    hint: 'Enter your age',
  ),
  QuestionModel(
    id: 'location',
    question: 'Where do you live?',
    type: QuestionType.text,
    hint: 'City, state, or country',
  ),
  QuestionModel(
    id: 'occupation',
    question: 'What do you do for a living?',
    type: QuestionType.text,
    hint: 'Your occupation or field',
  ),

  // ── Relationship ───────────────────────────────────────────
  QuestionModel(
    id: 'relationship_goal',
    question: 'What brings you here?',
    type: QuestionType.singleChoice,
    options: [
      'Casual dating',
      'Long-term relationship',
      'Making friends',
      'Undecided',
    ],
  ),
  QuestionModel(
    id: 'partner_trait',
    question: 'Which matters most in a partner?',
    type: QuestionType.singleChoice,
    options: [
      'Kindness',
      'Ambition',
      'Humor',
      'Intellect',
      'Adventurous',
      'Family-oriented',
    ],
  ),
  QuestionModel(
    id: 'children_preference',
    question: 'Do you want children?',
    type: QuestionType.singleChoice,
    options: ['Yes', 'No', 'Unsure'],
  ),

  // ── Values ─────────────────────────────────────────────────
  QuestionModel(
    id: 'religion_importance',
    question: 'How important is religion/spirituality in a partner?',
    type: QuestionType.scale,
    minValue: 1,
    maxValue: 10,
    minLabel: 'Not important',
    maxLabel: 'Very important',
  ),

  // ── Lifestyle ──────────────────────────────────────────────
  QuestionModel(
    id: 'activities',
    question: 'Pick your top 3 activities',
    type: QuestionType.pickN,
    maxSelections: 3,
    options: [
      'Hiking',
      'Cooking',
      'Gaming',
      'Music gigs',
      'Museums',
      'Partying',
      'Reading',
      'Sports',
    ],
  ),
  QuestionModel(
    id: 'music_vibe',
    question: 'Choose your music vibe',
    type: QuestionType.singleChoice,
    options: [
      'Pop',
      'Rock',
      'Hip-hop',
      'R&B',
      'Electronic',
      'Jazz',
      'Classical',
      'Country',
      'Indie',
    ],
  ),
  QuestionModel(
    id: 'cuisine_description',
    question: 'Describe your favorite cuisine',
    type: QuestionType.text,
    hint: 'What kind of food do you love?',
  ),

  // ── Social Style ───────────────────────────────────────────
  QuestionModel(
    id: 'social_frequency',
    question: 'How often do you enjoy large social gatherings?',
    type: QuestionType.singleChoice,
    options: [
      'Almost never',
      'Rarely',
      'Sometimes',
      'Often',
      'Almost always',
    ],
  ),
  QuestionModel(
    id: 'party_reaction',
    question:
        'A friend invites you to a last-minute party. What\'s your reaction?',
    type: QuestionType.singleChoice,
    options: [
      'Sounds fun — I\'m in',
      'Maybe, depends on mood',
      'Only if close friends are there',
      'I\'d rather skip it',
    ],
  ),
  QuestionModel(
    id: 'energy_preference',
    question: 'Where do you feel most energized?',
    type: QuestionType.singleChoice,
    options: [
      'Big party with many people',
      'Small group hangout',
      'Quiet evening alone',
    ],
  ),
  QuestionModel(
    id: 'social_slider',
    question: 'How social are you?',
    type: QuestionType.slider,
    minValue: 0.0,
    maxValue: 1.0,
    minLabel: 'Prefer quiet time',
    maxLabel: 'Love big social scenes',
  ),
  QuestionModel(
    id: 'crowd_energy',
    question: 'What best describes your energy around people?',
    type: QuestionType.emojiChoice,
    options: [
      '😌 Quiet spaces',
      '🙂 Small groups',
      '😄 Enjoy meeting people',
      '🎉 Big social events',
    ],
  ),

  // ── Communication ──────────────────────────────────────────
  QuestionModel(
    id: 'conversation_style',
    question: 'Preferred conversation style',
    type: QuestionType.multiChoice,
    options: [
      'Short replies',
      'Long thoughtful replies',
      'Lots of emojis',
      'Voice notes',
    ],
  ),

  // ── Final ──────────────────────────────────────────────────
  QuestionModel(
    id: 'religious_preferences',
    question: 'Any religious preferences or dealbreakers?',
    type: QuestionType.text,
    isRequired: false,
    hint: 'Share if you\'d like, or skip',
  ),
];
