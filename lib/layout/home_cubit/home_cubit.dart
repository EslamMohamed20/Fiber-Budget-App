


import 'package:bloc/bloc.dart';
import 'package:fiber_budget/modules/fiber_budget/fiber_budget_screen.dart';
import 'package:fiber_budget/modules/fiber_length/fiber_length_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates>{
  HomeCubit():super(HomeInitState());  //يبدأ بيها

//علشان اقدر اعمل منه اوبجكت اقدر استخدمه ف اى  مكان
  static HomeCubit get(context) => BlocProvider.of(context);  // CounterCubit.get(context).توصل لاى حاجه جوه

//هابتدى اعرف متغيراتى بقى والفانكشن اللبتسند قيم فيها

  int navBarIndex =0  ;
void navBarChange (int index ) {
  navBarIndex = index ;
  emit(NavBarChangeSuccess());
}

 List<Widget> navBarWidgets =
 [
   FiberBudgetScreen() ,
   FiberLengthScreen (),
 ];
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
  TextEditingController distanceController = TextEditingController() ;
 // String distance = '400' ;
  String distanceUnit = 'KM' ;
  int distanceUnitFactor =1000;
  String connectorLoss ='0.75';
  TextEditingController spliceLossController = TextEditingController() ;
  TextEditingController transBowerController = TextEditingController() ;
  TextEditingController receiveBowerController = TextEditingController() ;
  TextEditingController marginBowerController = TextEditingController() ;

  double powerBudget ;
  double lossBudget;
  int numOfSplices = 0;
  double totalLength ;
  int numOfFiberPieces ;
  int numOfConnectors ;
  double totalFiberLosses;
  double totalConnectorLosses;
  double totalSplicesLosses;
  double marginLoss ;
  double availableMargintoLossBudget ;
  double fiberDistance;

  //old data
  double  oldTotalLength ;
  double oldTotalFiberLosses ;
  double  oldLossBudget ;
  int  oldNumOfFiberPieces ;
  int oldNumOfConnectors ;
  int oldNumOfSplices =0;
  double oldTotalConnectorLosses;
  double oldTotalSplicesLosses ;

  void fitchValues()
  {
    if (transBowerController.text.isEmpty || receiveBowerController.text.isEmpty)
      {
        emit(PowerInputErrorState());
        emit(CalculateFinalResultErrorState());
      }
    powerBudget = double.parse(transBowerController.text ) - double.parse(receiveBowerController.text) ;
    fiberlengthUnitFactor  = FiberlengthUnit=='M' ?1 : 1000 ;
    distanceUnitFactor = distanceUnit == 'KM'? 1000 : 1 ;
    if(distanceController.text.isNotEmpty)
      {
        totalLength = double.parse(distanceController.text)*distanceUnitFactor ;
        oldTotalLength =  double.parse(distanceController.text)*distanceUnitFactor ;
      }
    else
      {
        totalLength = 0 ;
        emit(CalculateTotalDistanceErrorState());
        emit(CalculateFinalResultErrorState());
    }
    fiberLengthController.text= fiberLengthController.text.isEmpty?'400':fiberLengthController.text ;
  }


  void calculateBudgetResult ()
  {
     print('totalLength= $totalLength');
     if(powerBudget>0)
      {
        numOfFiberPieces = (totalLength /(double.parse(fiberLengthController.text)*fiberlengthUnitFactor)).round();
        oldNumOfFiberPieces = (oldTotalLength /(double.parse(fiberLengthController.text)*fiberlengthUnitFactor)).round();
         print('numofpieces : $numOfFiberPieces');
        print('oldNumOfFiberPieces : $oldNumOfFiberPieces');
         numOfConnectors = numOfFiberPieces-1;
        oldNumOfConnectors = oldNumOfFiberPieces -1 ;
        if (totalLength > 6000)
          {
            numOfSplices = ((totalLength/6000)-1).round() ;
            oldNumOfSplices =  ((oldTotalLength/6000)-1).round() ;
            numOfConnectors = numOfConnectors-numOfSplices ;
            oldNumOfConnectors = oldNumOfConnectors - oldNumOfSplices ;
            print('numOfConnectors : $numOfConnectors');
            print('numOfSplices = $numOfSplices');
            print('oldNumOfConnectors : $oldNumOfConnectors');
            print('oldNumOfSplices = $oldNumOfSplices');
            emit(CalculateBudgetResultSuccessState());

          }
        else
          {
           // numOfSplices=0 ;
           // oldNumOfSplices = 0;
            print('numOfConnectors : $numOfConnectors');
            print('numOfSplices = $numOfSplices');
            print('oldNumOfConnectors : $oldNumOfConnectors');
            print('oldNumOfSplices = $oldNumOfSplices');
            emit(CalculateBudgetResultSuccessState());
          }


      }
    else
      {
        print('negative budget');
        emit(CalculateBudgetResultErrorState());
        emit(CalculateFinalResultErrorState());
      }

  }
  
  bool isMarginCheck = false;
   
  void calculateLosses(){
    chooseFiberLoss() ;
    spliceLossController.text = spliceLossController.text.isEmpty?'0.1' :spliceLossController.text ;
    marginBowerController.text = marginBowerController.text.isEmpty?'3' :marginBowerController.text ;
    totalFiberLosses = totalLength *fiberLoss/1000 ;
    oldTotalFiberLosses = oldTotalLength *fiberLoss/1000 ;
    print('fiberLoss= $totalFiberLosses');
    print('oldTotalFiberLosses= $oldTotalFiberLosses');
    totalConnectorLosses = double.parse(connectorLoss)* numOfConnectors ;
    oldTotalConnectorLosses = double.parse(connectorLoss)* oldNumOfConnectors ;
    print('totalConnectorLosses= $totalConnectorLosses');
    totalSplicesLosses=numOfSplices*double.parse(spliceLossController.text);
    oldTotalSplicesLosses =  oldNumOfSplices*double.parse(spliceLossController.text);
    print('totalSplicesLosses= $totalSplicesLosses');
    marginLoss = double.parse(marginBowerController.text);
    print('marginLoss= $marginLoss');
    lossBudget=totalFiberLosses+totalConnectorLosses+totalSplicesLosses ;
    oldLossBudget = oldTotalFiberLosses+ oldTotalConnectorLosses + oldTotalSplicesLosses ;
    print('lossBudget= $lossBudget');
    print('oldLossBudget= $oldLossBudget');
    print('powerBudget= $powerBudget');
    if( isMarginCheck == false)
    marginCheck();
    if( isMarginCheck == true)
    calcRecommendedFiberLength();

   // double marginLoss ;
  }
  
  bool showOldCal = false;
     bool isDistance = false;
    bool isPower  =false ;

  void marginCheck ( ) {
    if(powerBudget - lossBudget < marginLoss)
      { 
         emit (CalculateCalcNewResultSuccessState(isDistance:isDistance , isPower:  isPower ));       
        //emit(CalculateFinalResultErrorState()) ;
        //emit(CalculateFinalResultSuccessState()) ;
        // availableMargintoLossBudget = powerBudget - marginLoss ;
        // fiberDistance =
        // (availableMargintoLossBudget - totalConnectorLosses - totalSplicesLosses)/fiberLoss ;
        // print('fiberDistance = $fiberDistance');

      }
    else
      emit(CalculateFinalResultSuccessState()) ;
  //  showOldCal = !showOldCal;

  }

  double newTxPower = 0 ;
  double newRxPower = -12 ;
  double newpowerBudget ;

  void calcRecommendedPowerBudget () 
  {
     showOldCal = true;
     isMarginCheck = false;
     newpowerBudget = lossBudget + marginLoss;
     newTxPower = newpowerBudget + newRxPower ;
     emit(CalcRecommendedPowerBudgetSuccessState());
  }

   void calcRecommendedFiberLength () 
  {  
    showOldCal = true ;
    isMarginCheck = true;
        totalLength=totalLength-500;
        if(powerBudget - lossBudget < marginLoss)
        {
        calculateBudgetResult();
        calculateLosses();
        }
        else {
          marginCheck();
        }
        

  }


}

