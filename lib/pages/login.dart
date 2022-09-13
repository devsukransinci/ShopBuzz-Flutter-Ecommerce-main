import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopbuzz_ecommerce/main.dart';
import 'package:shopbuzz_ecommerce/pages/bottom_nav_controller.dart';
import 'package:shopbuzz_ecommerce/pages/register.dart';
import 'package:shopbuzz_ecommerce/services/screen_navigation.dart';
import 'package:shopbuzz_ecommerce/widgets/custome_scafold_message.dart';
import 'package:shopbuzz_ecommerce/widgets/custome_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  bool isShowPassword = false;
  passwordVisibility() {
    setState(() {
      isShowPassword = true;
    });
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        isShowPassword = false;
      });
    });
  }

  _signIn() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: _emailCtrl.text,
        password: _passCtrl.text,
      );
      var authCredintial = userCredential.user;
      print(authCredintial!.uid.isEmpty);
      

      if (authCredintial.uid.isNotEmpty) {
        navigateToNextSceen(context, BottomNavController());
      } else {
        CustomeScafoldMessage(isWarning: true)
            .showCustomeMessages(context, 'Something is wrong');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CustomeScafoldMessage(isWarning: true)
            .showCustomeMessages(context, 'No user found for that email.');
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        CustomeScafoldMessage(isWarning: true).showCustomeMessages(
            context, 'Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff88C424),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SizedBox(
            height: _height,
            width: _width,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    CustomeTextField(
                      controller: _emailCtrl,
                      labelText: "E-mail",
                      prefixIcon: Icon(Icons.email),
                    ),
                    CustomeTextField(
                      controller: _passCtrl,
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      obscureText: !isShowPassword,
                      suffixIcon: IconButton(
                          onPressed: () {
                            passwordVisibility();
                          },
                          icon: isShowPassword
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          // print("Forget Password?");
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: const Text(
                            "Forget Password?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.double),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 26.0,
                    ),
                    ElevatedButton(
                        onPressed: () {  
                          _signIn();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                    SizedBox(
                      height: 50.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Not Register Yet?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.black),
                        ),
                        InkWell(
                          onTap: () {
                            navigateToNextSceen(context, RegisterScreen());
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
