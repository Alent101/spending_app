import 'package:flutter/cupertino.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:spending_app/widgets/chart.dart';
import 'package:spending_app/widgets/new_transaction.dart';
import 'package:spending_app/widgets/transaction_list.dart';
import 'models/transaction.dart';

void main() {
  //強迫設置方向
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
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(title: 'Personal Expenses'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //開支列表
  final List<Transaction> _userTransactions = [];

  //取得當前7天內開支
  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
            (tx) => tx.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  //switch元件使用，用於是否顯示圖表
  bool _showChart = false;

  //新增交易
  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateFormat().format(DateTime.now()),
      title: title,
      amount: amount,
      date: chosenDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  //彈出新增交易Dialog
  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewTransaction(addTxHandler: _addNewTransaction);
        });
  }

  //刪除交易
  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    //取得螢幕尺寸
    final mediaQuery = MediaQuery.of(context);

    //判斷是否為橫向模式
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    //AppBar元件
    final appBar = AppBar(
      title: Text(widget.title),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
    //ios風格 AppBar
    final navigationBar = CupertinoNavigationBar(
      middle: Text(widget.title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
          ),
        ],
      ),
    );

    //交易列表元件
    final txListWidget = Container(
      height: (mediaQuery.size.height - appBar.preferredSize.height) * 0.7,
      child: TransactionList(
        transactions: _userTransactions,
        deleteHandler: _deleteTransaction,
      ),
    );

    final pageBody = SafeArea(
      child: ListView(
        children: [
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Show hart',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Switch.adaptive(
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    })
              ],
            ),
          if (isLandscape)
            _showChart
                ? Container(
                    height:
                        (mediaQuery.size.height - appBar.preferredSize.height) *
                            0.7,
                    child: Chart(recentTransactions: _recentTransactions),
                  )
                : txListWidget,
          if (!isLandscape)
            Container(
              height:
                  (mediaQuery.size.height - appBar.preferredSize.height) * 0.3,
              child: Chart(recentTransactions: _recentTransactions),
            ),
          if (!isLandscape) txListWidget,
        ],
      ),
    );
    ;

    return UniversalPlatform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: navigationBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
            body: pageBody,
          );
  }
}
