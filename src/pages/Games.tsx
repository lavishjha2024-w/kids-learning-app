import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import { RotateCcw, ArrowLeft } from "lucide-react";
import { useApp } from "@/context/AppContext";

const emojis = ["🐶", "🐱", "🐸", "🦋", "🌸", "🌈", "⭐", "🎵"];

interface Card {
  id: number;
  emoji: string;
  flipped: boolean;
  matched: boolean;
}

const createCards = (): Card[] => {
  const pairs = [...emojis, ...emojis];
  return pairs
    .sort(() => Math.random() - 0.5)
    .map((emoji, i) => ({ id: i, emoji, flipped: false, matched: false }));
};

const Games = () => {
  const { incrementGames, addBadge } = useApp();
  const [playing, setPlaying] = useState(false);
  const [cards, setCards] = useState<Card[]>([]);
  const [selected, setSelected] = useState<number[]>([]);
  const [moves, setMoves] = useState(0);
  const [won, setWon] = useState(false);

  const startGame = () => {
    setCards(createCards());
    setSelected([]);
    setMoves(0);
    setWon(false);
    setPlaying(true);
  };

  useEffect(() => {
    if (selected.length === 2) {
      const [a, b] = selected;
      setMoves((m) => m + 1);

      if (cards[a].emoji === cards[b].emoji) {
        setTimeout(() => {
          setCards((prev) =>
            prev.map((c) => (c.id === a || c.id === b ? { ...c, matched: true } : c))
          );
          setSelected([]);
        }, 400);
      } else {
        setTimeout(() => {
          setCards((prev) =>
            prev.map((c) => (c.id === a || c.id === b ? { ...c, flipped: false } : c))
          );
          setSelected([]);
        }, 800);
      }
    }
  }, [selected, cards]);

  useEffect(() => {
    if (playing && cards.length > 0 && cards.every((c) => c.matched)) {
      setWon(true);
      incrementGames();
      addBadge("memory-champion");
    }
  }, [cards, playing, incrementGames, addBadge]);

  const handleFlip = (id: number) => {
    if (selected.length >= 2) return;
    if (cards[id].flipped || cards[id].matched) return;

    setCards((prev) => prev.map((c) => (c.id === id ? { ...c, flipped: true } : c)));
    setSelected((prev) => [...prev, id]);
  };

  if (!playing) {
    return (
      <div className="page-container text-center">
        <h1 className="kids-heading text-2xl mb-2">🎮 Games</h1>
        <p className="text-muted-foreground mb-8">Fun games that help you learn!</p>

        <motion.button
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          onClick={startGame}
          className="kids-card-interactive max-w-sm mx-auto text-center"
        >
          <span className="text-5xl block mb-3">🧠</span>
          <h3 className="font-bold text-lg">Memory Match</h3>
          <p className="text-sm text-muted-foreground">Find matching pairs!</p>
        </motion.button>
      </div>
    );
  }

  return (
    <div className="page-container">
      <div className="flex items-center justify-between mb-6">
        <button onClick={() => setPlaying(false)} className="flex items-center gap-2 text-muted-foreground font-semibold">
          <ArrowLeft size={20} /> Back
        </button>
        <span className="font-bold">Moves: {moves}</span>
        <button onClick={startGame} className="kids-btn-secondary text-sm !px-4 !py-2 !min-h-0">
          <RotateCcw size={16} /> New Game
        </button>
      </div>

      {won ? (
        <motion.div
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          className="text-center py-12"
        >
          <span className="text-6xl block mb-4">🎉</span>
          <h2 className="kids-heading text-2xl mb-2">You Did It!</h2>
          <p className="text-muted-foreground mb-4">Completed in {moves} moves! Great job! 🌟</p>
          <button onClick={startGame} className="kids-btn-primary">Play Again 🔄</button>
        </motion.div>
      ) : (
        <div className="grid grid-cols-4 gap-3 max-w-sm mx-auto">
          {cards.map((card) => (
            <motion.button
              key={card.id}
              whileTap={{ scale: 0.95 }}
              onClick={() => handleFlip(card.id)}
              className={`aspect-square rounded-2xl text-3xl flex items-center justify-center font-bold transition-all duration-300 min-h-[56px] ${
                card.flipped || card.matched
                  ? "bg-kids-mint"
                  : "bg-kids-lavender hover:bg-kids-lavender/80"
              } ${card.matched ? "opacity-60" : ""}`}
              aria-label={card.flipped || card.matched ? card.emoji : "Hidden card"}
            >
              {card.flipped || card.matched ? card.emoji : "?"}
            </motion.button>
          ))}
        </div>
      )}
    </div>
  );
};

export default Games;
