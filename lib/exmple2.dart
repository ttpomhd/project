import 'package:flutter/material.dart';
import 'package:newpro/data/db_config.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:pedometer/pedometer.dart';
class MyList extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final VoidCallback onChanged;

  const MyList({
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
      x = (h / 100) as double;
    });

    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: Theme.of(context),
      child: Scaffold( appBar: AppBar(

        title: const Icon(Icons.directions_walk),
        leading:

        IconButton(icon: Icon(Icons.arrow_circle_down_sharp), onPressed: () { db_config.add(x.toString(), "name");
        },),
        actions: [
          Row(
            children: [


              IconButton(icon: Icon(Icons.filter_list_rounded),
                onPressed: () => (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                      MyList(onChanged:          () => setState(() => mode= true))));

                },
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

        body:
        Container(
            padding: EdgeInsets.all(10.0),
            constraints: BoxConstraints.expand(),
            child:    FutureBuilder(
                future: db_config.getdata(),
                builder:(BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context,i) {
                          return ListTile(
                            title: Text("Health Points"+"  "+snapshot.data![i]['steps'].toString()),
                            subtitle: Text("  Dete"+" "+snapshot.data![i]['dete'].toString()),
                            //  leading: Text(snapshot.data![i]['dete'].toString()),
                          );

                        }
                    );

                  }

                  else
                    return CircularProgressIndicator();
                }
            )
        ),
      ),
    );
  }
}