


import 'package:bloc/bloc.dart';
import 'package:fiber_budget/modules/fiber_budget/fiber_budget_screen.dart';
import 'package:fiber_budget/modules/fiber_length/fiber_length_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'length_states.dart';

class LengthCubit extends Cubit<LengthStates>{
  LengthCubit():super(HomeInitState());  //يبدأ بيها

//علشان اقدر اعمل منه اوبجكت اقدر استخدمه ف اى  مكان
  static LengthCubit get(context) => BlocProvider.of(context);  // CounterCubit.get(context).توصل لاى حاجه جوه

//هابتدى اعرف متغيراتى بقى والفانكشن اللبتسند قيم فيها

  String fiberType ='SM 1550nm ,α = 0.25 dB/Km';
  double fiberLoss=0.25;
  void chooseFiberLoss()
  {
    if(fiberType == 'SM 1550nm ,α = 0.25 dB/Km' )
      fiberLoss=0.25 ;
    if(fiberType == 'SM 1310nm ,α = 0.35 dB/Km' )
      fiberLoss=0.35 ;
    if(fiberType == 'MM 850nm ,α = 3.5 dB/Km' )
      fiberLoss= 3.5 ;
    if(fiberType == 'MM 1300nm ,α = 1.5 dB/Km' )
      fiberLoss= 1.5 ;
  }

  TextEditingController fiberLengthController = TextEditingController();
  String FiberlengthUnit = 'M' ;
  int fiberlengthUnitFactor =1 ;

  String connectorLoss ='0.75';

  TextEditingController spliceLossController = TextEditingController() ;
  TextEditingController transBowerController = TextEditingController() ;
  TextEditingController receiveBowerController = TextEditingController() ;
  TextEditingController marginBowerController = TextEditingController() ;
  TextEditingController nomOfConnectorsController = TextEditingController() ;
  TextEditingController nomOfSplicesController = TextEditingController() ;


  double powerBudget ;
  double lossBudget;
  double linkBudget;
  double totalLength ;
  double totalFiberLosses;
  double totalConnectorLosses;
  double totalSplicesLosses;
  double marginLoss ;
  double availableMargintoLossBudget ;
  int fiberPecies ;

  //in padge 2 >> leangth
  int nomOfConnectorsGiven ;
  int nomOfSplicesGiven;

  void fitchValues()
  {
    if (transBowerController.text.isEmpty && receiveBowerController.text.isEmpty)
    {
      powerBudget = 0.0 ;
    }
    if (transBowerController.text.isEmpty  &&receiveBowerController.text.isNotEmpty)
    {
      emit(TransPowerInputErrorState());
      powerBudget= null;

    }
    if (receiveBowerController.text.isEmpty && transBowerController.text.isNotEmpty )
    {
      emit(ReceivePowerInputErrorState());
      powerBudget= null;
    }
    if(transBowerController.text.isNotEmpty && receiveBowerController.text.isNotEmpty)
      {
      powerBudget = double.parse(transBowerController.text ) - double.parse(receiveBowerController.text) ;
    }

    fiberlengthUnitFactor  = FiberlengthUnit=='M' ?1 : 1000 ;
    fiberLengthController.text= fiberLengthController.text.isEmpty?'400':fiberLengthController.text ;
       if (nomOfConnectorsController.text.isEmpty)
         emit(NumOfConnectorsErrorState());
    nomOfConnectorsGiven = int.parse(nomOfConnectorsController.text) ;
    if (nomOfSplicesController.text.isEmpty)
      emit(NumOfSplicesErrorState());
      nomOfSplicesGiven = int.parse(nomOfSplicesController.text);
      print('nomOfConnectorsGiven = $nomOfConnectorsGiven');
      print('nomOfSplicesGiven= $nomOfSplicesGiven');


  }

  int totalFiberDistance ;
  void calculateFiberDistance ()
  {
     totalFiberDistance = ((powerBudget - linkBudget ) / fiberLoss).round() ;
    print ('$totalFiberDistance= totalFiberDistance');
    if (totalFiberDistance <=0)
      {
        totalFiberDistance = nomOfConnectorsGiven +nomOfSplicesGiven +1 ;
        fiberPecies= (totalFiberDistance*1000 / double.parse(fiberLengthController.text)).round();
        print ('$totalFiberDistance= totalFiberDistance');
      }else
      fiberPecies= (totalFiberDistance*1000 / double.parse(fiberLengthController.text)).round();

  }

  void calculateLosses(){
    chooseFiberLoss();
    spliceLossController.text = spliceLossController.text.isEmpty?'0.1' :spliceLossController.text ;
    marginBowerController.text = marginBowerController.text.isEmpty?'3' :marginBowerController.text ;
    totalConnectorLosses = double.parse(connectorLoss)* nomOfConnectorsGiven ;
    print('totalConnectorLosses= $totalConnectorLosses');
    totalSplicesLosses=nomOfSplicesGiven*double.parse(spliceLossController.text);
    print('totalSplicesLosses= $totalSplicesLosses');
    marginLoss = double.parse(marginBowerController.text);
    print('marginLoss= $marginLoss');
    linkBudget = totalConnectorLosses+totalSplicesLosses + marginLoss ;
    print('linkBudget= $linkBudget');
    calculateFiberDistance();
    totalFiberLosses = totalFiberDistance*fiberLoss ;
    lossBudget=totalFiberLosses+totalConnectorLosses+totalSplicesLosses ;
    print('lossBudget= $lossBudget');
    print('powerBudget= $powerBudget');
   // marginCheck ();
    emit(CalculateFiberDistanceSuccess());
  }



}

