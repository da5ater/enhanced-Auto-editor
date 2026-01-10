# Enhanced Auto-Editor 🎬

A smart video editor that automatically removes silence, enhances audio with AI, and removes filler words (um, ah, يعني, etc.) from your videos.

Perfect for YouTube creators, podcasters, and content creators who work with Arabic/English mixed content.

## Features ✨

- **🔇 Silence Removal** - Automatically cuts silent parts using auto-editor
- **🧠 AI Audio Enhancement** - DeepFilterNet AI for studio-quality voice (removes background noise, enhances clarity)
- **🗣️ Filler Word Detection** - Removes "um", "uh", "ah", "يعني", "امم", "اه" and more
- **🌐 Arabic/English Support** - Optimized for mixed dialect content (Egyptian, Levantine, Gulf)
- **⚡ GPU Accelerated** - Uses NVENC for fast video encoding
- **📁 Premiere Pro Export** - Exports XML for fine-tuning in Premiere Pro

## Pipeline 🔄

```
Input Video
    ↓
[Stage 1] Remove Silence (auto-editor, fast)
    ↓
[Stage 2] Enhance Audio (DeepFilterNet AI)
    ↓
[Stage 3] Transcribe (Groq API or local Whisper)
    ↓
[Stage 4] Remove Fillers → Export Premiere Pro XML
    ↓
Output: Clean video + XML for editing
```

## Installation 📦

### Quick Install (Recommended)

```bash
# Clone the repo
git clone https://github.com/da5ater/enhanced-Auto-editor.git
cd enhanced-Auto-editor

# Run the installer
./install.sh
```

### Manual Installation

1. **Install dependencies:**

```bash
# Arch Linux
sudo pacman -S ffmpeg python

# Ubuntu/Debian
sudo apt install ffmpeg python3 python3-pip
```

2. **Install Python packages:**

```bash
pip install auto-editor groq faster-whisper
```

3. **Install DeepFilterNet:**

```bash
mkdir -p ~/.local/bin
curl -L -o ~/.local/bin/deep-filter \
  "https://github.com/Rikorose/DeepFilterNet/releases/download/v0.5.6/deep-filter-0.5.6-x86_64-unknown-linux-musl"
chmod +x ~/.local/bin/deep-filter
```

4. **Install the edit command:**

```bash
cp edit ~/.local/bin/edit
chmod +x ~/.local/bin/edit
```

## Usage 🚀

### Basic Usage

```bash
# Interactive mode (recommended for first time)
edit video.mp4

# Use Groq API (recommended - best accuracy)
edit video.mp4 --groq

# Use local Whisper (offline, less accurate)
edit video.mp4 --local
```

### Options

```
edit video.mp4                  # Interactive mode
edit video.mp4 --groq           # Use Groq API (Whisper Large V3)
edit video.mp4 --local          # Use local Whisper (small model)
edit video.mp4 --render         # Also render final video
edit video.mp4 --no-enhance     # Skip DeepFilterNet enhancement
edit --set-groq-key             # Set your Groq API key
```

### Output Files

After processing, you'll get:

- `video_no_silence.mp4` - Video with silence removed
- `video_enhanced.mp4` - Video with AI-enhanced audio
- `video_premiere.xml` - Premiere Pro XML for fine-tuning
- `video_final.mp4` - Final rendered video (with `--render`)

## Groq API (Free) 🆓

This tool uses [Groq](https://groq.com) for fast, accurate transcription with Whisper Large V3 Turbo.

**Free tier limits:**

- 7,200 audio seconds/hour (2 hours of audio per hour)
- 28,800 audio seconds/day (8 hours of audio per day)

**Get your free API key:**

1. Go to https://console.groq.com/keys
2. Sign up / Log in
3. Create a new API key
4. Run `edit --set-groq-key YOUR_KEY`

## Filler Words Detected 🗣️

### English

um, uh, ah, so, like, emm, mmm, umm, uhh, ahh, hmm, er, erm, eh, mhm, ugh, well, okay, ok

### Arabic (Egyptian/Levantine/Gulf)

يعني، امم، اا، اه، آه، طب، بقى، ماشي، تمام، اصل، بس، يلا، هم، اهم، ايوه، اوكي، خلاص، كده، زي، عارف، والله

## Requirements 📋

- **OS:** Linux (tested on Arch Linux)
- **GPU:** NVIDIA GPU with NVENC support (optional, for faster encoding)
- **Python:** 3.10+
- **FFmpeg:** With AAC and h264_nvenc support
- **Disk Space:** ~50MB for DeepFilterNet binary

## How It Works 🔧

1. **Silence Removal:** Uses auto-editor's audio threshold detection to find and cut silent parts. This is done first to reduce processing time for subsequent stages.

2. **Audio Enhancement:** DeepFilterNet is a state-of-the-art deep learning model that removes background noise and enhances voice clarity without the artifacts of traditional EQ/compression.

3. **Transcription:** Uses either Groq API (cloud, accurate) or faster-whisper (local, offline) to transcribe speech with word-level timestamps.

4. **Filler Detection:** Analyzes transcription to find filler words and low-confidence mumbles, then marks them for cutting.

5. **Export:** Generates a Premiere Pro XML file with all cuts marked, allowing you to fine-tune before final render.

## Troubleshooting 🔧

### "auto-editor not found"

```bash
pip install auto-editor
```

### "CUDA out of memory"

Use `--groq` flag to use cloud transcription instead of local GPU.

### "DeepFilterNet not found"

```bash
curl -L -o ~/.local/bin/deep-filter \
  "https://github.com/Rikorose/DeepFilterNet/releases/download/v0.5.6/deep-filter-0.5.6-x86_64-unknown-linux-musl"
chmod +x ~/.local/bin/deep-filter
```

### "No Groq API key"

```bash
edit --set-groq-key YOUR_KEY
```

## License 📄

MIT License

## Credits 🙏

- [auto-editor](https://github.com/WyattBlue/auto-editor) - Automatic video editing
- [DeepFilterNet](https://github.com/Rikorose/DeepFilterNet) - AI audio enhancement
- [Groq](https://groq.com) - Fast Whisper API
- [faster-whisper](https://github.com/guillaumekln/faster-whisper) - Local Whisper implementation
