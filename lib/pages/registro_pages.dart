// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:push_youtube/pages/dashboard_pages.dart';
import 'package:push_youtube/pages/login_pages.dart';
import 'package:push_youtube/preferences/pref_usuarios.dart';
import 'package:push_youtube/util/snackbar.dart';
import 'package:push_youtube/provider/auth.dart';

class RegistroPages extends StatefulWidget {
  static const String routename = 'registro';
  const RegistroPages({super.key});
  @override
  State<RegistroPages> createState() => _RegistroPagesState();
}

class _RegistroPagesState extends State<RegistroPages> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    // var prefs = PreferenciasUsuario();

    final size = MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Container(
              width: double.infinity,
              height: size.height,
              color: const Color(0xfff7f7f7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/logos_transparent.png', scale: 4,),
                  const Center(child: Text('Registro!', style: TextStyle(fontSize: 20),),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'user',
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue.shade900),
                                borderRadius: BorderRadius.circular(50)),
                            prefixIcon:  Icon(
                              Icons.account_circle_outlined,
                              color: Colors.blue.shade900,
                            ),
                            labelText: 'Usuario',
                            labelStyle: const TextStyle(fontSize: 13),
                            hintText: 'Ejemplo@email.com'),
                        keyboardType: TextInputType.emailAddress,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: 'Usuario requerido'),
                          FormBuilderValidators.email(
                              errorText: 'Debe ingresar un Correo valido')
                        ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormBuilderTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'pass',
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue.shade900,),
                                borderRadius: BorderRadius.circular(50)),
                            prefixIcon: Icon(
                              Icons.account_circle_outlined,
                              color: Colors.blue.shade900,
                            ),
                            labelText: 'Contraseña',
                            labelStyle: const TextStyle(fontSize: 13)
                            ),
                        keyboardType: TextInputType.emailAddress,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Debe ingresar una contraseña')
                        ]),
                    ),
                  ),
                  butonlogin(context),
                  SizedBox(height: size.height*0.1,),
                  GestureDetector(
                    onTap: () => Navigator.popAndPushNamed(context, LoginPage.routename),
                    child: Text('¿Tienes cuenta?', style: TextStyle(color: Colors.blue.shade900),),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton butonlogin(BuildContext context) {
    var prefs = PreferenciasUsuario();
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.blue.shade900,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
              horizontal: 40, vertical: 15)),
      onPressed: ()async {
        _formKey.currentState?.save();
        if(_formKey.currentState?.validate()==true){
          final v = _formKey.currentState?.value;
          var result = await _auth.createAcount(v?['user'], v?['pass']);
          if(result == 1){
            showSnackBar(context, 'Error password demasiado debil. favor cambiar.');
          } else if(result == 2){
            showSnackBar(context, 'Error, email ya esta en uso');
          }else if (result != null ){
            prefs.ultimouid = result;
            FirebaseFirestore.instance.collection('user').doc(result).set
            ({
              'email':v?['user'],
              'password':v?['pass']
            });


            Navigator.popAndPushNamed(context, DashboardPage.routename);
          }
        }
      },
      child: const Text(
        'REGISTRO!',
        style: TextStyle(color: Colors.white),
      )
    );
  }
}