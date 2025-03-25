import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Controllers/authentication_controller.dart';
import 'package:inter_repair_car/Core/Network/DioClient.dart';
import 'package:inter_repair_car/Models/Entities/Task.dart';
import 'package:inter_repair_car/Models/Entities/Client.dart';
import 'package:inter_repair_car/Models/Entities/vehicle.dart';
import 'package:inter_repair_car/Models/repositories/DatabaseHelper.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class BackUpController extends GetxController {
  final dio = getInstance();
  final dbHelper = DatabaseHelper();
  final authenticationController = Get.put(AuthenticationController());
  final logger = Logger();
  final RxBool isBackingUp = false.obs;
  final RxBool isRestoring = false.obs;

  Future<void> backupData() async {
    try {
      isBackingUp.value = true;
      final clients = await dbHelper.getUsers();
      final vehicles = await dbHelper.getVehicles();
      final tasks = await dbHelper.getTasks();

      final payload = jsonEncode({
        "clients": clients.map((client) => client.toMap()).toList(),
        
        "vehicles": vehicles.map((vehicle) => vehicle.toMap()).toList(),
        "tasks": tasks.map((task) => task.toMap()).toList(),
      });

      final response = await dio.post(
        'backupData',
        data: payload,
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${authenticationController.authToken.value}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        _showSuccess('Backup successful!');
        logger.i('Backup successful: ${response.data}');
      } else {
        _handleError('Backup failed: ${response.data}');
      }
    } on DioException catch (e) {
      final errorMessage = _dioErrorToString(e);
      _handleError('Backup failed: $errorMessage');
      logger.e('Dio error during backup', error: e, stackTrace: e.stackTrace);
    } catch (e, stackTrace) {
      _handleError('Unexpected backup error: ${e.toString()}');
      logger.e('Unexpected backup error', error: e, stackTrace: stackTrace);
    } finally {
      isBackingUp.value = false;
    }
  }

  Future<void> restoreFromCloud() async {
    try {
      isRestoring.value = true;
      final response = await dio.get(
        'sendData',
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${authenticationController.authToken.value}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Server responded with status code ${response.statusCode}',
        );
      }

      final cloudData = response.data['data'];
      final db = await dbHelper.database;

      await db.transaction((txn) async {
        // Clear existing data
        await txn.delete('tasks');
        await txn.delete('vehicles');
        await txn.delete('clients');

        // Parse and insert new data
        final clients = _parseEntities<Client>(
          cloudData['clients'],
          Client.fromJson,
          'clients',
        );

        final vehicles = _parseEntities<Vehicle>(
          cloudData['vehicles'],
          Vehicle.fromJson,
          'vehicles',
        );

        final tasks = _parseEntities<Task>(
          cloudData['tasks'],
          Task.fromJson,
          'tasks',
        );

        final batch = txn.batch();
        _insertEntities(batch, 'clients', clients);
        _insertEntities(batch, 'vehicles', vehicles);
        _insertEntities(batch, 'tasks', tasks);
        await batch.commit(noResult: true);

        _showSuccess(
          'Restored ${clients.length} clients, '
          '${vehicles.length} vehicles, '
          '${tasks.length} tasks',
        );
      });
    } on DioException catch (e) {
      final errorMessage = _dioErrorToString(e);
      _handleError('Restore failed: $errorMessage');
      logger.e('Dio error during restore', error: e, stackTrace: e.stackTrace);
    } catch (e, stackTrace) {
      _handleError('Restore failed: ${e.toString()}');
      logger.e('Unexpected restore error', error: e, stackTrace: stackTrace);
      rethrow;
    } finally {
      isRestoring.value = false;
    }
  }

  List<T> _parseEntities<T>(
    List<dynamic> data,
    T Function(Map<String, dynamic>) fromJson,
    String entityName,
  ) {
    try {
      return data.map((json) => fromJson(json)).toList();
    } catch (e) {
      throw FormatException('Failed to parse $entityName: ${e.toString()}');
    }
  }

  void _insertEntities(Batch batch, String table, List<dynamic> entities) {
    for (final entity in entities) {
      batch.insert(table, entity.toMap());
    }
  }

  String _dioErrorToString(DioException e) {
    if (e.response != null) {
      return 'Server error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
    }
    return 'Network error: ${e.message}';
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green.withValues(alpha: .9),
      colorText: Colors.white,
    );
    logger.i(message);
  }

  void _handleError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.withValues(alpha: .9),
      colorText: Colors.white,
    );
    logger.e(message);
  }
}
