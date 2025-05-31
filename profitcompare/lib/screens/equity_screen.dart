import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../theme/home_text_styles.dart';

class EquityScreen extends StatefulWidget {
  @override
  _EquityScreenState createState() => _EquityScreenState();
}

class _EquityScreenState extends State<EquityScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late CollectionReference equityRef;

  @override
  void initState() {
    super.initState();
    equityRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('equity');
  }

  void _addInvestmentDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Equity Investment', style: HomeTextStyles.label),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _inputField('Stock / MF Name', nameController),
              _inputField('Amount (₹)', amountController, isNumber: true),
              GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
                child: AbsorbPointer(
                  child: _inputField('Date (e.g., 2024-01-01)', dateController),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF595CE6)),
            onPressed: () async {
              if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
                await equityRef.add({
                  'name': nameController.text.trim(),
                  'amount': double.tryParse(amountController.text.trim()) ?? 0,
                  'date': dateController.text.trim(),
                  'created_at': Timestamp.now(),
                });
                Navigator.pop(ctx);
              }
            },
            child: Text('Add'),
          )
        ],
      ),
    );
  }

  Widget _inputField(String hint, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: HomeTextStyles.inputHint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Future<void> _deleteInvestment(String docId) async {
    await equityRef.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EDE3),
      appBar: AppBar(
        title: Text('Equity', style: HomeTextStyles.title),
        backgroundColor: Color(0xFF595CE6),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: equityRef.orderBy('created_at', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error loading data"));
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text("No equity investments yet."));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                elevation: 4,
                color: Color(0xFFF8F6FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'],
                              style: HomeTextStyles.inputLabel.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "₹${data['amount'].toStringAsFixed(2)}  •  ${data['date']}",
                              style: HomeTextStyles.inputHint.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                        onPressed: () => _deleteInvestment(docId),
                        tooltip: "Delete",
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton.extended(
            onPressed: _addInvestmentDialog,
            label: Text(
            'Add Investment',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black, // <-- CHANGED COLOR HERE
            ),
            ),
            icon: Icon(Icons.add, color: Colors.black), // <-- ICON COLOR MATCHED
            backgroundColor: Color(0xFFBEBEFE),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 4,
        ),
        ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF595CE6),
      unselectedItemColor: Color(0xFF333333),
      currentIndex: 4,
      onTap: (index) {
        if (index == 0) Navigator.pushNamed(context, '/explore');
        if (index == 1) Navigator.pushNamed(context, '/home');
        if (index == 2) Navigator.pushNamed(context, '/profile');
        if (index == 3) Navigator.pushNamed(context, '/chat');
        if (index == 4) Navigator.pushNamed(context, '/asset_class');
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Customize'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Assets'),
      ],
    );
  }
}
