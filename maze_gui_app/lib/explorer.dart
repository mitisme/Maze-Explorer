import 'maze_generator.dart';

//setup for stack in DFS
class Stack<E> {
  Stack() : _storage = <E>[];
  final List<E> _storage;

  void push(E e)=> _storage.add(e);
  E pop()=> _storage.removeLast();
  
  bool isEmpty() {
    if(_storage.isEmpty) {
      return true;
    }
    else {
      return false;
    }
  } 
}

List<int> getStart(Maze maze, int rows,int cols) {
  List<List<int>>curMaze = maze.grid;
  for (int i = 0; i < rows; i++) {
    for(int j = 0; j < cols; j++) {
      if(curMaze[i][j] == Space.entrance.value) {
        List<int> pos = [i,j];
        return pos;
      }
    }
  }
  throw new Exception("Cant find Start");
}

Future<void> DFS(Maze maze, int rows, int cols, int delay, Function updateUI) async {
 //stack for spaces to look at
 //list of visited positions
 var visited = [];
 Stack stack = new Stack();
List<List<int>>curMaze = maze.grid;
 //get start
 List<int> start = getStart(maze, rows, cols);
 //add to stack and visited
 stack.push(start);
 visited.add(start);
// boolean to see if exit is found
bool exitFound = false;


 while(!stack.isEmpty() && !exitFound) {
  var current = stack.pop();
  if(curMaze[current[0]][current[1]] != Space.entrance.value && curMaze[current[0]][current[1]] != Space.exit.value) {
    curMaze[current[0]][current[1]] = Space.explored.value;
  }
  //see if current cell is the exit, done if so
  if(curMaze[current[0]][current[1]] == Space.exit.value) {
    exitFound = true;
    break;
  }
  var neighbors  = getUnvisitedNeighborsDFS(current, curMaze, cols, rows);
    for(List<int>n in neighbors) {
      if(curMaze[n[0]][n[1]] == Space.exit.value) {
        exitFound = true;
        break;
      }
      stack.push(n);
      visited.add(n);
      curMaze[n[0]][n[1]] = Space.explored.value;
      maze.grid[n[0]][n[1]] = Space.explored.value;
    }
     updateUI();
     await Future.delayed(Duration(milliseconds: delay));
  }
}

List<List<int>> getUnvisitedNeighborsDFS(List<int> cell, List<List<int>> maze, int cols, int rows) {
  List<List<int>> neighbors = [];
  List<List<int>> directions = [[-1, 0], [1, 0], [0, -1], [0, 1]];

  for (var dir in directions) {
    int newRow = cell[0] + dir[0];
    int newCol = cell[1] + dir[1];
    if (isValidMoveDFS(maze, newRow, newCol, rows, cols)) {
      neighbors.add([newRow, newCol]);
    }
  }

  return neighbors;
}

bool isValidMoveDFS(List<List<int>> maze, int row, int col, int rows, int cols) {
  // Check if indices are within the bounds of the maze
  if (row < 0 || row >= rows || col < 0 || col >= cols) {
    return false;
  }

  // Check if the cell is the exit
  if (maze[row][col] == Space.exit.value) {
    return true;
  }

  // Check if the cell is unexplored
  return maze[row][col] == Space.unexplored.value;
}

