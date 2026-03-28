import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";

const moods = [
  { emoji: "😊", label: "Happy", response: "Wonderful! Let's have fun learning!" },
  { emoji: "😐", label: "Okay", response: "That's alright! Learning can cheer you up!" },
  { emoji: "😢", label: "Sad", response: "It's okay to feel sad. Let's do something fun together! 💛" },
  { emoji: "😴", label: "Tired", response: "Maybe take a little rest first? You can come back anytime! 🌙" },
  { emoji: "🤩", label: "Excited", response: "Yay! Let's make today awesome! 🌟" },
];

interface MoodCheckProps {
  onComplete: () => void;
}

const MoodCheck = ({ onComplete }: MoodCheckProps) => {
  const [selected, setSelected] = useState<number | null>(null);

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      className="kids-card max-w-md mx-auto text-center"
    >
      <h2 className="kids-heading text-xl mb-1">How are you feeling today?</h2>
      <p className="text-muted-foreground text-sm mb-4">Tap how you feel!</p>

      <div className="flex justify-center gap-3 mb-4">
        {moods.map((mood, i) => (
          <motion.button
            key={mood.label}
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => setSelected(i)}
            className={`flex flex-col items-center gap-1 p-3 rounded-2xl transition-colors min-w-[56px] ${
              selected === i ? "bg-primary/30 ring-2 ring-primary" : "hover:bg-muted"
            }`}
            aria-label={mood.label}
          >
            <span className="text-3xl">{mood.emoji}</span>
            <span className="text-xs font-semibold">{mood.label}</span>
          </motion.button>
        ))}
      </div>

      <AnimatePresence>
        {selected !== null && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: "auto" }}
            className="overflow-hidden"
          >
            <p className="text-foreground font-semibold mb-3">{moods[selected].response}</p>
            <button onClick={onComplete} className="kids-btn-secondary">
              Let's Go! 🚀
            </button>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
};

export default MoodCheck;
