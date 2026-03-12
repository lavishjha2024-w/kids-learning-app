#pragma once

#include "Tick.h"

#include <string>

// Simple persistence layer for demo purposes.
// Writes ticks to newline-delimited JSON (NDJSON) so it can be tailed/parsed easily.
namespace Persistence {

// Append one tick to an NDJSON file. Creates parent folders if they exist already.
// (This intentionally keeps dependencies minimal—no external JSON library.)
bool appendTickNdjson(const std::string& filePath, const Tick& tick);

} // namespace Persistence

