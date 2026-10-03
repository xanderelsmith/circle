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

abstract class Reaction
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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
  _i1.Table<int?> get table => t;

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
    _i1.WhereExpressionBuilder<ReactionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReactionTable>? orderByList,
    ReactionInclude? include,
  }) {
    return ReactionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reaction.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Reaction.t),
      include: include,
    );
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

class ReactionUpdateTable extends _i1.UpdateTable<ReactionTable> {
  ReactionUpdateTable(super.table);

  _i1.ColumnValue<int, int> postId(int value) => _i1.ColumnValue(
    table.postId,
    value,
  );

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> emoji(String value) => _i1.ColumnValue(
    table.emoji,
    value,
  );
}

class ReactionTable extends _i1.Table<int?> {
  ReactionTable({super.tableRelation}) : super(tableName: 'reaction') {
    updateTable = ReactionUpdateTable(this);
    postId = _i1.ColumnInt(
      'postId',
      this,
    );
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    emoji = _i1.ColumnString(
      'emoji',
      this,
    );
  }

  late final ReactionUpdateTable updateTable;

  late final _i1.ColumnInt postId;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString emoji;

  @override
  List<_i1.Column> get columns => [
    id,
    postId,
    userId,
    emoji,
  ];
}

class ReactionInclude extends _i1.IncludeObject {
  ReactionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Reaction.t;
}

class ReactionIncludeList extends _i1.IncludeList {
  ReactionIncludeList._({
    _i1.WhereExpressionBuilder<ReactionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Reaction.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Reaction.t;
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReactionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReactionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Reaction>(
      where: where?.call(Reaction.t),
      orderBy: orderBy?.call(Reaction.t),
      orderByList: orderByList?.call(Reaction.t),
      orderDescending: orderDescending,
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReactionTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReactionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReactionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Reaction>(
      where: where?.call(Reaction.t),
      orderBy: orderBy?.call(Reaction.t),
      orderByList: orderByList?.call(Reaction.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Reaction] by its [id] or null if no such row exists.
  Future<Reaction?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
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
  Future<List<Reaction>> insert(
    _i1.DatabaseSession session,
    List<Reaction> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Reaction>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Reaction] and returns the inserted row.
  ///
  /// The returned [Reaction] will have its `id` field set.
  Future<Reaction> insertRow(
    _i1.DatabaseSession session,
    Reaction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Reaction>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Reaction]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Reaction>> update(
    _i1.DatabaseSession session,
    List<Reaction> rows, {
    _i1.ColumnSelections<ReactionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Reaction>(
      rows,
      columns: columns?.call(Reaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Reaction]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Reaction> updateRow(
    _i1.DatabaseSession session,
    Reaction row, {
    _i1.ColumnSelections<ReactionTable>? columns,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ReactionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Reaction>(
      id,
      columnValues: columnValues(Reaction.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Reaction]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Reaction>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ReactionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ReactionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReactionTable>? orderBy,
    _i1.OrderByListBuilder<ReactionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Reaction>(
      columnValues: columnValues(Reaction.t.updateTable),
      where: where(Reaction.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reaction.t),
      orderByList: orderByList?.call(Reaction.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Reaction]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Reaction>> delete(
    _i1.DatabaseSession session,
    List<Reaction> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Reaction>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Reaction].
  Future<Reaction> deleteRow(
    _i1.DatabaseSession session,
    Reaction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Reaction>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Reaction>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ReactionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Reaction>(
      where: where(Reaction.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReactionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Reaction>(
      where: where?.call(Reaction.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Reaction] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ReactionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Reaction>(
      where: where(Reaction.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
