import 'dart:math';
import 'package:sudokuflutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:sudokuflutter/screens/result_screen.dart';

Random random = Random();

class Game extends ChangeNotifier {
  Grid grid;
  List<dynamic> markedItems = [];
  List<List<int>> stack = [];
  Cell currentCellSelected;
  String currentAction;
  bool printIt = false;
  var context;
  Game({this.context}) {
    grid = Grid();
  }

  void resetGame() {
    markedItems = [];
    stack = [];
    currentCellSelected = null;
    currentAction = null;
    printIt = false;
    grid = Grid();
    notifyListeners();
  }

  void undo() {
    if (stack.length == 0) return;
    List<int> lapse = [...stack.last];
    stack.removeLast();
    int r = lapse[0], c = lapse[1];
    grid.puzzle.original[r][c] = lapse[2];
    int row = r ~/ 3;
    int col = c ~/ 3;
    r = r % 3;
    c = c % 3;
    Cell cell = grid.blocks[row][col].lines[r].cells[c];
    cell.value = lapse[2];
    if (lapse[2] == -1) {
      grid.puzzle.emptyCells.add([cell.row, cell.col]);
      cell.text = '';
    }
    setStyle(cell, cell.defaultStyle);
  }

  void getHint() {
    List<dynamic> selections;
    selections = grid.puzzle.getHint();
    if (selections[0]) {
      List<int> loc = grid.puzzle.emptyCells[selections[1]];
      int r = loc[0], c = loc[1];
      int row = r ~/ 3;
      int col = c ~/ 3;
      r = r % 3;
      c = c % 3;
      int ch = selections[2];
      grid.puzzle.emptyCells.removeAt(selections[1]);
      Cell cell = grid.blocks[row][col].lines[r].cells[c];
      cell.value = ch;
      printIt = !printIt;
      setStyle(cell, 'hint');
    } else {
      print('No hint available');
    }
  }

  void changeValue(int val) {
    if (currentCellSelected != null && !currentCellSelected.permanent) {
      if (val != 0) {
        if (currentCellSelected.text == '') {
          currentCellSelected.value = val;
          grid.associates[currentCellSelected.value].add(currentCellSelected);
          grid.puzzle.emptyCells.removeWhere((el) =>
              el[0] == currentCellSelected.row &&
              el[1] == currentCellSelected.col);
        } else if (currentCellSelected.text == val.toString()) {
          grid.associates[currentCellSelected.value]
              .remove(currentCellSelected);
          grid.puzzle.emptyCells
              .add([currentCellSelected.row, currentCellSelected.col]);
          currentCellSelected.text = '';
          currentCellSelected.value = -1;
        } else {
          grid.associates[currentCellSelected.value]
              .remove(currentCellSelected);
          grid.puzzle.emptyCells.removeWhere((el) =>
              el[0] == currentCellSelected.row &&
              el[1] == currentCellSelected.col);
          currentCellSelected.value = val;
          grid.associates[val].add(currentCellSelected);
        }
      } else {
        if (currentCellSelected.text != '') {
          grid.associates[currentCellSelected.value]
              .remove(currentCellSelected);
          currentCellSelected.value = -1;
          currentCellSelected.text = '';
          if (grid.puzzle.emptyCells.indexWhere((el) =>
                  el[0] == currentCellSelected.row &&
                  el[1] == currentCellSelected.col) ==
              -1)
            grid.puzzle.emptyCells
                .add([currentCellSelected.row, currentCellSelected.col]);
        }
      }
      printIt = !printIt;
      setStyle(currentCellSelected, currentAction);
    }
  }

