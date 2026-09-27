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
import 'package:serverpod/serverpod.dart' as _is;

abstract class ProofPost
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      isVerified: _is.BoolJsonExtension.fromJson(
        jsonSerialization['isVerified'],
      ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = ProofPostTable();

  static const db = ProofPostRepository._();

  @override
  int? id;

  int userId;

  int circleId;

  String imageUrl;

  String caption;

  bool isVerified;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ProofPost]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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
  Map<String, dynamic> toJsonForProtocol() {
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

  static ProofPostInclude include() {
    return ProofPostInclude._();
  }

  static ProofPostIncludeList includeList({
    _is.WhereExpressionBuilder<ProofPostTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProofPostTable>? orderBy,
    _is.OrderByListBuilder<ProofPostTable>? orderByList,
    ProofPostInclude? include,
  }) {
    return ProofPostIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProofPost.t),
      orderByList: orderByList?.call(ProofPost.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class ProofPostUpdateTable extends _is.UpdateTable<ProofPostTable> {
  ProofPostUpdateTable(super.table);

  _is.ColumnValue<int, int> userId(int value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<int, int> circleId(int value) => _is.ColumnValue(
    table.circleId,
    value,
  );

  _is.ColumnValue<String, String> imageUrl(String value) => _is.ColumnValue(
    table.imageUrl,
    value,
  );

  _is.ColumnValue<String, String> caption(String value) => _is.ColumnValue(
    table.caption,
    value,
  );

  _is.ColumnValue<bool, bool> isVerified(bool value) => _is.ColumnValue(
    table.isVerified,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ProofPostTable extends _is.Table<int?> {
  ProofPostTable({super.tableRelation}) : super(tableName: 'proof_post') {
    updateTable = ProofPostUpdateTable(this);
    userId = _is.ColumnInt(
      'userId',
      this,
    );
    circleId = _is.ColumnInt(
      'circleId',
      this,
    );
    imageUrl = _is.ColumnString(
      'imageUrl',
      this,
    );
    caption = _is.ColumnString(
      'caption',
      this,
    );
    isVerified = _is.ColumnBool(
      'isVerified',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final ProofPostUpdateTable updateTable;

  late final _is.ColumnInt userId;

  late final _is.ColumnInt circleId;

  late final _is.ColumnString imageUrl;

  late final _is.ColumnString caption;

  late final _is.ColumnBool isVerified;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    circleId,
    imageUrl,
    caption,
    isVerified,
    createdAt,
  ];
}

class ProofPostInclude extends _is.IncludeObject {
  ProofPostInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ProofPost.t;
}

class ProofPostIncludeList extends _is.IncludeList {
  ProofPostIncludeList._({
    _is.WhereExpressionBuilder<ProofPostTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProofPost.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ProofPost.t;
}

class ProofPostRepository {
  const ProofPostRepository._();

  /// Returns a list of [ProofPost]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ProofPost>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProofPostTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProofPostTable>? orderBy,
    _is.OrderByListBuilder<ProofPostTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProofPost>(
      where: where?.call(ProofPost.t),
      orderBy: orderBy?.call(ProofPost.t),
      orderByList: orderByList?.call(ProofPost.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProofPost] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ProofPost?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProofPostTable>? where,
    int? offset,
    _is.OrderByBuilder<ProofPostTable>? orderBy,
    _is.OrderByListBuilder<ProofPostTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProofPost>(
      where: where?.call(ProofPost.t),
      orderBy: orderBy?.call(ProofPost.t),
      orderByList: orderByList?.call(ProofPost.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProofPost] by its [id] or null if no such row exists.
  Future<ProofPost?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProofPost>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProofPost]s in the list and returns the inserted rows.
  ///
  /// The returned [ProofPost]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProofPost>> insert(
    _is.DatabaseSession session,
    List<ProofPost> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProofPost>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProofPost] and returns the inserted row.
  ///
  /// The returned [ProofPost] will have its `id` field set.
  Future<ProofPost> insertRow(
    _is.DatabaseSession session,
    ProofPost row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProofPost>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProofPost]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [ProofPost]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProofPost>> upsert(
    _is.DatabaseSession session,
    List<ProofPost> rows, {
    required _is.ColumnSelections<ProofPostTable> conflictColumns,
    _is.ColumnSelections<ProofPostTable>? updateColumns,
    _is.WhereExpressionBuilder<ProofPostTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProofPost>(
      rows,
      conflictColumns: conflictColumns(ProofPost.t),
      updateColumns: updateColumns?.call(ProofPost.t),
      updateWhere: updateWhere?.call(ProofPost.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProofPost] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [ProofPost] will have its `id` field set.
  Future<ProofPost?> upsertRow(
    _is.DatabaseSession session,
    ProofPost row, {
    required _is.ColumnSelections<ProofPostTable> conflictColumns,
    _is.ColumnSelections<ProofPostTable>? updateColumns,
    _is.WhereExpressionBuilder<ProofPostTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProofPost>(
      row,
      conflictColumns: conflictColumns(ProofPost.t),
      updateColumns: updateColumns?.call(ProofPost.t),
      updateWhere: updateWhere?.call(ProofPost.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProofPost]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProofPost>> update(
    _is.DatabaseSession session,
    List<ProofPost> rows, {
    _is.ColumnSelections<ProofPostTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProofPost>(
      rows,
      columns: columns?.call(ProofPost.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProofPost]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProofPost> updateRow(
    _is.DatabaseSession session,
    ProofPost row, {
    _is.ColumnSelections<ProofPostTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProofPost>(
      row,
      columns: columns?.call(ProofPost.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProofPost] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProofPost?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ProofPostUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProofPost>(
      id,
      columnValues: columnValues(ProofPost.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProofPost]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProofPost>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProofPostUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ProofPostTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProofPostTable>? orderBy,
    _is.OrderByListBuilder<ProofPostTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProofPost>(
      columnValues: columnValues(ProofPost.t.updateTable),
      where: where(ProofPost.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProofPost.t),
      orderByList: orderByList?.call(ProofPost.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProofPost]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProofPost>> delete(
    _is.DatabaseSession session,
    List<ProofPost> rows, {
    _is.OrderByBuilder<ProofPostTable>? orderBy,
    _is.OrderByListBuilder<ProofPostTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProofPost>(
      rows,
      orderBy: orderBy?.call(ProofPost.t),
      orderByList: orderByList?.call(ProofPost.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProofPost].
  Future<ProofPost> deleteRow(
    _is.DatabaseSession session,
    ProofPost row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProofPost>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProofPost>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProofPostTable> where,
    _is.OrderByBuilder<ProofPostTable>? orderBy,
    _is.OrderByListBuilder<ProofPostTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProofPost>(
      where: where(ProofPost.t),
      orderBy: orderBy?.call(ProofPost.t),
      orderByList: orderByList?.call(ProofPost.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProofPostTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProofPost>(
      where: where?.call(ProofPost.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProofPost] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProofPostTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProofPost>(
      where: where(ProofPost.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
