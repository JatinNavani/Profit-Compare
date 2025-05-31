import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../service/gpt_service.dart';

class AllocationSummaryScreen extends StatefulWidget {
  @override
  State<AllocationSummaryScreen> createState() => _AllocationSummaryScreenState();
}

class _AllocationSummaryScreenState extends State<AllocationSummaryScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final GPTService _gptService = GPTService();
  double totalFixed = 0;
  double totalEquity = 0;
  double totalAlternate = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchInvestmentData();
  }

  Future<void> _fetchInvestmentData() async {
    final uid = user!.uid;
    final db = FirebaseFirestore.instance;

    Future<double> getTotal(String assetClass) async {
      final snapshot = await db.collection('users').doc(uid).collection(assetClass).get();
      return snapshot.docs.fold<double>(0.0, (sum, doc) => sum + (doc['amount'] as num).toDouble());
    }

    totalFixed = await getTotal('fixed_income');
    totalEquity = await getTotal('equity');
    totalAlternate = await getTotal('alternate');

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final total = totalFixed + totalEquity + totalAlternate;
    double percent(double value) => total == 0 ? 0 : (value / total) * 100;

    return Scaffold(
      backgroundColor: Color(0xFFF5EDE3),
      appBar: AppBar(
        backgroundColor: Color(0xFF595CE6),
        title: Text('Portfolio Summary', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Your Current Asset Allocation",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 20),
                        AspectRatio(
                          aspectRatio: 1.3,
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 40,
                              sectionsSpace: 3,
                              sections: [
                                _buildPieSection("Fixed Income", percent(totalFixed), Colors.blue),
                                _buildPieSection("Equity", percent(totalEquity), Colors.green),
                                _buildPieSection("Alternate", percent(totalAlternate), Colors.orange),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildBreakdown("Fixed Income", totalFixed, percent(totalFixed), Colors.blue),
                        _buildBreakdown("Equity", totalEquity, percent(totalEquity), Colors.green),
                        _buildBreakdown("Alternate Investments", totalAlternate, percent(totalAlternate), Colors.orange),
                        SizedBox(height: 30),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF595CE6),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => AlertDialog(
                                title: Text("Gemini Suggests"),
                                content: SizedBox(
                                  height: 100,
                                  child: Center(child: CircularProgressIndicator()),
                                ),
                              ),
                            );

                            final recommendation = await _getGeminiSuggestion();
                            Navigator.pop(context);

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Gemini Suggests"),
                                content: SingleChildScrollView(
                                  child: MarkdownBody(
                                    data: recommendation,
                                    styleSheet: MarkdownStyleSheet(
                                      p: TextStyle(fontSize: 14, color: Colors.black, height: 1.5),
                                      strong: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                      listBullet: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                      blockSpacing: 12,
                                      listIndent: 24,
                                    ),
                                  ),
                                ),
                                actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Close"))],
                              ),
                            );
                          },
                          icon: Icon(Icons.auto_awesome, color: Colors.white),
                          label: Text("Get Gemini Advice", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  PieChartSectionData _buildPieSection(String title, double percent, Color color) {
    return PieChartSectionData(
      color: color,
      value: percent,
      title: "${percent.toStringAsFixed(1)}%",
      radius: 60,
      titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
    );
  }

  Widget _buildBreakdown(String label, double amount, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color, radius: 6),
          SizedBox(width: 10),
          Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.w500))),
          Text("₹${amount.toStringAsFixed(2)} | ${percent.toStringAsFixed(1)}%", style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Future<String> _getGeminiSuggestion() async {
    final prompt = '''
Given the following investment breakdown:
- Fixed Income: ₹${totalFixed.toStringAsFixed(2)}
- Equity: ₹${totalEquity.toStringAsFixed(2)}
- Alternate Investments: ₹${totalAlternate.toStringAsFixed(2)}

Please analyze the portfolio and give recommendations on how to diversify further. Respond like a professional advisor in short paragraphs.
''';

    try {
      return await _gptService.getResponse(prompt);
    } catch (e) {
      return "Sorry, Gemini is currently unavailable. Try again later.";
    }
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
