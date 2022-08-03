import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_expense_tracker/Widgets/new_transaction_form.dart';
import 'package:personal_expense_tracker/Widgets/transaction_list.dart';
// import 'package:intl/intl.dart';
import 'Widgets/chart.dart';

import './models/transcation.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense Tracker',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.tealAccent,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              button:
                  TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final title = 12;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Laptop',
    //   amount: 70000,
    //   time: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'New earphones',
    //   amount: 750,
    //   time: DateTime.now(),
    // )
  ];
  void _addTransaction(
      String newTitle, double newAmount, DateTime selectedDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: newTitle,
      amount: newAmount,
      time: selectedDate,
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void startNewAddTransaction(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return NewTransactionForm(_addTransaction);
      },
    );
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.time.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  bool _showChart = false;

  List<Widget> _buildLandScapeContent(Widget chartWidget, Widget txWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ShowChart',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          Switch(
            value: _showChart,
            onChanged: (val) {
              print(_showChart);
              setState(() {
                _showChart = val;
                print(_showChart);
              });
            },
          )
        ],
      ),
      _showChart ? txWidget : chartWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
      Widget txWidget, MediaQueryData mediaQuery, AppBar appBar) {
    return [
      Container(
        height: (mediaQuery.size.height -
                mediaQuery.padding.vertical -
                appBar.preferredSize.height) *
            0.3,
        width: double.infinity,
        child: Chart(_recentTransactions),
      ),
      txWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      actions: [
        IconButton(
          onPressed: () => startNewAddTransaction(context),
          icon: Icon(Icons.add),
        ),
      ],
      title: Text('Expense Tracker'),
    );
    final chartWidget = Container(
      height: (mediaQuery.size.height -
              mediaQuery.padding.vertical -
              appBar.preferredSize.height) *
          0.7,
      width: double.infinity,
      child: Chart(_recentTransactions),
    );
    final txWidget = Container(
      height: (mediaQuery.size.height -
              mediaQuery.padding.vertical -
              appBar.preferredSize.height) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    return Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () => startNewAddTransaction(context),
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (_isLandscape) ..._buildLandScapeContent(txWidget, chartWidget),
            if (!_isLandscape)
              ..._buildPortraitContent(txWidget, mediaQuery, appBar)
          ],
        ),
      ),
    );
  }
}
