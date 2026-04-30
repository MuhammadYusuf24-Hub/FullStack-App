// import 'package:flutter/material.dart';
// import '../Service/serviceapi.dart';

// class HistoryPage extends StatefulWidget {
//   const HistoryPage({super.key});

//   @override
//   State<HistoryPage> createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   List data = [];
//   List filtered = [];
//   bool isLoading = true;
//   final search = TextEditingController();

//   @override
//   // void initState() {
//   //   super.initState();
//   //   load();
//   // }

//   // void load() async {
//   //   var res = await ServiceApi.getHistory();
//   //   setState(() {
//   //     data = res;
//   //     filtered = res;
//   //     isLoading = false;
//   //   });
//   // }

//   void doSearch(String keyword) {
//     setState(() {
//       filtered = data.where((h) {
//         return h['nama_item'].toString().toLowerCase().contains(
//               keyword.toLowerCase(),
//             ) ||
//             h['id'].toString().contains(keyword);
//       }).toList();
//     });
//   }

//   Color getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'selesai':
//         return Color(0xff1e6b3a);
//       case 'diproses':
//         return Color(0xff6b4e1e);
//       default:
//         return Color(0xff1e3a6b);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff081a33),
//       appBar: AppBar(
//         backgroundColor: Color(0xff0f2a4a),
//         title: Text(
//           "Riwayat Transaksi",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator(color: Colors.white))
//           : Column(
//               children: [
//                 // Search bar
//                 Padding(
//                   padding: EdgeInsets.all(16),
//                   child: TextField(
//                     controller: search,
//                     onChanged: doSearch,
//                     style: TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       hintText: "Cari berdasarkan ID atau Nama Item...",
//                       hintStyle: TextStyle(color: Colors.white38),
//                       prefixIcon: Icon(Icons.search, color: Colors.white54),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(color: Color(0xff3b82f6)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(color: Color(0xff3b82f6)),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // List transaksi
//                 Expanded(
//                   child: filtered.isEmpty
//                       ? Center(
//                           child: Text(
//                             "Tidak ada data",
//                             style: TextStyle(color: Colors.white54),
//                           ),
//                         )
//                       : ListView.builder(
//                           padding: EdgeInsets.symmetric(horizontal: 16),
//                           itemCount: filtered.length,
//                           itemBuilder: (c, i) {
//                             var h = filtered[i];
//                             return Container(
//                               margin: EdgeInsets.only(bottom: 12),
//                               decoration: BoxDecoration(
//                                 color: Color(0xff0f2a4a),
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(color: Color(0xff1e4d8c)),
//                               ),
//                               child: Padding(
//                                 padding: EdgeInsets.all(16),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     // ID + Status
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           "ID: ${h['id']}",
//                                           style: TextStyle(
//                                             color: Colors.white54,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                         Container(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: 10,
//                                             vertical: 4,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: getStatusColor(
//                                               h['status'] ?? '',
//                                             ),
//                                             borderRadius: BorderRadius.circular(
//                                               6,
//                                             ),
//                                           ),
//                                           child: Text(
//                                             h['status'] ?? '',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 8),

//                                     // Nama item
//                                     Text(
//                                       h['item'] ?? '',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4),

//                                     // Tipe + Tanggal
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.label_outline,
//                                           color: Colors.white54,
//                                           size: 14,
//                                         ),
//                                         SizedBox(width: 4),
//                                         Text(
//                                           h['tipe'] ?? '',
//                                           style: TextStyle(
//                                             color: Colors.white54,
//                                             fontSize: 13,
//                                           ),
//                                         ),
//                                         SizedBox(width: 16),
//                                         Icon(
//                                           Icons.calendar_today,
//                                           color: Colors.white54,
//                                           size: 14,
//                                         ),
//                                         SizedBox(width: 4),
//                                         Text(
//                                           h['tanggal'] ?? '',
//                                           style: TextStyle(
//                                             color: Colors.white54,
//                                             fontSize: 13,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 8),

//                                     // Total
//                                     Text(
//                                       "Rp${h['total']}",
//                                       style: TextStyle(
//                                         color: Color(0xff3b82f6),
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
