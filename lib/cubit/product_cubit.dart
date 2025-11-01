import 'dart:io';

import 'package:advance_e_commerce_app/cubit/product_state.dart';
import 'package:advance_e_commerce_app/entities/product/mdl_product.dart';
import 'package:advance_e_commerce_app/repository/provider/lrf/product_repository.dart';
import 'package:advance_e_commerce_app/services/internet_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ProductCubit extends Cubit<ProductState> with HydratedMixin {
  final ProductRepository repository;
  List<MDLProduct> products = [];
  List<MDLProduct> allProducts = []; // Store all fetched products
  String internetStatus = '';
  int currentPage = 1;
  final int limit = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  ProductCubit({required this.repository}) : super(ProductInitialState()) {
    hydrate();
    _monitorInternetStatus();
    _checkInitialConnection();
  }

  /// 🔹 Fetch Products with Pagination (First Page or Refresh)
  Future<void> fetchProducts({bool isRefresh = false}) async {
    var hasInternetConnected = await InternetService.hasInternetConnected();

    if (hasInternetConnected) {
      if (!isRefresh) {
        emit(ProductLoadingState());
      }
      
      try {
        // Fetch all products (FakeStore API doesn't support pagination natively)
        // In a real API, you would use: limit and offset parameters
        var response = await repository.product();

        if (response.getException == null) {
          if (response.getData != null) {
            allProducts = response.getData ?? [];
            
            // Reset pagination on refresh
            if (isRefresh) {
              currentPage = 1;
              products.clear();
            }
            
            // Get products for first page
            _updateProductsForCurrentPage();
            emit(ProductSuccessState());
          } else {
            emit(ProductErrorState(errorMessage: "No product data found."));
          }
        } else {
          emit(ProductErrorState(errorMessage: "No product data found."));
        }
      } catch (e) {
        emit(ProductErrorState(errorMessage: e.toString()));
      }
    }
  }

  /// 🔹 Load More Products (Next Page)
  Future<void> loadMoreProducts() async {
    if (isLoadingMore || !hasMore) return;

    var hasInternetConnected = await InternetService.hasInternetConnected();
    if (!hasInternetConnected) return;

    isLoadingMore = true;
    emit(ProductLoadingMoreState());

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if we have more products to load
      final startIndex = currentPage * limit;
      if (startIndex >= allProducts.length) {
        hasMore = false;
        isLoadingMore = false;
        emit(ProductSuccessState());
        return;
      }

      // Move to next page
      currentPage++;
      _updateProductsForCurrentPage();
      
      // Check if there are more products
      hasMore = (currentPage * limit) < allProducts.length;
      isLoadingMore = false;
      emit(ProductSuccessState());
    } catch (e) {
      isLoadingMore = false;
      emit(ProductErrorState(errorMessage: e.toString()));
    }
  }

  /// 🔹 Update products list based on current page
  void _updateProductsForCurrentPage() {
    final startIndex = 0;
    final endIndex = currentPage * limit;
    products = allProducts.sublist(
      0,
      endIndex > allProducts.length ? allProducts.length : endIndex,
    );
    
    // Update hasMore flag
    hasMore = endIndex < allProducts.length;
  }

  /// 🔹 Monitor internet changes continuously

  void _monitorInternetStatus() {
     Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      // Combine all current network statuses
      final hasConnection = results.any((r) => r != ConnectivityResult.none);

      bool actualInternet = hasConnection;

      if (hasConnection) {
        try {
          // Optional: verify real internet connectivity
          final lookup = await InternetAddress.lookup('google.com');
          actualInternet = lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
        } on SocketException {
          actualInternet = false;
        }
      }

      internetStatus = actualInternet ? 'Connected' : 'Offline';
      emit(ProductInternetStatusChanged(internetStatus: internetStatus));
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    final hasConnection = results.any((r) => r != ConnectivityResult.none);
    internetStatus = hasConnection ? 'Connected' : 'Offline';
    emit(ProductInternetStatusChanged(internetStatus: internetStatus));
  }


  /// 🔹 Restore Cached Products (HydratedBloc auto-calls this)
  @override
  ProductState? fromJson(Map<String, dynamic> json) {
    try {
      final List<dynamic> data = json['products'] ?? [];
      products = data.map((e) => MDLProduct.fromJson(e)).toList();
      return ProductSuccessState();
    } catch (_) {
      return null;
    }
  }

  /// 🔹 Save Cached Products (HydratedBloc auto-calls this)
  @override
  Map<String, dynamic>? toJson(ProductState state) {
    if (state is ProductSuccessState && products.isNotEmpty) {
      return {'products': products.map((e) => e.toJson).toList()};
    }
    return null;
  }
}
