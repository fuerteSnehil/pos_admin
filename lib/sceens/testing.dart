// import 'package:flutter/material.dart';

// class YourOverallReportScreen extends StatelessWidget {
//   // ... (your existing code)

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text('Overall Report', style: TextStyle(fontFamily: 'tabfont')),
//       ),
//       body: Column(
//         children: [
//           // ... (your existing Lottie widget)

//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: billsCollection.snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Text('No data available');
//                 }

//                 return ListView.builder(
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     var billData = snapshot.data!.docs[index];

//                     // Use RichText to style different parts of the text
//                     return ListTile(
//                       title: Text('Bill ${index + 1}'),
//                       subtitle: RichText(
//                         text: TextSpan(
//                           text: 'User ID: ',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           children: <TextSpan>[
//                             TextSpan(
//                               text: '${billData['userId']}',
//                               style: TextStyle(
//                                 color: Colors.blue, // Customize the color
//                                 fontWeight: FontWeight.normal,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 BillDetailsScreen(billData: billData),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
