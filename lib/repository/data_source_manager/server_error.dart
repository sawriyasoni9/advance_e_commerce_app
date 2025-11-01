import 'package:advance_e_commerce_app/services/internet_service.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/material.dart';

// const String kSomethingWentWrong = LocalizationService.appLocale.somethingWentWrong;
const String kNoInternet = 'Please check your internet connection!';

class ServerError implements Exception {
  final int _errorCode = 0;
  String _errorMessage = 'Something Went Wrong';

  ServerError.withError({DioException? error}) {
    _handleError(error);
  }

  ServerError.withErrorMessage({String message = ''}) {
    _errorMessage = message;
  }

  int get errorCode {
    return _errorCode;
  }

  Future<String> get errorMessage async {
    var isConnected = await InternetService.hasInternetConnected();
    if (!isConnected) {
      _errorMessage = kNoInternet;
    }
    return _errorMessage;
  }

  Future<void> _handleError(DioException? error) async {
    debugPrint('#### error : $error');
    if (error == null) {
      _errorMessage = 'Something Went Wrong';
      return;
    }

    debugPrint('### API : ${error.requestOptions.uri}');
    debugPrint('### Method : ${error.requestOptions.method}');
    debugPrint('### Parameters : ${error.requestOptions.data}');
    debugPrint('### queryParameters : ${error.requestOptions.queryParameters}');
    debugPrint('### statusCode : ${error.response?.statusCode} ');
    debugPrint('### headers : ${error.requestOptions.headers} ');
    debugPrint('### statusMessage : ${error.response?.statusMessage} ');
    debugPrint('### response : ${error.response} ');
    debugPrint('### response.data : ${error.response?.data} ');
    debugPrint('### _handleError : ${error.toString()} ');

    switch (error.type) {
      case DioExceptionType.cancel:
        _errorMessage = 'Request was cancelled';
        break;
      case DioExceptionType.connectionTimeout:
        _errorMessage = 'Connection timeout';
        break;
      case DioExceptionType.unknown:
        if (error.response != null) {
          _errorMessage =
              error.response?.statusMessage ?? 'Something Went Wrong';
        }
        //_errorMessage = "Connection failed due to internet connection";
        break;
      case DioExceptionType.receiveTimeout:
        _errorMessage = 'Receive timeout in connection';
        break;
      case DioExceptionType.badCertificate:
        if (error.response != null) {
          var msg = _handleServerError(error.response);
          debugPrint('msg ---- > $msg');
          if (msg.isEmpty) {
            msg = error.toString();
          }
          _errorMessage = msg;
        }
        break;
      case DioExceptionType.sendTimeout:
        _errorMessage = 'Receive timeout in send request';
        break;
      case DioExceptionType.badResponse:
        // TODO: Handle this case.
        throw UnimplementedError();
      case DioExceptionType.connectionError:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    if (_errorMessage.isEmpty) {
      _errorMessage = 'Something Went Wrong';
    }

    // return _errorMessage;
  }

  static String _handleServerError(response) {
    if (response == null) {
      return 'Something Went Wrong';
    }
    if (response.statusCode == 403) {
      // Get.offAllNamed(Routes.LOGIN);
    }
    if (response.statusCode == 401) {
    }

    if (response.statusCode == 400) {
      var map = response.data;

      return map['meta']['message'] ?? 'Something Went Wrong';
    }

    if (response.statusMessage != null && !response.statusMessage.isEmpty) {
      return response.statusMessage;
    }

    if (response != null && response.runtimeType == String) {
      return response.toString();
    }
    if (response.users != null && response.users.runtimeType == String) {
      return response.users;
    }
    if (response.users != null) {
      return response.users.toString();
    }
    return '';
  }
}
