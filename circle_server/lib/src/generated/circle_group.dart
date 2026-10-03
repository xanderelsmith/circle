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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class CircleGroup
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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
      dailyDeadline: _i1.DateTimeJsonExtension.fromJson(
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
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CircleGroup]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
    _i1.WhereExpressionBuilder<CircleGroupTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CircleGroupTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CircleGroupTable>? orderByList,
    CircleGroupInclude? include,
  }) {
    return CircleGroupIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CircleGroup.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CircleGroup.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
  @_i1.useResult
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

class CircleGroupUpdateTable extends _i1.UpdateTable<CircleGroupTable> {
  CircleGroupUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dailyDeadline(DateTime value) =>
      _i1.ColumnValue(
        table.dailyDeadline,
        value,
      );
}

class CircleGroupTable extends _i1.Table<int?> {
  CircleGroupTable({super.tableRelation}) : super(tableName: 'circle_group') {
    updateTable = CircleGroupUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    dailyDeadline = _i1.ColumnDateTime(
      'dailyDeadline',
      this,
    );
  }

  late final CircleGroupUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnDateTime dailyDeadline;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    dailyDeadline,
  ];
}

class CircleGroupInclude extends _i1.IncludeObject {
  CircleGroupInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CircleGroup.t;
}

class CircleGroupIncludeList extends _i1.IncludeList {
  CircleGroupIncludeList._({
    _i1.WhereExpressionBuilder<CircleGroupTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CircleGroup.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CircleGroup.t;
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CircleGroupTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CircleGroupTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CircleGroupTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CircleGroup>(
      where: where?.call(CircleGroup.t),
      orderBy: orderBy?.call(CircleGroup.t),
      orderByList: orderByList?.call(CircleGroup.t),
      orderDescending: orderDescending,
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CircleGroupTable>? where,
    int? offset,
    _i1.OrderByBuilder<CircleGroupTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CircleGroupTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CircleGroup>(
      where: where?.call(CircleGroup.t),
      orderBy: orderBy?.call(CircleGroup.t),
      orderByList: orderByList?.call(CircleGroup.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CircleGroup] by its [id] or null if no such row exists.
  Future<CircleGroup?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
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
  Future<List<CircleGroup>> insert(
    _i1.DatabaseSession session,
    List<CircleGroup> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CircleGroup>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CircleGroup] and returns the inserted row.
  ///
  /// The returned [CircleGroup] will have its `id` field set.
  Future<CircleGroup> insertRow(
    _i1.DatabaseSession session,
    CircleGroup row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CircleGroup>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CircleGroup]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CircleGroup>> update(
    _i1.DatabaseSession session,
    List<CircleGroup> rows, {
    _i1.ColumnSelections<CircleGroupTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CircleGroup>(
      rows,
      columns: columns?.call(CircleGroup.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CircleGroup]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CircleGroup> updateRow(
    _i1.DatabaseSession session,
    CircleGroup row, {
    _i1.ColumnSelections<CircleGroupTable>? columns,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CircleGroupUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CircleGroup>(
      id,
      columnValues: columnValues(CircleGroup.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CircleGroup]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CircleGroup>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CircleGroupUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CircleGroupTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CircleGroupTable>? orderBy,
    _i1.OrderByListBuilder<CircleGroupTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CircleGroup>(
      columnValues: columnValues(CircleGroup.t.updateTable),
      where: where(CircleGroup.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CircleGroup.t),
      orderByList: orderByList?.call(CircleGroup.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CircleGroup]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CircleGroup>> delete(
    _i1.DatabaseSession session,
    List<CircleGroup> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CircleGroup>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CircleGroup].
  Future<CircleGroup> deleteRow(
    _i1.DatabaseSession session,
    CircleGroup row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CircleGroup>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CircleGroup>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CircleGroupTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CircleGroup>(
      where: where(CircleGroup.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CircleGroupTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CircleGroup>(
      where: where?.call(CircleGroup.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CircleGroup] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CircleGroupTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CircleGroup>(
      where: where(CircleGroup.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
