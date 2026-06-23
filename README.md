# Jewellery Manager Application

## 1. Project Overview

### Project Purpose
The Jewellery Manager is a robust business management application designed for jewellery stores. It facilitates the tracking of stock (Gold and Jewellery), customer ledgers, daily transactions (Stock In/Out, Payment In/Out), and generates comprehensive daily and monthly business reports. 

### Business Objective
To digitize and streamline the inventory and accounting processes of a jewellery business, ensuring accurate real-time stock balances, reducing manual errors in customer ledgers, and providing critical business insights through comprehensive reporting.

### Main Features
- **Authentication:** Secure login for business owners/staff.
- **Dashboard:** Real-time summary of total receivables, payables, available gold and jewellery stock, and recent transaction history.
- **Customer Management:** Add, update, delete, and view comprehensive details of customers including their individual stock and cash balances.
- **Stock Management:** Track inward and outward movements of Gold and Jewellery, maintaining an accurate stock ledger.
- **Transactions Management:** Record stock movements and monetary payments, supporting various metal types (Gold, Jewellery) and currencies (INR, USD, MYR).
- **Reports:** Generate and export Daily Transaction Reports and Monthly Sales Reports.
- **Gold Rate Tracking:** Features to configure and use the daily gold rate for transaction evaluations.

### Target Users
- Jewellery Store Owners
- Store Managers
- Accounting Staff in the Jewellery Retail/Wholesale business

### Technology Stack
- **Frontend Framework:** Flutter (Dart) - SDK ^3.11.4
- **State Management:** Flutter BLoC (`flutter_bloc: ^9.1.1`)
- **Networking:** Dio (`dio: ^5.9.2`) with `pretty_dio_logger` for request inspection.
- **Dependency Injection:** `get_it: ^9.2.1` & `Provider` (via `RepositoryProvider`).
- **Local Storage:** `flutter_secure_storage: ^10.3.1` (for authentication tokens).
- **Architecture Pattern:** BLoC + Repository Pattern.
- **Backend Architecture:** REST API (inferred to be Node.js/Express or similar based on endpoints and response structures).

---

## 2. Development Environment Setup

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version >=3.11.4)
- Dart SDK
- IDE: VS Code / Android Studio / IntelliJ IDEA
- iOS Simulator or Android Emulator

### Installation Steps

1. **Clone the repository** (if applicable):
   ```bash
   git clone <repository_url>
   cd jewellery_app
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure the Environment:**
   The application uses a remote API endpoint. Update `lib/core/network/api_endpoints.dart` to point to the correct local or production server before building:
   ```dart
   class ApiEndpoints {
     static const String baseUrl = 'http://157.20.51.180:4007/api';
     // Update to local if needed: 'http://127.0.0.1:3000/api'
   }
   ```

4. **Run the Application:**
   ```bash
   flutter run
   ```

5. **Build for Production:**
   - **Android:**
     ```bash
     flutter build apk --release
     # OR
     flutter build appbundle --release
     ```
   - **iOS:**
     ```bash
     flutter build ios --release
     ```

### Testing the Application
- Run unit and widget tests:
  ```bash
  flutter test
  ```
