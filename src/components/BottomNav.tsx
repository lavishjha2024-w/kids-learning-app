import { Home, BookOpen, Gamepad2, BarChart3, Settings } from "lucide-react";
import { useLocation, useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { useI18n } from "@/context/I18nContext";

const navItems = [
  { path: "/", labelKey: "nav.home" },
  { path: "/learn", labelKey: "nav.learn" },
  { path: "/games", labelKey: "nav.games" },
  { path: "/progress", labelKey: "nav.progress" },
  { path: "/settings", labelKey: "nav.settings" },
] as const;

const icons = [Home, BookOpen, Gamepad2, BarChart3, Settings];

const BottomNav = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const { t } = useI18n();

  if (location.pathname === "/parent") return null;

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-50 bg-card/95 backdrop-blur-md border-t border-border shadow-soft">
      <div className="flex justify-around items-center max-w-lg mx-auto py-2 px-1">
        {navItems.map((item, i) => {
          const active = location.pathname === item.path;
          const Icon = icons[i];
          return (
            <button
              key={item.path}
              type="button"
              onClick={() => navigate(item.path)}
              className={`relative kids-nav-item ${active ? "kids-nav-item-active" : "text-muted-foreground hover:text-foreground"}`}
              aria-label={t(item.labelKey)}
              aria-current={active ? "page" : undefined}
            >
              <motion.div whileTap={{ scale: 0.9 }}>
                <Icon size={24} strokeWidth={active ? 2.5 : 2} aria-hidden />
              </motion.div>
              <span className="text-xs font-semibold">{t(item.labelKey)}</span>
              {active && (
                <motion.div
                  layoutId="nav-indicator"
                  className="absolute -top-0.5 left-1/2 -translate-x-1/2 w-8 h-1 rounded-full bg-primary"
                />
              )}
            </button>
          );
        })}
      </div>
    </nav>
  );
};

export default BottomNav;
