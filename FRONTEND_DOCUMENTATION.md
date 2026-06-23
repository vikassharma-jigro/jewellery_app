# Frontend Documentation

## 1. Complete Folder Structure (`lib/`)

```text
lib/
 ├── main.dart
 │    Purpose: Entry point of the application. Initializes BLoC/Repository providers and sets the theme.
 │
 ├── core/
 │    ├── constants.dart
 │    │    Purpose: Holds application-wide configurations and static values.
 │    ├── network/
 │    │    ├── api_endpoints.dart
 │    │    │    Purpose: Defines all REST API URL routes.
 │    │    ├── api_response.dart
 │    │    │    Purpose: Generic class to parse standard API JSON wrapper responses.
 │    │    ├── dio_client.dart
 │    │    │    Purpose: Instantiates and configures the Dio HTTP client with timeouts, headers, and interceptors.
 │    │    └── dio_interceptors.dart
 │    │         Purpose: Intercepts outgoing requests to attach the Bearer authentication token.
 │    ├── storage/
 │    │    └── auth_storage.dart
 │    │         Purpose: Wrapper around `flutter_secure_storage` to handle read/write of JWT tokens securely.
 │    └── utils/
 │         ├── api_service.dart
 │         │    Purpose: Exposes the configured `DioClient` globally.
 │         └── exceptions.dart
 │              Purpose: Custom exception classes for UI-friendly error handling.
 │
 ├── data/
 │    └── models/
 │         ├── customer_model.dart
 │         ├── dashboard_summary_model.dart
 │         ├── report_model.dart
 │         ├── stock_ledger_entry_model.dart
 │         ├── stock_summary_model.dart
 │         ├── transaction_model.dart
 │         └── user_model.dart
 │         Purpose: Data Transfer Objects (DTOs) with `fromJson` and `toJson` methods to parse server responses into Dart objects.
 │
 ├── repositories/
 │    ├── auth_repository.dart
 │    ├── customer_repository.dart
 │    ├── dashboard_repository.dart
 │    ├── reports_repository.dart
 │    ├── stock_repository.dart
 │    └── transaction_repository.dart
 │    Purpose: Handles data fetching logic and network error catching. Returns data models to the Cubits.
 │
 ├── blocs/
 │    ├── auth_cubit.dart & auth_state.dart
 │    ├── customer_cubit.dart & customer_state.dart
 │    ├── dashboard_cubit.dart & dashboard_state.dart
 │    ├── market_rate_cubit.dart & market_rate_state.dart
 │    ├── reports_cubit.dart & reports_state.dart
 │    ├── stock_cubit.dart & stock_state.dart
 │    └── transaction_cubit.dart & transaction_state.dart
 │    Purpose: State management components. Cubits execute asynchronous repository tasks and emit UI states (Loading, Loaded, Error).
 │
 ├── screens/
 │    ├── add_customer_screen.dart
 │    ├── add_stock_screen.dart
 │    ├── dashboard_screen.dart
 │    ├── login_screen.dart
 │    ├── customers_screen.dart
 │    ├── stock_screen.dart
 │    ├── reports_screen.dart
 │    └── ... (other specific UI screens)
 │    Purpose: UI presentation layer. Subscribes to Cubit states using `BlocBuilder`.
 │
 ├── widgets/
 │    ├── stat_card.dart
 │    ├── section_title.dart
 │    ├── bottom_nav.dart
 │    └── common.dart
 │    Purpose: Reusable UI components used across multiple screens to maintain visual consistency and reduce code duplication.
 │
 └── theme/
      └── app_theme.dart
           Purpose: Defines custom color palettes, text styles, and global material themes (e.g., `AppTheme.gold`, `AppTheme.muted`).
```

---

## 2. Core Concepts

### Framework Details
Built with **Flutter**, using the Dart language. It is optimized for cross-platform deployment but primarily targets Android and iOS devices.

### State Management Approach
Uses the **Cubit pattern** from the `flutter_bloc` package.
- **Why?** Cubit simplifies the standard BLoC pattern by replacing Stream Events with direct asynchronous functions, drastically reducing boilerplate while maintaining separation of concerns.
- **Implementation:** `BlocProvider` injects the state, `context.read<MyCubit>()` triggers actions, and `BlocBuilder` rebuilds the UI strictly when new states are emitted.

