import 'dart:convert';

import 'package:dolan/data/api/request/ChatRequest.dart';
import 'package:dolan/data/model/Chat.dart';
import 'package:dolan/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final int jadwalId;
  final int userId;
  final String chatTitle;
  final ChatRequest apiRequest = ChatRequest();

  ChatPage({super.key, required this.chatTitle ,required this.jadwalId, required this.userId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Chat> listOfChat = [];
  final msgController = TextEditingController();
  var errorMsgVisibility = false;
  var errorMessage = [];
  String _txtchat = "";

  fetchData() async {
    final response = await widget.apiRequest.getPartyChat(widget.jadwalId);
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
        print("error $result");
      });
      return;
    }

    final listOfObject = result['data'] as List<dynamic>;
    listOfChat.clear();
    setState(() {
      for (int i = 0; i < listOfObject.length; i++) {
        listOfChat.add(Chat.fromJson(listOfObject[i]));
      }
    });
  }

  sendMessage(String message) async {
    final response = await widget.apiRequest.addPartyChat(
        widget.jadwalId, MyApp.preference.getUserName()!, message);
    var result = jsonDecode(response.body) as Map<String, dynamic>;
    print(result);

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
        print(result);
      });
      return;
    }
    fetchData();
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatTitle)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 64.0),
                child: ListView.builder(
                    itemCount: listOfChat.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              listOfChat[index].name ?? "undefined",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(listOfChat[index].message ?? "undefined"),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        "${DateFormat.yMd().format(listOfChat[index].createdAt!)} - ${DateFormat.jm().format(listOfChat[index].createdAt!)}",
                                        style: TextStyle(fontSize: 10)),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: msgController,
                        textInputAction: TextInputAction.send,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.chat),
                          labelText: 'Tuliskan Pesan',
                        ),
                        onFieldSubmitted: (value) {
                          sendMessage(value);
                          msgController.clear();
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
