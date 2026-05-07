int moneyToMileagePoints(int amountWon) {
  if (amountWon <= 0) return 0;

  const int thresholdWon = 150000; // 15만원 이상이면 일정금액
  const int capPoints = 4500; // 1회 적립 최대

  final int points;
  if (amountWon >= thresholdWon) {
    points = capPoints;
  } else {
    // 0.03% = 0.0003, 내림(floor)
    points = (amountWon * 0.0003).floor();
  }

  if (points < 0) return 0;
  if (points > capPoints) return capPoints;
  return points;
}

