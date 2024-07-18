import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';

import '../AuthBloc/auth_cubit.dart';
import '../flavors/config/flavor_config.dart';

class ApiCaller {
  final String _baseUrl = FlavorConfig.instance.baseUrl ?? "";
  final dio.Dio _dio = dio.Dio();

  Future<dynamic> get(
    String url, {
    Map<String, String>? query,
  }) async {
    var responseJson;
    try {
      final response = await _dio.get('$_baseUrl$url', queryParameters: query);
      responseJson = _returnResponse(response);
    } on SocketException {
      debugPrint('No Internet connection');
    } catch (e) {
      debugPrint(e.toString());
    }

    return responseJson;
  }

  static dynamic _returnResponse(dio.Response response) {
    var responseJson;
    try {
      responseJson = response.data;
    } catch (e) {
      debugPrint("Error parsing response: $e");
      return null;
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseJson;
      case 412:
        return responseJson;
      case 400:
      case 401:
        AuthCubit.logout();
        break;
      case 403:
        break;
      case 422:
        return responseJson;
      case 404:
        return responseJson;
      case 500:
      default:
        debugPrint(
            "Error occured while Communication with Server with StatusCode : ${response.statusCode}");
    }
  }
}
