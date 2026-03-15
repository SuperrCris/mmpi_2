import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mmpi_2/registro.dart';
import 'package:mmpi_2/selecinventario.dart';
import 'package:mmpi_2/servicios/sesion_controlador.dart';

class InicioSesion extends StatefulWidget {
  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion({bool conSesionActual = false}) async {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SeleccionInventario()),
      );
      print("iniciando sesión con sesión actual: ${FirebaseAuth.instance.currentUser!.email}");
      return;
    }
    print("No hay sesión actual, intentando iniciar sesión en línea...");
    if (conSesionActual) return;

        SesionControlador.iniciarSesionEnLinea(
          email: _emailController.text.trim(), 
          password: _passwordController.text.trim()).
          then((resultado) {
          if (resultado['exito']) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => SeleccionInventario()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(resultado['mensaje']),
                backgroundColor: Colors.red,),
            );}});
  }
    void _iniciarSesionSinConexion() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SeleccionInventario()),
      );
    }
    
    @override
   void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
         _iniciarSesion(conSesionActual: true);
    });

    }
   

   void _validar(){
     if (_formKey.currentState!.validate()) {
      _iniciarSesion(conSesionActual: false);
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
                key: _formKey, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      "Vocacional",
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
                          .next, 
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu email';
                        }

                        return null; 
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
                         _validar(),
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
                      onPressed: (){
                      
                        _validar();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _iniciarSesionSinConexion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Iniciar sin conexión',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Registro())).then((_) {
                        _iniciarSesion();
                        });},
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
