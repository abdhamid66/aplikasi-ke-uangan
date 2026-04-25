import 'package:flutter/material.dart';

class DialogTambah extends StatefulWidget {
  final Function(bool) tambahTransaksi;
  final TextEditingController namaController;
  final TextEditingController nominalController;

  const DialogTambah({
    super.key,
    required this.tambahTransaksi,
    required this.namaController,
    required this.nominalController,
  });

  @override
  State<DialogTambah> createState() => _DialogTambahState();
}

class _DialogTambahState extends State<DialogTambah> {
  bool isPemasukan = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                "Tambah Transaksi",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 15),

              TextField(
                controller: widget.namaController,
                decoration: InputDecoration(labelText: "Nama"),
              ),

              TextField(
                controller: widget.nominalController,
                decoration: InputDecoration(labelText: "Nominal"),
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceChip(
                    label: Text("Pemasukan"),
                    selected: isPemasukan,
                    onSelected: (val) {
                      setState(() {
                        isPemasukan = true;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: Text("Pengeluaran"),
                    selected: !isPemasukan,
                    onSelected: (val) {
                      setState(() {
                        isPemasukan = false;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Batal"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.tambahTransaksi(isPemasukan);
                        Navigator.pop(context);
                      },
                      child: Text("Simpan"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}