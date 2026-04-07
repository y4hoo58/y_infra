import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'builder/query/i_query_builder.dart';
import 'mapper/delete/i_db_delete_data_mapper.dart';
import 'mapper/insert/i_db_data_mapper.dart';
import 'mapper/insert/i_db_insert_data_mapper.dart';
import 'mapper/insert/i_db_insert_data_raw_mapper.dart';
import 'mapper/update/i_db_update_data_mapper.dart';
import 'objects/i_database_table.dart';

/// Abstract interface for managing SQLite database operations
/// including CRUD, table creation, and lifecycle management.
abstract class IDbManager {
  final String dbName;
  final int dbVersion;

  IDbManager({required this.dbName, required this.dbVersion});

  static final insertStream = StreamController<IDbDataMapper>.broadcast();

  Future<String> get dbPath async => '${await getDatabasesPath()}/$dbName';

  Future<void> createTable(IDatabaseTable table);
  Future<void> insert(IDatabaseTable table, IDbInsertDataMapper mapper);
  Future<void> insertRaw(IDatabaseTable table, IDbInsertDataRawMapper mapper);
  Future<List<Map<String, Object?>>> query(IDatabaseTable table);
  Future<List<Map<String, Object?>>> queryRaw(
    IDatabaseTable table,
    IQueryBuilder queryBuilder,
  );
  Future<void> update(IDatabaseTable table, IDbUpdateDataMapper mapper);
  Future<void> delete(IDatabaseTable table, IDbDeleteDataMapper mapper);
  Future<void> deleteAll(IDatabaseTable table);
  Future<void> deleteDb();
  Future<void> dispose();
}