  void setStyle(Cell cell, String action) {
    cell.isErrorSource = false;
    currentCellSelected = cell;
    currentAction = action;
    for (int i = markedItems.length - 1; i >= 0; i--) {
      markedItems[i].setStyle('defaultStyle', '', cell);
    }
    if (cell.text != '') {
      for (Cell associateCell in grid.associates[cell.value]) {
        if (associateCell.text != '') {
          associateCell.setStyle('associate', '', cell);
          markedItems.add(associateCell);
        }
      }
    }
    Line pathLine = cell.parent;
    Block pathBlock = pathLine.parent;
    pathBlock.setStyle('pathVisible', cell.text, cell);
    markedItems.add(pathBlock);
    for (int i = 0; i < 3; i++) {
      Line currentLine = grid.blocks[pathBlock.row][i].lines[pathLine.idx];
      currentLine.setStyle('pathVisible', cell.text, cell);
      markedItems.add(currentLine);
    }
    for (int i = 0; i < 3; i++) {
      Block currentBlock = grid.blocks[i][pathBlock.col];
      for (Line line in currentBlock.lines) {
        line.cells[cell.idx].setStyle('pathVisible', cell.text, cell);
        markedItems.add(line.cells[cell.idx]);
      }
    }
    if (!cell.permanent && printIt) {
      int bfr = grid.puzzle.original[cell.row][cell.col];
      grid.puzzle.original[cell.row][cell.col] = cell.value;
      stack.add([cell.row, cell.col, bfr]);
      if (grid.puzzle.emptyCells.length == 0) {
        if (grid.isGameOver()) {
          print('game over');
          resetGame();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultScreen()),
          );
          return;
        }
      }
    }
    if (printIt) printIt = false;
    cell.setStyle(action, '', cell);
    notifyListeners();
  }
}

class Grid {
  List<List<Block>> blocks = [];
//  List<List<int>> grid;
  Puzzle puzzle;
  Map<int, List<Cell>> associates = {
    1: [],
    2: [],
    3: [],
    4: [],
    5: [],
    6: [],
    7: [],
    8: [],
    9: []
  };
  Grid() {
    for (int i = 0; i < 3; i++) {
      blocks.add([]);
      for (int j = 0; j < 3; j++) {
        blocks[i].add(Block(row: i, col: j));
      }
    }
    initialize();
  }
  void initialize() {
//    grid = createPuzzle();
    puzzle = Puzzle();
    puzzle.createPuzzle();
//    grid = puzzle.grid;
    int br = -1, bc;
    for (int row = 0; row < 9; row++) {
      if (row % 3 == 0) br++;
      bc = -1;
      for (int col = 0; col < 9; col++) {
        if (col % 3 == 0) bc++;
        Cell cell = blocks[br][bc].lines[row % 3].cells[col % 3];
        cell.row = row;
        cell.col = col;
        cell.permanent = puzzle.isPermanent[row][col];
        cell.value = puzzle.original[row][col];
        if (cell.value != -1) associates[cell.value].add(cell);
      }
    }
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) blocks[i][j].makeList();
    }
  }

  bool isGameOver() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        for (Cell cell in blocks[i][j].cells)
          if (cell.isErrorSource) return false;
      }
    }
    return true;
  }
}

class Block {
  List<Line> lines = [];
  List<Cell> cells = [];
  int row, col;
  Block({this.row, this.col}) {
    for (int i = 0; i < 3; i++) lines.add(Line(parent: this, idx: i));
  }
  void initialize(List<int> choices) {
    for (Line line in lines) line.initialize(choices);
  }

  void setStyle(String action, String text, Cell origin) {
    for (Line line in lines) line.setStyle(action, text, origin);
  }

  void makeList() {
    for (Line line in lines) {
      for (Cell cell in line.cells) cells.add(cell);
    }
//    return vals;
  }
}

class Line {
  List<Cell> cells = [];
  Block parent;
  int idx;
  Line({this.parent, this.idx}) {
    for (int i = 0; i < 3; i++) cells.add(Cell(parent: this, idx: i));
  }
  void initialize(List<int> choices) {
    int choice = 0;
    for (Cell cell in cells) {
      cell.value = choices[choice];
      choices.removeAt(choice);
      choice++;
    }
  }

