import 'dart:io';
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/currency_format.dart';
import '../views/transactions/transaction_form_screen.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel data;

  const TransactionItem(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListTile(
        leading: data.imagePath == null
            ? CircleAvatar(child: Icon(Icons.receipt))
            : CircleAvatar(backgroundImage: FileImage(File(data.imagePath!))),
        title: Text(data.description),
        subtitle: Text(
          "${formatRupiah(data.amount)} • ${data.date.substring(0, 10)}",
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "edit",
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text("Edit"),
                ],
              ),
            ),
            PopupMenuItem(
              value: "delete",
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18),
                  SizedBox(width: 8),
                  Text("Hapus"),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == "edit") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionFormScreen(data: data),
                ),
              );
            } else if (value == "delete") {
              provider.deleteTransaction(data.id);
            }
          },
        ),
      ),
    );
  }
}
