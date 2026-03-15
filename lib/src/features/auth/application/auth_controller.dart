import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/utils/app_logger.dart';
import '../data/auth_repository.dart';
import '../domain/auth_models.dart';

const _sessionTokenKey = 'sessionToken';
const _userTokenKey = 'userToken';
const _userEmailKey = 'userEmail';

class AuthState {
  const AuthState({
    this.isLoading = false,
    this.sessionToken,
    this.userToken,
    this.email,
    this.error,
  });

  final bool isLoading;
  final String? sessionToken;
  final String? userToken;
  final String? email;
  final String? error;

  bool get isAuthenticated =>
      sessionToken != null &&
      sessionToken!.isNotEmpty &&
      userToken != null &&
      userToken!.isNotEmpty;

  AuthState copyWith({
    bool? isLoading,
    String? sessionToken,
    String? userToken,
    String? email,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      sessionToken: sessionToken ?? this.sessionToken,
      userToken: userToken ?? this.userToken,
      email: email ?? this.email,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  );
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    final preferences = ref.watch(sharedPreferencesProvider);
    return AuthController(repository: repository, preferences: preferences);
  },
);

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required AuthRepository repository,
    required SharedPreferences preferences,
  }) : _repository = repository,
       _preferences = preferences,
       super(const AuthState()) {
    _loadFromStorage();
  }

  final AuthRepository _repository;
  final SharedPreferences _preferences;

  Future<void> signIn({required String email, required String password}) async {
    AppLogger.log(
      'AuthController: Sign-in started for ${email.trim().toLowerCase()}',
    );
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _repository.signIn(
        SignInRequest(email: email, password: password),
      );

      await _persistSession(
        userToken: response.userToken,
        sessionToken: response.sessionToken,
        email: response.user.email,
      );
      AppLogger.log(
        'AuthController: Sign-in successful for ${response.user.email}',
      );
    } on AuthFailure catch (failure) {
      AppLogger.logError('AuthController: Sign-in failed - ${failure.message}');
      state = state.copyWith(isLoading: false, error: failure.message);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: 'Unable to sign in. Please try again.',
      );
      AppLogger.logError('Unexpected sign-in error: $error');
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    AppLogger.log(
      'AuthController: Sign-up started for ${email.trim().toLowerCase()}',
    );
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _repository.signUp(
        SignUpRequest(
          email: email,
          password: password,
          phoneNumber: phoneNumber,
        ),
      );

      await _persistSession(
        userToken: response.userToken,
        sessionToken: response.sessionToken,
        email: response.user.email,
      );
      AppLogger.log(
        'AuthController: Sign-up successful for ${response.user.email}',
      );
    } on AuthFailure catch (failure) {
      AppLogger.logError('AuthController: Sign-up failed - ${failure.message}');
      state = state.copyWith(isLoading: false, error: failure.message);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: 'Unable to sign up. Please try again.',
      );
      AppLogger.logError('Unexpected sign-up error: $error');
    }
  }

  Future<void> signOut() async {
    AppLogger.log(
      'AuthController: Sign-out started for ${state.email ?? 'unknown user'}',
    );
    await _preferences.remove(_sessionTokenKey);
    await _preferences.remove(_userTokenKey);
    await _preferences.remove(_userEmailKey);

    state = const AuthState();
    AppLogger.log('AuthController: Sign-out successful');
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(clearError: true);
    }
  }

  Future<void> _loadFromStorage() async {
    final sessionToken = _preferences.getString(_sessionTokenKey);
    final userToken = _preferences.getString(_userTokenKey);
    final email = _preferences.getString(_userEmailKey);

    state = state.copyWith(
      sessionToken: sessionToken,
      userToken: userToken,
      email: email,
      isLoading: false,
      clearError: true,
    );
  }

  Future<void> _persistSession({
    required String userToken,
    required String sessionToken,
    required String email,
  }) async {
    await _preferences.setString(_userTokenKey, userToken);
    await _preferences.setString(_sessionTokenKey, sessionToken);
    await _preferences.setString(_userEmailKey, email);

    state = state.copyWith(
      isLoading: false,
      userToken: userToken,
      sessionToken: sessionToken,
      email: email,
      clearError: true,
    );
  }
}
