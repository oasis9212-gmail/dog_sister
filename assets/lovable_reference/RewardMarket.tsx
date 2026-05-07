import { motion } from "framer-motion";
import { Heart, BookOpen, Gamepad2 } from "lucide-react";
import { useState } from "react";

interface RewardMarketProps {
  mileage: number;
  onSpend: (amount: number) => void;
  onDonate: (kg: number) => void;
}

const categories = [
  {
    id: "donate",
    icon: Heart,
    label: "유기견 기부",
    description: "사료 1kg 기부하기",
    cost: 500,
    color: "bg-primary/10",
    iconColor: "text-primary",
  },
  {
    id: "webtoon",
    icon: BookOpen,
    label: "웹툰 보기",
    description: "인기 웹툰 1회차",
    cost: 300,
    color: "bg-secondary/20",
    iconColor: "text-secondary-foreground",
  },
  {
    id: "game",
    icon: Gamepad2,
    label: "게임 아이템",
    description: "랜덤 아이템 뽑기",
    cost: 200,
    color: "bg-accent",
    iconColor: "text-accent-foreground",
  },
];

const RewardMarket = ({ mileage, onSpend, onDonate }: RewardMarketProps) => {
  const [purchased, setPurchased] = useState<string | null>(null);

  const handlePurchase = (id: string, cost: number) => {
    if (mileage < cost) return;
    onSpend(cost);
    if (id === "donate") onDonate(1);
    setPurchased(id);
    setTimeout(() => setPurchased(null), 2000);
  };

  return (
    <div className="px-5 pt-14">
      <h1 className="text-2xl font-bold mb-2">리워드 마켓</h1>
      <p className="text-muted-foreground text-sm mb-8">
        마일리지로 좋은 일을 해보세요
      </p>

      {/* Balance */}
      <div className="bg-card rounded-3xl p-5 shadow-soft mb-8">
        <p className="text-sm text-muted-foreground">사용 가능한 포인트</p>
        <p className="text-3xl font-bold font-mono-nums mt-1">
          {mileage.toLocaleString()}
          <span className="text-primary text-xl ml-1">P</span>
        </p>
      </div>

      {/* Categories */}
      <div className="space-y-4">
        {categories.map((cat, i) => {
          const Icon = cat.icon;
          const canAfford = mileage >= cat.cost;
          const justPurchased = purchased === cat.id;

          return (
            <motion.button
              key={cat.id}
              initial={{ opacity: 0, y: 16 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.1 }}
              onClick={() => handlePurchase(cat.id, cat.cost)}
              disabled={!canAfford || justPurchased}
              className={`w-full flex items-center gap-4 p-5 rounded-3xl shadow-soft transition-all ${
                justPurchased
                  ? "bg-secondary/30"
                  : canAfford
                  ? "bg-card hover:shadow-md"
                  : "bg-muted opacity-60"
              }`}
            >
              <div
                className={`w-14 h-14 rounded-2xl ${cat.color} flex items-center justify-center`}
              >
                <Icon className={`w-7 h-7 ${cat.iconColor}`} />
              </div>
              <div className="flex-1 text-left">
                <p className="font-bold text-foreground">{cat.label}</p>
                <p className="text-sm text-muted-foreground">
                  {cat.description}
                </p>
              </div>
              <div className="text-right">
                {justPurchased ? (
                  <motion.span
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    className="text-secondary-foreground font-bold"
                  >
                    ✅ 완료!
                  </motion.span>
                ) : (
                  <span className="font-bold font-mono-nums text-foreground">
                    {cat.cost}P
                  </span>
                )}
              </div>
            </motion.button>
          );
        })}
      </div>
    </div>
  );
};

export default RewardMarket;

