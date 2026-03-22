import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lobby_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;
  String error = "";

  Future<void> authenticate() async {
    try {

      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        setState(() => error = "Completa los campos");
        return;
      }

      UserCredential userCredential;

      if (isLogin) {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {

        if (nombreController.text.isEmpty) {
          setState(() => error = "Ingresa tu nombre");
          return;
        }

        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': nombreController.text.trim(),
          'email': emailController.text.trim(),
          'wins': 0,
        });
      }

      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      String username = userDoc['name'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LobbyScreen(username: username),
        ),
      );

    } catch (e) {
      setState(() => error = "Error en autenticación");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF00529e),

      body: Center(
        child: SingleChildScrollView( 
          child: Padding(
            padding: EdgeInsets.all(20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  "TicTacToe Unison",
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 32, 
                    fontWeight: FontWeight.bold
                  ),
                ),

                SizedBox(height: 15),

                Image.asset(
                  'assets/logo.png',
                  height: 120, 
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image, size: 100, color: Colors.white54); 
                  },
                ),

                SizedBox(height: 15),

                Text(
                  "Desarrollado por:\nBarajas Miranda Zihary Leticia\nJose Jose Alex Gabi\nSalcido Gutierrez Daniel Antonio",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70, 
                    fontSize: 14,
                    fontStyle: FontStyle.italic
                  ),
                ),

                SizedBox(height: 30),

                if (!isLogin)
                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Nombre",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                if (!isLogin) SizedBox(height: 10),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Correo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Contraseña",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFf8bb00),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  onPressed: authenticate,
                  child: Text(
                    isLogin ? "Iniciar Sesión" : "Registrarse",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),

                SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                      error = "";
                    });
                  },
                  child: Text(
                    isLogin
                        ? "¿No tienes cuenta? Regístrate aquí"
                        : "¿Ya tienes cuenta? Inicia sesión",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                if (error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(error, style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}