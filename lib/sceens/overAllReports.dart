import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OverAllReport extends StatefulWidget {
  @override
  _OverAllReportState createState() => _OverAllReportState();
}

class _OverAllReportState extends State<OverAllReport> {
  final CollectionReference billsCollection =
      FirebaseFirestore.instance.collection('Bills');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overall Report'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: billsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No data available');
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var billData = snapshot.data!.docs[index];

              return ListTile(
                title: Text('Bill ${index + 1}'),
                subtitle: Text('User ID: ${billData['userId']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BillDetailsScreen(billData: billData),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class BillDetailsScreen extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> billData;

  BillDetailsScreen({required this.billData});

  @override
  Widget build(BuildContext context) {
    var itemsList = billData['items'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User ID: ${billData['userId']}'),
          Text('Subtotal: ${billData['subTotal']}'),
          ...itemsList.map<Widget>((item) {
            return Text(
              'Name: ${item['name']}, Quantity: ${item['quantity']}, Price: ${item['price']}',
            );
          }).toList(),
        ],
      ),
    );
  }
}
