import 'package:flutter/cupertino.dart';
import 'package:newpro/data/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class myLocal implements Translations{

  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys =>

      {
        "ar":{"1":"عدد الخطوات"},
        "en":{"1":"Step"},

        "ar":{"s":"عدد الخطوات"},
        "en":{"s":"Step"},

        "ar":{"2":"عدد النقاط الصحية"},
        "en":{"2":"Health Points"},






      };

}

String lang="";

class myLocalCtr extends GetxController {

  Locale _locale =lang=="ar"?Locale("ar"):Locale("en");


  Future<void> changeLong(String codeLang) async {
    Locale locale = Locale(codeLang);

lang=codeLang;



    Get.updateLocale(locale);
  }
}




