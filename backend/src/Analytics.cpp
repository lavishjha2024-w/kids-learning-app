#include "Analytics.h"

#include <algorithm>

namespace Analytics {

std::optional<double> movingAverage(const std::vector<Tick>& window) {
  if (window.empty()) return std::nullopt;
  double sum = 0.0;
  for (const auto& t : window) sum += t.price;
  return sum / static_cast<double>(window.size());
}

std::optional<double> vwap(const std::vector<Tick>& window) {
  if (window.empty()) return std::nullopt;
  long double pv = 0.0L;
  long double v = 0.0L;
  for (const auto& t : window) {
    pv += static_cast<long double>(t.price) * static_cast<long double>(t.volume);
    v += static_cast<long double>(t.volume);
  }
  if (v == 0.0L) return std::nullopt;
  return static_cast<double>(pv / v);
}

std::optional<Ohlc> ohlc(const std::vector<Tick>& window) {
  if (window.empty()) return std::nullopt;
  Ohlc o{};
  o.open = window.front().price;
  o.close = window.back().price;
  auto [minIt, maxIt] = std::minmax_element(
      window.begin(), window.end(), [](const Tick& a, const Tick& b) { return a.price < b.price; });
  o.low = minIt->price;
  o.high = maxIt->price;
  return o;
}

} // namespace Analytics

