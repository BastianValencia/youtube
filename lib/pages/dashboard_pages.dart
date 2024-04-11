import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_youtube/pages/login_pages.dart';
import 'package:push_youtube/preferences/pref_usuarios.dart';
import 'package:push_youtube/services/bloc/notifications_bloc.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  static const String routename = 'dashboard';
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  final _auth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    context.read<NotificationsBloc>().requestPermission();
    var prefs = PreferenciasUsuario();
    print('TOKEN: '+prefs.token);
    prefs.ultimaPagina = 'dashboard';
    prefs.ultimouid =  _auth!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard!'),
        actions: [
          IconButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            // ignore: use_build_context_synchronously
            Navigator.popAndPushNamed(context, LoginPage.routename);
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('user').doc(prefs.ultimouid).get(),        
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator());
            }else{
              // print(snapshot);
              // ignore: no_leading_underscores_for_local_identifiers
              final _data = snapshot.data.data();
              if(_data!.isNotEmpty){
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_data['email']),
                      SizedBox(height: 200,),
                      
                      ElevatedButton(onPressed: (){
                          try {
                              http.post(
                                Uri.parse('API URL BACKEND'),
                                headers: {
                                  "Content-type":"application/json"
                                },
                                body: jsonEncode({
                                  "token":["YOU TOKEN PHONE"],
                                  "data":{
                                    "title":"Notificacion desde la nube",
                                    "body":"Mensaje desde el dispositivo"
                                  }
                                })
                              );
                          // ignore: empty_catches
                          } catch (e) {
                            
                          }
                      }, 
                      child: const Text('Enviar Push'))
                    ],
                  ),
                );
              }else{
                return Container();
              }
            }
          },
        ),
      ),
    );

  }
}
