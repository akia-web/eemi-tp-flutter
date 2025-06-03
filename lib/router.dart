import 'package:go_router/go_router.dart';

import 'screens/Add_product_screen.dart';
import 'screens/home_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => AddProductScreen(),
    ),
  ],
);
