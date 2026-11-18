# Repair Car System

This repository contains the Flutter mobile app and its Laravel API backend.

## Project structure

- `inter_repair_car/` - Flutter mobile application
- `inter_repair_car_track_system_cloud/` - Laravel API and SQLite database

## Requirements

- Flutter SDK (Dart 3.7 or later)
- PHP 8.2 or later with the extensions required by Laravel
- Composer
- Android Studio with an Android SDK and emulator, or a connected Android device

## Run the backend

Open a terminal at the repository root, then:

```powershell
cd .\inter_repair_car_track_system_cloud
composer install
```

Create local environment and SQLite files if they do not already exist:

```powershell
if (-not (Test-Path .env)) { Copy-Item .env.example .env }
if (-not (Test-Path .\database\database.sqlite)) {
    New-Item -ItemType File .\database\database.sqlite | Out-Null
}
```

Then generate the application key, create the database tables, and start the API:

```powershell
php artisan key:generate
php artisan migrate
php artisan serve --host=0.0.0.0 --port=8000
```

Keep this terminal open while using the app. The backend uses SQLite by default,
so no separate database server is needed. The local `.env` and SQLite database
are not committed to Git.

For macOS/Linux, use `cp .env.example .env` if `.env` does not exist and
`touch database/database.sqlite` before running the Artisan commands.

You can check that the API is responding at
`http://localhost:8000/api/sendData`.

## Run the Flutter app

Start an Android emulator or connect an Android device. In a second terminal at
the repository root, run:

```powershell
cd .\inter_repair_car
flutter pub get
flutter devices
flutter run
```

If more than one device is available, choose one with `flutter run -d <device-id>`.

### API connection

The app's API base URL is currently set in
`inter_repair_car/lib/Core/Network/DioClient.dart` to
`http://10.0.2.2:8000/api/`. This address is for the Android emulator to reach
the backend running on the development computer.

For a physical Android device, change the base URL to the computer's local
network IP address (for example, `http://192.168.1.10:8000/api/`). Keep the
phone and computer on the same network and allow port 8000 through the computer's
firewall if prompted.

## Tests

Run backend tests from `inter_repair_car_track_system_cloud/`:

```powershell
php artisan test
```

Run Flutter tests from `inter_repair_car/`:

```powershell
flutter test
```

The Flutter test currently contains the default counter-app smoke test, which
does not match this application's UI and fails until that test is updated.
