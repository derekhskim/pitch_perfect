# Pitch Perfect

Pitch Perfect is a Flutter application that can detect a user's voice or instruments and return the corresponding musical notes (C, D, E, F, G, A, B). This app provides real-time pitch detection and is designed to help users improve their singing or instrument playing skills.

## Features

- Real-time pitch detection: The app captures audio samples from the device's microphone and uses the `pitch_detector_dart` library to analyze the pitch frequency.
- Note identification: The `pitchupdart` library is used to map the detected pitch to the closest musical note.
- Start/Stop functionality: Users can start and stop the pitch detection process by tapping the image on the screen.
- User-friendly interface: The app displays the detected note in a large font, providing immediate feedback to the user. It also shows a status message to guide the user on when to start or stop singing/playing.

## Frameworks and Libraries Used

The Pitch Perfect app is built using the Flutter framework. The following frameworks and libraries were used to implement specific features:

- `permission_handler`: Used to handle permission requests for microphone access.
- `flutter_audio_capture`: Provides audio capture functionality for accessing audio samples from the device's microphone.
- `google_mobile_ads`: Used to display banner ads within the app.
- `pitch_detector_dart`: Library for pitch detection from audio samples.
- `pitchupdart`: Library for note identification based on pitch frequency.

## Getting Started

To run the Pitch Perfect app on your device:

1. Ensure you have Flutter installed and set up on your machine.
2. Clone the repository or copy the code files into your Flutter project.
3. Run `flutter pub get` to fetch the required dependencies.
4. Connect your device or start an emulator.
5. Run the app using `flutter run` or through your preferred IDE.

Note: Make sure to grant microphone permission to the app when prompted, as it's necessary for pitch detection.

## Published

[Android: Google Play](https://play.google.com/store/apps/details?id=com.noobietubie.pitch.perfect)

[iOS: Apple Store](https://apps.apple.com/ca/app/pitch-perfect/id1637198395)

## Contributions

Contributions to the Pitch Perfect app are welcome. If you find any issues or have suggestions for improvements, please open an issue or submit a pull request on the GitHub repository.

## License

The Pitch Perfect app is open source and released under the MIT License. Feel free to modify and use the code for personal or commercial projects.
