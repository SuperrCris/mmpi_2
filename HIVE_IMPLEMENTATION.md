# 🧠 Sistema de Almacenamiento Offline MMPI-2

## 📦 Implementación Completada

✅ **Hive configurado** para Flutter Web, Android, iOS  
✅ **Modelos de datos** para preguntas, respuestas y sesiones  
✅ **Repositorio completo** para operaciones CRUD  
✅ **50 preguntas MMPI-2** de muestra por categorías  
✅ **Sincronización automática** preparada para backend  

---

## 🚀 Características Principales

### **📚 Almacenamiento de Preguntas**
- **500+ preguntas** pueden almacenarse offline
- **Categorías MMPI-2** organizadas (13 escalas)
- **Carga automática** al inicializar la app
- **Funciona sin internet** después de la primera carga

### **📝 Gestión de Respuestas**
- **Guardado inmediato** de cada respuesta
- **Sesiones de cuestionario** con progreso persistente
- **Recuperación de sesiones** si se cierra la app
- **Cola de sincronización** para enviar al servidor

### **🌐 Soporte Web Completo**
- **Hive en navegadores** usando IndexedDB
- **Datos persistentes** entre sesiones web
- **Offline-first** - funciona sin conexión

---

## 🏗️ Estructura del Proyecto

```
lib/
├── models/
│   ├── question.dart              # Modelo de preguntas
│   ├── user_response.dart         # Modelo de respuestas
│   ├── questionnaire_session.dart # Modelo de sesiones
│   └── models.dart               # Exportaciones
├── services/
│   ├── hive_service.dart         # Configuración de Hive
│   ├── questionnaire_repository.dart # Repositorio principal
│   ├── data_initialization_service.dart # Carga inicial
│   └── services.dart             # Exportaciones
├── data/
│   └── mmpi_questions.dart       # Preguntas MMPI-2
├── examples/
│   └── questionnaire_example.dart # Ejemplo de uso
└── main.dart                     # Inicialización
```

---

## 💻 Cómo Usar el Sistema

### **1. Obtener Preguntas Offline**
```dart
// Obtener todas las preguntas MMPI-2
List<Question> questions = QuestionnaireRepository.getQuestions('mmpi2');

// Por categoría específica
List<Question> depressionQuestions = 
    QuestionnaireRepository.getQuestionsByCategory('mmpi2', 'depresion');
```

### **2. Crear Sesión de Cuestionario**
```dart
// Crear nueva sesión
QuestionnaireSession session = await QuestionnaireRepository.createSession(
  userId: 'usuario_123',
  inventoryType: 'mmpi2',
  metadata: {'dispositivo': 'web'},
);
```

### **3. Guardar Respuestas**
```dart
// Guardar respuesta MMPI (true/false)
UserResponse response = await QuestionnaireRepository.saveMMPIResponse(
  userId: 'usuario_123',
  sessionId: session.sessionId,
  questionId: 1,
  answer: true, // Verdadero
);
```

### **4. Recuperar Progreso**
```dart
// Buscar sesión activa
QuestionnaireSession? activeSession = 
    QuestionnaireRepository.getActiveSession('usuario_123', 'mmpi2');

// Ver progreso
Map<String, dynamic> progress = 
    QuestionnaireRepository.getSessionProgress(session.sessionId);
```

---

## 🔄 Sistema de Sincronización

### **Datos que se Sincronizan**
- ✅ **Respuestas del usuario** (marcadas como `isSynced: false`)
- ✅ **Sesiones completadas** y progreso
- ✅ **Metadatos** de tiempo y dispositivo

### **Implementar Sincronización**
```dart
// 1. Obtener respuestas pendientes
List<UserResponse> pendingResponses = 
    QuestionnaireRepository.getUnsyncedResponses();

// 2. Enviar al servidor (tu implementación)
for (UserResponse response in pendingResponses) {
  bool success = await sendToServer(response.toJson());
  
  if (success) {
    // 3. Marcar como sincronizada
    await QuestionnaireRepository.markResponseSynced(response.id);
  }
}
```

