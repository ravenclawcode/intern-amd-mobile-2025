import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../../utils/currency_format.dart';
import 'transaction_form_screen.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel data;

  const TransactionDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Transaksi"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionFormScreen(data: data),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              provider.deleteTransaction(data.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            if (data.imagePath != null)
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(File(data.imagePath!)),
                  ),
                ),
              ),

            SizedBox(height: 20),

            Text(
              "Deskripsi",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(data.description, style: TextStyle(fontSize: 15)),

            SizedBox(height: 20),

            Text(
              "Nominal",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(formatRupiah(data.amount), style: TextStyle(fontSize: 15)),

            SizedBox(height: 20),

            Text(
              "Jenis Transaksi",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              data.type == "income" ? "Pemasukan" : "Pengeluaran",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 20),
            Text(
              "Tanggal",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(data.date.substring(0, 10), style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
