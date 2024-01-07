import 'dart:convert';

import 'package:dolan/data/model/detailjadwal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CariPage extends StatefulWidget {
  const CariPage({super.key});

  @override
  State<CariPage> createState() => _CariPageState();
}

class _CariPageState extends State<CariPage> {
  String _txtcari = "";

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://hybrid.anxdre.my.id/api/auth/carijadwal"),
        body: {'cari': _txtcari});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    // DJs.clear();
    // Future<String> data = fetchData();
    // data.then((value) {
    //   Map json = jsonDecode(value);
    //   for (var jadwal in json['data']) {
    //     DetailJadwal dj = DetailJadwal.fromJSON(jadwal);
    //     DJs.add(dj);
    //   }
    //   setState(() {
    //     for (var jadwal in json['data']) {
    //       DetailJadwal dj = DetailJadwal.fromJSON(jadwal);
    //       DJs.add(dj);
    //     }
    //   });
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bacaData();
  }

  Widget DaftarCariJadwal(DaftarJadwal) {
    if (DaftarJadwal != null) {
      return ListView.builder(
          itemCount: DaftarJadwal.length,
          itemBuilder: (BuildContext ctxt, int index) {
            int jumlahPemain = 0; // TODO::lenght of dolan
            return Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Image.network(
                    DaftarJadwal[index].foto,
                    width: 50, // Sesuaikan lebar gambar sesuai kebutuhan
                    height: 50, // Sesuaikan tinggi gambar sesuai kebutuhan
                    fit: BoxFit
                        .cover, // Sesuaikan jenis penyesuaian gambar sesuai kebutuhan
                  ),
                  // title:
                  //     GestureDetector(child: Text(DJs[index].informasiDolanan)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(DJs[index].tanggal),
                      // Text(DJs[index].jam),
                      // SizedBox(height: 4),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     // Action when the button is pressed
                      //   },
                      //   //ubah text button
                      //   child: Text(
                      //       '$jumlahPemain / ${DJs[index].jumlahPemain} orang'),
                      // ),
                      // Text(DJs[index].namaTempat),
                      // Text(DJs[index].alamat),
                      // SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          // Action when the button is pressed
                        },
                        child: Text('Join'),
                      ),
                    ],
                  ),
                ),
              ],
            ));
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          labelText: 'Cari...',
        ),
        onFieldSubmitted: (value) {
          setState(() {
            _txtcari = value;
          });
          // _txtcari = value;
          bacaData();
        },
      ),
      // Text(_temp)
      Container(
        height: MediaQuery.of(context).size.height - 200,
        // child: DaftarCariJadwal(DJs),
      )
    ]));
  }
}
