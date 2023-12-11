import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

var baseRemota = FirebaseFirestore.instance;

class DB {
  static Future insertar(Map<String, dynamic> eventos) async {
    return await baseRemota.collection("eventos").add(eventos); //then se hace en la vista para el usuario
  }

  static Future<List> mostrarTodos() async {
    List temporal = [];
    var query = await baseRemota.collection("eventos").get();

    query.docs.forEach((element) {
      Map<String, dynamic> dataTemp = element.data();
      dataTemp.addAll({'id': element.id});
      temporal.add(dataTemp);
    });
    return temporal;
  }
  static Future<void> actualizarImagen(String eventID, String imageUrl) async {
    // Actualiza la base de datos con la nueva URL de la imagen
    return await baseRemota.collection("eventos")
        .doc(eventID)
        .update({'imagenUrl': imageUrl});
  }

  static Future eliminar(String id) async{
    return await baseRemota.collection("eventos")
        .doc(id).delete();
  }

  static Future<void> actualizar(Map<String, dynamic> eventos) async {
    String codigoActualizar = eventos['codigo'];
    eventos.remove('codigo'); // Remove the 'codigo' field from the data

    QuerySnapshot<Map<String, dynamic>> eventosSnapshot =
    await baseRemota.collection("eventos").where('codigo', isEqualTo: codigoActualizar).get();

    if (eventosSnapshot.docs.isNotEmpty) {
      // Iterate through all documents with the specified 'codigo' and update each one
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in eventosSnapshot.docs) {
        String idActualizar = doc.id;
        await baseRemota.collection("eventos").doc(idActualizar).update(eventos);
      }
    } else {
      // Handle the case where no event with the specified 'codigo' is found
      throw Exception("No se encontraron eventos con el código: $codigoActualizar");
    }
  }


  static Future<List> mostrarEventosPropios() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? currentUserEmail = user?.email;

    if (currentUserEmail != null) {
      List temporal = [];

      var query = await baseRemota
          .collection("eventos")
          .where('propietario', isEqualTo: currentUserEmail)
          .get();

      query.docs.forEach((element) {
        Map<String, dynamic> dataTemp = element.data();
        if (dataTemp['rol'] != "invitado") {
          dataTemp.addAll({'id': element.id});
          temporal.add(dataTemp);
        }
      });

      return temporal;
    } else {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> mostrarEventosInvitado() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? currentUserEmail = user?.email;

    if (currentUserEmail != null) {
      List<Map<String, dynamic>> temporal = [];

      var query = await baseRemota
          .collection("eventos")
          .where('rol', isEqualTo: 'invitado')
          .get();

      query.docs.forEach((element) {
        Map<String, dynamic> dataTemp = element.data();
        // Agrega la condición para verificar que el usuario actual no sea el "propietario"
        if (dataTemp['propietario'] != currentUserEmail) {
          dataTemp.addAll({'id': element.id});
          temporal.add(dataTemp);
        }
      });

      return temporal;
    } else {
      return [];
    }
  }


  static Future<Map<String, dynamic>> mostrarEventoPorCodigo(String codigo) async {
    try {
      // Buscar el evento con el código proporcionado
      var query = await baseRemota.collection("eventos").where('codigo', isEqualTo: codigo).get();

      if (query.docs.isNotEmpty) {
        var evento = query.docs.first;
        Map<String, dynamic> data = evento.data();
        data.addAll({'id': evento.id});
        return data;
      } else {
        // Si no se encuentra ningún evento con el código
        return {};
      }
    } catch (error) {
      print("Error al buscar el evento por código: $error");
      // Manejar el error según tus necesidades
      throw error;
    }
  }


  static Future<Map<String, dynamic>> mostrarEvento(String id) async {
    var doc = await baseRemota.collection("eventos").doc(id).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data()!;
      data.addAll({'id': doc.id});
      return data;
    } else {
      return {};
    }
  }
}