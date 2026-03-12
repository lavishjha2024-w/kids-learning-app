#include "Persistence.h"

#include <chrono>
#include <fstream>
#include <iomanip>
#include <sstream>

namespace {

// Minimal JSON string escaper for symbol field.
std::string jsonEscape(const std::string& s) {
  std::ostringstream out;
  for (char c : s) {
    switch (c) {
      case '\\': out << "\\\\"; break;
      case '"': out << "\\\""; break;
      case '\n': out << "\\n"; break;
      case '\r': out << "\\r"; break;
      case '\t': out << "\\t"; break;
      default: out << c; break;
    }
  }
  return out.str();
}

} // namespace

namespace Persistence {

bool appendTickNdjson(const std::string& filePath, const Tick& tick) {
  std::ofstream f(filePath, std::ios::app);
  if (!f.is_open()) return false;

  // NDJSON: one JSON object per line.
  // Example: {"symbol":"AAPL","price":187.12,"volume":120,"ts_ms":1710200000000}
  f << "{\"symbol\":\"" << jsonEscape(tick.symbol) << "\","
    << "\"price\":" << std::fixed << std::setprecision(4) << tick.price << ","
    << "\"volume\":" << tick.volume << ","
    << "\"ts_ms\":" << tick.ts_ms << "}\n";
  return true;
}

} // namespace Persistence

