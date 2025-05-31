import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/home_text_styles.dart';

class AssetClassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final assetClasses = [
      {'title': 'Fixed Income', 'route': '/fixed'},
      {'title': 'Equity', 'route': '/equity'},
      {'title': 'Alternate Investments', 'route': '/alternate'},
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF5EDE3),
      appBar: AppBar(
        backgroundColor: Color(0xFF595CE6),
        title: Text('Your Investments', style: HomeTextStyles.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose an Asset Class", style: HomeTextStyles.label),
            SizedBox(height: 20),
            ...assetClasses.map((item) => _buildCard(context, item)).toList(),
            Spacer(),
            _buildActionButtons(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, String> item) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, item['route']!),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Text(
            item['title']!,
            style: HomeTextStyles.inputLabel.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pushNamed(context, '/allocation_summary'),
      icon: Icon(Icons.pie_chart, color: Colors.white),
      label: Text("View Summary", style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4C52F8),
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
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
