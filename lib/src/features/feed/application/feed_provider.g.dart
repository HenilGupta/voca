// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedNotifierHash() => r'1784ad45dbdd76dc7dedf5cb908619fe4175cd2c';

/// Riverpod provider for the feed notifier.
///
/// This is the main provider used by the UI to access feed state and operations.
/// The notifier automatically loads profiles when first accessed.
///
/// Copied from [FeedNotifier].
@ProviderFor(FeedNotifier)
final feedNotifierProvider =
    AutoDisposeNotifierProvider<FeedNotifier, FeedState>.internal(
      FeedNotifier.new,
      name: r'feedNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$feedNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FeedNotifier = AutoDisposeNotifier<FeedState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
