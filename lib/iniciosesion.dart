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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscapeMobile = screenHeight < 500 && screenWidth > screenHeight;

    Widget titulo = AutoSizeText(
      "Vocacional",
      maxFontSize: 100,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
      maxLines: 1,
    );

    Widget campos = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Usuario',
            hintText: 'usuario@ejemplo.com',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Por favor ingresa tu email';
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Contraseña',
            hintText: 'Ingresa tu contraseña',
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _validar(),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Por favor ingresa tu contraseña';
            if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
            return null;
          },
        ),
      ],
    );

    Widget botones = Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton(
          onPressed: _validar,
          child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 14, color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: _iniciarSesionSinConexion,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent),
          child: const Text('Iniciar sin conexión', style: TextStyle(fontSize: 14, color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Registro()))
               ;
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          child: const Text('Registrarse', style: TextStyle(fontSize: 14, color: Colors.white)),
        ),
      ],
    );

    Widget contenidoFormulario = isLandscapeMobile
        // Landscape: título a la izquierda, campos+botones a la derecha
        ? Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(child: titulo),
              ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [campos, const SizedBox(height: 12), botones],
                  ),
                ),
              ),
            ],
          )
        // Portrait: columna centrada
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                titulo,
                const SizedBox(height: 20),
                campos,
                const SizedBox(height: 16),
                botones,
              ],
            ),
          );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 58, 123, 183),
              Color.fromARGB(255, 0, 177, 153),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Hero(
            tag: "fondo",
            child: Container(
              margin: EdgeInsets.all(isLandscapeMobile ? 8.0 : 24.0),
              constraints: BoxConstraints(
                maxWidth: isLandscapeMobile ? double.infinity : 480,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: contenidoFormulario,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
