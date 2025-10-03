# Product Requirements Document (PRD)
## Resume UltraProMax - Complete Full-Stack Implementation

---

## 1. Project Overview

### 1.1 Project Identity
- **Project Name:** Resume UltraProMax
- **Platform:** Flutter Web
- **Frontend Deployment:** Vercel
- **Backend Deployment:** Render (Already Implemented)
- **Backend Framework:** Flask (Python)
- **Authentication:** Firebase Authentication (Google Sign-In)
- **Database:** Cloud Firestore
- **PDF Generation:** LaTeX (Backend Service)
- **Current Scope:** Full-Stack MVP with Firebase Integration

### 1.2 Project Vision
A modern, clean resume builder web application inspired by Notion's minimal and elegant design language. Users can authenticate with Google, build their professional resume using an intuitive form interface, save their data to the cloud, and generate beautiful PDF resumes using LaTeX templates. The UI emphasizes clarity, subtle interactions, and a warm, professional aesthetic with a light color scheme.

### 1.3 Success Criteria
- Clean, reusable Flutter widget architecture
- Consistent Notion-inspired design system (light, minimal, warm tones)
- Smooth navigation and subtle transitions
- Responsive layout for web (desktop-first, tablet-compatible)
- Seamless Firebase Authentication and Firestore integration
- Persistent data storage with real-time sync
- Professional PDF generation via backend service
- Data management (save, load, reset, update)

---

## 2. Technical Architecture

### 2.1 Technology Stack
```
Frontend Framework: Flutter Web (Latest Stable)
State Management: Riverpod 2.x
Navigation: Navigator 2.0 (Manual routing without GoRouter)
UI Components: Material 3 + Custom Widgets
Fonts: Google Fonts (Inter/Poppins)

Authentication: Firebase Authentication (Google Sign-In)
Database: Cloud Firestore
Cloud Platform: Firebase (Google Cloud)

Backend Framework: Flask (Python) - Already Implemented
PDF Generation: LaTeX (pdflatex) - Already Implemented
Backend Hosting: Render
API Communication: HTTP REST API
```

### 2.2 Project Structure
```
lib/
├── main.dart                          # App entry point
├── app.dart                           # Root app widget with auth check
├── core/
│   ├── theme/
│   │   ├── app_theme.dart            # Theme definitions
│   │   ├── app_colors.dart           # Color palette
│   │   └── app_text_styles.dart      # Typography
│   ├── constants/
│   │   └── app_constants.dart        # App-wide constants
│   └── utils/
│       ├── scroll_utils.dart         # Scroll helpers
│       └── validators.dart           # Input validation utilities
├── services/
│   ├── auth_service.dart             # Firebase Auth wrapper
│   ├── firestore_service.dart        # Firestore CRUD operations
│   └── pdf_service.dart              # Backend API communication
├── features/
│   ├── auth/
│   │   ├── presentation/
│   │   │   └── widgets/
│   │   │       └── google_sign_in_dialog.dart  # Sign-in popup
│   │   └── providers/
│   │       └── auth_provider.dart    # Auth state management
│   ├── landing/
│   │   ├── presentation/
│   │   │   ├── landing_page.dart     # Landing screen
│   │   │   └── widgets/
│   │   │       ├── hero_section.dart
│   │   │       ├── info_cards.dart
│   │   │       └── top_navbar.dart
│   ├── builder/
│   │   ├── models/
│   │   │   └── resume_data.dart      # Data models
│   │   ├── providers/
│   │   │   ├── resume_provider.dart  # Resume state management
│   │   │   └── ui_state_provider.dart # Loading/error states
│   │   ├── presentation/
│   │   │   ├── builder_page.dart     # Main builder screen
│   │   │   └── widgets/
│   │   │       ├── sidebar_menu.dart
│   │   │       ├── profile_avatar.dart
│   │   │       ├── section_card.dart
│   │   │       ├── sections/
│   │   │       │   ├── profile_section.dart
│   │   │       │   ├── education_section.dart
│   │   │       │   ├── experience_section.dart
│   │   │       │   ├── projects_section.dart
│   │   │       │   ├── skills_section.dart
│   │   │       │   ├── leadership_section.dart
│   │   │       │   └── achievements_section.dart
│   │   │       └── action_bar.dart
│   └── preview/
│       └── presentation/
│           ├── preview_page.dart     # Preview screen with PDF
│           └── widgets/
│               └── pdf_viewer_widget.dart  # PDF display
└── shared/
    └── widgets/
        ├── notion_button.dart        # Reusable Notion-style button
        ├── notion_card.dart          # Reusable Notion-style card
        ├── notion_text_field.dart    # Reusable input field
        ├── notion_chip.dart          # Chip component for skills
        ├── loading_overlay.dart      # Loading states
        └── error_dialog.dart         # Error handling UI
```

---

## 3. Design System Specification

### 3.1 Color Palette
```dart
// app_colors.dart - Notion-inspired theme
class AppColors {
  // Primary (Light mode inspired by Notion)
  static const Color background = Color(0xFFFFFFFF);      // Pure white
  static const Color surface = Color(0xFFF7F6F3);         // Warm off-white
  static const Color surfaceHover = Color(0xFFEFEEEB);    // Slightly darker on hover
  
  // Text
  static const Color textPrimary = Color(0xFF37352F);     // Dark brown-grey
  static const Color textSecondary = Color(0xFF787774);   // Medium grey
  static const Color textTertiary = Color(0xFF9B9A97);    // Light grey
  
  // Borders & Dividers
  static const Color border = Color(0xFFE9E9E7);          // Subtle border
  static const Color divider = Color(0xFFEDECE9);         // Divider line
  
  // Sidebar
  static const Color sidebarBackground = Color(0xFFF7F6F3);
  static const Color sidebarHover = Color(0xFFEFEEEB);
  static const Color sidebarActive = Color(0xFFE9E9E7);
  
  // Accents
  static const Color primary = Color(0xFF2383E2);         // Notion blue
  static const Color primaryHover = Color(0xFF1F7CD6);
  
  // Functional
  static const Color error = Color(0xFFEB5757);
  static const Color success = Color(0xFF0F7B6C);
  static const Color warning = Color(0xFFF2994A);
  
  // Overlay
  static const Color overlayBackground = Color(0x80000000); // Semi-transparent black
}
```

### 3.2 Typography
```dart
// app_text_styles.dart - Notion-inspired typography
Font Family: 'Inter' (primary)

Heading Styles:
- H1 (Page Title): 40px, Bold, Letter Spacing -0.8, Line Height 1.2
- H2 (Section): 28px, Bold, Letter Spacing -0.4, Line Height 1.3
- H3 (Subsection): 20px, SemiBold, Letter Spacing -0.2, Line Height 1.4

Body Styles:
- Body Large: 16px, Regular, Letter Spacing 0, Line Height 1.6
- Body Medium: 15px, Regular, Letter Spacing 0, Line Height 1.5
- Body Small: 14px, Regular, Letter Spacing 0, Line Height 1.5

Button Text: 14px, Medium, Letter Spacing 0, Normal case (not uppercase)
Label Text: 13px, Medium, Letter Spacing 0
```

### 3.3 Component Specifications

#### Card (Notion-style)
```
Background: White (#FFFFFF)
Border: 1px solid Color(0xFFE9E9E7)
Border Radius: 6px
Padding: 20px
Shadow: None (or very subtle: 0 1px 2px rgba(0,0,0,0.04))
Hover: Background changes to Color(0xFFF7F6F3)
```

#### Button (Primary)
```
Background: Color(0xFF2383E2)
Text Color: White
Border: None
Border Radius: 6px
Padding: 8px 16px
Height: 36px
Hover: Background Color(0xFF1F7CD6)
Transition: 150ms ease
```

#### Button (Secondary)
```
Background: Color(0xFFF7F6F3)
Text Color: Color(0xFF37352F)
Border: 1px solid Color(0xFFE9E9E7)
Border Radius: 6px
Padding: 8px 16px
Height: 36px
Hover: Background Color(0xFFEFEEEB)
Transition: 150ms ease
```

#### Text Field (Notion-style)
```
Background: White
Border: 1px solid Color(0xFFE9E9E7)
Border Radius: 4px
Padding: 8px 12px
Height: 36px
Focus: Border Color(0xFF2383E2), Shadow 0 0 0 2px rgba(35,131,226,0.1)
Placeholder: Color(0xFF9B9A97)
```

#### Dialog (Sign-in Popup)
```
Background: White
Border: None
Border Radius: 12px
Padding: 32px
Shadow: 0 8px 24px rgba(0,0,0,0.12)
Max Width: 400px
Close Button: Top-right, 24px from edges, grey color
```

