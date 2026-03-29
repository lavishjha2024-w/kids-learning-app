import { useEffect, useState, useCallback } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { ArrowLeft } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { cn } from "@/lib/utils";
import { useApp } from "@/context/AppContext";
import { useI18n } from "@/context/I18nContext";
import raw from "@/data/gk-questions.json";
import type { GKQuestion } from "@/data/gkTypes";

const CATEGORIES: { id: string; labelKey: string }[] = [
  { id: "animals", labelKey: "gk.category.animals" },
  { id: "space", labelKey: "gk.category.space" },
  { id: "science", labelKey: "gk.category.science" },
  { id: "geography", labelKey: "gk.category.geography" },
  { id: "everyday", labelKey: "gk.category.everyday" },
];

function shuffle<T>(arr: T[]): T[] {
  return [...arr].sort(() => Math.random() - 0.5);
}

const pool = raw.questions as GKQuestion[];

const GeneralKnowledge = () => {
  const navigate = useNavigate();
  const { t } = useI18n();
  const { awardCandies, recordStreakActivity } = useApp();
  const [category, setCategory] = useState("animals");
  const [difficulty, setDifficulty] = useState<"easy" | "medium" | "random">("random");
  const [order, setOrder] = useState<GKQuestion[]>([]);
  const [idx, setIdx] = useState(0);
  const [feedback, setFeedback] = useState<"ok" | "retry" | null>(null);

  const buildOrder = useCallback(() => {
    let q = pool.filter((x) => x.category === category);
    if (difficulty !== "random") q = q.filter((x) => x.difficulty === difficulty);
    return shuffle(q);
  }, [category, difficulty]);

  useEffect(() => {
    setOrder(buildOrder());
    setIdx(0);
    setFeedback(null);
  }, [buildOrder]);

  const q = order[idx];

  const onCorrect = () => {
    recordStreakActivity();
    awardCandies(10);
    setFeedback("ok");
  };

  const onWrong = () => {
    setFeedback("retry");
  };

  const checkMcq = (i: number, correctIndex: number) => {
    if (feedback) return;
    if (i === correctIndex) onCorrect();
    else onWrong();
  };

  const checkTf = (v: boolean, correct: boolean) => {
    if (feedback) return;
    if (v === correct) onCorrect();
    else onWrong();
  };

  const next = () => {
    setFeedback(null);
    if (idx >= order.length - 1) {
      setOrder(buildOrder());
      setIdx(0);
    } else setIdx((i) => i + 1);
  };

  return (
    <div className="page-container">
      <button
        type="button"
        onClick={() => navigate("/")}
        className="flex items-center gap-2 text-muted-foreground mb-4 font-semibold min-h-[44px]"
      >
        <ArrowLeft size={20} aria-hidden /> {t("nav.home")}
      </button>

      <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="mb-6">
        <h1 className="kids-heading text-3xl sm:text-4xl mb-1">{t("gk.title")}</h1>
        <p className="text-muted-foreground font-semibold">{t("gk.sub")}</p>
      </motion.div>

      <div className="flex flex-wrap gap-2 mb-4">
        <button
          type="button"
          onClick={() => setDifficulty("easy")}
          className={cn(
            "kids-btn text-sm !min-h-[44px] !py-2",
            difficulty === "easy" ? "bg-primary" : "bg-muted text-muted-foreground",
          )}
        >
          {t("gk.diff.easy")}
        </button>
        <button
          type="button"
          onClick={() => setDifficulty("medium")}
          className={cn(
            "kids-btn text-sm !min-h-[44px] !py-2",
            difficulty === "medium" ? "bg-primary" : "bg-muted text-muted-foreground",
          )}
        >
          {t("gk.diff.medium")}
        </button>
        <button
          type="button"
          onClick={() => setDifficulty("random")}
          className={cn(
            "kids-btn text-sm !min-h-[44px] !py-2",
            difficulty === "random" ? "bg-primary" : "bg-muted text-muted-foreground",
          )}
        >
          {t("gk.diff.random")}
        </button>
      </div>

      <div className="flex flex-wrap gap-2 mb-6">
        {CATEGORIES.map((c) => (
          <button
            key={c.id}
            type="button"
            onClick={() => setCategory(c.id)}
            className={cn(
              "kids-btn text-sm !min-h-[44px] !py-2",
              category === c.id ? "bg-primary" : "bg-muted text-muted-foreground",
            )}
          >
            {t(c.labelKey)}
          </button>
        ))}
      </div>

      {order.length === 0 && (
        <p className="text-muted-foreground font-semibold mb-4">{t("gk.empty")}</p>
      )}
      {q && (
        <div className="kids-card border border-border/40">
          {q.type === "image" && (
            <div className="text-7xl text-center mb-4" aria-hidden>
              {q.image}
            </div>
          )}
          <p className="font-black text-lg text-balance mb-4">{q.question}</p>
          {q.type === "mcq" || q.type === "image" ? (
            <div className="grid gap-2">
              {q.options.map((opt, i) => (
                <motion.button
                  key={i}
                  type="button"
                  whileTap={{ scale: 0.99 }}
                  disabled={!!feedback}
                  onClick={() => checkMcq(i, q.correctIndex)}
                  className="kids-btn-secondary w-full text-left justify-start !py-4"
                >
                  {opt}
                </motion.button>
              ))}
            </div>
          ) : (
            <div className="flex gap-3 flex-wrap">
              <button
                type="button"
                disabled={!!feedback}
                onClick={() => checkTf(true, q.correct)}
                className="kids-btn-primary flex-1 min-h-[52px]"
              >
                {t("gk.tf.true")}
              </button>
              <button
                type="button"
                disabled={!!feedback}
                onClick={() => checkTf(false, q.correct)}
                className="kids-btn-secondary flex-1 min-h-[52px]"
              >
                {t("gk.tf.false")}
              </button>
            </div>
          )}
          <AnimatePresence mode="wait">
            {feedback && (
              <motion.div
                key={feedback}
                initial={{ opacity: 0, y: 6 }}
                animate={{ opacity: 1, y: 0 }}
                className={cn(
                  "mt-4 rounded-2xl py-3 px-4 font-bold text-center",
                  feedback === "ok" ? "bg-kids-mint/40" : "bg-kids-yellow/40",
                )}
              >
                {feedback === "ok" ? (
                  <>
                    <p className="mb-3">{t("gk.nice")}</p>
                    <button type="button" onClick={next} className="kids-btn-primary">
                      {t("gk.next")}
                    </button>
                  </>
                ) : (
                  <>
                    <p className="mb-3">{q.wrongHint}</p>
                    <button type="button" onClick={() => setFeedback(null)} className="kids-btn-secondary">
                      {t("gk.tryagain")}
                    </button>
                  </>
                )}
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      )}
    </div>
  );
};

export default GeneralKnowledge;
