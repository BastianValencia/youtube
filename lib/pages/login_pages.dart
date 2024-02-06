// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:push_youtube/pages/dashboard_pages.dart';
import 'package:push_youtube/pages/registro_pages.dart';
import 'package:push_youtube/services/bloc/notifications_bloc.dart';
import 'package:push_youtube/util/snackbar.dart';
import 'package:push_youtube/provider/auth.dart';


class LoginPage extends StatefulWidget {
  static const String routename = 'Login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
   final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {
    context.read<NotificationsBloc>().requestPermission();
    // const Color color = Color(0xff293baf);
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
                  const Center(child: Text('Login', style: TextStyle(fontSize: 20),),),
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
                    onTap: () => Navigator.popAndPushNamed(context, RegistroPages.routename),
                    child: Text('¿No tienes cuenta?', style: TextStyle(color: Colors.blue.shade900),),
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.blue.shade900,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
              horizontal: 40, vertical: 15)),
      onPressed: () async {

        _formKey.currentState?.save();
        if(_formKey.currentState?.validate()==true){
          final v = _formKey.currentState?.value;
          var result = await _auth.singInEmailAndPassword(v?['user'], v?['pass']);            
          if(result == 1){
            showSnackBar(context, 'Error en el usuario o contraseña');
          } else if(result == 2){
            showSnackBar(context, 'Error en el usuario o contraseña');
          }else if (result != null ){
            Navigator.popAndPushNamed(context, DashboardPage.routename);
          }
        }
      },
      child: const Text(
        'INICIAR SESIÓN',
        style: TextStyle(color: Colors.white),
      )
    );
  }
}