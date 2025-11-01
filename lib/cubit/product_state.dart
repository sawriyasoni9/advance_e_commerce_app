import 'package:advance_e_commerce_app/entities/product/mdl_product.dart';

sealed class ProductState {}

final class ProductInitialState extends ProductState {}

final class ProductLoadingState extends ProductState {}

final class ProductSuccessState extends ProductState {}
final class ProductDetailsSuccessState extends ProductState {
  MDLProduct productDetails;
  ProductDetailsSuccessState({required this.productDetails});
}

final class ProductErrorState extends ProductState {
  final String errorMessage;
  ProductErrorState({required this.errorMessage});
}
final class ProductInternetStatusChanged extends ProductState {
  final String internetStatus;
  ProductInternetStatusChanged({required this.internetStatus});
}
