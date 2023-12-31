import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pos_admin/constants/colors.dart';

class AllCustomerScreen extends StatefulWidget {
  final String adminUid;

  AllCustomerScreen({required this.adminUid});

  @override
  State<AllCustomerScreen> createState() => _AllCustomerScreenState();
}

class _AllCustomerScreenState extends State<AllCustomerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to delete a customer from Firebase
  Future<void> _deleteCustomer(String customerId) async {
    try {
      await _firestore
          .collection('AllAdmins')
          .doc(widget.adminUid)
          .collection('customer')
          .doc(customerId)
          .delete();
    } catch (e) {
      // Handle errors here
      print('Error deleting customer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'All Customers',
          style: TextStyle(
            fontFamily: "tabfont",
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('AllAdmins')
            .doc(widget.adminUid)
            .collection('customer')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var customers = snapshot.data!.docs;
          List<Widget> customerWidgets = [];
          for (var customer in customers) {
            var customerData = customer.data() as Map<String, dynamic>;
            var customerId = customer.id;
            var customerName = customerData['name'];
            var customerPhone = customerData['phoneNumber'];
            var customerCode = customerData['customerCode'];
            var customerEmail = customerData['email'];

            var customerWidget = Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    const BoxShadow(
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                      height: MediaQuery.of(context).size.width * .3,
                      width: MediaQuery.of(context).size.width * .28,
                      padding: const EdgeInsets.all(8.0),
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20.0,
                        backgroundImage: AssetImage('$imagesPath/account.gif'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customerName,
                            style: const TextStyle(
                              fontSize: 19.0,
                              fontFamily: "tabfont",
                            ),
                          ),
                          Text(
                            "Customer Code: $customerCode",
                            style: const TextStyle(
                                fontFamily: "fontmain",
                                fontSize: 15.0,
                                color: Colors.black54),
                          ),
                          Text(
                            "Phone No: $customerPhone",
                            style: const TextStyle(
                                fontFamily: "fontmain",
                                fontSize: 15.0,
                                color: Colors.black54),
                          ),
                          Text(
                            customerEmail,
                            style: const TextStyle(
                                fontFamily: "fontmain",
                                fontSize: 15.0,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                      ),
                      onPressed: () {
                        // Show a confirmation dialog before deleting
                        _showDeleteConfirmationDialog(context, customerId);
                      },
                    ),
                  ],
                ),
              ),
            );

            customerWidgets.add(customerWidget);
          }

          return ListView(
            children: customerWidgets,
          );
        },
      ),
    );
  }

  // Function to show a confirmation dialog before deleting
  void _showDeleteConfirmationDialog(
      BuildContext context, String customerId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Customer"),
          content: Text("Are you sure you want to delete this customer?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Return true when delete is confirmed
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    ).then((result) {
      if (result == true) {
        _deleteCustomer(customerId);
      }
    });
  }
}
