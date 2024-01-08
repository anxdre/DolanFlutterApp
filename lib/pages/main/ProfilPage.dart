import 'dart:convert';

import 'package:dolan/data/api/request/UserDataRequest.dart';
import 'package:dolan/data/model/User.dart';
import 'package:dolan/main.dart';
import 'package:dolan/pages/auth/LoginPage.dart';
import 'package:dolan/services/UserPreference.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  ProfilPage({super.key});

  late UserPreference preference;

  final UserDataRequest apiRequest = UserDataRequest();

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
//ini diganti menjadi isian sebelumnya (tidak kosong)
  String _photoUrl =
      UserPreference.instance.getString(UserPreference.photoKey) ?? "";
  String _nama =
      UserPreference.instance.getString(UserPreference.nameKey) ?? "";

  //email nanti diganti menjadi tidak dapat diedit
  String _email =
      UserPreference.instance.getString(UserPreference.emailKey) ?? "";

  String _password = "";

  // Controller untuk mengelola input nama
  TextEditingController _nameController = TextEditingController();

  //initialization
  var errorMsgVisibility = false;
  var errorMessage = [];

  //method
  saveUser() async {
    var user = User.create(widget.preference.getUserId(), _nameController.text,
        widget.preference.getUserEmail(), _photoUrl);

    final response = await widget.apiRequest.updateUser(user, _password);
    var result = jsonDecode(response.body) as Map<String, dynamic>;

    try {
      setState(() {
        errorMsgVisibility = false;
        errorMessage.clear();
      });
    } catch (e) {
      return;
    }

    if (response.statusCode != 200) {
      setState(() {
        errorMessage.add(result['message']);
        errorMsgVisibility = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result['message'])));
      return;
    }

    widget.preference.storeEmail(user.email!);
    widget.preference.storeUserPhoto(user.photoUrl!);
    widget.preference.storeUserName(user.name!);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Sukses menyimpan data')));
    return;
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = _nama;
  }

  @override
  Widget build(BuildContext context) {
    widget.preference = UserPreference(UserPreference.instance);
    print(widget.preference.getUserId());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Menampilkan gambar profil
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_photoUrl),
              ),
              SizedBox(height: 10),

              // Input untuk mengubah nama
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                ),
              ),
              SizedBox(height: 5),

              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                readOnly: true, // Membuat input tidak dapat diedit
                enabled: false, // Membuat input tidak dapat diaktifkan
              ),
              SizedBox(height: 5),

              TextFormField(
                initialValue: _photoUrl,
                decoration: InputDecoration(
                  labelText: 'Photo URL',
                ),
                onChanged: (value) {
                  _photoUrl = value;
                },
              ),
              TextFormField(
                initialValue: _password,
                decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password baru'
                ),
                onChanged: (value) {
                  _password = value;
                },
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: ElevatedButton(
                    onPressed: () {
                      saveUser();
                    },
                    child: Text('Simpan'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: FilledButton(
                    onPressed: () {
                      widget.preference.removeUser();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                              (Route<dynamic> route) => false);
                    },
                    child: Text('Logout'),
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
