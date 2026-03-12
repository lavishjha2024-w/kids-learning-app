#pragma once

#include "Tick.h"

#include <cstddef>
#include <deque>
#include <mutex>
#include <string>
#include <unordered_map>
#include <vector>

// In-memory time-series store for ticks per symbol.
//
// Notes:
// - This keeps the "last N" ticks per symbol in memory (bounded by capacity).
// - In production, you'd likely shard by symbol and use lock-free queues or a TSDB.
class TimeSeriesDB {
public:
  explicit TimeSeriesDB(std::size_t perSymbolCapacity);

  // Ingest a tick for a symbol.
  void ingest(const Tick& tick);

  // Get last N ticks (most recent last, in chronological order).
  std::vector<Tick> lastNTicks(const std::string& symbol, std::size_t n) const;

  // Return all known symbols.
  std::vector<std::string> symbols() const;

  std::size_t capacity() const;

private:
  std::size_t perSymbolCapacity_;

  mutable std::mutex mu_;
  std::unordered_map<std::string, std::deque<Tick>> data_;
};

