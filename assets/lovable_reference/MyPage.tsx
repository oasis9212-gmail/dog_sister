import { motion } from "framer-motion";
import { getBreedById } from "@/lib/dogBreeds";
import { Settings } from "lucide-react";
import type { UserProfile } from "@/components/ProfileEditor";

interface MyPageProps {
  mileage: number;
  totalDonatedKg: number;
  scanHistory: { date: string; amount: number; store: string }[];
  level: number;
  breedId: string;
  onOpenBreedPicker: () => void;
  onOpenProfileEditor: () => void;
  profile: UserProfile;
}

const MyPage = ({ mileage, totalDonatedKg, scanHistory, level, breedId, onOpenBreedPicker, onOpenProfileEditor, profile }: MyPageProps) => {
  const breed = getBreedById(breedId);

  return (
    <div className="px-5 pt-14">
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-2xl font-bold">마이페이지</h1>
        <button onClick={onOpenProfileEditor} className="w-10 h-10 rounded-full bg-muted flex items-center justify-center">
          <Settings className="w-5 h-5 text-muted-foreground" />
        </button>
      </div>

      {/* Profile Card */}
      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-card rounded-4xl p-6 shadow-soft mb-4 flex items-center gap-5"
      >
        <motion.button
          whileTap={{ scale: 0.9 }}
          onClick={onOpenBreedPicker}
          className="relative"
        >
          <img src={breed.image} alt={breed.name} className="w-16 h-16 object-contain" />
          <div className="absolute -bottom-1 -right-1 w-5 h-5 bg-primary rounded-full flex items-center justify-center">
            <span className="text-primary-foreground text-[10px]">✏️</span>
          </div>
        </motion.button>
        <div>
          <p className="font-bold text-lg">바우 돌보미</p>
          <p className="text-sm text-muted-foreground">Lv.{level} · {breed.name}</p>
        </div>
      </motion.div>

      {/* User Info Card */}
      {profile.age && (
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.05 }}
          className="bg-card rounded-3xl p-4 shadow-soft mb-6"
        >
          <div className="grid grid-cols-2 gap-3 text-sm">
            <div>
              <p className="text-xs text-muted-foreground">나이</p>
              <p className="font-medium text-foreground">{profile.age}</p>
            </div>
            <div>
              <p className="text-xs text-muted-foreground">성별</p>
              <p className="font-medium text-foreground">{profile.gender}</p>
            </div>
            {profile.livingArea && (
              <div>
                <p className="text-xs text-muted-foreground">사는 곳</p>
                <p className="font-medium text-foreground">{profile.livingArea}</p>
              </div>
            )}
            {profile.activityArea && (
              <div>
                <p className="text-xs text-muted-foreground">활동 지역</p>
                <p className="font-medium text-foreground">{profile.activityArea}</p>
              </div>
            )}
            {profile.marriage && (
              <div>
                <p className="text-xs text-muted-foreground">결혼 여부</p>
                <p className="font-medium text-foreground">{profile.marriage}</p>
              </div>
            )}
            {profile.hasChildren && (
              <div>
                <p className="text-xs text-muted-foreground">자녀</p>
                <p className="font-medium text-foreground">{profile.hasChildren}</p>
              </div>
            )}
          </div>
          <button
            onClick={onOpenProfileEditor}
            className="mt-3 text-xs text-primary font-medium"
          >
            정보 수정하기 →
          </button>
        </motion.div>
      )}

      {/* Stats Grid */}
      <div className="grid grid-cols-2 gap-4 mb-8">
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="bg-primary/10 rounded-3xl p-5"
        >
          <p className="text-xs text-muted-foreground">기부한 사료</p>
          <p className="text-2xl font-bold font-mono-nums mt-2">
            {totalDonatedKg}
            <span className="text-sm font-normal text-muted-foreground ml-1">kg</span>
          </p>
          <p className="text-xs text-primary mt-1">🐾 바우 {Math.floor(totalDonatedKg / 0.5)}끼 분량</p>
        </motion.div>
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.15 }}
          className="bg-secondary/20 rounded-3xl p-5"
        >
          <p className="text-xs text-muted-foreground">총 적립 포인트</p>
          <p className="text-2xl font-bold font-mono-nums mt-2">
            {mileage.toLocaleString()}
            <span className="text-sm font-normal text-primary ml-1">P</span>
          </p>
          <p className="text-xs text-muted-foreground mt-1">이번 달 활동</p>
        </motion.div>
      </div>

      {/* Scan History */}
      <h2 className="text-lg font-bold mb-4">최근 영수증 기록</h2>
      <div className="space-y-3 pb-4">
        {scanHistory.map((item, i) => (
          <motion.div
            key={i}
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.2 + i * 0.05 }}
            className="bg-card rounded-2xl p-4 shadow-soft flex items-center justify-between"
          >
            <div>
              <p className="font-medium text-sm text-foreground">{item.store}</p>
              <p className="text-xs text-muted-foreground">{item.date}</p>
            </div>
            <span className="font-bold font-mono-nums text-primary">+{item.amount}P</span>
          </motion.div>
        ))}
      </div>
    </div>
  );
};

export default MyPage;

