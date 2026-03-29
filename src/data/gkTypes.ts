export type GKCategory = "animals" | "space" | "science" | "geography" | "everyday";

export type GKQuestion =
  | {
      id: string;
      category: string;
      difficulty: "easy" | "medium";
      type: "mcq";
      question: string;
      options: string[];
      correctIndex: number;
      wrongHint: string;
    }
  | {
      id: string;
      category: string;
      difficulty: "easy" | "medium";
      type: "tf";
      question: string;
      correct: boolean;
      wrongHint: string;
    }
  | {
      id: string;
      category: string;
      difficulty: "easy" | "medium";
      type: "image";
      image: string;
      question: string;
      options: string[];
      correctIndex: number;
      wrongHint: string;
    };
