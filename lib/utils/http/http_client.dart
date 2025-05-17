import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_ui/utils/http/utils.dart';
import 'package:uuid/uuid.dart';

import 'http_exception.dart';
import 'http_file.dart';

typedef HttpResponseType = ResponseType;
typedef HttpProgressCallback = ProgressCallback;

class HttpClientConfig {
  const HttpClientConfig({
    this.baseUrl = '',
    this.headers,
    this.connectTimeout = const Duration(seconds: 10),
    this.sendTimeout = const Duration(seconds: 60),
    this.receiveTimeout = const Duration(seconds: 60),
    this.enableLogs = false,
  });

  HttpClientConfig copyWith({
    String? baseUrl,
    Map<String, String>? headers,
    Duration? connectTimeout,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    bool? enableLogs,
  }) {
    return HttpClientConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      headers: headers ?? this.headers,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      enableLogs: enableLogs ?? this.enableLogs,
    );
  }

  final String baseUrl;
  final Map<String, String>? headers;
  final Duration connectTimeout;
  final Duration sendTimeout;
  final Duration receiveTimeout;
  final bool enableLogs;
}

enum HttpMethod {
  get,
  post,
  put,
  patch,
  delete;

  String call() => name.toUpperCase();
}

const uuid = Uuid();

/// General Repository to interact with any REST AP
class HttpClient {
  HttpClient({required this.clientConfig}) : id = uuid.v4();

  /// Unique id for this client
  final String id;

  /// Configuration for this client
  final HttpClientConfig clientConfig;

  Future<void> cancel([String? key]) async {
    try {
      await (_cancelTokens.remove(key ?? id)?..cancel())?.whenCancel;
    } catch (e) {
      log(e);
    }
  }

  final Map<String, CancelToken> _cancelTokens = {};

  String get baseUrl => clientConfig.baseUrl;

  Map<String, String>? get headers => clientConfig.headers;

  Duration get timeout => clientConfig.connectTimeout;

  Duration get sendTimeout => clientConfig.sendTimeout;

  Duration get receiveTimeout => clientConfig.receiveTimeout;

  bool get enableLogs => clientConfig.enableLogs;

  Future<T> get<T>({
    String? baseUrl,
    required String path,
    JsonObject query = const {},
    Map<String, String>? headers,
    HttpProgressCallback? onReceiveProgress,
    HttpResponseType? responseType,
    Duration? timeout,
    Duration? receiveTimeout,
    bool? enableLogs,
  }) =>
      request<T>(
        baseUrl: baseUrl,
        path: path,
        method: HttpMethod.get,
        query: query,
        headers: headers,
        onReceiveProgress: onReceiveProgress,
        responseType: responseType,
        timeout: timeout,
        receiveTimeout: receiveTimeout,
        enableLogs: enableLogs,
      );

  Future<T> post<T>({
    String? baseUrl,
    required String path,
    JsonObject query = const {},
    dynamic body,
    HttpFormData? formData,
    Map<String, String>? headers,
    HttpProgressCallback? onSendProgress,
    HttpProgressCallback? onReceiveProgress,
    HttpResponseType? responseType,
    Duration? timeout,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    bool? enableLogs,
  }) =>
      request<T>(
        baseUrl: baseUrl,
        path: path,
        method: HttpMethod.post,
        query: query,
        body: body,
        formData: formData,
        headers: headers,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        responseType: responseType,
        timeout: timeout,
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
        enableLogs: enableLogs,
      );

  Future<T> put<T>({
    String? baseUrl,
    required String path,
    JsonObject query = const {},
    dynamic body,
    HttpFormData? formData,
    Map<String, String>? headers,
    HttpProgressCallback? onSendProgress,
    HttpProgressCallback? onReceiveProgress,
    HttpResponseType? responseType,
    Duration? timeout,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    bool? enableLogs,
  }) =>
      request<T>(
        baseUrl: baseUrl,
        path: path,
        method: HttpMethod.put,
        query: query,
        body: body,
        formData: formData,
        headers: headers,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        responseType: responseType,
        timeout: timeout,
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
        enableLogs: enableLogs,
      );

  Future<T> patch<T>({
    String? baseUrl,
    required String path,
    JsonObject query = const {},
    dynamic body,
    HttpFormData? formData,
    Map<String, String>? headers,
    HttpProgressCallback? onSendProgress,
    HttpProgressCallback? onReceiveProgress,
    HttpResponseType? responseType,
    Duration? timeout,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    bool? enableLogs,
  }) =>
      request<T>(
        baseUrl: baseUrl,
        path: path,
        method: HttpMethod.patch,
        query: query,
        body: body,
        formData: formData,
        headers: headers,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        responseType: responseType,
        timeout: timeout,
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
        enableLogs: enableLogs,
      );

  Future<T> delete<T>({
    String? baseUrl,
    required String path,
    JsonObject query = const {},
    dynamic body,
    Map<String, String>? headers,
    HttpProgressCallback? onReceiveProgress,
    HttpResponseType? responseType,
    Duration? timeout,
    Duration? receiveTimeout,
    bool? enableLogs,
  }) =>
      request<T>(
        baseUrl: baseUrl,
        path: path,
        method: HttpMethod.delete,
        query: query,
        body: body,
        headers: headers,
        onReceiveProgress: onReceiveProgress,
        responseType: responseType,
        timeout: timeout,
        receiveTimeout: receiveTimeout,
        enableLogs: enableLogs,
      );

