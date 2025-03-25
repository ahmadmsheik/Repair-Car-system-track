import 'package:inter_repair_car/Models/Entities/Task.dart';
import 'package:inter_repair_car/Models/Entities/Client.dart';
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

  // Add to DatabaseHelper class
  Future<int> countCompletedTasks() async {
    final db = await database;
    final result = await db.rawQuery(
      '''
    SELECT COUNT(*) FROM tasks
    where tasks.status = 'completed'
  ''',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<DateTime> getClientJoinDate(int clientId) async {
    final db = await database;
    final result = await db.query(
      'clients',
      columns: ['created_at'],
      where: 'id = ?',
      whereArgs: [clientId],
    );
    return DateTime.parse(result.first['created_at'] as String);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Vehicles table
    await db.execute('''
        CREATE TABLE vehicles(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          make TEXT not null,
          model TEXT not null,
          year INTEGER not null,
          vin TEXT null,
          plate_number TEXT not null,
          engine_type TEXT null,
          mileage INTEGER null,
          image_path TEXT,
          client_id INTEGER null,
          FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
        )
      ''');

    // Create Tasks table
    await db.execute('''CREATE TABLE tasks(id INTEGER PRIMARY KEY,
           name TEXT,
            details TEXT null,
             status Text,
              start_time TEXT,
               end_time TEXT null,
                cost REAL,
                 vehicle_id INTEGER,
                  Foreign Key (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE)
                  ''');

    // Create Clients table
    await db.execute('''
      CREATE TABLE clients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone INTEGER NOT NULL UNIQUE
      )
    ''');
  }

  Future<List<Task>> getTasksByStatus(String status) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'status = ?', // Filter by status
      whereArgs: [status],
    );
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        name: maps[i]['name'],
        status: maps[i]['status'],
        timeStart: DateTime.parse(maps[i]['start_time']),
        timeEnd:
            maps[i]['end_time'] != null
                ? DateTime.parse(maps[i]['end_time'])
                : null,
        cost: maps[i]['cost'],
        details: maps[i]['details'],
        vehicleId: maps[i]['vehicle_id'],
      );
    });
  }

  Future<Client> getUserById(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'clients',
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) {
      return Client(
        id: maps[0]['id'],
        name: maps[0]['name'],
        phone: maps[0]['phone'],
      );
    }
    throw Exception('Client not found');
  }

  Future<List<Task>> getTasksByVehicleId(int vehicleId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
    );
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        name: maps[i]['name'],
        status: maps[i]['status'],
        timeStart: DateTime.parse(maps[i]['start_time']),
        timeEnd:
            maps[i]['end_time'] != null
                ? DateTime.parse(maps[i]['end_time'])
                : null,
        cost: maps[i]['cost'],
        details: maps[i]['details'],
        vehicleId: maps[i]['vehicle_id'],
      );
    });
  }

  Future<int> deleteTasksByVehicleId(int vehicleId) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
    );
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
        id: maps[i]["id"],
        name: maps[i]['name'],
        status: maps[i]['status'],
        timeStart: DateTime.parse(maps[i]['start_time']),
        timeEnd:
            maps[i]['end_time'] != null
                ? DateTime.parse(maps[i]['end_time'])
                : null,
        cost: maps[i]['cost'],
        details: maps[i]['details'],
        vehicleId: maps[i]['vehicle_id'],
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

  Future<int> updateTaskStatus(
    int taskId,
    String newStatus,
    DateTime? timeEnd,
  ) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'status': newStatus, 'end_time': timeEnd?.toIso8601String()},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD operations for User
  Future<int> insertUser(Client user) async {
    final db = await database;
    return await db.insert('clients', user.toMap());
  }

  Future<List<Client>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('clients');
    return List.generate(maps.length, (i) {
      return Client(
        id: maps[i]['id'],
        name: maps[i]['name'],
        phone: maps[i]['phone'],
      );
    });
  }

  Future<int> updateUser(Client user) async {
    final db = await database;
    return await db.update(
      'clients',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<bool> deleteUser(int id) async {
    final db = await database;

    await db.transaction((txn) async {
      final List<Map<String, dynamic>> vehicleMaps = await txn.query(
        'vehicles',
        where: 'client_id = ?',
        whereArgs: [id],
      );

      for (final vehicle in vehicleMaps) {
        final vehicleId = vehicle['id'];
        await txn.delete(
          'tasks',
          where: 'vehicle_id = ?',
          whereArgs: [vehicleId],
        );
      }

      await txn.delete('vehicles', where: 'client_id = ?', whereArgs: [id]);

      await txn.delete('clients', where: 'id = ?', whereArgs: [id]);
    });

    return true;
  }

  // CRUD operations for Vehicle
  Future<int> insertVehicle(Vehicle vehicle) async {
    final db = await database;
    return await db.insert('vehicles', vehicle.toMap());
  }

  Future<Client?> getUserByPhone(int phone) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'clients',
      where: 'phone = ?',
      whereArgs: [phone],
    );
    if (maps.isNotEmpty) {
      return Client(
        id: maps[0]['id'],
        name: maps[0]['name'],
        phone: maps[0]['phone'],
      );
    }
    return null;
  }

  Future<Vehicle?> getVehicleByVin(String vin) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vehicles',
      where: 'vin = ?',
      whereArgs: [vin],
    );
    if (maps.isNotEmpty) {
      return Vehicle(
        id: maps[0]['id'],
        vin: maps[0]['vin'],
        plateNumber: int.parse(maps[0]['plate_number']),
        make: maps[0]['make'],
        model: maps[0]['model'],
        year: maps[0]['year'],
        engineType: maps[0]['engine_type'],
        mileage: maps[0]['mileage'],
        imagePath: maps[0]['image_path'],
        clientId: maps[0]['client_id'],
      );
    }
    return null; // Return null if no vehicle is found
  }

  Future<List<Vehicle>> getVehicles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('vehicles');
    return List.generate(maps.length, (i) {
      return Vehicle(
        id: maps[i]['id'],
        vin: maps[i]['vin'],
        plateNumber: int.parse(maps[i]['plate_number']),
        make: maps[i]['make'],
        model: maps[i]['model'],
        year: maps[i]['year'],
        engineType: maps[i]['engine_type'],
        mileage: maps[i]['mileage'],
        imagePath: maps[i]['image_path'],
        clientId: maps[i]['client_id'],
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

  Future<bool> deleteVehicle(int id) async {
    final db = await database;

    // Start a transaction to ensure atomicity
    await db.transaction((txn) async {
      // Step 1: Delete all tasks associated with the vehicle
      await txn.delete('tasks', where: 'vehicle_id = ?', whereArgs: [id]);

      // Step 2: Delete the vehicle
      await txn.delete('vehicles', where: 'id = ?', whereArgs: [id]);
    });

    return true; // Return true if the operation succeeds
  }

  Future<double> calculateTotalCostForVehicle(int vehicleId) async {
    final db = await database;

    // Query the database for tasks associated with the vehicle
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where:
          'vehicle_id = ? AND status = ?', // Filter by vehicle ID and ongoing status
      whereArgs: [vehicleId, 'onGoing'],
    );

    // Calculate the total cost
    double totalCost = 0.0;
    for (final map in maps) {
      totalCost += map['cost'] ?? 0.0; // Add the cost of each task
    }

    return totalCost;
  }

  Future<void> deleteDatabasef() async {
    // Get the path to the database
    String databasePath2 = join(await getDatabasesPath(), 'app_database.db');

    // Delete the database file
    await deleteDatabase(databasePath2);
  }

  Future<Vehicle?> getVehicleById(int vehicleId) async {
    final db = await database;

    // Query the database for the vehicle with the given ID
    final List<Map<String, dynamic>> maps = await db.query(
      'vehicles',
      where: 'id = ?',
      whereArgs: [vehicleId],
    );

    // If a vehicle is found, return it as a Vehicle object
    if (maps.isNotEmpty) {
      return Vehicle(
        id: maps[0]['id'],
        vin: maps[0]['vin'],
        plateNumber: int.parse(maps[0]['plate_number']),
        make: maps[0]['make'],
        model: maps[0]['model'],
        year: maps[0]['year'],
        engineType: maps[0]['engine_type'],
        mileage: maps[0]['mileage'],
        imagePath: maps[0]['image_path'],
        clientId: maps[0]['client_id'],
      );
    }

    // If no vehicle is found, return null
    return null;
  }

  Future<int> deleteAllClients() async {
    final db = await database;
    return await db.delete('clients');
  }

  Future<int> deleteAllVehicles() async {
    final db = await database;
    return await db.delete('vehicles');
  }

  Future<int> deleteAllTasks() async {
    final db = await database;
    return await db.delete('tasks');
  }

  Future<Client?> getOwnerByVehicleId(int vehicleId) async {
    final db = await database;

    // First, get the client_id from the vehicles table
    final List<Map<String, dynamic>> vehicleMaps = await db.query(
      'vehicles',
      where: 'id = ?',
      whereArgs: [vehicleId],
    );

    if (vehicleMaps.isEmpty) {
      return null; // No vehicle found with the given ID
    }

    final int? clientId = vehicleMaps[0]['client_id'];

    if (clientId == null) {
      return null; // No client_id associated with the vehicle
    }

    // Query the clients table to get the owner
    final List<Map<String, dynamic>> clientMaps = await db.query(
      'clients',
      where: 'id = ?',
      whereArgs: [clientId],
    );

    if (clientMaps.isNotEmpty) {
      return Client(
        id: clientMaps[0]['id'],
        name: clientMaps[0]['name'],
        phone: clientMaps[0]['phone'],
      );
    }

    return null;
  }
}
