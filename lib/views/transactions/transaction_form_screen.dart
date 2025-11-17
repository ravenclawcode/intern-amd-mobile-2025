import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';

class TransactionFormScreen extends StatefulWidget {
  final TransactionModel? data;

  const TransactionFormScreen({super.key, this.data});

  @override
  _TransactionFormScreenState createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController descC = TextEditingController();
  TextEditingController amountC = TextEditingController();
  String type = "income";
  String? imagePath;

  @override
  void initState() {
    if (widget.data != null) {
      descC.text = widget.data!.description;
      amountC.text = widget.data!.amount.toString();
      type = widget.data!.type;
      imagePath = widget.data!.imagePath;
    }
    super.initState();
  }

  Future pickImage() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() => imagePath = photo.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.data == null ? "Tambah Transaksi" : "Edit Transaksi")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: descC,
                decoration: InputDecoration(labelText: "Deskripsi"),
                validator: (v) => v!.isEmpty ? "Deskripsi wajib diisi" : null,
              ),
              TextFormField(
                controller: amountC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Nominal"),
                validator: (v) => v!.isEmpty ? "Nominal wajib diisi" : null,
              ),
              DropdownButtonFormField(
                initialValue: type,
                items: [
                  DropdownMenuItem(value: "income", child: Text("Pemasukan")),
                  DropdownMenuItem(value: "expense", child: Text("Pengeluaran")),
                ],
                onChanged: (v) {
                  setState(() => type = v.toString());
                },
              ),
              SizedBox(height: 20),

              // Gambar
              if (imagePath != null)
                Image.file(File(imagePath!), height: 150),

              TextButton.icon(
                icon: Icon(Icons.image),
                label: Text("Upload Gambar"),
                onPressed: pickImage,
              ),

              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Simpan"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final trx = TransactionModel(
                      id: widget.data?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      description: descC.text,
                      amount: int.parse(amountC.text),
                      type: type,
                      imagePath: imagePath,
                      date: DateTime.now().toIso8601String(),
                    );

                    if (widget.data == null) {
                      provider.addTransaction(trx);
                    } else {
                      provider.updateTransaction(trx);
                    }

                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
