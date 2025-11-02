import 'package:advance_e_commerce_app/cubit/product_cubit.dart';
import 'package:advance_e_commerce_app/cubit/theme/theme_cubit.dart';
import 'package:advance_e_commerce_app/repository/provider/lrf/product_repository.dart';
import 'package:advance_e_commerce_app/repository/provider/theme_repository.dart';
import 'package:advance_e_commerce_app/ui/product_module/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'cubit/theme/theme_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ProductCubit productCubit;
  late final ThemeCubit themeCubit;

  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    productCubit = ProductCubit(repository: ProductRepository());
    themeCubit = ThemeCubit(repository: ThemeRepository());
  }

  @override
  void dispose() {
    productCubit.close();
    themeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider.value(value: productCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        bloc: themeCubit,
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ShopSync',
            theme: themeState.lightTheme,
            darkTheme: themeState.darkTheme,
            themeMode: themeState.themeMode,
            home: ProductsScreen(productCubit: productCubit),
          );
        },
      ),
    );
  }
}
