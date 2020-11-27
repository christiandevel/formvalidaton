import 'package:flutter/material.dart';
import 'package:formvalidaton/src/bloc/provider.dart';
import 'package:formvalidaton/src/models/producto_model.dart';
import 'package:formvalidaton/src/providers/producto_provider.dart';

class HomePage extends StatelessWidget {
  // final productoprovider = new ProductosProvider();
  @override
  Widget build(BuildContext context) {
    
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBotom(context),
    );
  }

  FloatingActionButton _crearBotom(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto'),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {

      return StreamBuilder(
        stream:  productosBloc.productosStream,
        builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
          if (snapshot.hasData) {
            final productos = snapshot.data;
            return ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, i) => _crearItem(context, productosBloc, productos[i]));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc, ProductoModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          productosBloc.borrarProductos(producto.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null)
                  ? Image(image: AssetImage('assets/original.png'))
                  : FadeInImage(
                      image: NetworkImage(producto.fotoUrl),
                      placeholder: AssetImage('assets/original.gif'),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text(producto.id),
                onTap: () => Navigator.pushNamed(context, 'producto',
                    arguments: producto),
              ),
            ],
          ),
        ));
  }
}
