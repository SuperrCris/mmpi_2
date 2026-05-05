import 'package:flutter/material.dart';

class TemaControlador {
  static final ValueNotifier<ThemeMode> modoTema = ValueNotifier(ThemeMode.light);

  static void alternarTema() {
    modoTema.value =
        modoTema.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  static bool get esModoOscuro => modoTema.value == ThemeMode.dark;
}
