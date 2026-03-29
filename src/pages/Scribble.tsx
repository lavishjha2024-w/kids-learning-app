import { useCallback, useEffect, useRef, useState } from "react";
import { ArrowLeft } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { cn } from "@/lib/utils";
import { useI18n } from "@/context/I18nContext";

type Tool = "pencil" | "eraser" | "line" | "rect" | "circle";

const COLORS = ["#7dd3c0", "#a78bfa", "#fcd34d", "#fb923c", "#f472b6", "#38bdf8", "#86efac", "#fca5a5"];

const GUIDES = [
  { key: "scribble.prompt.house", fallback: "Draw a house" },
  { key: "scribble.prompt.tree", fallback: "Draw a tree" },
  { key: "scribble.prompt.sun", fallback: "Draw a sun" },
];

const Scribble = () => {
  const navigate = useNavigate();
  const { t } = useI18n();
  const wrapRef = useRef<HTMLDivElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [tool, setTool] = useState<Tool>("pencil");
  const [color, setColor] = useState(COLORS[0]);
  const [mode, setMode] = useState<"free" | "guided">("free");
  const [guideIdx, setGuideIdx] = useState(0);
  const drawing = useRef(false);
  const start = useRef<{ x: number; y: number } | null>(null);
  const last = useRef<{ x: number; y: number } | null>(null);

  const syncSize = useCallback(() => {
    const canvas = canvasRef.current;
    const wrap = wrapRef.current;
    if (!canvas || !wrap) return;
    const { width, height } = wrap.getBoundingClientRect();
    const dpr = Math.min(window.devicePixelRatio || 1, 2);
    canvas.width = Math.floor(width * dpr);
    canvas.height = Math.floor(height * dpr);
    canvas.style.width = `${width}px`;
    canvas.style.height = `${height}px`;
    const ctx = canvas.getContext("2d");
    if (ctx) {
      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      ctx.lineCap = "round";
      ctx.lineJoin = "round";
    }
  }, []);

  useEffect(() => {
    syncSize();
    const ro = new ResizeObserver(() => syncSize());
    if (wrapRef.current) ro.observe(wrapRef.current);
    return () => ro.disconnect();
  }, [syncSize]);

  const getPos = (e: React.MouseEvent | React.TouchEvent) => {
    const canvas = canvasRef.current;
    if (!canvas) return { x: 0, y: 0 };
    const r = canvas.getBoundingClientRect();
    let clientX: number;
    let clientY: number;
    if ("touches" in e) {
      const touch = e.touches[0] ?? e.changedTouches[0];
      if (!touch) return { x: 0, y: 0 };
      clientX = touch.clientX;
      clientY = touch.clientY;
    } else {
      clientX = e.clientX;
      clientY = e.clientY;
    }
    return { x: clientX - r.left, y: clientY - r.top };
  };

  const drawLine = (from: { x: number; y: number }, to: { x: number; y: number }, stroke: string, width: number) => {
    const ctx = canvasRef.current?.getContext("2d");
    if (!ctx) return;
    ctx.beginPath();
    ctx.strokeStyle = stroke;
    ctx.lineWidth = width;
    ctx.moveTo(from.x, from.y);
    ctx.lineTo(to.x, to.y);
    ctx.stroke();
  };

  const onDown = (e: React.MouseEvent | React.TouchEvent) => {
    e.preventDefault();
    const p = getPos(e);
    drawing.current = true;
    start.current = p;
    last.current = p;
    if (tool === "pencil" || tool === "eraser") {
      const ctx = canvasRef.current?.getContext("2d");
      if (!ctx) return;
      ctx.beginPath();
      ctx.moveTo(p.x, p.y);
      ctx.strokeStyle = tool === "eraser" ? "#ffffff" : color;
      ctx.lineWidth = tool === "eraser" ? 20 : 4;
      ctx.globalCompositeOperation = tool === "eraser" ? "destination-out" : "source-over";
    }
  };

  const onMove = (e: React.MouseEvent | React.TouchEvent) => {
    if (!drawing.current || !last.current) return;
    e.preventDefault();
    const p = getPos(e);
    if (tool === "pencil" || tool === "eraser") {
      const ctx = canvasRef.current?.getContext("2d");
      if (!ctx) return;
      ctx.lineTo(p.x, p.y);
      ctx.stroke();
      last.current = p;
    }
  };

  const onUp = (e: React.MouseEvent | React.TouchEvent) => {
    if (!drawing.current || !start.current) return;
    e.preventDefault();
    const p = getPos(e);
    const ctx = canvasRef.current?.getContext("2d");
    if (ctx && (tool === "line" || tool === "rect" || tool === "circle")) {
      ctx.globalCompositeOperation = "source-over";
      ctx.strokeStyle = color;
      ctx.lineWidth = 3;
      if (tool === "line") {
        drawLine(start.current, p, color, 3);
      } else if (tool === "rect") {
        const w = p.x - start.current.x;
        const h = p.y - start.current.y;
        ctx.strokeRect(start.current.x, start.current.y, w, h);
      } else if (tool === "circle") {
        const r = Math.hypot(p.x - start.current.x, p.y - start.current.y);
        ctx.beginPath();
        ctx.arc(start.current.x, start.current.y, r, 0, Math.PI * 2);
        ctx.stroke();
      }
    }
    drawing.current = false;
    start.current = null;
    last.current = null;
    const c = canvasRef.current?.getContext("2d");
    if (c) c.globalCompositeOperation = "source-over";
  };

  const clear = () => {
    const canvas = canvasRef.current;
    const ctx = canvas?.getContext("2d");
    if (!canvas || !ctx) return;
    ctx.save();
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.restore();
  };

  const save = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    try {
      localStorage.setItem("kids-scribble-last", canvas.toDataURL("image/png"));
    } catch {
      /* ignore */
    }
    const a = document.createElement("a");
    a.href = canvas.toDataURL("image/png");
    a.download = "klearn-drawing.png";
    a.click();
  };

  const guide = GUIDES[guideIdx % GUIDES.length];

  return (
    <div className="page-container">
      <button
        type="button"
        onClick={() => navigate("/")}
        className="flex items-center gap-2 text-muted-foreground mb-4 font-semibold min-h-[44px]"
      >
        <ArrowLeft size={20} aria-hidden /> {t("nav.home")}
      </button>

      <h1 className="kids-heading text-3xl sm:text-4xl mb-1">{t("scribble.title")}</h1>
      <p className="text-muted-foreground font-semibold mb-4">{t("scribble.sub")}</p>

      <div className="flex flex-wrap gap-2 mb-3">
        <button
          type="button"
          onClick={() => setMode("free")}
          className={cn(
            "kids-btn text-sm !min-h-[44px] !py-2",
            mode === "free" ? "bg-primary" : "bg-muted text-muted-foreground",
          )}
        >
          {t("scribble.free")}
        </button>
        <button
          type="button"
          onClick={() => setMode("guided")}
          className={cn(
            "kids-btn text-sm !min-h-[44px] !py-2",
            mode === "guided" ? "bg-primary" : "bg-muted text-muted-foreground",
          )}
        >
          {t("scribble.guided")}
        </button>
      </div>

      {mode === "guided" && (
        <div className="kids-card mb-3 py-3 text-center font-bold">
          <p>{t(guide.key)}</p>
          <button type="button" onClick={() => setGuideIdx((i) => i + 1)} className="kids-btn-secondary text-sm mt-2 !min-h-[40px]">
            {t("scribble.nextPrompt")}
          </button>
        </div>
      )}

      <div className="flex flex-wrap gap-2 mb-3">
        {(
          [
            ["pencil", "scribble.tool.pencil"],
            ["eraser", "scribble.tool.eraser"],
            ["line", "scribble.tool.line"],
            ["rect", "scribble.tool.rect"],
            ["circle", "scribble.tool.circle"],
          ] as const
        ).map(([id, key]) => (
          <button
            key={id}
            type="button"
            onClick={() => setTool(id)}
            className={cn(
              "kids-btn text-sm !min-h-[44px] !py-2",
              tool === id ? "bg-primary" : "bg-muted text-muted-foreground",
            )}
          >
            {t(key)}
          </button>
        ))}
      </div>

      <div className="flex flex-wrap gap-2 mb-3">
        {COLORS.map((c) => (
          <button
            key={c}
            type="button"
            aria-label={`color ${c}`}
            onClick={() => setColor(c)}
            className={cn(
              "w-10 h-10 rounded-2xl border-2 border-border shadow-soft min-h-[44px] min-w-[44px]",
              color === c && "ring-4 ring-primary ring-offset-2",
            )}
            style={{ backgroundColor: c }}
          />
        ))}
      </div>

      <div ref={wrapRef} className="relative w-full h-64 sm:h-80 rounded-2xl overflow-hidden border border-border bg-card">
        <canvas
          ref={canvasRef}
          className="touch-none cursor-crosshair block w-full h-full bg-white"
          onMouseDown={onDown}
          onMouseMove={onMove}
          onMouseUp={onUp}
          onMouseLeave={onUp}
          onTouchStart={onDown}
          onTouchMove={onMove}
          onTouchEnd={onUp}
        />
      </div>

      <div className="flex flex-wrap gap-2 mt-4">
        <button type="button" onClick={clear} className="kids-btn-secondary !min-h-[48px]">
          {t("scribble.clear")}
        </button>
        <button type="button" onClick={save} className="kids-btn-primary !min-h-[48px]">
          {t("scribble.save")}
        </button>
      </div>
    </div>
  );
};

export default Scribble;
