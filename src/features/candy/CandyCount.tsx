import { useEffect, useRef, useState, type ReactNode } from "react";
import { motion, AnimatePresence } from "framer-motion";

interface CandyCountProps {
  count: number;
  className?: string;
  /** Shown next to count (e.g. candy emoji). */
  icon?: ReactNode;
}

/** Same footprint as a text line: shows count + optional floating +N when value increases. */
export function CandyCount({ count, className = "", icon }: CandyCountProps) {
  const prev = useRef<number | null>(null);
  const [delta, setDelta] = useState<number | null>(null);

  useEffect(() => {
    if (prev.current === null) {
      prev.current = count;
      return;
    }
    if (count > prev.current) {
      setDelta(count - prev.current);
      const t = window.setTimeout(() => setDelta(null), 1100);
      prev.current = count;
      return () => clearTimeout(t);
    }
    prev.current = count;
  }, [count]);

  return (
    <span className={`relative inline-flex items-center gap-1 ${className}`}>
      {icon}
      <motion.span
        key={count}
        initial={{ scale: 1 }}
        animate={{ scale: [1, 1.12, 1] }}
        transition={{ duration: 0.35 }}
        className="tabular-nums font-black"
      >
        {count}
      </motion.span>
      <AnimatePresence>
        {delta != null && delta > 0 && (
          <motion.span
            initial={{ opacity: 0, y: 6 }}
            animate={{ opacity: 1, y: -14 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.9 }}
            className="absolute -right-1 -top-5 text-sm font-black text-kids-mint pointer-events-none whitespace-nowrap"
            aria-hidden
          >
            +{delta} 🍬
          </motion.span>
        )}
      </AnimatePresence>
    </span>
  );
}
