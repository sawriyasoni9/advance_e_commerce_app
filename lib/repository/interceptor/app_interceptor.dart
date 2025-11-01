import 'dart:developer';

import 'package:advance_e_commerce_app/constant/app_logs.dart';
import 'package:dio/dio.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    // /// Set the Bearer token if user is loggedIn.
    // var languageType = LocalizationService.instance.languageType;
    // options.headers.addAll({'language': languageType.name});
    // options.headers.addAll(
    //     {'authorization': 'Bearer ${UserService.instance.authorizationToken}'});
    // options.headers.addAll({'deviceType': "app"});
    //

    AppLogs.debugPrint("##REQ: URL: ${options.baseUrl} END POINT: ${options.path}   DATA: ${options.data.toString()} QUERY DATA: ${options.queryParameters.toString()} Headers: ${options.headers.toString()}");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    log(response.toString());
  }
}
