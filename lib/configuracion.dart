import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Configuracion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          ListTile(
            title: Text("Cambiar Contraseña"),
            leading: Icon(Icons.lock),
            onTap: () {
              _mostrarDialogoCambiarContrasena(context);
            },
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoCambiarFoto(BuildContext context) {
    // Lógica para mostrar el diálogo de cambio de foto
    // Puedes utilizar ImagePicker o implementar tu propia lógica.
    // Ejemplo:
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Cambiar Foto"),
          content: Text("Aquí puedes seleccionar una nueva foto."),
          actions: [
            TextButton(
              onPressed: () {
                // Lógica para cambiar la foto
                // Implementa tu código aquí
                Navigator.of(context).pop();
              },
              child: Text("Guardar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoCambiarNombre(BuildContext context) {
    // Lógica para mostrar el diálogo de cambio de nombre
    showDialog(
      context: context,
      builder: (context) {
        String nuevoNombre = ""; // Variable para almacenar el nuevo nombre
        return AlertDialog(
          title: Text("Cambiar Nombre de Usuario"),
          content: TextField(
            onChanged: (value) {
              nuevoNombre = value;
            },
            decoration: InputDecoration(labelText: "Nuevo Nombre"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Lógica para cambiar el nombre de usuario
                // Implementa tu código aquí
                print("Nuevo nombre: $nuevoNombre");
                Navigator.of(context).pop();
              },
              child: Text("Guardar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoCambiarContrasena(BuildContext context) {
    // Lógica para mostrar el diálogo de cambio de contraseña
    showDialog(
      context: context,
      builder: (context) {
        String nuevaContrasena = ""; // Variable para almacenar la nueva contraseña
        String confirmarContrasena = ""; // Variable para almacenar la confirmación de la nueva contraseña

        return AlertDialog(
          title: Text("Cambiar Contraseña"),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Ajusta el relleno del contenido
          content: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del contenido al mínimo
            children: [
              TextField(
                obscureText: true,
                onChanged: (value) {
                  nuevaContrasena = value;
                },
                decoration: InputDecoration(labelText: "Nueva Contraseña"),
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  confirmarContrasena = value;
                },
                decoration: InputDecoration(labelText: "Confirmar Contraseña"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  // Verificar que las contraseñas coincidan
                  if (nuevaContrasena == confirmarContrasena) {
                    // Lógica para cambiar la contraseña
                    User? user = FirebaseAuth.instance.currentUser;
                    await user?.updatePassword(nuevaContrasena);
                    print("Contraseña cambiada con éxito");
                    Navigator.of(context).pop();
                  } else {
                    print("Las contraseñas no coinciden");
                    // Puedes mostrar un mensaje de error aquí si lo deseas
                  }
                } catch (error) {
                  print("Error al cambiar la contraseña: $error");
                  // Puedes mostrar un mensaje de error aquí si lo deseas
                }
              },
              child: Text("Guardar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }
}
