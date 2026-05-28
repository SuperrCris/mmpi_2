import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mmpi_2/servicios/sesion_controlador.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final Map<String, dynamic> datos = {
    'nombre': '',
    'apellido': '',
    'curp': '',
    'rfc': '',
    'correo': '',
    'clave': '',
    'clave_confirmar': '',
  };

  final GlobalKey<FormState> _llaveFormulario = GlobalKey<FormState>();
  final TextEditingController _claveController = TextEditingController();

  final FocusNode _fnNombre = FocusNode();
  final FocusNode _fnApellido = FocusNode();
  final FocusNode _fnCurp = FocusNode();
  final FocusNode _fnRfc = FocusNode();
  final FocusNode _fnCorreo = FocusNode();
  final FocusNode _fnClave = FocusNode();
  final FocusNode _fnClaveConfirmar = FocusNode();

  @override
  void dispose() {
    _claveController.dispose();
    _fnNombre.dispose();
    _fnApellido.dispose();
    _fnCurp.dispose();
    _fnRfc.dispose();
    _fnCorreo.dispose();
    _fnClave.dispose();
    _fnClaveConfirmar.dispose();
    super.dispose();
  }

  void _enviarFormulario() {
    if (_llaveFormulario.currentState!.validate()) {
      _llaveFormulario.currentState!.save();
      iniciarSesion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscapeMobile = screenHeight < 500 && screenWidth > screenHeight;

    Widget titulo = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/inicio_sesion'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.white,
                shadowColor: Colors.black.withOpacity(0.3),
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Icon(Icons.arrow_back_rounded, color: Colors.white, shadows: [Shadow(offset: Offset(0, 2), blurRadius: 0.2, color: Colors.black12)]),
            ),
            AutoSizeText(
              'Vocacional',
              maxFontSize: 100,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
              maxLines: 1,
            ),
 SizedBox(width: 1),
          ],
        ),
        const SizedBox(height: 8),
        AutoSizeText(
          'Crea una cuenta',
          maxFontSize: 60,
          style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.85)),
          maxLines: 1,
        ),
      ],
    );

    Widget camposFormulario = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        TextFormField(
                    focusNode: _fnNombre,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_fnApellido),
                    onSaved: (value) => datos['nombre'] = value?.trim() ?? '',
                    decoration: decoracion('Nombre'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'El nombre es requerido';
                      if (value.trim().length < 2) return 'Ingresa un nombre válido';
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _fnApellido,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_fnCurp),
                    onSaved: (value) => datos['apellido'] = value?.trim() ?? '',
                    decoration: decoracion('Apellido'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'El apellido es requerido';
                      if (value.trim().length < 2) return 'Ingresa un apellido válido';
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _fnCurp,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_fnRfc),
                    onSaved: (value) => datos['curp'] = value?.trim().toUpperCase() ?? '',
                    decoration: decoracion('CURP'),
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'La CURP es requerida';
                      final curpRegex = RegExp(
                        r'^[A-Z]{4}\d{6}[HM][A-Z]{5}[A-Z0-9]\d$',
                        caseSensitive: false,
                      );
                      if (!curpRegex.hasMatch(value.trim())) return 'CURP inválida (18 caracteres, ej: ABCD010101HDFXXX01)';
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _fnRfc,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_fnCorreo),
                    onSaved: (value) => datos['rfc'] = value?.trim().toUpperCase() ?? '',
                    decoration: decoracion('RFC'),
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'El RFC es requerido';
                      final rfcRegex = RegExp(
                        r'^[A-ZÑ&]{3,4}\d{6}[A-Z0-9]{3}$',
                        caseSensitive: false,
                      );
                      if (!rfcRegex.hasMatch(value.trim())) return 'RFC inválido (12-13 caracteres, ej: ABCD010101XXX)';
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _fnCorreo,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_fnClave),
                    onSaved: (value) => datos['correo'] = value?.trim() ?? '',
                    decoration: decoracion('Correo'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'El correo es requerido';
                      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                      if (!emailRegex.hasMatch(value.trim())) return 'Ingresa un correo válido';
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _fnClave,
                    controller: _claveController,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_fnClaveConfirmar),
                    onSaved: (value) => datos['clave'] = value ?? '',
                    decoration: decoracion('Contraseña'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'La contraseña es requerida';
                      if (value.length < 6) return 'Mínimo 6 caracteres';
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _fnClaveConfirmar,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _enviarFormulario(),
                    onSaved: (value) => datos['clave_confirmar'] = value ?? '',
                    decoration: decoracion('Confirmar Contraseña'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Confirma tu contraseña';
                      if (value != _claveController.text) return 'Las contraseñas no coinciden';
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _enviarFormulario,
                    child: Text('Registrar', style: TextStyle(color: Colors.white, shadows: [Shadow(offset: Offset(0, 2), blurRadius: 0.2, color: Colors.black12)])),
                  ),
                ],
      );

    Widget contenido = isLandscapeMobile
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
                  child: Form(
                    key: _llaveFormulario,
                    child: camposFormulario,
                  ),
                ),
              ),
            ],
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _llaveFormulario,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [titulo, const SizedBox(height: 16), camposFormulario],
              ),
            ),
          );

    return Scaffold(
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
          child: Container(
            margin: EdgeInsets.all(isLandscapeMobile ? 8.0 : 24.0),
            constraints: BoxConstraints(
              maxWidth: isLandscapeMobile ? double.infinity : 480,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
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
            child: contenido,
          ),
        ),
      ),
    );
  }

  void iniciarSesion() async {
    final resultado = await SesionControlador.registroEnLinea(
      email: datos['correo'], password: datos['clave'], datosAdicionales: {
        'nombre': datos['nombre'],
        'apellido': datos['apellido'],
        'curp': datos['curp'],
        'rfc': datos['rfc'],
      });
    if (!mounted) return;
    if (resultado['exito']) {
      Navigator.pushReplacementNamed(context, '/seleccion_inventario');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado['mensaje']), backgroundColor: Colors.red),
      );
    }
  }

  InputDecoration decoracion(String texto) {
    return InputDecoration(
      labelText: texto,
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
    );
  }
}