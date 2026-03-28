import React, { createContext, useContext, useState, useEffect, useCallback } from "react";

interface UsageData {
  totalMinutesToday: number;
  sessionStart: number;
  lastActive: string;
  lessonsCompleted: string[];
  badges: string[];
  gamesPlayed: number;
}

interface AppSettings {
  calmMode: boolean;
  breakDuration: number; // minutes
  maxScreenTime: number; // minutes
  soundEnabled: boolean;
  musicEnabled: boolean;
  fontSize: "normal" | "large" | "xlarge";
  colorblindMode: boolean;
}

interface AppContextType {
  usage: UsageData;
  settings: AppSettings;
  showBreakReminder: boolean;
  setShowBreakReminder: (v: boolean) => void;
  updateSettings: (s: Partial<AppSettings>) => void;
  completeLesson: (id: string) => void;
  addBadge: (badge: string) => void;
  incrementGames: () => void;
  parentPinVerified: boolean;
  verifyParentPin: (pin: string) => boolean;
  setParentPin: (pin: string) => void;
}

const defaultUsage: UsageData = {
  totalMinutesToday: 0,
  sessionStart: Date.now(),
  lastActive: new Date().toDateString(),
  lessonsCompleted: [],
  badges: [],
  gamesPlayed: 0,
};

const defaultSettings: AppSettings = {
  calmMode: false,
  breakDuration: 5,
  maxScreenTime: 60,
  soundEnabled: true,
  musicEnabled: false,
  fontSize: "normal",
  colorblindMode: false,
};

const AppContext = createContext<AppContextType | null>(null);

export const useApp = () => {
  const ctx = useContext(AppContext);
  if (!ctx) throw new Error("useApp must be inside AppProvider");
  return ctx;
};

export const AppProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [usage, setUsage] = useState<UsageData>(() => {
    const saved = localStorage.getItem("kids-usage");
    if (saved) {
      const parsed = JSON.parse(saved);
      // Reset if new day
      if (parsed.lastActive !== new Date().toDateString()) {
        return { ...defaultUsage, lessonsCompleted: parsed.lessonsCompleted, badges: parsed.badges };
      }
      return { ...parsed, sessionStart: Date.now() };
    }
    return defaultUsage;
  });

  const [settings, setSettings] = useState<AppSettings>(() => {
    const saved = localStorage.getItem("kids-settings");
    return saved ? JSON.parse(saved) : defaultSettings;
  });

  const [showBreakReminder, setShowBreakReminder] = useState(false);
  const [parentPinVerified, setParentPinVerified] = useState(false);

  // Track usage time
  useEffect(() => {
    const interval = setInterval(() => {
      setUsage((prev) => {
        const updated = { ...prev, totalMinutesToday: prev.totalMinutesToday + 1 };
        localStorage.setItem("kids-usage", JSON.stringify(updated));
        
        // Check for break reminder every 30 minutes
        if (updated.totalMinutesToday > 0 && updated.totalMinutesToday % 30 === 0) {
          setShowBreakReminder(true);
        }
        return updated;
      });
    }, 60000); // every minute

    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    localStorage.setItem("kids-settings", JSON.stringify(settings));
  }, [settings]);

  // Apply calm mode class
  useEffect(() => {
    document.documentElement.classList.toggle("calm-mode", settings.calmMode);
  }, [settings.calmMode]);

  // Apply font size
  useEffect(() => {
    const sizes = { normal: "16px", large: "18px", xlarge: "20px" };
    document.documentElement.style.fontSize = sizes[settings.fontSize];
  }, [settings.fontSize]);

  const updateSettings = useCallback((s: Partial<AppSettings>) => {
    setSettings((prev) => ({ ...prev, ...s }));
  }, []);

  const completeLesson = useCallback((id: string) => {
    setUsage((prev) => {
      if (prev.lessonsCompleted.includes(id)) return prev;
      const updated = { ...prev, lessonsCompleted: [...prev.lessonsCompleted, id] };
      localStorage.setItem("kids-usage", JSON.stringify(updated));
      return updated;
    });
  }, []);

  const addBadge = useCallback((badge: string) => {
    setUsage((prev) => {
      if (prev.badges.includes(badge)) return prev;
      const updated = { ...prev, badges: [...prev.badges, badge] };
      localStorage.setItem("kids-usage", JSON.stringify(updated));
      return updated;
    });
  }, []);

  const incrementGames = useCallback(() => {
    setUsage((prev) => {
      const updated = { ...prev, gamesPlayed: prev.gamesPlayed + 1 };
      localStorage.setItem("kids-usage", JSON.stringify(updated));
      return updated;
    });
  }, []);

  const verifyParentPin = (pin: string) => {
    const stored = localStorage.getItem("kids-parent-pin") || "1234";
    const ok = pin === stored;
    if (ok) setParentPinVerified(true);
    return ok;
  };

  const setParentPin = (pin: string) => {
    localStorage.setItem("kids-parent-pin", pin);
  };

  return (
    <AppContext.Provider
      value={{
        usage,
        settings,
        showBreakReminder,
        setShowBreakReminder,
        updateSettings,
        completeLesson,
        addBadge,
        incrementGames,
        parentPinVerified,
        verifyParentPin,
        setParentPin,
      }}
    >
      {children}
    </AppContext.Provider>
  );
};
