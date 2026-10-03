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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class CircleGroup
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CircleGroup._({
    this.id,
    required this.name,
    required this.dailyDeadline,
  });

  factory CircleGroup({
    int? id,
    required String name,
    required DateTime dailyDeadline,
  }) = _CircleGroupImpl;

  factory CircleGroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return CircleGroup(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      dailyDeadline: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['dailyDeadline'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  DateTime dailyDeadline;

  /// Returns a shallow copy of this [CircleGroup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CircleGroup copyWith({
    int? id,
    String? name,
    DateTime? dailyDeadline,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CircleGroup',
      if (id != null) 'id': id,
      'name': name,
      'dailyDeadline': dailyDeadline.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CircleGroup',
      if (id != null) 'id': id,
      'name': name,
      'dailyDeadline': dailyDeadline.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CircleGroupImpl extends CircleGroup {
  _CircleGroupImpl({
    int? id,
    required String name,
    required DateTime dailyDeadline,
  }) : super._(
         id: id,
         name: name,
         dailyDeadline: dailyDeadline,
       );

  /// Returns a shallow copy of this [CircleGroup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CircleGroup copyWith({
    Object? id = _Undefined,
    String? name,
    DateTime? dailyDeadline,
  }) {
    return CircleGroup(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      dailyDeadline: dailyDeadline ?? this.dailyDeadline,
    );
  }
}
