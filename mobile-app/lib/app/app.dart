import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mushroom_master/guide/view/encyclopedia_page.dart';
import 'package:mushroom_master/navigation/cubit/nav_bar_cubit.dart';
import 'package:mushroom_master/navigation/nav_bar.dart';
import 'package:mushroom_master/utils/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavBarCubit(), child: const NavBar(),),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const EncyclopediaPage(),
      ),
    );
  }
}