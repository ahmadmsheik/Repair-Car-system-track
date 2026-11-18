import 'package:inter_repair_car/Models/Entities/Expenditure.dart';
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
    final result = await db.rawQuery('''
    SELECT COUNT(*) FROM tasks
    where tasks.status = 'completed'
  ''');
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
                current_mileage INTEGER,
                 vehicle_id INTEGER,
                  Foreign Key (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE)
                  ''');

    // Create Parts table
    await db.execute('''
      CREATE TABLE parts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        supplier TEXT NOT NULL,
        price REAL NOT NULL,
        task_id INTEGER NOT NULL,
        FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE
      )
    ''');

    // Create Clients table
    await db.execute('''
      CREATE TABLE clients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone INTEGER NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE expenditures (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        expense_type TEXT NOT NULL,
        amount REAL NOT NULL,
        due_date TEXT,
        description TEXT
      )
    ''');
  }

  Future<int> insertPart({
    required String name,
    required String supplier,
    required double price,
    required int taskId,
  }) async {
    final db = await database;
    return await db.insert('parts', {
      'name': name,
      'supplier': supplier,
      'price': price,
      'task_id': taskId,
    });
  }

  Future<int> deleteExpenditure(int id) async {
    final db = await database;
    return await db.delete('expenditures', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertExpenditure(Expenditure expenditure) async {
    final db = await database;
    return await db.insert('expenditures', expenditure.toMap());
  }

  Future<int> updateExpenditure(Expenditure expenditure) async {
    final db = await database;
    return await db.update(
      'expenditures',
      expenditure.toMap(),
      where: 'id = ?',
      whereArgs: [expenditure.id],
    );
  }

  Future<List<Expenditure>> getExpenditures() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expenditures');
    return List.generate(maps.length, (i) => Expenditure.fromMap(maps[i]));
  }

  Future<List<Vehicle>> getVehiclesByClientId(int clientId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vehicles',
      where: 'client_id = ?',
      whereArgs: [clientId],
    );
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

  /// Get all parts for a specific task
  Future<List<Map<String, dynamic>>> getPartsByTask(int taskId) async {
    final db = await database;
    return await db.query(
      'parts',
      where: 'task_id = ?',
      whereArgs: [taskId],
      orderBy: 'name ASC',
    );
  }

  /// Get a single part by ID
  Future<Map<String, dynamic>?> getPartById(int partId) async {
    final db = await database;
    final results = await db.query(
      'parts',
      where: 'id = ?',
      whereArgs: [partId],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Update an existing part
  Future<int> updatePart({
    required int id,
    String? name,
    String? supplier,
    double? price,
  }) async {
    final db = await database;
    return await db.update(
      'parts',
      {
        if (name != null) 'name': name,
        if (supplier != null) 'supplier': supplier,
        if (price != null) 'price': price,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete a part by ID
  Future<int> deletePart(int partId) async {
    final db = await database;
    return await db.delete('parts', where: 'id = ?', whereArgs: [partId]);
  }

  /// Delete all parts for a specific task
  Future<int> deletePartsByTask(int taskId) async {
    final db = await database;
    return await db.delete('parts', where: 'task_id = ?', whereArgs: [taskId]);
  }

  /// Calculate total cost of parts for a task
  Future<double> getTotalPartsCostForTask(int taskId) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT SUM(price) as total FROM parts WHERE task_id = ?
    ''',
      [taskId],
    );
    return result.first['total'] as double? ?? 0.0;
  }

  /// Get all parts from all tasks (use with caution for large datasets)
  Future<List<Map<String, dynamic>>> getAllParts() async {
    final db = await database;
    return await db.query('parts', orderBy: 'name ASC');
  }

  /// Search parts by name or supplier
  Future<List<Map<String, dynamic>>> searchParts(String query) async {
    final db = await database;
    return await db.query(
      'parts',
      where: 'name LIKE ? OR supplier LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
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
        currentMileage: maps[i]['current_mileage'],
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
        currentMileage: maps[i]['current_mileage'],
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
        currentMileage: maps[i]['current_mileage'],
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
    return await db.transaction((txn) async {
      // Delete parts first
      await txn.delete('parts', where: 'task_id = ?', whereArgs: [id]);
      // Then delete the task
      return await txn.delete('tasks', where: 'id = ?', whereArgs: [id]);
    });
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
      // Get all vehicles for this user
      final List<Map<String, dynamic>> vehicleMaps = await txn.query(
        'vehicles',
        where: 'client_id = ?',
        whereArgs: [id],
      );

      for (final vehicle in vehicleMaps) {
        final vehicleId = vehicle['id'];

        // Get all tasks for this vehicle
        final List<Map<String, dynamic>> taskMaps = await txn.query(
          'tasks',
          where: 'vehicle_id = ?',
          whereArgs: [vehicleId],
        );

        // Delete parts for each task
        for (final task in taskMaps) {
          final taskId = task['id'];
          await txn.delete('parts', where: 'task_id = ?', whereArgs: [taskId]);
        }

        // Delete tasks for this vehicle
        await txn.delete(
          'tasks',
          where: 'vehicle_id = ?',
          whereArgs: [vehicleId],
        );
      }

      // Delete vehicles for this user
      await txn.delete('vehicles', where: 'client_id = ?', whereArgs: [id]);

      // Finally delete the user
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

    await db.transaction((txn) async {
      // Step 1: Get all tasks for this vehicle
      final List<Map<String, dynamic>> taskMaps = await txn.query(
        'tasks',
        where: 'vehicle_id = ?',
        whereArgs: [id],
      );

      // Step 2: Delete parts for each task
      for (final task in taskMaps) {
        final taskId = task['id'];
        await txn.delete('parts', where: 'task_id = ?', whereArgs: [taskId]);
      }

      // Step 3: Delete all tasks associated with the vehicle
      await txn.delete('tasks', where: 'vehicle_id = ?', whereArgs: [id]);

      // Step 4: Delete the vehicle
      await txn.delete('vehicles', where: 'id = ?', whereArgs: [id]);
    });

    return true;
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
