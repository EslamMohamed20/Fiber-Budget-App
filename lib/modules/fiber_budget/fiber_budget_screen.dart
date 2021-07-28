import 'package:fiber_budget/layout/home_cubit/home_cubit.dart';
import 'package:fiber_budget/layout/home_cubit/home_states.dart';
import 'package:fiber_budget/shared/componnent/componnent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:toast/toast.dart';

class FiberBudgetScreen extends StatefulWidget {
  @override
  _FiberBudgetScreenState createState() => _FiberBudgetScreenState();
}

class _FiberBudgetScreenState extends State<FiberBudgetScreen> {
  
  
 
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) async {
        var listenCubit = HomeCubit.get(context);
        if (state is PowerInputErrorState) {
          Toast.show(
            'Please input Tx Power & Rx Power!',
            context,
            backgroundColor: Colors.red,
            duration: 4,
          );
        }
        if (state is CalculateBudgetResultErrorState) {
          Toast.show(
            'Your Transmitted Power(Tx) Lower Than Rx sensitivity, Or Your Power Budget Not Enough',
            context,
            backgroundColor: Colors.red,
            duration: 6,
          );
        }
        if (state is CalculateTotalDistanceErrorState) {
          Toast.show(
            'Please enter Cable Distance!',
            context,
            backgroundColor: Colors.red,
            duration: 4,
          );
        }
        if (state is CalculateFinalResultSuccessState)
          await buildFinalResultItem(
            context,
            showOld: true,
            fun: () {
              setState(() {
                listenCubit.showOldCal = false;
                listenCubit.isMarginCheck = false;
              });
            },
            showOldCal: listenCubit.showOldCal,
            newFiberType: listenCubit.fiberType,
            newCableDistance:
                listenCubit.totalLength / listenCubit.distanceUnitFactor,
            newLossBudget: listenCubit.lossBudget,
            newNumOfConnectors: listenCubit.numOfConnectors,
            newNumOfSplices: listenCubit.numOfSplices,
            newPowerBudget: listenCubit.powerBudget,
            newNumOfFiberPieces: listenCubit.numOfFiberPieces,
            margin: listenCubit.marginLoss,
            DisUnit: listenCubit.distanceUnit,
            oldFiberType: listenCubit.fiberType,
            oldNumOfFiberPieces: listenCubit.oldNumOfFiberPieces,
            oldCableDistance:
                listenCubit.oldTotalLength / listenCubit.distanceUnitFactor,
            oldLossBudget: listenCubit.oldLossBudget,
            oldNumOfConnectors: listenCubit.oldNumOfConnectors,
            oldNumOfSplices: listenCubit.oldNumOfSplices,
            oldPowerBudget: listenCubit.powerBudget,
          );


        if (state is CalculateCalcNewResultSuccessState) { 
         showDialog(context: context, builder: (context ) => ChooseAlertDialog() ,);
        
        }
       
       if (state is CalcRecommendedPowerBudgetSuccessState)
       {
          await buildFinalResultItem(
            context,
            showOld: true,
            showNewElement: true ,
            fun: () {
              setState(() {
                listenCubit.showOldCal = false;
                listenCubit.isMarginCheck = false;
              });
            },
            newRxPower: listenCubit.newRxPower,
            newTxPower:listenCubit.newTxPower ,
            showOldCal: listenCubit.showOldCal,
            newFiberType: listenCubit.fiberType,
            newCableDistance:
                listenCubit.totalLength / listenCubit.distanceUnitFactor,
            newLossBudget: listenCubit.lossBudget,
            newNumOfConnectors: listenCubit.numOfConnectors,
            newNumOfSplices: listenCubit.numOfSplices,
            newPowerBudget: listenCubit.newpowerBudget,
            newNumOfFiberPieces: listenCubit.numOfFiberPieces,
            margin: listenCubit.marginLoss,
            DisUnit: listenCubit.distanceUnit,
            oldFiberType: listenCubit.fiberType,
            oldNumOfFiberPieces: listenCubit.oldNumOfFiberPieces,
            oldCableDistance:
                listenCubit.oldTotalLength / listenCubit.distanceUnitFactor,
            oldLossBudget: listenCubit.oldLossBudget,
            oldNumOfConnectors: listenCubit.oldNumOfConnectors,
            oldNumOfSplices: listenCubit.oldNumOfSplices,
            oldPowerBudget: listenCubit.powerBudget,
          );


       }

      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          backgroundColor: HexColor('#EEEEEE'),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: 6, left: 10.0, right: 10.0, bottom: 10.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage('assets/images/opticalfiber2.jpg'),
                    height: MediaQuery.of(context).size.height * 0.21,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //fiber information
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(
                          'assets/images/fibercable.png',
                        ),
                        // height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.16,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              builddropdownItem(
                                title: 'Fiber Type',
                                context: context,
                                hint: 'SM 1550nm ,α = 0.25 dB/Km',
                                value: cubit.fiberType,
                                onChanged: (value) {
                                  setState(() {
                                    cubit.fiberType = value;
                                  });
                                },
                                items: [
                                  'SM 1550nm ,α = 0.25 dB/Km',
                                  'SM 1310nm ,α = 0.35 dB/Km',
                                  'MM 850nm ,α = 3.5 dB/Km',
                                  'MM 1300nm ,α = 1.5 dB/Km',
                                ],
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                              //fiber length
                              Row(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Available length',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: ' 400',
                                        contentPadding: EdgeInsets.all(5.0),
                                        isDense: true,
                                        suffix: DropdownButton(
                                          key: Key('Available length'),
                                          value: cubit.FiberlengthUnit,
                                          elevation: 16,
                                          isDense: true,
                                          onChanged: (value) {
                                            setState(() {
                                              cubit.FiberlengthUnit = value;
                                            });
                                          },
                                          hint: Text('M'),
                                          items: <String>['M', 'KM']
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                softWrap: true,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      controller: cubit.fiberLengthController,
                                      onSubmitted: (length) {
                                        setState(() {
                                          cubit.fiberLengthController.text =
                                              length ?? '400';
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  )
                                ],
                              ),

                              Divider(
                                height: 16,
                                color: Colors.grey,
                              ),
                              //Distance
                              Row(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cable Distance',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '*',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                  ),
                                  Spacer(),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: '10',
                                        contentPadding: EdgeInsets.all(5.0),
                                        isDense: true,
                                        suffix: DropdownButton(
                                          key: Key('Distance'),
                                          value: cubit.distanceUnit,
                                          elevation: 16,
                                          isDense: true,
                                          onChanged: (value) {
                                            setState(() {
                                              cubit.distanceUnit = value;
                                            });
                                          },
                                          hint: Text('M'),
                                          items: <String>['M', 'KM']
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                softWrap: true,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      controller: cubit.distanceController,
                                      onSubmitted: (distance) {
                                        setState(() {
                                          cubit.distanceController.text =
                                              distance ?? '10';
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[700],
                  ),
                  //conector information
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(
                          'assets/images/connector.png',
                        ),
                        // height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.16,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              builddropdownItem(
                                title: 'Connector loss',
                                context: context,
                                hint: '0.75 dB',
                                width: MediaQuery.of(context).size.width * 0.31,
                                value: '${cubit.connectorLoss}',
                                unit: 'dB',
                                onChanged: (value) {
                                  setState(() {
                                    cubit.connectorLoss = value;
                                  });
                                },
                                items: [
                                  '0.75',
                                  '0.15',
                                  '0.5',
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  //SpliceInformation
                  Divider(
                    color: Colors.grey[700],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage(
                          'assets/images/splice.png',
                        ),
                        // height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.16,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Splice loss',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Spacer(),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '0.1',
                                    contentPadding: EdgeInsets.all(5.0),
                                    isDense: true,
                                    suffix: Text('dB'),
                                  ),
                                  textAlign: TextAlign.center,
                                  controller: cubit.spliceLossController,
                                  onSubmitted: (loss) {
                                    setState(() {
                                      cubit.spliceLossController.text =
                                          loss ?? '0.1';
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[700],
                  ),
                  //power&margin
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //transmited power
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Tx power',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '*',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true, signed: true),
                                decoration: InputDecoration(
                                  hintText: '10',
                                  contentPadding: EdgeInsets.all(5.0),
                                  isDense: true,
                                  suffix: Text('dBm'),
                                ),
                                textAlign: TextAlign.center,
                                controller: cubit.transBowerController,
                                onSubmitted: (tx) {
                                  setState(() {
                                    cubit.transBowerController.text = tx;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        //recive sensitivit
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Rx power',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '*',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true, signed: true),
                                decoration: InputDecoration(
                                  hintText: '3',
                                  contentPadding: EdgeInsets.all(5.0),
                                  isDense: true,
                                  suffix: Text('dBm'),
                                ),
                                textAlign: TextAlign.center,
                                controller: cubit.receiveBowerController,
                                onSubmitted: (rx) {
                                  setState(() {
                                    cubit.receiveBowerController.text = rx;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        //margin
                        Column(
                          children: [
                            Text(
                              'Margin',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true, signed: true),
                                decoration: InputDecoration(
                                  hintText: '3',
                                  contentPadding: EdgeInsets.all(5.0),
                                  isDense: true,
                                  suffix: Text('dB'),
                                ),
                                textAlign: TextAlign.center,
                                controller: cubit.marginBowerController,
                                onSubmitted: (margin) {
                                  setState(() {
                                    cubit.marginBowerController.text =
                                        margin ?? '3';
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 25,
                  ),
                  //calclate button
                  defaultButton(
                      function: () {
                        cubit.fitchValues();
                        cubit.calculateBudgetResult();
                        cubit.calculateLosses();
                      },
                      text: 'Calculate',
                      isUpperCase: false,
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          shadows: [
                            Shadow(
                                color: Colors.deepOrangeAccent[400],
                                offset: Offset(0.2, 2),
                                blurRadius: 7),
                          ])),
                  //usful equation
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '*',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red),
                            ),
                            Icon(
                              Icons.arrow_forward_outlined,
                              size: 15,
                            ),
                            Text(
                              'Required.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                          ],
                        ),
                       SizedBox(
                          height: 0,
                        ),
                        Text('The reference value of Rx Sens is {-27 to -8 dBM}'
                         ,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                       SizedBox(
                          height: 4,
                        ),
                        Text('Intial value of Rx Sens in my calculations = -12 dBM'
                         ,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(
                          height: 5,
                        ),
                      
                        Text(
                          'Some Useful Equations :',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.54,
                          child: Divider(
                            height: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Power Budget(dB) = (Tx Power(dBm) - Rx Sensitivity(dBm)) ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Loss Budget = [fiber length (km) × fiber attenuation per km] +'
                          '[splice loss × # of splices] '
                          '[connector loss × # of connectors]',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      
                      
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[500]),
                    SizedBox(height: 6,),
                  // designer info
                  Card(
                    elevation: 9,
                    margin: EdgeInsets.all(2),
                    color: HexColor('#EEEEEE'),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Designed & Engineered by : ',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.521,
                            child: Divider(
                              height: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                          buildDesignerItem(
                              name: 'Eslam Mohamed',
                              bio: 'Electronics & Communication Engineer',
                              phone: '+20 01141752766',
                              imagePath: 'assets/images/eslam.png'),
                          Divider(height: 0, color: Colors.grey[500]),
                          buildDesignerItem(
                              name: 'Yahia Zakaria',
                              bio: 'Electronics & Communication Engineer',
                              phone: '+20 01114220410',
                              imagePath: 'assets/images/yahia.jpeg'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
     
      },
    );
  }
}
