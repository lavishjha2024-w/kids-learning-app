import { useState } from "react";
import { motion } from "framer-motion";
import { Moon, Volume2, Eye, Type, Lock, Shield } from "lucide-react";
import { useApp } from "@/context/AppContext";
import { useNavigate } from "react-router-dom";

const Settings = () => {
  const { settings, updateSettings, parentPinVerified, verifyParentPin } = useApp();
  const [pinInput, setPinInput] = useState("");
  const [pinError, setPinError] = useState(false);
  const navigate = useNavigate();

  const handlePinSubmit = () => {
    if (verifyParentPin(pinInput)) {
      setPinError(false);
    } else {
      setPinError(true);
    }
    setPinInput("");
  };

  const Toggle = ({ enabled, onToggle, label, icon: Icon }: { enabled: boolean; onToggle: () => void; label: string; icon: any }) => (
    <button
      onClick={onToggle}
      className="kids-card flex items-center justify-between w-full"
      role="switch"
      aria-checked={enabled}
    >
      <div className="flex items-center gap-3">
        <div className={`w-10 h-10 rounded-xl flex items-center justify-center ${enabled ? "bg-kids-mint" : "bg-muted"}`}>
          <Icon size={20} />
        </div>
        <span className="font-bold">{label}</span>
      </div>
      <div className={`w-12 h-7 rounded-full transition-colors ${enabled ? "bg-kids-blue" : "bg-muted"} relative`}>
        <motion.div
          animate={{ x: enabled ? 22 : 2 }}
          className="absolute top-1 w-5 h-5 rounded-full bg-card shadow-soft"
        />
      </div>
    </button>
  );

  return (
    <div className="page-container">
      <h1 className="kids-heading text-2xl mb-6">⚙️ Settings</h1>

      <div className="space-y-3 mb-8">
        <Toggle
          enabled={settings.calmMode}
          onToggle={() => updateSettings({ calmMode: !settings.calmMode })}
          label="Calm Mode 😌"
          icon={Moon}
        />
        <Toggle
          enabled={settings.soundEnabled}
          onToggle={() => updateSettings({ soundEnabled: !settings.soundEnabled })}
          label="Sound Effects"
          icon={Volume2}
        />
        <Toggle
          enabled={settings.colorblindMode}
          onToggle={() => updateSettings({ colorblindMode: !settings.colorblindMode })}
          label="Colorblind Mode"
          icon={Eye}
        />
      </div>

      {/* Font Size */}
      <div className="kids-card mb-6">
        <div className="flex items-center gap-3 mb-3">
          <Type size={20} />
          <span className="font-bold">Text Size</span>
        </div>
        <div className="flex gap-2">
          {(["normal", "large", "xlarge"] as const).map((size) => (
            <button
              key={size}
              onClick={() => updateSettings({ fontSize: size })}
              className={`kids-btn flex-1 text-sm ${
                settings.fontSize === size ? "bg-primary text-primary-foreground" : "bg-muted text-muted-foreground"
              }`}
            >
              {size === "normal" ? "A" : size === "large" ? "A+" : "A++"}
            </button>
          ))}
        </div>
      </div>

      {/* Parent Dashboard */}
      <div className="kids-card">
        <div className="flex items-center gap-3 mb-3">
          <Shield size={20} />
          <span className="font-bold">Parent Dashboard</span>
        </div>

        {parentPinVerified ? (
          <button onClick={() => navigate("/parent")} className="kids-btn-peach w-full">
            <Lock size={18} /> Open Dashboard
          </button>
        ) : (
          <div>
            <p className="text-sm text-muted-foreground mb-3">Enter PIN to access (default: 1234)</p>
            <div className="flex gap-2">
              <input
                type="password"
                maxLength={4}
                value={pinInput}
                onChange={(e) => setPinInput(e.target.value.replace(/\D/g, ""))}
                placeholder="PIN"
                className="flex-1 rounded-xl border border-border px-4 py-3 text-center text-lg font-bold tracking-widest bg-muted focus:outline-none focus:ring-2 focus:ring-ring"
              />
              <button onClick={handlePinSubmit} className="kids-btn-primary !px-6">
                Go
              </button>
            </div>
            {pinError && <p className="text-destructive text-sm mt-2 font-semibold">Wrong PIN, try again!</p>}
          </div>
        )}
      </div>
    </div>
  );
};

export default Settings;
