import 'package:advance_e_commerce_app/constant/app_logs.dart';
import 'package:advance_e_commerce_app/repository/contract_builder/environment_service.dart';
import 'package:advance_e_commerce_app/repository/retrofit/apis.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://fakestoreapi.com') //Production
abstract class ApiClient {
  factory ApiClient(Dio dio, {String url = ''}) {
    String baseUrl = '';
    if (url != '') {
      baseUrl = url;
    } else {
      baseUrl = EnvironmentService.baseUrl;
    }

    AppLogs.debugPrint("##BASEURL: $baseUrl");

    return _ApiClient(dio, baseUrl: baseUrl);
  }

  @GET(Apis.product)
  Future<HttpResponse> product({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  @GET(Apis.viewProduct)
  Future<HttpResponse> productDetails(@Path("id") productId);
}
