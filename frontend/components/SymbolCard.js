import { Line } from "react-chartjs-2";
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Tooltip,
  Legend
} from "chart.js";

// Chart.js modules must be registered once before rendering charts.
ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Tooltip, Legend);

function formatNum(x) {
  if (x == null || Number.isNaN(x)) return "—";
  return Number(x).toFixed(4);
}

export default function SymbolCard({ symbol, ticks, analytics }) {
  // Frontend chart rendering logic:
  // - Plot price (primary), MA and VWAP as separate series.
  // - Use ts_ms as x labels (lightweight formatting).
  const labels = ticks.map((t) => new Date(t.ts_ms).toLocaleTimeString());
  const prices = ticks.map((t) => t.price);
  const ma = ticks.map(() => analytics?.ma ?? null);
  const vw = ticks.map(() => analytics?.vwap ?? null);

  const data = {
    labels,
    datasets: [
      {
        label: "Price",
        data: prices,
        borderColor: "rgba(255,255,255,0.9)",
        backgroundColor: "rgba(255,255,255,0.12)",
        tension: 0.25,
        pointRadius: 0
      },
      {
        label: "MA",
        data: ma,
        borderColor: "rgba(124,58,237,0.95)",
        backgroundColor: "rgba(124,58,237,0.12)",
        borderDash: [6, 4],
        tension: 0.25,
        pointRadius: 0
      },
      {
        label: "VWAP",
        data: vw,
        borderColor: "rgba(16,185,129,0.95)",
        backgroundColor: "rgba(16,185,129,0.12)",
        borderDash: [3, 3],
        tension: 0.25,
        pointRadius: 0
      }
    ]
  };

  const options = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: true, labels: { color: "rgba(255,255,255,0.75)" } },
      tooltip: { mode: "index", intersect: false }
    },
    interaction: { mode: "index", intersect: false },
    scales: {
      x: { ticks: { color: "rgba(255,255,255,0.5)", maxTicksLimit: 6 }, grid: { color: "rgba(255,255,255,0.08)" } },
      y: { ticks: { color: "rgba(255,255,255,0.5)" }, grid: { color: "rgba(255,255,255,0.08)" } }
    }
  };

  return (
    <div className="card">
      <div className="cardHeader">
        <div className="symbol">{symbol}</div>
        <div className="stats">
          <div className="stat">MA: {formatNum(analytics?.ma)}</div>
          <div className="stat">VWAP: {formatNum(analytics?.vwap)}</div>
          <div className="stat">
            OHLC:{" "}
            {analytics?.ohlc
              ? `${formatNum(analytics.ohlc.open)} / ${formatNum(analytics.ohlc.high)} / ${formatNum(
                  analytics.ohlc.low
                )} / ${formatNum(analytics.ohlc.close)}`
              : "—"}
          </div>
        </div>
      </div>
      <div className="chartWrap">
        <Line data={data} options={options} />
      </div>
    </div>
  );
}

