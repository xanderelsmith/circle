/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:circle_client/src/protocol/chat_message.dart' as _i91r8fv7;
import 'package:circle_client/src/protocol/circle_group.dart' as _ix4qfs8g;
import 'package:circle_client/src/protocol/greetings/greeting.dart'
    as _i05q6mhs;
import 'package:circle_client/src/protocol/proof_post.dart' as _i97nygvf;
import 'package:circle_client/src/protocol/user.dart' as _irryv4ps;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointChat extends _isc.EndpointRef {
  EndpointChat(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'chat';

  _ida.Future<_i91r8fv7.ChatMessage> postMessage(
    _i91r8fv7.ChatMessage message,
  ) => caller.callServerEndpoint<_i91r8fv7.ChatMessage>(
    'chat',
    'postMessage',
    {'message': message},
  );

  _ida.Future<List<_i91r8fv7.ChatMessage>> getMessages(int groupId) =>
      caller.callServerEndpoint<List<_i91r8fv7.ChatMessage>>(
        'chat',
        'getMessages',
        {'groupId': groupId},
      );
}

/// {@category Endpoint}
class EndpointCircle extends _isc.EndpointRef {
  EndpointCircle(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'circle';

  _ida.Future<bool> seedDummyData() => caller.callServerEndpoint<bool>(
    'circle',
    'seedDummyData',
    {},
  );

  _ida.Future<List<_ix4qfs8g.CircleGroup>> getCircles() =>
      caller.callServerEndpoint<List<_ix4qfs8g.CircleGroup>>(
        'circle',
        'getCircles',
        {},
      );

  _ida.Future<_ix4qfs8g.CircleGroup> createCircle(
    _ix4qfs8g.CircleGroup circle,
  ) => caller.callServerEndpoint<_ix4qfs8g.CircleGroup>(
    'circle',
    'createCircle',
    {'circle': circle},
  );

  _ida.Future<_i97nygvf.ProofPost> createProofPost(_i97nygvf.ProofPost post) =>
      caller.callServerEndpoint<_i97nygvf.ProofPost>(
        'circle',
        'createProofPost',
        {'post': post},
      );

  _ida.Future<List<_i97nygvf.ProofPost>> getFeed(int circleId) =>
      caller.callServerEndpoint<List<_i97nygvf.ProofPost>>(
        'circle',
        'getFeed',
        {'circleId': circleId},
      );

  _ida.Future<bool> verifyPost(int postId) => caller.callServerEndpoint<bool>(
    'circle',
    'verifyPost',
    {'postId': postId},
  );
}

/// {@category Endpoint}
class EndpointNotification extends _isc.EndpointRef {
  EndpointNotification(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  _ida.Future<bool> registerDeviceToken(
    String token,
    String platform,
  ) => caller.callServerEndpoint<bool>(
    'notification',
    'registerDeviceToken',
    {
      'token': token,
      'platform': platform,
    },
  );

  _ida.Future<bool> unregisterDeviceToken(String token) =>
      caller.callServerEndpoint<bool>(
        'notification',
        'unregisterDeviceToken',
        {'token': token},
      );

  _ida.Future<bool> sendNotification(
    int userId,
    String title,
    String body,
    Map<String, String>? data,
  ) => caller.callServerEndpoint<bool>(
    'notification',
    'sendNotification',
    {
      'userId': userId,
      'title': title,
      'body': body,
      'data': data,
    },
  );

  _ida.Future<bool> sendTopicNotification(
    String topic,
    String title,
    String body,
    Map<String, String>? data,
  ) => caller.callServerEndpoint<bool>(
    'notification',
    'sendTopicNotification',
    {
      'topic': topic,
      'title': title,
      'body': body,
      'data': data,
    },
  );

  _ida.Future<bool> subscribeToCircle(int circleId) =>
      caller.callServerEndpoint<bool>(
        'notification',
        'subscribeToCircle',
        {'circleId': circleId},
      );

  _ida.Future<bool> unsubscribeFromCircle(int circleId) =>
      caller.callServerEndpoint<bool>(
        'notification',
        'unsubscribeFromCircle',
        {'circleId': circleId},
      );
}

/// {@category Endpoint}
class EndpointUser extends _isc.EndpointRef {
  EndpointUser(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  _ida.Future<_irryv4ps.User?> getCurrentUser() =>
      caller.callServerEndpoint<_irryv4ps.User?>(
        'user',
        'getCurrentUser',
        {},
      );

  _ida.Future<_irryv4ps.User> signUp(
    String username,
    String phoneNumber,
  ) => caller.callServerEndpoint<_irryv4ps.User>(
    'user',
    'signUp',
    {
      'username': username,
      'phoneNumber': phoneNumber,
    },
  );

  _ida.Future<_irryv4ps.User> createUser(
    String username,
    String phoneNumber,
  ) => caller.callServerEndpoint<_irryv4ps.User>(
    'user',
    'createUser',
    {
      'username': username,
      'phoneNumber': phoneNumber,
    },
  );

  _ida.Future<List<_irryv4ps.User>> getLeaderboard() =>
      caller.callServerEndpoint<List<_irryv4ps.User>>(
        'user',
        'getLeaderboard',
        {},
      );
}

/// {@category Endpoint}
class EndpointVapi extends _isc.EndpointRef {
  EndpointVapi(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'vapi';

  /// Initiates a Vapi call
  _ida.Future<bool> initiateCall(
    String phoneNumber,
    String habitName,
  ) => caller.callServerEndpoint<bool>(
    'vapi',
    'initiateCall',
    {
      'phoneNumber': phoneNumber,
      'habitName': habitName,
    },
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _isc.EndpointRef {
  EndpointGreeting(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _ida.Future<_i05q6mhs.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i05q6mhs.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    chat = EndpointChat(this);
    circle = EndpointCircle(this);
    notification = EndpointNotification(this);
    user = EndpointUser(this);
    vapi = EndpointVapi(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointChat chat;

  late final EndpointCircle circle;

  late final EndpointNotification notification;

  late final EndpointUser user;

  late final EndpointVapi vapi;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'chat': chat,
    'circle': circle,
    'notification': notification,
    'user': user,
    'vapi': vapi,
    'greeting': greeting,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
