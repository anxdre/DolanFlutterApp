import 'dart:convert';

import 'package:flutter/material.dart';

import '../../data/api/request/UserDataRequest.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  final UserDataRequest apiRequest = UserDataRequest();

  var errorMessage = [];

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //initialization
  var errorMsgVisibility = false;
  var errorMessage = [];
  String email = "";
  String name = "";
  String password = "";
  String validatePassword = "";

  //method
  Future<bool> registerUser(String email, String password, String name) async {
    final response =
        await widget.apiRequest.registerUser(email, name, password);
    var result = jsonDecode(response.body) as Map<String, dynamic>;

    setState(() {
      errorMsgVisibility = false;
      errorMessage.clear();
    });

    if (response.statusCode != 200) {
      setState(() {
        errorMessage.add(result['message']);
        errorMsgVisibility = true;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (text) {
                    email = text;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (text) {
                    name = text;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (text) {
                    password = text;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (text) {
                    validatePassword = text;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Re-Type Password',
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FilledButton(
                          onPressed: () {
                            if (password != validatePassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Password are not equal")));
                              return;
                            }

                            registerUser(email, password, name)
                                .then((value) => {
                                      if (value){
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Register Success, please back to login page")))
                                        }
                                    });
                          },
                          child: const Text('Register')))),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                alignment: Alignment.center,
                child: Visibility(
                  visible: errorMsgVisibility,
                  child: Text(
                    errorMessage.join(),
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
