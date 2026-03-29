import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { useI18n } from "@/context/I18nContext";

const moods = [
  { emoji: "😊", labelKey: "mood.label.happy", responseKey: "mood.r.happy" },
  { emoji: "😐", labelKey: "mood.label.okay", responseKey: "mood.r.okay" },
  { emoji: "😢", labelKey: "mood.label.sad", responseKey: "mood.r.sad" },
  { emoji: "😴", labelKey: "mood.label.tired", responseKey: "mood.r.tired" },
  { emoji: "🤩", labelKey: "mood.label.excited", responseKey: "mood.r.excited" },
];

interface MoodCheckProps {
  onComplete: () => void;
}

const MoodCheck = ({ onComplete }: MoodCheckProps) => {
  const { t } = useI18n();
  const [selected, setSelected] = useState<number | null>(null);

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      className="kids-card max-w-md mx-auto text-center"
    >
      <h2 className="kids-heading text-xl mb-1">{t("mood.title")}</h2>
      <p className="text-muted-foreground text-sm mb-4">{t("mood.tap")}</p>

      <div className="flex justify-center gap-3 mb-4 flex-wrap">
        {moods.map((mood, i) => (
          <motion.button
            key={mood.labelKey}
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => setSelected(i)}
            className={`flex flex-col items-center gap-1 p-3 rounded-2xl transition-colors min-w-[56px] ${
              selected === i ? "bg-primary/30 ring-2 ring-primary" : "hover:bg-muted"
            }`}
            aria-label={t(mood.labelKey)}
          >
            <span className="text-3xl">{mood.emoji}</span>
            <span className="text-xs font-semibold">{t(mood.labelKey)}</span>
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
            <p className="text-foreground font-semibold mb-3">{t(moods[selected].responseKey)}</p>
            <button type="button" onClick={onComplete} className="kids-btn-secondary">
              {t("mood.go")}
            </button>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
};

export default MoodCheck;
