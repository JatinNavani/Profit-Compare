import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AssetAllocationScreen extends StatefulWidget {
  final String riskTolerance;

  AssetAllocationScreen({required this.riskTolerance});

  @override
  State<AssetAllocationScreen> createState() => _AssetAllocationScreenState();
}

class _AssetAllocationScreenState extends State<AssetAllocationScreen> {
  late String selectedRisk;

  final Map<String, Map<String, double>> allocationData = {
    "Low": {"Gold": 50, "Mutual Funds": 30, "Nifty 50": 20},
    "Medium": {"Gold": 30, "Mutual Funds": 40, "Nifty 50": 30},
    "High": {"Gold": 10, "Mutual Funds": 30, "Nifty 50": 60},
  };

  final Map<String, String> riskDescriptions = {
    "Low": "Suitable for conservative investors focused on capital protection.",
    "Medium": "Balanced growth with moderate risk and returns.",
    "High": "Designed for aggressive investors seeking higher returns.",
  };

  int? touchedIndex;

  @override
  void initState() {
    super.initState();
    selectedRisk = widget.riskTolerance;
  }

  @override
  Widget build(BuildContext context) {
    final data = allocationData[selectedRisk]!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Asset Allocation"),
        backgroundColor: Color(0xFF595CE6),
      ),
      backgroundColor: Color(0xFFF5EDE3),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildDropdown(),
            SizedBox(height: 30),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, pieTouchResponse) {
                      if (event == null || pieTouchResponse == null) return;

                      final touchedSection = pieTouchResponse.touchedSection;
                      if (touchedSection != null &&
                          touchedSection.touchedSectionIndex != -1) {
                        final index = touchedSection.touchedSectionIndex;
                        if (index >= 0 && index < data.length) {
                          final label = data.keys.elementAt(index);
                          final value = data.values.elementAt(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$label: ${value.toStringAsFixed(1)}%')),
                          );
                        }
                      }
                    },
                  ),
                  sections: data.entries.map((entry) {
                    final color = entry.key == "Gold"
                        ? Colors.yellow
                        : entry.key == "Mutual Funds"
                            ? Colors.green
                            : Colors.blue;
                    return PieChartSectionData(
                      color: color,
                      value: entry.value,
                      title: entry.value >= 10 ? '${entry.key}\n${entry.value}%' : '',
                      titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      radius: 70,
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                ),
                swapAnimationDuration: Duration(milliseconds: 800),
                swapAnimationCurve: Curves.easeInOut,
              ),
            ),
            SizedBox(height: 20),
            _buildLegend(data),
            SizedBox(height: 20),
            Text(
              riskDescriptions[selectedRisk]!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            Navigator.pushReplacementNamed(context, '/profile');
          }
          else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/chat');
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Customize Investments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: DropdownButton<String>(
        value: selectedRisk,
        icon: Icon(Icons.keyboard_arrow_down),
        isExpanded: true,
        underline: SizedBox(),
        style: TextStyle(fontSize: 16, color: Colors.black),
        items: allocationData.keys.map((risk) {
          return DropdownMenuItem(
            value: risk,
            child: Text("Risk Tolerance: $risk"),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedRisk = value!;
          });
        },
      ),
    );
  }

  Widget _buildLegend(Map<String, double> data) {
    return Column(
      children: data.entries.map((entry) {
        final color = entry.key == "Gold"
            ? Colors.yellow
            : entry.key == "Mutual Funds"
                ? Colors.green
                : Colors.blue;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              SizedBox(width: 8),
              Text(entry.key, style: TextStyle(fontSize: 14)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
