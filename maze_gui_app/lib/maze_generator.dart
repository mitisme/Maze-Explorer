import 'dart:math';

enum Space {
  empty,
  wall,
  entrance,
  exit,
  unexplored,
  explored,
  current,
  outline
}

extension SpaceValue on Space {
  int get value {
    switch (this) {
      case Space.wall:
        return 1;
      case Space.entrance:
        return 2;
      case Space.exit:
        return 3;
      case Space.unexplored:
        return 4;
      case Space.explored:
        return 5;
      case Space.current:
        return 6;
      case Space.outline:
        return 7;
      case Space.empty:
        return 8;
      default:
        return -1;
    }
  }
}

class MazeSize {
  int rows;
  int cols;

  MazeSize(this.rows, this.cols);
}

class Maze {
  late MazeSize size;
  List<List<int>> grid = [];

  Maze(int rows, int cols) {
    size = MazeSize(rows, cols);
    grid = generate(cols, rows);
  }

List<int> pickSide(int side, int cols, int rows) {
  var random = Random();
  switch(side) {
    //top
    case 0:
      var pos = 1 + random.nextInt(cols - 1);
      return [side, pos];
    //bottom
    case 1:
      var pos = 1 + random.nextInt(cols - 1);
      return [side, pos];
    //left
    case 2:
      var pos = 1 + random.nextInt(rows - 1);
      return [side, pos];
    //right
    case 3:
      var pos = 1 + random.nextInt(rows - 1);
      return [side, pos];
  }
  throw new Exception("Side not found: $side");
}

List<List<int>> generate(int cols, int rows) {
  //creates an empty 2d array for the maze
  var maze = <List<int>>[];
  //Init the maze with values
  for(int i = 0; i < rows; i++) {
    List<int> row = [];
    for(int j = 0; j < cols; j++) {
      if(i ==0 || j == 0 || i == rows - 1 || j == cols - 1) {
        row.add(Space.wall.value);
      }
      else
        row.add(Space.empty.value); // Add emptySpace to row
    }
    maze.add(row); // Add the row to the maze
  }

  createPath(maze, cols, rows);
  EnterAndExit(maze, cols, rows);
  fillIn(maze, cols, rows);

  return maze;
}


void createPath(List<List<int>> maze, int cols, int rows) {
  var random = Random();
  var stack = <List<int>>[];

  // Start from a random position within the maze
  int startRow = random.nextInt(rows - 2) + 1;
  int startCol = random.nextInt(cols - 2) + 1;
  maze[startRow][startCol] = Space.unexplored.value;
  stack.add([startRow, startCol]);

  while (stack.isNotEmpty) {
    var current = stack.last;
    List<List<int>> neighbors = getUnvisitedNeighbors(current, maze, cols, rows);

    if (neighbors.isNotEmpty) {
      var next = neighbors[random.nextInt(neighbors.length)];
      // Carve a path to the next cell
      int midRow = (current[0] + next[0]) ~/ 2;
      int midCol = (current[1] + next[1]) ~/ 2;
      maze[next[0]][next[1]] = Space.unexplored.value;
      maze[midRow][midCol] = Space.unexplored.value;
      stack.add(next);
    } else {
      stack.removeLast();
    }
  }
}

List<List<int>> getUnvisitedNeighbors(List<int> cell, List<List<int>> maze, int cols, int rows) {
  List<List<int>> neighbors = [];
  List<List<int>> directions = [[-2, 0], [2, 0], [0, -2], [0, 2]];

  for (var dir in directions) {
    int newRow = cell[0] + dir[0];
    int newCol = cell[1] + dir[1];
    if (isValidMove(maze, newRow, newCol, rows, cols)) {
      neighbors.add([newRow, newCol]);
    }
  }

  return neighbors;
}

bool isValidMove(List<List<int>> maze, int row, int col, int rows, int cols) {
  return row > 0 && row < rows - 1 && col > 0 && col < cols - 1 && maze[row][col] == Space.empty.value;
}




void EnterAndExit( List<List<int>> maze, int cols, int rows) {
  bool entrancePlaced = false;
  bool exitPlaced = false;
  var random = new Random();
  int startSide = 0;

  while(!entrancePlaced) {
    //chose a side
    int side = random.nextInt(4);
    startSide = side;
    switch (side) {
      //top
      case 0:
        for(int i = 5; i < cols - 1; i++) {
          if(maze[1][i] == Space.unexplored.value) {
              maze[0][i] = Space.entrance.value;
              entrancePlaced = true;
              break;
          }
        }
      //bottom
      case 1:
        for(int i = 5; i < cols - 1; i++) {
          if(maze[rows-2][i] == Space.unexplored.value) {
              maze[rows-1][i] = Space.entrance.value;
              entrancePlaced = true;
              break;
          }
        }
      //left
      case 2:
        for(int i = 5; i < rows - 1; i++) {
          if(maze[i][1] == Space.unexplored.value) {
              maze[i][0] = Space.entrance.value;
              entrancePlaced = true;
              break;
          }
        }
      //right
      case 3:
        for(int i = 5; i < rows - 1; i++) {
          if(maze[i][cols-2] == Space.unexplored.value) {
              maze[i][cols-1] = Space.entrance.value;
              entrancePlaced = true;
              break;
          }
        }
    }

  }
  while(!exitPlaced) {
    //chose a side
    int side = random.nextInt(4);
    while(side == startSide) {
      side = random.nextInt(4);
    }
    switch (side) {
      //top
      case 0:
        for(int i = 5; i < cols - 1; i++) {
          if(maze[1][i] == Space.unexplored.value) {
              maze[0][i] = Space.exit.value;
              exitPlaced = true;
              break;
          }
        }
      //bottom
      case 1:
        for(int i = 5; i < cols - 1; i++) {
          if(maze[rows-2][i] == Space.unexplored.value) {
              maze[rows-1][i] = Space.exit.value;
              exitPlaced = true;
              break;
          }
        }
      //left
      case 2:
        for(int i = 5; i < rows - 1; i++) {
          if(maze[i][1] == Space.unexplored.value) {
              maze[i][0] = Space.exit.value;
              exitPlaced = true;
              break;
          }
        }
      //right
      case 3:
        for(int i = 5; i < rows - 1; i++) {
          if(maze[i][cols-2] == Space.unexplored.value) {
              maze[i][cols-1] = Space.exit.value;
              exitPlaced = true;
              break;
          }
        }
    }

  }

}

