

import 'package:fiber_budget/layout/home_cubit/home_cubit.dart';
import 'package:fiber_budget/layout/home_cubit/home_states.dart';
import 'package:fiber_budget/modules/fiber_budget/fiber_budget_screen.dart';
import'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit , HomeStates>(
      listener: (context , state ) {} ,
        builder: (context , state ) {
        var cubit = HomeCubit.get(context);
        return  Scaffold(
          backgroundColor: HexColor('#E0E0E0') ,
          appBar: AppBar(
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.blue ,
              statusBarIconBrightness: Brightness.light ,
            ),

            centerTitle: true,
            title: Text(
              'Fiber optics calculator',
              style: TextStyle(fontSize: 27, shadows: [
                Shadow(
                  offset: Offset(0.3, 2),
                  color: Colors.deepOrangeAccent[400],
                  blurRadius: 6.0,
                )
              ]),
            ),
            elevation: 20.0,
            shadowColor: Colors.deepOrangeAccent[300],
          ),
          bottomNavigationBar:BottomNavigationBar(
            currentIndex:cubit.navBarIndex ,
            onTap: (index ) {
              cubit.navBarChange(index);
            },
              elevation: 30,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),

            items: [
              BottomNavigationBarItem(
                icon: Image(
                  image:AssetImage('assets/icons/rca.png') , height: 22,
                 color: cubit.navBarIndex == 0? Colors.blue[600] : null,
                ) ,
                 // icon: Icon(Icons.wifi_tethering_sharp) ,
                   label: 'Fiber Budget' ,
              ),

              BottomNavigationBarItem(
                icon: Image(image:AssetImage('assets/icons/oplength.png') , height: 22,
                  color: cubit.navBarIndex == 1? Colors.blue[600] : null,
                ) ,
                label: 'Fiber Length' ,
              ),
            ]
          ) ,
          body: cubit.navBarWidgets[cubit.navBarIndex] ,
        );
        } , );

  }
}
