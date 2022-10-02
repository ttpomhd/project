import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:newpro/data/db_config.dart';
import 'package:newpro/example.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custombuttonauth.dart';
import 'customtextformauth.dart';
class MyStart extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final VoidCallback onChanged;

  const MyStart({
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
        title: 'Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        home: start(onChanged: onChanged),
      ),
    );
  }
}

class start extends StatefulWidget {

  final VoidCallback onChanged;

  const start({super.key, required this.onChanged});

  @override
  _startState createState() => _startState();
}

class _startState extends State<start> {
  TextEditingController name=new TextEditingController();
bool mode=true;
  @override
  Widget build(BuildContext context) {

go(context);
    return AnimatedTheme(
        duration: const Duration(milliseconds: 300),
    data: Theme.of(context),
    child:
    Scaffold(
      appBar: AppBar(

        title: const Icon(Icons.directions_walk),
        actions: [
          Row(
            children: [



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
    Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: CustomTextFormAuth(hinttext: 'You  Name',
    labeltext: '',
    iconData: Icons.perm_contact_cal, mycontroller: name,
    isNumber:false,),
    ),

    Padding(
    padding: const EdgeInsets.all(8.0),
    child: CustomButtomAuth(text: 'GO',onPressed:
    ()
    //if(li)
        {
    db_config.saveperf(name.text);


    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
        MyHome(
        onChanged: () => setState(() => mode = false))
          )
    );

    }
    )

    )
    ],
    ),

    )
    );
  }
}
go(BuildContext context) async{
  SharedPreferences preferences=await SharedPreferences.getInstance();
  var  username=   preferences.getString("name");
  if(username!= null) {

    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
        MyHome(
            onChanged: () =>  mode=false)
    ));

    print(username);
  }
  else
  {}
}