  void fillIn(List<List<int>> maze, int cols, int rows) {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        if(maze[i][j] == Space.empty.value) {
          maze[i][j] = Space.wall.value;
        }
      }
    }
  }


}
void printMaze(Maze maze) {
  //clears the terminal
  print(ANSIColors.clearScreen);

  for (List<int> row in maze.grid) {
    List<String> strRow = [];
    for(int i = 0; i < row.length; i++) {
      switch(row[i]) {
        case 1:
          strRow.add("${ANSIColors.magenta}#${ANSIColors.reset}");
        case 2:
          strRow.add("${ANSIColors.green}S${ANSIColors.reset}");
        case 3:
          strRow.add("${ANSIColors.blue}E${ANSIColors.reset}");
        case 4:
          strRow.add("${ANSIColors.yellow}~${ANSIColors.reset}");
        case 5:
          strRow.add("${ANSIColors.red}*${ANSIColors.reset}");
        case 6:
          strRow.add("!${ANSIColors.reset}");
        case 7:
          strRow.add("@${ANSIColors.reset}");
        case 8:
          strRow.add("${ANSIColors.red}o${ANSIColors.reset}");
       } 
    }
    print(strRow.join(' '));
  }
}

class ANSIColors {
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';
  static const String reset = '\x1B[0m';
  static const String clearScreen = '\x1B[2J\x1B[0;0H'; 
}