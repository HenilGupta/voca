class SignInRequest {
  const SignInRequest({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
    'email': email.trim().toLowerCase(),
    'password': password,
  };
}

class SignUpRequest {
  const SignUpRequest({
    required this.email,
    required this.password,
    this.phoneNumber,
  });

  final String email;
  final String password;
  final String? phoneNumber;

  Map<String, dynamic> toJson() => {
    'email': email.trim().toLowerCase(),
    'password': password,
    if (phoneNumber != null && phoneNumber!.trim().isNotEmpty)
      'phoneNumber': phoneNumber!.trim(),
  };
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    this.phoneNumber,
    required this.createdAt,
  });

  final String id;
  final String email;
  final String? phoneNumber;
  final DateTime createdAt;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString(),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

class AuthResponse {
  const AuthResponse({
    required this.statusCode,
    required this.userToken,
    required this.sessionToken,
    required this.expiresIn,
    required this.user,
  });

  final int statusCode;
  final String userToken;
  final String sessionToken;
  final String expiresIn;
  final AuthUser user;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      statusCode: json['statusCode'] as int? ?? 0,
      userToken: json['userToken']?.toString() ?? '',
      sessionToken: json['sessionToken']?.toString() ?? '',
      expiresIn: json['expiresIn']?.toString() ?? '',
      user: AuthUser.fromJson(
        (json['user'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
    );
  }
}

class AuthFailure implements Exception {
  const AuthFailure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
