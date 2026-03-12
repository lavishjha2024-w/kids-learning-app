// MercuryAnalytics v2 – Express API
//
// Routes:
// - POST /ticks               ingest a tick (symbol, price, volume, ts_ms)
// - GET  /symbols             list known symbols
// - GET  /ticks/:symbol?n=200 last N ticks for symbol
// - GET  /analytics/:symbol?n=50 analytics over last N ticks (MA/VWAP/OHLC)

const express = require("express");
const cors = require("cors");

const { TickStore } = require("./store");
const { movingAverage, vwap, ohlc } = require("./analytics");

const app = express();
app.use(cors());
app.use(express.json({ limit: "1mb" }));

const store = new TickStore({ perSymbolCapacity: 10000 });

function parseN(req, fallback) {
  const raw = req.query.n;
  const n = raw == null ? fallback : Number(raw);
  if (!Number.isFinite(n) || n <= 0) return fallback;
  return Math.min(Math.floor(n), 10000);
}

function validateTick(body) {
  const symbol = typeof body.symbol === "string" ? body.symbol.trim() : "";
  const price = Number(body.price);
  const volume = Number(body.volume);
  const ts_ms = body.ts_ms == null ? Date.now() : Number(body.ts_ms);

  if (!symbol) return { ok: false, error: "symbol is required" };
  if (!Number.isFinite(price) || price <= 0) return { ok: false, error: "price must be a positive number" };
  if (!Number.isFinite(volume) || volume < 0) return { ok: false, error: "volume must be a non-negative number" };
  if (!Number.isFinite(ts_ms) || ts_ms <= 0) return { ok: false, error: "ts_ms must be epoch milliseconds" };

  return {
    ok: true,
    tick: { symbol, price, volume: Math.floor(volume), ts_ms: Math.floor(ts_ms) }
  };
}

app.get("/health", (_req, res) => {
  res.json({ ok: true, service: "mercuryanalytics-v2-api" });
});

app.get("/symbols", (_req, res) => {
  res.json({ symbols: store.symbols() });
});

app.post("/ticks", (req, res) => {
  // Ingestion endpoint: accepts one tick at a time for clarity.
  const v = validateTick(req.body || {});
  if (!v.ok) return res.status(400).json({ ok: false, error: v.error });
  store.ingest(v.tick);
  return res.status(201).json({ ok: true });
});

app.get("/ticks/:symbol", (req, res) => {
  const symbol = String(req.params.symbol || "").trim();
  const n = parseN(req, 200);
  const ticks = store.lastNTicks(symbol, n);
  res.json({ symbol, n, ticks });
});

app.get("/analytics/:symbol", (req, res) => {
  const symbol = String(req.params.symbol || "").trim();
  const n = parseN(req, 50);
  const window = store.lastNTicks(symbol, n);
  res.json({
    symbol,
    n,
    ma: movingAverage(window),
    vwap: vwap(window),
    ohlc: ohlc(window),
    latest: window.length ? window[window.length - 1] : null
  });
});

const port = Number(process.env.PORT || 4000);
app.listen(port, () => {
  console.log(`MercuryAnalytics v2 API listening on http://localhost:${port}`);
});

