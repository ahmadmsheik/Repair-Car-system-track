import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:inter_repair_car/Core/Network/DioClient.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';

class AuthenticationController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final RxString userName = "".obs;
  final RxString authToken = "".obs;
  final Rx<DateTime> joinDate = DateTime.now().obs;

  final RxInt userId = 0.obs;
  final dio = getInstance();
  final logger = Logger();

  final RxBool isLoading = false.obs;

  Future<bool> signIn(String username, String password) async {
    try {
      final response = await dio.post(
        'signIn',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final userData = response.data['user'];
        _updateUserProfile(
          username: userData['username'],
          token: response.data['token'],
          userId: userData['id'],
          joinDate: DateTime.parse(userData['created_at']),
        );

        return true;
      }
      _handleError(
        'Invalid credentials',
        'Please check your username/password',
      );
      return false;
    } on DioException catch (e) {
      _handleDioError(e, 'Sign In Failed');
      return false;
    } catch (e, stackTrace) {
      _handleGenericError(e, stackTrace, 'Sign In Error');
      return false;
    }
  }

  void _updateUserProfile({
    required String username,
    required String token,
    required int userId,
    required DateTime joinDate,
  }) {
    isLoggedIn.value = true;
    userName.value = username;
    authToken.value = token;
    this.userId.value = userId;
    this.joinDate.value = joinDate;
  }

  Future<bool> register(String username, String password) async {
    try {
      isLoading.value = true;
      final response = await dio.post(
        'register',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 201) {
        final userData = response.data['user'];
        _updateUserProfile(
          username: userData['username'],
          token: response.data['token'],
          userId: userData['id'],
          joinDate: DateTime.parse(userData['created_at']),
        );
        _handleAuthSuccess(
          username,
          response.data['token'],
          'Registration successful!',
        );
        return true;
      }
      _handleError(
        'Registration failed',
        response.data['message'] ?? 'Unknown error',
      );
      return false;
    } on DioException catch (e) {
      _handleDioError(e, 'Registration Failed');
      return false;
    } catch (e, stackTrace) {
      _handleGenericError(e, stackTrace, 'Registration Error');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      final response = await dio.post(
        'logout',
        options: Options(
          headers: {'Authorization': 'Bearer ${authToken.value}'},
        ),
      );

      if (response.statusCode == 200) {
        _resetAuthState();
        _showSuccess('Logged out successfully');
        logger.i('User logged out: ${userName.value}');
      } else {
        _handleError(
          'Logout failed',
          response.data['message'] ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      _handleDioError(e, 'Logout Failed');
    } catch (e, stackTrace) {
      _handleGenericError(e, stackTrace, 'Logout Error');
    } finally {
      isLoading.value = false;
    }
  }

  void _handleAuthSuccess(String username, String token, String message) {
    isLoggedIn.value = true;
    userName.value = username;
    authToken.value = token;
    _showSuccess(message);
    logger.i('$message - User: $username');
  }

  void _resetAuthState() {
    isLoggedIn.value = false;
    userName.value = "";
    authToken.value = "";
  }

  void _handleDioError(DioException e, String title) {
    final errorMessage = _parseDioError(e);
    _handleError(title, errorMessage);
    logger.e('$title: $errorMessage', error: e, stackTrace: e.stackTrace);
  }

  void _handleGenericError(dynamic e, StackTrace stackTrace, String title) {
    final errorMessage = e.toString();
    _handleError(title, errorMessage);
    logger.e('$title: $errorMessage', error: e, stackTrace: stackTrace);
  }

  String _parseDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final serverMessage = e.response?.data['message'] ?? 'No server message';
      return 'Server error ($statusCode): $serverMessage';
    }
    return 'Network error: ${e.message}';
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green.withValues(alpha: .9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _handleError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red.withValues(alpha: .9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
