// import 'package:flutter/material.dart';
// import '../Service/serviceapi.dart';
// import 'history.dart';
// import 'login.dart';

// class DataSewaPage extends StatefulWidget {
//   const DataSewaPage({super.key});

//   @override
//   State<DataSewaPage> createState() => _DataSewaPageState();
// }

// class _DataSewaPageState extends State<DataSewaPage> {
//   List kamera = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     load();
//   }

//   void load() async {
//     var data = await ServiceApi.getKamera();
//     setState(() {
//       kamera = data;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff081a33),
//       appBar: AppBar(
//         backgroundColor: Color(0xff0f2a4a),
//         title: Text(
//           "SMARTSTUDIO",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       drawer: Drawer(
//         backgroundColor: Color(0xff0f2a4a),
//         child: ListView(
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Color(0xff081a33)),
//               child: Text(
//                 "SMARTSTUDIO",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.camera_alt, color: Colors.white),
//               title: Text(
//                 "Daftar Kamera",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.history, color: Colors.white),
//               title: Text("History", style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => HistoryPage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout, color: Colors.redAccent),
//               title: Text("Logout", style: TextStyle(color: Colors.redAccent)),
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => LoginPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator(color: Colors.white))
//           : ListView.builder(
//               padding: EdgeInsets.all(16),
//               itemCount: kamera.length,
//               itemBuilder: (c, i) {
//                 var k = kamera[i];
//                 return Container(
//                   margin: EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Color(0xff0f2a4a),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Color(0xff1e4d8c)),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header card
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.symmetric(
//                           vertical: 12,
//                           horizontal: 16,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Color(0xff1a3a6b),
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(12),
//                             topRight: Radius.circular(12),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 k['nama'] ?? '',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Body card
//                       Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               k['spesifikasi'] ?? '',
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 13,
//                               ),
//                             ),
//                             SizedBox(height: 12),
//                             Text(
//                               "Rp${k['harga_per_hari']} / Hari",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 12),
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Color(0xff3b82f6),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   padding: EdgeInsets.symmetric(vertical: 12),
//                                 ),
//                                 onPressed: () {},
//                                 child: Text(
//                                   "Sewa Sekarang",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
