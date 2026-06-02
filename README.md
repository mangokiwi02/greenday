# GreenDay — 비건 챌린지 & 레시피 iOS 앱

> 매일 하나의 비건 레시피로 시작하는 작은 습관, 지구를 위한 큰 변화

---

## 📱 데모 영상

[![GreenDay 앱 데모](https://img.youtube.com/vi/DB6aVJ1IV1k/0.jpg)](https://youtube.com/shorts/DB6aVJ1IV1k?feature=share)

> 위 이미지를 클릭하면 시연 영상으로 이동해요.

---

##  프로젝트 개요

**GreenDay**는 비건 식단에 관심은 있지만 어디서부터 시작해야 할지 모르는 사람들을 위해 기획한 iOS 앱이에요.

사용자가 자신의 비건 단계를 선택하면, 매일 하나의 레시피를 달력 형태로 제안해요. 챌린지를 꾸준히 달성할수록 CO₂ 절감량이 쌓이는 구조를 통해 환경에 기여한다는 동기 부여도 함께 제공해요.

외부 API나 LLM 없이 로컬 JSON 데이터만으로 동작하기 때문에, 별도 설정 없이 바로 실행할 수 있어요.

---

##  주요 기능

| 기능 | 설명 |
|---|---|
| 비건 단계 설정 | 플렉시테리언 / 베지테리언 / 비건 중 선택 |
| 달력 챌린지 | 날짜별 레시피 배정, 완료 체크 시 초록 표시 |
| 오늘의 레시피 | 칼로리, 영양 정보, CO₂ 절감량 표시 |
| 레시피 목록 | 카테고리 필터링 + 검색 기능 |
| 즐겨찾기 | 하트 탭으로 저장, 프로필에서 모아보기 |
| CO₂ 트래킹 | 누적 절감량을 나무 그루 수로 환산해 표시 |
| 스트릭 & 통계 | 연속 달성 일수, 주간/전체 달성률 |

---

##  기술 스택

- **언어**: Swift 5.0
- **UI 프레임워크**: SwiftUI
- **데이터 저장**: UserDefaults + Codable
- **레시피 데이터**: 로컬 JSON (30개 레시피)
- **최소 지원 버전**: iOS 14.0
- **개발 환경**: Xcode 13

---

## 📁 프로젝트 구조

```
greenday/
├── App/
│   └── GreendayApp.swift
├── Models/
│   ├── VeganLevel.swift
│   ├── Recipe.swift
│   ├── ChallengeRecord.swift
│   └── FavoriteRecipe.swift
├── ViewModels/
│   ├── ChallengeViewModel.swift
│   └── RecipeViewModel.swift
├── Utilities/
│   └── RecipeAssigner.swift
├── Resources/
│   └── recipes.json
└── Views/
    ├── Onboarding/
    ├── Home/
    ├── Calendar/
    ├── Recipe/
    └── Profile/
```

---

##  핵심 알고리즘 — 날짜별 레시피 배정

LLM 없이 매일 다른 레시피를 결정하는 방식으로, 날짜를 시드로 사용해 항상 같은 날에는 같은 레시피가 나오도록 했어요.

```swift
func recipe(for date: Date, veganLevel: VeganLevel, from recipes: [Recipe]) -> Recipe? {
    let filtered = recipes.filter { $0.veganLevel.rawValue >= veganLevel.rawValue }
    guard !filtered.isEmpty else { return nil }
    let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
    return filtered[dayOfYear % filtered.count]
}
```

---

##  실행 방법

```
1. 프로젝트 클론 또는 압축 해제
2. greenday.xcodeproj 실행
3. 시뮬레이터 또는 실기기 선택
4. Cmd + R 빌드 및 실행
```

별도 API 키나 외부 설정이 필요 없어요.

---

##  화면 구성

| 화면 | 설명 |
|---|---|
| 온보딩 | 비건 단계 선택 → 챌린지 기간 설정 |
| 홈 | 스트릭, CO₂ 기여, 오늘의 레시피 |
| 달력 | 월간 달력 + 날짜별 완료 현황 |
| 레시피 | 전체 목록 검색 + 카테고리 필터 |
| 프로필 | 통계, 즐겨찾기, 단계 변경 |

---

## CO₂ 절감량 기준

- 소고기 기반 동일 열량 식사 대비 탄소 절감량 기준
- 나무 1그루 = 연간 CO₂ 흡수량 약 **54kg** 기준으로 환산

---

## 개발자

| | |
|---|---|
| 이름 | 임창수 |
| 개발 기간 | 2026년 5,6월 |
| 유형 | iOS 개인 토이 프로젝트 |
