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

abstract class ProofPost
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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
  _i1.Table<int?> get table => t;

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
    _i1.WhereExpressionBuilder<ProofPostTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProofPostTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProofPostTable>? orderByList,
    ProofPostInclude? include,
  }) {
    return ProofPostIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProofPost.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ProofPost.t),
      include: include,
    );
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

class ProofPostUpdateTable extends _i1.UpdateTable<ProofPostTable> {
  ProofPostUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> circleId(int value) => _i1.ColumnValue(
    table.circleId,
    value,
  );

  _i1.ColumnValue<String, String> imageUrl(String value) => _i1.ColumnValue(
    table.imageUrl,
    value,
  );

  _i1.ColumnValue<String, String> caption(String value) => _i1.ColumnValue(
    table.caption,
    value,
  );

  _i1.ColumnValue<bool, bool> isVerified(bool value) => _i1.ColumnValue(
    table.isVerified,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class ProofPostTable extends _i1.Table<int?> {
  ProofPostTable({super.tableRelation}) : super(tableName: 'proof_post') {
    updateTable = ProofPostUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    circleId = _i1.ColumnInt(
      'circleId',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    caption = _i1.ColumnString(
      'caption',
      this,
    );
    isVerified = _i1.ColumnBool(
      'isVerified',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final ProofPostUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnInt circleId;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnString caption;

  late final _i1.ColumnBool isVerified;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    circleId,
    imageUrl,
    caption,
    isVerified,
    createdAt,
  ];
}

class ProofPostInclude extends _i1.IncludeObject {
  ProofPostInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ProofPost.t;
}

class ProofPostIncludeList extends _i1.IncludeList {
  ProofPostIncludeList._({
    _i1.WhereExpressionBuilder<ProofPostTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProofPost.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ProofPost.t;
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProofPostTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProofPostTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProofPostTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProofPost>(
      where: where?.call(ProofPost.t),
      orderBy: orderBy?.call(ProofPost.t),
      orderByList: orderByList?.call(ProofPost.t),
      orderDescending: orderDescending,
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProofPostTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProofPostTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProofPostTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProofPost>(
      where: where?.call(ProofPost.t),
      orderBy: orderBy?.call(ProofPost.t),
      orderByList: orderByList?.call(ProofPost.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProofPost] by its [id] or null if no such row exists.
  Future<ProofPost?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
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
  Future<List<ProofPost>> insert(
    _i1.DatabaseSession session,
    List<ProofPost> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ProofPost>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ProofPost] and returns the inserted row.
  ///
  /// The returned [ProofPost] will have its `id` field set.
  Future<ProofPost> insertRow(
    _i1.DatabaseSession session,
    ProofPost row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProofPost>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ProofPost]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ProofPost>> update(
    _i1.DatabaseSession session,
    List<ProofPost> rows, {
    _i1.ColumnSelections<ProofPostTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ProofPost>(
      rows,
      columns: columns?.call(ProofPost.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProofPost]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProofPost> updateRow(
    _i1.DatabaseSession session,
    ProofPost row, {
    _i1.ColumnSelections<ProofPostTable>? columns,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ProofPostUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ProofPost>(
      id,
      columnValues: columnValues(ProofPost.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProofPost]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ProofPost>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProofPostUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ProofPostTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProofPostTable>? orderBy,
    _i1.OrderByListBuilder<ProofPostTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ProofPost>(
      columnValues: columnValues(ProofPost.t.updateTable),
      where: where(ProofPost.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProofPost.t),
      orderByList: orderByList?.call(ProofPost.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ProofPost]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ProofPost>> delete(
    _i1.DatabaseSession session,
    List<ProofPost> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ProofPost>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ProofPost].
  Future<ProofPost> deleteRow(
    _i1.DatabaseSession session,
    ProofPost row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProofPost>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ProofPost>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProofPostTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ProofPost>(
      where: where(ProofPost.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProofPostTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ProofPost>(
      where: where?.call(ProofPost.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProofPost] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProofPostTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProofPost>(
      where: where(ProofPost.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
