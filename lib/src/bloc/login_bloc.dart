import 'dart:async';
import 'package:formvalidaton/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';


class LoginBloc with Validators{
  final _emailController = BehaviorSubject<String>();
  final _passwController = BehaviorSubject<String>();



  // Recuperar los datos del Stream
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwStream => _passwController.stream.transform(validarPassword);

  Stream<bool> get formValidStream => CombineLatestStream.combine2(emailStream, passwStream, (a, b) => true);

  // Insertar Valores al String
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassw => _passwController.sink.add;


  // Obtener el ultimo valor agregado a los string
  String get email => _emailController.value;
  String get password => _passwController.value;

  dispose(){
    _emailController?.close();
    _passwController?.close();
  }
}