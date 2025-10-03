# 🚀 Resume UltraProMax Deployment Guide

This guide will help you deploy your Resume UltraProMax application to Render (backend) and Vercel (frontend).

## 📋 Prerequisites

- GitHub repository with your code
- Render account (free tier available)
- Vercel account (free tier available)
- Firebase project configured

## 🔧 Backend Deployment (Render)

### Step 1: Prepare Your Repository

Make sure your `backend/` directory contains:
- ✅ `app.py` - Your Flask application
- ✅ `requirements.txt` - Python dependencies
- ✅ `render.yaml` - Render configuration (optional)
- ✅ `Dockerfile` - Docker configuration (optional)

### Step 2: Deploy to Render

1. **Go to [Render.com](https://render.com)**
   - Sign up or login to your account

2. **Create New Web Service**
   - Click "New +" → "Web Service"
   - Connect your GitHub repository

3. **Configure the Service**
   ```
   Name: resume-backend
   Environment: Python 3
   Region: Oregon (US West) or Frankfurt (EU)
   Branch: main (or your default branch)
   Root Directory: backend
   ```

4. **Build & Deploy Settings**
   ```
   Build Command: pip install -r requirements.txt
   Start Command: gunicorn --bind 0.0.0.0:$PORT app:app
   ```

   **⚠️ IMPORTANT: For PDF Generation to Work**
   
   Since your app generates PDFs using LaTeX, you need to install LaTeX system dependencies. Choose one of these options:

   **Option A: Use Docker (Recommended)**
   ```
   Environment: Docker
   Dockerfile Path: backend/Dockerfile
   ```
   The Dockerfile already includes LaTeX installation.

   **Option B: Add Build Script**
   ```
   Build Command: apt-get update && apt-get install -y texlive-latex-base texlive-latex-extra texlive-fonts-recommended && pip install -r requirements.txt
   Start Command: gunicorn --bind 0.0.0.0:$PORT app:app
   ```

5. **Advanced Settings**
   ```
   Health Check Path: /api/health
   Auto-Deploy: Yes (recommended)
   ```

6. **Deploy**
   - Click "Create Web Service"
   - Wait for deployment to complete
   - Note your service URL (e.g., `https://resume-backend.onrender.com`)

### Step 3: Test Backend

Visit your Render URL + `/api/health` to verify it's working:
```
https://your-service-name.onrender.com/api/health
```

## 🎨 Frontend Deployment (Vercel)

### Step 1: Prerequisites Check

Before deploying, ensure you have:

- ✅ **Backend deployed and working** (LaTeX available)
- ✅ **Firebase project configured** with Authentication and Firestore enabled
- ✅ **Flutter SDK installed** locally (for testing)
- ✅ **Git repository** with all code committed

### Step 2: Update Backend URL

**CRITICAL**: You must update the backend URL before deploying:

1. **Get your Render backend URL**
   - Go to your Render dashboard
   - Copy your service URL (e.g., `https://resume-backend-abc123.onrender.com`)

2. **Edit `frontend/lib/services/pdf_service.dart`**
   ```dart
   // Find this line (around line 11):
   static const String _baseUrl = 'YOUR_RENDER_BACKEND_URL';
   
   // Replace with your actual Render URL:
   static const String _baseUrl = 'https://resume-backend-abc123.onrender.com';
   ```

3. **Test locally** (optional but recommended):
   ```bash
   cd frontend
   flutter pub get
   flutter build web --release
   flutter run -d chrome
   ```

4. **Commit and push changes**:
   ```bash
   git add frontend/lib/services/pdf_service.dart
   git commit -m "Update backend URL for production"
   git push
   ```

### Step 3: Deploy to Vercel

1. **Go to [Vercel.com](https://vercel.com)**
   - Sign up with GitHub (recommended)
   - Or sign up with email and connect GitHub later

2. **Import Project**
   - Click **"New Project"**
   - Find your `resume_ultrapromax` repository
   - Click **"Import"**

3. **Configure Project Settings**
   ```
   Project Name: resume-ultrapromax (or your preferred name)
   Framework Preset: Other
   Root Directory: frontend
   ```

4. **Build Settings** (VERY IMPORTANT)
   ```
   Build Command: flutter build web --release
   Output Directory: build/web
   Install Command: flutter pub get
   ```

5. **Environment Variables** (if needed)
   - Most Firebase config is in your code, but if you have any secrets:
   - Click **"Add"** and add any environment variables
   - Usually not needed for this project

6. **Deploy**
   - Click **"Deploy"**
   - Wait for build to complete (5-10 minutes)
   - Note your Vercel URL (e.g., `https://resume-ultrapromax.vercel.app`)

### Step 4: Verify Deployment

1. **Visit your Vercel URL**
2. **Test the complete flow**:
   - Landing page loads ✅
   - Click "Get Started" → Google Sign-In dialog appears ✅
   - Sign in with Google ✅
   - Resume builder loads ✅
   - Fill out some data ✅
   - Click "Save" → Success message ✅
   - Click "Generate Preview" → PDF generates ✅
   - Download PDF works ✅

### Step 5: Update Firebase Settings (if needed)

If you encounter CORS issues:

1. **Go to Firebase Console**
2. **Authentication → Settings → Authorized domains**
3. **Add your Vercel domain**:
   ```
   resume-ultrapromax.vercel.app
   ```
4. **Firestore → Rules** (if needed):
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

## 🔗 Integration Testing

### Step 1: Test Full Flow

1. **Visit your Vercel URL**
2. **Sign in with Google** (Firebase Auth)
3. **Fill out resume form**
4. **Click "Save"** (Firestore integration)
5. **Click "Generate Preview"** (Backend API call)
6. **Download PDF** (End-to-end test)

### Step 2: Verify All Components

- ✅ Landing page loads
- ✅ Google Sign-In works
- ✅ Resume builder loads
- ✅ Data saves to Firestore
- ✅ PDF generation works
- ✅ PDF download works

## 🛠️ Troubleshooting

### Backend Issues

**Problem: Build fails**
- Check `requirements.txt` syntax
- Ensure all dependencies are listed
- Verify Python version compatibility

**Problem: Service won't start**
- Check `startCommand` in Render settings
- Verify `app.py` has correct Flask app instance
- Check logs in Render dashboard

**Problem: Health check fails**
- Ensure `/api/health` endpoint exists in your Flask app
- Check if service is binding to `0.0.0.0:$PORT`

**Problem: LaTeX not available (`"latex_available": false`)**
- This means PDF generation will fail
- **Solution 1**: Switch to Docker deployment (recommended)
  - Go to Render dashboard → Settings → Environment
  - Change from "Python 3" to "Docker"
  - Set Dockerfile Path to `backend/Dockerfile`
  - Redeploy
- **Solution 2**: Add LaTeX to build command
  - Go to Render dashboard → Settings → Build & Deploy
  - Update Build Command to:
    ```
    apt-get update && apt-get install -y texlive-latex-base texlive-latex-extra texlive-fonts-recommended && pip install -r requirements.txt
    ```
  - Redeploy
- **Verify**: Check `/api/health` should return `"latex_available": true`

### Frontend Issues

**Problem: Build fails**
- Run `flutter clean && flutter pub get` locally first
- Check `pubspec.yaml` for syntax errors
- Ensure all dependencies are compatible

**Problem: PDF generation fails**
- Verify backend URL is correct in `pdf_service.dart`
- Check CORS settings in Flask app
- Test backend health endpoint

**Problem: Firebase errors**
- Verify Firebase configuration
- Check Firebase project settings
- Ensure authentication is enabled

## 📊 Monitoring & Maintenance

### Render Monitoring
- Check Render dashboard for service health
- Monitor logs for errors
- Set up alerts for downtime

### Vercel Monitoring
- Check Vercel dashboard for build status
- Monitor function logs
- Set up analytics if needed

### Firebase Monitoring
- Monitor Firebase console for usage
- Check Firestore usage and limits
- Monitor authentication metrics

## 🔄 Updates & Redeployment

### Backend Updates
1. Make changes to `backend/` code
2. Commit and push to GitHub
3. Render auto-deploys (if enabled)
4. Or manually redeploy from Render dashboard

### Frontend Updates
1. Make changes to `frontend/` code
2. Update backend URL if needed
3. Commit and push to GitHub
4. Vercel auto-deploys (if enabled)
5. Or manually redeploy from Vercel dashboard

## 💰 Cost Considerations

### Render (Free Tier)
- 750 hours/month free
- Service sleeps after 15 minutes of inactivity
- Cold start delay (~30 seconds)
- Upgrade to paid plan for always-on service

### Vercel (Free Tier)
- Unlimited static deployments
- 100GB bandwidth/month
- Perfect for frontend hosting

### Firebase (Free Tier)
- 50,000 reads/day
- 20,000 writes/day
- 1GB storage
- Sufficient for most resume applications

## 🎯 Production Checklist

Before going live:

- [ ] Backend deployed and health check passes
- [ ] **LaTeX available** (`/api/health` returns `"latex_available": true`)
- [ ] Frontend deployed and loads correctly
- [ ] Google Sign-In works in production
- [ ] Resume data saves to Firestore
- [ ] PDF generation works end-to-end
- [ ] All URLs updated (no localhost references)
- [ ] Firebase security rules configured
- [ ] Error handling tested
- [ ] Performance acceptable
- [ ] Mobile responsiveness checked

## 📞 Support

If you encounter issues:

1. **Check Render logs** for backend errors
2. **Check Vercel logs** for frontend build errors
3. **Check Firebase console** for database/auth issues
4. **Test locally** to isolate problems
5. **Review this guide** for common solutions

---

**Happy Deploying! 🚀**

Your Resume UltraProMax application should now be live and ready for users to create professional resumes!
