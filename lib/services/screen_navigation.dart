import 'package:flutter/material.dart';

navigateToNextSceen(BuildContext context, Widget nextScreen){
   Navigator.push( context,
                              MaterialPageRoute(
                                  builder: (BuildContext) => nextScreen));
}