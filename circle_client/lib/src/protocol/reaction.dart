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

abstract class Reaction implements _i1.SerializableModel {
  Reaction._({
    this.id,
    required this.postId,
    required this.userId,
    required this.emoji,
  });

  factory Reaction({
    int? id,
    required int postId,
    required int userId,
    required String emoji,
  }) = _ReactionImpl;

  factory Reaction.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reaction(
      id: jsonSerialization['id'] as int?,
      postId: jsonSerialization['postId'] as int,
      userId: jsonSerialization['userId'] as int,
      emoji: jsonSerialization['emoji'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int postId;

  int userId;

  String emoji;

  /// Returns a shallow copy of this [Reaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Reaction copyWith({
    int? id,
    int? postId,
    int? userId,
    String? emoji,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reaction',
      if (id != null) 'id': id,
      'postId': postId,
      'userId': userId,
      'emoji': emoji,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReactionImpl extends Reaction {
  _ReactionImpl({
    int? id,
    required int postId,
    required int userId,
    required String emoji,
  }) : super._(
         id: id,
         postId: postId,
         userId: userId,
         emoji: emoji,
       );

  /// Returns a shallow copy of this [Reaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Reaction copyWith({
    Object? id = _Undefined,
    int? postId,
    int? userId,
    String? emoji,
  }) {
    return Reaction(
      id: id is int? ? id : this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      emoji: emoji ?? this.emoji,
    );
  }
}
