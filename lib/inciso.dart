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
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscapeMobile = screenHeight < 500 && screenWidth > screenHeight;
    final isPortraitMobile = screenWidth < 600 && screenHeight > screenWidth;

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
          
constraints: BoxConstraints(
              minWidth: screenWidth * 0.05,
              maxWidth: isPortraitMobile ? screenWidth * 0.30 : screenWidth * 0.20,
            ), 
            height: isLandscapeMobile ? screenHeight * 0.15 : screenHeight * 0.1,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              
              color: widget.seleccionado ?  const Color.fromARGB(255, 36, 189, 16)  : const Color.fromARGB(100, 255, 255, 255),
              borderRadius: BorderRadius.all(Radius.circular(45)),
              border: Border.all(color: widget.seleccionado ? const Color.fromARGB(255, 36, 189, 16) : const Color.fromARGB(100, 255, 255, 255), width: 2),
            ),
         
              child: Center(
                child: AutoSizeText(
                  widget.texto.replaceFirst(' ', '\n'),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  minFontSize: 8,
                  style: TextStyle(
                    color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900),
                ),
              ),
          
            ),
      ),);
    
  }
}