import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirectoryPath = await getDatabasesPath();
    final databasePath = join(databaseDirectoryPath, 'kure_database.db');
    //await deleteDatabase(databasePath);

    final database = await openDatabase(
      databasePath,
      version: 8,
      onConfigure: (db) async => await db.execute("PRAGMA foreign_keys = ON"),
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE IF NOT EXISTS 'patients' (
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
              name TEXT NOT NULL, 
              cpf TEXT UNIQUE NOT NULL, 
              phone TEXT NOT NULL, 
              birthday TEXT NOT NULL,
              gender TEXT NOT NULL
            )                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
          ''');

        await db.execute('''
            CREATE TABLE IF NOT EXISTS 'addresses' (
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
              cep TEXT NOT NULL,
              street TEXT NOT NULL, 
              number TEXT NOT NULL, 
              complement TEXT, 
              neighborhood TEXT NOT NULL,
              city TEXT NOT NULL,
              state TEXT NOT NULL,
              patient_id INTEGER NOT NULL,
              FOREIGN KEY (patient_id) REFERENCES 'patients' (id)
            );                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
          ''');

        await db.execute('''
            CREATE TABLE IF NOT EXISTS 'doctors' (
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
              name TEXT NOT NULL,
              crm TEXT UNIQUE NOT NULL,
              phone TEXT UNIQUE NOT NULL,
              email TEXT UNIQUE NOT NULL,
              password TEXT NOT NULL
            )        
          ''');

        await db.execute('''
            CREATE TABLE IF NOT EXISTS 'appointments' (
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              doctor_id INTEGER NOT NULL,
              patient_id INTEGER NOT NULL,
              date TEXT NOT NULL,
              time TEXT NOT NULL,
              cancelled INTEGER NOT NULL,
              price_in_cents INTEGER NOT NULL
            )
          ''');
      },
    );
    return database;
  }
}
