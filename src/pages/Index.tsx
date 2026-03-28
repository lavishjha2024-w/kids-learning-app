import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { BookOpen, Gamepad2, BarChart3, Sparkles } from "lucide-react";
import mascot from "@/assets/mascot.png";
import heroBg from "@/assets/hero-bg.jpg";
import MoodCheck from "@/components/MoodCheck";

const features = [
  { icon: BookOpen, label: "Learn", desc: "ABCs, Numbers & More", path: "/learn", color: "bg-kids-blue" },
  { icon: Gamepad2, label: "Play Games", desc: "Fun Memory Games", path: "/games", color: "bg-kids-mint" },
  { icon: BarChart3, label: "My Progress", desc: "See How You're Doing", path: "/progress", color: "bg-kids-lavender" },
];

const Index = () => {
  const navigate = useNavigate();
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
      {/* Hero */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="relative rounded-3xl overflow-hidden mb-8"
      >
        <img src={heroBg} alt="" className="w-full h-48 sm:h-64 object-cover" />
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="text-center">
            <motion.img
              src={mascot}
              alt="Owly the learning owl"
              width={100}
              height={100}
              className="mx-auto mb-2"
              animate={{ y: [0, -6, 0] }}
              transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
            />
            <h1 className="kids-heading text-3xl sm:text-4xl text-foreground drop-shadow-sm">
              Hi there! <Sparkles className="inline w-6 h-6 text-kids-yellow" />
            </h1>
            <p className="text-muted-foreground font-semibold mt-1">
              Ready to learn something new today?
            </p>
          </div>
        </div>
      </motion.div>

      {/* Mood Check */}
      {!moodDone && (
        <div className="mb-8">
          <MoodCheck onComplete={handleMoodComplete} />
        </div>
      )}

      {/* Feature Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-8">
        {features.map((f, i) => (
          <motion.button
            key={f.label}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.1 }}
            onClick={() => navigate(f.path)}
            className="kids-card-interactive text-left"
          >
            <div className={`w-14 h-14 ${f.color} rounded-2xl flex items-center justify-center mb-3`}>
              <f.icon size={28} className="text-foreground" />
            </div>
            <h3 className="font-bold text-lg">{f.label}</h3>
            <p className="text-sm text-muted-foreground">{f.desc}</p>
          </motion.button>
        ))}
      </div>

      {/* Healthy Reminder */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.4 }}
        className="kids-card bg-kids-yellow/30 text-center"
      >
        <p className="font-semibold">💧 Remember to drink some water! 💧</p>
      </motion.div>
    </div>
  );
};

export default Index;
