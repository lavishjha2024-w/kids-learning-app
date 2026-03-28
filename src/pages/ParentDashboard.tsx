import { motion } from "framer-motion";
import { ArrowLeft, Clock, BookOpen, Gamepad2, Shield } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useApp } from "@/context/AppContext";
import { useEffect } from "react";

const ParentDashboard = () => {
  const navigate = useNavigate();
  const { usage, settings, updateSettings, parentPinVerified } = useApp();

  useEffect(() => {
    if (!parentPinVerified) navigate("/settings");
  }, [parentPinVerified, navigate]);

  if (!parentPinVerified) return null;

  return (
    <div className="page-container">
      <button onClick={() => navigate("/settings")} className="flex items-center gap-2 text-muted-foreground mb-6 font-semibold">
        <ArrowLeft size={20} /> Back to Settings
      </button>

      <h1 className="kids-heading text-2xl mb-6">
        <Shield className="inline mr-2" size={24} /> Parent Dashboard
      </h1>

      {/* Usage Stats */}
      <div className="grid grid-cols-3 gap-3 mb-8">
        <div className="kids-card text-center">
          <Clock size={24} className="mx-auto mb-1 text-muted-foreground" />
          <p className="text-xl font-black">{usage.totalMinutesToday}m</p>
          <p className="text-xs text-muted-foreground">Today</p>
        </div>
        <div className="kids-card text-center">
          <BookOpen size={24} className="mx-auto mb-1 text-muted-foreground" />
          <p className="text-xl font-black">{usage.lessonsCompleted.length}</p>
          <p className="text-xs text-muted-foreground">Lessons</p>
        </div>
        <div className="kids-card text-center">
          <Gamepad2 size={24} className="mx-auto mb-1 text-muted-foreground" />
          <p className="text-xl font-black">{usage.gamesPlayed}</p>
          <p className="text-xs text-muted-foreground">Games</p>
        </div>
      </div>

      {/* Controls */}
      <h2 className="font-bold text-lg mb-3">Controls</h2>
      <div className="space-y-3">
        <div className="kids-card">
          <label className="font-bold block mb-2">Max Screen Time (minutes)</label>
          <input
            type="range"
            min={15}
            max={120}
            step={15}
            value={settings.maxScreenTime}
            onChange={(e) => updateSettings({ maxScreenTime: Number(e.target.value) })}
            className="w-full accent-primary"
          />
          <p className="text-sm text-muted-foreground mt-1">{settings.maxScreenTime} minutes</p>
        </div>

        <div className="kids-card">
          <label className="font-bold block mb-2">Break Duration (minutes)</label>
          <input
            type="range"
            min={1}
            max={15}
            step={1}
            value={settings.breakDuration}
            onChange={(e) => updateSettings({ breakDuration: Number(e.target.value) })}
            className="w-full accent-primary"
          />
          <p className="text-sm text-muted-foreground mt-1">{settings.breakDuration} minutes</p>
        </div>
      </div>
    </div>
  );
};

export default ParentDashboard;
