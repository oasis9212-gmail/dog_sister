import { motion, AnimatePresence } from "framer-motion";
import { X, Lock, Check } from "lucide-react";
import { dogBreeds, type DogBreed } from "@/lib/dogBreeds";

interface BreedPickerProps {
  isOpen: boolean;
  onClose: () => void;
  currentBreedId: string;
  userLevel: number;
  mileage: number;
  unlockedBreeds: string[];
  onSelectBreed: (breedId: string) => void;
  onUnlockBreed: (breedId: string, cost: number) => void;
}

const BreedPicker = ({
  isOpen,
  onClose,
  currentBreedId,
  userLevel,
  mileage,
  unlockedBreeds,
  onSelectBreed,
  onUnlockBreed,
}: BreedPickerProps) => {
  const handleBreedTap = (breed: DogBreed) => {
    if (unlockedBreeds.includes(breed.id)) {
      onSelectBreed(breed.id);
      onClose();
      return;
    }
    if (userLevel >= breed.unlockLevel && mileage >= breed.unlockCost) {
      onUnlockBreed(breed.id, breed.unlockCost);
    }
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-50 flex items-end justify-center max-w-md mx-auto left-0 right-0"
        >
          <div className="absolute inset-0 bg-foreground/40" onClick={onClose} />
          <motion.div
            initial={{ y: "100%" }}
            animate={{ y: 0 }}
            exit={{ y: "100%" }}
            transition={{ type: "spring", damping: 25, stiffness: 300 }}
            className="relative w-full bg-background rounded-t-[2rem] max-h-[80vh] overflow-hidden"
          >
            {/* Header */}
            <div className="flex items-center justify-between px-5 py-4 border-b border-border">
              <h3 className="text-lg font-bold">나만의 강아지 선택</h3>
              <button onClick={onClose} className="w-8 h-8 rounded-full bg-muted flex items-center justify-center">
                <X className="w-4 h-4 text-muted-foreground" />
              </button>
            </div>

            {/* Grid */}
            <div className="p-5 overflow-y-auto max-h-[65vh] grid grid-cols-3 gap-3">
              {dogBreeds.map((breed) => {
                const isUnlocked = unlockedBreeds.includes(breed.id);
                const canUnlock = userLevel >= breed.unlockLevel && mileage >= breed.unlockCost;
                const isCurrent = currentBreedId === breed.id;

                return (
                  <motion.button
                    key={breed.id}
                    whileTap={{ scale: 0.95 }}
                    onClick={() => handleBreedTap(breed)}
                    className={`relative flex flex-col items-center gap-2 p-3 rounded-2xl transition-all ${
                      isCurrent
                        ? "bg-primary/10 ring-2 ring-primary"
                        : isUnlocked
                        ? "bg-card shadow-soft"
                        : canUnlock
                        ? "bg-card shadow-soft opacity-90"
                        : "bg-muted opacity-50"
                    }`}
                  >
                    {isCurrent && (
                      <div className="absolute top-1 right-1 w-5 h-5 bg-primary rounded-full flex items-center justify-center">
                        <Check className="w-3 h-3 text-primary-foreground" />
                      </div>
                    )}
                    {!isUnlocked && (
                      <div className="absolute top-1 right-1 w-5 h-5 bg-muted-foreground/30 rounded-full flex items-center justify-center">
                        <Lock className="w-3 h-3 text-muted-foreground" />
                      </div>
                    )}
                    <img
                      src={breed.image}
                      alt={breed.name}
                      className={`w-14 h-14 object-contain ${!isUnlocked ? "grayscale" : ""}`}
                    />
                    <span className="text-xs font-medium text-foreground text-center leading-tight">{breed.name}</span>
                    {!isUnlocked && (
                      <span className="text-[10px] text-muted-foreground">
                        Lv.{breed.unlockLevel} · {breed.unlockCost}P
                      </span>
                    )}
                  </motion.button>
                );
              })}
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default BreedPicker;
