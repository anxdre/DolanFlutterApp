import 'dart:convert';

import 'package:dolan/data/model/Dolanan.dart';
import 'package:dolan/main.dart';
import 'package:dolan/services/DolanItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class BuatJadwalPage extends StatefulWidget {
  final int? userId = MyApp.userId;

  BuatJadwalPage({super.key});

  @override
  State<BuatJadwalPage> createState() => _BuatJadwalPageState();
}

class _BuatJadwalPageState extends State<BuatJadwalPage> {
  final _formKey = GlobalKey<FormState>();
  String _lokasi = "";
  String _alamat = "";
  Dolanan? _dolanan = null;

  final _controllerDate = TextEditingController();
  DateTime? _dateValue = null;

  final _controllerTime = TextEditingController();
  TimeOfDay? _timeValue = null;

  void submit() async {
    print(widget.userId.toString());
    print(_dolanan?.id ?? 1);
    final response = await http
        .post(Uri.parse("https://dolanan.anxdre.my.id/api/jadwal/add"), body: {
      'tanggal': _dateValue.toString(),
      'jam': "${_timeValue?.hour}:${_timeValue?.minute}",
      'lokasi': _lokasi,
      'alamat': _alamat,
      'dolanan_id': _dolanan?.id.toString(),
      'users_id': widget.userId.toString(),
    });

    var json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sukses Menambah Jadwal Baru')));

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        SystemNavigator.pop();
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(json['message'])));
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Buat Jadwal"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text('Bikin jadwal dolanmu yuk!'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField(
                        hint: Text("Pilih dolanan"),
                        items: <DropdownMenuItem<Dolanan>>[
                          for (var value in listOfDolanType)
                            DropdownMenuItem(
                              value: value,
                              child: Text(value.name ?? ""),
                            ),
                        ],
                        onChanged: (value) {
                          _dolanan = value;
                          print(_dolanan);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Tipe permainan harus diisi';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Tanggal Dolan',
                              ),
                              controller: _controllerDate,
                            )),
                            ElevatedButton(
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2200))
                                      .then((value) {
                                    _dateValue = value;
                                    print(value);
                                    setState(() {
                                      _controllerDate.text =
                                          value.toString().substring(0, 10);
                                    });
                                  });
                                },
                                child: Icon(
                                  Icons.calendar_today_sharp,
                                  color: Colors.black,
                                  size: 24.0,
                                ))
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Jam Dolan',
                              ),
                              controller: _controllerTime,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                _timeValue = value;
                                print(value);
                                setState(() {
                                  if (value != null) {
                                    _controllerTime.text =
                                        value.format(context).toString();
                                  }
                                });
                              });
                            },
                            child: Icon(
                              Icons.access_time,
                              color: Colors.black,
                              size: 24.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Lokasi Dolan',
                          ),
                          onChanged: (value) {
                            _lokasi = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lokasi harus diisi';
                            }
                            return null;
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Alamat Dolan',
                          ),
                          onChanged: (value) {
                            _alamat = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Alamat harus diisi';
                            }
                            return null;
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState != null &&
                              !_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Harap Isian diperbaiki')));
                          } else {
                            submit();
                          }
                        },
                        child: Text('Buat Jadwal'),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
