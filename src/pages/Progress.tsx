import { motion } from "framer-motion";
import {
  Trophy,
  Clock,
  BookOpen,
  Gamepad2,
  Award,
  Flame,
  Sparkles,
} from "lucide-react";
import { useApp } from "@/context/AppContext";
import { useI18n } from "@/context/I18nContext";
import { BADGE_CATALOG } from "@/lib/badges";
import { CANDY_MILESTONE, getCandyProgressPercent, getCandyInCurrentMilestone } from "@/lib/gamification";
import { Progress as UiProgress } from "@/components/ui/progress";
import { CandyCount } from "@/features/candy/CandyCount";

const ProgressPage = () => {
  const { usage } = useApp();
  const { t } = useI18n();
  const trackedPlays = Object.values(usage.gameStats).reduce((n, s) => n + s.played, 0);
  const gamesLabel = trackedPlays || usage.gamesPlayed;
  const cur = getCandyInCurrentMilestone(usage.candies);

  const stats = [
    { icon: Clock, labelKey: "progress.stat.time", value: `${usage.totalMinutesToday} ${t("common.min")}`, color: "bg-kids-blue" },
    { icon: BookOpen, labelKey: "progress.stat.topics", value: usage.lessonsCompleted.length, color: "bg-kids-mint" },
    { icon: Gamepad2, labelKey: "progress.stat.games", value: gamesLabel, color: "bg-kids-lavender" },
    { icon: Trophy, labelKey: "progress.stat.badges", value: usage.badges.length, color: "bg-kids-peach" },
  ];

  return (
    <div className="page-container">
      <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="mb-8">
        <h1 className="kids-heading text-3xl sm:text-4xl mb-2">{t("progress.title")}</h1>
        <p className="text-muted-foreground font-semibold">{t("progress.sub")}</p>
      </motion.div>

      <motion.section
        initial={{ opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.05 }}
        className="kids-card mb-8 bg-gradient-to-br from-primary/25 via-card to-secondary/20 border border-border/60"
      >
        <div className="flex flex-wrap items-end justify-between gap-4 mb-3">
          <div>
            <p className="text-xs font-bold uppercase tracking-wide text-muted-foreground flex items-center gap-1">
              <Sparkles size={14} aria-hidden /> {t("candy.title")}
            </p>
            <p className="kids-heading text-2xl flex items-center gap-2">
              <span aria-hidden>🍬</span>
              <CandyCount count={usage.candies} />
            </p>
            <p className="text-sm font-semibold text-muted-foreground mt-1">{t("candy.collect")}</p>
          </div>
          <div className="flex items-center gap-2 rounded-2xl bg-kids-yellow/35 px-4 py-2 font-black text-lg">
            <Flame className="text-orange-500" size={22} aria-hidden />
            {usage.streak}
          </div>
        </div>
        <div className="mb-2 flex justify-between text-sm font-bold text-muted-foreground">
          <span>{t("candy.barLabel")}</span>
          <span className="tabular-nums">{t("candy.milestone", { cur, max: CANDY_MILESTONE })}</span>
        </div>
        <UiProgress value={getCandyProgressPercent(usage.candies)} className="h-4 rounded-full" />
      </motion.section>

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-10">
        {stats.map((s, i) => (
          <motion.div
            key={s.labelKey}
            initial={{ opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.08 + i * 0.05 }}
            className="kids-card text-center border border-border/40"
          >
            <div className={`w-12 h-12 ${s.color} rounded-2xl flex items-center justify-center mx-auto mb-2 shadow-soft`}>
              <s.icon size={24} className="text-foreground" />
            </div>
            <p className="text-3xl font-black tabular-nums">{s.value}</p>
            <p className="text-xs text-muted-foreground font-bold">{t(s.labelKey)}</p>
          </motion.div>
        ))}
      </div>

      <h2 className="kids-heading text-xl mb-4 flex items-center gap-2">
        <Award size={22} aria-hidden /> {t("progress.badges")}
      </h2>
      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3">
        {BADGE_CATALOG.map((badge) => {
          const earned = usage.badges.includes(badge.id);
          return (
            <motion.div
              key={badge.id}
              whileHover={{ y: -3 }}
              className={`kids-card text-center border transition-all ${
                earned ? "border-kids-mint shadow-soft" : "border-border/30 opacity-45 grayscale"
              }`}
            >
              <span className="text-4xl block mb-2" aria-hidden>
                {badge.emoji}
              </span>
              <p className="text-sm font-black leading-tight">{badge.label}</p>
              <p className="text-xs text-muted-foreground mt-1 font-semibold line-clamp-2">{badge.description}</p>
              {earned && (
                <span className="inline-flex items-center gap-1 mt-2 text-xs font-bold text-kids-mint">
                  <Trophy size={12} aria-hidden /> {t("progress.unlocked")}
                </span>
              )}
            </motion.div>
          );
        })}
      </div>

      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.3 }}
        className="kids-card bg-kids-mint/25 text-center mt-10 border border-border/40"
      >
        <p className="font-black text-lg">{t("progress.footer1")}</p>
        <p className="text-sm text-muted-foreground font-semibold">{t("progress.footer2")}</p>
      </motion.div>
    </div>
  );
};

export default ProgressPage;
