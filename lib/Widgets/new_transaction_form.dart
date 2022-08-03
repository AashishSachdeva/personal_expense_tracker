import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransactionForm extends StatefulWidget {
  final Function addTransaction;
  NewTransactionForm(this.addTransaction);

  @override
  _NewTransactionFormState createState() => _NewTransactionFormState();
}

class _NewTransactionFormState extends State<NewTransactionForm> {
  final _titlecontroller = TextEditingController();

  final _amountcontroller = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _submitData() {
    final enteredAmount = double.parse(_amountcontroller.text);
    final enteredTitle = _titlecontroller.text;
    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }
    widget.addTransaction(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentdatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.grey[100],
        elevation: 8,
        // margin: EdgeInsets.all(5),
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(fontSize: 18),
                ),
                controller: _titlecontroller,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Amount",
                  labelStyle: TextStyle(fontSize: 20),
                ),
                controller: _amountcontroller,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                // margin: EdgeInsets.all(),
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                            "Picked Date: ${DateFormat.yMd().format(_selectedDate)}")),
                    TextButton(
                      onPressed: _presentdatePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                // style: ButtonStyle(textStyle:),
                onPressed: _submitData,
                child: Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
