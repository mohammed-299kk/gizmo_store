import 'package:gizmo_store/screens/categories_screen.dart';
import 'package:gizmo_store/screens/shipping_screen.dart';
import 'package:gizmo_store/screens/address_screen.dart';
import 'package:gizmo_store/screens/shipping_screen.dart';
import 'package:gizmo_store/screens/address_screen.dart';
import 'package:flutter/material.dart';
import 'package:gizmo_store/screens/home/home_screen.dart';
import 'package:gizmo_store/screens/profile/profile_screen.dart';
import 'package:gizmo_store/screens/cart/cart_screen.dart';
import 'package:gizmo_store/screens/order/orders_screen.dart';
import 'package:gizmo_store/screens/search/search_screen.dart';
import 'package:gizmo_store/screens/auth/auth_screen.dart';
import 'package:gizmo_store/screens/product/products_screen.dart';
import 'package:gizmo_store/screens/product/product_detail_screen.dart';
import 'package:gizmo_store/models/product.dart';
import 'package:gizmo_store/screens/splash_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case '/orders':
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case '/auth':
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case '/products':
        return MaterialPageRoute(builder: (_) => const ProductsScreen());
      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case '/shipping':
        return MaterialPageRoute(builder: (_) => const ShippingScreen());
      case '/addresses':
        return MaterialPageRoute(builder: (_) => const AddressScreen());
      case '/product_detail':
        final product = settings.arguments as Product;
        return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
                  product: product,
                ));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
