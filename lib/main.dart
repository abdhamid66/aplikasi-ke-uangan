import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

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
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> simpanData() async {
    final prefs = await SharedPreferences.getInstance();
    String data = jsonEncode(transaksi);
    await prefs.setString('dataTransaksi', data);
  }

  // 👇 TAMBAHKAN DI SINI
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('dataTransaksi');

    if (data != null) {
      setState(() {
        transaksi = List<Map<String, dynamic>>.from(jsonDecode(data));
      });
    }
  }

  void tambahTransaksi() {
    setState(() {
      transaksi.add({
        "nama": namaController.text,
        "nominal": int.tryParse(nominalController.text) ?? 0,
        "isPemasukan": isPemasukan,
      });
    });
    simpanData();

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
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          "Catatan Keuangan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),

      body: Column(
        children: [
          // 🔹 SALDO
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Saldo", style: TextStyle(color: Colors.white70)),
                SizedBox(height: 10),
                Text(
                  "Rp ${NumberFormat('#,###', 'id_ID').format(hitungSaldo())}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
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
                    simpanData();
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
                            "Rp ${NumberFormat('#,###', 'id_ID').format(item["nominal"])}",
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
