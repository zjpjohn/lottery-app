import 'package:flutter/material.dart';

class FastTable {
  //速查表信息
  static List<List<String>> fast_table = [
    ["8", "3", "7", "3", "6", "1", "7", "7", "4", "4", "2", "2", "8"],
    ["5", "1", "2", "2", "0", "6", "1", "9", "7", "6", "4", "0", "5"],
    ["2", "5", "4", "7", "2", "3", "8", "4", "9", "7", "3", "4", "2"],
    ["2", "4", "1", "6", "5", "9", "3", "4", "5", "1", "9", "3", "2"],
    ["1", "2", "0", "5", "8", "8", "6", "7", "4", "8", "8", "6", "1"],
    ["4", "3", "7", "4", "0", "9", "3", "0", "3", "4", "0", "5", "4"],
    ["8", "5", "9", "2", "4", "5", "7", "8", "4", "2", "0", "7", "8"],
    ["7", "0", "0", "6", "9", "6", "4", "9", "9", "8", "9", "7", "7"],
    ["0", "6", "4", "0", "7", "5", "8", "3", "8", "6", "2", "3", "0"],
    ["8", "3", "0", "7", "1", "7", "2", "6", "0", "9", "4", "6", "8"],
    ["2", "1", "1", "1", "8", "0", "6", "5", "5", "6", "1", "4", "2"],
    ["6", "4", "0", "4", "2", "1", "1", "6", "3", "5", "1", "3", "6"],
    ["8", "9", "0", "0", "0", "2", "7", "3", "5", "3", "4", "3", "8"],
    ["8", "5", "0", "2", "8", "3", "0", "1", "8", "9", "7", "5", "8"],
    ["1", "7", "4", "4", "2", "7", "8", "4", "8", "6", "0", "7", "1"],
    ["6", "8", "9", "2", "8", "1", "5", "4", "2", "7", "9", "1", "6"],
    ["8", "3", "7", "3", "6", "1", "7", "7", "4", "4", "2", "2", "8"]
  ];

  static List<List<bool>> chkBall(List ball) {
    List<List<bool>> chkResult = List<List<bool>>();
    for (int i = 0; i < fast_table.length; i++) {
      List<bool> chk = List();
      for (int j = 0; j < fast_table[i].length; j++) {
        chk.add(false);
      }
      chkResult.add(chk);
    }
    if (ball != null && ball.length == 3) {
      for (int i = 0; i < fast_table.length; i++) {
        List<String> row = fast_table[i];
        for (int j = 0; j < fast_table[i].length; j++) {
          String element = row[j];
          position(ball, element, i, j, chkResult);
        }
      }
    }
    return chkResult;
  }

  static void position(List ball, String element, int row, int column,
      List<List<bool>> chkTable) {
    //百位判断
    if (ball[0] != element) {
      return;
    }
    //十位查找
    int sRowMinus = row - 1;
    int sRowPlus = row + 1;
    int sColMinus = column - 1;
    int sColPlus = column + 1;
    List<int> rows = List();
    rows.add(row);
    if (sRowMinus >= 0) {
      rows.add(sRowMinus);
    }
    if (sRowPlus <= 16) {
      rows.add(sRowPlus);
    }
    List<int> columns = List();
    columns.add(column);
    if (sColMinus >= 0) {
      columns.add(sColMinus);
    }
    if (sColPlus <= 12) {
      columns.add(sColPlus);
    }
    List<RCResult> shis = List();
    for (int i = 0; i < rows.length; i++) {
      int r = rows[i];
      for (int j = 0; j < columns.length; j++) {
        int c = columns[j];
        if ((r != row || c != column) && ball[1] == fast_table[r][c]) {
          RCResult value = RCResult()
            ..v = fast_table[r][c]
            ..row = r
            ..column = c;
          shis.add(value);
        }
      }
    }
    if (shis.length == 0) {
      return;
    }
    //个位查找
    for (int i = 0; i < shis.length; i++) {
      RCResult shi = shis[i];
      int gRowMinus = shi.row - 1;
      int gRowPlus = shi.row + 1;
      int gColumnMinus = shi.column - 1;
      int gColumnPlus = shi.column + 1;
      List<int> gRows = List();
      gRows.add(shi.row);
      if (gRowMinus >= 0) {
        gRows.add(gRowMinus);
      }
      if (gRowPlus <= 16) {
        gRows.add(gRowPlus);
      }
      List<int> gColumns = List();
      gColumns.add(shi.column);
      if (gColumnMinus >= 0) {
        gColumns.add(gColumnMinus);
      }
      if (gColumnPlus <= 12) {
        gColumns.add(gColumnPlus);
      }
      for (int i = 0; i < gRows.length; i++) {
        int r = gRows[i];
        for (int j = 0; j < gColumns.length; j++) {
          int c = gColumns[j];
          if ((r != shi.row || c != shi.column) &&
              ball[2] == fast_table[r][c]) {
            chkTable[row][column] = true;
            chkTable[shi.row][shi.column] = true;
            chkTable[r][c] = true;
          }
        }
      }
    }
  }

  static List<List<RenderResult>> renderTable(
    List<List<bool>> lastTable,
    List<List<bool>> lastShi,
    List<List<bool>> currShi,
  ) {
    List<List<RenderResult>> renderTable = List();
    for (int i = 0; i < fast_table.length; i++) {
      List<RenderResult> rows = List();
      for (int j = 0; j < fast_table[j].length; j++) {
        bool last = lastTable[i][j];
        bool last_shi = lastShi[i][j];
        bool current = currShi[i][j];
        RenderResult render = RenderResult();
        render.key = fast_table[i][j];
        if (last && last_shi && current) {
          render.color = Color(0xfff48f7b);
        } else if (last && current) {
          render.color = Color(0xfff6ab72);
        } else if (last_shi && current) {
          render.color = Color(0xffedca81);
        } else if (last) {
          render.color = Color(0xffe4c4cd);
        } else if (last_shi) {
          render.color = Color(0xffb0c8a5);
        } else if (current) {
          render.color = Color(0xffbab0b0);
        } else {
          render.color = Colors.white;
        }
        rows.add(render);
      }
      renderTable.add(rows);
    }
    return renderTable;
  }
}

class RCResult {
  String v;
  int row;
  int column;

  RCResult();
}

class RenderResult {
  String key;
  Color color;

  RenderResult();
}