  Future<T> request<T>({
    String? baseUrl,
    required String path,
    required HttpMethod method,
    JsonObject query = const {},
    dynamic body,
    HttpFormData? formData,
    Map<String, String>? headers,
    HttpProgressCallback? onSendProgress,
    HttpProgressCallback? onReceiveProgress,
    HttpResponseType? responseType,
    Duration? timeout,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    bool? enableLogs,
  }) async {
    baseUrl ??= this.baseUrl;
    headers ??= this.headers;
    timeout ??= this.timeout;
    sendTimeout ??= this.sendTimeout;
    receiveTimeout ??= this.receiveTimeout;
    enableLogs ??= this.enableLogs;
    Dio? dio;
    try {
      dio = Dio();
      dio.interceptors.add(
        LogInterceptor(
          request: enableLogs,
          requestHeader: enableLogs,
          requestBody: enableLogs,
          responseHeader: enableLogs,
          responseBody: enableLogs,
          error: enableLogs,
          logPrint: (object) => _log(object, path, enableLogs),
        ),
      );

      dio.options
        ..baseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'
        ..validateStatus = (status) => status == 200 || status == 201;
      dio.options.connectTimeout = timeout;
      dio.options.sendTimeout = sendTimeout;
      dio.options.receiveTimeout = receiveTimeout;

      final cancelToken = _cancelTokens[id] = CancelToken();
      final queryNonNull = query.replaceNullWithEmpty;

      final isMultipart = formData != null;
      final data = formData ?? body;

      _log(queryNonNull, 'request.query', enableLogs);
      _log(formData?.files, 'request.form-data-files', enableLogs);
      _log(formData?.fields, 'request.form-data', enableLogs);

      final response = await dio.request<T>(
        path.startsWith('/') ? path.substring(1) : path,
        queryParameters: queryNonNull,
        data: data,
        options: Options(
          method: method(),
          responseType: responseType ?? ResponseType.json,
          contentType:
              isMultipart ? Headers.multipartFormDataContentType : null,
          headers: headers,
        ),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      _log(queryNonNull, 'request.query', enableLogs);
      _log(formData?.files, 'request.form-data-files', enableLogs);
      _log(formData?.fields, 'request.form-data', enableLogs);
      _log(response.data?.runtimeType, 'response.type', enableLogs);
      return decodeData<T>(response.data);
    } on DioException catch (e) {
      _log(e, path, enableLogs);
      switch (e.type) {
        case DioExceptionType.cancel:
          throw const CancelException();

        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw const TimeoutException();

        case DioExceptionType.connectionError:
          throw const NoInternetException();

        case DioExceptionType.badCertificate:
        case DioExceptionType.badResponse:
        case DioExceptionType.unknown:
          throw await _invalidResponse(e);
      }
    } catch (e) {
      log(e, path, enableLogs);
      throw HttpException(e.toString());
    } finally {
      dio?.close();
    }
  }

  String? decodeMessage(dynamic data, int statusCode) {
    if (data is JsonObject && data.isNotEmpty) {
      final message = data['message'] ?? data['response'];
      if (message is String && message.isNotBlank) {
        return message;
      }
      if (message is JsonArray && message.isNotEmpty) {
        return $mapToList(message, (e) => e.toString())?.join('\n');
      }
      final error = data['error'];
      if (error is String && error.isNotBlank) {
        return error;
      }
    }
    return null;
  }

  /// Decode valid/invalid responses based on their types
  T decodeData<T>(dynamic data) {
    final result = data is String
        ? data.jsonOrString
        : data is Map<dynamic, dynamic>
            ? data.map((key, value) => MapEntry(key.toString(), value))
            : data;
    if (T == JsonObject) {
      return result as T? ?? (throw const NoDataException());
    } else if (T == JsonArray) {
      return result as T? ?? (throw const NoDataException());
    } else if (T == String) {
      return result?.toString() as T? ?? (throw const NoDataException());
    }
    return result as T;
  }

  /// HTTP error codes - invalid responses
  Future<HttpException> _invalidResponse(DioException e) async {
    final response = e.response;
    final error = e.error;
    final statusCode = response?.statusCode ?? 0;
    final data = response != null ? decodeData<dynamic>(response.data) : null;
    final messageOrError = decodeMessage(data, statusCode) ?? e.message;
    switch (statusCode) {
      case 400:
        return BadRequestException(messageOrError);
      case 401:
      case 403:
      case 405:
        return UnauthorisedException(messageOrError);
      case 500:
        return InternalServerException(messageOrError);
      default:
        if (error is SocketException) {
          return const NoInternetException();
        }
        return NoDataException(
          statusCode != 0 && messageOrError == null ? '$statusCode: ' : '',
          messageOrError,
        );
    }
  }

  void log(dynamic object, [dynamic name, bool? enable]) =>
      _log(object, (name ?? runtimeType).toString(), enable ?? enableLogs);

  void _log(dynamic object, String name, [bool? enable]) {
    if (enable ?? clientConfig.enableLogs) {
      developer.log(
        '$object',
        name:
            'http_api.${name.startsWith('/') ? name.replaceFirst(RegExp('/*'), '') : name}',
      );
    }
  }
}

extension MapDynamic<K> on Map<K, dynamic> {
  Map<K, dynamic> get replaceNullWithEmpty => isEmpty
      ? this
      : Map.fromEntries(entries.map((e) => MapEntry(e.key, e.value ?? '')));
}

extension ListDynamic on List<dynamic> {
  List<dynamic> get replaceNullWithEmpty =>
      isEmpty ? this : map((e) => e ?? '').toList();
}

extension JsonString on String {
  dynamic get jsonOrString {
    try {
      return jsonDecode(this);
    } catch (e) {
      return this;
    }
  }
}
