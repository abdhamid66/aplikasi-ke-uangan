import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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
      int nominal = item["nominal"] as int;

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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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

          //
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Colors.blue,
                ),
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
            ),
          ),

          // 🔹 LIST
          Expanded(
            child: ListView.builder(
              itemCount: transaksi.length,
              itemBuilder: (context, index) {
                final item = transaksi[index];

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(
                      item["isPemasukan"]
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: item["isPemasukan"] ? Colors.green : Colors.red,
                    ),
                    title: Text(item["nama"]),
                    trailing: Text(
                      "${item["isPemasukan"] ? "+ " : "- "}Rp ${NumberFormat('#,###', 'id_ID').format(item["nominal"])}",
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
