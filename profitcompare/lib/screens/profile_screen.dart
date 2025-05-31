import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../database_helper.dart';
import '../theme/profile_text_styles.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedMetric = "Sharpe Ratio";
  String selectedRiskLevel = "Moderate";
  bool isDarkMode = false;
  bool isLoading = true;
  File? _profileImage;

  final picker = ImagePicker();

  final List<String> metrics = ["Sharpe Ratio", "ROI", "Alpha", "Beta"];
  final List<String> riskLevels = ["Low", "Moderate", "High"];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await DatabaseHelper.getPreferences();
      if (mounted) {
        setState(() {
          selectedMetric = prefs['preferred_metric'];
          selectedRiskLevel = prefs['risk_tolerance'];
          isDarkMode = prefs['theme_mode'];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading preferences: $e");
    }
  }

  Future<void> _savePreferences() async {
    try {
      await DatabaseHelper.savePreferences(
          selectedMetric, selectedRiskLevel, isDarkMode);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Preferences saved!")),
        );
      }
    } catch (e) {
      print("Error saving preferences: $e");
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Color(0xFFFAF8F5),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text('Edit Profile',
                              style: ProfileTextStyles.editProfile),
                          SizedBox(width: 40),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),

                    // Profile Image with camera overlay
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 78,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? Icon(Icons.person,
                                  size: 70, color: Colors.black54)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showImagePickerOptions,
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.camera_alt,
                                  color: Colors.black87, size: 22),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // User Info (Email only)
                    _buildProfileField('Email', user?.email ?? 'Not set'),
                    SizedBox(height: 15),

                    // Preferences
                    _buildPreferenceField(
                      "Preferred Metric",
                      metrics,
                      selectedMetric,
                      (value) {
                        setState(() {
                          selectedMetric = value;
                        });
                        _savePreferences();
                      },
                    ),
                    SizedBox(height: 15),
                    _buildPreferenceField(
                      "Risk Tolerance",
                      riskLevels,
                      selectedRiskLevel,
                      (value) {
                        setState(() {
                          selectedRiskLevel = value;
                        });
                        _savePreferences();
                      },
                    ),
                    SizedBox(height: 15),
                    _buildThemeToggle(),
                    SizedBox(height: 30),

                    // Logout Button
                    GestureDetector(
                      onTap: () => _logout(context),
                      child: Container(
                        width: 221,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFF24265F),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('Log Out',
                            style: ProfileTextStyles.saveChangesButton),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  // Profile Field UI
  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: ProfileTextStyles.fieldLabel),
          SizedBox(height: 5),
          Text(value, style: ProfileTextStyles.fieldValue),
        ],
      ),
    );
  }

  // Dropdown UI
  Widget _buildPreferenceField(String label, List<String> options,
      String selectedValue, Function(String) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: ProfileTextStyles.fieldLabel),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0x23534C4C)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButton<String>(
              value: selectedValue,
              onChanged: (newValue) => onChanged(newValue!),
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: ProfileTextStyles.fieldValue),
                );
              }).toList(),
              isExpanded: true,
              underline: SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  // Dark Mode Toggle
  Widget _buildThemeToggle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Dark Mode", style: ProfileTextStyles.fieldLabel),
          Switch(
            value: isDarkMode,
            onChanged: (bool value) {
              setState(() {
                isDarkMode = value;
              });
              _savePreferences();
            },
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF595CE6),
      unselectedItemColor: Color(0xFF333333),
      currentIndex: 2,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamed(context, '/explore');
        } else if (index == 1) {
          Navigator.pushNamed(context, '/home');
        } else if (index == 3) {
          Navigator.pushNamed(context, '/chat'); 
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
