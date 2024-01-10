import 'dart:convert';

import 'package:dolan/data/api/request/JadwalDataRequest.dart';
import 'package:dolan/data/model/UserParty.dart';
import 'package:dolan/data/model/detailjadwal.dart';
import 'package:dolan/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CariPage extends StatefulWidget {
  CariPage({super.key});

  final apiRequest = JadwalDataRequest();

  @override
  State<CariPage> createState() => _CariPageState();
}

class _CariPageState extends State<CariPage> {
  String _txtcari = "";
  List<DetailJadwal> listOfJadwal = [];
  var errorMsgVisibility = false;
  var errorMessage = [];

  fetchData() async {
    final response = await widget.apiRequest.searchJadwal(_txtcari);
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
      return;
    }
    listOfJadwal.clear();
    final listOfObject = result['data'] as List<dynamic>;
    for (int i = 0; i < listOfObject.length; i++) {
      listOfJadwal.add(DetailJadwal.fromJson(listOfObject[i]));
    }
  }

  joinParty(int jadwalId) async {
    print(jadwalId);
    final response = await widget.apiRequest
        .joinParty(jadwalId, MyApp.preference.getUserId() ?? 0);
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result['message'])));
      });
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('Sukses join party, silahkan cek di menu jadwalmu')));
  }

  Future<List<UserParty>> fetchUserParty(int jadwalId) async {
    List<UserParty> userParty = [];
    final response = await widget.apiRequest.getUserParty(jadwalId);
    var result = jsonDecode(response.body) as Map<String, dynamic>;

    final listOfObject = result['data'] as List<dynamic>;
    print(listOfObject);
    for (int i = 0; i < listOfObject.length; i++) {
      userParty.add(UserParty.fromJson(listOfObject[i]));
    }
    return userParty;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  labelText: 'Cari...',
                ),
                onFieldSubmitted: (value) {
                  setState(() {
                    _txtcari = value;
                  });
                  fetchData();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: ListView.builder(
                      itemCount: listOfJadwal.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child: Column(
                          children: <Widget>[
                            ListTile(
                              title: GestureDetector(
                                  child: Text(
                                listOfJadwal[index].dolanan?.name ?? "Undefined",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                        "https://goodstats.id/img/articles/original/2023/11/08/perkembangan-industri-game-dunia-48-pemainnya-berasal-dari-asia-pasifik-aPU9ZMbhO7.jpg?p=articles-lg"),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          "Tanggal : ${DateFormat.yMd().format(listOfJadwal[index].tanggal!)}"),
                                    ),
                                    Text("Jam : ${listOfJadwal[index].jam?.replaceRange(5, 8, "")}"),
                                    ElevatedButton(
                                      onPressed: () {
                                        var data = fetchUserParty(
                                            listOfJadwal[index].id!);
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: SizedBox(
                                                height: MediaQuery.of(context).size.height * 0.5,
                                                child: Column(
                                                  children: [
                                                    FutureBuilder(
                                                        future: data,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            return SingleChildScrollView(child: Padding(
                                                              padding: const EdgeInsets.all(16.0),
                                                              child: Column(
                                                                children: [
                                                                  for (var value in snapshot.data!)
                                                                    Card(child:ListTile(
                                                                      leading:FlutterLogo(),
                                                                      title: Text('${value.name}'),
                                                                    ))
                                                                ],
                                                              ),
                                                            ),
                                                            );
                                                          }else{
                                                            return Text("loading ...");
                                                          }
                                                        })
                                                  ],
                                                ),
                                              ),
                                            ));
                                      },
                                      //ubah text button
                                      child: Text(
                                        'Lihat Pemain',
                                      ),
                                    ),
                                    Text("Lokasi : ${listOfJadwal[index].lokasi}" ??
                                        ""),
                                    Text(
                                        "Alamat Lokasi : ${listOfJadwal[index].alamat}" ??
                                            ""),
                                    SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      child: FilledButton(
                                        onPressed: () {
                                          joinParty(listOfJadwal[index].id ?? 0);
                                        },
                                        child: Text('Join'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ));
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
