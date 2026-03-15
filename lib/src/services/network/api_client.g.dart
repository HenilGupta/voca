// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiClientHash() => r'bee744edfc4d7b521f3e9c48d6aad934ecc00f1e';

/// Riverpod provider for the main Dio HTTP client.
///
/// Provides a configured Dio instance with:
/// - Base URL for the dating app API
/// - Custom logging interceptor for debugging
/// - Standard timeout configurations
/// - JSON content type headers
///
/// Copied from [apiClient].
@ProviderFor(apiClient)
final apiClientProvider = AutoDisposeProvider<Dio>.internal(
  apiClient,
  name: r'apiClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiClientRef = AutoDisposeProviderRef<Dio>;
String _$mockApiClientHash() => r'e1c2c27fd414930f473e0226028c95c4cedddc2f';

/// Alternative API client provider for mock/testing environments.
///
/// Can be used to override the main apiClient provider during testing
/// or when the backend API is unavailable.
///
/// Copied from [mockApiClient].
@ProviderFor(mockApiClient)
final mockApiClientProvider = AutoDisposeProvider<Dio>.internal(
  mockApiClient,
  name: r'mockApiClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mockApiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MockApiClientRef = AutoDisposeProviderRef<Dio>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
