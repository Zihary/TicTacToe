import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'game_screen.dart';
import 'leaderboard_screen.dart';

class LobbyScreen extends StatefulWidget {
  final String username;

  LobbyScreen({required this.username});

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {

  final codeController = TextEditingController();

  String generateCode() {
    return DateTime.now().millisecondsSinceEpoch.toString().substring(7);
  }

  Future<void> createGame() async {
    String code = generateCode();
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('games').doc(code).set({
      'board': List.generate(9, (_) => ""),
      'turn': 'X',
      'player1': widget.username,
      'player1_uid': user!.uid, 
      'player2': '',
      'player2_uid': '',
      'status': 'waiting',
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("Sala creada"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text("Código:"),

              SizedBox(height: 10),

              Text(
                code,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              ElevatedButton.icon(
                icon: Icon(Icons.copy),
                label: Text("Copiar"),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Copiado")),
                  );
                },
              ),

              SizedBox(height: 20),
              Text("Esperando jugador..."),
            ],
          ),
        );
      },
    );

    FirebaseFirestore.instance
        .collection('games')
        .doc(code)
        .snapshots()
        .listen((snapshot) {

      if (snapshot.exists && snapshot['status'] == 'playing') {

        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GameScreen(gameId: code),
          ),
        );
      }
    });
  }

  Future<void> joinGame() async {
    String code = codeController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    var doc = FirebaseFirestore.instance.collection('games').doc(code);
    var snapshot = await doc.get();

    if (snapshot.exists) {

      await doc.update({
        'player2': widget.username,
        'player2_uid': user!.uid, 
        'status': 'playing',
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(gameId: code),
        ),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Código inválido")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF00529e),

      appBar: AppBar(
        title: Text("Sala de Espera"),
        backgroundColor: Color(0xFF003f7d),
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                "Jugador: ${widget.username}",
                style: TextStyle(color: Colors.white),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: createGame,
                child: Text("Crear partida"),
              ),

              SizedBox(height: 20),

              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Código",
                ),
              ),

              SizedBox(height: 10),

              ElevatedButton(
                onPressed: joinGame,
                child: Text("Unirse"),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LeaderboardScreen(),
                    ),
                  );
                },
                child: Text("Ver Ranking"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}