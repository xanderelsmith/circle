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

abstract class Reaction
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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

  static final t = ReactionTable();

  static const db = ReactionRepository._();

  @override
  int? id;

  int postId;

  int userId;

  String emoji;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Reaction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Reaction',
      if (id != null) 'id': id,
      'postId': postId,
      'userId': userId,
      'emoji': emoji,
    };
  }

  static ReactionInclude include() {
    return ReactionInclude._();
  }

  static ReactionIncludeList includeList({
    _is.WhereExpressionBuilder<ReactionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReactionTable>? orderBy,
    _is.OrderByListBuilder<ReactionTable>? orderByList,
    ReactionInclude? include,
  }) {
    return ReactionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reaction.t),
      orderByList: orderByList?.call(Reaction.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class ReactionUpdateTable extends _is.UpdateTable<ReactionTable> {
  ReactionUpdateTable(super.table);

  _is.ColumnValue<int, int> postId(int value) => _is.ColumnValue(
    table.postId,
    value,
  );

  _is.ColumnValue<int, int> userId(int value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> emoji(String value) => _is.ColumnValue(
    table.emoji,
    value,
  );
}

class ReactionTable extends _is.Table<int?> {
  ReactionTable({super.tableRelation}) : super(tableName: 'reaction') {
    updateTable = ReactionUpdateTable(this);
    postId = _is.ColumnInt(
      'postId',
      this,
    );
    userId = _is.ColumnInt(
      'userId',
      this,
    );
    emoji = _is.ColumnString(
      'emoji',
      this,
    );
  }

  late final ReactionUpdateTable updateTable;

  late final _is.ColumnInt postId;

  late final _is.ColumnInt userId;

  late final _is.ColumnString emoji;

  @override
  List<_is.Column> get columns => [
    id,
    postId,
    userId,
    emoji,
  ];
}

class ReactionInclude extends _is.IncludeObject {
  ReactionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Reaction.t;
}

class ReactionIncludeList extends _is.IncludeList {
  ReactionIncludeList._({
    _is.WhereExpressionBuilder<ReactionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Reaction.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Reaction.t;
}

class ReactionRepository {
  const ReactionRepository._();

  /// Returns a list of [Reaction]s matching the given query parameters.
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
  Future<List<Reaction>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReactionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReactionTable>? orderBy,
    _is.OrderByListBuilder<ReactionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Reaction>(
      where: where?.call(Reaction.t),
      orderBy: orderBy?.call(Reaction.t),
      orderByList: orderByList?.call(Reaction.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Reaction] matching the given query parameters.
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
  Future<Reaction?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReactionTable>? where,
    int? offset,
    _is.OrderByBuilder<ReactionTable>? orderBy,
    _is.OrderByListBuilder<ReactionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Reaction>(
      where: where?.call(Reaction.t),
      orderBy: orderBy?.call(Reaction.t),
      orderByList: orderByList?.call(Reaction.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Reaction] by its [id] or null if no such row exists.
  Future<Reaction?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Reaction>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Reaction]s in the list and returns the inserted rows.
  ///
  /// The returned [Reaction]s will have their `id` fields set.
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
  Future<List<Reaction>> insert(
    _is.DatabaseSession session,
    List<Reaction> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Reaction>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Reaction] and returns the inserted row.
  ///
  /// The returned [Reaction] will have its `id` field set.
  Future<Reaction> insertRow(
    _is.DatabaseSession session,
    Reaction row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Reaction>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Reaction]s in the list and returns the resulting rows.
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
  /// The returned [Reaction]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Reaction>> upsert(
    _is.DatabaseSession session,
    List<Reaction> rows, {
    required _is.ColumnSelections<ReactionTable> conflictColumns,
    _is.ColumnSelections<ReactionTable>? updateColumns,
    _is.WhereExpressionBuilder<ReactionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Reaction>(
      rows,
      conflictColumns: conflictColumns(Reaction.t),
      updateColumns: updateColumns?.call(Reaction.t),
      updateWhere: updateWhere?.call(Reaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Reaction] and returns the resulting row.
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
  /// The returned [Reaction] will have its `id` field set.
  Future<Reaction?> upsertRow(
    _is.DatabaseSession session,
    Reaction row, {
    required _is.ColumnSelections<ReactionTable> conflictColumns,
    _is.ColumnSelections<ReactionTable>? updateColumns,
    _is.WhereExpressionBuilder<ReactionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Reaction>(
      row,
      conflictColumns: conflictColumns(Reaction.t),
      updateColumns: updateColumns?.call(Reaction.t),
      updateWhere: updateWhere?.call(Reaction.t),
      transaction: transaction,
    );
  }

  /// Updates all [Reaction]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Reaction>> update(
    _is.DatabaseSession session,
    List<Reaction> rows, {
    _is.ColumnSelections<ReactionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Reaction>(
      rows,
      columns: columns?.call(Reaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Reaction]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Reaction> updateRow(
    _is.DatabaseSession session,
    Reaction row, {
    _is.ColumnSelections<ReactionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Reaction>(
      row,
      columns: columns?.call(Reaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Reaction] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Reaction?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ReactionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Reaction>(
      id,
      columnValues: columnValues(Reaction.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Reaction]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Reaction>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReactionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ReactionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReactionTable>? orderBy,
    _is.OrderByListBuilder<ReactionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Reaction>(
      columnValues: columnValues(Reaction.t.updateTable),
      where: where(Reaction.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reaction.t),
      orderByList: orderByList?.call(Reaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Reaction]s in the list and returns the deleted rows.
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
  Future<List<Reaction>> delete(
    _is.DatabaseSession session,
    List<Reaction> rows, {
    _is.OrderByBuilder<ReactionTable>? orderBy,
    _is.OrderByListBuilder<ReactionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Reaction>(
      rows,
      orderBy: orderBy?.call(Reaction.t),
      orderByList: orderByList?.call(Reaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Reaction].
  Future<Reaction> deleteRow(
    _is.DatabaseSession session,
    Reaction row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Reaction>(
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
  Future<List<Reaction>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReactionTable> where,
    _is.OrderByBuilder<ReactionTable>? orderBy,
    _is.OrderByListBuilder<ReactionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Reaction>(
      where: where(Reaction.t),
      orderBy: orderBy?.call(Reaction.t),
      orderByList: orderByList?.call(Reaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReactionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Reaction>(
      where: where?.call(Reaction.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Reaction] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReactionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Reaction>(
      where: where(Reaction.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
