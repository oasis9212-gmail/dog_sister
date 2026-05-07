import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { X, ChevronRight } from "lucide-react";

export interface UserProfile {
  age: string;
  gender: string;
  livingArea: string;
  activityArea: string;
  marriage: string;
  hasChildren: string;
}

const defaultProfile: UserProfile = {
  age: "",
  gender: "",
  livingArea: "",
  activityArea: "",
  marriage: "",
  hasChildren: "",
};

interface ProfileEditorProps {
  isOpen: boolean;
  onClose: () => void;
  profile: UserProfile;
  onSave: (profile: UserProfile) => void;
  isFirstTime?: boolean;
}

const ageOptions = ["10대", "20대", "30대", "40대", "50대", "60대 이상"];
const genderOptions = ["남성", "여성", "기타"];
const marriageOptions = ["미혼", "기혼", "기타"];
const childrenOptions = ["없음", "1명", "2명", "3명 이상"];

const ProfileEditor = ({ isOpen, onClose, profile, onSave, isFirstTime }: ProfileEditorProps) => {
  const [step, setStep] = useState(0);
  const [form, setForm] = useState<UserProfile>({ ...defaultProfile, ...profile });

  const handleSelect = (field: keyof UserProfile, value: string) => {
    setForm((prev) => ({ ...prev, [field]: value }));
  };

  const handleNext = () => {
    if (step < 2) setStep(step + 1);
    else {
      onSave(form);
      onClose();
      setStep(0);
    }
  };

  const handleSkip = () => {
    onSave(form);
    onClose();
    setStep(0);
  };

  const canProceed = () => {
    if (step === 0) return form.age !== "" && form.gender !== "";
    if (step === 1) return form.livingArea.trim() !== "" && form.activityArea.trim() !== "";
    return true;
  };

  const steps = [
    {
      title: "기본 정보",
      subtitle: "나이와 성별을 알려주세요",
      content: (
        <div className="space-y-6">
          <div>
            <p className="text-sm font-medium text-foreground mb-3">나이</p>
            <div className="grid grid-cols-3 gap-2">
              {ageOptions.map((opt) => (
                <button
                  key={opt}
                  onClick={() => handleSelect("age", opt)}
                  className={`py-3 rounded-2xl text-sm font-medium transition-all ${
                    form.age === opt
                      ? "bg-primary text-primary-foreground shadow-coral"
                      : "bg-card shadow-soft text-foreground"
                  }`}
                >
                  {opt}
                </button>
              ))}
            </div>
          </div>
          <div>
            <p className="text-sm font-medium text-foreground mb-3">성별</p>
            <div className="grid grid-cols-3 gap-2">
              {genderOptions.map((opt) => (
                <button
                  key={opt}
                  onClick={() => handleSelect("gender", opt)}
                  className={`py-3 rounded-2xl text-sm font-medium transition-all ${
                    form.gender === opt
                      ? "bg-primary text-primary-foreground shadow-coral"
                      : "bg-card shadow-soft text-foreground"
                  }`}
                >
                  {opt}
                </button>
              ))}
            </div>
          </div>
        </div>
      ),
    },
    {
      title: "활동 지역",
      subtitle: "사는 곳과 주로 활동하는 곳을 알려주세요",
      content: (
        <div className="space-y-5">
          <div>
            <p className="text-sm font-medium text-foreground mb-2">사는 곳</p>
            <input
              value={form.livingArea}
              onChange={(e) => handleSelect("livingArea", e.target.value)}
              placeholder="예: 서울 강남구"
              className="w-full bg-card shadow-soft rounded-2xl px-4 py-3 text-sm text-foreground placeholder:text-muted-foreground outline-none focus:ring-2 focus:ring-primary"
            />
          </div>
          <div>
            <p className="text-sm font-medium text-foreground mb-2">활동하는 곳</p>
            <input
              value={form.activityArea}
              onChange={(e) => handleSelect("activityArea", e.target.value)}
              placeholder="예: 서울 홍대, 강남"
              className="w-full bg-card shadow-soft rounded-2xl px-4 py-3 text-sm text-foreground placeholder:text-muted-foreground outline-none focus:ring-2 focus:ring-primary"
            />
          </div>
        </div>
      ),
    },
    {
      title: "추가 정보 (선택)",
      subtitle: "결혼 정보와 자녀 유무를 알려주세요",
      content: (
        <div className="space-y-6">
          <div>
            <p className="text-sm font-medium text-foreground mb-3">결혼 여부</p>
            <div className="grid grid-cols-3 gap-2">
              {marriageOptions.map((opt) => (
                <button
                  key={opt}
                  onClick={() => handleSelect("marriage", opt)}
                  className={`py-3 rounded-2xl text-sm font-medium transition-all ${
                    form.marriage === opt
                      ? "bg-primary text-primary-foreground shadow-coral"
                      : "bg-card shadow-soft text-foreground"
                  }`}
                >
                  {opt}
                </button>
              ))}
            </div>
          </div>
          <div>
            <p className="text-sm font-medium text-foreground mb-3">자녀 유무</p>
            <div className="grid grid-cols-4 gap-2">
              {childrenOptions.map((opt) => (
                <button
                  key={opt}
                  onClick={() => handleSelect("hasChildren", opt)}
                  className={`py-3 rounded-2xl text-sm font-medium transition-all ${
                    form.hasChildren === opt
                      ? "bg-primary text-primary-foreground shadow-coral"
                      : "bg-card shadow-soft text-foreground"
                  }`}
                >
                  {opt}
                </button>
              ))}
            </div>
          </div>
        </div>
      ),
    },
  ];

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-50 flex items-end justify-center max-w-md mx-auto left-0 right-0"
        >
          <div className="absolute inset-0 bg-foreground/40" onClick={!isFirstTime ? onClose : undefined} />
          <motion.div
            initial={{ y: "100%" }}
            animate={{ y: 0 }}
            exit={{ y: "100%" }}
            transition={{ type: "spring", damping: 25, stiffness: 300 }}
            className="relative w-full bg-background rounded-t-[2rem] overflow-hidden"
          >
            {/* Header */}
            <div className="flex items-center justify-between px-5 py-4 border-b border-border">
              <div>
                <h3 className="text-lg font-bold">{steps[step].title}</h3>
                <p className="text-xs text-muted-foreground">{steps[step].subtitle}</p>
              </div>
              {!isFirstTime && (
                <button onClick={onClose} className="w-8 h-8 rounded-full bg-muted flex items-center justify-center">
                  <X className="w-4 h-4 text-muted-foreground" />
                </button>
              )}
            </div>

            {/* Step indicator */}
            <div className="flex gap-2 px-5 pt-4">
              {[0, 1, 2].map((i) => (
                <div
                  key={i}
                  className={`h-1 flex-1 rounded-full transition-colors ${
                    i <= step ? "bg-primary" : "bg-muted"
                  }`}
                />
              ))}
            </div>

            {/* Content */}
            <div className="px-5 py-6">{steps[step].content}</div>

            {/* Buttons */}
            <div className="px-5 pb-10 flex gap-3">
              {step > 0 && (
                <button
                  onClick={() => setStep(step - 1)}
                  className="flex-1 py-3 rounded-2xl bg-muted text-muted-foreground text-sm font-bold"
                >
                  이전
                </button>
              )}
              {step === 2 && (
                <button
                  onClick={handleSkip}
                  className="flex-1 py-3 rounded-2xl bg-muted text-muted-foreground text-sm font-bold"
                >
                  건너뛰기
                </button>
              )}
              <button
                onClick={handleNext}
                disabled={!canProceed()}
                className={`flex-1 py-3 rounded-2xl text-sm font-bold flex items-center justify-center gap-1 transition-all ${
                  canProceed()
                    ? "bg-primary text-primary-foreground shadow-coral"
                    : "bg-muted text-muted-foreground"
                }`}
              >
                {step === 2 ? "완료" : "다음"}
                {step < 2 && <ChevronRight className="w-4 h-4" />}
              </button>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export { defaultProfile };
export default ProfileEditor;
