import 'package:advance_e_commerce_app/cubit/cart/cart_cubit.dart';
import 'package:advance_e_commerce_app/cubit/cart/cart_state.dart';
import 'package:advance_e_commerce_app/cubit/product_detail/product_detail_cubit.dart';
import 'package:advance_e_commerce_app/cubit/product_detail/product_detail_state.dart';
import 'package:advance_e_commerce_app/entities/product/mdl_product.dart';
import 'package:advance_e_commerce_app/extensions/app_loader.dart';
import 'package:advance_e_commerce_app/extensions/navigation_with_animation.dart'
    show navigateWithAnimation;
import 'package:advance_e_commerce_app/extensions/string_extension.dart';
import 'package:advance_e_commerce_app/ui/cart_module/cart_screen.dart';
import 'package:advance_e_commerce_app/ui/common/custom_network_image.dart';
import 'package:advance_e_commerce_app/ui/common/full_page_error.dart';
import 'package:advance_e_commerce_app/ui/common/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductDetailCubit productDetailCubit;

  const ProductDetailsScreen({super.key, required this.productDetailCubit});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _productCubit.fetchProductDetails(_productCubit.productId.toInt);
    });
  }

  ProductDetailCubit get _productCubit {
    return widget.productDetailCubit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: _mainBody(),
    );
  }

  Widget _mainBody() {
    return BlocConsumer(
      bloc: _productCubit,
      listener: (context, state) {
        if (state is ProductDetailLoadingState) {
          AppLoader.showLoader(context);
        } else {
          AppLoader.hideLoader();
        }
      },
      builder: (context, state) {
        if (state is ProductDetailErrorState) {
          return FullPageError(
            errorMessage: state.errorMessage,
            onRetryTap: () {
              _productCubit.fetchProductDetails(_productCubit.productId.toInt);
            },
          );
        }
        if (state is ProductDetailsSuccessState) {
          var productInfo = state.productDetails;
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CustomNetworkImage(
                    url: productInfo.image ?? '',
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              productDetails(productInfo),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget productDetails(MDLProduct productInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productInfo.title ?? '',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          productInfo.category?.toUpperCase() ?? '',
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),

        // Price
        Text(
          'Price: \$${productInfo.price ?? ''}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 16),

        // Rating
        if (productInfo.rating != null)
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber[600]),
              const SizedBox(width: 4),
              Text(
                '${productInfo.rating!.rate ?? ''} / 5',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                '(${productInfo.rating!.count ?? 0} reviews)',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        const SizedBox(height: 20),

        // Description
        const Text(
          'Description',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          productInfo.description ?? '',
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
        SizedBox(height: 20),
        // Add to Cart Button
        BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            final cartCubit = context.read<CartCubit>();
            final isInCart = cartCubit.isInCart(productInfo);

            return PrimaryButton(
              backgroundColor: isInCart ? Colors.red : Colors.teal,
              title: isInCart ? 'Remove from cart' : 'Add to cart',
              onTap: () {
                if (isInCart) {
                  cartCubit.removeFromCart(productInfo);
                  Fluttertoast.showToast(msg: "Removed from cart");
                } else {
                  cartCubit.addToCart(productInfo);
                  Fluttertoast.showToast(msg: "Added to cart");
                  navigateWithAnimation(
                    context: context,
                    page: BlocProvider.value(
                      value: cartCubit, // Reuse the existing cubit
                      child: const CartScreen(),
                    ),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}
