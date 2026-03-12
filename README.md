# MercuryAnalytics v2 – Real-Time Multi-Symbol Market Data Engine

Production-ready demo project with:

- **Backend (C++)**: Real-time multi-symbol tick simulation, in-memory time-series store, analytics (MA, VWAP, OHLC), and optional persistence to `backend/data/`.
- **Node.js API (Express)**: REST endpoints to ingest ticks and serve ticks + analytics to the frontend.
- **Frontend (Next.js + React)**: Live dashboard polling the API every second with charts (via `react-chartjs-2`).

> Live demo: **(placeholder)**  
> GitHub repo: **(placeholder)**

---

## Project structure

```text
backend/
  src/
  data/
api/
frontend/
  pages/
  components/
```

---

## Quickstart (local)

### 1) API (Express)

```bash
cd api
npm install
npm run dev
```

API runs at `http://localhost:4000` by default.

### 2) Start a tick simulator that posts to the API

In a separate terminal:

```bash
cd api
npm run simulate
```

### 3) Frontend (Next.js)

In a separate terminal:

```bash
cd frontend
npm install
cp .env.local.example .env.local
npm run dev
```

Open `http://localhost:3000`.

---

## C++ backend simulation (standalone)

This is a self-contained simulation that prints analytics per symbol and persists ticks to `backend/data/ticks.ndjson`.

```bash
cd backend
cmake -S . -B build
cmake --build build
./build/mercury_analytics
```

---

## REST API

- `POST /ticks` submit a tick
- `GET /symbols` list symbols currently seen
- `GET /ticks/:symbol?n=200` last N ticks
- `GET /analytics/:symbol?n=50` MA, VWAP, and OHLC over last N ticks

---

## Deploy to Vercel (frontend)

1. Push this repo to GitHub.
2. In Vercel, import the GitHub repo.
3. Set **Project Root** to `frontend/`.
4. Set environment variable:
   - `NEXT_PUBLIC_API_BASE_URL` = your API URL (e.g. `https://your-api-host.com`)
5. Deploy.

> The API in this repo is an Express server. Vercel can host it as Serverless Functions with additional refactoring, but for a clean demo we recommend deploying the API on Render/Fly/Railway and pointing the Vercel frontend at it.

---

## Push to GitHub

```bash
git add .
git commit -m "Add MercuryAnalytics v2 engine/api/frontend"
git remote add origin <your-github-repo-url>
git push -u origin main
```

---

## License

MIT

---

# Kids Learning Flutter App

A Flutter-based mobile learning app for kids (Age 4–10) that follows Human-Computer Interaction (HCI) principles with child-friendly UI/UX, reduced cognitive load, eye-friendly design, and mental health support.

## Features

### Core HCI principles implemented

- Consistency across all screens
- Visibility of system status
- Immediate feedback for all actions
- Error prevention and recovery
- Recognition over recall (icons + labels)
- Minimal cognitive load
- User control and freedom
- Accessibility features
- Flexibility and efficiency
- Aesthetic & minimalist design

### Learning modules

- Alphabets with voice guidance
- Numbers & counting
- Basic math (interactive)
- Shapes and colors
- Simple puzzles
- Memory matching game
- Story mode with narration

### Mental health features

- Break reminder system (30-minute intervals)
- Smart usage tracking
- Calm mode (reduced animations/sounds)
- Positive reinforcement system
- Parent control panel

### Accessibility

- Text-to-speech
- Adjustable font size
- Dyslexia-friendly font option
- Colorblind-friendly mode
- Voice navigation option

## Getting started (Flutter)

```bash
flutter pub get
flutter run
```

