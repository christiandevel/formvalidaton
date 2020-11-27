import 'package:flutter/material.dart';
import 'package:formvalidaton/src/bloc/provider.dart';
import 'package:formvalidaton/src/pages/home_page.dart';
import 'package:formvalidaton/src/pages/login_page.dart';
import 'package:formvalidaton/src/pages/producto_page.dart';
import 'package:formvalidaton/src/pages/registro_page.dart';
import 'package:formvalidaton/src/preferencias/preferencias_usuario.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
 final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
  runApp(MyApp());
}

  
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    print(prefs.token);
    return Provider(
      child: MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login':  (BuildContext context) => LoginPage(),
        'home': (BuildContext context) => HomePage(),
        'producto' : (BuildContext context) => ProductoPage(),
        'registro' : (BuildContext context) => RegistroPage()
      },
      theme: ThemeData(
        primaryColor: Colors.deepPurple 
        ),
      )
    );
  }
}
