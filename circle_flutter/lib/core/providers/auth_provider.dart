import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circle_client/circle_client.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../client.dart';

// Auth state provider
final authStateProvider = StateProvider<AuthState>((ref) => AuthState.unknown);

// Current user provider - uses Serverpod auth
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState != AuthState.authenticated) return null;
  try {
    return await client.user.getCurrentUser();
  } catch (e) {
    return null;
  }
});

// Auth controller for login/signup operations
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

enum AuthState {
  unknown,
  unauthenticated,
  authenticating,
  authenticated,
}

class AuthController {
  final Ref _ref;

  AuthController(this._ref);

  Future<bool> signInWithEmail(String email, String password) async {
    _ref.read(authStateProvider.notifier).state = AuthState.authenticating;

    try {
      final result = await client.emailIdp.login(
        email: email,
        password: password,
      );

      // AuthSuccess has a 'token' field (not sessionId)
      if (result.token.isNotEmpty) {
        _ref.read(authStateProvider.notifier).state = AuthState.authenticated;
        _ref.invalidate(currentUserProvider);
        return true;
      }
      return false;
    } catch (e) {
      _ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
      return false;
    }
  }

  Future<bool> signUpWithEmail(
    String email,
    String password,
    String username,
  ) async {
    _ref.read(authStateProvider.notifier).state = AuthState.authenticating;

    try {
      // First start registration
      final accountRequestId = await client.emailIdp.startRegistration(
        email: email,
      );

      if (accountRequestId != null) {
        // In production, the user would click the verification link in their email
        // For now, we'll use the registration token to finish registration
        // Note: In real app, you'd wait for user to click the email link
        // For demo purposes, we'll try to finish registration (will fail without verification code)

        // For now, let's just return false and let the user know to check their email
        _ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
        return false;
      }
      return false;
    } catch (e) {
      _ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
      return false;
    }
  }

  Future<bool> finishRegistration({
    required String email,
    required String password,
    required String verificationCode,
  }) async {
    _ref.read(authStateProvider.notifier).state = AuthState.authenticating;

    try {
      // Start registration to get account request ID
      final accountRequestId = await client.emailIdp.startRegistration(
        email: email,
      );

      if (accountRequestId != null) {
        // Verify the registration code
        final registrationToken = await client.emailIdp.verifyRegistrationCode(
          accountRequestId: accountRequestId,
          verificationCode: verificationCode,
        );

        // Finish registration with password
        final result = await client.emailIdp.finishRegistration(
          registrationToken: registrationToken,
          password: password,
        );

        if (result.token.isNotEmpty) {
          _ref.read(authStateProvider.notifier).state = AuthState.authenticated;
          _ref.invalidate(currentUserProvider);
          return true;
        }
      }
      return false;
    } catch (e) {
      _ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      // Clear the session by invalidating the token
      // There's no explicit logout method, just invalidate the local state
      // The server will handle token expiration
    } catch (e) {
      // Ignore logout errors
    }
    _ref.read(authStateProvider.notifier).state = AuthState.unauthenticated;
    _ref.invalidate(currentUserProvider);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await client.emailIdp.startPasswordReset(email: email);
  }
}