### 3.4 Spacing System
```
xs: 4px
sm: 8px
md: 16px
lg: 24px
xl: 32px
2xl: 48px
3xl: 64px
```

### 3.5 Animations
```
Duration Fast: 100ms
Duration Normal: 200ms
Duration Slow: 350ms

Curve: Curves.easeOut (Notion uses subtle easing)
Scroll Behavior: Smooth (duration: 500ms)
Hover Transitions: 150ms
Dialog Fade In: 200ms
```

---

## 4. Feature Specifications

### 4.1 Landing Page

#### 4.1.1 Top Navbar
**Components:**
- App Logo/Name (Left aligned) - Uses Notion-style logo design
- **View Example Button (Right aligned)** - Notion secondary button style
  - **NOT CLICKABLE** (visual only, to be implemented later)
  - Shows hover effect but no action

**Behavior:**
- Clean white background with subtle bottom border
- Fixed position at top

#### 4.1.2 Hero Section
**Components:**
- Main Heading: "Build your professional resume in minutes."
- Subtext: "Simple, clean, and ready-to-download resumes built instantly."
- **CTA Button: "Get Started →"**

**Behavior:**
- Centered content with max-width constraint
- **CTA button opens Google Sign-In Dialog (popup)**
- Smooth fade-in animation on load

#### 4.1.3 Info Section
**Components:**
- 3 Cards showing:
  1. Fill Details
  2. Preview
  3. Download

**Behavior:**
- Horizontal layout with equal spacing
- Cards have subtle hover effect (background color change to surface color)
- Minimal shadow or no shadow, relying on borders

---

### 4.2 Authentication Flow

#### 4.2.1 Google Sign-In Dialog
**Trigger:** Clicking "Get Started" button on Landing Page

**Visual Design:**
```
┌─────────────────────────────────────────┐
│                                    [X]  │
│                                         │
│        Sign in to get started          │
│                                         │
│  ┌─────────────────────────────────┐  │
│  │  [G] Sign in with Google    │  │
│  └─────────────────────────────────┘  │
│                                         │
└─────────────────────────────────────────┘
```

**Components:**
1. Dialog Container
   - White background with rounded corners (12px)
   - Centered on screen with overlay background
   - Max width: 400px
   - Padding: 32px

2. Close Button (X)
   - Top-right corner
   - Grey color (textSecondary)
   - Icon button with hover effect
   - Closes dialog and returns to Landing Page

3. Heading
   - Text: "Sign in to get started"
   - Centered, H3 style
   - Margin bottom: 24px

4. Sign in with Google Button
   - Full width within dialog
   - White background with border
   - Google logo icon on left
   - Text: "Sign in with Google"
   - Hover effect: subtle background change

**Behavior Flow:**

**Case 1: User is Already Authenticated (Previously Logged In)**
```
1. User clicks "Get Started" → Dialog opens
2. User clicks "Sign in with Google"
3. AuthService checks: `FirebaseAuth.instance.currentUser != null`
4. If authenticated: Skip sign-in process
5. Close dialog
6. Navigate directly to Builder Page
7. Load user's saved data from Firestore
```

**Case 2: User is Not Authenticated (First Time or Logged Out)**
```
1. User clicks "Get Started" → Dialog opens
2. User clicks "Sign in with Google"
3. AuthService checks: `FirebaseAuth.instance.currentUser == null`
4. Trigger Firebase Google Sign-In flow
5. Show loading indicator in dialog
6. On success:
   - Close dialog
   - Navigate to Builder Page
   - Initialize empty resume data (or load if exists)
7. On error:
   - Show error message in dialog
   - Keep dialog open for retry
```

**Firebase Authentication Implementation:**
```dart
// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Check if user is already signed in
  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Get user ID for Firestore
  String? get userId => currentUser?.uid;
}
```

**Error Handling:**
- Network errors: "No internet connection. Please try again."
- Sign-in cancelled: Close dialog silently
- Firebase errors: "Something went wrong. Please try again."
- Show errors as toast/snackbar at bottom of dialog

---

### 4.3 Builder Page

#### 4.3.1 Layout Structure
```
┌─────────────────────────────────────────────────┐
│  [Action Bar - Save | Generate Preview]        │
├──────────┬──────────────────────────────────────┤
│          │                                       │
│ Sidebar  │         Main Form Area               │
│          │         (Scrollable)                  │
│ - Avatar │                                       │
│ - Reset  │  ┌─────────────────────────────┐    │
│ - Logout │  │  Profile Section Card       │    │
│ - Menu   │  └─────────────────────────────┘    │
│          │  ┌─────────────────────────────┐    │
│          │  │  Education Section Card     │    │
│          │  └─────────────────────────────┘    │
│          │  ...                                 │
│          │                                       │
└──────────┴──────────────────────────────────────┘
```

#### 4.3.2 Left Sidebar (Fixed, Scrollable Content)
**Width:** 240px (fixed, Notion-style)
**Background:** Color(0xFFF7F6F3) - Warm off-white

**Components:**

1. **Profile Avatar Section**
   - Circular avatar (48px diameter)
   - Displays user's Google profile picture
   - Fallback: User initials from email
   - Padding: 16px

2. **Action Buttons** (Below Avatar)
   - **Reset Data Button**
     - Secondary button style
     - Icon: Refresh/Reset icon
     - Text: "Reset Data"
     - Full width with margin
     - **On Click: Show confirmation dialog**
     - **Action: Deletes all data from Firestore**
     - **Result: Empty fields on Builder Page**
   
   - **Logout Button**
     - Secondary button style (red accent for danger)
     - Icon: Logout icon
     - Text: "Logout"
     - Full width with margin
     - **On Click: Show confirmation dialog**
     - **Action: Signs out user and navigates to Landing Page**

3. **Section Navigation Menu**
   - Vertical list of section links
   - Items with icons:
     - 👤 Profile
     - 🎓 Education
     - 💼 Experience
     - 🚀 Projects
     - ⚡ Skills
     - 👥 Leadership & Activities
     - 🏆 Achievements & Certifications
   - Active state: Background Color(0xFFE9E9E7) + font weight 500
   - Hover state: Background Color(0xFFEFEEEB)
   - Each item: 4px border-radius, 6px padding
   - **On Click: Smoothly scrolls to corresponding section**

**Behaviors:**

**Reset Data Button:**
```
1. User clicks "Reset Data"
2. Show confirmation dialog:
   - Title: "Reset All Data?"
   - Message: "This will permanently delete all your resume data from cloud storage. This action cannot be undone."
   - Buttons: "Cancel" | "Reset" (red, primary style)
3. If confirmed:
   - Show loading overlay
   - Call FirestoreService.deleteUserData(userId)
   - Clear local state (ResumeProvider.reset())
   - Show success toast: "Data reset successfully"
   - All fields become empty on Builder Page
4. If cancelled: Close dialog, no action
```

**Logout Button:**
```
1. User clicks "Logout"
2. Show confirmation dialog:
   - Title: "Sign Out?"
   - Message: "Make sure you've saved your work before signing out."
   - Buttons: "Cancel" | "Sign Out" (primary style)
3. If confirmed:
   - Show loading overlay
   - Call AuthService.signOut()
   - Clear local state
   - Navigate to Landing Page
   - Show success toast: "Signed out successfully"
4. If cancelled: Close dialog, no action
```

**Section Navigation:**
```
1. User clicks on a section item (e.g., "Education")
2. Main content area scrolls smoothly to that section
3. Scroll animation: 500ms with easeOut curve
4. Active section highlights in sidebar
5. Scroll listener updates active state based on visible section
```

**Implementation:**
```dart
// Scroll to section
void scrollToSection(String sectionId) {
  final context = sectionKeys[sectionId]?.currentContext;
  if (context != null) {
    Scrollable.ensureVisible(
      context,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
      alignment: 0.1, // Scroll to 10% from top
    );
  }
}

// Update active section on scroll
ScrollController _scrollController = ScrollController();

@override
void initState() {
  super.initState();
  _scrollController.addListener(_updateActiveSection);
}

void _updateActiveSection() {
  // Check which section is currently visible
  // Update activeSectionProvider accordingly
}
```

