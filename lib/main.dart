import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> transaksi = [
    {"nama": "Makan", "nominal": 20000, "isPemasukan": false},
    {"nama": "Gaji", "nominal": 2000000, "isPemasukan": true},
    {"nama": "Pulsa", "nominal": 50000, "isPemasukan": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Money Tracker"),
        centerTitle: true,
      ),

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
                Text(
                  "Total Saldo",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "Rp 1.930.000",
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
            onPressed: () {},
            child: Text("+ Tambah Transaksi"),
          ),

          SizedBox(height: 10),

          // 🔹 LIST TRANSAKSI
          Expanded(
            child: ListView.builder(
              itemCount: transaksi.length,
              itemBuilder: (context, index) {
                final item = transaksi[index];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Icon(
                      item["isPemasukan"]
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: item["isPemasukan"]
                          ? Colors.green
                          : Colors.red,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}