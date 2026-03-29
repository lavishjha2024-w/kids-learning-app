import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { BookOpen, Gamepad2, BarChart3, Sparkles, Flame, Globe, Pencil } from "lucide-react";
import mascot from "@/assets/mascot.png";
import heroBg from "@/assets/hero-bg.jpg";
import MoodCheck from "@/components/MoodCheck";
import { useApp } from "@/context/AppContext";
import { useI18n } from "@/context/I18nContext";
import { CandyCount } from "@/features/candy/CandyCount";

const features = [
  { icon: BookOpen, labelKey: "home.card.learn", descKey: "home.card.learn.desc", path: "/learn", color: "bg-kids-blue" },
  { icon: Gamepad2, labelKey: "home.card.play", descKey: "home.card.play.desc", path: "/games", color: "bg-kids-mint" },
  { icon: BarChart3, labelKey: "home.card.progress", descKey: "home.card.progress.desc", path: "/progress", color: "bg-kids-lavender" },
  { icon: Globe, labelKey: "home.card.gk", descKey: "home.card.gk.desc", path: "/gk", color: "bg-kids-peach" },
  { icon: Pencil, labelKey: "home.card.scribble", descKey: "home.card.scribble.desc", path: "/scribble", color: "bg-kids-yellow" },
];

const Index = () => {
  const navigate = useNavigate();
  const { usage } = useApp();
  const { t } = useI18n();

  const [moodDone, setMoodDone] = useState(() => {
    const last = localStorage.getItem("kids-mood-date");
    return last === new Date().toDateString();
  });

  const handleMoodComplete = () => {
    localStorage.setItem("kids-mood-date", new Date().toDateString());
    setMoodDone(true);
  };

  return (
    <div className="page-container">
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="relative rounded-[2rem] overflow-hidden mb-8 border border-border/50 shadow-soft"
      >
        <img src={heroBg} alt="" className="w-full h-52 sm:h-64 object-cover opacity-95" />
        <div className="absolute inset-0 bg-gradient-to-t from-background/85 via-background/20 to-transparent" />
        <div className="absolute inset-0 flex flex-col items-center justify-end pb-8 pt-6 px-4 text-center">
          <motion.img
            src={mascot}
            alt="Owly the learning owl"
            width={112}
            height={112}
            className="mx-auto mb-2 drop-shadow-md"
            animate={{ y: [0, -8, 0] }}
            transition={{ duration: 2.4, repeat: Infinity, ease: "easeInOut" }}
          />
          <h1 className="kids-heading text-3xl sm:text-5xl text-foreground drop-shadow-sm">
            {t("home.hero")} <Sparkles className="inline w-7 h-7 text-kids-yellow" aria-hidden />
          </h1>
          <p className="text-muted-foreground font-bold mt-2 max-w-md text-balance">{t("home.sub")}</p>

          <motion.div
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.15 }}
            className="flex flex-wrap justify-center gap-3 mt-6"
          >
            <div className="flex items-center gap-2 rounded-2xl bg-card/90 backdrop-blur px-4 py-2 border border-border/50 shadow-soft">
              <span className="text-lg" aria-hidden>
                🍬
              </span>
              <CandyCount count={usage.candies} className="font-black text-sm" />
            </div>
            <div className="flex items-center gap-2 rounded-2xl bg-card/90 backdrop-blur px-4 py-2 border border-border/50 shadow-soft">
              <Flame className="text-orange-500" size={20} aria-hidden />
              <span className="font-black text-sm">{t("home.streak", { n: usage.streak })}</span>
            </div>
          </motion.div>
        </div>
      </motion.div>

      {!moodDone && (
        <div className="mb-8">
          <MoodCheck onComplete={handleMoodComplete} />
        </div>
      )}

      <h2 className="sr-only">{t("home.sr.go")}</h2>
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-8">
        {features.map((f, i) => (
          <motion.button
            key={f.labelKey}
            type="button"
            initial={{ opacity: 0, y: 18 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.08 + i * 0.07 }}
            onClick={() => navigate(f.path)}
            className="kids-card-interactive text-left border border-border/50"
          >
            <div className={`w-14 h-14 ${f.color} rounded-2xl flex items-center justify-center mb-3 shadow-soft`}>
              <f.icon size={28} className="text-foreground" aria-hidden />
            </div>
            <h3 className="font-black text-xl">{t(f.labelKey)}</h3>
            <p className="text-sm text-muted-foreground font-semibold">{t(f.descKey)}</p>
          </motion.button>
        ))}
      </div>

      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.35 }}
        className="kids-card bg-kids-mint/25 text-center border border-border/40"
      >
        <p className="font-bold text-lg">{t("home.water")}</p>
        <p className="text-sm text-muted-foreground font-semibold mt-1">{t("home.pace")}</p>
      </motion.div>
    </div>
  );
};

export default Index;