### Theme Management
Custom defined in `lib/theme/app_theme.dart`. It overrides Flutter's default `ThemeData` to apply custom fonts (Google Fonts) and brand colors (Deep Purple, Gold). All UI components explicitly reference `AppTheme` static colors (e.g., `AppTheme.goldDark`) for a premium look.

### Local Storage
Uses `flutter_secure_storage`. Standard `SharedPreferences` is not secure for sensitive data like JWT tokens. `flutter_secure_storage` uses Keychain on iOS and Keystore on Android, ensuring the `access_token` and `refresh_token` cannot be easily extracted by malicious actors.

### Authentication Flow
1. **Login:** User submits credentials via `LoginScreen`.
2. **Token Fetch:** `AuthCubit` calls `AuthRepository.login()`.
3. **Storage:** If valid, JWT is stored using `flutter_secure_storage`.
4. **Interception:** On subsequent requests, `AuthInterceptor` reads the token and attaches `Authorization: Bearer <token>` to headers.
5. **Session Check:** Upon app launch, `AuthCubit.checkAuthStatus()` validates the token's presence, routing to `HomeScreen` or `LoginScreen` accordingly.
6. **Logout:** Deletes the token and navigates back to `LoginScreen`.

### Error Handling
- **Network Level:** `DioClient` catches connection/timeout errors.
- **Repository Level:** `DioException` is intercepted. The backend's standard error message (`e.response?.data['message']`) is parsed into a custom `AppException`.
- **Bloc Level:** `AppException` is caught and translated to an `ErrorState` (e.g., `CustomerError(errorMessage)`).
- **UI Level:** `BlocConsumer` listens for `ErrorState` and displays a `SnackBar` or fallback UI widget.

---

## 3. Screen Documentation

### Dashboard Screen
**Screen Name:** `DashboardScreen`
**File Location:** `lib/screens/dashboard_screen.dart`
**Purpose:** Provides a high-level overview of the business, current stock balances, payables/receivables, and recent transactions.

**UI Components:**
- Hero Balance Card (`_HeroBalance`): Displays Gold & Jewellery combined stock using a beautiful gold gradient.
- Quick Actions (`_QuickAction`): Buttons to rapidly trigger "Stock In", "Stock Out", or add "New Customer".
- Transaction Tiles (`_TxTile`): Renders recent activities with intuitive color-coding (Green for IN, Red for OUT).

**State Management:** Listens to both `DashboardCubit` and `StockCubit`. Uses a nested `BlocBuilder` to reactively render data when `DashboardLoaded` is emitted.

**API Calls:** `ApiConstants.dashboardSummary` & `ApiConstants.stockLedger`.

**User Flow:** On initialization, `fetchDashboardSummary()` and `fetchStockData()` are called automatically. Users can pull-to-refresh to manually trigger re-fetches.

---

### Add Stock Screen
**Screen Name:** `AddStockScreen`
**File Location:** `lib/screens/add_stock_screen.dart`
**Purpose:** Records inward and outward movement of Gold and Jewellery.

**State Management:** Uses `TransactionCubit` to post the data, listens via `BlocConsumer` to navigate back upon success.

**Input Fields:**
- Transaction Type Dropdown (IN/OUT)
- Metal Type Dropdown (Gold/Jewellery)
- Customer Selection Dropdown
- Weight (grams) Text Field
- Optional Remarks

**Validation Rules:** Weight must be a valid double > 0. Customer must be selected.

---

### Customers Screen
**Screen Name:** `CustomersScreen`
**File Location:** `lib/screens/customers_screen.dart`
**Purpose:** Displays a searchable list of all customers.

**State Management:** Managed by `CustomerCubit`.

**API Calls:** `ApiConstants.customers` (GET).

**User Flow:** Tapping on a customer navigates to `CustomerDetailsScreen` (or Ledger). Tapping the Floating Action Button routes to `AddCustomerScreen`.

---

## 4. Reusable Widgets

### StatCard
**File Location:** `lib/widgets/stat_card.dart`
**Purpose:** A beautifully designed card widget used primarily on the Dashboard to display key metrics (like Total Receivables).
**Why it is used:** To maintain consistency in grid layouts and minimize repetitive styling code.

### SectionTitle
**File Location:** `lib/widgets/section_title.dart`
**Purpose:** Renders a standardized bold Text widget used to separate content blocks vertically on screens.
