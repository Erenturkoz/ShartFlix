import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/presentation/pages/home_page.dart';
import 'package:shartflix/presentation/pages/login_page.dart';
import 'package:shartflix/presentation/viewmodels/auth_cubit.dart';
import 'package:shartflix/presentation/viewmodels/movie_viewmodel.dart';
import 'di/locator.dart';

void main() {
  setupLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider<MovieCubit>(create: (_) => MovieCubit()),
        // BlocProvider<ProfileCubit>(create: (_) => ProfileCubit()),
      ],
      child: const ShartflixApp(),
    ),
  );
}

class ShartflixApp extends StatelessWidget {
  const ShartflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shartflix',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const LoginPage(),
      routes: {'/home': (_) => const HomePage()},
    );
  }
}
