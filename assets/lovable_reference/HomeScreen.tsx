import { motion } from "framer-motion";
import { Camera, Dog, Coffee, Fish, ChevronRight, Gift } from "lucide-react";
import { getBreedById } from "@/lib/dogBreeds";
import cafeImg from "@/assets/cafe-local.png";
import seafoodImg from "@/assets/seafood-market.png";

const coupons = [
  {
    id: 1,
    image: cafeImg,
    storeName: "집앞카페",
    tag: "단골 혜택",
    tagColor: "bg-accent text-accent-foreground",
    title: "바우카페를 4번 가셨네요!",
    description: "한 번만 더 가시면 쿠키 서비스를 받으실 수 있어요 🍪",
    progress: 4,
    progressMax: 5,
    icon: Coffee,
  },
  {
    id: 2,
    image: seafoodImg,
    storeName: "오늘수산",
    tag: "이벤트",
    tagColor: "bg-secondary text-secondary-foreground",
    title: "5만원 이상 구매 시",
    description: "조개 500g 서비스! 🐚",
    progress: null,
    progressMax: null,
    icon: Fish,
  },
];

interface HomeScreenProps {
  mileage: number;
  onScan: () => void;
  onOpenGame: () => void;
  breedId: string;
  level: number;
}

const HomeScreen = ({ mileage, onScan, onOpenGame, breedId, level }: HomeScreenProps) => {
  const breed = getBreedById(breedId);

  return (
    <div className="px-5 pt-14">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <div>
          <p className="text-muted-foreground text-sm">안녕하세요 👋</p>
          <h1 className="text-2xl font-bold tracking-tight">바우바우</h1>
        </div>
        <div className="w-10 h-10 rounded-full bg-muted flex items-center justify-center">
          <span className="text-lg">🐾</span>
        </div>
      </div>

      {/* Mileage Card */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
        className="bg-card rounded-5xl p-6 shadow-soft mb-8"
      >
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm text-muted-foreground mb-1">내 마일리지</p>
            <div className="flex items-baseline gap-1">
              <span className="text-4xl font-bold font-mono-nums text-foreground">
                {mileage.toLocaleString()}
              </span>
              <span className="text-xl font-bold text-primary">P</span>
            </div>
            <p className="text-xs text-muted-foreground mt-2">
              Lv.{level} · {breed.name}
            </p>
          </div>
          <motion.img
            id="pet-image"
            src="/assets/lovable_reference/dog-bowwow.png"
            alt={breed.name}
            className="w-20 h-20 object-contain"
            animate={{ y: [0, -6, 0] }}
            transition={{ duration: 2.5, repeat: Infinity, ease: "easeInOut" }}
          />
        </div>
      </motion.div>

      {/* Scan Button */}
      <motion.button
        onClick={onScan}
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ delay: 0.2, type: "spring", stiffness: 260, damping: 20 }}
        whileHover={{ scale: 0.98 }}
        whileTap={{ scale: 0.95 }}
        className="w-full aspect-[4/3] rounded-[40px] bg-primary flex flex-col items-center justify-center gap-5 shadow-coral transition-shadow"
      >
        <motion.div
          className="w-20 h-20 bg-primary-foreground/20 rounded-full flex items-center justify-center"
          animate={{ scale: [1, 1.05, 1] }}
          transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
        >
          <Camera className="text-primary-foreground w-10 h-10" />
        </motion.div>
        <div className="text-center">
          <span className="text-primary-foreground font-bold text-xl block">
            영수증 촬영하기
          </span>
          <span className="text-primary-foreground/70 text-sm mt-1 block">
            오늘의 영수증을 들려주세요
          </span>
        </div>
      </motion.button>

      {/* Quick Stats + Game shortcut */}
      <div className="grid grid-cols-3 gap-3 mt-6">
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="bg-card rounded-3xl p-4 shadow-soft"
        >
          <p className="text-xs text-muted-foreground">이번 주</p>
          <p className="text-lg font-bold font-mono-nums mt-1">+1,240P</p>
        </motion.div>
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.35 }}
          className="bg-secondary/20 rounded-3xl p-4 shadow-soft"
        >
          <p className="text-xs text-muted-foreground">기부 사료</p>
          <p className="text-lg font-bold font-mono-nums mt-1">12.5kg</p>
        </motion.div>
        <motion.button
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          whileTap={{ scale: 0.95 }}
          onClick={onOpenGame}
          className="bg-primary/10 rounded-3xl p-4 shadow-soft flex flex-col items-center justify-center gap-1"
        >
          <Dog className="w-6 h-6 text-primary" />
          <p className="text-xs font-bold text-primary">키우기</p>
        </motion.button>
      </div>

      {/* Coupons & Events */}
      <div className="mt-8 mb-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-bold text-foreground">🎁 내 주변 혜택</h2>
          <button className="text-xs text-muted-foreground flex items-center gap-0.5">
            전체보기 <ChevronRight className="w-3 h-3" />
          </button>
        </div>
        <div className="flex flex-col gap-4">
          {coupons.map((coupon, i) => {
            const Icon = coupon.icon;
            return (
              <motion.div
                key={coupon.id}
                initial={{ opacity: 0, y: 15 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.45 + i * 0.1 }}
                whileTap={{ scale: 0.98 }}
                className="bg-card rounded-3xl overflow-hidden shadow-soft cursor-pointer"
              >
                <div className="flex gap-4 p-4">
                  {/* Store Image */}
                  <div className="w-20 h-20 rounded-2xl bg-muted overflow-hidden flex-shrink-0">
                    <img
                      src={coupon.image}
                      alt={coupon.storeName}
                      className="w-full h-full object-cover"
                    />
                  </div>
                  {/* Content */}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 mb-1">
                      <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${coupon.tagColor}`}>
                        {coupon.tag}
                      </span>
                      <span className="text-xs text-muted-foreground">{coupon.storeName}</span>
                    </div>
                    <p className="text-sm font-bold text-foreground leading-snug">
                      {coupon.title}
                    </p>
                    <p className="text-xs text-muted-foreground mt-0.5">
                      {coupon.description}
                    </p>
                    {/* Progress bar for stamp-type */}
                    {coupon.progress !== null && coupon.progressMax !== null && (
                      <div className="mt-2 flex items-center gap-2">
                        <div className="flex-1 h-2 bg-muted rounded-full overflow-hidden">
                          <motion.div
                            className="h-full bg-primary rounded-full"
                            initial={{ width: 0 }}
                            animate={{ width: `${(coupon.progress / coupon.progressMax) * 100}%` }}
                            transition={{ delay: 0.6, duration: 0.6, ease: "easeOut" }}
                          />
                        </div>
                        <span className="text-[10px] font-bold text-primary">
                          {coupon.progress}/{coupon.progressMax}
                        </span>
                      </div>
                    )}
                  </div>
                  <div className="flex items-center">
                    <ChevronRight className="w-4 h-4 text-muted-foreground" />
                  </div>
                </div>
              </motion.div>
            );
          })}
        </div>
      </div>
    </div>
  );
};

export default HomeScreen;