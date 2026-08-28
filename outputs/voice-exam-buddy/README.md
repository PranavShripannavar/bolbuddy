# BolBuddy — Offline Voice Exam Tutor

A NeuralSprint MVP powered by the local Qwen model already installed on this computer. Run it with Node, then open `http://127.0.0.1:4173` in a modern browser:

```powershell
node server.js
```

Or simply double-click `start-bolbuddy.cmd`. Keep the small server window open while using the app.

## Demo path

1. Disconnect Wi-Fi to establish the offline story.
2. Ask “Photosynthesis kya hota hai?” (typing is the dependable fallback).
3. Let the spoken explanation finish, then answer the three questions.
4. Show that progress and weak-topic data persist after refreshing.

## Current MVP vs. production stack

The interface, Qwen-generated lessons, local Faster-Whisper transcription, browser text-to-speech, quizzes, and progress tracking run locally. The app currently uses the installed local Qwen 2.5 3B model for any study topic.

## Offline voice input

BolBuddy now records audio in the browser and transcribes it with local Faster-Whisper. The first setup downloads the multilingual `base` model; after that, disconnect from Wi-Fi and click **Hold to speak** to begin recording, then click it again to stop and transcribe. Allow the browser microphone permission when prompted.

The transcription runtime and model are intentionally excluded from Git because they are machine-local dependencies.

Recommended local API contract: `POST /api/tutor` with `{ question, language }`, returning `{ title, explanation, keyPoint, quiz }`.
