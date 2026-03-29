import { useEffect, useRef } from "react";
import { toast } from "sonner";
import { useApp } from "@/context/AppContext";
import { useI18n } from "@/context/I18nContext";

/** Shows a friendly toast when candy total increases (skips first mount sync). */
export function CandyToastBridge() {
  const { usage } = useApp();
  const { t } = useI18n();
  const prev = useRef<number | null>(null);

  useEffect(() => {
    if (prev.current === null) {
      prev.current = usage.candies;
      return;
    }
    if (usage.candies > prev.current) {
      const d = usage.candies - prev.current;
      toast.success(t("candy.earned", { n: d }));
    }
    prev.current = usage.candies;
  }, [usage.candies, t]);

  return null;
}
