import { motion } from "framer-motion";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { cn } from "@/lib/utils";
import { useI18n } from "@/context/I18nContext";
import MemoryMatchGame from "@/components/games/MemoryMatchGame";
import DragMatchGame from "@/components/games/DragMatchGame";
import PicturePuzzleGame from "@/components/games/PicturePuzzleGame";
import QuizGame from "@/components/games/QuizGame";
import PatternGame from "@/components/games/PatternGame";
import SpellGame from "@/components/games/SpellGame";

const gameTabs = [
  { id: "memory", emoji: "🃏" },
  { id: "match", emoji: "🍎" },
  { id: "puzzle", emoji: "🧩" },
  { id: "quiz", emoji: "❓" },
  { id: "pattern", emoji: "🔁" },
  { id: "spell", emoji: "✏️" },
] as const;

const Games = () => {
  const { t } = useI18n();
  return (
    <div className="page-container">
      <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} className="mb-6">
        <h1 className="kids-heading text-3xl sm:text-4xl mb-1">{t("games.title")}</h1>
        <p className="text-muted-foreground font-semibold text-balance">{t("games.sub")}</p>
      </motion.div>

      <Tabs defaultValue="memory" className="w-full">
        <TabsList
          className={cn(
            "w-full h-auto flex flex-wrap justify-start gap-2 rounded-2xl bg-muted/80 p-2 mb-6 border border-border/60",
          )}
        >
          {gameTabs.map((tab) => (
            <TabsTrigger
              key={tab.id}
              value={tab.id}
              className="rounded-xl px-4 py-3 text-sm sm:text-base font-bold data-[state=active]:shadow-soft data-[state=active]:bg-card gap-1.5 min-h-[48px]"
            >
              <span aria-hidden>{tab.emoji}</span>
              {t(`games.tab.${tab.id}`)}
            </TabsTrigger>
          ))}
        </TabsList>

        <TabsContent value="memory" className="mt-0 focus-visible:outline-none">
          <motion.section
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="kids-card border border-border/40"
            aria-labelledby="game-memory-title"
          >
            <h2 id="game-memory-title" className="sr-only">
              {t("games.sr.memory")}
            </h2>
            <MemoryMatchGame />
          </motion.section>
        </TabsContent>
        <TabsContent value="match" className="mt-0 focus-visible:outline-none">
          <motion.section initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="kids-card border border-border/40">
            <h2 className="sr-only">{t("games.sr.match")}</h2>
            <DragMatchGame />
          </motion.section>
        </TabsContent>
        <TabsContent value="puzzle" className="mt-0 focus-visible:outline-none">
          <motion.section initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="kids-card border border-border/40">
            <h2 className="sr-only">{t("games.sr.puzzle")}</h2>
            <PicturePuzzleGame />
          </motion.section>
        </TabsContent>
        <TabsContent value="quiz" className="mt-0 focus-visible:outline-none">
          <motion.section initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="kids-card border border-border/40">
            <h2 className="sr-only">{t("games.sr.quiz")}</h2>
            <QuizGame />
          </motion.section>
        </TabsContent>
        <TabsContent value="pattern" className="mt-0 focus-visible:outline-none">
          <motion.section initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="kids-card border border-border/40">
            <h2 className="sr-only">{t("games.sr.pattern")}</h2>
            <PatternGame />
          </motion.section>
        </TabsContent>
        <TabsContent value="spell" className="mt-0 focus-visible:outline-none">
          <motion.section initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="kids-card border border-border/40">
            <h2 className="sr-only">{t("games.sr.spell")}</h2>
            <SpellGame />
          </motion.section>
        </TabsContent>
      </Tabs>
    </div>
  );
};

export default Games;
