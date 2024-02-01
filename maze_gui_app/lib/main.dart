import 'package:flutter/material.dart';
import 'maze_generator.dart'; // Ensure proper import
import 'explorer.dart'; // Ensure proper import

void main() {
  runApp(MazeApp());
}

class MazeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maze Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color.fromARGB(255, 225, 225, 225), // Set the global background color here
      ),
      home: MazeHomePage(),
    );
  }
}

class MazeHomePage extends StatefulWidget {
  @override
  _MazeHomePageState createState() => _MazeHomePageState();
}

class _MazeHomePageState extends State<MazeHomePage> {
  late Maze maze;
  final TextEditingController rowController = TextEditingController();
  final TextEditingController colController = TextEditingController();
  final TextEditingController delayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    maze = Maze(20, 20); // Default size
  }

void generateNewMaze() async {
  int rows = int.tryParse(rowController.text) ?? 20;
  int cols = int.tryParse(colController.text) ?? 20;
  int delay = int.tryParse(delayController.text) ?? 50;

  setState(() {
    maze = Maze(rows, cols);
  });

  // Call DFS and pass a callback that updates the UI
  await DFS(maze, rows, cols, delay,() {
    setState(() {}); // This will refresh the UI after each exploration step
  });
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Maze Explorer (Avoid sizes smaller than 10x10 or greater than 70x70)'),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(4.0),
            child: TextField(
              controller: rowController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Rows',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: TextField(
              controller: colController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Columns',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: TextField(
              controller: delayController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Delay (milliseconds)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: generateNewMaze,
            child: Text('Generate Maze'),
          ),
          SizedBox(
            width: 500, // Fixed width for the maze
            height: 500, // Fixed height for the maze
            child: GridView.count(
              crossAxisCount: maze.size.cols,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              children: List.generate(maze.size.rows * maze.size.cols, (index) {
                int row = index ~/ maze.size.cols;
                int col = index % maze.size.cols;
                return Container(
                  decoration: BoxDecoration(
                    color: getColorForCell(maze.grid[row][col]),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    ),
  );
}

  Color getColorForCell(int cellType) {
    switch (cellType) {
      case 1: // Wall
        return const Color.fromARGB(255, 0, 0, 0);
      case 2: // Entrance
        return const Color.fromARGB(255, 42, 191, 47);
      case 3: // Exit
        return const Color.fromARGB(255, 225, 28, 14);
      case 4: // Unexplored
        return const Color.fromARGB(255, 255, 255, 255);
      case 5: // Explored
        return const Color.fromARGB(255, 13, 110, 189);
      default:
        return const Color.fromARGB(255, 150, 147, 147);
    }
  }
}
