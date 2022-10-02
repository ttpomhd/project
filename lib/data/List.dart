import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:newpro/data/db_config.dart';

import '../example.dart';
class List_Data extends StatefulWidget {
  const List_Data({Key? key}) : super(key: key);

  @override
  _List_DataState createState() => _List_DataState();
}

class _List_DataState extends State<List_Data> {
  bool mode=false;
  @override

  Widget build(BuildContext context) {

    return new Scaffold(

      appBar: AppBar(


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
      FutureBuilder(
          future: db_config.getdata(),
          builder:(BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,

                  shrinkWrap: true,
                  itemBuilder: (context,i) {
                    return ListTile(
                      title: Text("Health Points"+"  "+snapshot.data![i]['steps'].toString()),
                      subtitle: Text("  Dete"+" "+snapshot.data![i]['dete'].toString()),
                      leading: Text(snapshot.data![i]['name'].toString()),
                    );

                  }
              );

            }

            else
              return CircularProgressIndicator();
          }
      )


    );
  }
}













