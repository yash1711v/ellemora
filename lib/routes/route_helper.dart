import 'package:elmore/features/ProductPage/view/product_screen.dart';
import 'package:elmore/routes/routes.dart';

class RouteHelper {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.id:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case HomeScreen.id:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case Login.id:
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );
      case SignUp.id:
        return MaterialPageRoute(
          builder: (context) => const SignUp(),
        );
      case CartPage.id:
        return MaterialPageRoute(
          builder: (context) => const CartPage(),
        );
        case ProductScreen.id:
        return MaterialPageRoute(
          builder: (context) => const ProductScreen(),
        );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
