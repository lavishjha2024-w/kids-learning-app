import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { ArrowLeft, Volume2, ChevronLeft, ChevronRight, Star } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useApp } from "@/context/AppContext";

type Module = "alphabets" | "numbers" | "shapes" | null;

const alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
const numbers = Array.from({ length: 10 }, (_, i) => i);
const shapes = [
  { name: "Circle", emoji: "🔵", color: "bg-kids-blue" },
  { name: "Square", emoji: "🟧", color: "bg-kids-peach" },
  { name: "Triangle", emoji: "🔺", color: "bg-kids-pink" },
  { name: "Star", emoji: "⭐", color: "bg-kids-yellow" },
  { name: "Heart", emoji: "❤️", color: "bg-kids-pink" },
  { name: "Diamond", emoji: "💎", color: "bg-kids-lavender" },
];

const modules = [
  { id: "alphabets" as Module, title: "Alphabets", emoji: "🔤", color: "bg-kids-blue", desc: "Learn A to Z" },
  { id: "numbers" as Module, title: "Numbers", emoji: "🔢", color: "bg-kids-mint", desc: "Count 0 to 9" },
  { id: "shapes" as Module, title: "Shapes & Colors", emoji: "🎨", color: "bg-kids-lavender", desc: "Discover shapes" },
];

const speak = (text: string) => {
  const u = new SpeechSynthesisUtterance(text);
  u.rate = 0.8;
  u.pitch = 1.2;
  speechSynthesis.speak(u);
};

const Learn = () => {
  const navigate = useNavigate();
  const { completeLesson, addBadge, settings } = useApp();
  const [activeModule, setActiveModule] = useState<Module>(null);
  const [currentIndex, setCurrentIndex] = useState(0);

  const encouragements = ["Great job! 🌟", "You're amazing! ✨", "Wonderful! 🎉", "Keep going! 💪", "Nice try! 👏"];
  const randomEncouragement = () => encouragements[Math.floor(Math.random() * encouragements.length)];

  const handleNext = (total: number) => {
    if (currentIndex < total - 1) {
      setCurrentIndex(currentIndex + 1);
    } else {
      completeLesson(activeModule!);
      addBadge(`${activeModule}-master`);
      setActiveModule(null);
      setCurrentIndex(0);
    }
  };

  const handlePrev = () => {
    if (currentIndex > 0) setCurrentIndex(currentIndex - 1);
  };

  if (!activeModule) {
    return (
      <div className="page-container">
        <h1 className="kids-heading text-2xl mb-6">📚 Learning Modules</h1>
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          {modules.map((m, i) => (
            <motion.button
              key={m.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.1 }}
              onClick={() => { setActiveModule(m.id); setCurrentIndex(0); }}
              className="kids-card-interactive text-center"
            >
              <span className="text-5xl block mb-3">{m.emoji}</span>
              <h3 className="font-bold text-lg">{m.title}</h3>
              <p className="text-sm text-muted-foreground">{m.desc}</p>
            </motion.button>
          ))}
        </div>
      </div>
    );
  }

  const renderContent = () => {
    if (activeModule === "alphabets") {
      const letter = alphabets[currentIndex];
      return (
        <div className="text-center">
          <motion.div
            key={currentIndex}
            initial={{ scale: 0.5, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            className="w-40 h-40 mx-auto bg-kids-blue rounded-3xl flex items-center justify-center mb-4"
          >
            <span className="text-7xl font-black text-foreground">{letter}</span>
          </motion.div>
          <p className="text-xl font-bold mb-2">Letter {letter}</p>
          <button onClick={() => speak(`${letter}. ${letter} for ${letter === "A" ? "Apple" : letter}`)} className="kids-btn-primary">
            <Volume2 size={20} /> Hear it
          </button>
        </div>
      );
    }

    if (activeModule === "numbers") {
      const num = numbers[currentIndex];
      return (
        <div className="text-center">
          <motion.div
            key={currentIndex}
            initial={{ scale: 0.5, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            className="w-40 h-40 mx-auto bg-kids-mint rounded-3xl flex items-center justify-center mb-4"
          >
            <span className="text-7xl font-black text-foreground">{num}</span>
          </motion.div>
          <p className="text-xl font-bold mb-2">Number {num}</p>
          <div className="flex justify-center gap-1 mb-3">
            {Array.from({ length: num }, (_, i) => (
              <Star key={i} size={24} className="text-kids-yellow fill-kids-yellow" />
            ))}
          </div>
          <button onClick={() => speak(`${num}`)} className="kids-btn-secondary">
            <Volume2 size={20} /> Hear it
          </button>
        </div>
      );
    }

    if (activeModule === "shapes") {
      const shape = shapes[currentIndex];
      return (
        <div className="text-center">
          <motion.div
            key={currentIndex}
            initial={{ rotate: -10, opacity: 0 }}
            animate={{ rotate: 0, opacity: 1 }}
            className={`w-40 h-40 mx-auto ${shape.color} rounded-3xl flex items-center justify-center mb-4`}
          >
            <span className="text-7xl">{shape.emoji}</span>
          </motion.div>
          <p className="text-xl font-bold mb-2">{shape.name}</p>
          <button onClick={() => speak(shape.name)} className="kids-btn-accent">
            <Volume2 size={20} /> Hear it
          </button>
        </div>
      );
    }
  };

  const total = activeModule === "alphabets" ? 26 : activeModule === "numbers" ? 10 : shapes.length;

  return (
    <div className="page-container">
      <button onClick={() => setActiveModule(null)} className="flex items-center gap-2 text-muted-foreground mb-6 font-semibold">
        <ArrowLeft size={20} /> Back to Modules
      </button>

      <AnimatePresence mode="wait">
        {renderContent()}
      </AnimatePresence>

      {/* Navigation */}
      <div className="flex items-center justify-center gap-4 mt-8">
        <button onClick={handlePrev} disabled={currentIndex === 0} className="kids-btn-primary disabled:opacity-30">
          <ChevronLeft size={24} />
        </button>
        <span className="font-bold text-lg">{currentIndex + 1} / {total}</span>
        <button onClick={() => handleNext(total)} className="kids-btn-primary">
          {currentIndex === total - 1 ? "🎉 Done!" : <ChevronRight size={24} />}
        </button>
      </div>

      {/* Encouragement */}
      <motion.p
        key={currentIndex}
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        className="text-center mt-4 text-muted-foreground font-semibold"
      >
        {randomEncouragement()}
      </motion.p>
    </div>
  );
};

export default Learn;
