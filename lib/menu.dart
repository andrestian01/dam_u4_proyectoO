import 'package:dam_u4_p1/drawer.dart';
import 'package:flutter/material.dart';
import 'basedatos.dart';
import 'albumevento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String titulo = "C R E A N D O  M E M O R I A S";
  final descripcion = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  String? currentUserEmail;
  String userRole = ''; // Initialize userRole
  final fechaI = TextEditingController();
  final fechaF = TextEditingController();
  final tipoE = TextEditingController();
  final permiso = TextEditingController();
  final propietario = TextEditingController();
  String dropdownValue = "Baby Shower";
  bool dropdownValue2 = false;

  void initState() {
    super.initState();
    currentUserEmail = user?.email;
    DB.mostrarEventosPropios();
    // Fetch userRole when initializing the state
    //fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    // Assuming you have a method to fetch the event details by ID
    var eventoDetails = await DB.mostrarEventosPropios();
    if (eventoDetails.isNotEmpty) {
      setState(() {
        // Assuming 'userRole' is a field in your "evento" document
        userRole = eventoDetails[0]['userRole'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DB.mostrarEventosPropios(),
      builder: (context, listaJSON) {
        if (listaJSON.hasData) {
          return Scaffold(

            body: Column(
              children: [
                // Sección de información del evento
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Display userRole in the UI

                  ),
                ),
                // Lista de eventos
                Expanded(
                  child: ListView.builder(
                    itemCount: listaJSON.data?.length,
                    itemBuilder: (context, indice) {
                      return ListTile(
                        title: Text("${listaJSON.data?[indice]['descripcion']}"),
                        subtitle: Text("${listaJSON.data?[indice]['tipoE']}"),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("E L I M I N A R  E V E N T O"),
                                  content: Text("¿Desea eliminar este evento?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        DB.eliminar(listaJSON.data?[indice]['id']).then((value) {
                                          setState(() {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text("E V E N T O  E L I M I N A D O"),
                                              ),
                                            );
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) => P01()),
                                            );
                                          });
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Eliminar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancelar'),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete),
                        ),
                        onTap: () {
                          String IDevento = listaJSON.data?[indice]['id'];
                          if (currentUserEmail != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Album(
                                  eventID: IDevento,
                                  currentUserEmail: currentUserEmail,
                                  userRole: userRole,
                                ),
                              ),
                            );
                          } else {
                            // Handle the case where the user is not authenticated
                            print("User is not authenticated");
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void actualizar(String ID) async {
    var datosEvento = await DB.mostrarEvento(ID);
    if (datosEvento.isNotEmpty) {
      setState(() {
        descripcion.text = datosEvento['descripcion'];
        fechaI.text = datosEvento['fechaI'];
        dropdownValue = datosEvento['tipoE'];
        fechaF.text = datosEvento['fechaF'];
        dropdownValue2 = datosEvento['permiso'] as bool;
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 5,
      builder: (builder) {
        return Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 30,
            right: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ID: ${ID}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: descripcion,
                decoration: InputDecoration(
                  labelText: "Descripción:",
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: fechaI,
                decoration: InputDecoration(
                  labelText: "Fecha Inicio (yy/mm/dd):",
                ),
              ),
              SizedBox(
                height: 15,
              ),
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
                      icon: const Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.deepPurple,
                      ),
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
                          value: 'Celebracion',
                          child: Text("Celebracion Navideña"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: fechaF,
                decoration: InputDecoration(
                  labelText: "Fecha Final (yy/mm/dd):",
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
                      icon: const Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.deepPurple,
                      ),
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
                          child: Text("Después Evento"),
                        ),
                        DropdownMenuItem<bool>(
                          value: false,
                          child: Text("En Evento"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      var basedatos = {
                        'id': ID,
                        'descripcion': descripcion.text,
                        'fechaI': fechaI.text,
                        'tipoE': dropdownValue,
                        'fechaF': fechaF.text,
                        'permiso': dropdownValue2,
                      };
                      DB.actualizar(basedatos).then((value) {
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("E V E N T O  A C T U A L I Z A D O"),
                            ),
                          );
                          Navigator.pop(context);
                        });
                      });
                      descripcion.text = "";
                      fechaI.text = "";
                      fechaF.text = "";
                      dropdownValue = 'Baby Shower';
                      dropdownValue2 = false;
                    },
                    child: Text("Actualizar"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Cancelar"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
