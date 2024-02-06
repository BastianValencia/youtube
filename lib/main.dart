import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:push_youtube/firebase_options.dart';
import 'package:push_youtube/pages/dashboard_pages.dart';
import 'package:push_youtube/pages/login_pages.dart';
import 'package:push_youtube/pages/registro_pages.dart';
import 'package:push_youtube/preferences/pref_usuarios.dart';
import 'package:push_youtube/services/bloc/notifications_bloc.dart';
import 'package:push_youtube/services/localNotification/local_notification.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenciasUsuario.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await LocalNotification.initializeLocalNotifications();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotificationsBloc()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: prefs.ultimaPagina,
      routes: {
        LoginPage.routename       :(context) => const LoginPage(),
        RegistroPages.routename   :(context) => const RegistroPages(),
        DashboardPage.routename   :(context) => const DashboardPage()
      },
    );
  }
}