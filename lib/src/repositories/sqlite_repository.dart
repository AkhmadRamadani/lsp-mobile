import 'package:lsp_mobile/src/models/cash_flow_model.dart';
import 'package:lsp_mobile/src/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteRepository {
  Database? _database;

  static final SQLiteRepository _instance = SQLiteRepository._internal();

  factory SQLiteRepository() => _instance;

  SQLiteRepository._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      'buku_kas.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE cashflow(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount INTEGER NOT NULL,
            description TEXT NOT NULL,
            date TEXT NOT NULL,
            type INTEGER NOT NULL
          )
        ''');

        await db.insert(
          'users',
          UserModel(
            username: 'admin',
            password: 'admin',
          ).toJson(),
        );
      },
    );
  }

  Future<int> insert(String table, Map<String, Object?> data) async {
    try {
      final db = await database;
      return await db.insert(table, data);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<CashFlowModel>> getAllCashFlow({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final db = await database;
      if (startDate == null || endDate == null) {
        final result = await db.query('cashflow');
        return result.map((e) => CashFlowModel.fromJson(e)).toList();
      }

      final result = await db.query(
        'cashflow',
        where: 'date BETWEEN ? AND ?',
        whereArgs: [
          startDate.toIso8601String(),
          endDate.toIso8601String(),
        ],
      );
      return result.map((e) => CashFlowModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UserModel> updatePassword(UserModel user) async {
    try {
      final db = await database;
      await db.update(
        'users',
        user.toJson(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<
      (
        bool,
        UserModel,
      )> login(String username, String password) async {
    try {
      final db = await database;
      final result = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );
      if (result.isEmpty) {
        return (false, UserModel());
      }
      return (
        true,
        UserModel.fromJson(result.first),
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
