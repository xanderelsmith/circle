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

abstract class CircleGroup
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      dailyDeadline: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['dailyDeadline'],
      ),
    );
  }

  static final t = CircleGroupTable();

  static const db = CircleGroupRepository._();

  @override
  int? id;

  String name;

  DateTime dailyDeadline;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CircleGroup]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static CircleGroupInclude include() {
    return CircleGroupInclude._();
  }

  static CircleGroupIncludeList includeList({
    _is.WhereExpressionBuilder<CircleGroupTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CircleGroupTable>? orderBy,
    _is.OrderByListBuilder<CircleGroupTable>? orderByList,
    CircleGroupInclude? include,
  }) {
    return CircleGroupIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CircleGroup.t),
      orderByList: orderByList?.call(CircleGroup.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class CircleGroupUpdateTable extends _is.UpdateTable<CircleGroupTable> {
  CircleGroupUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> dailyDeadline(DateTime value) =>
      _is.ColumnValue(
        table.dailyDeadline,
        value,
      );
}

class CircleGroupTable extends _is.Table<int?> {
  CircleGroupTable({super.tableRelation}) : super(tableName: 'circle_group') {
    updateTable = CircleGroupUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    dailyDeadline = _is.ColumnDateTime(
      'dailyDeadline',
      this,
    );
  }

  late final CircleGroupUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnDateTime dailyDeadline;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    dailyDeadline,
  ];
}

class CircleGroupInclude extends _is.IncludeObject {
  CircleGroupInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CircleGroup.t;
}

class CircleGroupIncludeList extends _is.IncludeList {
  CircleGroupIncludeList._({
    _is.WhereExpressionBuilder<CircleGroupTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CircleGroup.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CircleGroup.t;
}

class CircleGroupRepository {
  const CircleGroupRepository._();

  /// Returns a list of [CircleGroup]s matching the given query parameters.
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
  Future<List<CircleGroup>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CircleGroupTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CircleGroupTable>? orderBy,
    _is.OrderByListBuilder<CircleGroupTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CircleGroup>(
      where: where?.call(CircleGroup.t),
      orderBy: orderBy?.call(CircleGroup.t),
      orderByList: orderByList?.call(CircleGroup.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CircleGroup] matching the given query parameters.
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
  Future<CircleGroup?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CircleGroupTable>? where,
    int? offset,
    _is.OrderByBuilder<CircleGroupTable>? orderBy,
    _is.OrderByListBuilder<CircleGroupTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CircleGroup>(
      where: where?.call(CircleGroup.t),
      orderBy: orderBy?.call(CircleGroup.t),
      orderByList: orderByList?.call(CircleGroup.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CircleGroup] by its [id] or null if no such row exists.
  Future<CircleGroup?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CircleGroup>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CircleGroup]s in the list and returns the inserted rows.
  ///
  /// The returned [CircleGroup]s will have their `id` fields set.
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
  Future<List<CircleGroup>> insert(
    _is.DatabaseSession session,
    List<CircleGroup> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CircleGroup>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CircleGroup] and returns the inserted row.
  ///
  /// The returned [CircleGroup] will have its `id` field set.
  Future<CircleGroup> insertRow(
    _is.DatabaseSession session,
    CircleGroup row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CircleGroup>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CircleGroup]s in the list and returns the resulting rows.
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
  /// The returned [CircleGroup]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CircleGroup>> upsert(
    _is.DatabaseSession session,
    List<CircleGroup> rows, {
    required _is.ColumnSelections<CircleGroupTable> conflictColumns,
    _is.ColumnSelections<CircleGroupTable>? updateColumns,
    _is.WhereExpressionBuilder<CircleGroupTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CircleGroup>(
      rows,
      conflictColumns: conflictColumns(CircleGroup.t),
      updateColumns: updateColumns?.call(CircleGroup.t),
      updateWhere: updateWhere?.call(CircleGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CircleGroup] and returns the resulting row.
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
  /// The returned [CircleGroup] will have its `id` field set.
  Future<CircleGroup?> upsertRow(
    _is.DatabaseSession session,
    CircleGroup row, {
    required _is.ColumnSelections<CircleGroupTable> conflictColumns,
    _is.ColumnSelections<CircleGroupTable>? updateColumns,
    _is.WhereExpressionBuilder<CircleGroupTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CircleGroup>(
      row,
      conflictColumns: conflictColumns(CircleGroup.t),
      updateColumns: updateColumns?.call(CircleGroup.t),
      updateWhere: updateWhere?.call(CircleGroup.t),
      transaction: transaction,
    );
  }

  /// Updates all [CircleGroup]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CircleGroup>> update(
    _is.DatabaseSession session,
    List<CircleGroup> rows, {
    _is.ColumnSelections<CircleGroupTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CircleGroup>(
      rows,
      columns: columns?.call(CircleGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CircleGroup]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CircleGroup> updateRow(
    _is.DatabaseSession session,
    CircleGroup row, {
    _is.ColumnSelections<CircleGroupTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CircleGroup>(
      row,
      columns: columns?.call(CircleGroup.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CircleGroup] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CircleGroup?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CircleGroupUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CircleGroup>(
      id,
      columnValues: columnValues(CircleGroup.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CircleGroup]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CircleGroup>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CircleGroupUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CircleGroupTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CircleGroupTable>? orderBy,
    _is.OrderByListBuilder<CircleGroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CircleGroup>(
      columnValues: columnValues(CircleGroup.t.updateTable),
      where: where(CircleGroup.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CircleGroup.t),
      orderByList: orderByList?.call(CircleGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CircleGroup]s in the list and returns the deleted rows.
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
  Future<List<CircleGroup>> delete(
    _is.DatabaseSession session,
    List<CircleGroup> rows, {
    _is.OrderByBuilder<CircleGroupTable>? orderBy,
    _is.OrderByListBuilder<CircleGroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CircleGroup>(
      rows,
      orderBy: orderBy?.call(CircleGroup.t),
      orderByList: orderByList?.call(CircleGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CircleGroup].
  Future<CircleGroup> deleteRow(
    _is.DatabaseSession session,
    CircleGroup row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CircleGroup>(
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
  Future<List<CircleGroup>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CircleGroupTable> where,
    _is.OrderByBuilder<CircleGroupTable>? orderBy,
    _is.OrderByListBuilder<CircleGroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CircleGroup>(
      where: where(CircleGroup.t),
      orderBy: orderBy?.call(CircleGroup.t),
      orderByList: orderByList?.call(CircleGroup.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CircleGroupTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CircleGroup>(
      where: where?.call(CircleGroup.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CircleGroup] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CircleGroupTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CircleGroup>(
      where: where(CircleGroup.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
