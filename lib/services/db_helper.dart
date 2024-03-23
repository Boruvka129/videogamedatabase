import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;
  static final DBHelper instance = DBHelper._();

  DBHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        profile_picture BLOB
      )
    ''');

    await db.execute('''
      CREATE TABLE favorite_games (
        id INTEGER PRIMARY KEY, 
        user_id TEXT,
        game_name TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id) 
      )
    ''');
  }
  Future<void> insertUserData(String id, Uint8List profilePicture) async {
    final db = await instance.database;

    final existingUser = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (existingUser.isEmpty) {
      await db.insert('users', {'id': id, 'profile_picture': profilePicture});
    } else { 
      await updateProfilePicture(id, profilePicture); 
    }
  }

 Future<void> updateProfilePicture(String id, Uint8List profilePicture) async {
  final db = await instance.database;
  await db.update(
    'users',
    { 'profile_picture': profilePicture },
    where: 'id = ?',
    whereArgs: [id],
  );
}

  Future<void> addFavoriteGame(String userId, String gameId) async {
    final db = await instance.database;
    await db.insert('favorite_games', {
      'user_id': userId,
      'game_name': gameId
    });
  }

  Future<void> removeFavoriteGame(String userId, String gameName) async {
    final db = await instance.database;
    await db.delete('favorite_games',
      where: 'user_id = ? AND game_name = ?', whereArgs: [userId, gameName]);
  }

  Future<List<String>> getFavoriteGames(String userId) async {
    final db = await instance.database;
    final result = await db.query('favorite_games',
      columns: ['game_name'], where: 'user_id = ?', whereArgs: [userId]);
    return result.map((e) => e['game_name'] as String).toList();
  }

 Future<Uint8List> getUserImage(String userId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['profile_picture'],
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {

      return result[0]['profile_picture'];
    } else {


      return Uint8List(0);

    }

  }

}
