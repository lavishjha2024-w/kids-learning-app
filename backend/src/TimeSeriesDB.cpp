#include "TimeSeriesDB.h"

#include <algorithm>

TimeSeriesDB::TimeSeriesDB(std::size_t perSymbolCapacity) : perSymbolCapacity_(perSymbolCapacity) {}

void TimeSeriesDB::ingest(const Tick& tick) {
  std::lock_guard<std::mutex> lock(mu_);
  auto& q = data_[tick.symbol];
  q.push_back(tick);
  while (q.size() > perSymbolCapacity_) {
    q.pop_front();
  }
}

std::vector<Tick> TimeSeriesDB::lastNTicks(const std::string& symbol, std::size_t n) const {
  std::lock_guard<std::mutex> lock(mu_);
  std::vector<Tick> out;
  const auto it = data_.find(symbol);
  if (it == data_.end() || n == 0) return out;

  const auto& q = it->second;
  const std::size_t take = std::min(n, q.size());
  out.reserve(take);
  // Keep chronological order (oldest -> newest) for charting/aggregation.
  for (std::size_t i = q.size() - take; i < q.size(); i++) {
    out.push_back(q[i]);
  }
  return out;
}

std::vector<std::string> TimeSeriesDB::symbols() const {
  std::lock_guard<std::mutex> lock(mu_);
  std::vector<std::string> out;
  out.reserve(data_.size());
  for (const auto& kv : data_) out.push_back(kv.first);
  std::sort(out.begin(), out.end());
  return out;
}

std::size_t TimeSeriesDB::capacity() const { return perSymbolCapacity_; }

