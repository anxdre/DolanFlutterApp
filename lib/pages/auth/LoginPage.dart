import 'dart:convert';
import 'dart:ffi';

import 'package:dolan/data/api/request/UserDataRequest.dart';
import 'package:dolan/data/model/User.dart';
import 'package:dolan/main.dart';
import 'package:dolan/pages/auth/RegisterPage.dart';
import 'package:dolan/pages/main/CariPage.dart';
import 'package:dolan/pages/main/JadwalPage.dart';
import 'package:dolan/pages/main/home.dart';
import 'package:dolan/services/UserPreference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  LoginPage({super.key});

  final UserDataRequest apiRequest = UserDataRequest();
  late final SharedPreferences _prefs;
  late final _prefsFuture = SharedPreferences.getInstance().then((v) => _prefs = v);

  var errorMessage = [];

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  //initialization
  var errorMsgVisibility = false;
  var errorMessage = [];
  String email = "";
  String password = "";
  //method
  loginUser(String email, String password) async {
    final response = await widget.apiRequest.loginUser(email, password);
    var result = jsonDecode(response.body) as Map<String,dynamic>;

    try{ setState(() {
      errorMsgVisibility = false;
      errorMessage.clear();
    });
    }catch(e){
      return;
    }

    if (response.statusCode != 200) {
      setState(() {
        errorMessage.add(result['message']);
        errorMsgVisibility = true;
      });
      return;
    }
    storeUserToPreference(User.fromJson(result['user']));
    return;
  }

  storeUserToPreference(User data) {
    final pref = UserPreference(widget._prefs);
    pref.storeUserId(data.id as int);
    pref.storeUserName(data.name ?? "");
    pref.storeUserPhoto(data.photoUrl ?? "");
  }

  checkUserWasLoggedIn()  {
    final pref = UserPreference(widget._prefs);

    if (pref.getUserId() != null && pref.getUserId() != 0){
      MyApp.userId = pref.getUserId();
      print(MyApp.userId);
      print(pref.getUserId());
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>  const Home(),
          ),
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: FutureBuilder(
        future: widget._prefsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              checkUserWasLoggedIn();
              return  Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (text){email = text;},
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          obscureText: true,
                          onChanged: (text){password = text;},
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: FilledButton(
                                  onPressed: () async {
                                    loginUser(email, password);
                                    checkUserWasLoggedIn();
                                  },
                                  child: const Text('Login')))),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          alignment: Alignment.center,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => RegisterPage(),
                                      ),
                                    );
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
              );
            }
            // `_prefs` is not ready yet, show loading bar till then.
            return const CircularProgressIndicator();
          }
      ),
    );
  }
}
