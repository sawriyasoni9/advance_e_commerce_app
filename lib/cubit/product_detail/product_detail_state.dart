import 'package:advance_e_commerce_app/entities/product/mdl_product.dart';

sealed class ProductDetailState {}

final class ProductDetailInitial extends ProductDetailState {}

final class ProductDetailLoadingState extends ProductDetailState {}

final class ProductDetailsSuccessState extends ProductDetailState {
  MDLProduct productDetails;

  ProductDetailsSuccessState({required this.productDetails});
}

final class ProductDetailErrorState extends ProductDetailState {
  final String errorMessage;

  ProductDetailErrorState({required this.errorMessage});
}
