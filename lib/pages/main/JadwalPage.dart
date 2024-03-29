import 'dart:convert';

import 'package:dolan/data/api/request/JadwalDataRequest.dart';
import 'package:dolan/data/model/DetailJadwal.dart';
import 'package:dolan/data/model/UserParty.dart';
import 'package:dolan/main.dart';
import 'package:dolan/pages/chat/ChatPage.dart';
import 'package:dolan/pages/main/BuatJadwalPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JadwalPage extends StatefulWidget {
  JadwalPage({super.key});

  final JadwalDataRequest apiRequest = JadwalDataRequest();

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> with WidgetsBindingObserver {
  List<DetailJadwal> listOfJadwal = [];
  var errorMsgVisibility = false;
  var errorMessage = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchData();
    }
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

  fetchData() async {
    final response =
        await widget.apiRequest.getAllJadwal(MyApp.preference.getUserId() ?? 0);
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

    final listOfObject = result['data'] as List<dynamic>;
    for (int i = 0; i < listOfObject.length; i++) {
      listOfJadwal.add(DetailJadwal.fromJson(listOfObject[i]));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 200.0),
                  child: listOfJadwal.isEmpty
                  ? Center(
                      child: Text(
                        "Jadwal main masih kosong nih, Cari konco main atau bikin jadwal baru aja",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: listOfJadwal.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child: Column(
                          children: <Widget>[
                            ListTile(
                              title: GestureDetector(
                                  child: Text(
                                listOfJadwal[index].dolanan?.name ??
                                    "Undefined",
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
                                          "Tanggal ; ${DateFormat.yMd().format(listOfJadwal[index].tanggal!)}"),
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
                                    Text(
                                        "Lokasi : ${listOfJadwal[index].lokasi}" ??
                                            ""),
                                    Text(
                                        "Alamat Lokasi : ${listOfJadwal[index].alamat}" ??
                                            ""),
                                    SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      child: FilledButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                  chatTitle: listOfJadwal[index]
                                                          .dolanan
                                                          ?.name ??
                                                      "",
                                                  jadwalId:
                                                      listOfJadwal[index].id!,
                                                  userId: MyApp.preference
                                                      .getUserId()!),
                                            ),
                                          ).onError((error, stackTrace) =>
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Maaf terjadi kesalahan'))));
                                        },
                                        child: Text('Party Chat'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ));
                      }),
                )),
          ],
        ),
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
