import 'package:advance_e_commerce_app/entities/product/mdl_product.dart';
import 'package:advance_e_commerce_app/repository/contract_builder/app_repository_contract.dart';
import 'package:advance_e_commerce_app/repository/data_source_manager/response_wrapper.dart';
import 'package:advance_e_commerce_app/repository/data_source_manager/server_error.dart';
import 'package:advance_e_commerce_app/repository/interceptor/app_interceptor.dart';
import 'package:advance_e_commerce_app/repository/retrofit/api_client.dart';
import 'package:dio/dio.dart';

class ProductRepository extends AppRepositoryContract {
  late Dio dio;
  late ApiClient _apiClient;

  ProductRepository() {
    dio = Dio();
    dio.interceptors.add(AppInterceptor());
    _apiClient = ApiClient(dio);
  }

  Future<ResponseWrapper<List<MDLProduct>?>> product({
    int? limit,
    int? offset,
  }) async {
    var responseWrapper = ResponseWrapper<List<MDLProduct>>();
    try {
      var response = await _apiClient.product(
        limit: limit,
        offset: offset,
      );

      if (response.response.statusCode == 200) {
        List<MDLProduct>? products = [];

        if (response.data != null) {
          var data = response.data ?? [];
          for (var item in data) {
            products.add(MDLProduct.fromJson(item));
          }
        }

        return responseWrapper..setData(products);
      } else {
        responseWrapper.setException(
          ServerError.withErrorMessage(
            message: response.response.statusMessage ?? '',
          ),
        );
      }
    } on DioException catch (e) {
      responseWrapper.setException(ServerError.withError(error: e));
    } on Exception {
      responseWrapper.setException(ServerError.withError(error: null));
    }
    return responseWrapper;
  }

  Future<ResponseWrapper<MDLProduct?>> productDetails({
    required int productId,
  }) async {
    var responseWrapper = ResponseWrapper<MDLProduct>();
    try {
      var response = await _apiClient.productDetails(productId);

      if (response.response.statusCode == 200) {
        MDLProduct? productDetails;

        if (response.data != null) {
          var data = response.data ?? [];
          productDetails = MDLProduct.fromJson(data);
        }

        return responseWrapper..setData(productDetails!);
      } else {
        responseWrapper.setException(
          ServerError.withErrorMessage(
            message: response.response.statusMessage ?? '',
          ),
        );
      }
    } on DioException catch (e) {
      responseWrapper.setException(ServerError.withError(error: e));
    } on Exception {
      responseWrapper.setException(ServerError.withError(error: null));
    }
    return responseWrapper;
  }
}
