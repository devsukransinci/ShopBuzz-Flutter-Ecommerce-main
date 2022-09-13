import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopbuzz_ecommerce/const/app_color.dart';
import 'package:shopbuzz_ecommerce/pages/bottom_nav_controller.dart';
import 'package:shopbuzz_ecommerce/services/screen_navigation.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }

  sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users form data");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
          "Name": _nameController.text,
          "Phone": _phoneController.text,
          "DoB": _dobController.text,
          "Gender": _genderController.text,
          "Age": _ageController.text,
        })
        .then((value) => navigateToNextSceen(context, BottomNavController()))
        .catchError((error) => print("something is wrong"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Submit the form to continue.",
                    style: TextStyle(
                        fontSize: 22.0, color: AppColors.green_accent),
                  ),
                  Text(
                    "We will not share your information with anyone.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFBBBBBB),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),

                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Enter Your Name"),
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _phoneController,
                    decoration:
                        InputDecoration(hintText: "Enter Your Phone Number"),
                  ),

                  TextField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "date of birth",
                      suffixIcon: IconButton(
                        onPressed: () => _selectDateFromPicker(context),
                        icon: Icon(Icons.calendar_today_outlined),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _genderController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "choose your gender",
                      prefixIcon: DropdownButton<String>(
                        items: gender.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                            onTap: () {
                              setState(() {
                                _genderController.text = value;
                              });
                            },
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _ageController,
                    decoration: InputDecoration(hintText: "Enter Your Age"),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          sendUserDataToDB();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff88C424),
                            onPrimary: Colors.black),
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                  )

                  // elevated button
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
