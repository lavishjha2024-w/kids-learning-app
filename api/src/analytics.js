// Analytics helpers for MA, VWAP, and OHLC over the last N ticks.
// These computations are windowed by "last N ticks" for a straightforward demo.

/**
 * @param {Array<{price:number}>} window
 */
function movingAverage(window) {
  if (!window.length) return null;
  const sum = window.reduce((acc, t) => acc + t.price, 0);
  return sum / window.length;
}

/**
 * @param {Array<{price:number, volume:number}>} window
 */
function vwap(window) {
  if (!window.length) return null;
  let pv = 0;
  let v = 0;
  for (const t of window) {
    pv += t.price * t.volume;
    v += t.volume;
  }
  if (v === 0) return null;
  return pv / v;
}

/**
 * @param {Array<{price:number}>} window
 */
function ohlc(window) {
  if (!window.length) return null;
  const open = window[0].price;
  const close = window[window.length - 1].price;
  let high = -Infinity;
  let low = Infinity;
  for (const t of window) {
    high = Math.max(high, t.price);
    low = Math.min(low, t.price);
  }
  return { open, high, low, close };
}

module.exports = { movingAverage, vwap, ohlc };

