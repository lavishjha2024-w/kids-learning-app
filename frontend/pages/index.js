import { useEffect, useMemo, useState } from "react";
import SymbolCard from "../components/SymbolCard";

const DEFAULT_SYMBOLS = ["AAPL", "GOOG", "MSFT", "TSLA"];

function apiBase() {
  return process.env.NEXT_PUBLIC_API_BASE_URL || "http://localhost:4000";
}

async function fetchJson(url) {
  const res = await fetch(url);
  if (!res.ok) {
    const text = await res.text();
    throw new Error(`${res.status} ${text}`);
  }
  return res.json();
}

export default function HomePage() {
  const [symbols, setSymbols] = useState(DEFAULT_SYMBOLS);
  const [ticksBySymbol, setTicksBySymbol] = useState({});
  const [analyticsBySymbol, setAnalyticsBySymbol] = useState({});
  const [status, setStatus] = useState({ ok: true, message: "Polling…" });

  const base = useMemo(() => apiBase(), []);

  useEffect(() => {
    let cancelled = false;

    // Data fetching logic:
    // - Every second: refresh symbols list (best-effort) and fetch ticks + analytics.
    // - This keeps the demo simple and robust for Vercel deployment.
    async function pollOnce() {
      try {
        // Prefer API-provided symbols if available.
        const symResp = await fetchJson(`${base}/symbols`);
        const apiSymbols = Array.isArray(symResp.symbols) && symResp.symbols.length ? symResp.symbols : DEFAULT_SYMBOLS;
        if (!cancelled) setSymbols(apiSymbols);

        const nextTicks = {};
        const nextAnalytics = {};
        await Promise.all(
          apiSymbols.map(async (sym) => {
            const [t, a] = await Promise.all([
              fetchJson(`${base}/ticks/${encodeURIComponent(sym)}?n=120`),
              fetchJson(`${base}/analytics/${encodeURIComponent(sym)}?n=50`)
            ]);
            nextTicks[sym] = t.ticks || [];
            nextAnalytics[sym] = { ma: a.ma, vwap: a.vwap, ohlc: a.ohlc };
          })
        );

        if (!cancelled) {
          setTicksBySymbol(nextTicks);
          setAnalyticsBySymbol(nextAnalytics);
          setStatus({ ok: true, message: "Live" });
        }
      } catch (e) {
        if (!cancelled) setStatus({ ok: false, message: `API error: ${String(e.message || e)}` });
      }
    }

    pollOnce();
    const id = setInterval(pollOnce, 1000);
    return () => {
      cancelled = true;
      clearInterval(id);
    };
  }, [base]);

  return (
    <div className="container">
      <div className="header">
        <div>
          <h1 className="title">MercuryAnalytics v2 – Real-Time Market Data Engine</h1>
          <p className="subtitle">
            Multi-symbol tick ingestion + windowed analytics (MA/VWAP/OHLC). Frontend polls the API every 1s.
          </p>
        </div>
        <div className="pill">
          API: <strong>{base}</strong> · Status: <strong>{status.ok ? "OK" : "DOWN"}</strong>
        </div>
      </div>

      {!status.ok ? (
        <div className="card">
          <div style={{ color: "rgba(255,255,255,0.92)", fontWeight: 700, marginBottom: 6 }}>Cannot reach API</div>
          <div style={{ color: "rgba(255,255,255,0.70)", fontSize: 13, lineHeight: 1.5 }}>
            {status.message}
            <div style={{ marginTop: 10 }}>
              Start the API: <code>cd api && npm install && npm run dev</code>
              <br />
              Then start the simulator: <code>cd api && npm run simulate</code>
            </div>
          </div>
        </div>
      ) : null}

      <div className="grid" style={{ marginTop: 14 }}>
        {symbols.map((sym) => (
          <SymbolCard
            key={sym}
            symbol={sym}
            ticks={ticksBySymbol[sym] || []}
            analytics={analyticsBySymbol[sym] || null}
          />
        ))}
      </div>

      <div className="footerNote">
        Tip: For Vercel, set <code>NEXT_PUBLIC_API_BASE_URL</code> to your deployed API host.
      </div>
    </div>
  );
}

