import 'package:fiber_budget/layout/home_cubit/home_cubit.dart';
import 'package:fiber_budget/layout/home_cubit/home_states.dart';
import 'package:fiber_budget/modules/fiber_budget/fiber_budget_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';

Widget builddropdownItem ( {BuildContext context ,
    String title ,
    String hint ,
    String value ,
   String unit ,
    double width ,
  TextStyle hintStyle ,
    List<String> items ,
    Function(dynamic value) onChanged , }
    )
{
  unit = unit==null?'':unit ;
  return  Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(title ,
        style:TextStyle (fontSize: 18 , fontWeight: FontWeight.w600) ,) ,
     // SizedBox(width:MediaQuery.of(context).size.width *0.1 ,),
      Spacer(),
      Container(
        width:width?? MediaQuery.of(context).size.width *0.4,
        child: DropdownButton(
          key: Key(title),
          value:value,

          elevation: 16,
          isExpanded: true,
          underline: Container(
            height: 1,
            color: Colors.black45,
          ),
          //isDense: true,

          onChanged:onChanged ,
          hint: Text(hint ,),
          items : items
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child:Center(child: Text('$value $unit' , softWrap: true,)),
            );
          }).toList(),
        ),
      ),
     // SizedBox(width: 5,),

    ],
  );
}

