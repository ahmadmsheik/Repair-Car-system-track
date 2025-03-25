import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

Dio getInstance() {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000/api/',
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 5),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus:
          (status) => status! >= 200 && status < 400, // Accept 2xx and 3xx
      followRedirects: true, // Enable following redirects
      maxRedirects: 5, // Limit number of redirects
    ),
  );

  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
  );

  return dio;
}