#### 4.3.3 Main Form Area
**Width:** Flexible (remaining space with max-width: 800px, centered)
**Background:** White (#FFFFFF)

**Data Persistence Behavior:**

**On Page Load:**
```
1. Builder Page mounts
2. Check Firebase Auth state:
   - If authenticated: Proceed
   - If not: Redirect to Landing Page
3. Show loading overlay
4. Call FirestoreService.loadUserData(userId)
5. If data exists in Firestore:
   - Populate all fields with saved data
   - Show success toast: "Data loaded"
6. If no data exists:
   - Show empty fields (initial state)
   - No toast message
7. Hide loading overlay
```

**Manual Save (Save Button in Action Bar):**
```
1. User fills/edits fields
2. User clicks "Save" button
3. Validate all fields (optional, basic validation)
4. Show loading overlay
5. Get current form data from ResumeProvider
6. Call FirestoreService.saveUserData(userId, resumeData)
7. On success:
   - Hide loading overlay
   - Show success toast: "Saved successfully"
   - Keep user on Builder Page
8. On error:
   - Hide loading overlay
   - Show error dialog: "Failed to save. Please try again."
```

**Important Note:**
```
⚠️ If user doesn't manually save using the "Save" button:
   - Data will be lost if they navigate away
   - Data will be lost if they logout
   - Data will be lost if they close browser
   - User must explicitly click "Save" to persist data
```

**Structure:**
Each section is a `NotionCard` (white background, subtle border) containing:
- Section heading (H2 style, Notion typography)
- Form fields appropriate to section
- "+Add" button for repeatable sections (Notion secondary button style)
- Remove/Delete buttons for individual entries

**Section Details:**

**Profile Section** (Single entry, non-repeatable)
```
Fields:
- Full Name (TextField, required)
- Phone (TextField, phone format, required)
- Email (TextField, email validation, required, auto-filled from Google)
- LinkedIn URL (TextField, optional)
- GitHub URL (TextField, optional)
- Website URL (TextField, optional)
- Summary (Multiline TextField, 3-5 lines, optional)
  - Label: "Professional Summary"
  - Placeholder: "Brief summary of your professional background..."
```

**Education Section** (Repeatable)
```
Fields per entry:
- University/Institution Name (TextField, required)
- Degree/Program (TextField, required)
- Date/Duration (TextField, required) - e.g., "2021 - 2025"
- CGPA/GPA (TextField, optional) - e.g., "CGPA: 7.76/10"

Buttons:
- [+ Add Education] - At bottom of section
- [Remove] icon (X button) - Top-right of each entry card
  - Only visible if more than 1 entry exists
  - On click: Remove entry from UI and state immediately

Minimum Entries: 1 (cannot delete the last one)
```

**Experience Section** (Repeatable)
```
Fields per entry:
- Company Name (TextField, required)
- Role/Position (TextField, required)
- Location (TextField, optional) - e.g., "San Francisco, CA"
- Date/Duration (TextField, required) - e.g., "May 2024 - Aug 2024"
- Points/Description (Dynamic list of TextFields)
  - Each point: Multiline TextField
  - [+ Add Point] button below points
  - [−] Remove button next to each point
  - **Minimum: 1 point (cannot remove the first point)**

Buttons:
- [+ Add Experience] - At bottom of section
- [Remove] icon (X button) - Top-right of each entry card

Minimum Entries: 0 (can have no experience)
```

**Projects Section** (Repeatable)
```
Fields per entry:
- Project Name (TextField, required)
- Project Link (TextField, optional) - GitHub/live link
- Points/Description (Dynamic list of TextFields)
  - Each point: Multiline TextField
  - [+ Add Point] button below points
  - [−] Remove button next to each point
  - **Minimum: 1 point (cannot remove the first point)**

Buttons:
- [+ Add Project] - At bottom of section
- [Remove] icon (X button) - Top-right of each entry card

Minimum Entries: 0 (can have no projects)
```

**Skills Section** (Single entry, non-repeatable)
```
Fields:
- Languages (TextField) - comma-separated
  - Label: "Programming Languages"
  - Placeholder: "e.g., Dart, Python, Java, JavaScript"
  
- Technologies (TextField) - comma-separated
  - Label: "Technologies & Tools"
  - Placeholder: "e.g., Flutter, Firebase, AWS, React"
  
- Professional Skills (TextField, optional) - comma-separated
  - Label: "Professional Skills"
  - Placeholder: "e.g., Leadership, Communication, Project Management"

Note: Input is comma-separated text
```

**Leadership/Activities Section** (Repeatable)
```
Fields per entry:
- Organization Name (TextField, required)
- Role/Position (TextField, required)
- Date/Duration (TextField, required) - e.g., "Sep 2024 - May 2025"
- Points/Description (Dynamic list of TextFields)
  - Each point: Multiline TextField
  - [+ Add Point] button below points
  - [−] Remove button next to each point
  - **Minimum: 1 point (cannot remove the first point)**

Buttons:
- [+ Add Leadership Role] - At bottom of section
- [Remove] icon (X button) - Top-right of each entry card

Minimum Entries: 0 (can have no leadership roles)
```

**Achievements Section** (Simple list, repeatable)
```
Fields:
- Achievement items (List of TextFields)
  - Each achievement: Single-line TextField
  - Simple bullet-point format
  - [+ Add Achievement] button below list
  - [−] Remove button next to each item
  - **Minimum: 1 achievement (cannot remove the first item)**

Example entries:
- "Qualified University Level Round of Smart India Hackathon (SIH)"
- "Postman API Fundamentals Student Expert - Postman"

Minimum Entries: 0 (can have no achievements)
```

**Common UI Patterns:**

**Add Button Behavior:**
```
1. User clicks [+ Add {Section}] button
2. New entry card/field appears below existing entries
3. Entry has empty fields with focus on first field
4. Smooth animation: Fade in + slide down (200ms)
5. Auto-scroll to new entry if needed
6. Data added to local state only (not saved to Firestore yet)
```

**Remove Button Behavior:**
```
1. User clicks [−] Remove button next to field/entry
2. Immediate removal (no confirmation for single fields)
3. Remove from UI with fade-out animation (150ms)
4. Remove from local state immediately
5. **Data NOT removed from Firestore until "Save" is clicked**
6. If minimum count reached, disable/hide remove button
```

**Dynamic Points (Experience, Projects, Leadership):**
```
Structure per entry:
┌─────────────────────────────────────────────┐
│ Company Name        [TextField]         [X] │
│ Role/Position       [TextField]             │
│ Location            [TextField]             │
│ Date/Duration       [TextField]             │
│                                             │
│ Points:                                     │
│ • [TextField for point 1]                   │
│ • [TextField for point 2]            [−]   │
│ • [TextField for point 3]            [−]   │
│                                             │
│ [+ Add Point]                               │
└─────────────────────────────────────────────┘

- First point: [−] button hidden/disabled
- Additional points: [−] button visible and active
- [+ Add Point]: Adds new TextField below existing points
- On [−] click: Immediately removes that point
```

#### 4.3.4 Action Bar
**Position:** Fixed at top of main content area (sticky)
**Background:** White with bottom border
**Height:** 64px

**Layout:**
```
┌─────────────────────────────────────────────┐
│                    [Save] [Generate Preview] │
└─────────────────────────────────────────────┘
```

**Components:**

1. **Save Button**
   - Style: Secondary button (grey background)
   - Text: "Save"
   - Icon: Save/Checkmark icon (optional)
   - Position: Right side, before Generate Preview
   - Margin: 8px between buttons

2. **Generate Preview Button**
   - Style: Primary button (Notion blue)
   - Text: "Generate Preview"
   - Icon: Eye/Preview icon (optional)
   - Position: Far right

**Behaviors:**

**Save Button:**
```
1. User clicks "Save"
2. Collect all form data from ResumeProvider
3. Basic validation (check required fields)
4. If validation fails:
   - Show error toast: "Please fill all required fields"
   - Scroll to first error field
   - Highlight error fields with red border
   - Stop execution
5. If validation passes:
   - Show loading overlay with text "Saving..."
   - Call FirestoreService.saveUserData(userId, resumeData)
   - On success:
     - Hide loading overlay
     - Show success toast: "Saved successfully"
     - Stay on Builder Page
   - On error:
     - Hide loading overlay
     - Show error dialog with retry option
     - Keep data in local state
```

**Generate Preview Button:**
```
1. User clicks "Generate Preview"
2. Collect all form data from ResumeProvider
3. Basic validation (check required fields)
4. If validation fails:
   - Show error toast: "Please fill all required fields"
   - Scroll to first error field
   - Stop execution
5. If validation passes:
   - Show loading overlay with text "Saving and generating preview..."
   - Step 1: Save data to Firestore (if not already saved)
     - Call FirestoreService.saveUserData(userId, resumeData)
   - Step 2: Navigate to Preview Page
     - Pass resumeData as parameter
   - Preview Page will handle PDF generation
6. On any error:
   - Hide loading overlay
   - Show error dialog
   - Stay on Builder Page
```

**Visual States:**
- Default: Normal button appearance
- Hover: Background color change
- Loading: Show loading spinner inside button, disable clicks
- Disabled: Grey color, no hover effect (if validation fails)

---

### 4.4 Preview Page

#### 4.4.1 Layout
```
┌─────────────────────────────────────────────┐
│ [← Back to Editor]    [Download PDF]        │
├─────────────────────────────────────────────┤
│                                             │
│          ┌────────────────────┐             │
│          │                    │             │
│          │   PDF Viewer       │             │
│          │   (A4 Aspect)      │             │
│          │   or Loading       │             │
│          │                    │             │
│          │                    │             │
│          └────────────────────┘             │
│                                             │
└─────────────────────────────────────────────┘
```

#### 4.4.2 Components

1. **Back Button (Top-left)**
   - Style: Secondary button with left arrow icon
   - Text: "Back to Editor"
   - Position: Top-left, 24px margin
   - Behavior: Returns to Builder Page (preserves state)

2. **Download PDF Button (Top-right)**
   - Style: Primary button (Notion blue)
   - Text: "Download PDF"
   - Icon: Download icon
   - Position: Top-right, 24px margin
   - Behavior: Downloads the generated PDF

3. **PDF Viewer Area**
   - Centered container
   - Max width: 800px
   - White background
   - Shadow: 0 2px 8px rgba(0,0,0,0.08)
   - A4 aspect ratio: 210:297
   - Border: 1px solid Color(0xFFE9E9E7)

#### 4.4.3 Preview Page Flow

**Note:** Backend integration is already complete. User will integrate the API call.

**On Page Load:**
```
1. Preview Page receives resumeData from Builder Page
2. Show loading overlay with text "Generating your resume..."
3. Call backend API (PDFService.generatePDF)
4. Backend process (already implemented):
   - Receives JSON resume data
   - Compiles LaTeX template with data
   - Generates PDF file
   - Returns PDF URL or Base64 data
5. On success:
   - Hide loading overlay
   - Display PDF in viewer
   - Enable "Download PDF" button
6. On error:
   - Hide loading overlay
   - Show error state in PDF viewer area:
     - Icon: Warning/Error icon
     - Message: "Failed to generate PDF. Please try again."
     - Button: "Retry" (calls API again)
     - Button: "Back to Editor"
```

**PDF Display:**
```
- Use iframe or PDF viewer package (flutter_pdfview, syncfusion_flutter_pdfviewer)
- Display PDF with zoom controls
- Responsive sizing
- Scroll if PDF exceeds viewport height
```

**Download Behavior:**
```
1. User clicks "Download PDF"
2. Show loading indicator on button
3. Trigger browser download:
   - If PDF is URL: Direct download link
   - If PDF is Base64: Convert and trigger download
4. File name: "Resume_{UserName}_{Date}.pdf"
5. Show success toast: "PDF downloaded successfully"
6. Keep user on Preview Page
```

**Back Button Behavior:**
```
1. User clicks "Back to Editor"
2. Navigate to Builder Page
3. Preserve all form data (state maintained by Riverpod)
4. No confirmation needed (PDF is temporary)
```

---

## 5. Firebase Integration

### 5.1 Firestore Database Structure

**Collection:** `users`
**Document ID:** Firebase Auth User UID

**Document Structure:**
```json
{
  "userId": "firebase_auth_uid",
  "email": "user@example.com",
  "displayName": "John Doe",
  "photoURL": "https://...",
  "createdAt": "2025-10-03T10:30:00Z",
  "updatedAt": "2025-10-03T11:45:00Z",
  "resumeData": {
    "profile": {
      "name": "John Doe",
      "phone": "+1234567890",
      "email": "john.doe@example.com",
      "linkedin": "https://linkedin.com/in/johndoe",
      "github": "https://github.com/johndoe",
      "website": "https://johndoe.com",
      "summary": "Experienced software engineer with 5+ years..."
    },
    "education": [
      {
        "id": "edu_1",
        "university": "Stanford University",
        "degree": "B.S. in Computer Science",
        "date": "2018 - 2022",
        "cgpa": "CGPA: 3.8/4.0"
      }
    ],
    "experience": [
      {
        "id": "exp_1",
        "company": "Google",
        "role": "Software Engineer",
        "location": "Mountain View, CA",
        "date": "May 2022 - Present",
        "points": [
          "Developed scalable microservices...",
          "Led team of 5 engineers...",
          "Improved system performance by 40%..."
        ]
      }
    ],
    "projects": [
      {
        "id": "proj_1",
        "name": "E-commerce Platform",
        "link": "https://github.com/johndoe/ecommerce",
        "points": [
          "Built full-stack web application...",
          "Implemented payment gateway integration...",
          "Deployed on AWS with CI/CD pipeline..."
        ]
      }
    ],
    "skills": {
      "languages": "Dart, Python, Java, JavaScript, C++",
      "technologies": "Flutter, Firebase, React, Node.js, AWS, Docker",
      "professional": "Leadership, Communication, Agile, Project Management"
    },
    "leadership": [
      {
        "id": "lead_1",
        "organization": "IEEE Student Chapter",
        "role": "President",
        "date": "Sep 2020 - May 2021",
        "points": [
          "Led chapter of 100+ members...",
          "Organized 10+ technical workshops...",
          "Increased membership by 50%..."
        ]
      }
    ],
    "achievements": [
      "Winner of National Hackathon 2021",
      "Google Summer of Code Contributor",
      "Dean's List for Academic Excellence (All Semesters)"
    ]
  }
}
```

### 5.2 Firestore Service Implementation

**File:** `services/firestore_service.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/builder/models/resume_data.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Collection reference
  CollectionReference get _usersCollection => 
      _firestore.collection('users');

  /// Save or update user's resume data
  Future<void> saveUserData(String userId, ResumeData resumeData) async {
    try {
      await _usersCollection.doc(userId).set({
        'userId': userId,
        'updatedAt': FieldValue.serverTimestamp(),
        'resumeData': resumeData.toJson(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  /// Load user's resume data
  Future<ResumeData?> loadUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      
      if (!doc.exists) {
        return null;
      }
      
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      
      if (data['resumeData'] != null) {
        return ResumeData.fromJson(data['resumeData']);
      }
      
      return null;
    } catch (e) {
      print('Error loading user data: $e');
      rethrow;
    }
  }

  /// Delete user's resume data (Reset Data feature)
  Future<void> deleteUserData(String userId) async {
    try {
      await _usersCollection.doc(userId).update({
        'resumeData': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error deleting user data: $e');
      rethrow;
    }
  }

  /// Save user profile info (from Firebase Auth)
  Future<void> saveUserProfile(String userId, {
    required String email,
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await _usersCollection.doc(userId).set({
        'userId': userId,
        'email': email,
        'displayName': displayName,
        'photoURL': photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user profile: $e');
      rethrow;
    }
  }

  /// Check if user has existing data
  Future<bool> hasExistingData(String userId) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      
      if (!doc.exists) {
        return false;
      }
      
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      return data?['resumeData'] != null;
    } catch (e) {
      print('Error checking existing data: $e');
      return false;
    }
  }
}
```

### 5.3 Firestore Security Rules

**File:** `firestore.rules` (in Firebase Console)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      // Allow read/write only if authenticated and userId matches auth.uid
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**Rules Explanation:**
- Users can only read/write their own document
- Document ID must match Firebase Auth UID
- Unauthenticated users have no access
- Prevents data leakage between users

---

## 6. State Management with Riverpod

### 6.1 Resume Data Models

**File:** `features/builder/models/resume_data.dart`

```dart
import 'package:uuid/uuid.dart';

class ResumeData {
  Profile? profile;
  List<Education> education;
  List<Experience> experience;
  List<Project> projects;
  Skills? skills;
  List<Leadership> leadership;
  List<String> achievements;

  ResumeData({
    this.profile,
    this.education = const [],
    this.experience = const [],
    this.projects = const [],
    this.skills,
    this.leadership = const [],
    this.achievements = const [],
  });

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'profile': profile?.toJson(),
    'education': education.map((e) => e.toJson()).toList(),
    'experience': experience.map((e) => e.toJson()).toList(),
    'projects': projects.map((e) => e.toJson()).toList(),
    'skills': skills?.toJson(),
    'leadership': leadership.map((e) => e.toJson()).toList(),
    'achievements': achievements,
  };

  factory ResumeData.fromJson(Map<String, dynamic> json) => ResumeData(
    profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    education: (json['education'] as List?)?.map((e) => Education.fromJson(e)).toList() ?? [],
    experience: (json['experience'] as List?)?.map((e) => Experience.fromJson(e)).toList() ?? [],
    projects: (json['projects'] as List?)?.map((e) => Project.fromJson(e)).toList() ?? [],
    skills: json['skills'] != null ? Skills.fromJson(json['skills']) : null,
    leadership: (json['leadership'] as List?)?.map((e) => Leadership.fromJson(e)).toList() ?? [],
    achievements: List<String>.from(json['achievements'] ?? []),
  );

  // Create empty instance
  factory ResumeData.empty() => ResumeData(
    profile: Profile.empty(),
    education: [Education.empty()],
    experience: [],
    projects: [],
    skills: Skills.empty(),
    leadership: [],
    achievements: [],
  );

  // Copy with method for immutability
  ResumeData copyWith({
    Profile? profile,
    List<Education>? education,
    List<Experience>? experience,
    List<Project>? projects,
    Skills? skills,
    List<Leadership>? leadership,
    List<String>? achievements,
  }) => ResumeData(
    profile: profile ?? this.profile,
    education: education ?? this.education,
    experience: experience ?? this.experience,
    projects: projects ?? this.projects,
    skills: skills ?? this.skills,
    leadership: leadership ?? this.leadership,
    achievements: achievements ?? this.achievements,
  );
}

class Profile {
  String name;
  String phone;
  String email;
  String? linkedin;
  String? github;
  String? website;
  String? summary;

  Profile({
    required this.name,
    required this.phone,
    required this.email,
    this.linkedin,
    this.github,
    this.website,
    this.summary,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
    'linkedin': linkedin,
    'github': github,
    'website': website,
    'summary': summary,
  };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    name: json['name'] ?? '',
    phone: json['phone'] ?? '',
    email: json['email'] ?? '',
    linkedin: json['linkedin'],
    github: json['github'],
    website: json['website'],
    summary: json['summary'],
  );

  factory Profile.empty() => Profile(
    name: '',
    phone: '',
    email: '',
  );

  Profile copyWith({
    String? name,
    String? phone,
    String? email,
    String? linkedin,
    String? github,
    String? website,
    String? summary,
  }) => Profile(
    name: name ?? this.name,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    linkedin: linkedin ?? this.linkedin,
    github: github ?? this.github,
    website: website ?? this.website,
    summary: summary ?? this.summary,
  );
}

class Education {
  String id;
  String university;
  String degree;
  String date;
  String? cgpa;

  Education({
    String? id,
    required this.university,
    required this.degree,
    required this.date,
    this.cgpa,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'university': university,
    'degree': degree,
    'date': date,
    'cgpa': cgpa,
  };

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    id: json['id'],
    university: json['university'] ?? '',
    degree: json['degree'] ?? '',
    date: json['date'] ?? '',
    cgpa: json['cgpa'],
  );

  factory Education.empty() => Education(
    university: '',
    degree: '',
    date: '',
  );

  Education copyWith({
    String? id,
    String? university,
    String? degree,
    String? date,
    String? cgpa,
  }) => Education(
    id: id ?? this.id,
    university: university ?? this.university,
    degree: degree ?? this.degree,
    date: date ?? this.date,
    cgpa: cgpa ?? this.cgpa,
  );
}

class Experience {
  String id;
  String company;
  String role;
  String location;
  String date;
  List<String> points;

  Experience({
    String? id,
    required this.company,
    required this.role,
    required this.location,
    required this.date,
    required this.points,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'company': company,
    'role': role,
    'location': location,
    'date': date,
    'points': points,
  };

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    id: json['id'],
    company: json['company'] ?? '',
    role: json['role'] ?? '',
    location: json['location'] ?? '',
    date: json['date'] ?? '',
    points: List<String>.from(json['points'] ?? ['']),
  );

  factory Experience.empty() => Experience(
    company: '',
    role: '',
    location: '',
    date: '',
    points: [''],
  );

  Experience copyWith({
    String? id,
    String? company,
    String? role,
    String? location,
    String? date,
    List<String>? points,
  }) => Experience(
    id: id ?? this.id,
    company: company ?? this.company,
    role: role ?? this.role,
    location: location ?? this.location,
    date: date ?? this.date,
    points: points ?? this.points,
  );
}

class Project {
  String id;
  String name;
  String? link;
  List<String> points;

  Project({
    String? id,
    required this.name,
    this.link,
    required this.points,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'link': link,
    'points': points,
  };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'],
    name: json['name'] ?? '',
    link: json['link'],
    points: List<String>.from(json['points'] ?? ['']),
  );

  factory Project.empty() => Project(
    name: '',
    points: [''],
  );

  Project copyWith({
    String? id,
    String? name,
    String? link,
    List<String>? points,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    link: link ?? this.link,
    points: points ?? this.points,
  );
}

class Skills {
  String? languages;
  String? technologies;
  String? professional;

  Skills({
    this.languages,
    this.technologies,
    this.professional,
  });

  Map<String, dynamic> toJson() => {
    'languages': languages,
    'technologies': technologies,
    'professional': professional,
  };

  factory Skills.fromJson(Map<String, dynamic> json) => Skills(
    languages: json['languages'],
    technologies: json['technologies'],
    professional: json['professional'],
  );

  factory Skills.empty() => Skills(
    languages: '',
    technologies: '',
    professional: '',
  );

  Skills copyWith({
    String? languages,
    String? technologies,
    String? professional,
  }) => Skills(
    languages: languages ?? this.languages,
    technologies: technologies ?? this.technologies,
    professional: professional ?? this.professional,
  );
}

class Leadership {
  String id;
  String organization;
  String role;
  String date;
  List<String> points;

  Leadership({
    String? id,
    required this.organization,
    required this.role,
    required this.date,
    required this.points,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'organization': organization,
    'role': role,
    'date': date,
    'points': points,
  };

  factory Leadership.fromJson(Map<String, dynamic> json) => Leadership(
    id: json['id'],
    organization: json['organization'] ?? '',
    role: json['role'] ?? '',
    date: json['date'] ?? '',
    points: List<String>.from(json['points'] ?? ['']),
  );

  factory Leadership.empty() => Leadership(
    organization: '',
    role: '',
    date: '',
    points: [''],
  );

  Leadership copyWith({
    String? id,
    String? organization,
    String? role,
    String? date,
    List<String>? points,
  }) => Leadership(
    id: id ?? this.id,
    organization: organization ?? this.organization,
    role: role ?? this.role,
    date: date ?? this.date,
    points: points ?? this.points,
  );
}
```

### 6.2 Riverpod Providers

**File:** `features/builder/providers/resume_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resume_data.dart';
import '../../../services/firestore_service.dart';
import '../../../services/auth_service.dart';

// Resume state notifier
class ResumeNotifier extends StateNotifier<ResumeData> {
  final FirestoreService _firestoreService;
  final AuthService _authService;

  ResumeNotifier(this._firestoreService, this._authService)
      : super(ResumeData.empty());

  // Load data from Firestore
  Future<void> loadData() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      final data = await _firestoreService.loadUserData(userId);
      if (data != null) {
        state = data;
      } else {
        state = ResumeData.empty();
      }
    } catch (e) {
      print('Error loading resume data: $e');
      rethrow;
    }
  }

  // Save data to Firestore
  Future<void> saveData() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      await _firestoreService.saveUserData(userId, state);
    } catch (e) {
      print('Error saving resume data: $e');
      rethrow;
    }
  }

  // Reset all data
  Future<void> resetData() async {
    final userId = _authService.userId;
    if (userId == null) return;

    try {
      await _firestoreService.deleteUserData(userId);
      state = ResumeData.empty();
    } catch (e) {
      print('Error resetting data: $e');
      rethrow;
    }
  }

  // Update profile
  void updateProfile(Profile profile) {
    state = state.copyWith(profile: profile);
  }

  // Update education
  void updateEducation(List<Education> education) {
    state = state.copyWith(education: education);
  }

  void addEducation() {
    state = state.copyWith(
      education: [...state.education, Education.empty()],
    );
  }

  void removeEducation(String id) {
    if (state.education.length <= 1) return; // Keep at least one
    state = state.copyWith(
      education: state.education.where((e) => e.id != id).toList(),
    );
  }

  // Update experience
  void updateExperience(List<Experience> experience) {
    state = state.copyWith(experience: experience);
  }

  void addExperience() {
    state = state.copyWith(
      experience: [...state.experience, Experience.empty()],
    );
  }

  void removeExperience(String id) {
    state = state.copyWith(
      experience: state.experience.where((e) => e.id != id).toList(),
    );
  }

  // Update projects
  void updateProjects(List<Project> projects) {
    state = state.copyWith(projects: projects);
  }

  void addProject() {
    state = state.copyWith(
      projects: [...state.projects, Project.empty()],
    );
  }

  void removeProject(String id) {
    state = state.copyWith(
      projects: state.projects.where((p) => p.id != id).toList(),
    );
  }

  // Update skills
  void updateSkills(Skills skills) {
    state = state.copyWith(skills: skills);
  }

  // Update leadership
  void updateLeadership(List<Leadership> leadership) {
    state = state.copyWith(leadership: leadership);
  }

  void addLeadership() {
    state = state.copyWith(
      leadership: [...state.leadership, Leadership.empty()],
    );
  }

  void removeLeadership(String id) {
    state = state.copyWith(
      leadership: state.leadership.where((l) => l.id != id).toList(),
    );
  }

  // Update achievements
  void updateAchievements(List<String> achievements) {
    state = state.copyWith(achievements: achievements);
  }

  void addAchievement() {
    state = state.copyWith(
      achievements: [...state.achievements, ''],
    );
  }

  void removeAchievement(int index) {
    if (state.achievements.isEmpty) return;
    final newAchievements = List<String>.from(state.achievements);
    newAchievements.removeAt(index);
    state = state.copyWith(achievements: newAchievements);
  }

  // Add/remove points for Experience
  void addExperiencePoint(String experienceId) {
    final updatedExperience = state.experience.map((exp) {
      if (exp.id == experienceId) {
        return exp.copyWith(points: [...exp.points, '']);
      }
      return exp;
    }).toList();
    state = state.copyWith(experience: updatedExperience);
  }

  void removeExperiencePoint(String experienceId, int pointIndex) {
    final updatedExperience = state.experience.map((exp) {
      if (exp.id == experienceId && exp.points.length > 1) {
        final newPoints = List<String>.from(exp.points);
        newPoints.removeAt(pointIndex);
        return exp.copyWith(points: newPoints);
      }
      return exp;
    }).toList();
    state = state.copyWith(experience: updatedExperience);
  }

  // Add/remove points for Projects
  void addProjectPoint(String projectId) {
    final updatedProjects = state.projects.map((proj) {
      if (proj.id == projectId) {
        return proj.copyWith(points: [...proj.points, '']);
      }
      return proj;
    }).toList();
    state = state.copyWith(projects: updatedProjects);
  }

  void removeProjectPoint(String projectId, int pointIndex) {
    final updatedProjects = state.projects.map((proj) {
      if (proj.id == projectId && proj.points.length > 1) {
        final newPoints = List<String>.from(proj.points);
        newPoints.removeAt(pointIndex);
        return proj.copyWith(points: newPoints);
      }
      return proj;
    }).toList();
    state = state.copyWith(projects: updatedProjects);
  }

  // Add/remove points for Leadership
  void addLeadershipPoint(String leadershipId) {
    final updatedLeadership = state.leadership.map((lead) {
      if (lead.id == leadershipId) {
        return lead.copyWith(points: [...lead.points, '']);
      }
      return lead;
    }).toList();
    state = state.copyWith(leadership: updatedLeadership);
  }

  void removeLeadershipPoint(String leadershipId, int pointIndex) {
    final updatedLeadership = state.leadership.map((lead) {
      if (lead.id == leadershipId && lead.points.length > 1) {
        final newPoints = List<String>.from(lead.points);
        newPoints.removeAt(pointIndex);
        return lead.copyWith(points: newPoints);
      }
      return lead;
    }).toList();
    state = state.copyWith(leadership: updatedLeadership);
  }
}

// Provider for FirestoreService
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Resume provider
final resumeProvider = StateNotifierProvider<ResumeNotifier, ResumeData>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final authService = ref.watch(authServiceProvider);
  return ResumeNotifier(firestoreService, authService);
});

// UI state provider (loading, errors, etc.)
class UIState {
  final bool isLoading;
  final String? errorMessage;

  UIState({
    this.isLoading = false,
    this.errorMessage,
  });

  UIState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return UIState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final uiStateProvider = StateProvider<UIState>((ref) => UIState());

// Active section provider (for sidebar navigation)
final activeSectionProvider = StateProvider<String>((ref) => 'profile');
```

**File:** `features/auth/providers/auth_provider.dart`

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/auth_service.dart';

// Auth state stream provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});
```

---

## 7. Navigation & Routing

### 7.1 App Entry Point

**File:** `app.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/landing/presentation/landing_page.dart';
import 'features/builder/presentation/builder_page.dart';
import 'features/preview/presentation/preview_page.dart';
import 'features/auth/providers/auth_provider.dart';
import 'core/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Resume UltraProMax',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      
      // Initial route based on auth state
      home: authState.when(
        data: (user) => user != null ? const BuilderPage() : const LandingPage(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const LandingPage(),
      ),
      
      // Named routes
      routes: {
        '/': (context) => const LandingPage(),
        '/builder': (context) => const BuilderPage(),
        '/preview': (context) => const PreviewPage(),
      },
    );
  }
}
```

### 7.2 Mobile Responsiveness Restriction

**Important:** Only the Landing Page is responsive for mobile devices. Builder and Preview pages are desktop/tablet only.

**Implementation:** `core/utils/responsive_utils.dart`

```dart
import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Breakpoints
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  
  // Check if device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }
  
  // Check if device is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }
  
  // Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }
  
  // Check if device is mobile or tablet (for builder/preview restriction)
  static bool isDesktopOrTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileBreakpoint;
  }
}
```

**Mobile Restriction Dialog:**

**File:** `shared/widgets/mobile_restriction_dialog.dart`

```dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class MobileRestrictionDialog extends StatelessWidget {
  const MobileRestrictionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(
                Icons.laptop_mac,
                size: 32,
                color: AppColors.primary,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              'Desktop or Tablet Required',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Message
            Text(
              'Creating a resume requires a larger screen for the best experience. Please use a desktop or tablet device to access the resume builder.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'Got it',
                  style: AppTextStyles.buttonText.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Modified Landing Page Behavior:**

**File:** `features/landing/presentation/landing_page.dart`

```dart
// In the Get Started button's onPressed callback:

void _handleGetStarted(BuildContext context) {
  // Check if mobile device
  if (ResponsiveUtils.isMobile(context)) {
    // Show mobile restriction dialog
    showDialog(
      context: context,
      builder: (context) => const MobileRestrictionDialog(),
    );
    return;
  }
  
  // If desktop or tablet, show sign-in dialog
  showDialog(
    context: context,
    builder: (context) => const GoogleSignInDialog(),
  );
}
```

---

## 8. User Flows & Complete Use Cases

### 8.1 First-Time User Flow

```
1. User lands on Landing Page
   - Not authenticated
   - Sees hero section and info cards
   - "View Example" button visible but not clickable

2. User clicks "Get Started"
   - Google Sign-In Dialog opens
   - Shows "Sign in with Google" button
   - Close button (X) in top-right

3. User clicks "Sign in with Google"
   - AuthService checks: currentUser == null
   - Firebase Google Sign-In flow initiates
   - User selects Google account
   - Grants permissions

4. Sign-In Success
   - Dialog closes
   - Navigate to Builder Page
   - Show loading overlay: "Loading..."
   - Check Firestore for existing data
   - No data found (first time)
   - Show empty form fields
   - Hide loading overlay

5. User fills form fields
   - Profile: Name, phone, email (pre-filled), LinkedIn, GitHub, summary
   - Education: University, degree, dates, CGPA
   - Experience: Company, role, location, dates, points (add/remove)
   - Projects: Name, link, points (add/remove)
   - Skills: Languages, technologies, professional
   - Leadership: Organization, role, dates, points (add/remove)
   - Achievements: List of achievements (add/remove)

6. User clicks "Save"
   - Show loading overlay: "Saving..."
   - Validate fields
   - Save to Firestore: FirestoreService.saveUserData()
   - Show success toast: "Saved successfully"
   - Hide loading overlay

7. User clicks "Generate Preview"
   - Validate fields
   - Save to Firestore (if not already saved)
   - Navigate to Preview Page
   - Show loading: "Generating your resume..."
   - Call backend API with resume data
   - Backend compiles LaTeX template
   - Returns PDF URL
   - Display PDF in viewer
   - Enable "Download PDF" button

8. User clicks "Download PDF"
   - Trigger browser download
   - File name: "Resume_JohnDoe_2025-10-03.pdf"
   - Show success toast: "PDF downloaded successfully"

9. User clicks "Back to Editor"
   - Navigate back to Builder Page
   - All data preserved in state

10. User clicks "Logout"
    - Show confirmation dialog
    - User confirms
    - Firebase sign out
    - Clear local state
    - Navigate to Landing Page
```

### 8.2 Returning User Flow

```
1. User lands on Landing Page
   - Previously logged in but session expired
   - Not currently authenticated

2. User clicks "Get Started"
   - Google Sign-In Dialog opens

3. User clicks "Sign in with Google"
   - AuthService checks: currentUser != null
   - User is already authenticated (cached credentials)
   - Skip Google Sign-In flow
   - Close dialog immediately
   - Navigate to Builder Page

4. Builder Page loads
   - Show loading overlay: "Loading your data..."
   - Call Firestore: FirestoreService.loadUserData()
   - Data found (previously saved)
   - Populate all fields with saved data
   - Show success toast: "Data loaded"
   - Hide loading overlay

5. User edits data
   - Add new experience entry
   - Remove old project
   - Update skills list
   - Add achievement
   - Data changes in local state only

6. User clicks "Save"
   - Show loading overlay: "Saving..."
   - Save updated data to Firestore
   - Overwrites existing document
   - Show success toast: "Saved successfully"

7. User continues to Preview/Download
   - Same flow as first-time user
```

### 8.3 Reset Data Flow

```
1. User on Builder Page with existing data
   - All fields populated from Firestore

2. User clicks "Reset Data" in sidebar
   - Confirmation dialog appears:
     - Title: "Reset All Data?"
     - Message: "This will permanently delete all your resume data..."
     - Buttons: "Cancel" | "Reset" (red)

3. User clicks "Reset"
   - Show loading overlay: "Resetting..."
   - Call FirestoreService.deleteUserData()
   - Delete resumeData field from Firestore
   - Clear local state: ResumeProvider.reset()
   - All fields become empty
   - Show success toast: "Data reset successfully"
   - Hide loading overlay

4. User now sees empty form
   - Can start fresh
   - Can fill new data and save
```

### 8.4 Edit and Update Flow

```
1. User on Builder Page with saved data
   - Fields populated from Firestore

2. User makes changes
   - Edits experience points
   - Adds new project
   - Removes achievement
   - Changes stay in local state

3. User doesn't click "Save" and navigates away
   - All changes are LOST
   - Next time user loads: Previous saved data appears
   - User must explicitly save to persist changes

4. User clicks "Save" after making changes
   - Current state overwrites Firestore data
   - All changes now persistent
   - Success message shown
```

---

## 9. Error Handling & Edge Cases

### 9.1 Authentication Errors

**Error: Google Sign-In Cancelled**
```
Scenario: User closes Google Sign-In popup without selecting account
Handling:
- Detect cancellation (null return from GoogleSignIn)
- Close dialog silently
- Stay on Landing Page
- No error message (user cancelled intentionally)
```

**Error: Google Sign-In Network Error**
```
Scenario: No internet connection during sign-in
Handling:
- Catch exception
- Show error toast: "No internet connection. Please try again."
- Keep dialog open
- Allow retry
```

**Error: Firebase Auth Error**
```
Scenario: Firebase service error
Handling:
- Catch exception
- Show error dialog: "Authentication failed. Please try again later."
- Log error for debugging
- Close dialog after user acknowledges
```

### 9.2 Firestore Errors

**Error: Load Data Failed**
```
Scenario: Firestore read fails (network, permissions, etc.)
Handling:
- Show error toast: "Failed to load data. Please check your connection."
- Show empty fields (fallback)
- Retry button in UI
- Log error details
```

**Error: Save Data Failed**
```
Scenario: Firestore write fails
Handling:
- Show error dialog:
  - Message: "Failed to save. Please check your internet connection."
  - Buttons: "Retry" | "Cancel"
- Keep data in local state
- Allow retry
- If retry fails multiple times, suggest refreshing page
```

**Error: Delete Data Failed (Reset)**
```
Scenario: Firestore delete operation fails
Handling:
- Show error dialog: "Failed to reset data. Please try again."
- Keep existing data in UI
- Allow retry
```

### 9.3 PDF Generation Errors

**Error: Backend API Unreachable**
```
Scenario: Backend service down or network error
Handling:
- Show error in PDF viewer area:
  - Icon: Warning icon
  - Message: "Unable to connect to PDF generation service."
  - Suggestion: "Please check your internet connection and try again."
  - Button: "Retry"
  - Button: "Back to Editor"
```

**Error: LaTeX Compilation Failed**
```
Scenario: Backend returns 500 error (LaTeX error)
Handling:
- Show error message:
  - "Failed to generate PDF. There may be an issue with your data."
  - Suggestion: "Please check for special characters or unusual formatting."
  - Button: "Back to Editor"
- Log error details for debugging
```

### 9.4 Validation & Edge Cases

**Case: Required Fields Empty**
```
Handling:
- Show error toast: "Please fill all required fields"
- Scroll to first empty required field
- Highlight field with red border
- Show helper text: "This field is required"
- Prevent save/preview until fixed
```

**Case: User Tries to Delete Last Education Entry**
```
Handling:
- Disable remove button when count = 1
- Show tooltip on hover: "At least one education entry is required"
```

**Case: User Tries to Delete First Point in Experience**
```
Handling:
- Hide/disable remove button for first point
- Show tooltip: "At least one point is required"
```

**Case: Browser Refresh Without Saving**
```
Handling:
- Detect page unload event
- Data in local state is lost
- On next load: Previous saved data from Firestore appears
- No recovery of unsaved changes
```

**Case: Rapid Clicking on Save Button**
```
Handling:
- Disable button during save operation
- Show loading state on button
- Prevent multiple simultaneous saves
- Re-enable after operation completes
```

**Case: Session Timeout**
```
Handling:
- Firebase Auth handles token refresh automatically
- If session expires:
  - Show error: "Your session has expired. Please sign in again."
  - Redirect to Landing Page
  - Local state cleared
```

---

## 10. Development Phases & Implementation Guide

### Phase 1: Foundation & Setup (Days 1-2)

**Firebase Configuration:**
```
✓ Create Firebase project
✓ Enable Authentication (Google provider)
✓ Create Firestore database
✓ Configure security rules
✓ Download google-services.json / GoogleService-Info.plist
```

**Flutter Setup:**
```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.0
  
  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.15.0
  cloud_firestore: ^4.13.0
  google_sign_in: ^6.1.5
  
  # UI
  google_fonts: ^6.1.0
  
  # Utilities
  uuid: ^4.2.0
  http: ^1.1.0
  
  # PDF (for preview)
  syncfusion_flutter_pdfviewer: ^23.2.4
  # OR
  # flutter_pdfview: ^1.3.2
```

**Project Structure:**
```
✓ Create folder hierarchy as specified
✓ Set up core/ (theme, constants, utils)
✓ Set up services/ (auth, firestore, pdf)
✓ Set up features/ (auth, landing, builder, preview)
✓ Set up shared/ (widgets)
```

**Theme System:**
```
✓ Implement app_colors.dart
✓ Implement app_text_styles.dart
✓ Implement app_theme.dart
✓ Configure Material 3 theme
```

**Shared Widgets:**
```
✓ NotionCard
✓ NotionButton (primary, secondary)
✓ NotionTextField
✓ LoadingOverlay
✓ ErrorDialog
```

### Phase 2: Authentication (Days 3-4)

```
✓ Implement AuthService
  - Google Sign-In integration
  - Sign out functionality
  - Auth state stream
  
✓ Implement Auth Providers (Riverpod)
  - authStateProvider
  - currentUserProvider
  - isAuthenticatedProvider
  
✓ Create Google Sign-In Dialog
  - Dialog UI (Notion-styled)
  - Sign-in button
  - Close button
  - Loading states
  - Error handling
  
✓ Auth flow logic
  - Check if already authenticated
  - Handle sign-in success/failure
  - Navigate based on auth state
```

### Phase 3: Landing Page (Day 5)

```
✓ Landing page layout
  - Top navbar (logo, View Example button - not clickable)
  - Hero section (heading, subtext, Get Started CTA)
  - Info cards section
  
✓ Navigation integration
  - Get Started button opens Sign-In Dialog
  - Auth state check
  - Redirect logic
  
✓ Animations
  - Fade-in on load
  - Button hover effects
  - Card hover effects
```

### Phase 4: Firestore Integration (Day 6)

```
✓ Implement Data Models
  - ResumeData class with all sections
  - Profile, Education, Experience, Project, Skills, Leadership classes
  - JSON serialization (toJson, fromJson)
  - copyWith methods for immutability
  - empty() factory constructors
  
✓ Implement FirestoreService
  - saveUserData()
  - loadUserData()
  - deleteUserData()
  - saveUserProfile()
  - hasExistingData()
  
✓ Configure Firestore Security Rules
  - User-specific access control
  - Read/write permissions
```

### Phase 5: State Management (Day 7)

```
✓ Implement Resume Providers
  - ResumeNotifier (StateNotifier)
  - CRUD methods for all sections
  - Add/remove entry methods
  - Add/remove point methods
  - Save/load/reset methods
  
✓ Implement UI State Providers
  - uiStateProvider (loading, errors)
  - activeSectionProvider (sidebar navigation)
  
✓ Provider Setup
  - firestoreServiceProvider
  - authServiceProvider
  - resumeProvider
```

### Phase 6: Builder Page - Structure (Days 8-9)

```
✓ Builder page layout
  - Two-column layout (sidebar + main)
  - Sticky action bar
  - Scrollable main area
  
✓ Left sidebar
  - Profile avatar (Google photo)
  - Reset Data button with confirmation
  - Logout button with confirmation
  - Section navigation menu
  - Active section highlighting
  
✓ Sidebar functionality
  - Scroll to section on click
  - Active section detection on scroll
  - Reset data confirmation dialog
  - Logout confirmation dialog
  
✓ Action bar
  - Save button
  - Generate Preview button
  - Fixed positioning
  - Loading states
```

### Phase 7: Builder Page - Form Sections (Days 10-14)

```
✓ Profile section
  - All text fields (name, phone, email, etc.)
  - Summary multiline field
  - Auto-fill email from Google
  
✓ Education section
  - Repeatable entries
  - Add/remove functionality
  - All fields per entry
  - Minimum 1 entry enforcement
  
✓ Experience section
  - Repeatable entries
  - Dynamic points (add/remove)
  - All fields per entry
  - Minimum 1 point per entry
  
✓ Projects section
  - Repeatable entries
  - Dynamic points (add/remove)
  - All fields per entry
  - Minimum 1 point per entry
  
✓ Skills section
  - Three text fields (languages, technologies, professional)
  - Comma-separated input
  
✓ Leadership section
  - Repeatable entries
  - Dynamic points (add/remove)
  - All fields per entry
  - Minimum 1 point per entry
  
✓ Achievements section
  - Simple list of text fields
  - Add/remove achievements
  - No minimum requirement
```

### Phase 8: Data Persistence Logic (Day 15)

```
✓ Load data on page mount
  - Check auth state
  - Call loadUserData()
  - Populate fields if data exists
  - Show empty fields if no data
  
✓ Manual save functionality
  - Collect form data
  - Validate fields
  - Save to Firestore
  - Show success/error messages
  
✓ Unsaved changes warning
  - Detect form modifications
  - Warn before logout
  - Note: No browser unload warning (data will be lost)
```

### Phase 9: Preview Page & PDF Generation (Days 16-17)

```
✓ Preview page layout
  - Back button
  - Download button
  - PDF viewer area
  
✓ PDF generation flow
  - Validate data
  - Save to Firestore
  - Call backend API (PDFService)
  - Handle loading state
  - Handle errors
  
✓ PDF display
  - Iframe or PDF viewer package
  - A4 aspect ratio
  - Placeholder while loading
  - Error state UI
  
✓ Download functionality
  - Trigger browser download
  - File naming convention
  - Success message
  
Note: Backend API integration to be done by user
```

### Phase 10: Testing & Polish (Day 18)

```
✓ Field validation
  - Required fields check
  - Email format validation
  - URL format validation (basic)
  - Show error states
  
✓ Error handling
  - Auth errors
  - Firestore errors
  - Network errors
  - Backend API errors
  
✓ UI Polish
  - Smooth animations
  - Loading overlays
  - Toast notifications
  - Error dialogs
  
✓ Testing
  - Manual testing of all flows
  - Edge case testing
  - Browser compatibility (Chrome, Firefox, Safari)
```

---

## 11. Backend Integration Notes

**Note:** Backend is already implemented. User needs to integrate the API call.

### 11.1 PDF Service Implementation

**File:** `services/pdf_service.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/builder/models/resume_data.dart';

class PDFService {
  // Backend API URL (replace with your Render URL)
  static const String _baseUrl = 'YOUR_RENDER_BACKEND_URL';
  
  /// Generate PDF from resume data
  Future<String> generatePDF(ResumeData resumeData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/generate-pdf'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(resumeData.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          return data['pdfUrl']; // Return PDF URL
        } else {
          throw Exception(data['message'] ?? 'Failed to generate PDF');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating PDF: $e');
      rethrow;
    }
  }
}
```

### 11.2 Integration in Preview Page

```dart
// In PreviewPage, call the PDF service
final pdfService = PDFService();

// On page load
@override
void initState() {
  super.initState();
  generatePDF();
}

Future<void> generatePDF() async {
  setState(() => isLoading = true);
  
  try {
    final pdfUrl = await pdfService.generatePDF(widget.resumeData);
    setState(() {
      this.pdfUrl = pdfUrl;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      error = e.toString();
      isLoading = false;
    });
  }
}
```

---

## 12. Deployment Guide

### 12.1 Firebase Deployment

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize project
firebase init

# Deploy security rules
firebase deploy --only firestore:rules
```

### 12.2 Vercel Deployment

```bash
# Install Vercel CLI
npm install -g vercel

# Build Flutter web
flutter build web --release

# Deploy
cd build/web
vercel --prod
```

**vercel.json configuration:**
```json
{
  "buildCommand": "flutter build web --release",
  "outputDirectory": "build/web",
  "framework": null,
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

---

## 13. Environment Configuration

### 13.1 Firebase Configuration

**File:** `lib/firebase_options.dart`

```dart
// This file is auto-generated by FlutterFire CLI
// Run: flutterfire configure

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_AUTH_DOMAIN',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );
}
```

### 13.2 Main.dart Setup

**File:** `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

---

## 14. Success Metrics & Deliverables

### 14.1 Must-Have Features

```
✓ Landing page with hero section and info cards
✓ Google Sign-In authentication
✓ Builder page with sidebar navigation
✓ All 7 resume sections with proper fields
✓ Profile with summary field
✓ Repeatable sections (Education, Experience, Projects, Leadership)
✓ Dynamic bullet points for Experience, Projects, Leadership
✓ Skills with 3 categories
✓ Simple achievements list
✓ Profile avatar with Google photo
✓ Reset Data functionality
✓ Logout functionality
✓ Preview page with PDF generation
✓ Smooth scroll navigation
✓ Save functionality with Firestore
✓ Load existing data on return
✓ Consistent Notion-inspired styling
```

### 14.2 Data Flow Summary

```
Landing Page
    ↓ [Get Started]
Sign-In Dialog
    ↓ [Google Sign-In]
Builder Page
    ↓ [Load from Firestore if exists]
Form Editing
    ↓ [Manual Save Required]
Firestore Storage
    ↓ [Generate Preview]
Preview Page
    ↓ [Backend API Call]
PDF Download
    ↓ [Back to Editor or Logout]
Landing Page (if logout)
```

### 14.3 Key Behavioral Notes

**IMPORTANT:**
1. **Data must be manually saved** - No auto-save, changes lost if not saved
2. **View Example button** - Visual only, not functional
3. **Minimum requirements** - First point/achievement cannot be removed
4. **Returning users** - Data loads automatically from Firestore
5. **Reset data** - Permanently deletes all data from cloud
6. **Logout** - Clears authentication, returns to landing page

---

## 15. Testing Checklist

### Manual Testing

```
Landing Page:
□ Navigation works to builder page after sign-in
□ Get Started button opens dialog
□ View Example button shows but doesn't work
□ Buttons have proper hover effects

Authentication:
□ Google Sign-In works for new users
□ Already authenticated users skip sign-in
□ Sign-out works correctly
□ Error handling for network issues

Builder Page:
□ Sidebar menu scrolls to sections smoothly
□ Add/Remove works for all repeatable sections
□ Minimum requirements enforced (1 education, 1 point per entry)
□ Reset Data deletes everything from Firestore
□ Logout button returns to landing page
□ Data persists only after clicking Save
□ Avatar shows Google profile picture

Data Persistence:
□ Save button saves to Firestore
□ Load on page mount retrieves saved data
□ Unsaved changes are lost on navigation
□ Reset Data clears Firestore and UI
□ Returning users see their saved data

Preview Page:
□ Back navigation returns to builder
□ PDF generation calls backend API
□ Download triggers browser download
□ Error states display correctly

Cross-Page:
□ All transitions are smooth
□ No layout shifts
□ Text is readable
□ Colors match Notion design system
```

---

## Appendix: Quick Reference

### Key Files Priority

**Critical Files (Implement First):**
1. `services/auth_service.dart` - Authentication
2. `services/firestore_service.dart` - Data persistence
3. `features/builder/models/resume_data.dart` - Data structure
4. `features/builder/providers/resume_provider.dart` - State management
5. `features/auth/presentation/widgets/google_sign_in_dialog.dart` - Sign-in UI

**Core UI Files:**
6. `features/landing/presentation/landing_page.dart` - Entry point
7. `features/builder/presentation/builder_page.dart` - Main editor
8. `features/preview/presentation/preview_page.dart` - PDF preview

### Common Commands

```bash
# Run app
flutter run -d chrome

# Build for web
flutter build web --release

# Clean build
flutter clean && flutter pub get

# Deploy to Vercel
vercel --prod

# Deploy Firestore rules
firebase deploy --only firestore:rules
```

---

**Document Version:** 2.0  
**Last Updated:** [Current Date]  
**Status:** Complete Full-Stack Implementation Guide  
**Owner:** Resume UltraProMax Team