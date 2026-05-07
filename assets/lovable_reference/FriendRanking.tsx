import { motion } from "framer-motion";
import { Trophy, Medal, Crown, ChevronRight } from "lucide-react";
import { dogBreeds, getBreedById } from "@/lib/dogBreeds";

interface Friend {
  id: string;
  name: string;
  level: number;
  breedId: string;
  totalPoints: number;
}

interface FriendRankingProps {
  userLevel: number;
  userBreedId: string;
}

const mockFriends: Friend[] = [
  { id: "1", name: "김민지", level: 8, breedId: "husky", totalPoints: 12400 },
  { id: "2", name: "이서준", level: 7, breedId: "golden", totalPoints: 9800 },
  { id: "3", name: "박지유", level: 6, breedId: "corgi", totalPoints: 8200 },
  { id: "me", name: "나 (바우 돌보미)", level: 3, breedId: "bowwow", totalPoints: 3240 },
  { id: "4", name: "최윤서", level: 5, breedId: "shiba", totalPoints: 6100 },
  { id: "5", name: "정하준", level: 4, breedId: "maltese", totalPoints: 4500 },
  { id: "6", name: "강예린", level: 3, breedId: "bichon", totalPoints: 3100 },
  { id: "7", name: "오지호", level: 2, breedId: "beagle", totalPoints: 1800 },
];

const levelRewards: Record<number, string> = {
  3: "🎁 Lv.3 달성! 500P 보너스",
  5: "🎁 Lv.5 달성! 새 품종 해금",
  7: "🎁 Lv.7 달성! 1000P 보너스",
  10: "🎁 Lv.10 달성! 특별 캐릭터 해금",
};

const getRankIcon = (rank: number) => {
  if (rank === 1) return <Crown className="w-5 h-5 text-primary" />;
  if (rank === 2) return <Medal className="w-5 h-5 text-muted-foreground" />;
  if (rank === 3) return <Medal className="w-5 h-5 text-primary/70" />;
  return <span className="text-sm font-bold text-muted-foreground w-5 text-center">{rank}</span>;
};

const FriendRanking = ({ userLevel, userBreedId }: FriendRankingProps) => {
  const sorted = [...mockFriends]
    .map((f) => (f.id === "me" ? { ...f, level: userLevel, breedId: userBreedId } : f))
    .sort((a, b) => b.level - a.level || b.totalPoints - a.totalPoints);

  const myRank = sorted.findIndex((f) => f.id === "me") + 1;

  return (
    <div className="px-5 pt-14">
      <h1 className="text-2xl font-bold mb-2">바우 친구 랭킹</h1>
      <p className="text-muted-foreground text-sm mb-6">친구들과 함께 레벨을 올려보세요!</p>

      {/* My rank banner */}
      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-primary/10 rounded-3xl p-5 mb-6 flex items-center gap-4"
      >
        <div className="w-14 h-14 rounded-full bg-primary/20 flex items-center justify-center">
          <Trophy className="w-7 h-7 text-primary" />
        </div>
        <div className="flex-1">
          <p className="text-sm text-muted-foreground">내 현재 순위</p>
          <p className="text-2xl font-bold font-mono-nums">
            {myRank}위 <span className="text-sm font-normal text-muted-foreground">/ {sorted.length}명</span>
          </p>
        </div>
        <img src={getBreedById(userBreedId).image} alt="내 강아지" className="w-12 h-12 object-contain" />
      </motion.div>

      {/* Level-up rewards */}
      {levelRewards[userLevel] && (
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          className="bg-secondary/20 rounded-2xl p-4 mb-6 text-center"
        >
          <p className="text-sm font-bold text-secondary-foreground">{levelRewards[userLevel]}</p>
        </motion.div>
      )}

      {/* Friend list */}
      <div className="space-y-3">
        {sorted.map((friend, i) => {
          const breed = getBreedById(friend.breedId);
          const isMe = friend.id === "me";
          return (
            <motion.div
              key={friend.id}
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: i * 0.04 }}
              className={`flex items-center gap-3 p-4 rounded-2xl shadow-soft ${
                isMe ? "bg-primary/5 ring-2 ring-primary/30" : "bg-card"
              }`}
            >
              <div className="w-6 flex justify-center">{getRankIcon(i + 1)}</div>
              <img src={breed.image} alt={breed.name} className="w-10 h-10 object-contain" />
              <div className="flex-1 min-w-0">
                <p className={`font-medium text-sm truncate ${isMe ? "text-primary font-bold" : "text-foreground"}`}>
                  {friend.name}
                </p>
                <p className="text-xs text-muted-foreground">Lv.{friend.level} · {breed.name}</p>
              </div>
              <div className="text-right">
                <p className="text-sm font-bold font-mono-nums text-foreground">{friend.totalPoints.toLocaleString()}P</p>
              </div>
            </motion.div>
          );
        })}
      </div>

      {/* Next level hint */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.5 }}
        className="mt-6 mb-4 bg-muted rounded-2xl p-4 flex items-center gap-3"
      >
        <span className="text-xl">💡</span>
        <p className="text-xs text-muted-foreground flex-1">
          영수증을 더 스캔하면 레벨이 올라가요! 다음 레벨까지 500P 남았어요
        </p>
        <ChevronRight className="w-4 h-4 text-muted-foreground" />
      </motion.div>
    </div>
  );
};

export default FriendRanking;