Widget defaultButton({
  double width = double.infinity,
  double height =50.0,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  TextStyle textStyle ,
  @required Function function,
  @required String text,
}) =>
    Container(
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: textStyle ,
        ),),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

  Future buildFinalResultItem(BuildContext context ,
{
  String oldFiberType ,
  double oldCableDistance ,
  int oldNumOfFiberPieces ,
  double oldPowerBudget ,
  double oldLossBudget ,
  double newTxPower ,
  double newRxPower ,
  int oldNumOfConnectors ,
  int oldNumOfSplices ,
  bool showNewElement= false , 

  @required String newFiberType ,
  @required  bool showOld,
  bool showOldCal,
  @required double margin ,
  @required String DisUnit ,
  double totalSplicesLoss ,
  double totalConnectorLoss ,
  double totalFiberLoss ,
  Function fun,
  @required double newCableDistance ,
  @required int newNumOfFiberPieces ,
  @required double newPowerBudget ,
  @required double newLossBudget ,
  @required int newNumOfConnectors ,
  @required int newNumOfSplices ,

} ) async
{
  return await showDialog(
      context: context,
      builder: (context )
      {
        return AlertDialog(
          elevation: 6,scrollable: true,
          title: Column(
            children: [
              Row(
                children: [
                  Text('Fiber Calculations' ,style: TextStyle(color: Colors.blue ,
                  fontWeight: FontWeight.w700 , fontSize: 24),),
                  Spacer(),
                  IconButton(icon: Icon(Icons.close ,size: 26,),
                      padding: EdgeInsets.all(2),
                      splashRadius: 28,
                      color: Colors.red,
                      onPressed: ()
                  {
                    fun() ;
                    Navigator.of(context).pop();
                  }
                  ) ,

                ],
              ),
              Divider(height: 1, color: Colors.grey,),
            ],
          ),
           shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          titlePadding:EdgeInsets.only(top: 15 , left: 35 ,right: 20 , bottom: 3) ,
          contentPadding: EdgeInsets.only(top: 3,left: 20 , right: 20 , bottom: 10) ,

          actions: [
            defaultButton(function:  ()
            {
              fun();
              Navigator.of(context).pop();
            }, text: 'Close' ,width:MediaQuery.of(context).size.width*0.23 ,
              height: MediaQuery.of(context).size.height*0.045
                ,textStyle: TextStyle(color: Colors.white)),

          ],
          content: Container( 
            child: Column(
              children: [
                if(showOldCal == true)
                    //old calculations
                   if(showOld )
                     if(showOldCal == true)
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.38,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.95,
                        child: SingleChildScrollView(
                          child: Card(
                            elevation: 5,
                            margin: EdgeInsets.all(3),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: Column(
                                children: [
                                  //title
                                  Text('Old Calculations:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 19),),
                                  Divider(color: Colors.grey, height: 10,),
                                  //fiber tybe
                                  SizedBox(height: 9,),
                                  Row(
                                    children: [
                                      Expanded(child: Text('Fiber Type :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),)),
                                      Text('$oldFiberType'),
                                    ],
                                  ),
                                  Divider(color: Colors.grey),
                                  //Cable Distance
                                  Row(
                                    children: [
                                      Expanded(child: Text('Cable Distance:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),)),
                                      Text('$oldCableDistance $DisUnit'),
                                    ],
                                  ),

                                  Divider(color: Colors.grey),
                                  //oldNumOfFiberPieces
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text('No. of Fiber pieces:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),)),
                                      Text('$oldNumOfFiberPieces'),
                                    ],
                                  ),
                                  Divider(color: Colors.grey),
                                  //powerBudget
                                  Row(
                                    children: [
                                      Expanded(child: Text('Power Budget:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),)),
                                      Text('$oldPowerBudget dB'),
                                    ],
                                  ),
                                  Divider(color: Colors.grey),
                                  //loss budget
                                  Row(
                                    children: [
                                      Expanded(child: Text('Loss Budget :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),)),
                                      Text('$oldLossBudget dB'),
                                    ],
                                  ),
                                  Divider(color: Colors.grey),
                                  //margin
                                  Row(
                                    children: [
                                      Expanded(child: Text('Safety Margin :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),)),
                                      Text('$margin dB'),
                                    ],
                                  ),
                                  Divider(color: Colors.grey),
                                  //no. of connectors
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text('No. of Connectors :',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),)),
                                      Text('$oldNumOfConnectors'),
                                    ],
                                  ),
                                  Divider(color: Colors.grey),
                                  //No. of Splices
                                  Row(
                                    children: [
                                      Expanded(child: Text('No. of Splices :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),)),
                                      Text('$oldNumOfSplices'),
                                    ],
                                  ),
                                  Divider(color: Colors.grey, height: 10,),
                                  Text(
                                    'Your test not pass by this calculations',
                                    style: TextStyle(fontWeight: FontWeight.w600
                                      , fontSize: 15,
                                      color: Colors.red,
                                    ),),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    if(showOld )
                      if(showOldCal == true)
                      Divider(color: Colors.grey, height: 10,),

                //correct calculations
                Container(
                  height:showOld?MediaQuery.of(context).size.height*0.383 :
                  MediaQuery.of(context).size.height*0.49,

                  width:MediaQuery.of(context).size.width*0.95 ,
                  child: SingleChildScrollView(
                    child: Card(
                      elevation:5 ,
                      margin: EdgeInsets.all(3),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Column(
                          children: [
                            //title
                            Text('Correct Calculations:' ,
                              style: TextStyle(fontWeight: FontWeight.w800 ,fontSize: 19 , color: Colors.green),),
                            Divider(color:Colors.grey , height: 10,),
                            //fiber tybe
                            SizedBox(height: 9,),
                            Row(
                              children: [
                                Expanded(child: Text('Fiber Type :' ,
                                  style: TextStyle(fontWeight: FontWeight.w600),)),
                                Text('$newFiberType'),
                              ],
                            ),
                            Divider(color:Colors.grey),
                            //Cable Distance

                            Row(
                              children: [
                                Expanded(child: Text('Cable Distance:' ,
                                  style: TextStyle(fontWeight: FontWeight.w600),)),
                                Text('$newCableDistance $DisUnit'),
                              ],
                            ),

                            Divider(color:Colors.grey),
                            //oldNumOfFiberPieces
                            Row(
                              children: [
                                Expanded(child: Text('No. of Fiber pieces:' ,
                                  style: TextStyle(fontWeight: FontWeight.w600),)),
                                Text('$newNumOfFiberPieces'),
                              ],
                            ),
                            Divider(color:Colors.grey),
                            //powerBudget
                            Row(
                              children: [
                                Expanded(child: Text('Power Budget:' ,
                                  style: TextStyle(fontWeight: FontWeight.w600),)),
                                Text('$newPowerBudget dB'),
                              ],
                            ),
                            Divider(color:Colors.grey),
                            //loss budget
                            Row(
                              children: [
                                Expanded(child: Text('Loss Budget :' ,
                                  style: TextStyle(fontWeight: FontWeight.w600),)),
                                Text('$newLossBudget dB'),
                              ],
                            ),
                            Divider(color:Colors.grey),
                              if (showNewElement)
                             //new Tx power
                            Row(
                              children: [
                                Expanded(child: Text('New Tx Power(Example):' ,
                                  style: TextStyle(fontWeight: FontWeight.w600),)),
                                Text('$newTxPower dB'),
                              ],
                            ),
                            if (showNewElement)
                            Divider(color:Colors.grey),
                             if (showNewElement)
                             //new Rx power
                            Row(
                              children: [
                                Expanded(child: Text('New Rx sens.(Example):' ,
                                  style: TextStyle(fontWeight: FontWeight.w600),)),
                                Text('$newRxPower  dB'),
                              ],
                            ),
                            if (showNewElement)
                            Divider(color:Colors.grey),
                            //margin
                            Row(
                              children: [
                                Expanded(child: Text('Safety Margin :' ,
                                  style: TextStyle(fontWeight: FontWeight.w600),)),
                                Text('$margin dB'),
                              ],
                            ),
                            Divider(color:Colors.grey),
                            //no. of connectors
                            Row(
                              children: [
                                Expanded(child: Text('No. of Connectors :' ,
                                  style: TextStyle(fontWeight: FontWeight.w600),)),
                                Text('$newNumOfConnectors'),
                              ],
                            ),
                            if(showOld)
                            Divider(color:Colors.grey),
                            //connector loss
                            if(!showOld)
                            Divider(color:Colors.grey),
                            if(!showOld)
                            Row(
                              children: [
                                Expanded(child: Text('Connectors Loss :' ,
                                  style: TextStyle(fontWeight: FontWeight.w600),)),
                                Text('$totalConnectorLoss'),
                              ],
                            ),
                            if(!showOld)
                            Divider(color:Colors.grey),
                            //No. of Splices
                            Row(
                              children: [
                                Expanded(child: Text('No. of Splices :' ,
                                  style: TextStyle(fontWeight: FontWeight.w600),)),
                                Text('$newNumOfSplices'),
                              ],
                            ),
                            if(showOld)
                            Divider(color:Colors.grey , height: 10,),
                            //splices loss
                            if(!showOld)
                              Divider(color:Colors.grey),
                            if(!showOld)
                              Row(
                                children: [
                                  Expanded(child: Text('Splices Loss :' ,
                                    style: TextStyle(fontWeight: FontWeight.w600),)),
                                  Text('$totalSplicesLoss'),
                                ],
                              ),
                            //fiber loss
                            if(!showOld)
                              Divider(color:Colors.grey),
                            if(!showOld)
                              Row(
                                children: [
                                  Expanded(child: Text('Total Fiber Loss :' ,
                                    style: TextStyle(fontWeight: FontWeight.w600),)),
                                  Text('$totalFiberLoss'),
                                ],
                              ),
                            if(!showOld)
                            Divider(color:Colors.grey),
                            Text('Your test is pass by this calculations' ,
                              style: TextStyle(fontWeight: FontWeight.w600
                                ,fontSize: 15 ,
                                color: Colors.green,
                              ),),

                          ],
                        ),
                      ) ,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
  );
}


class ChooseAlertDialog extends StatefulWidget {

  @override
  _ChooseAlertDialogState createState() => _ChooseAlertDialogState();
}

class _ChooseAlertDialogState extends State<ChooseAlertDialog> {
   bool isDistance = true ; //true => distance , false=> power

   void choose () {
     !isDistance? 
                HomeCubit.get(context).calcRecommendedPowerBudget():
                HomeCubit.get(context).calcRecommendedFiberLength();
  }
  @override
  Widget build(BuildContext context) {
  
        return BlocConsumer <HomeCubit , HomeStates>(
          listener: (context, state )async {    
          },
          builder: (context, state ){
           return AlertDialog(
            elevation: 6,scrollable: true,
            title: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                     color: Colors.orange[600], size: 36,) ,
                    Text('Wrong Calculations' ,style: TextStyle(color: Colors.red ,
                    fontWeight: FontWeight.w700 , fontSize: 24),),
                    Spacer(),
                    IconButton(icon: Icon(Icons.close ,size: 26,),
                        padding: EdgeInsets.all(2),
                        splashRadius: 28,
                        color: Colors.red,
                        onPressed: ()
                    {
                      Navigator.of(context).pop();
                    }
                    ) ,

                  ],
                ),
                Divider(height: 1, color: Colors.grey,),
              ],
            ),
             shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            titlePadding:EdgeInsets.only(top: 15 , left: 18 ,right: 15 , bottom: 3) ,
            contentPadding: EdgeInsets.only(top: 3,left: 20 , right: 15 , bottom: 10) ,
            
            actions: [
              defaultButton(function:  ()
              { 
                choose();
                Navigator.of(context).pop();
              }, 

              text: 'Calculate' ,
              width:MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height*0.045
                  ,textStyle: TextStyle(color: Colors.white)),

            ],
           
           content: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text ('According to the values you have entered:' ,
               style: TextStyle(fontWeight: FontWeight.w700 , color: Colors.blue , fontSize: 15), ) ,
               Container(
                 width: MediaQuery.of(context).size.width*0.66,
                 child: Divider(color:Colors.grey[300] 
                 , ),
               ),
               Text ('The Power Budget not enough to transmit data along with this whole distance!') , 
               SizedBox(height: 10,),
               Text ('Choose one of these methods to evaluate the Correct values:' ,
               style: TextStyle(fontWeight: FontWeight.w600 ,),) ,

               RadioListTile(
                 value: true , 
                 groupValue: isDistance  , 
                  onChanged: (value) {
                    setState(() {
                     isDistance = value ;
                      print( isDistance);
                    });
                  },
 
                  title: Text ('Correct Distance' ,
                  style: TextStyle(color: Colors.blue , fontWeight: FontWeight.w500),),
                  subtitle:Text ('Generate the correct distance limited by the power budget you entered!'), 
                  ) ,
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Container(
                     width: MediaQuery.of(context).size.width*0.6,
                     child: Divider(color:Colors.grey[400]  , height: 0
                     , ),
               ),
                   ],
                 ),
              
                    RadioListTile(
                   value: false, 
                   groupValue: isDistance,
                  onChanged: (value)
                  {
                    setState(() {
                      
                      isDistance = value ;
                      print( isDistance);
                    });
                  } ,
                  title: Text ('Correct Power budget' , 
                  style: TextStyle(color: Colors.blue , fontWeight: FontWeight.w500),),
                  subtitle:Text ('Generate enough power budget to transmit your data along the whole distance you entered!'), 
                  ) ,
                       
                      

             ],
           ),
          );
       
          },
                   );
      

  }
}



Widget buildDesignerItem ({String name , String bio , String phone , String imagePath})
{
  return  ListTile(title:Text(name , style: TextStyle(fontWeight: FontWeight.w700),),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(bio , style: TextStyle(fontWeight: FontWeight.w500),) ,
        Text(phone ,style: TextStyle(fontWeight: FontWeight.w500),) ,
      ],
    ),
    leading: CircleAvatar(
      backgroundImage:AssetImage(imagePath,) ,
      radius: 25, 
    ),
     contentPadding: EdgeInsets.symmetric(horizontal: 1 ,  vertical: 2),
  ) ;
}

