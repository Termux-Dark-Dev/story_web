
# Story Web -  [app link](https://storyweb.vercel.app)

A web app build using flutter to create and listen story through gemini ai and voice rss (text to speech) api.

## Run Locally

Clone the project

```bash
  git clone <copy above url>
```

Go to the project directory

```bash
  cd <project-name>
```

Install dependencies

```bash
  flutter pub get
```

Run the web app Locally

```bash
    flutter run -d chrome --dart-define=GEMINI_API_KEY=your-api-key --dart-define=VOICERSS_API_KEY=your-app-name
```

Run the android app Locally

```bash
    flutter run -d <device-name> --dart-define=GEMINI_API_KEY=your-api-key --dart-define=VOICERSS_API_KEY=your-app-name
```

# Build For Production

```bash
    flutter build web --dart-define=GEMINI_API_KEY=your-api-key --dart-define=VOICERSS_API_KEY=your-app-name
```
## Screenshots

![App Screenshot](https://raw.githubusercontent.com/Termux-Dark-Dev/story_web/main/assets/screen1.png)

![App Screenshot](https://raw.githubusercontent.com/Termux-Dark-Dev/story_web/main/assets/screen2.png)