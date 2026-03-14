// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedRepositoryHash() => r'3627a6379f279b0cdd793061e7a5462b30c9b2a9';

/// Riverpod provider for the FeedRepository.
///
/// By default, uses the HTTP implementation with the main API client.
/// Can be overridden in tests or when the backend is unavailable.
///
/// Copied from [feedRepository].
@ProviderFor(feedRepository)
final feedRepositoryProvider = AutoDisposeProvider<FeedRepository>.internal(
  feedRepository,
  name: r'feedRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$feedRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeedRepositoryRef = AutoDisposeProviderRef<FeedRepository>;
String _$mockFeedRepositoryHash() =>
    r'3d35ca5706d5db220a1b91496d0fd431501c6458';

/// Riverpod provider for the mock FeedRepository.
///
/// Useful for development when the backend API is not available
/// or for testing scenarios.
///
/// Copied from [mockFeedRepository].
@ProviderFor(mockFeedRepository)
final mockFeedRepositoryProvider = AutoDisposeProvider<FeedRepository>.internal(
  mockFeedRepository,
  name: r'mockFeedRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mockFeedRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MockFeedRepositoryRef = AutoDisposeProviderRef<FeedRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
