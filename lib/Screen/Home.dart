import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:newpro/data/List.dart';
import 'package:newpro/data/db_config.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
class MyHome2 extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final VoidCallback onChanged;

  const MyHome2({
  super.key,
  this.savedThemeMode,
  required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAdaptiveTheme(
      light: const CupertinoThemeData(brightness: Brightness.light),
      dark: const CupertinoThemeData(brightness: Brightness.dark),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme) => CupertinoApp(
        title: 'Adaptive Theme Demo',
        theme: theme,
        home: Home(onChanged: onChanged),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final VoidCallback onChanged;

  const Home({super.key, required this.onChanged});


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
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
      x=(h/100) as double;

    });
    return
      Scaffold(
        appBar: AppBar(

          title: const Icon(Icons.directions_walk),
          leading:

          IconButton(icon: Icon(Icons.arrow_circle_down_sharp), onPressed: () { db_config.add(x.toString(), "name");
          },),
          actions: [
            Row(
              children: [


                IconButton(icon: Icon(Icons.filter_list_rounded),
                  onPressed: () => AdaptiveTheme.of(context).setDark(),
                ),

                IconButton(icon: Icon(Icons.filter_list_rounded),
                  onPressed: () => AdaptiveTheme.of(context).setLight(),
                ),

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
                'Steps taken:',
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
      );
  }
}
