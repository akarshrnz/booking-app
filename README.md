# Co-Working Space Booking App

A modern, responsive mobile application for booking co-working spaces, built with **Flutter** for the frontend and **Firebase** for the backend. The app follows **Clean Architecture** principles and uses **BLoC** for state management, providing a scalable and maintainable structure.

---

## Features

- Splash Screen – Show logo and navigate to Home.
- Login and Register – User authentication flow.
- Home Screen – List coworking branches with name, location, price/hour, search (by asset name, city, or branch), filter (by city or price).
- Map View – Show all branches as markers dynamically.
- Space Detail Screen – Images, description, amenities, operating hours.
- Booking Screen – Date/time slot selection, booking confirmation.
- My Bookings Screen – Show user bookings with status (Upcoming / Completed).
- Notifications Screen – Show booking-related push notifications.


---

## Challenges Faced

**OpenStreetMap Integration:**  
We used OpenStreetMap instead of Google Maps due to billing and usage cost concerns with Google Maps.

**Map Styling & Features:**  
Implementing custom markers, user location tracking, and interactive features required additional configuration compared to Google Maps.

**Cross-Platform Consistency:**  
Ensuring maps worked consistently on both Android and iOS devices required extra testing and fine-tuning.

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
