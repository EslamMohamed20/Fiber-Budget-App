
import 'package:fiber_budget/shared/componnent/componnent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:toast/toast.dart';

import 'length_cubit/length_cubit.dart';
import 'length_cubit/length_states.dart';

class FiberLengthScreen extends StatefulWidget {
  @override
  _FiberLengthScreenState createState() => _FiberLengthScreenState();
}

class _FiberLengthScreenState extends State<FiberLengthScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LengthCubit() ,
      child:
      BlocConsumer<LengthCubit , LengthStates>(
        listener: (context , state)
        {
          var lengthCubit = LengthCubit.get(context);

          if (state is TransPowerInputErrorState)
            {
              Toast.show('Please enter Tx Power!', context ,
                backgroundColor: Colors.red ,duration: 4 ,);
            }
          if (state is ReceivePowerInputErrorState)
          {
            Toast.show('Please enter Rx Power!', context ,
              backgroundColor: Colors.red ,duration: 4 ,);
          }
          if (state is NumOfConnectorsErrorState)
          {
            Toast.show('Please enter No. of connectors !', context ,
              backgroundColor: Colors.red ,duration: 4 ,);
          }
          if (state is NumOfSplicesErrorState)
          {
            Toast.show('Please enter No. of splices !', context ,
              backgroundColor: Colors.red ,duration: 4 ,);
          }
          if(state is CalculateFiberDistanceSuccess)
            {
              buildFinalResultItem(context,

                  showOld: false,
                  fun: (){},
                  newFiberType: lengthCubit.fiberType,
                  margin: lengthCubit.marginLoss,
                  DisUnit: 'KM',
                  totalConnectorLoss:lengthCubit.totalConnectorLosses ,
                  totalSplicesLoss:lengthCubit.totalConnectorLosses ,
                  totalFiberLoss:lengthCubit.totalFiberLosses ,
                  newCableDistance:lengthCubit.totalFiberDistance.toDouble(),
                  newNumOfFiberPieces: lengthCubit.fiberPecies,
                  newPowerBudget: lengthCubit.powerBudget,
                  newLossBudget: lengthCubit.lossBudget,
                  newNumOfConnectors: lengthCubit.nomOfConnectorsGiven,
                  newNumOfSplices:lengthCubit.nomOfSplicesGiven ,
                );
            }
        } ,
        builder: (context , state) {
          var cubit = LengthCubit.get(context);
          return Scaffold(
            backgroundColor: HexColor('#EEEEEE') ,
            body:  SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 6 , left: 10.0 ,right: 10.0 ,bottom: 10.0),
                width: MediaQuery.of(context).size.width ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(image: AssetImage('assets/images/opticalfiber4.jpg'),
                      height: MediaQuery.of(context).size.height*0.215,
                      width: MediaQuery.of(context).size.width ,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10,),
                    //fiber information
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage('assets/images/fibercable.png' ,)
                          ,
                          // height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width *0.16,
                        ) ,

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                builddropdownItem(title:'Fiber Type' ,
                                  context: context ,
                                  hint: 'SM 1550nm ,α = 0.25 dB/Km' ,
                                  value: cubit.fiberType ,
                                  onChanged: (value) {
                                    setState(() {
                                      cubit.fiberType = value ;
                                    });
                                  },
                                  items: [
                                    'SM 1550nm ,α = 0.25 dB/Km' ,
                                    'SM 1310nm ,α = 0.35 dB/Km',
                                    'MM 850nm ,α = 3.5 dB/Km' ,
                                    'MM 1300nm ,α = 1.5 dB/Km' ,
                                  ],
                                ) ,
                                Divider(height: 1, color:Colors.grey,),
                                //fiber length
                                Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Available length' ,
                                      style:TextStyle (fontSize: 18 , fontWeight: FontWeight.w600) ,) ,
                                    Spacer(),
                                    Container(
                                      width:MediaQuery.of(context).size.width *0.3,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(hintText: ' 400' ,
                                          contentPadding: EdgeInsets.all(5.0),
                                          isDense: true ,
                                          suffix:  DropdownButton(
                                            key: Key('Available length'),
                                            value:cubit.FiberlengthUnit,
                                            elevation: 16,
                                            isDense: true,
                                            onChanged:(value){
                                              setState(() {
                                                cubit.FiberlengthUnit = value;
                                              });
                                            } ,

                                            hint: Text('M'),
                                            items : <String>['M' , 'KM']
                                                .map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child:Text(value , softWrap: true,),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        controller: cubit.fiberLengthController,
                                        onSubmitted: (length){
                                          setState(() {
                                            cubit.fiberLengthController.text = length??'400' ;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 5,)


                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey[700],),
                    //conector information
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage('assets/images/connector.png' ,)
                          ,
                          // height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width *0.16,
                        ) ,

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                builddropdownItem(title:'Connector loss' ,
                                  context: context ,
                                  hint: '0.75 dB' ,
                                  width: MediaQuery.of(context).size.width *0.31,
                                  value: '${cubit.connectorLoss}' ,
                                  unit: 'dB',
                                  onChanged: (value) {
                                    setState(() {
                                      cubit.connectorLoss  = value ;
                                    });
                                  },
                                  items: [
                                    '0.75' ,
                                    '0.15',
                                    '0.5',
                                  ],
                                ) ,


                                Divider(height: 16 ,color: Colors.grey,),
                                //nomber of connectors
                                Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('No. of connectors' ,
                                      style:TextStyle (fontSize: 18 , fontWeight: FontWeight.w600) ,) ,
                                    Text('*' ,
                                      style:TextStyle (fontSize: 20 ,
                                          fontWeight: FontWeight.w600 , color: Colors.red) ,) ,
                                    Spacer(),
                                    Container(
                                      width:MediaQuery.of(context).size.width *0.3,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(hintText: '# 0f conn' ,
                                          contentPadding: EdgeInsets.all(5.0),
                                          isDense: true ,

                                        ),
                                        textAlign: TextAlign.center,
                                        controller: cubit.nomOfConnectorsController,
                                        onSubmitted: (number){
                                          setState(() {
                                            cubit.nomOfConnectorsController.text = number;
                                          });
                                        },

                                      ),
                                    ),
                                    SizedBox(width: 5,)


                                  ],
                                ),



                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    //SpliceInformation
                    Divider(color: Colors.grey[700],),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage('assets/images/splice.png' ,)
                          ,
                          // height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width *0.16,
                        ) ,

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              children: [
                                Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Splice loss' ,
                                      style:TextStyle (fontSize: 18 , fontWeight: FontWeight.w600) ,) ,
                                    Spacer(),
                                    Container(
                                      width:MediaQuery.of(context).size.width *0.3,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(hintText: '0.1' ,
                                          contentPadding: EdgeInsets.all(5.0),
                                          isDense: true ,
                                          suffix: Text('dB'),
                                        ),
                                        textAlign: TextAlign.center,
                                        controller: cubit.spliceLossController,
                                        onSubmitted: (loss){
                                          setState(() {
                                            cubit.spliceLossController.text = loss??'0.1' ;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 5,)


                                  ],
                                ),
                                Divider(height: 16 ,color: Colors.grey,),
                                //no. of splices
                                Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('No. of splices' ,
                                      style:TextStyle (fontSize: 18 , fontWeight: FontWeight.w600) ,) ,
                                    Text('*' ,
                                      style:TextStyle (fontSize: 20 ,
                                          fontWeight: FontWeight.w600 , color: Colors.red) ,) ,
                                    Spacer(),
                                    Container(
                                      width:MediaQuery.of(context).size.width *0.3,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(hintText: '# 0f splices' ,
                                          contentPadding: EdgeInsets.all(5.0),
                                          isDense: true ,

                                        ),
                                        textAlign: TextAlign.center,
                                        controller: cubit.nomOfSplicesController,
                                        onSubmitted: (number){
                                          setState(() {
                                            cubit.nomOfSplicesController.text = number;
                                          });
                                        },

                                      ),
                                    ),
                                    SizedBox(width: 5,)


                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey[700],),
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
                              Text('Tx power' ,
                                style:TextStyle (fontSize: 18 , fontWeight: FontWeight.w600) ,),
                              Container(
                                width:MediaQuery.of(context).size.width *0.3,
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(decimal:true ,signed:true ),
                                  decoration: InputDecoration(hintText: '10' ,
                                    contentPadding: EdgeInsets.all(5.0),
                                    isDense: true ,
                                    suffix: Text('dBm'),
                                  ),
                                  textAlign: TextAlign.center,
                                  controller: cubit.transBowerController,
                                  onSubmitted: (tx){
                                    setState(() {
                                      cubit.transBowerController.text = tx;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 5,),
                            ],
                          ),
                          //recive sensitivit
                          Column(
                            children: [
                              Text('Rx power' ,
                                style:TextStyle (fontSize: 18 , fontWeight: FontWeight.w600) ,),
                              Container(
                                width:MediaQuery.of(context).size.width *0.3,
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(decimal:true ,signed:true ),
                                  decoration: InputDecoration(hintText: '3' ,
                                    contentPadding: EdgeInsets.all(5.0),
                                    isDense: true ,
                                    suffix: Text('dBm'),
                                  ),
                                  textAlign: TextAlign.center,
                                  controller: cubit.receiveBowerController,
                                  onSubmitted: (rx){
                                    setState(() {
                                      cubit.receiveBowerController.text = rx ;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 5,),
                            ],
                          ),
                          //margin
                          Column(
                            children: [
                              Text('Margin' ,
                                style:TextStyle (fontSize: 18 , fontWeight: FontWeight.w600) ,),
                              Container(
                                width:MediaQuery.of(context).size.width *0.3,
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(decimal:true ,signed:true ),
                                  decoration: InputDecoration(hintText: '3' ,
                                    contentPadding: EdgeInsets.all(5.0),
                                    isDense: true ,
                                    suffix: Text('dB'),
                                  ),
                                  textAlign: TextAlign.center,
                                  controller: cubit.marginBowerController,
                                  onSubmitted: (margin){
                                    setState(() {
                                      cubit.marginBowerController.text = margin??'3' ;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 5,),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 25,),
                    //calclate button
                    defaultButton(function: (){
                      cubit.fitchValues();
                      cubit.calculateLosses();
                    }
                        , text: 'Calculate' ,isUpperCase: false,
                        textStyle: TextStyle(color: Colors.white , fontSize: 28 ,
                            shadows:[
                              Shadow(
                                  color: Colors.deepOrangeAccent[400],
                                  offset: Offset(0.2 , 2),
                                  blurRadius: 7
                              ),
                            ] )),

                   //usful equation
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('*' ,
                              style:TextStyle (fontSize: 20 ,
                                  fontWeight: FontWeight.w600 , color: Colors.red) ,) ,
                            Icon(Icons.arrow_forward_outlined ,size: 15,),
                            Text('Required.' ,
                              style:TextStyle(fontSize: 14 , fontWeight: FontWeight.w500 ,),),
                          ],
                        ),
                        Text('If you did\'t enter Tx & Rx Power :' ,
                          style:TextStyle(fontSize: 14 , fontWeight: FontWeight.w500 ,
                              color: Colors.grey[700]),),
                        Text(' Calculations passed on Rx=0 , Tx=0;' ,
                          style:TextStyle(fontSize: 14 ,
                            fontWeight: FontWeight.w500 , color: Colors.grey[700]),),
                       SizedBox(height: 3,),
                        Text('Some Useful Equations :' ,
                          style:TextStyle(fontSize: 20 , fontWeight: FontWeight.w700 , color: Colors.blue) ,),
                       Container(
                         width: MediaQuery.of(context).size.width*0.54 ,
                           child: Divider(height: 10, color: Colors.grey[600],) ,),
                        Text('Power Budget(dB) = (Tx Power(dBm) - Rx Sensitivity(dBm)) ' ,
                            style:TextStyle(fontSize: 14 , fontWeight: FontWeight.w500 ,),),
                        SizedBox(height: 5,),
                        Text('Cable Distance = ([Power Budget] - [loss Budget]) / [fiber loss/km] ' ,
                          style:TextStyle(fontSize: 14, fontWeight: FontWeight.w500 ,),),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[500]),
                    SizedBox(height: 6,),
                    //designer info
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
        }, ),
    );



  }
}
