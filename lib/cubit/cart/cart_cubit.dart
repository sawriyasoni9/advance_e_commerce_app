import 'package:advance_e_commerce_app/cubit/cart/cart_state.dart';
import 'package:advance_e_commerce_app/entities/product/mdl_product.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class CartCubit extends Cubit<CartState> with HydratedMixin {
  CartCubit() : super(CartSuccessState(cartItems: [])) {
    hydrate();
  }

  /// 🔹 Add product to cart
  void addToCart(MDLProduct product) {
    final updatedCart = List<MDLProduct>.from(state.cartItems);
    final existing = updatedCart.indexWhere((e) => e.id == product.id);

    if (existing == -1) {
      updatedCart.add(product);
    } else {
      // Optional: handle duplicates (e.g., increase quantity)
      // For now, do nothing if item already exists
    }

    emit(CartSuccessState(cartItems: updatedCart));
  }

  /// 🔹 Remove product from cart
  void removeFromCart(MDLProduct product) {
    final updatedCart = List<MDLProduct>.from(state.cartItems)
      ..removeWhere((e) => e.id == product.id);

    emit(CartSuccessState(cartItems: updatedCart));
  }

  /// 🔹 Check if product already exists in cart
  bool isInCart(MDLProduct product) {
    return state.cartItems.any((e) => e.id == product.id);
  }

  /// 🔹 Calculate total price
  double get totalPrice {
    return state.cartItems.fold(
      0.0,
      (sum, item) => sum + (double.tryParse(item.price ?? '0') ?? 0),
    );
  }

  /// 🔹 Restore from Hydrated storage
  @override
  CartState? fromJson(Map<String, dynamic> json) {
    try {
      final List<dynamic> data = json['cartItems'] ?? [];
      final products = data.map((e) => MDLProduct.fromJson(e)).toList();
      return CartSuccessState(cartItems: products);
    } catch (e) {
      return CartSuccessState(cartItems: []);
    }
  }

  /// 🔹 Save to Hydrated storage
  @override
  Map<String, dynamic>? toJson(CartState state) {
    if (state is CartSuccessState) {
      return {'cartItems': state.cartItems.map((e) => e.toJson).toList()};
    }
    return null;
  }

  /// Increase quantity of a product
  void increaseQuantity(MDLProduct product) {
    final updatedCart = List<MDLProduct>.from(state.cartItems);
    final index = updatedCart.indexWhere((e) => e.id == product.id);
    if (index != -1) {
      updatedCart[index].quantity = (updatedCart[index].quantity ?? 1) + 1;
      emit(CartSuccessState(cartItems: updatedCart));
    }
  }

  /// Decrease quantity (min 1)
  void decreaseQuantity(MDLProduct product) {
    final updatedCart = List<MDLProduct>.from(state.cartItems);
    final index = updatedCart.indexWhere((e) => e.id == product.id);
    if (index != -1) {
      final newQty = (updatedCart[index].quantity ?? 1) - 1;
      if (newQty > 0) {
        updatedCart[index].quantity = newQty;
      } else {
        updatedCart.removeAt(index);
      }
      emit(CartSuccessState(cartItems: updatedCart));
    }
  }
}
