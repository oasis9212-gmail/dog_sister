import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import bowwowImg from "@/assets/bowwow-character.png";

interface OnboardingTutorialProps {
  isOpen: boolean;
  onClose: () => void;
}

const tutorialSteps = [
  {
    emoji: "📸",
    title: "영수증 인증 방법",
    message: "안녕! 나는 바우야 🐾\n영수증 인증 방법을 알려줄게!",
    rules: [
      "결제 후 2주 이내에 영수증을 촬영해야 해요",
      "2주가 지난 영수증은 인증이 불가능해요",
    ],
  },
  {
    emoji: "🏪",
    title: "매장별 규칙",
    message: "매장마다 규칙이 있어!",
    rules: [
      "한 매장당 하루 1회만 인증 가능해요",
      "올리브영, CGV, 백화점 등 대기업 매장은 마일리지 적립이 안돼요",
      "소상공인·동네 가게를 응원해주세요! 💪",
    ],
  },
  {
    emoji: "💰",
    title: "적립 규칙",
    message: "마일리지 적립 기준이야!",
    rules: [
      "1만원 이상 결제한 영수증만 인증 가능해요",
      "15만원 이상은 동일한 마일리지가 적립돼요",
      "결제 금액의 3%가 마일리지로 적립돼요",
      "예: 5만원 결제 → 1,500P 적립!",
    ],
  },
];

const OnboardingTutorial = ({ isOpen, onClose }: OnboardingTutorialProps) => {
  const [step, setStep] = useState(0);

  const handleNext = () => {
    if (step < tutorialSteps.length - 1) setStep(step + 1);
    else {
      onClose();
      setStep(0);
    }
  };

  const current = tutorialSteps[step];

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-50 bg-background flex flex-col max-w-md mx-auto left-0 right-0"
        >
          {/* Dog character */}
          <div className="flex-1 flex flex-col items-center justify-center px-5">
            <motion.img
              src={bowwowImg}
              alt="바우"
              className="w-32 h-32 object-contain mb-6"
              animate={{ y: [0, -8, 0] }}
              transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
            />

            {/* Speech bubble */}
            <motion.div
              key={step}
              initial={{ opacity: 0, y: 20, scale: 0.95 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              className="bg-card rounded-3xl p-6 shadow-soft w-full max-w-sm relative"
            >
              <div className="absolute -top-3 left-1/2 -translate-x-1/2 w-6 h-6 bg-card rotate-45 rounded-sm" />
              <div className="flex items-center gap-2 mb-3">
                <span className="text-2xl">{current.emoji}</span>
                <h3 className="font-bold text-lg text-foreground">{current.title}</h3>
              </div>
              <p className="text-sm text-muted-foreground whitespace-pre-line mb-4">
                {current.message}
              </p>
              <div className="space-y-2">
                {current.rules.map((rule, i) => (
                  <div key={i} className="flex items-start gap-2">
                    <span className="text-primary text-sm mt-0.5">•</span>
                    <p className="text-sm text-foreground leading-relaxed">{rule}</p>
                  </div>
                ))}
              </div>
            </motion.div>
          </div>

          {/* Step indicator + button */}
          <div className="px-5 pb-10">
            <div className="flex justify-center gap-2 mb-6">
              {tutorialSteps.map((_, i) => (
                <div
                  key={i}
                  className={`w-2 h-2 rounded-full transition-colors ${
                    i === step ? "bg-primary" : "bg-muted"
                  }`}
                />
              ))}
            </div>
            <div className="flex gap-3">
              <button
                onClick={() => { onClose(); setStep(0); }}
                className="flex-1 py-3.5 rounded-2xl bg-muted text-muted-foreground text-sm font-bold"
              >
                건너뛰기
              </button>
              <button
                onClick={handleNext}
                className="flex-1 py-3.5 rounded-2xl bg-primary text-primary-foreground text-sm font-bold shadow-coral"
              >
                {step === tutorialSteps.length - 1 ? "시작하기! 🐾" : "다음"}
              </button>
            </div>
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default OnboardingTutorial;