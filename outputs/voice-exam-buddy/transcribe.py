"""Local, offline transcription worker used by BolBuddy's Node server."""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
RUNTIME = os.path.join(os.path.dirname(__file__), ".voice-runtime")
MODEL_DIR = os.path.join(ROOT, "work", "whisper-model")
sys.path.insert(0, RUNTIME)

from faster_whisper import WhisperModel


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: transcribe.py <audio-file> <language>")
    audio_file, language = sys.argv[1:]
    model = WhisperModel("base", device="cpu", compute_type="int8", download_root=MODEL_DIR)
    lang = None if language == "hinglish" else ("hi" if language == "hindi" else "en")
    segments, _ = model.transcribe(audio_file, language=lang, vad_filter=True)
    text = " ".join(segment.text.strip() for segment in segments).strip()
    print(json.dumps({"text": text}, ensure_ascii=False))


if __name__ == "__main__":
    main()
