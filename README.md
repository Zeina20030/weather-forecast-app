# Weather Forecast App

A Flutter weather app with real-time conditions, a multi-day forecast, city
search, and a UI that changes color/iconography based on the current
weather (clear, rain, snow, thunderstorm, clouds, fog) and time of day.

Built against the free [OpenWeatherMap](https://openweathermap.org/api)
REST API (Geocoding, Current Weather, and 5 Day / 3 Hour Forecast
endpoints — no credit card required).

## Features

- Current conditions: temperature, "feels like", min/max, humidity, wind,
  pressure
- 5-day forecast, aggregated from 3-hour data into daily highs/lows
- City search (autocomplete via OpenWeatherMap Geocoding API)
- "Use my current location" via device GPS
- Dynamic background gradient and icon based on live weather condition and
  day/night
- Pull-to-refresh

## Project structure

```
lib/
  config/         # .env access
  models/         # CurrentWeather, DailyForecast, CitySuggestion
  services/       # WeatherApiService (HTTP), LocationService (geolocator)
  providers/      # WeatherProvider (app state, ChangeNotifier)
  theme/          # WeatherTheme — maps condition codes to icon + gradient
  screens/        # HomeScreen, SearchScreen
  widgets/        # CurrentWeatherCard, ForecastList, ForecastTile, ...
  main.dart
```

## Setup

### 1. Install Flutter

You need the [Flutter SDK](https://docs.flutter.dev/get-started/install)
(this project targets Dart ^3.9). Confirm your setup with:

```bash
flutter doctor
```

### 2. Get a free OpenWeatherMap API key

1. Go to https://openweathermap.org/api and click **Sign Up**.
2. Create a free account (no credit card needed for the free tier).
3. Verify your email via the link OpenWeatherMap sends you.
4. Log in, then go to https://home.openweathermap.org/api_keys.
5. Use the default key, or click **Generate** to create a new one.

**Note:** newly created keys can take up to ~2 hours to activate. If you
get `401 Unauthorized` right after creating your key, wait a bit and try
again.

### 3. Configure the API key

Copy the example env file and add your key:

```bash
cp .env.example .env
```

Edit `.env`:

```
OPENWEATHER_API_KEY=your_actual_key_here
```

`.env` is listed in `.gitignore` and will never be committed. Only
`.env.example` (with a placeholder) is tracked in git.

### 4. Install dependencies

```bash
flutter pub get
```

### 5. Run the app

```bash
flutter run
```

Pick any connected device/emulator/browser when prompted, or target one
directly, e.g.:

```bash
flutter run -d windows
flutter run -d chrome
flutter run -d <android-device-id>
```

On first launch the app requests location permission to show weather for
where you are. If you deny it (or are on a platform without location
support), use the search icon to look up a city instead.

## Running tests

```bash
flutter test
```

## Notes on the API

This app deliberately uses OpenWeatherMap's **free** `data/2.5/weather`,
`data/2.5/forecast`, and `geo/1.0/direct` endpoints rather than the newer
One Call 3.0 API, which requires a billing plan to be attached to your
account even on its free tier.
