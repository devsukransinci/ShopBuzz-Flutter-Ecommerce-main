import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopbuzz_ecommerce/main.dart';
import 'package:shopbuzz_ecommerce/pages/login.dart';
import 'package:shopbuzz_ecommerce/pages/user_form.dart';
import 'package:shopbuzz_ecommerce/services/form_validator.dart';
import 'package:shopbuzz_ecommerce/services/screen_navigation.dart';
import 'package:shopbuzz_ecommerce/widgets/custome_scafold_message.dart';
import 'package:shopbuzz_ecommerce/widgets/custome_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _cPpassCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  _registerWithEmail() async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: _emailCtrl.text,
        password: _cPpassCtrl.text,
      );
      CustomeScafoldMessage(isWarning: false)
          .showCustomeMessages(context, 'Register is done');

      var authCredintial = userCredential.user;
      print(authCredintial!.uid);

      if (authCredintial.uid.isNotEmpty) {
        navigateToNextSceen(context, UserForm());
      } else {
        CustomeScafoldMessage(isWarning: true)
            .showCustomeMessages(context, 'Something is wrong');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        CustomeScafoldMessage(isWarning: true).showCustomeMessages(
            context, 'The account already exists for that email.');
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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Register",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    CustomeTextField(
                      controller: _nameCtrl,
                      labelText: "Name",
                      prefixIcon: Icon(Icons.person),
                    ),
                    CustomeTextField(
                      prefixIcon: Icon(Icons.email),
                      controller: _emailCtrl,
                      labelText: "Email",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter your E-mail";
                        } else if (!validateEmail(value)) {
                          return "E-mail is not valid";
                        }
                        return null;
                      },
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
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter your password";
                        } else if (val.length < 6) {
                          return "Weak Password";
                        }
                        return null;
                      },
                    ),
                    CustomeTextField(
                      controller: _cPpassCtrl,
                      labelText: "Confirm-Password",
                      prefixIcon: Icon(Icons.lock),
                      obscureText: !isShowPassword,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter your password";
                        } else if (val != _passCtrl.text) {
                          return "Password isn't Matched";
                        }
                        return null;
                      },
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
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (validateAndSave(_formKey)) {
                            _registerWithEmail();
                          }
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                    SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already Have an Acount?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.black),
                        ),
                        InkWell(
                          onTap: () {
                            navigateToNextSceen(context, LoginScreen());
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.double),
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
