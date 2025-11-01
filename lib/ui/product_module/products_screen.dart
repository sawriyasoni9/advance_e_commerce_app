import 'package:advance_e_commerce_app/cubit/cart/cart_cubit.dart';
import 'package:advance_e_commerce_app/cubit/cart/cart_state.dart';
import 'package:advance_e_commerce_app/cubit/product_cubit.dart';
import 'package:advance_e_commerce_app/cubit/product_detail/product_detail_cubit.dart';
import 'package:advance_e_commerce_app/cubit/product_state.dart';
import 'package:advance_e_commerce_app/extensions/app_loader.dart';
import 'package:advance_e_commerce_app/extensions/navigation_with_animation.dart';
import 'package:advance_e_commerce_app/repository/provider/lrf/product_repository.dart';
import 'package:advance_e_commerce_app/ui/cart_module/cart_screen.dart';
import 'package:advance_e_commerce_app/ui/common/internet_connection_banner.dart';
import 'package:advance_e_commerce_app/ui/product_module/product_details_screen.dart';
import 'package:advance_e_commerce_app/ui/product_module/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductsScreen extends StatefulWidget {
  final ProductCubit productCubit;

  const ProductsScreen({super.key, required this.productCubit});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late CartCubit cartCubit;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    cartCubit = CartCubit();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      widget.productCubit.fetchProducts();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    cartCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cartCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Products',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                onPressed: () async {
                  navigateWithAnimation(
                    context: context,
                    page: BlocProvider.value(
                      value: cartCubit, // Reuse the existing cubit
                      child: const CartScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.shopping_cart),
              ),
            ),
          ],
          elevation: 0,
        ),
        body: Column(
          children: [
            BlocBuilder<ProductCubit, ProductState>(
              bloc: widget.productCubit,
              buildWhen:
                  (previous, current) =>
                      current is ProductInternetStatusChanged,
              builder: (context, state) {
                if (state is ProductInternetStatusChanged) {
                  return InternetStatusBanner(status: state.internetStatus);
                }
                return SizedBox.shrink();
              },
            ),

            // ✅ Product Grid
            Expanded(child: _mainBody()),
          ],
        ),
      ),
    );
  }

  Widget _mainBody() {
    return BlocConsumer<ProductCubit, ProductState>(
      bloc: widget.productCubit,
      listener: (context, state) {
        if (state is ProductLoadingState) {
          AppLoader.showLoader(context);
        } else if (state is ProductLoadingMoreState) {
          // Don't show full loader for load more
        } else {
          AppLoader.hideLoader();
          if (state is ProductErrorState) {
            Fluttertoast.showToast(msg: state.errorMessage);
          }
          
          // Complete refresh controller
          if (_refreshController.isRefresh) {
            _refreshController.refreshCompleted();
          }
          if (_refreshController.isLoading) {
            _refreshController.loadComplete();
          }
        }
      },
      buildWhen:
          (previous, current) =>
              current is ProductLoadingState ||
              current is ProductSuccessState ||
              current is ProductErrorState ||
              current is ProductLoadingMoreState,
      builder: (context, state) {
        if (state is ProductLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductErrorState) {
          return const Center(
            child: Text(
              'Something went wrong.\nPlease try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        if (widget.productCubit.products.isEmpty) {
          return const Center(
            child: Text(
              'No products found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        }

        return BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: widget.productCubit.hasMore,
              onRefresh: () async {
                // Pull to refresh - fetch page 1
                await widget.productCubit.fetchProducts(isRefresh: true);
              },
              onLoading: () async {
                // Load more - fetch next page
                await widget.productCubit.loadMoreProducts();
              },
              header: const ClassicHeader(
                refreshingText: 'Refreshing...',
                completeText: 'Refresh completed',
                releaseText: 'Release to refresh',
                idleText: 'Pull down to refresh',
              ),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  if (!widget.productCubit.hasMore) {
                    return const SizedBox(
                      height: 55.0,
                      child: Center(child: Text("No more products")),
                    );
                  }
                  
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = const Text("Pull up to load more");
                  } else if (mode == LoadStatus.loading) {
                    body = const CircularProgressIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = const Text("Load Failed! Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = const Text("Release to load more");
                  } else {
                    body = const Text("No more products");
                  }
                  return SizedBox(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: widget.productCubit.products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final product = widget.productCubit.products[index];
                  final isInCart = cartCubit.isInCart(product);

                  return ProductCard(
                    product: product,
                    onAddToCart: () {
                      if (isInCart) {
                        cartCubit.removeFromCart(product);
                        Fluttertoast.showToast(msg: "Removed from cart");
                      } else {
                        cartCubit.addToCart(product);
                        Fluttertoast.showToast(msg: "Added to cart");
                      }
                      setState(() {});
                    },
                    onTap: () {
                      navigateWithAnimation(
                        context: context,
                        page: ProductDetailsScreen(
                          productDetailCubit: ProductDetailCubit(
                            repository: ProductRepository(),
                            productId: product.id.toString(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
