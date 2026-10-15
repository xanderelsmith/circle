import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../../../client.dart';
import 'current_user_provider.dart';
import '../../features/home/data/home_feed_provider.dart';

enum AuthState {
  unknown,
  unauthenticated,
  authenticating,
  authenticated,
}

/// Auth state, kept in sync with the Serverpod session manager (`client.auth`).
///
/// Starts as [AuthState.unknown] until the persisted session has been
/// restored, then follows sign-in / sign-out events.
final authStateProvider = NotifierProvider<AuthStateNotifier, AuthState>(
  AuthStateNotifier.new,
);

class AuthStateNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    final listenable = client.auth.authInfoListenable;
    listenable.addListener(_sync);
    ref.onDispose(() => listenable.removeListener(_sync));

    // Resolve `unknown` once the stored session has been restored.
    authRestored.then((_) => _sync());

    return client.auth.isAuthenticated
        ? AuthState.authenticated
        : AuthState.unknown;
  }

  void _sync() {
    state = client.auth.isAuthenticated
        ? AuthState.authenticated
        : AuthState.unauthenticated;
  }

  void setAuthenticating() => state = AuthState.authenticating;

  /// Re-derive state from the session manager (e.g. after a failed attempt).
  void refresh() => _sync();
}

// Auth controller for login/signup operations
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref _ref;

  AuthController(this._ref);

  /// Account request from [signUpWithEmail], needed to verify the emailed code.
  UuidValue? _pendingAccountRequestId;

  AuthStateNotifier get _auth => _ref.read(authStateProvider.notifier);

  Future<bool> signInWithEmail(String email, String password) async {
    _auth.setAuthenticating();

    try {
      final result = await client.emailIdp.login(
        email: email,
        password: password,
      );
      // Persist the session; this notifies authStateProvider.
      await client.auth.updateSignedInUser(result);
      _ref.invalidate(currentUserProvider);
      _ref.invalidate(usersMapProvider);
      return true;
    } catch (e) {
      return false;
    } finally {
      _auth.refresh();
    }
  }

  /// Starts registration. The server emails a verification code
  /// (logged to the server console in development).
  Future<bool> signUpWithEmail(
    String email,
    String password,
    String username,
  ) async {
    _pendingAccountRequestId = await client.emailIdp.startRegistration(
      email: email,
    );
    return true;
  }

  Future<bool> finishRegistration({
    required String email,
    required String password,
    required String verificationCode,
    String? username,
  }) async {
    final accountRequestId = _pendingAccountRequestId;
    if (accountRequestId == null) return false;

    _auth.setAuthenticating();

    try {
      final registrationToken = await client.emailIdp.verifyRegistrationCode(
        accountRequestId: accountRequestId,
        verificationCode: verificationCode,
      );

      final result = await client.emailIdp.finishRegistration(
        registrationToken: registrationToken,
        password: password,
      );
      await client.auth.updateSignedInUser(result);
      _pendingAccountRequestId = null;

      if (username != null && username.trim().isNotEmpty) {
        try {
          await client.user.setUsername(username.trim());
        } catch (_) {
          // Non-fatal: the profile keeps its default username.
        }
      }
      _ref.invalidate(currentUserProvider);
      _ref.invalidate(usersMapProvider);
      return true;
    } catch (e) {
      return false;
    } finally {
      _auth.refresh();
    }
  }

  Future<void> signOut() async {
    try {
      await client.auth.signOutDevice();
    } catch (e) {
      // Ignore logout errors; local session is cleared regardless.
    }
    _ref.invalidate(currentUserProvider);
    _ref.invalidate(usersMapProvider);
    _auth.refresh();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await client.emailIdp.startPasswordReset(email: email);
  }
}
