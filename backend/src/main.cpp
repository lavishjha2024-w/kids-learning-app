#include "Analytics.h"
#include "Simulator.h"
#include "TimeSeriesDB.h"

#include <chrono>
#include <iomanip>
#include <iostream>
#include <thread>

// MercuryAnalytics v2 (C++ backend demo)
//
// This executable:
// - simulates real-time multi-symbol tick ingestion,
// - stores ticks in an in-memory time-series DB,
// - computes analytics (MA, VWAP, OHLC) per symbol over the last N ticks,
// - periodically prints results,
// - persists ticks to backend/data/ticks.ndjson for inspection.
int main() {
  const std::vector<std::string> symbols = {"AAPL", "GOOG", "MSFT", "TSLA"};

  // Keep the last 10k ticks per symbol in memory for the demo.
  TimeSeriesDB db(/*perSymbolCapacity=*/10'000);

  // Persist ticks for demo/inspection.
  // Ensure backend/data exists (included in repo).
  const std::string persistPath = "data/ticks.ndjson";

  Simulator sim(db, symbols, persistPath);
  sim.start(/*ticksPerSecond=*/5);

  const std::size_t windowN = 50;
  std::cout << "MercuryAnalytics v2 running. Press Ctrl+C to stop.\n";
  std::cout << "Persisting ticks to: " << persistPath << "\n\n";

  while (true) {
    for (const auto& sym : symbols) {
      const auto window = db.lastNTicks(sym, windowN);
      const auto ma = Analytics::movingAverage(window);
      const auto vw = Analytics::vwap(window);
      const auto o = Analytics::ohlc(window);

      std::cout << std::left << std::setw(6) << sym << " | "
                << "N=" << std::setw(4) << window.size() << " | ";

      if (ma) std::cout << "MA=" << std::fixed << std::setprecision(4) << *ma << " ";
      else std::cout << "MA=NA ";

      if (vw) std::cout << "VWAP=" << std::fixed << std::setprecision(4) << *vw << " ";
      else std::cout << "VWAP=NA ";

      if (o) {
        std::cout << "OHLC=(" << o->open << "," << o->high << "," << o->low << "," << o->close << ")";
      } else {
        std::cout << "OHLC=NA";
      }
      std::cout << "\n";
    }
    std::cout << "----\n";
    std::this_thread::sleep_for(std::chrono::seconds(1));
  }

  return 0;
}

