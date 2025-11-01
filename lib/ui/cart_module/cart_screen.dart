import 'package:advance_e_commerce_app/cubit/cart/cart_cubit.dart';
import 'package:advance_e_commerce_app/cubit/cart/cart_state.dart';
import 'package:advance_e_commerce_app/cubit/product_detail/product_detail_cubit.dart';
import 'package:advance_e_commerce_app/extensions/navigation_with_animation.dart';
import 'package:advance_e_commerce_app/repository/provider/lrf/product_repository.dart';
import 'package:advance_e_commerce_app/ui/cart_module/cart_product_tile.dart';
import 'package:advance_e_commerce_app/ui/common/primary_button.dart';
import 'package:advance_e_commerce_app/ui/product_module/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cartCubit = context.read<CartCubit>();
        final items = state.cartItems;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "My Cart",
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body:
              items.isEmpty
                  ? const Center(
                    child: Text(
                      "Your cart is empty",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                  : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (_, index) {
                            final item = items[index];
                            return InkWell(
                              onTap: () {
                                navigateWithAnimation(
                                  context: context,
                                  page: ProductDetailsScreen(
                                    productDetailCubit: ProductDetailCubit(
                                      repository: ProductRepository(),
                                      productId: item.id.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: CartItemTile(
                                item: item,
                                onIncrease:
                                    () => cartCubit.increaseQuantity(item),
                                onDecrease:
                                    () => context
                                        .read<CartCubit>()
                                        .decreaseQuantity(item),
                                onRemove:
                                    () => context
                                        .read<CartCubit>()
                                        .removeFromCart(item),
                              ),
                            );
                          },
                        ),
                      ),
                      _placeOrderWidget(
                        totalPrice: cartCubit.totalPrice,
                        totalItems: items.length,
                      ),
                    ],
                  ),
        );
      },
    );
  }
}

Widget _placeOrderWidget({
  required double totalPrice,
  required int totalItems,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              totalPrice.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Items',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              totalItems.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        Divider(),
        PrimaryButton(
          backgroundColor: Colors.black,
          title: 'Place Order',
          onTap: () {},
        ),
      ],
    ),
  );
}
