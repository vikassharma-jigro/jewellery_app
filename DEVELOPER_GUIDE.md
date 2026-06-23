# Developer Guide & Future Development

This guide is designed to help new developers quickly onboard and confidently extend the Jewellery Manager application without breaking the established architecture.

---

## 1. How to Add a New Feature

Adding a new feature usually involves traversing the entire architectural stack from bottom (Data) to top (UI).

### Step 1: Add a New Model (If applicable)
1. Navigate to `lib/data/models/`.
2. Create a new file `my_feature_model.dart`.
3. Create a class extending `Equatable` to allow value-based equality comparisons (crucial for BLoC state changes).
4. Implement `fromJson` and `toJson` factory methods to serialize the API data.
5. Add the fields to the `props` getter.

### Step 2: Add API Endpoints
1. Open `lib/core/network/api_endpoints.dart`.
2. Add static constants for the new URLs:
   ```dart
   static const String myFeatureEndpoint = '/my-feature';
   ```

### Step 3: Create a New Repository
1. Navigate to `lib/repositories/`.
2. Create `my_feature_repository.dart`.
3. Inject the `ApiService` via constructor.
4. Write asynchronous functions using `_apiService.dio.get(...)`.
5. **Crucial:** Wrap Dio calls in `try/catch` and throw `AppException` explicitly using the standard `e.response?.data['message']` parsing structure used across other repositories.
6. Register this repository in `lib/main.dart` inside the `MultiRepositoryProvider`.

### Step 4: Create a New Cubit (State Management)
1. Navigate to `lib/blocs/`.
2. Create `my_feature_state.dart` (defining `Initial`, `Loading`, `Loaded`, and `Error` states).
3. Create `my_feature_cubit.dart`.
4. Inject the `MyFeatureRepository` via constructor.
5. Write functions that `emit(Loading)`, `await` the repository data, and `emit(Loaded)` or catch errors and `emit(Error)`.
6. Register this Cubit in `lib/main.dart` inside the `MultiBlocProvider`.

### Step 5: Create a New Screen
1. Navigate to `lib/screens/`.
2. Create `my_feature_screen.dart`.
3. Use `Scaffold` with `backgroundColor: kBg` (from `AppTheme`).
4. Wrap the body or relevant widgets in a `BlocBuilder<MyFeatureCubit, MyFeatureState>`.
5. Handle the UI states (e.g., show `CircularProgressIndicator` on Loading).

---

## 2. Common Issues & Troubleshooting

### A. "BlocProvider.of() called with a context that does not contain a Cubit"
- **Cause:** You are trying to `context.read<MyCubit>()` above the widget tree where the `BlocProvider` is defined, or you forgot to add the Cubit to `main.dart`.
- **Fix:** Ensure the `MultiBlocProvider` in `main.dart` includes your new Cubit.

### B. API Calls returning 401 Unauthorized unexpectedly
- **Cause:** The JWT Token has expired or the `AuthInterceptor` failed to attach it.
- **Fix:** Ensure `AuthStorage` is correctly storing the token. The backend might require a refresh token logic which is currently minimally implemented.

### C. Dio Timeout Exceptions
- **Cause:** The backend server is unreachable.
- **Fix:** Check `ApiEndpoints.baseUrl`. Ensure you are not using `localhost` if running on a physical Android/iOS device (use your local machine's IP address instead, e.g., `192.168.x.x`).

### D. UI not updating when data changes
- **Cause:** Equatable `props` list in your Models or States is missing a property. BLoC determines if a UI rebuild is needed by comparing the previous state to the new state. If the `props` don't change, the UI won't rebuild.
- **Fix:** Ensure all variables are added to the `props => [var1, var2]` list in your state class.

---

## 3. Change Management Checklists

### Feature Addition Checklist
- [ ] Model created with `Equatable` and JSON serialization.
- [ ] Endpoints added to `api_endpoints.dart`.
- [ ] Repository functions written with proper `AppException` error handling.
- [ ] Cubit created with comprehensive states (`Loading`, `Success`, `Error`).
- [ ] Providers registered in `main.dart`.
- [ ] Screen implements `BlocBuilder` or `BlocConsumer`.
- [ ] New strings/colors utilize `AppTheme`.

### Bug Fixing Checklist
- [ ] Identify if the bug is UI-based (Widget), State-based (Cubit), or Data-based (API/Model).
- [ ] Check Dio Logs in the console (`pretty_dio_logger` is enabled) to verify what the backend is actually sending.
- [ ] Ensure the BLoC state transition is actually firing (use print statements in `Cubit` methods).

### Release Checklist
- [ ] Update `pubspec.yaml` version number (e.g., `1.0.1+2`).
- [ ] Point `ApiEndpoints.baseUrl` to the **Production URL**.
- [ ] Run `flutter clean` && `flutter pub get`.
- [ ] Run `flutter analyze` to ensure no linting errors.
- [ ] Build production bundles: `flutter build apk --release` / `flutter build ios --release`.
