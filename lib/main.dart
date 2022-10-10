import 'package:fit_map/pages/home_page.dart';
import 'package:flutter/material.dart';



const String accessToken = String.fromEnvironment("ACCESS_TOKEN");


void main() async {


  runApp(MaterialApp(home: HomePage(),));
}
