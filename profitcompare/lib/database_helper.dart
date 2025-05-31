import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  
  // Get database instance (initialize only once)
  static Future<Database?> get database async {
    if (kIsWeb) {
      // Return null for web, we'll use SharedPreferences instead
      return null;
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  // Initialize database
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'preferences.db');

    print("Database initialized at: $path");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_preferences (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            preferred_metric TEXT,
            risk_tolerance TEXT,
            theme_mode INTEGER
          )
        ''');
        print("Database table created!");
      },
    );
  }
  
  // Save preferences (INSERT or UPDATE)
  static Future<void> savePreferences(String metric, String risk, bool theme) async {
    if (kIsWeb) {
      // Web implementation using SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('preferred_metric', metric);
      await prefs.setString('risk_tolerance', risk);
      await prefs.setBool('theme_mode', theme);
      print("Saved web preferences: Metric=$metric, Risk=$risk, DarkMode=$theme");
      return;
    }
    
    // Mobile implementation using SQLite
    final db = await database;
    if (db == null) return;

    // Check if a row already exists
    final existing = await db.query('user_preferences', limit: 1);

    if (existing.isNotEmpty) {
      // Update existing preferences
      await db.update(
        'user_preferences',
        {'preferred_metric': metric, 'risk_tolerance': risk, 'theme_mode': theme ? 1 : 0},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
      print("Updated Preferences: Metric=$metric, Risk=$risk, DarkMode=$theme");
    } else {
      // Insert new preferences
      await db.insert(
        'user_preferences',
        {'preferred_metric': metric, 'risk_tolerance': risk, 'theme_mode': theme ? 1 : 0},
      );
      print("Inserted New Preferences: Metric=$metric, Risk=$risk, DarkMode=$theme");
    }
  }
  
  // Get preferences
  static Future<Map<String, dynamic>> getPreferences() async {
    if (kIsWeb) {
      // Web implementation using SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        final metric = prefs.getString('preferred_metric');
        final risk = prefs.getString('risk_tolerance');
        final theme = prefs.getBool('theme_mode');
        
        print("Loaded web preferences: Metric=$metric, Risk=$risk, DarkMode=$theme");
        
        return {
          'preferred_metric': metric ?? 'Sharpe Ratio',
          'risk_tolerance': risk ?? 'Moderate',
          'theme_mode': theme ?? false
        };
      } catch (e) {
        print("Error loading web preferences: $e");
        return {'preferred_metric': 'Sharpe Ratio', 'risk_tolerance': 'Moderate', 'theme_mode': false};
      }
    }
    
    // Mobile implementation using SQLite
    try {
      final db = await database;
      if (db == null) {
        return {'preferred_metric': 'Sharpe Ratio', 'risk_tolerance': 'Moderate', 'theme_mode': false};
      }
      
      final result = await db.query('user_preferences', limit: 1);

      if (result.isNotEmpty) {
        print("Loaded Preferences: ${result[0]}");
        return {
          'preferred_metric': result[0]['preferred_metric'] as String,
          'risk_tolerance': result[0]['risk_tolerance'] as String,
          'theme_mode': result[0]['theme_mode'] == 1
        };
      }

      // Default preferences
      print("No preferences found, returning defaults.");
      return {'preferred_metric': 'Sharpe Ratio', 'risk_tolerance': 'Moderate', 'theme_mode': false};
    } catch (e) {
      print("Error loading preferences: $e");
      return {'preferred_metric': 'Sharpe Ratio', 'risk_tolerance': 'Moderate', 'theme_mode': false};
    }
  }
  
  // Clear preferences (Reset to default)
  static Future<void> clearPreferences() async {
    if (kIsWeb) {
      // Web implementation
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('preferred_metric');
      await prefs.remove('risk_tolerance');
      await prefs.remove('theme_mode');
      print("Web preferences cleared.");
      return;
    }
    
    // Mobile implementation
    try {
      final db = await database;
      if (db == null) return;
      
      await db.delete('user_preferences');
      print("User preferences cleared.");
    } catch (e) {
      print("Error clearing preferences: $e");
    }
  }
}