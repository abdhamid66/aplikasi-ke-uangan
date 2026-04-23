import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> transaksi = [];

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();

  bool isPemasukan = true;

  void tambahTransaksi() {
    setState(() {
      transaksi.add({
        "nama": namaController.text,
        "nominal": int.tryParse(nominalController.text) ?? 0,
        "isPemasukan": isPemasukan,
      });
    });

    namaController.clear();
    nominalController.clear();
  }

  int hitungSaldo() {
    int total = 0;

    for (var item in transaksi) {
      int nominal = item["nominal"] as int; // 👈 INI FIX

      if (item["isPemasukan"]) {
        total += nominal;
      } else {
        total -= nominal;
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CATATAN KEUANGAN"), centerTitle: true),

      body: Column(
        children: [
          // 🔹 SALDO
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text("Total Saldo", style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                Text(
                  "Rp ${hitungSaldo()}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 TOMBOL TAMBAH
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Tambah Transaksi"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: namaController,
                          decoration: InputDecoration(labelText: "Nama"),
                        ),

                        TextField(
                          controller: nominalController,
                          decoration: InputDecoration(labelText: "Nominal"),
                          keyboardType: TextInputType.number,
                        ),

                        SizedBox(height: 10),

                        Wrap(
                          spacing: 10,
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
                      ],
                    ),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Batal"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (namaController.text.isEmpty ||
                              nominalController.text.isEmpty) {
                            return;
                          }

                          tambahTransaksi();
                          Navigator.pop(context);
                        },
                        child: Text("Simpan"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text("+ Tambah Transaksi"),
          ),

          // 🔹 LIST TRANSAKSI
          Expanded(
            child: ListView.builder(
              itemCount: transaksi.length,
              itemBuilder: (context, index) {
                final item = transaksi[index];

                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      transaksi.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),

                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Icon(
                        item["isPemasukan"]
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: item["isPemasukan"] ? Colors.green : Colors.red,
                      ),
                      title: Text(item["nama"]),
                      trailing: Text(
                        (item["isPemasukan"] ? "+ " : "- ") +
                            "Rp ${item["nominal"]}",
                        style: TextStyle(
                          color: item["isPemasukan"]
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
