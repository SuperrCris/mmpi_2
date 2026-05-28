import 'package:flutter/material.dart';
import 'package:mmpi_2/utilidades/repositoriopreguntas.dart';

class inventario2 extends StatefulWidget {
  final String tipoInventario;
  final String tipo;

  const inventario2({Key? key, required this.tipoInventario, required this.tipo}) : super(key: key);

  @override
  _inventario2State createState() => _inventario2State();
}

class _inventario2State extends State<inventario2> {
  late Map<String, String> intereses;

  @override
  void initState() {
    super.initState();
    intereses = todoslosintereses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipoInventario),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: intereses.length, // Aquí deberías usar el tamaño real del inventario
          itemBuilder: (context, index) {
            String key = intereses.keys.elementAt(index);
            return ListTile(
              title: Text(intereses[key] ?? 'Pregunta ${index + 1}'), // Aquí deberías mostrar la pregunta real
            );
          },
        ),
      ),
    );
  }
}