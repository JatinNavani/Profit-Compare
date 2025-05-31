import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/report_text_styles.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String selectedCategory = "Gold";
  String selectedRiskTolerance = "Medium"; // default for passing to allocation screen
  Map<String, Map<String, String>> categoryData = {};
  bool isLoading = true;
  double initialCapital = 100.0;

  final Map<String, String> metricInfo = {
    "1-Year Return": "Percentage gain or loss over 1 year.",
    "3-Year Return": "Percentage gain or loss over 3 years.",
    "5-Year Return": "Percentage gain or loss over 5 years.",
    "10-Year Return": "Percentage gain or loss over 10 years.",
    "Sharpe Ratio": "Return earned per unit of risk. Higher is better.",
    "Volatility": "Indicates how much the investment’s price fluctuates.",
    "Max Drawdown": "Maximum drop from peak to lowest value before recovery. Lower is better.",
    "Risk-Reward Ratio": "Compares expected reward to risk taken.",
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is String) {
      initialCapital = double.tryParse(args.replaceAll('₹', '').replaceAll(',', '')) ?? 1000.0;
    }
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    final url = 'https://s3.ap-south-1.amazonaws.com/www.jatinnavani.in/MC_app/investment_report.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          categoryData = jsonData.map((key, value) => MapEntry(key, Map<String, String>.from(value)));
          isLoading = false;
        });
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  double calculateAmount(String percentage) {
    final clean = percentage.replaceAll('%', '');
    final percentValue = double.tryParse(clean) ?? 0.0;
    return (initialCapital * (percentValue / 100)) + initialCapital;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EDE3),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildTopBar(),
                  SizedBox(height: 10),
                  _buildDropdown(),
                  SizedBox(height: 20),
                  _buildMetricsGrid(),
                  SizedBox(height: 10),
                  _buildAssetAllocationButton(),
                  SizedBox(height: 20),
                  _buildBottomNavigationBar(context),
                ],
              ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Stack(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Color(0xFF595CE6),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(0),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 16,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          top: 50,
          left: 80,
          child: Text('Detailed Report!', style: ReportTextStyles.detailedReport),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: DropdownButton<String>(
          value: selectedCategory,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
          isExpanded: true,
          underline: SizedBox(),
          style: ReportTextStyles.dropdownText,
          items: categoryData.keys.map((String category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.8,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: categoryData[selectedCategory]!.entries.map((entry) {
            return _buildMetricCard(entry.key, entry.value);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value) {
    final isReturn = value.contains('%') && label.contains('Return');
    final double? calculated = isReturn ? calculateAmount(value) : null;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(label, style: ReportTextStyles.metricLabel)),
              GestureDetector(
                onTap: () {
                  final info = metricInfo[label] ?? "No description available.";
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(label),
                      content: Text(info),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Close"),
                        ),
                      ],
                    ),
                  );
                },
                child: Icon(Icons.info_outline, size: 16, color: Colors.grey[700]),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(value, style: ReportTextStyles.metricValue),
          if (calculated != null)
            Text('₹${calculated.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12, color: Colors.green)),
        ],
      ),
    );
  }

  Widget _buildAssetAllocationButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF595CE6),
          foregroundColor: Colors.white, // ✅ ensures text + icon are white
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          minimumSize: Size(double.infinity, 48),
        ),
        icon: Icon(Icons.pie_chart),
        label: Text("View Asset Allocation", style: TextStyle(fontSize: 16)),
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/allocation',
            arguments: selectedRiskTolerance,
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF595CE6),
      unselectedItemColor: Color(0xFF333333),
      currentIndex: 1,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamed(context, '/explore');
        } else if (index == 1) {
          Navigator.pushNamed(context, '/home');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/profile');
        } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/chat');
        } else if (index == 4) Navigator.pushNamed(context, '/asset_class');
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
