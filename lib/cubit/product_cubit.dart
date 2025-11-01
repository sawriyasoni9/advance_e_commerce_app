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
  String internetStatus = '';

  ProductCubit({required this.repository}) : super(ProductInitialState()) {
    hydrate();
    _monitorInternetStatus();
    _checkInitialConnection();
  }

  /// 🔹 Fetch All Products
  Future<void> fetchProducts() async {
    var hasInternetConnected = await InternetService.hasInternetConnected();

    if (hasInternetConnected) {
      emit(ProductLoadingState());
      try {
        var response = await repository.product();

        if (response.getException == null) {
          if (response.getData != null) {
            products = response.getData ?? [];
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
