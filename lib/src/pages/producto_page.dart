import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidaton/src/bloc/provider.dart';

import 'package:formvalidaton/src/models/producto_model.dart';
import 'package:formvalidaton/src/utils/utils.dart' as utils;

import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldkey = GlobalKey<ScaffoldState>();

  ProductosBloc productosBloc;
  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  // final productoprovider = ProductosProvider();

  File foto;

  @override
  Widget build(BuildContext context) {

    productosBloc = Provider.productosBloc(context);
    final ProductoModel propData = ModalRoute.of(context).settings.arguments;
    if (propData != null) {
      producto = propData;
    }

    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBotom(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }


   Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo Numeros';
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: true,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  Widget _crearBotom() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    // setState(() { _guardando = true; });

    if(foto != null){
      producto.fotoUrl = await  productosBloc.subirFoto(foto);
    }
    if (producto.id == null) {
      productosBloc.agregarProductos(producto);
    } else {
      productosBloc.editaProductos(producto);
    }

    // mostrarSnackbar('Registro Guardado');
    Navigator.pop(context);

    // if(formKey.currentState.validate()){
    //   // Cuando el formulario es valido
    // }
  }

  // void mostrarSnackbar(String mensaje) {
  //   final snackbar = SnackBar(
  //     content: Text(mensaje),
  //     duration: Duration(milliseconds: 1500),
  //   );

  //   scaffoldkey.currentState.showSnackBar(snackbar);
  // }

  Widget _mostrarFoto() {
      print(producto.fotoUrl);
          if(producto.fotoUrl != null){
      // Tengo que hacer esto
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/original.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    }else{
      return Image(
        image: AssetImage( foto?.path ?? 'assets/original.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }
  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
      _procesarImagen(ImageSource.camera);
  }

  _procesarImagen( ImageSource origen) async {
    foto = await ImagePicker.pickImage(source: origen);
  
    if(foto != null){
      producto.fotoUrl = null;
    }
    setState((){});
  }
}
