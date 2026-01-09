# Nama Aplikasi App - Flutter Application

<div align="center">
<url>
  <img src="https://lms.global.ac.id/lms/pluginfile.php/1/theme_klass/footerlogo/1745232397/logo-global-institute-stroke.png" alt="Institut Teknologi dan Bisnis Bina Sarana Global" width="200"/>
  </div>
<div align="center">
Institut Teknologi dan Bisnis Bina Sarana Global <br>
FAKULTAS TEKNOLOGI INFORMASI & KOMUNIKASI 
<br>
https://global.ac.id/
  </div>

  ##  Project UAS
  - Mata Kuliah : Aplikasi Mobile
  - Kelas : KS1234 
  - Semester : GANJIL 
  - Tahun Akademik: 2025 - 2026 
  
  

## About The Project

Nekomind adalah aplikasi mobile modern yang dikembangkan menggunakan Flutter untuk membantu user mencatat ide ide brilian mereka yang menyediakan antarmuka yang intuitif, fitur sinkronisasi cloud menggunakan firebase authentication , dan firebase store

Dengan fitur pencatatan dengan tampilan minimalis yang nikmat dipandang mata, fitur notifikasi pengingat untuk catatan, dan aplikasi yang sudah terintegrasi dengan akun google masing masing, serta fitur hapus yang masuk ke 'sampah' (Trash) dengan sistem delete otomatis setelah 7 hari, dan lain lain.

### Key Features

- **Modern UI/UX Design** - Antarmuka yang clean, minimalis, dan user-friendly
- **Google Integration** - Login mudah dan sinkronisasi dengan Akun Google
- **Pin Notes** - Sematkan catatan penting agar selalu di atas
- **Category System** - Pengelompokan catatan berdasarkan kategori
- **Trash & Auto Delete** - Fitur sampah dengan penghapusan otomatis setelah 7 hari
- **Push Notifications** - Reminder untuk catatan penting
- **Cloud Sync** - Sinkronisasi otomatis dengan Firebase

## Screenshots

<div align="center">
  <img src="screenshots/splash_login/splash1.jpg" alt="Splash Screen" width="200"/>
  <img src="screenshots/splash_login/splash2.jpg" alt="Splash Screen" width="200"/>
  <img src="screenshots/splash_login/splash3.jpg" alt="Splash Screen" width="200"/>
  <img src="screenshots/splash_login/splash4.jpg" alt="Splash Screen" width="200"/>
  <img src="screenshots/login_screen.png" alt="Login" width="200"/>
  <img src="screenshots/home_screen.png" alt="Home" width="200"/>
  <img src="screenshots/profile_screen.png" alt="Profile" width="200"/>
</div>

<div align="center">
  <img src="screenshots/note_detail.png" alt="Note Detail" width="200"/>
  <img src="screenshots/search.png" alt="Search" width="200"/>
  <img src="screenshots/category.png" alt="Category" width="200"/>
  <img src="screenshots/settings.png" alt="Settings" width="200"/>
</div>

## Demo Video

Lihat video demo aplikasi kami untuk melihat semua fitur dalam aksi!

**[Watch Full Demo on YouTube](https://youtube.com/watch?v=dQw4w9WgXcQ)**

Alternative link: **[Google Drive Demo](https://drive.google.com/file/d/1234567890/view)**

## Download APK

Download versi terbaru aplikasi Notes App:

### Latest Release v1.0.0
- [**Download APK (15.2 MB)**](https://github.com/yourusername/notes-app/releases/download/v1.0.0/notes-app-v1.0.0.apk)


**Minimum Requirements:**
- Android 6.0 (API level 23) or higher
- ~20MB free storage space

## Built With

- **[Flutter](https://flutter.dev/)** - UI Framework
- **[Dart](https://dart.dev/)** - Programming Language
- **[Firebase Auth](https://firebase.google.com/products/auth)** - Google Sign-In & Authentication
- **[Firebase Firestore](https://firebase.google.com/products/firestore)** - Cloud Database
- **[Provider](https://pub.dev/packages/provider)** - State Management


## Getting Started

### Prerequisites

Pastikan Anda sudah menginstall:
- Flutter SDK (3.16.0 or higher)
- Dart SDK (3.2.0 or higher)
- Android Studio / VS Code
- Git

### Installation

1. Clone repository
```bash
git clone https://github.com/yourusername/notes-app.git
cd notes-app
```

2. Install dependencies
```bash
flutter pub get
```

3. Setup Firebase
```bash
# Download google-services.json dari Firebase Console
# Place in android/app/
cp path/to/google-services.json android/app/
```

4. Run aplikasi
```bash
flutter run
```

### Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APK by ABI
flutter build apk --split-per-abi
```

## 📁 Project Structure

```
lib/
├── main.dart                 # Entry point
├── app/
│   ├── routes/              # App routing
│   └── themes/              # App themes
├── models/                   # Data models
│   ├── user.dart
│   └── category.dart
├── screens/                  # UI Screens
│   ├── splash/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   ├── profile/
│   └── settings/
├── widgets/                  # Reusable widgets
├── services/                 # Business logic
│   ├── auth_service.dart
│   ├── database_service.dart
│   └── notification_service.dart
└── utils/                    # Utilities & helpers
```

## Authentication Flow

1. Splash Screen (Auto-login check)
   ↓
2. Login with Google (Firebase Auth)
   ↓
3. Home Screen (Dashboard with Cloud Sync)
   ↓
4. Profile & Settings

## 🗄️ Database Schema

### Notes Table
```sql
CREATE TABLE tableABC (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  title TEXT NOT NULL,
  content TEXT,
  category_id TEXT,
  created_at INTEGER,
  updated_at INTEGER,
  is_synced INTEGER DEFAULT 0
);
```


## 📝 API Documentation

### Authentication Endpoints
- `POST /api/auth/register` - Register user baru
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user
- `GET /api/auth/verify` - Verify token

### Development Workflow

1. Fork repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## Team Members & Contributions

### Development Team

| Name | Role | Contributions |
|------|------|---------------|
| **Asis** | Project Lead & Backend Developer | - Authentication system<br>- Firebase integration<br>- API development<br>- Database design |
| **Helen** | Frontend Developer | - UI/UX Design<br>- Home screen implementation<br>- Profile screen<br>- State management |
| **Rio** | Full Stack Developer | - Splash screen<br>- Register screen<br>- Notification system<br>- Push notifications (FCM) |
| **Adit** | Mobile Developer | - Login screen<br>- Local database (SQLite)<br>- Offline sync logic<br>- Testing & QA |


## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.



## Acknowledgments

- [Flutter Community](https://flutter.dev/community) - For amazing packages
- [Firebase](https://firebase.google.com/) - For backend services
- [Flaticon](https://www.flaticon.com/) - For app icons
- [Unsplash](https://unsplash.com/) - For placeholder images



---

<div align="center">
  <p>Made with by love of the Team</p>
  <p>© 2026 Notes App. All rights reserved.</p>
</div>