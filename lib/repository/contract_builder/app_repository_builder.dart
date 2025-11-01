import 'package:advance_e_commerce_app/constant/enums.dart';
import 'package:advance_e_commerce_app/repository/provider/lrf/product_repository.dart';
import 'app_repository_contract.dart';

class AppRepositoryBuilder {
  static AppRepositoryContract repository(
      {RepositoryProviderType of = RepositoryProviderType.product}) {
    switch (of) {
      case RepositoryProviderType.product:
        return ProductRepository();
      }
  }
}
