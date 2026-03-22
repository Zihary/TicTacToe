import 'package:flutter/material.dart';
import 'lobby_screen.dart';
import 'leaderboard_screen.dart'; 

class ResultScreen extends StatelessWidget {
  final String winner;
  final String username; 

  ResultScreen({required this.winner, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00529e),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              winner == "Empate"
                  ? Icons.handshake
                  : Icons.emoji_events,
              size: 100,
              color: Color(0xFFf8bb00),
            ),

            SizedBox(height: 20),

            Text(
              winner == "Empate"
                  ? "Empate"
                  : "Ganador: $winner",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFf8bb00),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LobbyScreen(username: username)),
                  (route) => false,
                );
              },
              child: Text("Volver a jugar", style: TextStyle(color: Colors.black)),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, 
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LeaderboardScreen()),
                );
              },
              child: Text("Ver Ranking", style: TextStyle(color: Colors.white)),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LobbyScreen(username: username)),
                  (route) => false,
                );
              },
              child: Text("Salir", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}