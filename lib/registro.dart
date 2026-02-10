import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {

  Map<String, dynamic> datos = {
    'nombre': '',
    'apellido': '',
    'curp': '',
    'rfc': '',
    'correo': '',
    'clave': '',
  };
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            SizedBox(height: 20),
            Center(child: Text('MMPI-2', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 40, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child:  Container(
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 600),
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  AutoSizeText(
                    'Crea una cuenta',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      maxLines: 1,
                    ),

                    TextField(
                      onChanged: (value) => datos['nombre'] = value,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                      ),
                    ),
                    TextField(
                      onChanged: (value) => datos['apellido'] = value,
                      decoration: InputDecoration(
                        labelText: 'Apellido',
                      ),
                    ),
                    TextField(
                      onChanged: (value) => datos['curp'] = value,
                      decoration: InputDecoration(
                        labelText: 'CURP',
                      ),
                    ),
                    TextField(
                      onChanged: (value) => datos['rfc'] = value,
                       decoration: InputDecoration(
                        labelText: 'RFC',
                      ),
                    ),
                    TextField(
                      onChanged: (value) => datos['correo'] = value,
                       decoration: InputDecoration(
                        labelText: 'Correo',
                      ),
                    ),
                    TextField(
                      onChanged: (value) => datos['clave'] = value,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Aquí puedes manejar el envío de los datos
                        print(datos);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registro exitoso')));
                      },
                      child: Text('Registrar', style: TextStyle(color: Colors.white, shadows: [Shadow(offset: Offset(0, 2), blurRadius: 0.2, color: Colors.black12)],),),
                    ),
                  ],
              ),
            ),
          ),
        ),
      ),
      );
        }
      
  InputDecoration decoracion (String texto) {
    return InputDecoration(
      labelText: texto,
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
  
    );
  }
  
}