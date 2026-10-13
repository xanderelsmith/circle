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
import 'package:circle_server/src/generated/chat_message.dart' as _iukdsbyq;
import 'package:circle_server/src/generated/circle_group.dart' as _imhv1m7j;
import 'package:circle_server/src/generated/future_calls.dart' as _i66ecde7;
import 'package:circle_server/src/generated/proof_post.dart' as _idd7hml3;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../endpoints/chat_endpoint.dart' as _ihc7hrsa;
import '../endpoints/circle_endpoint.dart' as _i35yc453;
import '../endpoints/notification_endpoint.dart' as _ihb11yhk;
import '../endpoints/user_endpoint.dart' as _iymy5306;
import '../endpoints/vapi_endpoint.dart' as _ioy6ptx0;
import '../greetings/greeting_endpoint.dart' as _il624ik7;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'chat': _ihc7hrsa.ChatEndpoint()
        ..initialize(
          server,
          'chat',
          null,
        ),
      'circle': _i35yc453.CircleEndpoint()
        ..initialize(
          server,
          'circle',
          null,
        ),
      'notification': _ihb11yhk.NotificationEndpoint()
        ..initialize(
          server,
          'notification',
          null,
        ),
      'user': _iymy5306.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
      'vapi': _ioy6ptx0.VapiEndpoint()
        ..initialize(
          server,
          'vapi',
          null,
        ),
      'greeting': _il624ik7.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['chat'] = _is.EndpointConnector(
      name: 'chat',
      endpoint: endpoints['chat']!,
      methodConnectors: {
        'postMessage': _is.MethodConnector(
          name: 'postMessage',
          params: {
            'message': _is.ParameterDescription(
              name: 'message',
              type: _is.getType<_iukdsbyq.ChatMessage>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['chat'] as _ihc7hrsa.ChatEndpoint).postMessage(
                    session,
                    params['message'],
                  ),
        ),
        'getMessages': _is.MethodConnector(
          name: 'getMessages',
          params: {
            'groupId': _is.ParameterDescription(
              name: 'groupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['chat'] as _ihc7hrsa.ChatEndpoint).getMessages(
                    session,
                    params['groupId'],
                  ),
        ),
      },
    );
    connectors['circle'] = _is.EndpointConnector(
      name: 'circle',
      endpoint: endpoints['circle']!,
      methodConnectors: {
        'seedDummyData': _is.MethodConnector(
          name: 'seedDummyData',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['circle'] as _i35yc453.CircleEndpoint)
                  .seedDummyData(session),
        ),
        'getCircles': _is.MethodConnector(
          name: 'getCircles',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['circle'] as _i35yc453.CircleEndpoint)
                  .getCircles(session),
        ),
        'createCircle': _is.MethodConnector(
          name: 'createCircle',
          params: {
            'circle': _is.ParameterDescription(
              name: 'circle',
              type: _is.getType<_imhv1m7j.CircleGroup>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['circle'] as _i35yc453.CircleEndpoint)
                  .createCircle(
                    session,
                    params['circle'],
                  ),
        ),
        'createProofPost': _is.MethodConnector(
          name: 'createProofPost',
          params: {
            'post': _is.ParameterDescription(
              name: 'post',
              type: _is.getType<_idd7hml3.ProofPost>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['circle'] as _i35yc453.CircleEndpoint)
                  .createProofPost(
                    session,
                    params['post'],
                  ),
        ),
        'getFeed': _is.MethodConnector(
          name: 'getFeed',
          params: {
            'circleId': _is.ParameterDescription(
              name: 'circleId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['circle'] as _i35yc453.CircleEndpoint).getFeed(
                    session,
                    params['circleId'],
                  ),
        ),
        'verifyPost': _is.MethodConnector(
          name: 'verifyPost',
          params: {
            'postId': _is.ParameterDescription(
              name: 'postId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['circle'] as _i35yc453.CircleEndpoint).verifyPost(
                    session,
                    params['postId'],
                  ),
        ),
      },
    );
    connectors['notification'] = _is.EndpointConnector(
      name: 'notification',
      endpoint: endpoints['notification']!,
      methodConnectors: {
        'registerDeviceToken': _is.MethodConnector(
          name: 'registerDeviceToken',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'platform': _is.ParameterDescription(
              name: 'platform',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .registerDeviceToken(
                        session,
                        params['token'],
                        params['platform'],
                      ),
        ),
        'unregisterDeviceToken': _is.MethodConnector(
          name: 'unregisterDeviceToken',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .unregisterDeviceToken(
                        session,
                        params['token'],
                      ),
        ),
        'sendNotification': _is.MethodConnector(
          name: 'sendNotification',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'body': _is.ParameterDescription(
              name: 'body',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<Map<String, String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .sendNotification(
                        session,
                        params['userId'],
                        params['title'],
                        params['body'],
                        params['data'],
                      ),
        ),
        'sendTopicNotification': _is.MethodConnector(
          name: 'sendTopicNotification',
          params: {
            'topic': _is.ParameterDescription(
              name: 'topic',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'body': _is.ParameterDescription(
              name: 'body',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<Map<String, String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .sendTopicNotification(
                        session,
                        params['topic'],
                        params['title'],
                        params['body'],
                        params['data'],
                      ),
        ),
        'subscribeToCircle': _is.MethodConnector(
          name: 'subscribeToCircle',
          params: {
            'circleId': _is.ParameterDescription(
              name: 'circleId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .subscribeToCircle(
                        session,
                        params['circleId'],
                      ),
        ),
        'unsubscribeFromCircle': _is.MethodConnector(
          name: 'unsubscribeFromCircle',
          params: {
            'circleId': _is.ParameterDescription(
              name: 'circleId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .unsubscribeFromCircle(
                        session,
                        params['circleId'],
                      ),
        ),
      },
    );
    connectors['user'] = _is.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'getCurrentUser': _is.MethodConnector(
          name: 'getCurrentUser',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _iymy5306.UserEndpoint)
                  .getCurrentUser(session),
        ),
        'signUp': _is.MethodConnector(
          name: 'signUp',
          params: {
            'username': _is.ParameterDescription(
              name: 'username',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'phoneNumber': _is.ParameterDescription(
              name: 'phoneNumber',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _iymy5306.UserEndpoint).signUp(
                session,
                params['username'],
                params['phoneNumber'],
              ),
        ),
        'createUser': _is.MethodConnector(
          name: 'createUser',
          params: {
            'username': _is.ParameterDescription(
              name: 'username',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'phoneNumber': _is.ParameterDescription(
              name: 'phoneNumber',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _iymy5306.UserEndpoint).createUser(
                    session,
                    params['username'],
                    params['phoneNumber'],
                  ),
        ),
        'getLeaderboard': _is.MethodConnector(
          name: 'getLeaderboard',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _iymy5306.UserEndpoint)
                  .getLeaderboard(session),
        ),
      },
    );
    connectors['vapi'] = _is.EndpointConnector(
      name: 'vapi',
      endpoint: endpoints['vapi']!,
      methodConnectors: {
        'initiateCall': _is.MethodConnector(
          name: 'initiateCall',
          params: {
            'phoneNumber': _is.ParameterDescription(
              name: 'phoneNumber',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'habitName': _is.ParameterDescription(
              name: 'habitName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vapi'] as _ioy6ptx0.VapiEndpoint).initiateCall(
                    session,
                    params['phoneNumber'],
                    params['habitName'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _is.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greeting'] as _il624ik7.GreetingEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _i66ecde7.FutureCalls();
  }
}
