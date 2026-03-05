import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/bindings/cart_binding.dart';
import 'app/core/constants/hive_boxes.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/models/order_model.dart';
import 'app/data/models/saved_card_model.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(OrderModelAdapter());
  Hive.registerAdapter(SavedCardModelAdapter());
  await Hive.openBox<OrderModel>(HiveBoxes.orders);
  await Hive.openBox<SavedCardModel>(HiveBoxes.savedCards);
  runApp(const GameStoreApp());
}

class GameStoreApp extends StatelessWidget {
  const GameStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GameStore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialBinding: CartBinding(),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}
