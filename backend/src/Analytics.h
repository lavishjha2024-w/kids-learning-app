#pragma once

#include "Tick.h"

#include <cstddef>
#include <optional>
#include <vector>

struct Ohlc {
  double open = 0.0;
  double high = 0.0;
  double low = 0.0;
  double close = 0.0;
};

// Analytics over a window of ticks.
// These are "last N ticks" computations for demo purposes.
namespace Analytics {

// Simple moving average of price over last N ticks.
std::optional<double> movingAverage(const std::vector<Tick>& window);

// Volume-weighted average price over last N ticks.
std::optional<double> vwap(const std::vector<Tick>& window);

// OHLC aggregation over last N ticks.
std::optional<Ohlc> ohlc(const std::vector<Tick>& window);

} // namespace Analytics

