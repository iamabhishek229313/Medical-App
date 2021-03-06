import 'package:flutter/material.dart';
import 'package:medical_app/Models/User.dart';
import 'package:provider/provider.dart';

import 'Screens/HomePage.dart';
import 'Screens/LogInPage.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context) ;
    print(user);
    if(user == null){
      return LogInPage();
    }else{
      return HomePage();
    }
  }
}