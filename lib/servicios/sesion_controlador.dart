
class SesionControlador {


  String idUsuario = "-1";



  static final SesionControlador _sesioncontrolador = SesionControlador._internal();
  bool sesionEnLinea = false;
  SesionControlador._internal();
 
  factory SesionControlador() {
    return _sesioncontrolador;
  }
  String get usuarioId => idUsuario;
  bool get estaEnLinea => sesionEnLinea;

  void iniciarSesionSinConexion() {
    
  }

  void iniciarSesionEnLinea() {
    sesionEnLinea = true;
  }
  

}