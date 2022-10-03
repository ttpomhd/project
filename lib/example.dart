import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:newpro/data/db_config.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:newpro/data/myLocal.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/List.dart';



class MyHome extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final VoidCallback onChanged;

  const MyHome({
  super.key,
  this.savedThemeMode,
  required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(myLocalCtr());
    return AdaptiveTheme(
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(



        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',



        theme: theme,
        darkTheme: darkTheme,
        home: MyHomePage(onChanged: onChanged),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  final VoidCallback onChanged;

  const MyHomePage({super.key, required this.onChanged});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
bool mode=true;
class _MyHomePageState extends State<MyHomePage> {



  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?' ;
double z=0.0;
  int Health_Points=0;
  @override
  void initState() {
    super.initState();
    z=10/100;
    z=z+0.1;

    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
      Health_Points=int.parse(event.steps.toString());
      z=z+0.01;
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }
  @override
  Widget build(BuildContext context) {
    myLocalCtr mylocal=Get.find();
    double x=0;
    int k=0;
    setState(() {
      x = (Health_Points / 100) as double;
      z=z+0.1/50;
    });

    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(

          title: const Icon(Icons.directions_walk),
          leading:

          IconButton(icon: Icon(Icons.arrow_circle_down_sharp), onPressed: () async {

            SharedPreferences preferences=await SharedPreferences.getInstance();
          var username=preferences.get("name");
            print(username);

            db_config.add(x.toString(), username.toString());
            Fluttertoast.showToast(msg:"Saved",

                toastLength:
                Toast.LENGTH_SHORT,
                //gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,

                backgroundColor: Colors.white,
                textColor: Colors.deepOrange,

                fontSize: 16.0
            );

          },),
          actions: [
            Row(
              children: [
                IconButton(icon: Icon(Icons.filter_list_rounded),
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                          List_Data ()))

                    }
                ),


                Switch(value: mode, onChanged: (state){
                  setState(() {
                    mode=state;
                    mode?AdaptiveTheme.of(context).setLight():AdaptiveTheme.of(context).setDark();


                  });
                })
              ],
            )
          ],        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[


              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  LinearPercentIndicator(

                    animation: true,


                    lineHeight: 40,
                    animationDuration: 1000,
                    restartAnimation: true,
                    onAnimationEnd: (){
                      setState(() {
                        z=0.0;
                      });
                    },


                    percent: z     ,

                    animateFromLastPercent: true,

                    center: new Text("Step "+_steps.toString()),
                    progressColor: Colors.yellow,
                  )),
              // Text(
              //   _steps,
              //   style: TextStyle(fontSize: 60),
              // ),
              Divider(
                height: 10,
                thickness: 0,
                color: Colors.white,
              ),

              Divider(
                height: 30,
                thickness: 0,
                color: Colors.white,
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  CircularPercentIndicator(
                    animation: true,
                    animationDuration: 1000,
                    restartAnimation: true,
                    onAnimationEnd: (){
                      setState(() {
                        z=0.0;
                      });
                    },

                    radius: 100.0,
                    lineWidth: 20.0,
                    percent: z    ,
                    reverse: true,
                    animateFromLastPercent: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: new Text("Health Points  "+x.toString(),
                    style: TextStyle(fontSize: 15),
                    ),
                    progressColor: Colors.deepOrange,
                  )),

              Text(
                'Pedestrian status:',
                style: TextStyle(fontSize: 30),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                    ? Icons.accessibility_new
                    : Icons.error,
                size: 75,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? TextStyle(fontSize: 20)
                      : TextStyle(fontSize: 20, color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
