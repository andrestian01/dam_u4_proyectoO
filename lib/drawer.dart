import 'package:dam_u4_p1/Screens/Welcome/welcome_screen.dart';
import 'package:dam_u4_p1/agregarevento.dart';
import 'package:dam_u4_p1/configuracion.dart';
import 'package:dam_u4_p1/crearevento.dart';
import 'package:dam_u4_p1/invitacionevento.dart';
import 'package:dam_u4_p1/menu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class P01 extends StatefulWidget {
  const P01({super.key});

  @override
  State<P01> createState() => _P01State();
}

class _P01State extends State<P01> {
  Widget page = MainScreen();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: Builder(
        builder: (context) {
          return MenuScreen(
            onPageChanged: (a) {
              setState(() {
                page = a;
              });
              ZoomDrawer.of(context)!.close();
            },
          );
        },
      ),
      mainScreen: page,
      borderRadius: 24.0,
      showShadow: true,
      drawerShadowsBackgroundColor: Colors.deepPurple.shade300,
      menuBackgroundColor: Colors.deepPurpleAccent.shade100,
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "C R E A N D O  M E M O R I A S",
          style: TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: Icon(Icons.menu),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(50),
        children: [
          Center(
            child: Text(
              "B I E N V E N I D O",
              style: TextStyle(
                color: Colors.green.shade300,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20,),
          Image.asset("assets/bs3.jpg", width: 200, height: 150,),
          SizedBox(height: 10,),
          Image.asset("assets/c3.jpg", width: 200, height: 150,),
          SizedBox(height: 10,),
          Image.asset("assets/n3.jpg", width: 200, height: 150,),
        ],
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  MenuScreen({Key? key, required this.onPageChanged}) : super(key: key);
  final Function(Widget) onPageChanged;

  List<ListItems> drawerItems = [
    ListItems(Icon(Icons.home, color: Colors.white,), Text("Mis Eventos"), menuu()),
    ListItems(Icon(Icons.event_note, color: Colors.white,), Text("Crear Evento"), creaar()),
    //ListItems(Icon(Icons.code, color: Colors.white,), Text("Generar Código"), generaar()),
    ListItems(Icon(Icons.book_online_rounded, color: Colors.white,), Text("Nueva Invitación"), agregarI()),
    ListItems(Icon(Icons.library_books, color: Colors.white,), Text("Invitaciones"), invitacion()),
    ListItems(Icon(Icons.settings, color: Colors.white,), Text("Configuración"), configuracioon()),
    ListItems(Icon(Icons.logout, color: Colors.white,), Text("Cerrar Sesión"), Cerrar()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent.shade100,
      body: Theme(
        data: ThemeData.dark(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: drawerItems.map((e) => ListTile(
            onTap: () {
              onPageChanged(e.page);
            },
            title: e.title,
            leading: e.icon,
          )).toList(),
        ),
      ),
    );
  }
}

class menuu extends StatelessWidget {
  const menuu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "M I S  E V E N T O S",
          style: TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: Icon(Icons.menu),
        ),
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.purple.shade50,
            child: const Text(
              "SB",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: Menu(),
    );
  }
}

class creaar extends StatelessWidget {
  const creaar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "C R E A R  E V E N T O",
          style: TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: Icon(Icons.menu),
        ),
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.purple.shade50,
            child: const Text(
              "SB",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: Crear(),
    );
  }
}

class generaar extends StatelessWidget {
  const generaar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "G E N E R A R  C Ó D I G O",
          style: TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: Icon(Icons.menu),
        ),
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.purple.shade50,
            child: const Text(
              "SB",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class agregarI extends StatelessWidget {
  const agregarI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "N U E V A  I N V I T A C I Ó N",
          style: TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: Icon(Icons.menu),
        ),
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.purple.shade50,
            child: const Text(
              "SB",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: AgregarEvento(),
    );
  }
}

class invitacion extends StatelessWidget {
  const invitacion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "I N V I T A C I O N E S",
          style: TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: Icon(Icons.menu),
        ),
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.purple.shade50,
            child: const Text(
              "SB",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: Invitaciones(),
    );
  }
}

class configuracioon extends StatelessWidget {
  const configuracioon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "C O N F I G U R A C I Ó N",
          style: TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: Icon(Icons.menu),
        ),
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.purple.shade50,
            child: const Text(
              "SB",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: Configuracion(),
    );
  }
}

class Cerrar extends StatelessWidget {
  const Cerrar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurpleAccent.shade100,
      child: InkWell(
        onTap: () async {
          // Cerrar sesión utilizando FirebaseAuth
          await FirebaseAuth.instance.signOut();

          // Redirigir a la pantalla de inicio de sesión o a donde desees
          Navigator.pushNamedAndRemoveUntil(context, "/welcome_screen", (route) => false);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(Icons.logout, color: Colors.white),
              ),
              Text(
                "Cerrar Sesión",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





class ListItems {
  final Icon icon;
  final Text title;
  final Widget page;

  ListItems(this.icon, this.title, this.page);
}
