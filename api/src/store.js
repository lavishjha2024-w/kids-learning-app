// In-memory time-series store for ticks per symbol.
// This mirrors the C++ backend concept, but is implemented in Node so the
// frontend can work against a simple REST API.

const DEFAULT_CAPACITY_PER_SYMBOL = 10000;

/**
 * @typedef {{symbol:string, price:number, volume:number, ts_ms:number}} Tick
 */

class TickStore {
  constructor({ perSymbolCapacity = DEFAULT_CAPACITY_PER_SYMBOL } = {}) {
    this.perSymbolCapacity = perSymbolCapacity;
    /** @type {Map<string, Tick[]>} */
    this.data = new Map();
  }

  ingest(tick) {
    const sym = tick.symbol;
    if (!this.data.has(sym)) this.data.set(sym, []);
    const arr = this.data.get(sym);
    arr.push(tick);
    if (arr.length > this.perSymbolCapacity) {
      arr.splice(0, arr.length - this.perSymbolCapacity);
    }
  }

  symbols() {
    return Array.from(this.data.keys()).sort();
  }

  lastNTicks(symbol, n) {
    const arr = this.data.get(symbol) || [];
    if (!n || n <= 0) return [];
    return arr.slice(Math.max(0, arr.length - n));
  }
}

module.exports = { TickStore };

