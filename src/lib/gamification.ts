/** Progress ring toward the next candy milestone (same visual slot as former XP bar). */
export const CANDY_MILESTONE = 100;

export function getCandyProgressPercent(candies: number): number {
  return ((candies % CANDY_MILESTONE) / CANDY_MILESTONE) * 100;
}

export function getCandyInCurrentMilestone(candies: number): number {
  return candies % CANDY_MILESTONE;
}

export function updateDailyStreak(
  lastStreakDate: string | undefined,
  currentStreak: number,
): { streak: number; lastStreakDate: string } {
  const today = new Date().toDateString();
  const y = new Date();
  y.setDate(y.getDate() - 1);
  const yesterday = y.toDateString();

  if (lastStreakDate === today) {
    return { streak: currentStreak, lastStreakDate: today };
  }
  if (lastStreakDate === yesterday) {
    return { streak: currentStreak + 1, lastStreakDate: today };
  }
  return { streak: 1, lastStreakDate: today };
}