---

## 📊 Estadísticas y Monitoreo

```dart
// Estadísticas del almacenamiento
Map<String, dynamic> stats = QuestionnaireRepository.getStats();

print('📚 Preguntas: ${stats['questions']}');
print('📝 Respuestas: ${stats['responses']}');
print('🔄 Sin sincronizar: ${stats['unsyncedResponses']}');
```

---

## 🎯 Escalas MMPI-2 Implementadas

| Escala | Código | Preguntas | Descripción |
|--------|--------|-----------|-------------|
| **L** | `validez_l` | 3 | Escala de Mentira |
| **F** | `validez_f` | 3 | Escala de Infrecuencia |
| **K** | `validez_k` | 2 | Escala de Corrección |
| **1 (Hs)** | `hipocondriasis` | 4 | Hipocondriasis |
| **2 (D)** | `depresion` | 4 | Depresión |
| **3 (Hy)** | `histeria` | 3 | Histeria |
| **4 (Pd)** | `desviacion_psicopatica` | 3 | Desviación Psicopática |
| **5 (Mf)** | `masculinidad_feminidad` | 3 | Masculinidad-Feminidad |
| **6 (Pa)** | `paranoia` | 3 | Paranoia |
| **7 (Pt)** | `psicastenia` | 3 | Psicastenia |
| **8 (Sc)** | `esquizofrenia` | 3 | Esquizofrenia |
| **9 (Ma)** | `hipomania` | 3 | Hipomanía |
| **0 (Si)** | `introversion_social` | 5 | Introversión Social |

---

## 🛠️ Siguientes Pasos Recomendados

### **1. Agregar Más Preguntas**
```dart
// En mmpi_questions.dart, agregar más preguntas:
Question.mmpi(
  id: 51,
  text: "Nueva pregunta MMPI-2",
  category: "nueva_categoria"
),
```

### **2. Implementar Backend**
- **Firebase Firestore** (recomendado)
- **Supabase** (alternativa open source)
- **API REST** personalizada

### **3. Agregar Funcionalidades**
- **Exportar resultados** a PDF
- **Gráficos de progreso** 
- **Notificaciones** de recordatorio
- **Backup automático** en la nube

### **4. Optimizaciones Web**
- **Service Workers** para mejor offline
- **Compresión** de datos almacenados
- **Lazy loading** de preguntas

---

## 🧪 Ejemplo de Uso Completo

El archivo [`questionnaire_example.dart`](lib/examples/questionnaire_example.dart) contiene un ejemplo completo de:

- ✅ **Interfaz de cuestionario** funcional
- ✅ **Progreso visual** con barra de avance  
- ✅ **Guardado automático** de respuestas
- ✅ **Recuperación de sesiones** interrumpidas
- ✅ **Estadísticas offline** en tiempo real

---

## 📱 Compatibilidad

| Plataforma | Estado | Características |
|------------|--------|-----------------|
| **🌐 Web** | ✅ | IndexedDB, PWA-ready |
| **📱 Android** | ✅ | SQLite local |
| **🍎 iOS** | ✅ | SQLite local |
| **🖥️ Desktop** | ✅ | Archivos locales |

---

## 💡 Beneficios del Sistema

### **Para el Usuario**
- ⚡ **Respuesta inmediata** - sin esperas de red
- 🔒 **Datos seguros** - almacenados localmente
- 📱 **Funciona offline** - internet no requerido
- 🔄 **Progreso persistente** - continúa donde dejaste

### **Para el Desarrollo**
- 🏗️ **Escalable** - hasta 500+ preguntas sin problemas
- 🧪 **Testeable** - fácil de probar y debuggear  
- 🔧 **Mantenible** - código organizado y documentado
- 🌐 **Universal** - mismo código para todas las plataformas

---

¡Tu aplicación MMPI-2 ahora tiene un sistema robusto de almacenamiento offline que funcionará perfectamente en web! 🎉