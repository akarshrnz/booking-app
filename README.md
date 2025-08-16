# Co-Working Space Booking App

A modern, responsive mobile application for booking co-working spaces, built with **Flutter** for the frontend and **Firebase** for the backend. The app follows **Clean Architecture** principles and uses **BLoC** for state management, providing a scalable and maintainable structure.

---

## Features

- Browse and search co-working spaces.
- View branch details, including location and amenities.
- Book a workspace for a specific date and time.
- View and manage your bookings.
- Receive push notifications for booking updates.
- Interactive map to locate branches using **OpenStreetMap**.
- Responsive UI for multiple device sizes.
- Real-time updates using **Firebase Firestore**.

---

## Architecture

The project follows **Clean Architecture** with three main layers:

- **Presentation Layer**  
  - Flutter UI screens and widgets  
  - BLoC state management for reactive UI  

- **Domain Layer**  
  - Entities representing core business models  
  - Use Cases implementing app logic  

- **Data Layer**  
  - Repository implementations for Firebase Firestore  
  - Data models and mappers  

---

## Tech Stack

- **Flutter** - Frontend framework  
- **Firebase** - Authentication, Firestore, Storage, Cloud Messaging (FCM)  
- **BLoC** - State management  
- **OpenStreetMap** - Maps and location  
- **flutter_screenutil** - Responsive UI scaling  

---

## Push Notifications

The app sends push notifications to users whenever a booking is created, using **Firebase Cloud Messaging (FCM)**. Notifications ensure users are instantly informed about their bookings.

### Setup

1. Enable **Cloud Messaging** in your Firebase project.
2. Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are configured.
3. Add dependencies in `pubspec.yaml`:


