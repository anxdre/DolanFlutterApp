import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BuatJadwalPage extends StatefulWidget {
  const BuatJadwalPage({super.key});

  @override
  State<BuatJadwalPage> createState() => _BuatJadwalPageState();
}

class _BuatJadwalPageState extends State<BuatJadwalPage> {

  final _formKey = GlobalKey<FormState>();
  String _lokasi = "";
  String _alamat = "";
  String _dolanutama ="";
  int _minimalmember = 0;
  
final _controllerDate = TextEditingController();
final _controllerTime = TextEditingController();

void submit() async {
    final response = await http
        .post(Uri.parse("https://hybrid.anxdre.my.id/api/auth/buatjadwal"), body: {
      'tanggal': _controllerDate.text,
      'jam': _controllerTime.text,
      'lokasi': _lokasi,
      'alamat': _controllerDate.text,
      'dolanutama': _dolanutama,
      'minimalmember': _minimalmember.toString(),
    });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Jadwal Baru')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          title: Text("Buat Jadwal"),
        ),
         body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text('Bikin jadwal dolanmu yuk!'),
               Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                mainAxisAlignment:MainAxisAlignment.start,
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

                  
              //  Padding(
              //       padding: EdgeInsets.all(10),
              //       child: DropdownButtonFormField<String>(
              //         decoration: InputDecoration(
              //           labelText: 'Dolan Utama',
              //         ),
              //         value: _selectedDolan,
              //         items: _dolanList.map((dolan) {
              //           return DropdownMenuItem<String>(
              //             value: dolan,
              //             child: Text(dolan),
              //           );
              //         }).toList(),
              //         onChanged: (value) {
              //           setState(() {
              //             _selectedDolan = value;
              //           });
              //         },
              //         validator: (value) {
              //           if (value == null || value.isEmpty) {
              //             return 'Pilih Dolan Utama';
              //           }
              //           return null;
              //         },
              //       ),
              //     ),

              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Minimal Member',
                    ),
                    onChanged: (value) {
                      _minimalmember = int.parse(value);
                    },
                   
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Minimal member harus diisi';
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
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Harap Isian diperbaiki')));
                      }
                      else{
                        submit();
                      }
                    },
                    child: Text('Buat Jadwal'),
                  ),
                ),

              
             
              ],
          ))
    );
  }
}
