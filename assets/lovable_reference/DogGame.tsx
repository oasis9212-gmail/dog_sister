import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { X, Heart } from "lucide-react";
import { getBreedById } from "@/lib/dogBreeds";

interface DogGameProps {
  breedId: string;
  level: number;
  mileage: number;
  onSpendMileage: (amount: number) => void;
  onLevelUp: () => void;
  onClose: () => void;
}

type Action = "feed" | "wash" | "play" | null;

const actionData = {
  feed: { emoji: "🍖", label: "밥 주기", cost: 100, exp: 30, message: "냠냠! 맛있게 먹고 있어요!" },
  wash: { emoji: "🛁", label: "씻겨주기", cost: 80, exp: 20, message: "깨끗해져서 기분 좋아요!" },
  play: { emoji: "🎾", label: "놀아주기", cost: 50, exp: 15, message: "신나게 놀았어요! 꼬리 살랑~" },
};

const weatherTypes = ["sunny", "cloudy", "rainy"] as const;
type Weather = (typeof weatherTypes)[number];

/* ── Pastel Tree ── */
const PastelTree = ({ size = "lg", className = "" }: { size?: "sm" | "md" | "lg"; className?: string }) => {
  const dims = size === "lg" ? { crown1: "w-16 h-18", crown2: "w-14 h-14", trunk: "w-4 h-10" }
    : size === "md" ? { crown1: "w-12 h-14", crown2: "w-10 h-10", trunk: "w-3 h-8" }
    : { crown1: "w-8 h-10", crown2: "w-7 h-8", trunk: "w-2 h-5" };
  return (
    <div className={`flex flex-col items-center ${className}`}>
      <div className={`${dims.crown1} rounded-full bg-[hsl(130,45%,75%)] shadow-[inset_-4px_-4px_8px_rgba(0,0,0,0.06)]`} />
      <div className={`${dims.crown2} rounded-full bg-[hsl(135,50%,68%)] -mt-[40%] shadow-[inset_-3px_-3px_6px_rgba(0,0,0,0.06)]`} />
      <div className={`${dims.trunk} rounded-b-md bg-[hsl(30,40%,65%)] -mt-[15%]`} />
    </div>
  );
};

/* ── Pastel Flower ── */
const PastelFlower = ({ color, size = 16, className = "" }: { color: string; size?: number; className?: string }) => (
  <motion.div
    className={`absolute ${className}`}
    animate={{ scale: [1, 1.1, 1], rotate: [0, 5, -5, 0] }}
    transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
  >
    <svg width={size} height={size} viewBox="0 0 24 24">
      {[0, 72, 144, 216, 288].map((angle) => (
        <circle key={angle} cx={12 + 6 * Math.cos((angle * Math.PI) / 180)} cy={12 + 6 * Math.sin((angle * Math.PI) / 180)} r="5" fill={color} opacity="0.8" />
      ))}
      <circle cx="12" cy="12" r="4" fill="hsl(45,90%,70%)" />
    </svg>
  </motion.div>
);

/* ── Cute Dog House ── */
const DogHouse = () => (
  <div className="flex flex-col items-center">
    {/* Roof */}
    <div className="relative">
      <div className="w-0 h-0 border-l-[40px] border-r-[40px] border-b-[30px] border-l-transparent border-r-transparent border-b-[hsl(15,50%,55%)]" />
      <div className="absolute top-[6px] left-1/2 -translate-x-1/2 w-0 h-0 border-l-[34px] border-r-[34px] border-b-[26px] border-l-transparent border-r-transparent border-b-[hsl(15,45%,62%)]" />
    </div>
    {/* Body */}
    <div className="w-[80px] h-[52px] bg-[hsl(30,50%,72%)] rounded-b-xl flex items-end justify-center shadow-[inset_-4px_-4px_8px_rgba(0,0,0,0.08)]">
      <div className="w-8 h-10 bg-[hsl(25,30%,35%)] rounded-t-full mb-0" />
    </div>
    {/* Name plate */}
    <div className="w-10 h-3 bg-[hsl(45,60%,75%)] rounded-sm -mt-[44px] mb-[32px] flex items-center justify-center">
      <span className="text-[6px] font-bold text-[hsl(25,30%,35%)]">HOME</span>
    </div>
  </div>
);

