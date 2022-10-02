import 'package:newpro/data/sqllite/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
SqlDb sqlDb=new SqlDb();

class db_config{

static  getperf(
      String name,

      )async  {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setString("name", name);


  }



static  saveperf(String username)async  {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setString("name", username);
    print(sharedPreferences.get("name"));

  }

static  Future<List<Map>> getdata () async{

    List<Map> result= await sqlDb.readData("SELECT *FROM steps");
    print("$result");
    return result;
  }

static add(String Step,String name) async {

  int response=await sqlDb.insertData(
      "INSERT INTO `steps` ('name','steps','dete') VALUES"
          "('"+name+"','"+Step+"','"+DateTime.now().toString()+"')");


}
}