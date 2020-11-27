import 'dart:convert';

import 'package:formvalidaton/src/preferencias/preferencias_usuario.dart';
import 'package:http/http.dart' as http;


class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyAI5VAgDrs1lLtBq2Jl6WllQIbXO2APtzg';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password)async {
    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true,
    };

    final resp = await  http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$_firebaseToken',
      body: json.encode( authData )
    );

    

    print(resp);

    Map<String, dynamic> decodedResp = await json.decode(resp.body);

    if(decodedResp.containsKey('idToken')){
      // Salvar el token en el Storange

      _prefs.token = decodedResp['idToken'];
      return { 'ok': true, 'token': decodedResp['idToken'] };
    }else{
      return { 'ok': false, 'mensaje' : decodedResp['error']['message'] };
    }
  }




  Future<Map<String, dynamic>> nuevoUsuario(String email, String password) async {
    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true,
    };

    final resp = await  http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=$_firebaseToken',
      body: json.encode( authData )
    );

    Map<String, dynamic> decodedResp = await json.decode(resp.body);

    print(decodedResp);

    if(decodedResp.containsKey('idToken')){
      // Salvar el token en el Storange

      _prefs.token = decodedResp['idToken'];
      return { 'ok': true, 'token': decodedResp['idToken'] };
    }else{
      return { 'ok': false, 'mensaje' : decodedResp['error']['message'] };
    }
  }
}