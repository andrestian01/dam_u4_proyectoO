import 'package:flutter/material.dart';
import 'basedatos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Crear extends StatefulWidget {
  const Crear({Key? key});

  @override
  State<Crear> createState() => _CrearState();
}

class _CrearState extends State<Crear> {
  String titulo = "C R E A N D O  M E M O R I A S";
  final descripcion = TextEditingController();
  final fechaI = TextEditingController();
  final fechaF = TextEditingController();
  final tipoE = TextEditingController();
  final permiso = TextEditingController();
  String dropdownValue = "Baby Shower";
  bool dropdownValue2 = false;
  late String nuevoCodigo;// Use as a variable

  String generarCodigoUnico() {
    return DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    nuevoCodigo = generarCodigoUnico(); // Initialize in initState
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        Text(
          ">> C R E A R   E V E N T O <<",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple.shade200,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15,),
        Image.asset("assets/b3.jpg", width: 200, height: 150,),
        SizedBox(height: 10,),
        TextField(
          controller: descripcion,
          decoration: InputDecoration(labelText: "Descripción:"),
        ),
        SizedBox(height: 15,),
        TextField(
          controller: fechaI,
          decoration: InputDecoration(labelText: "Fecha Inicio (yy/mm/dd):"),
        ),
        SizedBox(height: 15,),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text("Tipo Evento:"),
            ),
            Expanded(
              flex: 2,
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down_circle, color: Colors.deepPurple,),
                underline: Container(
                  height: 1.5,
                  color: Colors.black26,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Baby Shower',
                    child: Text("Baby Shower"),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Bautizo',
                    child: Text("Bautizo"),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Boda',
                    child: Text("Boda"),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Cumpleaños',
                    child: Text("Cumpleaños"),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Celebracion Navideña',
                    child: Text("Celebracion Navideña"),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 15,),
        TextField(
          controller: fechaF,
          decoration: InputDecoration(labelText: "Fecha Final (yy/mm/dd):"),
        ),
        SizedBox(height: 15,),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text("Fotografías:"),
            ),
            Expanded(
              flex: 2,
              child: DropdownButton<bool>(
                value: dropdownValue2,
                icon: const Icon(Icons.arrow_drop_down_circle, color: Colors.deepPurple,),
                underline: Container(
                  height: 1.5,
                  color: Colors.black26,
                ),
                onChanged: (bool? newValue) {
                  setState(() {
                    dropdownValue2 = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem<bool>(
                    value: true,
                    child: Text("Despues Evento"),
                  ),
                  DropdownMenuItem<bool>(
                    value: false,
                    child: Text("En Evento"),
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  // Get the current user
                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    // Create the event using the current user's email as the owner
                    var basedatos = FirebaseFirestore.instance;
                    basedatos.collection("eventos").add({
                      'descripcion': descripcion.text,
                      'fechaI': fechaI.text,
                      'tipoE': dropdownValue,
                      'fechaF': fechaF.text,
                      'permiso': dropdownValue2,
                      'propietario': user.email,
                      'rol': "propietario",
                      'codigo': nuevoCodigo, // Use as a variable
                    }).then((value) {
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("E V E N T O  C R E A D O"),
                          ),
                        );
                      });
                      descripcion.text = "";
                      fechaI.text = "";
                      fechaF.text = "";
                      dropdownValue = 'Baby Shower';
                      dropdownValue2 = false;
                    });
                  } else {
                    // Handle the case where no user is logged in
                    print("No user is logged in.");
                    // You might want to show an error message to the user.
                  }
                } catch (e) {
                  print("Error creating event: $e");
                  // Handle the error as needed
                }
              },
              child: Text("Crear"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  descripcion.text = "";
                  fechaI.text = "";
                  fechaF.text = "";
                  dropdownValue = 'Baby Shower';
                  dropdownValue2 = false;
                });
              },
              child: Text("Cancelar"),
            ),
          ],
        )
      ],
    );
  }
}

class FilledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  FilledButton({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
