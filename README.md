# Resume UltraProMax

A comprehensive resume building application that allows users to create professional resumes with real-time preview and PDF generation. Built with Flutter web frontend and Python Flask backend for a seamless, modern experience.

## 🚀 Tech Stack

**Frontend:** Flutter Web with responsive design  
**Backend:** Python Flask with LaTeX PDF generation  
**Database:** Firebase Firestore for user data  
**Authentication:** Firebase Auth with Google Sign-In  
**Deployment:** Vercel (Frontend) + Render (Backend)  

## 📁 Project Structure

```
resume_ultrapromax/
├── frontend/                 # Flutter web application
│   ├── lib/
│   │   ├── app.dart          # Main app entry point
│   │   ├── features/         # Feature-based architecture
│   │   │   ├── auth/         # Authentication module
│   │   │   ├── builder/      # Resume builder interface
│   │   │   ├── landing/      # Landing page
│   │   │   └── preview/      # PDF preview
│   │   ├── services/         # External service integrations
│   │   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   └── pdf_service.dart
│   │   ├── shared/widgets/   # Reusable UI components
│   │   └── core/            # Theme and utilities
│   ├── pubspec.yaml         # Flutter dependencies
│   └── web/                # Web assets
├── backend/                 # Python Flask API
│   ├── app.py              # Main Flask application
│   ├── requirements.txt    # Python dependencies
│   ├── Dockerfile          # Container configuration
│   ├── resume_template.tex # LaTeX template
│   └── resume_full.tex     # Generated LaTeX output
└── README.md
```

## 🎨 Features

**Authentication:** Seamless Google Sign-In integration  
**Resume Builder:** Intuitive form-based interface with real-time validation  
**Live Preview:** Instant preview as users type  
**PDF Generation:** Professional LaTeX-generated PDF documents  
**Data Persistence:** Cloud storage with Firebase Firestore  
**Responsive Design:** Mobile-first approach for all screen sizes  
**Real-time Updates:** Live form validation and auto-save  

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Python 3.9+
- Firebase project with Authentication and Firestore enabled

### Development Setup
```bash
# Install dependencies
cd frontend && flutter pub get
cd ../backend && pip install -r requirements.txt

# Start development servers (in separate terminals)
# Terminal 1: Backend
cd backend && python app.py

# Terminal 2: Frontend  
cd frontend && flutter run -d chrome

Open http://localhost:3000 to see the application.
```
