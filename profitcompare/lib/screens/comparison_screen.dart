import 'package:flutter/material.dart';

class ComparisonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get capital from arguments, use "Default" if null
    final String? capital = ModalRoute.of(context)!.settings.arguments as String?;
    final String capitalAmount = (capital != null && capital.isNotEmpty) ? capital : "Default";

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF5EDE3),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Back & Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 5),
                  Text('Comparison', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // 🔹 Capital Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Capital", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Text("₹$capitalAmount", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            // 🔹 Graph from AWS
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Image.network(
                  "https://s3.ap-south-1.amazonaws.com/www.jatinnavani.in/MC_app/graph_profitcompare.png",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 50, color: Colors.red),
                ),
              ),
            ),

            // 🔹 Graph Legend
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem(Colors.yellow, 'Gold'),
                  _buildLegendItem(Colors.green, 'Mutual Fund'),
                  _buildLegendItem(Colors.blue, 'Nifty 50'),
                ],
              ),
            ),
            SizedBox(height: 10),

            // 🔹 Full Report Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/report', arguments: capitalAmount);
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF595CE6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  alignment: Alignment.center,
                  child: Text('Full Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),

            // 🔹 Bottom Navigation Bar
            _buildBottomNavigationBar(context),
          ],
        ),
      ),
    );
  }

  // 🔹 Legend Item Builder
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  // 🔹 Bottom Navigation Bar
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF595CE6),
      unselectedItemColor: Color(0xFF333333),
      currentIndex: 1,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/explore');
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/profile');
        }
        else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/chat');
          }else if (index == 4) Navigator.pushNamed(context, '/asset_class');
        
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Customize Investments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Assets'),
      ],
    );
  }
}
