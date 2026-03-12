// Simple tick simulator that POSTS ticks to the local Express API.
// This makes the frontend demo work without needing to run the C++ binary.

const API_BASE = process.env.API_BASE_URL || "http://localhost:4000";
const SYMBOLS = (process.env.SYMBOLS || "AAPL,GOOG,MSFT,TSLA").split(",").map(s => s.trim()).filter(Boolean);
const TICKS_PER_SECOND = Number(process.env.TICKS_PER_SECOND || 5);

function nowMs() {
  return Date.now();
}

function sleep(ms) {
  return new Promise(r => setTimeout(r, ms));
}

const state = new Map();
for (let i = 0; i < SYMBOLS.length; i++) {
  state.set(SYMBOLS[i], 100 + i * 50);
}

function randn() {
  // Box-Muller
  let u = 0, v = 0;
  while (u === 0) u = Math.random();
  while (v === 0) v = Math.random();
  return Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
}

function nextTick(symbol) {
  const last = state.get(symbol) ?? 100;
  const move = randn() * 0.25;
  const px = Math.max(0.01, last + move);
  state.set(symbol, px);
  const volume = Math.floor(10 + Math.random() * 500);
  return { symbol, price: Number(px.toFixed(4)), volume, ts_ms: nowMs() };
}

async function postTick(tick) {
  const res = await fetch(`${API_BASE}/ticks`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(tick)
  });
  if (!res.ok) {
    const body = await res.text();
    throw new Error(`POST /ticks failed: ${res.status} ${body}`);
  }
}

async function main() {
  console.log(`Posting ticks to ${API_BASE}`);
  console.log(`Symbols: ${SYMBOLS.join(", ")}`);
  console.log(`Ticks/sec: ${TICKS_PER_SECOND}`);

  const intervalMs = TICKS_PER_SECOND <= 0 ? 100 : Math.floor(1000 / TICKS_PER_SECOND);

  while (true) {
    for (const sym of SYMBOLS) {
      const t = nextTick(sym);
      // This is the ingestion call into the API's in-memory tick store.
      await postTick(t);
    }
    await sleep(intervalMs);
  }
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});

