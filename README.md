# 📈 ProfitCompare – Smart Investment Comparison & Advisory App

ProfitCompare is a cross-platform Flutter application that helps users compare and analyze their investments across asset classes such as Fixed Income, Equity, and Alternate Investments. The app provides visual allocation breakdowns, personalized suggestions powered by Gemini AI, and real-time financial news insights.

## 🚀 Features

* 📈 Visual asset allocation breakdown (pie chart)
* 🧠 Gemini-powered AI investment advice
* 📰 Real-time financial news using NewsData.io API
* 🔐 Firebase Authentication and Firestore for secure data storage
* ✨ Clean, responsive, and intuitive user interface

## 🛠️ Tech Stack

* **Flutter + Dart**
* **Firebase Auth & Firestore**
* **Gemini API** (Google Generative AI)
* **NewsData.io API**
* Packages used: `fl_chart`, `firebase_core`, `flutter_markdown`, `google_fonts`, etc.

## 📦 Installation Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/profitcompare.git
cd profitcompare
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Add Required API Keys

Create a `.env` file or inject these keys into your project setup:

```env
NEWS_API_KEY=your_newsdata_api_key
GEMINI_API_KEY=your_gemini_api_key
```

## 🔑 Required API Keys

### 1. 📰 NewsData.io API Key
* Register: https://newsdata.io
* Navigate to Dashboard → Get API Key
* Used for fetching financial news for Gold, Nifty 50, Mutual Funds, etc.

### 2. 🤖 Gemini API Key (Google Generative AI)
* Register: https://makersuite.google.com/app/apikey
* Generate a Gemini (Generative AI) API Key
* Used to get personalized investment suggestions inside the app

## 🔥 Firebase Setup

To use Firebase Authentication and Firestore:

* Add `google-services.json` to: `android/app/`
* Add `GoogleService-Info.plist` to: `ios/Runner/`
* Configure authentication providers in your Firebase Console
* Setup Firestore database and rules as needed

**Note:** These files are ignored via `.gitignore` and must not be pushed to GitHub.

## ▶️ Run the App

To launch on emulator/device:

```bash
flutter run
```

To build an APK:

```bash
flutter build apk
```


## 🙇‍♂️ Developed By

**Jatin Navani**  
jatin11.navani@gmail.com  
www.jatinnavani.in

---

⭐ If you like this project, feel free to star the repo and share it!
