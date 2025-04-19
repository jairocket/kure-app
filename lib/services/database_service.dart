import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  
  final String _patientsTableName = 'patients';
  final String _patientsIdColumnName = 'id';
  final String _patientsNameColumnName = 'name';
  final String _patientsCPFColumnName = 'cpf';
  final String _patientsPhoneColumnName = 'phone';
  final String _patientsBirthdayColumnName = 'birthday';
  final String _patientsGenderColumnName = 'gender';

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirectoryPath = await getDatabasesPath();
    final databasePath = join(databaseDirectoryPath, 'k_database.db');

    final database = openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
            CREATE TABLE $_patientsTableName IF NOT EXISTS (
              $_patientsIdColumnName INT PRIMARY KEY NOT NULL, 
              $_patientsNameColumnName TEXT NOT NULL, 
              $_patientsCPFColumnName TEXT UNIQUE NOT NULL, 
              $_patientsPhoneColumnName TEXT NOT NULL, 
              $_patientsBirthdayColumnName TEXT NOT NULL,
              $_patientsGenderColumnName TEXT NOT NULL
            )                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
          ''');
      },
    );
    return database;
  }

  void savePatient (
    String name, 
    String cpf,
    String phone,
    String birthday,
    String gender
  ) async {
    final db = await database;
    await db.insert(
      _patientsTableName, 
      {
        _patientsNameColumnName: name,
        _patientsCPFColumnName: cpf,
        _patientsPhoneColumnName: phone,
        _patientsBirthdayColumnName: birthday,
        _patientsGenderColumnName: gender
      }
    );
  }


}
