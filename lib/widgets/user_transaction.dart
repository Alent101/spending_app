import 'package:flutter/material.dart';
import 'package:spending_app/widgets/new_transaction.dart';

class UserTransaction extends StatelessWidget {
  const UserTransaction({Key? key, required this.addTxHandler})
      : super(key: key);

  final Function addTxHandler;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NewTransaction(
          addTxHandler: addTxHandler,
        ),
      ],
    );
  }
}
