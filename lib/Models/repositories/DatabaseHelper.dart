import 'package:inter_repair_car/Models/Entities/Task.dart';
import 'package:inter_repair_car/Models/Entities/User.dart';
import 'package:inter_repair_car/Models/Entities/vehicle.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {

    // Create Vehicles table
    await db.execute('''
        CREATE TABLE vehicles(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          make TEXT not null,
          model TEXT not null,
          year INTEGER null,
          vin TEXT null,
          plate_number TEXT not null,
          engine_type TEXT null,
          mileage INTEGER null,
          image_path TEXT,
          user_id INTEGER null,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');

    // Create Tasks table
    await db.execute('''CREATE TABLE tasks(id INTEGER PRIMARY KEY,
           name TEXT,
            details TEXT,
             status Text,
              time_start TEXT,
               time_end TEXT,
                cost REAL,
                 vehicle_id INTEGER,
                  Foreign Key (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE)
                  ''');

    // Create Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone INTEGER NOT NULL UNIQUE
      )
    ''');
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task(
        name: maps[i]['name'],
        status: maps[i]['status'],
        timeStart: DateTime.parse(maps[i]['time_start']),
        timeEnd:
            maps[i]['time_end'] != null
                ? DateTime.parse(maps[i]['time_end'])
                : null,
        cost: maps[i]['cost'],
        details: maps[i]['details'],
      );
    });
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD operations for User
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User(name: maps[i]['name'], phone: maps[i]['phone']);
    });
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD operations for Vehicle
  Future<int> insertVehicle(Vehicle vehicle) async {
    final db = await database;
    return await db.insert('vehicles', vehicle.toMap());
  }

  Future<List<Vehicle>> getVehicles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('vehicles');
    return List.generate(maps.length, (i) {
      return Vehicle(
        vin: maps[i]['vin'],
        plateNumber: int.parse(maps[i]['plate_number']),
        make: maps[i]['make'],
        model: maps[i]['model'],
        year: maps[i]['year'],
        engineType: maps[i]['engine_type'],
        mileage: maps[i]['mileage'],
      );
    });
  }

  Future<int> updateVehicle(Vehicle vehicle) async {
    final db = await database;
    return await db.update(
      'vehicles',
      vehicle.toMap(),
      where: 'id = ?',
      whereArgs: [vehicle.id],
    );
  }

  Future<int> insertTaskForVehicle(Task task) async {
    final db = await database;

    // Insert the task into the database
    return await db.insert('tasks', task.toMap());
  }

  Future<int> deleteVehicle(int id) async {
    final db = await database;
    return await db.delete('vehicles', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteDatabasef() async {
    // Get the path to the database
    String databasePath2 = join(await getDatabasesPath(), 'app_database.db');

    // Delete the database file
    await deleteDatabase(databasePath2);

    print('Database deleted successfully');
  }
}
