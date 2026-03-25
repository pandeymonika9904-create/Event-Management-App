# Event Management System (Mobile-Only)

A production-ready event management system with a Flutter frontend and Node.js + Express + MongoDB backend. It supports multiple roles (User, Organizer, Admin) and handles authentication, ticket booking, razorpay payments, QR generation/scanning, and an organizer dashboard.

## Features Included
1. **Frontend (Flutter)**: Modern UI with glassmorphism, gradients, and rounded corners (`google_fonts`, `provider` for state management).
2. **Backend**: Express REST API with JWT Auth, Role-Based Access Control, Mongoose schema constraints, and mock FCM integration.
3. **Roles Supported**: 
   - `User`: Browse events, book tickets, check bookings, view QR token.
   - `Organizer`: Dashboard, create events, scan QR codes using phone camera.
   - `Admin / SuperAdmin`: Approve events/organizers, view stats.

## Setup Instructions

### 1. Backend Setup
1. Open a terminal and navigate to the backend folder:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Make sure MongoDB is running locally on port 27017, or edit `backend/.env` with your MongoDB URI.
4. Start the server:
   ```bash
   npm run dev
   # OR
   node server.js
   ```
   *The server runs on http://localhost:5000 by default.*

### 2. Frontend Setup (Flutter)
1. Open a terminal and navigate to the frontend folder:
   ```bash
   cd frontend
   ```
2. Install packages:
   ```bash
   flutter pub get
   ```
3. Update API Base URL (if needed):
   Edit `frontend/lib/core/constants.dart`. 
   - If running on an **Android Emulator**, keep `10.0.2.2:5000`.
   - If running on a **physical device or iOS Simulator**, change it to your machine's local IP (e.g., `192.168.1.5:5000`).
4. Run the app:
   ```bash
   flutter run
   ```

## Sample Testing Accounts
Run the app, go to "Sign Up" and create accounts specifying the roles `User` or `Organizer`.
- For `Organizer`: Select the Organizer radio button. You will be redirected to the Organizer Dashboard.
- For `User`: Select User. You will see the Home Screen feed.

### QR Code Testing
1. Login as User -> Book Event -> Go to "My Tickets" -> Tap ticket -> Generates QR Code.
2. Login as Organizer -> Dashboard -> Scan Tickets -> Use device camera to scan the user's generated QR code token.

## Tech Stack
- MongoDB + Mongoose
- Express.js Node Backend
- Flutter (Dart) Frontend using Provider
- Razorpay for Payments (Implementation hooks provided)
- Mobile Scanner + QR Flutter for ticketing.
