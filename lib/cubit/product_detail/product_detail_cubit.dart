import 'package:advance_e_commerce_app/cubit/product_detail/product_detail_state.dart';
import 'package:advance_e_commerce_app/entities/product/mdl_product.dart';
import 'package:advance_e_commerce_app/extensions/string_extension.dart';
import 'package:advance_e_commerce_app/repository/provider/lrf/product_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> with HydratedMixin {
  final ProductRepository repository;
  final String productId;

  ProductDetailCubit({required this.repository, required this.productId})
    : super(ProductDetailInitial()) {
    hydrate();
  }

  /// 🔹 Fetch Single Product Details
  Future<void> fetchProductDetails(int? productId) async {
    emit(ProductDetailLoadingState());
    try {
      var response = await repository.productDetails(productId: productId ?? 0);

      if (response.getException == null) {
        var productDetails = response.getData;
        if (productDetails != null) {
          emit(ProductDetailsSuccessState(productDetails: productDetails));
        } else {
          emit(
            ProductDetailErrorState(errorMessage: "No product details found."),
          );
        }
      } else {
        var errorMessage = await response.getException?.errorMessage ?? '';
        emit(ProductDetailErrorState(errorMessage: errorMessage));
      }
    } catch (e) {
      emit(ProductDetailErrorState(errorMessage: e.toString()));
    }
  }

  @override
  ProductDetailState? fromJson(Map<String, dynamic> json) {
    if (json.containsKey('products')) {
      final List<dynamic> data = json['products'] ?? [];
      var products = data.map((e) => MDLProduct.fromJson(e)).toList();

      try {
        var productInfo = products.firstWhere(
          (product) => product.id == productId.toInt,
        );

        return ProductDetailsSuccessState(productDetails: productInfo);
      } catch (e) {
        return ProductDetailErrorState(
          errorMessage: 'Product not found in cache.',
        );
      }
    }

    return null;
  }

  @override
  Map<String, dynamic>? toJson(ProductDetailState state) {
    return null;
  }
}
