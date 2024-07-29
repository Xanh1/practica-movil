import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prueba_1/controllers/services.dart';
import 'package:prueba_1/controllers/util/session_util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController userControl = TextEditingController();
  final TextEditingController passControl = TextEditingController();

  void sendData() {
    FToast ftoast = FToast();
    ftoast.init(context);

    setState(() {
      if (_formKey.currentState!.validate()) {
        Map<String, String> json = {
          "username": userControl.text,
          "password": passControl.text
        };

        log(json.toString());

        var service = Services();

        service.session(json).then((data) async {
          if (data.code == '200') {
            var session = SessionUtil();

            session.add('dni', data.dni);
            session.add('name', data.name);
            session.add('lastName', data.lastName);
            session.add('uid', data.uid);

            Navigator.pushNamed(context, '/dashboard/products');
            
          } else {
            ftoast.showToast(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.amber.shade400,
                ),
                child: Text(data.context ?? 'Error desconocido'),
              ),
              gravity: ToastGravity.CENTER,
              toastDuration: const Duration(seconds: 2),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(40),
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 40),
              child: const Column(
                children: [
                  Icon(
                    Icons.store_mall_directory_outlined,
                    size: 40,
                    color: Colors.black,
                  ),
                  Text(
                    'Log in',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your usernane";
                  }
                  return null;
                },
                controller: userControl,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                obscureText: true,
                obscuringCharacter: "*",
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your password";
                  }
                  return null;
                },
                controller: passControl,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: sendData,
                child: const Text("Log in"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
