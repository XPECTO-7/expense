import 'package:expense/database/expense_database.dart';
import 'package:expense/helper/helper_page.dart';
import 'package:expense/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //text controller
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState(){
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();

    super.initState();
  }
  
  //open new expense box
  void newExpenseBox() {
    showDialog(context: context,
     builder: (context)=>AlertDialog(
      title: const Text('New Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //user input -> expense name
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: "Name"
            ),
          ),
          //expense amount
          TextField(
            controller: amountController,
            decoration: const InputDecoration(
              hintText: "Amount"
            ),
          ),
        ],
      ),
      actions: [
        //cancel button
        _cancelButton(),
        //save button
        _createNewExpenseButton()
      ],
    ));      
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, value, child) => Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: newExpenseBox,
      child: const Icon(Icons.add),),
      body: ListView.builder(
        itemCount: value.allExpense.length,
        itemBuilder: (context, index) {
          //get individual expense
          Expense individualExpense =value.allExpense[index];
          //return list tile
          return ListTile(
            title: Text(individualExpense.name),
            trailing: Text(individualExpense.amount.toString()),
          );
        },
        ),
      ),);
  }


//cancelbutton
Widget _cancelButton() {
  return MaterialButton(onPressed: () {
    //pop box
    Navigator.pop(context);
    //clear inputs
    nameController.clear();
    amountController.clear();
  },
  child: const Text('Cancel'),
  );
}

//saveButton
Widget _createNewExpenseButton() {
  return MaterialButton(onPressed: () async {

    //only save if there is something in the textfield
   if(nameController.text.isNotEmpty && amountController.text.isNotEmpty){
    //pop the box
    Navigator.pop(context);

    //create new expense
    Expense newExpense = Expense(
      name: nameController.text,
     amount: convertStringToDouble(amountController.text),
      date: DateTime.now()
      );

    //save to db
    await context.read<ExpenseDatabase>().createNewExpense(newExpense);

    //clear controllers
    nameController.clear();
    amountController.clear();
   }
  },
  child: const Text('Save'),
  );
}
}