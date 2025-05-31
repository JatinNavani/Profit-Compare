import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<dynamic> newsArticles = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  String? nextPageUrl;
  final unescape = HtmlUnescape();
  final ScrollController _scrollController = ScrollController();

  final String apiUrl =
      'https://newsdata.io/api/1/news?apikey=api_key&country=in&q=nifty+gold+mutual%20funds'; //replace api_key with your news api key

  @override
  void initState() {
    super.initState();
    fetchNews();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !isLoadingMore &&
          nextPageUrl != null) {
        setState(() => isLoadingMore = true);
        fetchNews();
      }
    });
  }

  Future<void> fetchNews({bool isRefresh = false}) async {
    final String url = isRefresh
        ? apiUrl
        : nextPageUrl ?? apiUrl;

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newArticles = data['results'];
      final newNextPage = data['nextPage'];

      setState(() {
        if (isRefresh) {
          newsArticles = newArticles;
        } else {
          newsArticles.addAll(newArticles);
        }
        nextPageUrl = newNextPage != null
            ? "$apiUrl&page=$newNextPage"
            : null;
        isLoading = false;
        isLoadingMore = false;
      });
    } else {
      print("Failed to load news: ${response.statusCode}");
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EDE3),
      appBar: AppBar(
        title: Text('Explore News'),
        backgroundColor: Color(0xFF595CE6),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => fetchNews(isRefresh: true),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: newsArticles.length + (isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == newsArticles.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final article = newsArticles[index];
                  final title = unescape.convert(article['title'] ?? '');
                  final description =
                      unescape.convert(article['description'] ?? '');
                  final imageUrl = article['image_url'];
                  final pubDate = article['pubDate'] ?? '';

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: GestureDetector(
                      onTap: () => _launchURL(article['link']),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            imageUrl != null && imageUrl.toString().isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.network(
                                      imageUrl,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              SizedBox.shrink(),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Published: $pubDate',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
      currentIndex: 0, // Explore is index 0
      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamed(context, '/explore');
        } else if (index == 1) {
          Navigator.pushNamed(context, '/home');
        } else if (index == 2) {
           Navigator.pushNamed(context, '/profile');
        }else if (index == 3) {
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
