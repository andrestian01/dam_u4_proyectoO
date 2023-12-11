import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'basedatos.dart';
import 'package:clipboard/clipboard.dart';

class Album extends StatefulWidget {
  final String eventID;
  final String? currentUserEmail;
  final String userRole;

  const Album({
    Key? key,
    required this.eventID,
    required this.currentUserEmail,
    required this.userRole,
  }) : super(key: key);

  @override
  State<Album> createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
  List<String> images = [];
  final ImagePicker _imagePicker = ImagePicker();

  TextEditingController propietarioController = TextEditingController();
  TextEditingController codigoController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController fechaFController = TextEditingController();
  TextEditingController fechaIController = TextEditingController();
  final tipoE = TextEditingController();
  bool permisoValue = true;
  String dropdownValue = "Baby Shower";
  bool dropdownValue2 = false;

  @override
  void initState() {
    super.initState();
    cargarDatosEvento();
  }

  void cargarDatosEvento() async {
    try {
      var datosEvento = await DB.mostrarEvento(widget.eventID);

      setState(() {
        propietarioController.text = datosEvento['propietario'] ?? "";
        codigoController.text = datosEvento['codigo'] ?? "";
        descripcionController.text = datosEvento['descripcion'] ?? "";
        fechaFController.text = datosEvento['fechaF'] ?? "";
        fechaIController.text = datosEvento['fechaI'] ?? "";
        tipoE.text = datosEvento['tipoE']??"";
        permisoValue = datosEvento['permiso'] ?? true;
      });

      cargarImagenes();
    } catch (error) {
      print("Error al cargar datos del evento: $error");
    }
  }

  void cargarImagenes() async {
    try {
      var storage = FirebaseStorage.instance;
      var carpetaEvento = storage.ref().child('imagenes/${codigoController.text}');
      var resultados = await carpetaEvento.listAll();
      var nuevasImages = await Future.wait(resultados.items.map((imagenRef) async {
        var url = await imagenRef.getDownloadURL();
        return url;
      }));

      setState(() {
        images = nuevasImages;
      });
    } catch (error) {
      print("Error al cargar las imágenes: $error");
    }
  }

  Future<void> _subirImagen() async {
    if (!permisoValue) {
      // Si permisoValue es false, muestra un mensaje y no permite subir imágenes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No tienes permiso para subir imágenes.'),
        ),
      );
      return;
    }

    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var storage = firebase_storage.FirebaseStorage.instance;
      var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      var referencia = storage.ref().child("imagenes/${codigoController.text}/$imageName");
      var file = File(pickedFile.path);

      await referencia.putFile(file).then((snapshot) async {
        var url = await snapshot.ref.getDownloadURL();

        setState(() {
          images.add(url);
        });
      });
    }
  }





  Future<void> _actualizarEvento() async {
    try {
      if (widget.currentUserEmail == propietarioController.text) {
        await DB.actualizar({
          'codigo': codigoController.text, // Include the 'codigo' field
          'descripcion': descripcionController.text,
          'fechaF': fechaFController.text,
          'fechaI': fechaIController.text,
          'permiso': permisoValue,
          'tipoE':tipoE.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Evento actualizado con éxito.'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Solo el propietario puede actualizar el evento.'),
        ));
      }
    } catch (error) {
      print("Error al actualizar el evento: $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ALBUM EVENTO'),
        actions: [
          IconButton(
            onPressed: (widget.userRole == "invitado") ? null : _actualizarEvento,
            icon: Icon(Icons.update),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Propietario", propietarioController, enabled: false),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField("Código", codigoController, enabled: false),
                    ),
                    IconButton(
                      onPressed: () {
                        // Copia el contenido del controlador al portapapeles
                        FlutterClipboard.copy(codigoController.text)
                            .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Código copiado al portapapeles.'),
                          ),
                        ));
                      },
                      icon: Icon(Icons.content_copy),
                    ),
                  ],
                ),

                (widget.userRole == "invitado") ? _buildTextField("Descripción", descripcionController,enabled: false) : _buildTextField("Descripción", descripcionController,enabled: true),
                (widget.userRole == "invitado") ? _buildTextField("Fecha Fin", fechaFController,enabled: false) : _buildTextField("Fecha Fin", fechaFController),
                (widget.userRole == "invitado") ? _buildTextField("Fecha Inicio", fechaIController,enabled: false) : _buildTextField("Fecha Inicio", fechaIController),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down_circle, color: Colors.deepPurple,),
                  underline: Container(
                    height: 1.5,
                    color: Colors.black26,
                  ),
                  onChanged: (widget.userRole == "invitado") ? null : (String? newValue) {
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
                Row(
                  children: [
                    Text("Permiso"),
                    Switch(
                      value: permisoValue,
                      onChanged: (widget.userRole == "invitado")
                          ? null : (value) {
                        setState(() {
                          permisoValue = value;
                        });
                      }, // Set onChanged to null for non-"propietario" roles
                    ),
                  ],
                )

              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.network(images[index]);
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _subirImagen,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
