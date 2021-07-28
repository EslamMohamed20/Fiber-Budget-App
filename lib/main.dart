import 'package:fiber_budget/layout/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/home_screen.dart';

void main() => runApp(
    BlocProvider(
        create: (BuildContext context) => HomeCubit() ,
      child: MyApp() ,
    )
) ;


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false ,
      title: 'Test',
      home: HomeScreen(),
    );
  }
}



