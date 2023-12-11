import 'package:flutter/material.dart';
import 'basedatos.dart';
import 'albumevento.dart';

class Invitaciones extends StatefulWidget {
  const Invitaciones({Key? key}) : super(key: key);

  @override
  State<Invitaciones> createState() => _InvitacionesState();
}

class _InvitacionesState extends State<Invitaciones> {
  List<Map<String, dynamic>> eventosInvitado = [];

  @override
  void initState() {
    super.initState();
    cargarEventosInvitado();
  }

  void cargarEventosInvitado() async {
    try {
      var eventos = await DB.mostrarEventosInvitado();
      setState(() {
        eventosInvitado = eventos;
      });
    } catch (error) {
      print("Error al cargar eventos del invitado: $error");
      // Manejar el error según tus necesidades
    }
  }

  // Método para eliminar un evento
  void eliminarEvento(String eventId) async {
    try {
      await DB.eliminar(eventId);
      // Recargar la lista de eventos después de eliminar uno
      cargarEventosInvitado();
    } catch (error) {
      print("Error al eliminar el evento: $error");
      // Manejar el error según tus necesidades
    }
  }

  // Método para navegar al álbum cuando se toca un evento
  void verAlbum(String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Album(
          eventID: eventId,
          currentUserEmail: null, // Pass the appropriate user email or null
          userRole: 'invitado', // Pass the appropriate user role or empty string
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ... (existing code)

            Container(
              child: Column(
                children: [
                  // Mostrar la lista de eventos para el invitado
                  for (var evento in eventosInvitado)
                    ListTile(
                      title: Text(evento['descripcion']),
                      subtitle: Text(evento['tipoE']),
                      // Puedes agregar más detalles del evento según tus necesidades
                      // ...

                      // Agregar un IconButton para eliminar el evento
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Llamar al método para eliminar el evento
                          eliminarEvento(evento['id']);
                        },
                      ),
                      onTap: () {
                        // Llamar al método para ver el álbum
                        verAlbum(evento['id']);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
