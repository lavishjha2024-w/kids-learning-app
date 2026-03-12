#pragma once

#include <cstdint>
#include <string>

// A single market data tick.
// In a real feed, you'd typically have exchange timestamps and more fields.
struct Tick {
  std::string symbol;
  double price = 0.0;
  std::uint64_t volume = 0;
  std::int64_t ts_ms = 0; // epoch milliseconds
};

