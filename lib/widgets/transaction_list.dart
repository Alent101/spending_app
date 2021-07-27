import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spending_app/models/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(
      {Key? key, required this.transactions, required this.deleteHandler})
      : super(key: key);

  final List<Transaction> transactions;
  final Function deleteHandler;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraint) {
            return Column(
              children: [
                Text(
                  'No transaction added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: constraint.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, idx) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FittedBox(
                        child: Text(
                            '\$${transactions[idx].amount.toStringAsFixed(2)}'),
                      ),
                    ),
                  ),
                  title: Text(
                    transactions[idx].title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat('yyyy/MM/dd').format(transactions[idx].date),
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: size.width > 460
                      ? TextButton.icon(
                          icon: Icon(Icons.delete),
                          style: TextButton.styleFrom(
                              primary: Theme.of(context).errorColor),
                          label: Text('Delete'),
                          onPressed: () => deleteHandler(transactions[idx].id),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          iconSize: 40,
                          color: Theme.of(context).errorColor,
                          onPressed: () => deleteHandler(transactions[idx].id),
                        ),
                ),
              );
            },
          );
  }
}
