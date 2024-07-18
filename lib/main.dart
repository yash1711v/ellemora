import 'package:elmore/AuthBloc/auth_cubit.dart';
import 'package:elmore/features/HomeScreen/controller/home_cubit.dart';
import 'package:elmore/features/ProductPage/controller/item_cubit.dart';
import 'package:elmore/routes/route_helper.dart';
import 'package:elmore/util/network/internet_handler.dart';
import 'package:elmore/widgets/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cache/shared_pref.dart';
import 'features/Splash/splash_screen.dart';
import 'flavors/config/flavor_config.dart';
import 'package:bot_toast/bot_toast.dart';
import 'Themes/theme.dart'; // Import the theme definitions

// global context used for logout
BuildContext? globalContext;
final navigatorKey = GlobalKey<NavigatorState>();

Future mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Pref.instance.init();

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  themeNotifier.value = isDarkMode;

  runApp(
    Phoenix(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (BuildContext context) => HomeCubit(),
        ),
        BlocProvider<ItemCubit>(
          create: (BuildContext context) => ItemCubit(),
        ),
      ],
      child: InternetHandler(
        child: ValueListenableBuilder<bool>(
          valueListenable: themeNotifier,
          builder: (context, isDarkMode, child) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              title: FlavorConfig.instance.appName,
              debugShowCheckedModeBanner: false,
              builder: (context, child) =>
                  ResponsiveBuilder(
                    builder: (context) {
                      return BotToastInit()(context, child);
                    },
                  ),
              navigatorObservers: [BotToastNavigatorObserver()],
              theme: isDarkMode ? Themes.dark : Themes.light,
              onGenerateRoute: RouteHelper.generateRoute,
              initialRoute: SplashScreen.id,
            );
          },
        ),
      ),
    );
  }
}

final ValueNotifier<bool> themeNotifier = ValueNotifier(false);

void toggleTheme() async {
  final prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
  isDarkMode = !isDarkMode;
  await prefs.setBool('isDarkMode', isDarkMode);
  themeNotifier.value = isDarkMode;
}