/* ── Food Bowl ── */
const FoodBowl = ({ showFood }: { showFood: boolean }) => (
  <div className="relative">
    <div className="w-12 h-3 bg-[hsl(0,55%,72%)] rounded-t-md" />
    <div className="w-14 h-6 bg-[hsl(0,55%,65%)] rounded-b-[50%]" />
    <div className="absolute top-[2px] left-1/2 -translate-x-1/2 w-10 h-2 bg-[hsl(0,55%,78%)] rounded-full" />
    {showFood && (
      <motion.div initial={{ opacity: 0, scale: 0 }} animate={{ opacity: 1, scale: 1 }} className="absolute -top-3 left-1/2 -translate-x-1/2">
        <span className="text-lg">🍖</span>
      </motion.div>
    )}
  </div>
);

/* ── Pastel Cloud ── */
const PastelCloud = ({ className = "", speed = 30 }: { className?: string; speed?: number }) => (
  <motion.div className={`absolute ${className}`} animate={{ x: [-80, 420] }} transition={{ duration: speed, repeat: Infinity, ease: "linear" }}>
    <svg width="80" height="40" viewBox="0 0 80 40">
      <ellipse cx="40" cy="28" rx="30" ry="12" fill="white" opacity="0.7" />
      <ellipse cx="28" cy="22" rx="18" ry="14" fill="white" opacity="0.6" />
      <ellipse cx="52" cy="20" rx="20" ry="16" fill="white" opacity="0.65" />
      <ellipse cx="40" cy="18" rx="16" ry="12" fill="white" opacity="0.8" />
    </svg>
  </motion.div>
);

