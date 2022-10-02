import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newpro/data/db_config.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:pedometer/pedometer.dart';
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
    return AdaptiveTheme(
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Adaptive Theme Demo',
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


  int h=0;
  @override
  void initState() {
    super.initState();


    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
      h=int.parse(event.steps.toString());
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
    double x=0;

   setState(() {
      x = (h / 100) as double;

   });

    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(

        title: const Icon(Icons.directions_walk),
        leading:

        IconButton(icon: Icon(Icons.save_alt_rounded), onPressed: () async {
          SharedPreferences preferences=await SharedPreferences.getInstance();
          var  username=   preferences.getString("name");
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
              Text(
                'Steps taken:',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                _steps,
                style: TextStyle(fontSize: 60),
              ),
              Divider(
                height: 10,
                thickness: 0,
                color: Colors.white,
              ),
              Text(
                'Health Points:',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                x.toString(),
                style: TextStyle(fontSize: 60),
              ),
              Divider(
                height: 30,
                thickness: 0,
                color: Colors.white,
              ),
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
                size: 100,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? TextStyle(fontSize: 30)
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
