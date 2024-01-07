import 'dart:convert';


import 'package:dolan/data/model/detailjadwal.dart';
import 'package:dolan/pages/main/BuatJadwalPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  DetailJadwal? _dj;

  @override
  void initState() {
    super.initState();
    bacaData();
  }


  Future<String> fetchData() async {
    final response = await http
      .post(Uri.parse("https://hybrid.anxdre.my.id/api/auth/jadwal")
    );
    if (response.statusCode == 200) {
    return response.body;
    } else {
    throw Exception('Failed to read API');
    }
  }

 bacaData() {
    DJs.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var jadwal in json['data']) {
        DetailJadwal dj = DetailJadwal.fromJSON(jadwal);
        DJs.add(dj);
      }
      setState(() {
        // _temp = PMs[2].overview;
        for (var jadwal in json['data']) {
          DetailJadwal dj = DetailJadwal.fromJSON(jadwal);
          DJs.add(dj);
        }
      });
    });
  }

  

Widget DaftarJadwal(DaftarJadwal) {
    if (DaftarJadwal != null) {
      return ListView.builder(
          itemCount: DaftarJadwal.length,
          itemBuilder: (BuildContext ctxt, int index) {
            int jumlahPemain = DJs[index].pemain.length;
            return Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Image.network(
                      DaftarJadwal[index].foto,
                      width: 50, // Sesuaikan lebar gambar sesuai kebutuhan
                      height: 50, // Sesuaikan tinggi gambar sesuai kebutuhan
                      fit: BoxFit.cover, // Sesuaikan jenis penyesuaian gambar sesuai kebutuhan
                    ),
                  
                  title: GestureDetector(
                      child: Text(DJs[index].informasiDolanan)),
        
                   subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DJs[index].tanggal),
                        Text(DJs[index].jam),
                        SizedBox(height: 4),
                        ElevatedButton(
                          onPressed: () {
                            // Action when the button is pressed


                          },
                          //ubah text button
                          child: Text('$jumlahPemain / ${DJs[index].jumlahPemain} orang'),

                        ),


                        Text(DJs[index].namaTempat),
                        Text(DJs[index].alamat),
                       
                    
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () {
                            // Action when the button is pressed


                          },
                          child: Text('Party Chat'),
                        ),
                      ],
                    ),
                ),
              ],
            ));
          });
    } else {
      return Center(
        child: Text('Jadwal main masih kosong nih. Cari konco main atau bikin jadwal baru aja'),
      );
    }
  }


 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: ListView(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height - 200,
          child: DaftarJadwal(DJs),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BuatJadwalPage()),
        );
   
      },
      child: Icon(Icons.create_outlined),
    ),
  );
}

}
