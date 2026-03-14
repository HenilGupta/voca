import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/utils/app_logger.dart';
import '../data/feed_repository.dart';
import '../domain/profile_model.dart';

part 'feed_provider.g.dart';

/// State class for managing the feed of profiles.
///
/// Tracks the current list of profiles, loading state, and any errors
/// that occur during profile fetching.
class FeedState {
  final List<Profile> profiles;
  final bool isLoading;
  final String? error;

  const FeedState({
    this.profiles = const [],
    this.isLoading = false,
    this.error,
  });

  FeedState copyWith({
    List<Profile>? profiles,
    bool? isLoading,
    String? error,
  }) {
    return FeedState(
      profiles: profiles ?? this.profiles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Riverpod provider for the feed notifier.
///
/// This is the main provider used by the UI to access feed state and operations.
/// The notifier automatically loads profiles when first accessed.
@riverpod
class FeedNotifier extends _$FeedNotifier {
  @override
  FeedState build() {
    // Auto-load profiles when the provider is first created
    Future.microtask(() => loadProfiles());
    return const FeedState(isLoading: true);
  }

  /// Loads profiles from the repository.
  ///
  /// Updates the state with loading indicators and handles errors gracefully.
  /// On successful load, populates the feed with fresh profiles.
  Future<void> loadProfiles() async {
    try {
      AppLogger.log('FeedNotifier: Starting to load profiles');
      state = state.copyWith(isLoading: true, error: null);

      final repository = ref.read(feedRepositoryProvider);
      final profiles = await repository.fetchProfiles();

      AppLogger.log('FeedNotifier: Successfully loaded ${profiles.length} profiles');
      state = state.copyWith(
        profiles: profiles,
        isLoading: false,
        error: null,
      );
    } catch (e, stackTrace) {
      AppLogger.logError('FeedNotifier: Failed to load profiles - $e\nStackTrace: $stackTrace');

      // Check if we should fallback to mock data
      try {
        AppLogger.log('FeedNotifier: Attempting fallback to mock repository');
        final mockRepository = ref.read(mockFeedRepositoryProvider);
        final profiles = await mockRepository.fetchProfiles();

        AppLogger.log('FeedNotifier: Successfully loaded ${profiles.length} mock profiles');
        state = state.copyWith(
          profiles: profiles,
          isLoading: false,
          error: 'Using offline data - check your connection',
        );
      } catch (mockError) {
        AppLogger.logError('FeedNotifier: Mock repository also failed - $mockError');
        state = state.copyWith(
          profiles: [],
          isLoading: false,
          error: 'Failed to load profiles. Please try again.',
        );
      }
    }
  }

  /// Removes the top profile from the feed.
  ///
  /// Used when a user performs an action (like/pass) on a profile.
  /// This creates the "swiping through profiles" experience.
  void removeTopProfile() {
    if (state.profiles.isNotEmpty) {
      final updatedProfiles = List<Profile>.from(state.profiles)..removeAt(0);
      AppLogger.log('FeedNotifier: Removed top profile, ${updatedProfiles.length} remaining');

      state = state.copyWith(profiles: updatedProfiles);

      // If we're running low on profiles, try to load more
      if (updatedProfiles.length <= 2) {
        AppLogger.log('FeedNotifier: Low on profiles, loading more');
        loadProfiles();
      }
    }
  }

  /// Removes a specific profile by ID.
  ///
  /// Useful for removing profiles based on user preferences or blocking.
  void removeProfileById(String profileId) {
    final updatedProfiles = state.profiles.where((p) => p.id != profileId).toList();
    AppLogger.log('FeedNotifier: Removed profile $profileId, ${updatedProfiles.length} remaining');

    state = state.copyWith(profiles: updatedProfiles);

    if (updatedProfiles.length <= 2) {
      loadProfiles();
    }
  }

  /// Refreshes the feed by reloading profiles from the repository.
  ///
  /// Useful for pull-to-refresh functionality or when user wants
  /// to see new profiles.
  Future<void> refresh() async {
    AppLogger.log('FeedNotifier: Refreshing feed');
    await loadProfiles();
  }

  /// Clears any existing error state.
  ///
  /// Can be called after showing error messages to the user.
  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
      AppLogger.log('FeedNotifier: Cleared error state');
    }
  }

  /// Legacy method to maintain compatibility with existing UI code.
  ///
  /// Delegates to the new removeTopProfile method.
  @Deprecated('Use removeTopProfile() instead')
  void removeTop() {
    removeTopProfile();
  }
}
