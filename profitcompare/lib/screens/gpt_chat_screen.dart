import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../theme/home_text_styles.dart';
import '../service/gpt_service.dart';

class GPTChatScreen extends StatefulWidget {
  @override
  _GPTChatScreenState createState() => _GPTChatScreenState();
}

class _GPTChatScreenState extends State<GPTChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final GPTService _gptService = GPTService();
  final List<Map<String, String>> _messages = [];

  bool _isLoading = false;

  void _sendMessage() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': input});
      _isLoading = true;
      _controller.clear();
    });

    final reply = await _gptService.getResponse(input);

    setState(() {
      _messages.add({'role': 'assistant', 'content': reply});
      _isLoading = false;
    });
  }

  Widget _buildMessage(String content, String role) {
  final isUser = role == 'user';
  final messageColor = isUser ? Color(0xFF595CE6) : Color(0xFFF7F7F9);
  final textColor = isUser ? Colors.white : Colors.black;

  return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      decoration: BoxDecoration(
        color: messageColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(isUser ? 16 : 0),
          bottomRight: Radius.circular(isUser ? 0 : 16),
        ),
        boxShadow: isUser
            ? []
            : [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ],
      ),
      child: isUser
          ? Text(
              content,
              style: HomeTextStyles.inputHint.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            )
          : MarkdownBody(
              data: content,
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: HomeTextStyles.inputHint.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                  height: 1.5,
                ),
                strong: HomeTextStyles.inputHint.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                listBullet: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                blockSpacing: 12,
                listIndent: 24,
              ),
            ),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF5EDE3),
      body: SafeArea(
        child: Column(
          children: [
            // Curved Top
            Container(
              height: screenHeight * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF595CE6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(70),
                  bottomRight: Radius.circular(0),
                ),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 24, top: 32),
              child: Text(
                "Ask your Investment\nQuestions!",
                style: HomeTextStyles.title,
              ),
            ),

            // Chat Body
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 12, bottom: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessage(msg['content']!, msg['role']!);
                },
              ),
            ),

            if (_isLoading)
              Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(),
              ),

            // Input Field
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: HomeTextStyles.inputLabel,
                      decoration: InputDecoration(
                        hintText: "Type your question...",
                        hintStyle: HomeTextStyles.inputHint,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Color(0xFF595CE6)),
                    onPressed: _isLoading ? null : _sendMessage,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF595CE6),
      unselectedItemColor: Color(0xFF333333),
      currentIndex: 3, // New index for Chat
      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamed(context, '/explore');
        } else if (index == 1) {
          Navigator.pushNamed(context, '/home');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/profile');
        } else if (index == 3) {
          // already on chat
        } else if (index == 4) Navigator.pushNamed(context, '/asset_class');
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Customize'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'), // New
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Assets'),
      ],
    );
  }
}
