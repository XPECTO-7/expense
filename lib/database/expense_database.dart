import 'package:expense/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expense> _allExpense = [];
  /*
  S E T U P

  */
  //initialize the database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  /*
  G E T T E R S

  */
  List<Expense> get allExpense => _allExpense;
  /*
  O P E R A T I O N S
  */

  //crete a new expense
  Future<void> createNewExpense(Expense newExpense) async {
    //add to db
    await isar.writeTxn(() => isar.expenses.put(newExpense));

    //re read from db
   await readExpenses();
  }
  //read expenses from database
  Future<void> readExpenses() async {
    //fetch frm db the existing
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();

    //give to local list
    _allExpense.clear();
    _allExpense.addAll(fetchedExpenses);
    //update ui
    notifyListeners();
  }
  //update expense
  Future<void> updateExpense(int id,Expense updatedExpense)async {
    //make sure same id
    updatedExpense.id =id;

    //update db
    await isar.writeTxn(() => isar.expenses.put(updatedExpense));
    //reread
    readExpenses();
  }
  //delete
  Future<void> deleteExpense(int id)async {
    //delete from db
    await isar.writeTxn(() => isar.expenses.delete(id));
    //re read from db
    await readExpenses();
  }
  /*
    H E L P E R
   */
}