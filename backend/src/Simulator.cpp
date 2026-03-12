#include "Simulator.h"

#include "Persistence.h"

#include <chrono>

namespace {

std::int64_t nowMs() {
  using namespace std::chrono;
  return duration_cast<milliseconds>(system_clock::now().time_since_epoch()).count();
}

} // namespace

Simulator::Simulator(TimeSeriesDB& db, std::vector<std::string> symbols, std::string persistPath)
    : db_(db), symbols_(std::move(symbols)), persistPath_(std::move(persistPath)) {
  std::random_device rd;
  rng_ = std::mt19937_64(rd());

  // Seed starting prices (so each symbol has its own "level").
  for (std::size_t i = 0; i < symbols_.size(); i++) {
    lastPrice_[symbols_[i]] = 100.0 + static_cast<double>(i) * 50.0;
  }
}

Simulator::~Simulator() { stop(); }

void Simulator::start(int ticksPerSecond) {
  if (running_) return;
  running_ = true;
  worker_ = std::thread([this, ticksPerSecond]() { run(ticksPerSecond); });
}

void Simulator::stop() {
  if (!running_) return;
  running_ = false;
  if (worker_.joinable()) worker_.join();
}

void Simulator::run(int ticksPerSecond) {
  using namespace std::chrono;
  const int intervalMs = ticksPerSecond <= 0 ? 100 : (1000 / ticksPerSecond);

  while (running_) {
    for (const auto& sym : symbols_) {
      const Tick t = nextTick(sym);
      // "Ingestion": tick enters the in-memory time-series DB.
      db_.ingest(t);
      // "Persistence": optional write to disk for demo/inspection.
      (void)Persistence::appendTickNdjson(persistPath_, t);
    }
    std::this_thread::sleep_for(milliseconds(intervalMs));
  }
}

Tick Simulator::nextTick(const std::string& symbol) {
  double& px = lastPrice_[symbol];
  px = std::max(0.01, px + priceMove_(rng_));
  Tick t;
  t.symbol = symbol;
  t.price = px;
  t.volume = volDist_(rng_);
  t.ts_ms = nowMs();
  return t;
}

