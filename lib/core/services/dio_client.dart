import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:my_test_app/core/constants/api_constants.dart';

class DioClient {
  late final Dio _dio;
  final Logger _logger=Logger(
    printer: PrettyPrinter(
      colors: true,
      printEmojis : true,
      methodCount: 0,
    )
  );

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            _logger.w('🚀 [${options.method}] => PATH: ${options.path}');
            if (options.data != null) {
              _logger.w('📦 BODY: ${options.data}');
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            _logger.i('✅ [${response.statusCode}] => PATH: ${response.requestOptions.path}');
            _logger.i(response.data);
          }
          return handler.next(response);
        },
        onError: (DioException err, handler) {
          if (kDebugMode) {
            _logger.e('❌ [${err.response?.statusCode}] => MSG: ${err.message}');
          }
          return handler.next(err);
        },
      ),
    );
  }

   Dio get instance=>_dio;
}