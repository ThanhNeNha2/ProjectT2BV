import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shopbansach/ui/admin/search_admin.dart';
import 'package:shopbansach/ui/payment_cart/payment_cart_screen.dart';
import 'package:shopbansach/ui/admin/user_product_screen.dart';
import 'package:shopbansach/ui/cart/cart_manager.dart';
// import 'package:shopbansach/ui/order/order_detail_screen.dart';
import 'package:shopbansach/ui/order/order_manager.dart';
import 'package:shopbansach/ui/order/orders_screen.dart';
import 'package:shopbansach/ui/personal/personal_screen.dart';
import 'package:shopbansach/ui/personal_admin/personal_admin_screen.dart';
import 'package:shopbansach/ui/products/product_overview_screen.dart';
import 'package:shopbansach/ui/products/products_manager.dart';
import 'package:shopbansach/ui/products/search_product.dart';
import 'ui/admin/edit_product_screen.dart';
import 'ui/auth/auth_manager.dart';
import 'ui/auth/auth_screen.dart';
import 'ui/cart/cart_screen.dart';
import 'ui/chatbot_rasa_ai/chatbot_rasa_ai.dart';
import 'ui/products/product_detail_screen.dart';
import 'ui/splash_screen.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ProductsManager()),
          ChangeNotifierProvider(create: (context) => CartManager()),
          ChangeNotifierProvider(create: (context) => OrdersManager()),
          // ChangeNotifierProvider(create: (context) => OrdersManager()),
          ChangeNotifierProvider(create: (context) => AuthManager()),
        ],
        child: Consumer<AuthManager>(builder: (context, authManager, child) {
          return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: authManager.isAuth
                  ? (context.read<AuthManager>().authToken?.role == "admin"
                      ? const MyHomePage1(title: 'Admin Screen')
                      : const MyHomePage(title: 'User Screen'))
                  : FutureBuilder(
                      future: authManager.tryAutoLogin(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen();
                      },
                    ),
              routes: {
                CartScreen.routeName: (context) => const CartScreen(),
                OrdersScreen.routeName: (context) => const OrdersScreen(),
                UserProductsScreen.routeName: (context) =>
                    const UserProductsScreen(),
                PersonalScreen.routeName: (context) => const PersonalScreen(),
                PaymentCartScreen1.routeName: (context) =>
                    const PaymentCartScreen1(),
                SearchScreen.routeName: (context) => const SearchScreen(),
                ChatbotScreen1.routeName: (context) => const ChatbotScreen1(),
                PersonalAdminScreen.routeName: (context) =>
                    const PersonalAdminScreen(),
                SearchAdminScreen.routeName: (context) =>
                    const SearchAdminScreen(),
              },
              onGenerateRoute: (settings) {
                if (settings.name == ProductDetailScreen.routeName) {
                  final productID = settings.arguments as String;
                  return MaterialPageRoute(builder: (ctx) {
                    return ProductDetailScreen(
                      ctx.read<ProductsManager>().findById(productID)!,
                    );
                  });
                }
                if (settings.name == EditProductScreen.routeName) {
                  final productId = settings.arguments as String?;
                  return MaterialPageRoute(
                    builder: (ctx) {
                      return EditProductScreen(
                        productId != null
                            ? ctx.read<ProductsManager>().findById(productId)
                            : null,
                      );
                    },
                  );
                }
              });
        }));
  }
}

class MyHomePage extends StatefulWidget {
  static const routeName = '/';
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final screens = [
    const ProductsOverviewScreen(),
    const CartScreen(),
    const OrdersScreen(),
    const PersonalScreen(),
  ];
  late int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) =>
              setState(() => (this.index = index)),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Trang chủ"),
            NavigationDestination(
                icon: Icon(Icons.shopping_cart), label: "Giỏ hàng"),
            NavigationDestination(
                icon: Icon(Icons.shopping_bag), label: "Đơn hàng"),
            NavigationDestination(
                icon: Icon(Icons.account_circle_outlined), label: "Cá nhân"),
          ],
        ),
      ),
    );
  }
}

class MyHomePage1 extends StatefulWidget {
  const MyHomePage1({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage1> createState() => _MyHomePage1State();
}

class _MyHomePage1State extends State<MyHomePage1> {
  final screens = [
    const UserProductsScreen(),
    const SearchAdminScreen(),
    const PersonalAdminScreen(),
  ];
  late int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) =>
              setState(() => (this.index = index)),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Admin"),
            NavigationDestination(icon: Icon(Icons.search), label: "Tìm kiếm"),
            NavigationDestination(
                icon: Icon(Icons.account_circle_outlined), label: "Cá nhân"),
          ],
        ),
      ),
    );
  }
}
