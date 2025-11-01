import 'package:advance_e_commerce_app/entities/product/mdl_product.dart';

sealed class CartState {
  List<MDLProduct> get cartItems => [];
}

final class CartInitialState extends CartState {
  @override
  List<MDLProduct> get cartItems => [];
}

final class CartLoadingState extends CartState {
  @override
  List<MDLProduct> get cartItems => [];
}

final class CartSuccessState extends CartState {
  @override
  final List<MDLProduct> cartItems;

  CartSuccessState({required this.cartItems});
}

final class CartErrorState extends CartState {
  final String errorMessage;
  @override
  final List<MDLProduct> cartItems;

  CartErrorState({
    required this.errorMessage,
    this.cartItems = const [],
  });
}
