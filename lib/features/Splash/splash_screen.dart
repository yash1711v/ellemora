import 'package:elmore/AuthBloc/auth_cubit.dart';
import 'package:elmore/AuthBloc/auth_state.dart';
import 'package:elmore/features/HomeScreen/view/home_screen.dart';
import 'package:elmore/features/singUp/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  static const id = "/";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
      Future.delayed(Duration(seconds: 3)).then((value){
        context.read<AuthCubit>().checkAuthStatus(context);
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: Text("Welcome to Elmore ❤️"),
          ),
        );
      },
    );
  }
}
