import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl ='https://eemi-39b84a24258a.herokuapp.com';

  static Future request({
    required String uri,
    required String method,
    Map<String, dynamic>? data,
    Map<String, String>? queryParams,
    Function? parser,
  }) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Uri url = Uri.parse('$baseUrl/$uri');

    String? body;

    if (data != null) {
      body = jsonEncode(data);
    }

    if (queryParams != null) {
      url = url.replace(queryParameters: queryParams);
    }

    http.Response? response;

    try {
      switch (method) {
        case 'POST':
          response = await http.post(url, headers: headers, body: body);
          break;
        case 'PUT':
          response = await http.put(url, headers: headers, body: body);
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers, body: body);
          break;
        default:
          response = await http.get(url, headers: headers);
          break;
      }
    } on http.ClientException catch (e) {
      debugPrint(e.message);
      throw ApiException(
        httpCode: 500,
        type: 'ApiError',
        message: 'Something went wrong',
      );
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        if (['application/pdf'].contains(response.headers['content-type'])) {
          return response.bodyBytes;
        }

        if (response.body.isNotEmpty) {
          final decoded = jsonDecode(response.body);

          if (decoded == null) {
            return null;
          }

          if (parser != null) {
            return parser(decoded);
          }

          return decoded;
        }

        return response.body;

      case 204:
        return true;
      case 400:
      case 401:
      case 403:
      case 404:
        throw ApiException(
          httpCode: response.statusCode,
          type: 'ApiError',
          message: response.body,
        );
      case 422:
        throw ApiException(
          httpCode: response.statusCode,
          type: 'ValidationErrors',
          message: response.body,
        );
      default:
        throw ApiException(
          httpCode: response.statusCode,
          message: 'We are unable to communicate with our server',
          type: 'ApiError',
        );
    }
  }
}

class ApiException implements Exception {
  final int httpCode;
  final String type;
  final String message;

  ApiException({
    required this.httpCode,
    required this.type,
    required this.message,
  });

  factory ApiException.fromResponse(Map<String, dynamic> json) {
    return ApiException(
      httpCode: json['httpCode'],
      type: json['type'],
      message: json['message'],
    );
  }
}