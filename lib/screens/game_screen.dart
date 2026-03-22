import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final String gameId;

  GameScreen({required this.gameId});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.generate(9, (_) => "");
  String currentPlayer = "X";

  String player1Name = "";
  String player2Name = "";

  String player1Uid = "";
  String player2Uid = "";

  String myPlayer = "";
  
  String myName = "";
  String mySymbol = "";

  String winner = "";
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    String myUid = user!.uid;

    FirebaseFirestore.instance
        .collection('games')
        .doc(widget.gameId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          board = List<String>.from(snapshot['board']);
          currentPlayer = snapshot['turn'];

          player1Name = snapshot['player1'];
          player2Name = snapshot['player2'];

          player1Uid = snapshot['player1_uid'] ?? "";
          player2Uid = snapshot['player2_uid'] ?? "";

          if (myPlayer.isEmpty) {
            if (myUid == player1Uid) {
              myPlayer = "X";
              myName = player1Name; 
              mySymbol = "X"; 
            } else if (myUid == player2Uid) {
              myPlayer = "O";
              myName = player2Name; 
              mySymbol = "O"; 
            }
          }

          checkWinner();
        });
      }
    });
  }

  Future<void> playMove(int index) async {

    if (currentPlayer != myPlayer) return;

    if (board[index] == "" && !isGameOver) {
      board[index] = currentPlayer;

      await FirebaseFirestore.instance
          .collection('games')
          .doc(widget.gameId)
          .update({
        'board': board,
        'turn': currentPlayer == "X" ? "O" : "X",
      });
    }
  }

  void checkWinner() {  
    if (isGameOver) return;

    bool hayGanador = false;
    String simboloGanador = "";

    List<List<int>> patterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], 
      [0, 3, 6], [1, 4, 7], [2, 5, 8], 
      [0, 4, 8], [2, 4, 6],           
    ];

    for (var p in patterns) {
      if (board[p[0]] != "" &&
          board[p[0]] == board[p[1]] &&
          board[p[1]] == board[p[2]]) {
        hayGanador = true;
        simboloGanador = board[p[0]]; 
        break; 
      }
    }


    if (hayGanador) {
      winner = simboloGanador;
      isGameOver = true;
    } else if (!board.contains("")) {
      winner = "Empate";
      isGameOver = true;
    }


    if (isGameOver) {
      String winnerName = "";
      
      if (winner == "Empate") {
        winnerName = "Empate"; 
      } else if (winner == "X") {
        winnerName = player1Name;
      } else if (winner == "O") {
        winnerName = player2Name;
      }

      if (winner == mySymbol && winner != "Empate") {
        final user = FirebaseAuth.instance.currentUser;
        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'wins': FieldValue.increment(1)});
      }

      Future.delayed(Duration(milliseconds: 800), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              winner: winnerName,
              username: myName,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00529e),
      appBar: AppBar(
        title: Text("Juego"),
        backgroundColor: Color(0xFF003f7d),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            myName.isEmpty
                ? "Esperando jugador..."
                : "Tú eres: $myName ($mySymbol)",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(
            "Turno: $currentPlayer",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              itemCount: 9,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => playMove(index),
                  child: Container(
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: board[index] == "X" ? Colors.blue : Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}