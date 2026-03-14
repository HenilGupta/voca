import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/network/api_client.dart';
import '../../../shared/utils/app_logger.dart';
import '../domain/profile_model.dart';

part 'feed_repository.g.dart';

/// Abstract repository interface for feed-related operations.
/// 
/// Defines the contract for fetching profile data from various sources
/// (HTTP API, local storage, mock data, etc.).
abstract class FeedRepository {
  /// Fetches a list of profiles for the dating app feed.
  /// 
  /// Returns a list of [Profile] objects or throws an exception
  /// if the operation fails.
  Future<List<Profile>> fetchProfiles();

  /// Fetches a specific profile by ID.
  /// 
  /// Returns a single [Profile] or throws an exception if not found
  /// or if the operation fails.
  Future<Profile> fetchProfileById(String id);
}

/// HTTP-based implementation of [FeedRepository].
/// 
/// Handles API communication using Dio for fetching profile data
/// from the remote dating app backend.
class HttpFeedRepository implements FeedRepository {
  final Dio _dio;

  const HttpFeedRepository(this._dio);

  @override
  Future<List<Profile>> fetchProfiles() async {
    try {
      AppLogger.log('HttpFeedRepository: Fetching profiles from API');
      
      final response = await _dio.get('/profiles');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['profiles'] ?? response.data;
        
        final profiles = data.map<Profile>((json) {
          try {
            return Profile.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            AppLogger.logError('Failed to parse profile JSON: $e');
            // Return a default profile to avoid breaking the entire feed
            return Profile(
              id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
              name: 'Unknown User',
              age: 25,
              bio: 'Bio unavailable',
              imageSemanticLabel: 'Profile photo unavailable',
            );
          }
        }).toList();
        
        AppLogger.log('HttpFeedRepository: Successfully fetched ${profiles.length} profiles');
        return profiles;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to fetch profiles: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      AppLogger.logError('HttpFeedRepository: DioException - ${e.message}');
      rethrow;
    } catch (e) {
      AppLogger.logError('HttpFeedRepository: Unexpected error - $e');
      throw Exception('Failed to fetch profiles: $e');
    }
  }

  @override
  Future<Profile> fetchProfileById(String id) async {
    try {
      AppLogger.log('HttpFeedRepository: Fetching profile with ID: $id');
      
      final response = await _dio.get('/profiles/$id');
      
      if (response.statusCode == 200) {
        final profile = Profile.fromJson(response.data as Map<String, dynamic>);
        AppLogger.log('HttpFeedRepository: Successfully fetched profile for $id');
        return profile;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to fetch profile: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      AppLogger.logError('HttpFeedRepository: DioException - ${e.message}');
      rethrow;
    } catch (e) {
      AppLogger.logError('HttpFeedRepository: Unexpected error - $e');
      throw Exception('Failed to fetch profile: $e');
    }
  }
}

/// Mock implementation of [FeedRepository] for testing and development.
/// 
/// Provides hardcoded profile data when the backend API is unavailable
/// or during development/testing phases.
class MockFeedRepository implements FeedRepository {
  @override
  Future<List<Profile>> fetchProfiles() async {
    AppLogger.log('MockFeedRepository: Returning mock profiles');
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      Profile(
        id: '1',
        name: 'Sarah',
        age: 28,
        bio: 'Love hiking and photography. Always looking for the next adventure!',
        imageUrl: 'https://via.placeholder.com/400x600/000000/FFFFFF?text=Sarah',
        imageSemanticLabel: 'Photo of Sarah, smiling outdoors with hiking gear',
        interests: ['Photography', 'Hiking', 'Travel', 'Coffee'],
      ),
      Profile(
        id: '2',
        name: 'Alex',
        age: 32,
        bio: 'Software developer by day, musician by night. Looking for someone to share concerts with.',
        imageUrl: 'https://via.placeholder.com/400x600/000000/FFFFFF?text=Alex',
        imageSemanticLabel: 'Photo of Alex, playing guitar in a studio',
        interests: ['Music', 'Technology', 'Concerts', 'Gaming'],
      ),
      Profile(
        id: '3',
        name: 'Maya',
        age: 26,
        bio: 'Yoga instructor and foodie. Let\'s explore new restaurants together!',
        imageUrl: 'https://via.placeholder.com/400x600/000000/FFFFFF?text=Maya',
        imageSemanticLabel: 'Photo of Maya, practicing yoga in a peaceful garden',
        interests: ['Yoga', 'Cooking', 'Meditation', 'Health'],
      ),
      Profile(
        id: '4',
        name: 'Jordan',
        age: 30,
        bio: 'Artist and book lover. Always up for deep conversations over tea.',
        imageUrl: 'https://via.placeholder.com/400x600/000000/FFFFFF?text=Jordan',
        imageSemanticLabel: 'Photo of Jordan, painting in a bright art studio',
        interests: ['Art', 'Reading', 'Philosophy', 'Tea'],
      ),
      Profile(
        id: '5',
        name: 'Riley',
        age: 29,
        bio: 'Rock climber and environmental scientist. Let\'s save the world together!',
        imageUrl: 'https://via.placeholder.com/400x600/000000/FFFFFF?text=Riley',
        imageSemanticLabel: 'Photo of Riley, rock climbing on a mountain cliff',
        interests: ['Climbing', 'Environment', 'Science', 'Outdoors'],
      ),
    ];
  }

  @override
  Future<Profile> fetchProfileById(String id) async {
    AppLogger.log('MockFeedRepository: Fetching profile with ID: $id');
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final profiles = await fetchProfiles();
    final profile = profiles.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Profile with ID $id not found'),
    );
    
    return profile;
  }
}

/// Riverpod provider for the FeedRepository.
/// 
/// By default, uses the HTTP implementation with the main API client.
/// Can be overridden in tests or when the backend is unavailable.
@riverpod
FeedRepository feedRepository(FeedRepositoryRef ref) {
  final dio = ref.watch(apiClientProvider);
  return HttpFeedRepository(dio);
}

/// Riverpod provider for the mock FeedRepository.
/// 
/// Useful for development when the backend API is not available
/// or for testing scenarios.
@riverpod
FeedRepository mockFeedRepository(MockFeedRepositoryRef ref) {
  return MockFeedRepository();
}