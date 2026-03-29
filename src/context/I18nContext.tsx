import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from "react";
import translations from "@/data/translations.json";
import type { LocaleCode } from "@/i18n/types";

export type { LocaleCode } from "@/i18n/types";

const STORAGE_KEY = "kids-lang";

type Dict = Record<string, string>;
type TranslationsRoot = Record<string, Dict>;

const root = translations as TranslationsRoot;

function getDict(locale: LocaleCode): Dict {
  const d = root[locale] ?? root.en;
  const en = root.en;
  return { ...en, ...d };
}

interface I18nContextType {
  locale: LocaleCode;
  setLocale: (l: LocaleCode) => void;
  t: (key: string, vars?: Record<string, string | number>) => string;
}

const I18nContext = createContext<I18nContextType | null>(null);

export const useI18n = () => {
  const ctx = useContext(I18nContext);
  if (!ctx) throw new Error("useI18n must be inside I18nProvider");
  return ctx;
};

/** Safe hook for leaf components outside I18n (should not happen). */
export function useOptionalI18n(): I18nContextType | null {
  return useContext(I18nContext);
}

export const I18nProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [locale, setLocaleState] = useState<LocaleCode>(() => {
    if (typeof window === "undefined") return "en";
    const s = localStorage.getItem(STORAGE_KEY) as LocaleCode | null;
    if (s && root[s]) return s;
    return "en";
  });

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, locale);
    document.documentElement.lang = locale === "sa" ? "sa" : locale;
  }, [locale]);

  const setLocale = useCallback((l: LocaleCode) => {
    setLocaleState(l);
  }, []);

  const dict = useMemo(() => getDict(locale), [locale]);

  const t = useCallback(
    (key: string, vars?: Record<string, string | number>) => {
      let s = dict[key] ?? root.en[key] ?? key;
      if (vars) {
        for (const [k, v] of Object.entries(vars)) {
          s = s.replace(new RegExp(`\\{${k}\\}`, "g"), String(v));
        }
      }
      return s;
    },
    [dict],
  );

  const value = useMemo(() => ({ locale, setLocale, t }), [locale, setLocale, t]);

  return <I18nContext.Provider value={value}>{children}</I18nContext.Provider>;
};
