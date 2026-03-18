import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Inciso  extends StatefulWidget{
  int valor = 0;
  String texto = '';
  
bool seleccionado = false;
  

  Inciso ({ required this.texto, required this.valor, required this.seleccionado, required Key? key}) : super(key: key);
  @override
  _IncisoState createState() => _IncisoState();

}

class _IncisoState extends State<Inciso> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return MouseRegion(
      onHover: (event) {
        setState(() {
          hover = true;
        });
      },
      onExit: (event) {
        setState(() {
          hover = false;
        });
      },
     
      
      child: AnimatedScale(
        scale: hover ? 1.1 : 1.0,
        duration: Duration(milliseconds: 200),
        child: Container(
          
constraints: BoxConstraints(minHeight: 60, minWidth: screenWidth * 0.15, maxWidth: screenWidth * 0.28),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              
              color: widget.seleccionado ?  const Color.fromARGB(255, 36, 189, 16)  : const Color.fromARGB(100, 255, 255, 255),
              borderRadius: BorderRadius.all(Radius.circular(45)),
              border: Border.all(color: widget.seleccionado ? const Color.fromARGB(255, 36, 189, 16) : const Color.fromARGB(100, 255, 255, 255), width: 2),
            ),
         
              child: Center(
                child: AutoSizeText(
                  widget.texto,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  minFontSize: 10,
                  style: TextStyle(
                    color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900),
                ),
              ),
          
            ),
      ),);
    
  }
}