import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SeleccionInventario extends StatefulWidget {
  @override
  _SeleccionInventarioState createState() => _SeleccionInventarioState();
}

class _SeleccionInventarioState extends State<SeleccionInventario> {

  List inventarios = [
    "Inventario de aptitudes",
    "Inventario de intereses",
    "Inventario de valores",
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(

      body: Center(
        

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: inventarios.map((inventario) => Container(
                constraints: BoxConstraints(maxWidth: 300, minWidth: 100, minHeight: 400 ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                   
                    Column(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        constraints: BoxConstraints(maxWidth: 300),
                        decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 177, 153),
                        ),),
                        
                      SizedBox(height: 8),
                      AutoSizeText(
                        inventario,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                   Positioned(
                    height: 50,
                    width: 50,
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 50, minWidth: 40, ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.inventory, color: Colors.white, size: 40),
                      ),
                    )),
                  ]
                ),
              )).toList()),
            ),
          
        ),
      ),
    );
  }
}