const DogGame = ({ breedId, level, mileage, onSpendMileage, onLevelUp, onClose }: DogGameProps) => {
  const [currentAction, setCurrentAction] = useState<Action>(null);
  const [happiness, setHappiness] = useState(70);
  const [exp, setExp] = useState(0);
  const [weather, setWeather] = useState<Weather>("sunny");
  const maxExp = level * 100;
  const breed = getBreedById(breedId);

  useEffect(() => {
    const hour = new Date().getHours();
    if (hour >= 6 && hour < 12) setWeather("sunny");
    else if (hour >= 12 && hour < 18) setWeather("cloudy");
    else setWeather("rainy");
  }, []);

  const handleAction = (action: Action) => {
    if (!action) return;
    const data = actionData[action];
    if (mileage < data.cost) return;
    onSpendMileage(data.cost);
    setCurrentAction(action);
    setHappiness((prev) => Math.min(100, prev + 10));
    const newExp = exp + data.exp;
    if (newExp >= maxExp) {
      setExp(0);
      onLevelUp();
    } else {
      setExp(newExp);
    }
    setTimeout(() => setCurrentAction(null), 2000);
  };

  const weatherLabel = weather === "sunny" ? "맑음 ☀️" : weather === "cloudy" ? "흐림 ☁️" : "비 🌧️";

  return (
    <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} className="fixed inset-0 z-50 flex flex-col max-w-md mx-auto left-0 right-0 overflow-hidden">

      {/* ══════ SKY ══════ */}
      <div className="absolute inset-0 bg-gradient-to-b from-[hsl(200,70%,85%)] via-[hsl(195,60%,88%)] to-[hsl(90,40%,82%)]" />

      {/* Sunshine glow */}
      {weather === "sunny" && (
        <div className="absolute top-8 right-8 w-32 h-32 rounded-full bg-[hsl(45,95%,80%)] opacity-40 blur-3xl" />
      )}
      {weather === "sunny" && (
        <motion.div className="absolute top-6 right-10" animate={{ scale: [1, 1.08, 1], opacity: [0.9, 1, 0.9] }} transition={{ duration: 3, repeat: Infinity }}>
          <svg width="48" height="48" viewBox="0 0 48 48">
            <circle cx="24" cy="24" r="10" fill="hsl(45,95%,72%)" />
            {[0, 45, 90, 135, 180, 225, 270, 315].map((a) => (
              <line key={a} x1={24 + 14 * Math.cos((a * Math.PI) / 180)} y1={24 + 14 * Math.sin((a * Math.PI) / 180)} x2={24 + 20 * Math.cos((a * Math.PI) / 180)} y2={24 + 20 * Math.sin((a * Math.PI) / 180)} stroke="hsl(45,95%,72%)" strokeWidth="2.5" strokeLinecap="round" />
            ))}
          </svg>
        </motion.div>
      )}

      {/* Clouds */}
      {weather !== "rainy" && (
        <>
          <PastelCloud className="top-16" speed={35} />
          <PastelCloud className="top-28" speed={45} />
          <PastelCloud className="top-10" speed={50} />
        </>
      )}

      {/* Rain */}
      {weather === "rainy" && (
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          {Array.from({ length: 24 }).map((_, i) => (
            <motion.div key={i} className="absolute w-0.5 h-5 bg-[hsl(210,60%,75%)] rounded-full opacity-50" style={{ left: `${Math.random() * 100}%`, top: -20 }} animate={{ y: [0, 800], opacity: [0.6, 0] }} transition={{ duration: 1.2 + Math.random(), repeat: Infinity, delay: Math.random() * 2 }} />
          ))}
        </div>
      )}

      {/* ══════ HEADER (glassmorphism) ══════ */}
      <div className="relative z-20 mx-4 mt-12 mb-2 px-4 py-3 rounded-2xl bg-white/60 backdrop-blur-md shadow-sm">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-lg font-bold text-foreground">강아지 키우기</h2>
            <p className="text-xs text-muted-foreground">Lv.{level} {breed.name}</p>
          </div>
          <div className="flex items-center gap-2">
            <span className="text-[11px] text-muted-foreground bg-white/70 rounded-full px-2.5 py-0.5">{weatherLabel}</span>
            <button onClick={onClose} className="w-8 h-8 rounded-full bg-white/70 flex items-center justify-center">
              <X className="w-4 h-4 text-muted-foreground" />
            </button>
          </div>
        </div>
        {/* Bars */}
        <div className="mt-3 space-y-1.5">
          <div>
            <div className="flex items-center gap-1.5 mb-0.5">
              <Heart className="w-3 h-3 text-primary" />
              <span className="text-[10px] text-muted-foreground">행복도 {happiness}%</span>
            </div>
            <div className="h-1.5 bg-white/50 rounded-full overflow-hidden">
              <motion.div className="h-full bg-primary rounded-full" animate={{ width: `${happiness}%` }} transition={{ type: "spring" }} />
            </div>
          </div>
          <div>
            <span className="text-[10px] text-muted-foreground">경험치 {exp}/{maxExp}</span>
            <div className="h-1.5 bg-white/50 rounded-full overflow-hidden mt-0.5">
              <motion.div className="h-full bg-secondary rounded-full" animate={{ width: `${(exp / maxExp) * 100}%` }} transition={{ type: "spring" }} />
            </div>
          </div>
        </div>
      </div>

      {/* ══════ SCENE ══════ */}
      <div className="relative flex-1 flex flex-col justify-end z-10">

        {/* Speech bubble */}
        <AnimatePresence>
          {currentAction && (
            <motion.div key={currentAction} initial={{ opacity: 0, y: -10, scale: 0.8 }} animate={{ opacity: 1, y: 0, scale: 1 }} exit={{ opacity: 0, y: -20 }} className="absolute top-2 left-1/2 -translate-x-1/2 bg-white/90 backdrop-blur rounded-2xl px-4 py-2 shadow-lg z-30">
              <p className="text-sm font-medium text-foreground">{actionData[currentAction].message}</p>
              <div className="absolute -bottom-1.5 left-1/2 -translate-x-1/2 w-3 h-3 bg-white/90 rotate-45" />
            </motion.div>
          )}
        </AnimatePresence>

        {/* Floating hearts */}
        {currentAction && [0, 1, 2].map((i) => (
          <motion.span key={i} initial={{ opacity: 1, y: 0, x: (i - 1) * 30 }} animate={{ opacity: 0, y: -80 }} transition={{ duration: 1, delay: i * 0.2 }} className="absolute text-2xl z-20 left-1/2" style={{ bottom: "50%" }}>
            ❤️
          </motion.span>
        ))}

        {/* Background trees */}
        <PastelTree size="md" className="absolute bottom-[38%] left-2 z-[5] opacity-60" />
        <PastelTree size="lg" className="absolute bottom-[34%] left-8 z-[6]" />
        <PastelTree size="sm" className="absolute bottom-[40%] left-[38%] z-[5] opacity-50" />
        <PastelTree size="lg" className="absolute bottom-[35%] right-4 z-[6]" />
        <PastelTree size="md" className="absolute bottom-[37%] right-16 z-[5] opacity-70" />

        {/* Dog house (behind dog) */}
        <div className="absolute bottom-[22%] right-8 z-[7]">
          <DogHouse />
        </div>

        {/* Food bowl */}
        <div className="absolute bottom-[18%] left-10 z-[8]">
          <FoodBowl showFood={currentAction === "feed"} />
        </div>

        {/* Flowers scattered */}
        <PastelFlower color="hsl(340,60%,78%)" size={14} className="bottom-[30%] left-[15%] z-[7]" />
        <PastelFlower color="hsl(45,80%,75%)" size={12} className="bottom-[32%] left-[50%] z-[7]" />
        <PastelFlower color="hsl(280,50%,80%)" size={10} className="bottom-[29%] right-[30%] z-[7]" />
        <PastelFlower color="hsl(15,70%,80%)" size={14} className="bottom-[31%] right-[12%] z-[7]" />
        <PastelFlower color="hsl(200,50%,78%)" size={11} className="bottom-[33%] left-[30%] z-[7]" />

        {/* ── Dog ── */}
        <div className="flex items-end justify-center pb-0 relative z-[9] -mb-4">
          <motion.img
            src={breed.image}
            alt={breed.name}
            className="w-36 h-36 object-contain drop-shadow-lg"
            animate={
              currentAction === "play" ? { rotate: [-5, 5, -5], y: [0, -12, 0] }
                : currentAction === "wash" ? { scale: [1, 1.06, 1] }
                : currentAction === "feed" ? { y: [0, -5, 0] }
                : { y: [0, -6, 0] }
            }
            transition={{ duration: currentAction ? 0.5 : 2.5, repeat: Infinity, ease: "easeInOut" }}
          />
        </div>

        {/* ══════ HILL / GROUND ══════ */}
        <div className="relative">
          {/* Rolling hills */}
          <svg viewBox="0 0 400 120" className="w-full" preserveAspectRatio="none" style={{ height: "140px", marginBottom: "-2px" }}>
            <ellipse cx="100" cy="100" rx="200" ry="80" fill="hsl(100,45%,76%)" />
            <ellipse cx="320" cy="110" rx="180" ry="70" fill="hsl(105,40%,72%)" />
            <ellipse cx="200" cy="120" rx="250" ry="60" fill="hsl(95,50%,70%)" />
          </svg>
          {/* Ground fill */}
          <div className="h-20 bg-[hsl(95,50%,70%)]">
            {/* Grass tufts */}
            <div className="flex justify-around pt-1 px-6">
              {Array.from({ length: 16 }).map((_, i) => (
                <motion.div key={i} className="w-1 h-3 bg-[hsl(110,45%,60%)] rounded-t-full origin-bottom" animate={{ rotate: [-4, 4, -4] }} transition={{ duration: 2.5, repeat: Infinity, delay: i * 0.08 }} />
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* ══════ BOTTOM CONTROLS ══════ */}
      <div className="relative z-20 bg-white/90 backdrop-blur-lg rounded-t-3xl -mt-6 pt-4 shadow-[0_-4px_20px_rgba(0,0,0,0.06)]">
        <div className="px-5 mb-3 text-center">
          <p className="text-sm text-muted-foreground">보유 포인트: <span className="font-bold font-mono-nums text-primary">{mileage.toLocaleString()}P</span></p>
        </div>
        <div className="px-5 pb-10 grid grid-cols-3 gap-3">
          {(Object.keys(actionData) as Array<keyof typeof actionData>).map((key) => {
            const data = actionData[key];
            const canAfford = mileage >= data.cost;
            return (
              <motion.button key={key} whileTap={{ scale: 0.95 }} onClick={() => handleAction(key)} disabled={!canAfford || !!currentAction}
                className={`flex flex-col items-center gap-2 p-4 rounded-3xl transition-all ${canAfford && !currentAction ? "bg-card shadow-soft active:shadow-none" : "bg-muted opacity-50"}`}>
                <span className="text-3xl">{data.emoji}</span>
                <span className="text-xs font-bold text-foreground">{data.label}</span>
                <span className="text-xs font-mono-nums text-muted-foreground">{data.cost}P</span>
              </motion.button>
            );
          })}
        </div>
      </div>
    </motion.div>
  );
};

export default DogGame;