  void setStyle(String action, String text, Cell origin) {
    for (Cell cell in cells) cell.setStyle(action, text, origin);
  }
}

class Cell {
  int _val = 0, row, col;
  String _text = '';
  Line parent;
  bool isErrorSource = false;
  bool _isPermanent = true;
  String defaultStyle = 'plainTile';
  bool initialized = false;
  int idx;
  BoxDecoration _decoration;
  TextStyle _textStyle;
  Color blockContainerColor;

  bool get permanent => _isPermanent;
  set permanent(val) {
    _isPermanent = val;
    defaultStyle = val ? 'plainTile' : 'temporaryTile';
  }

  int get value => _val;
  set value(num) {
    if (permanent && !initialized) {
      _val = num;
      initialized = true;
      text = num.toString();
    } else {
      if (!permanent) {
        if (initialized) {
          _val = num;
          text = num.toString();
        } else {
          _val = num;
          initialized = true;
        }
      }
    }
  }

  String get text => _text;
  set text(num) {
    _text = num;
  }

  Cell({this.parent, this.idx}) {
    setStyle(defaultStyle, '', this);
  }

  BoxDecoration get decoration => _decoration;
  set decoration(style) {
    _decoration = style;
  }

  TextStyle get textStyle => _textStyle;
  set textStyle(style) {
    _textStyle = style;
  }

  void setStyle(String action, String temp, Cell origin) {
    if (temp == text && temp != '') {
      action = 'errorTile';
      if (this != origin) origin.isErrorSource = true;
    }
    switch (action) {
      case 'errorTile':
        blockContainerColor = kBackGroundColor;
        decoration = kCellBoxDecoration1.copyWith(color: kErrorBoxColor);
        textStyle = kCellTextStyle1.copyWith(
            color: permanent ? kPlainTextColor : kErrorTextColor);
        break;
      case 'defaultStyle':
        setStyle(defaultStyle, '', origin);
        break;
      case 'plainTile':
        decoration = kCellBoxDecoration2;
        textStyle = kCellTextStyle1;
        blockContainerColor = kBackGroundColor;
        break;
      case 'temporaryTile':
        decoration = kCellBoxDecoration2;
        textStyle = kCellTextStyle1.copyWith(
            color: isErrorSource ? kErrorTextColor : kTempTextColor);
        blockContainerColor = kBackGroundColor;
        break;
      case 'currentActive':
        blockContainerColor = kBlockContainerColor;
        textStyle = kCellTextStyle1.copyWith(
            color: permanent
                ? kPlainTextColor
                : isErrorSource ? kErrorTextColor : kTempTextColor);
        decoration = kCellBoxDecoration1.copyWith(
            border: Border.all(color: kTempTextColor, width: 0.8));
        break;
      case 'pathVisible':
        blockContainerColor = kBlockContainerColor;
        decoration = kCellBoxDecoration2.copyWith(color: kBlockContainerColor);
        break;
      case 'associate':
        blockContainerColor = kBackGroundColor;
        decoration = kCellBoxDecoration1;
        break;
      case 'hint':
        blockContainerColor = kBackGroundColor;
        decoration = kCellBoxDecoration1.copyWith(color: kHintBoxColor);
        textStyle = kCellTextStyle1.copyWith(color: kHintTextColor);
        break;
    }
  }
}

class Puzzle {
  List<List<int>> grid, original, emptyCells;
  List<List<bool>> isPermanent;
  List<int> temp;
  int fixedVisible = 40, variableVisible = 20;

  List<Object> rotate(List<Object> list, int v) {
    if (list == null || list.isEmpty) return list;
    var i = v % list.length;
    return list.sublist(i)..addAll(list.sublist(0, i));
  }

