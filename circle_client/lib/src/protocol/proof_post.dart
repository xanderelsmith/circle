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

abstract class ProofPost implements _i1.SerializableModel {
  ProofPost._({
    this.id,
    required this.userId,
    required this.circleId,
    required this.imageUrl,
    required this.caption,
    required this.isVerified,
    required this.createdAt,
  });

  factory ProofPost({
    int? id,
    required int userId,
    required int circleId,
    required String imageUrl,
    required String caption,
    required bool isVerified,
    required DateTime createdAt,
  }) = _ProofPostImpl;

  factory ProofPost.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProofPost(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      circleId: jsonSerialization['circleId'] as int,
      imageUrl: jsonSerialization['imageUrl'] as String,
      caption: jsonSerialization['caption'] as String,
      isVerified: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isVerified'],
      ),
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

  int circleId;

  String imageUrl;

  String caption;

  bool isVerified;

  DateTime createdAt;

  /// Returns a shallow copy of this [ProofPost]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProofPost copyWith({
    int? id,
    int? userId,
    int? circleId,
    String? imageUrl,
    String? caption,
    bool? isVerified,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProofPost',
      if (id != null) 'id': id,
      'userId': userId,
      'circleId': circleId,
      'imageUrl': imageUrl,
      'caption': caption,
      'isVerified': isVerified,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProofPostImpl extends ProofPost {
  _ProofPostImpl({
    int? id,
    required int userId,
    required int circleId,
    required String imageUrl,
    required String caption,
    required bool isVerified,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         circleId: circleId,
         imageUrl: imageUrl,
         caption: caption,
         isVerified: isVerified,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ProofPost]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProofPost copyWith({
    Object? id = _Undefined,
    int? userId,
    int? circleId,
    String? imageUrl,
    String? caption,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return ProofPost(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      circleId: circleId ?? this.circleId,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
