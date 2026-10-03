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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ChatMessage implements _i1.SerializableModel {
  ChatMessage._({
    this.id,
    required this.userId,
    required this.groupId,
    required this.message,
    required this.createdAt,
  });

  factory ChatMessage({
    int? id,
    required int userId,
    required int groupId,
    required String message,
    required DateTime createdAt,
  }) = _ChatMessageImpl;

  factory ChatMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessage(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      groupId: jsonSerialization['groupId'] as int,
      message: jsonSerialization['message'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  int groupId;

  String message;

  DateTime createdAt;

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatMessage copyWith({
    int? id,
    int? userId,
    int? groupId,
    String? message,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatMessage',
      if (id != null) 'id': id,
      'userId': userId,
      'groupId': groupId,
      'message': message,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatMessageImpl extends ChatMessage {
  _ChatMessageImpl({
    int? id,
    required int userId,
    required int groupId,
    required String message,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         groupId: groupId,
         message: message,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatMessage copyWith({
    Object? id = _Undefined,
    int? userId,
    int? groupId,
    String? message,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