  void swapRows(int choice) {
    int ch;
    for (int i = 0; i < 3; i++) {
      ch = (choice * 3 + 2) - random.nextInt(3);
      temp = grid[ch];
      grid[ch] = grid[choice * 3 + i];
      grid[choice * 3 + i] = temp;
    }
  }

  void swapCols(int choice) {
    int ch, t, orig;
    for (int i = 0; i < 3; i++) {
      orig = choice * 3 + i;
      ch = (choice * 3 + 2) - random.nextInt(3);
      for (int j = 0; j < 9; j++) {
        t = grid[j][orig];
        grid[j][orig] = grid[j][ch];
        grid[j][ch] = t;
      }
    }
  }

  void swapNums(int a, int b) {
    for (List<int> row in grid) {
      for (int i = 0; i < 9; i++) {
        if (row[i] == a)
          row[i] = b;
        else if (row[i] == b) row[i] = a;
      }
    }
  }

  List<dynamic> getHint() {
    List<int> choices = List.generate(emptyCells.length, (index) => index);
    choices.shuffle(random);
    int choice, row, col, ch, r, c;
    List<int> temp;
    bool dummy = true;
    for (choice in choices) {
//    choice = random.nextInt(emptyCells.length);
      row = emptyCells[choice][0];
      col = emptyCells[choice][1];
      temp = List.generate(9, (index) => index + 1);
      temp.shuffle(random);
      for (ch in temp) {
        dummy = false;
        for (int i = 0; i < 9; i++)
          if (original[row][i] == ch || original[i][col] == ch) {
            dummy = true;
            break;
          }
        if (dummy) continue;
        r = (row ~/ 3) * 3;
        c = (col ~/ 3) * 3;
        for (int a = r; a < r + 3; a++)
          for (int b = c; b < c + 3; b++) {
            if (original[a][b] == ch) {
              dummy = true;
              break;
            }
          }
        if (!dummy) return [!dummy, choice, ch];
      }
      if (!dummy) {
//      original[row][col] = ch;
//      print('[${row + 1}][${col + 1}] Hint : $ch');
      } else {
        print('[${row + 1}][${col + 1}] No Hint : $ch');
      }
    }
    return [!dummy, choice, ch];
  }

  void createPuzzle() {
    List<int> orig = List.generate(9, (index) => index + 1);
    orig.shuffle(random);
    grid = [];
    grid.add([...orig]);
    for (int i = 1; i < 9; i++) {
      orig = i % 3 == 0 ? orig = rotate(orig, 1) : orig = rotate(orig, 3);
      grid.add([...orig]);
    }
    for (int i = 0; i <= random.nextInt(3); i++) {
      swapRows(random.nextInt(3));
      swapCols(random.nextInt(3));
      swapNums(random.nextInt(9) + 1, random.nextInt(9) + 1);
    }
    original = [];
    emptyCells = [];
    isPermanent = [];
    for (int r = 0; r < 9; r++) {
      original.add([]);
      isPermanent.add([]);
      for (int c = 0; c < 9; c++) {
//        original[r].add(grid[r][c]);
        original[r].add(-1);
        emptyCells.add([r, c]);
        isPermanent[r].add(false);
      }
    }
    int cnt = random.nextInt(variableVisible) + fixedVisible;
    int choice;
    while (cnt != 0) {
      cnt--;
      choice = random.nextInt(emptyCells.length);
      original[emptyCells[choice][0]][emptyCells[choice][1]] =
          grid[emptyCells[choice][0]][emptyCells[choice][1]];
      isPermanent[emptyCells[choice][0]][emptyCells[choice][1]] = true;
      emptyCells.removeAt(choice);
    }
  }
}

//void main() {
//  Puzzle puzzle = Puzzle();
//  puzzle.createPuzzle();
//  puzzle.printGrid();
//}

//void main() {
//  List<List<int>> puzzle = createPuzzle();
////  for (List<int> row in grid) print(row);
//  Grid grid = Grid();
//  grid.initialize(puzzle);
//  grid.showGrid();
//}
