import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { useApp } from "@/context/AppContext";

const BreakReminder = () => {
  const { showBreakReminder, setShowBreakReminder, settings } = useApp();
  const [timeLeft, setTimeLeft] = useState(settings.breakDuration * 60);
  const [phase, setPhase] = useState<"remind" | "breathing">("remind");

  useEffect(() => {
    if (showBreakReminder) {
      setTimeLeft(settings.breakDuration * 60);
      setPhase("remind");
    }
  }, [showBreakReminder, settings.breakDuration]);

  useEffect(() => {
    if (!showBreakReminder || phase !== "breathing") return;
    if (timeLeft <= 0) {
      setShowBreakReminder(false);
      return;
    }
    const timer = setInterval(() => setTimeLeft((t) => t - 1), 1000);
    return () => clearInterval(timer);
  }, [showBreakReminder, phase, timeLeft, setShowBreakReminder]);

  const minutes = Math.floor(timeLeft / 60);
  const seconds = timeLeft % 60;

  return (
    <AnimatePresence>
      {showBreakReminder && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-[100] flex items-center justify-center bg-foreground/30 backdrop-blur-sm p-4"
        >
          <motion.div
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.8, opacity: 0 }}
            className="bg-card rounded-3xl p-8 max-w-sm w-full text-center shadow-hover"
          >
            {phase === "remind" ? (
              <>
                <div className="text-6xl mb-4">🌈</div>
                <h2 className="kids-heading text-2xl mb-2">Time for a Break!</h2>
                <p className="text-muted-foreground mb-6">
                  You've been learning for a while. Let's rest your eyes and stretch!
                </p>
                <button
                  onClick={() => setPhase("breathing")}
                  className="kids-btn-primary w-full"
                >
                  Start Breathing Exercise 🧘
                </button>
                <button
                  onClick={() => setShowBreakReminder(false)}
                  className="mt-3 text-sm text-muted-foreground underline"
                >
                  Parent: Skip break
                </button>
              </>
            ) : (
              <>
                <h2 className="kids-heading text-xl mb-4">Breathe with me...</h2>
                <motion.div
                  animate={{ scale: [1, 1.3, 1] }}
                  transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
                  className="w-32 h-32 mx-auto rounded-full bg-kids-mint flex items-center justify-center mb-6"
                >
                  <span className="text-3xl">😌</span>
                </motion.div>
                <p className="text-muted-foreground mb-2">Breathe in... and out...</p>
                <p className="text-2xl font-bold text-foreground">
                  {minutes}:{seconds.toString().padStart(2, "0")}
                </p>
              </>
            )}
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default BreakReminder;
