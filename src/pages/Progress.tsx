import { motion } from "framer-motion";
import { Trophy, Clock, BookOpen, Gamepad2, Award } from "lucide-react";
import { useApp } from "@/context/AppContext";

const Progress = () => {
  const { usage } = useApp();

  const stats = [
    { icon: Clock, label: "Time Today", value: `${usage.totalMinutesToday} min`, color: "bg-kids-blue" },
    { icon: BookOpen, label: "Lessons Done", value: usage.lessonsCompleted.length, color: "bg-kids-mint" },
    { icon: Gamepad2, label: "Games Played", value: usage.gamesPlayed, color: "bg-kids-lavender" },
    { icon: Trophy, label: "Badges", value: usage.badges.length, color: "bg-kids-peach" },
  ];

  const allBadges = [
    { id: "alphabets-master", label: "ABC Master", emoji: "🔤" },
    { id: "numbers-master", label: "Number Ninja", emoji: "🔢" },
    { id: "shapes-master", label: "Shape Explorer", emoji: "🎨" },
    { id: "memory-champion", label: "Memory Champ", emoji: "🧠" },
  ];

  return (
    <div className="page-container">
      <h1 className="kids-heading text-2xl mb-6">📊 My Progress</h1>

      {/* Stats Grid */}
      <div className="grid grid-cols-2 gap-4 mb-8">
        {stats.map((s, i) => (
          <motion.div
            key={s.label}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.1 }}
            className="kids-card text-center"
          >
            <div className={`w-12 h-12 ${s.color} rounded-xl flex items-center justify-center mx-auto mb-2`}>
              <s.icon size={24} />
            </div>
            <p className="text-2xl font-black">{s.value}</p>
            <p className="text-sm text-muted-foreground font-semibold">{s.label}</p>
          </motion.div>
        ))}
      </div>

      {/* Badges */}
      <h2 className="kids-heading text-xl mb-4">🏅 My Badges</h2>
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
        {allBadges.map((badge) => {
          const earned = usage.badges.includes(badge.id);
          return (
            <motion.div
              key={badge.id}
              whileHover={{ scale: 1.05 }}
              className={`kids-card text-center ${earned ? "" : "opacity-40 grayscale"}`}
            >
              <span className="text-4xl block mb-2">{badge.emoji}</span>
              <p className="text-sm font-bold">{badge.label}</p>
              {earned && (
                <div className="flex items-center justify-center gap-1 mt-1">
                  <Award size={14} className="text-kids-yellow" />
                  <span className="text-xs text-muted-foreground">Earned!</span>
                </div>
              )}
            </motion.div>
          );
        })}
      </div>

      {/* Encouragement */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.5 }}
        className="kids-card bg-kids-mint/30 text-center mt-8"
      >
        <p className="font-bold text-lg">You're doing great! Keep it up! 🌟</p>
        <p className="text-sm text-muted-foreground">Every step forward counts!</p>
      </motion.div>
    </div>
  );
};

export default Progress;
