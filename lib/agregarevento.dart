import 'package:flutter/material.dart';
import 'basedatos.dart';

class AgregarEvento extends StatefulWidget {
  const AgregarEvento({Key? key}) : super(key: key);

  @override
  State<AgregarEvento> createState() => _AgregarEventoState();
}

class _AgregarEventoState extends State<AgregarEvento> {
  TextEditingController codigoController = TextEditingController();

  String tipoEvento = "";
  String propietarioEvento = "";
  String descripcionEvento = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade200,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(5, 5),
                    blurRadius: 5,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'AGREGAR EVENTO',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(50),
              child: Column(
                children: [
                  Text(
                    "NÚMERO DE INVITACIÓN:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: codigoController,
                    decoration: InputDecoration(
                      labelText: 'Ingresa el código',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () {
                      buscarEvento();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent[200],
                      textStyle: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    child: Text("BUSCAR"),
                  ),
                  SizedBox(height: 30,),
                  Text(
                    "TIPO DE EVENTO:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(tipoEvento, style: TextStyle(fontSize: 20),),
                  SizedBox(height: 20,),
                  Text(
                    "PROPIEDAD DE:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(propietarioEvento, style: TextStyle(fontSize: 20),),
                  SizedBox(height: 20,),
                  Text(
                    "DESCRIPCION:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10,),
                  Text(descripcionEvento, style: TextStyle(fontSize: 20,)),
                  SizedBox(height: 30,),
                  ElevatedButton(
                    onPressed: () {
                      agregarInvitacion();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent[200],
                      textStyle: TextStyle(fontSize: 20,),
                    ),
                    child: Text("AGREGAR"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void buscarEvento() async {
    try {
      String codigo = codigoController.text;
      var evento = await DB.mostrarEventoPorCodigo(codigo);

      setState(() {
        tipoEvento = evento['tipoE'] ?? "";
        propietarioEvento = evento['propietario'] ?? "";
        descripcionEvento = evento['descripcion'] ?? "";
      });
    } catch (error) {
      print("Error al buscar el evento: $error");
      // Manejar el error según tus necesidades
    }
  }

  void agregarInvitacion() async {
    try {
      // Obtener datos del evento
      String codigo = codigoController.text;
      var evento = await DB.mostrarEventoPorCodigo(codigo);

      // Verificar si el evento existe
      if (evento.isNotEmpty) {
        // Crear la invitación con los datos del evento
        await DB.insertar({
          'codigo': evento['codigo'],
          'tipoE': evento['tipoE'],
          'propietario': evento['propietario'],
          'rol': 'invitado',
          'descripcion': evento['descripcion'],
          'fechaI': evento['fechaI'],
          'fechaF': evento['fechaF'],
          'imagenUrl': evento['imagenUrl'],
          'permiso': evento['permiso'],
        });

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("INVITACIÓN AGREGADA")),
        );
      } else {
        // Mostrar mensaje de error si el evento no existe
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: El evento no existe")),
        );
      }
    } catch (error) {
      print("Error al agregar la invitación: $error");
      // Manejar el error según tus necesidades
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al agregar la invitación")),
      );
    }
  }

}
