import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mmpi_2/selecinventario.dart';

class InicioSesion extends StatefulWidget {
  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  // GlobalKey que conecta el Form con su estado interno
  final _formKey = GlobalKey<FormState>();

  // Controladores para obtener el texto ingresado
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Liberar recursos cuando el widget se destruya
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _iniciarSesion() {
    // validate() ejecuta todos los validadores de los TextFormField
    if (_formKey.currentState!.validate()) {
      // Si todos los campos son válidos, procesar el login
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');


      Future.delayed(Duration(seconds: 2));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SeleccionInventario()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 177, 153),
                  Color.fromARGB(255, 1, 132, 255),
                ],
                begin: Alignment.center,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: const Color.fromARGB(234, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                maxWidth: 400,
                minWidth: 300,
                minHeight: 400,
                maxHeight: 500,
              ),
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey, // Conecta el Form con su GlobalKey
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      "MMPI-2 o SABE",
                      maxFontSize: 100,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: 24),
                    // TextFormField para email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        hintText: 'usuario@ejemplo.com',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction
                          .next, // Muestra botón "Siguiente" en el teclado
                      // validator se ejecuta cuando llamas a _formKey.currentState!.validate()
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu email';
                        }

                        return null; // null significa que la validación pasó
                      },
                    ),

                    SizedBox(height: 16),

                    // TextFormField para contraseña
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        hintText: 'Ingresa tu contraseña',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true, // Oculta el texto
                      textInputAction: TextInputAction
                          .done, // Muestra el botón "Listo" en el teclado
                      onFieldSubmitted: (_) =>
                          _iniciarSesion(), // Se ejecuta al presionar Enter
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 24),

                    // Botón de inicio de sesión
                    ElevatedButton(
                      onPressed: _iniciarSesion,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(50, 50),
                        backgroundColor: Colors.amber,
                      ),
                      child: Text(
                        'Registrarse',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
