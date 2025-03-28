# Omar Mahmoud Meals Tracker

A Flutter application for tracking meals, their calories, and meal details. This app uses Hive for local storage and interacts with an API to fetch or sync meal data.

## Features

- Add meals with details like name, calories, time, and an optional photo.
- View a list of meals sorted by name, time, or calories.
- Delete meals from the list.
- View detailed information about each meal.
- Persistent local storage using Hive.
- API integration for fetching and syncing meal data.
- Responsive UI with Flutter's Material Design.

## API Integration

This app interacts with an API to fetch and sync meal data. Below are the details:


## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Omar-galab/Omar_mahmoud
   cd omar-mahmoud-meals-tracker
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```


## Dependencies

The project uses the following dependencies:

- [Hive](https://pub.dev/packages/hive) - Lightweight and fast key-value database.
- [Hive Flutter](https://pub.dev/packages/hive_flutter) - Hive integration for Flutter.
- [Intl](https://pub.dev/packages/intl) - Internationalization and localization.
- [Image Picker](https://pub.dev/packages/image_picker) - Pick images from the gallery or camera.
- [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) - State management.
- [HTTP](https://pub.dev/packages/http) - For API interactions.

## How to Add a Meal

1. Tap the floating action button (`+`) on the main screen.
2. Fill in the meal details (name, calories, time, and optional photo).
3. Tap "Add Meal" to save the meal locally and sync it with the server.

## How to Delete a Meal

1. Swipe left or right on a meal in the list.
2. Confirm the deletion. The meal will be removed locally and from the server.

## How to View Meal Details

1. Tap on a meal in the list to view its details.

## Known Issues

- Ensure the Hive box is initialized before accessing it.
- API errors are not yet fully handled (e.g., network issues).

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.