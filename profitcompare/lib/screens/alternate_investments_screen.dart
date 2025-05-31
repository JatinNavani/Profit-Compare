import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../theme/home_text_styles.dart';

class AlternateInvestmentsScreen extends StatefulWidget {
  @override
  _AlternateInvestmentsScreenState createState() => _AlternateInvestmentsScreenState();
}

class _AlternateInvestmentsScreenState extends State<AlternateInvestmentsScreen> {
  User? user;
  late CollectionReference alternateRef;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      alternateRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('alternate');
    }
  }

  void _addInvestmentDialog() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Alternate Investment', style: HomeTextStyles.label),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _inputField('Asset Name (e.g., Gold, RE)', nameController),
              _inputField('Amount (₹)', amountController, isNumber: true),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
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
                  child: _inputField('Date (YYYY-MM-DD)', dateController),
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
              if (nameController.text.isEmpty || amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required")));
                return;
              }
              await alternateRef.add({
                'name': nameController.text.trim(),
                'amount': double.tryParse(amountController.text.trim()) ?? 0,
                'date': dateController.text.trim(),
                'created_at': Timestamp.now(),
              });
              Navigator.pop(ctx);
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
    await alternateRef.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(child: Text("Please login first.")),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5EDE3),
      appBar: AppBar(
        title: Text('Alternate Investments', style: HomeTextStyles.title),
        backgroundColor: Color(0xFF595CE6),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: alternateRef.orderBy('created_at', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error loading data"));
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text("No alternate investments yet.", style: HomeTextStyles.inputHint),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;
              final formattedAmount = NumberFormat.currency(locale: 'en_IN', symbol: '₹')
                  .format(data['amount']);

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
                              "$formattedAmount  •  ${data['date']}",
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          icon: Icon(Icons.add, color: Colors.black),
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
