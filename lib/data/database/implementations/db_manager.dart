import 'package:sqflite/sqflite.dart';

import '../builder/command/implementations/create_table_command_builder.dart';
import '../builder/command/implementations/insert_command_builder.dart';
import '../builder/command/implementations/query_command_builder.dart';
import '../builder/query/i_query_builder.dart';
import '../i_db_manager.dart';
import '../mapper/delete/i_db_delete_data_mapper.dart';
import '../mapper/insert/i_db_insert_data_mapper.dart';
import '../mapper/insert/i_db_insert_data_raw_mapper.dart';
import '../mapper/update/i_db_update_data_mapper.dart';
import '../objects/i_database_table.dart';

/// Concrete SQLite database manager that handles table creation on open
/// and delegates command building to dedicated builder classes.
class DbManager extends IDbManager {
  final List<IDatabaseTable> initialTables;

  DbManager({
    required super.dbName,
    required this.initialTables,
    super.dbVersion = 1,
  });

  Database? db;

  Future<Database> get _db async {
    return openDatabase(
      await dbPath,
      version: dbVersion,
      onCreate: (db, version) {
        for (final table in initialTables) {
          final cmd = CreateTableCommandBuilder(table).command;
          db.execute(cmd);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) {},
      onDowngrade: (db, oldVersion, newVersion) {},
    );
  }

  @override
  Future<void> createTable(IDatabaseTable table) async {
    db ??= await _db;
    final cmd = CreateTableCommandBuilder(table).command;
    await db!.execute(cmd);
  }

  @override
  Future<void> insert(IDatabaseTable table, IDbInsertDataMapper mapper) async {
    if (db == null) await createTable(table);
    await db!.insert(table.name, mapper.values);
    IDbManager.insertStream.add(mapper);
  }

  @override
  Future<void> insertRaw(
    IDatabaseTable table,
    IDbInsertDataRawMapper mapper,
  ) async {
    if (db == null) await createTable(table);
    final cmd = InsertCommandBuilder(table, mapper).command;
    await db!.execute(cmd);
    IDbManager.insertStream.add(mapper);
  }

  @override
  Future<List<Map<String, Object?>>> query(IDatabaseTable table) async {
    if (db == null) await createTable(table);
    return await db!.query(table.name);
  }

  @override
  Future<List<Map<String, Object?>>> queryRaw(
    IDatabaseTable table,
    IQueryBuilder queryBuilder,
  ) async {
    if (db == null) await createTable(table);
    final cmd = QueryCommandBuilder(table, queryBuilder).command;
    return await db!.rawQuery(cmd);
  }

  @override
  Future<void> update(IDatabaseTable table, IDbUpdateDataMapper mapper) async {
    if (db == null) return;
    await db?.update(
      table.name,
      mapper.values,
      where: 'id = ?',
      whereArgs: [mapper.index],
    );
  }

  @override
  Future<void> delete(IDatabaseTable table, IDbDeleteDataMapper mapper) async {
    if (db == null) return;
    await db?.delete(
      table.name,
      where: 'id = ?',
      whereArgs: [mapper.index],
    );
  }

  @override
  Future<void> deleteAll(IDatabaseTable table) async {
    try {
      if (db == null) await createTable(table);
      await db!.delete(table.name);
    } catch (_) {}
  }

  @override
  Future<void> deleteDb() async {
    await deleteDatabase(await dbPath);
  }

  @override
  Future<void> dispose() async {
    await db?.close();
  }
}
