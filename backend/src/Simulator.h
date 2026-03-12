#pragma once

#include "Tick.h"
#include "TimeSeriesDB.h"

#include <atomic>
#include <random>
#include <string>
#include <thread>
#include <unordered_map>
#include <vector>

// Real-time tick simulation for multiple symbols.
//
// This approximates a market data feed by emitting ticks on a fixed interval,
// with small random walks in price and random volumes.
class Simulator {
public:
  Simulator(TimeSeriesDB& db, std::vector<std::string> symbols, std::string persistPath);
  ~Simulator();

  // Start the background simulation thread.
  void start(int ticksPerSecond);

  // Stop the simulation thread.
  void stop();

private:
  void run(int ticksPerSecond);
  Tick nextTick(const std::string& symbol);

  TimeSeriesDB& db_;
  std::vector<std::string> symbols_;
  std::string persistPath_;

  std::atomic<bool> running_{false};
  std::thread worker_;

  std::mt19937_64 rng_;
  std::uniform_int_distribution<std::uint64_t> volDist_{10, 500};
  std::normal_distribution<double> priceMove_{0.0, 0.25};

  std::unordered_map<std::string, double> lastPrice_;
};

