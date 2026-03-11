import 'package:flutter/material.dart';

void main() {
  runApp(const GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // CRITICAL: Always explicitly set initialRoute and map it in routes
      initialRoute: '/',
      routes: {
        '/': (context) => const TicTacToeScreen(),
      },
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  // The board is a list of 9 strings, initially empty.
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  String winner = '';
  bool isDraw = false;

  void _handleTap(int index) {
    // Ignore tap if cell is already filled or game is over
    if (board[index] != '' || winner != '') return;

    setState(() {
      board[index] = isXTurn ? 'X' : 'O';
      isXTurn = !isXTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    // All possible winning combinations (indices of the 3x3 grid)
    List<List<int>> winningLines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6]             // Diagonals
    ];

    for (var line in winningLines) {
      if (board[line[0]] != '' &&
          board[line[0]] == board[line[1]] &&
          board[line[1]] == board[line[2]]) {
        winner = board[line[0]];
        return;
      }
    }

    // Check for draw
    if (!board.contains('')) {
      isDraw = true;
    }
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      winner = '';
      isDraw = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String statusText;
    if (winner != '') {
      statusText = 'Player $winner Wins! 🎉';
    } else if (isDraw) {
      statusText = 'It\'s a Draw! 🤝';
    } else {
      statusText = 'Player ${isXTurn ? 'X' : 'O'}\'s Turn';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status Indicator
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  statusText,
                  key: ValueKey<String>(statusText),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: winner != '' 
                        ? Colors.greenAccent 
                        : (isDraw ? Colors.orangeAccent : Colors.white),
                  ),
                ),
              ),
            ),
            
            // Game Board
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _handleTap(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: board[index] == '' 
                                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                                  : Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                board[index],
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: board[index] == 'X' 
                                      ? Colors.blueAccent 
                                      : Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Reset Button
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0, top: 16.0),
              child: ElevatedButton.icon(
                onPressed: _resetGame,
                icon: const Icon(Icons.refresh),
                label: const Text('Restart Game', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
