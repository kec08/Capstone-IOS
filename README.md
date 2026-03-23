# 집착 (ZipChak) - AI 전월세 안심 거래 도우미

<p align="center">
  <img src="JeepChak/Assets.xcassets/Splash/splash_logo.imageset/splash_logo.png" alt="집착 로고" width="120"/>
</p>

<p align="center">
  <strong>"집에 착하게 살자" - 안전한 전월세 거래를 위한 AI 부동산 분석 앱</strong>
</p>

<p align="center">
  <a href="https://apps.apple.com/kr/app/%EC%A7%91%EC%B0%A9/id6757211728">
    <img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="App Store" height="40"/>
  </a>
</p>

---

## 소개

**집착**은 전월세 사기를 예방하고 안전한 주거 환경을 도와주는 iOS 앱입니다.

AI 기반의 매물 위험도 분석, 체크리스트 자동 생성, 대출 가이드 등 전월세 거래에 필요한 핵심 기능을 제공합니다.

## 주요 기능

### 1. AI 매물 분석
- 등기부등본 등 서류를 업로드하면 AI가 매물의 위험 요소를 자동 분석
- 위험도 점수 산출 및 항목별 상세 리포트 제공
- 위험 요소에 대한 대처 방안 제시

### 2. AI 체크리스트
- 매물 정보를 기반으로 AI가 점검 체크리스트를 자동 생성
- 심각도 분류 (안전 / 보통 / 주의 / 위험)
- 항목별 메모 기능으로 현장 점검 시 활용 가능

### 3. 지도
- 네이버 지도 기반 매물 위치 탐색
- 매물 유형별 필터링 및 검색
- 매물 상세 정보 바텀시트 제공

### 4. 대출 가이드
- 단계별 입력을 통한 대출 자격 조회
- 개인 상황에 맞는 대출 상품 안내

### 5. 마이페이지
- 회원 정보 조회
- 등록한 매물 관리

## 기술 스택

| 분류 | 기술 |
|------|------|
| **UI** | SwiftUI |
| **아키텍처** | MVVM |
| **상태관리** | Combine, @StateObject, @EnvironmentObject |
| **네트워킹** | Moya + Alamofire |
| **지도** | Naver Maps SDK (NMapsMap) |
| **인증** | JWT (Access Token + Refresh Token) |
| **빌드** | CocoaPods |
| **최소 지원** | iOS 16.0+ |

## 프로젝트 구조

```
JeepChak/
├── App/                        # 앱 진입점 및 네비게이션
│   ├── JeepChakApp.swift       # @main 엔트리
│   ├── RootView.swift          # 인증 상태 기반 라우팅
│   ├── AppState.swift          # 앱 전역 상태 관리
│   └── MainTabView.swift       # 탭 네비게이션 (5탭)
│
├── Feature/                    # 기능별 모듈
│   ├── Home/                   # 홈 화면
│   ├── Analyze/                # AI 매물 분석
│   ├── Map/                    # 네이버 지도 매물 탐색
│   ├── CheckList/              # AI 체크리스트
│   ├── LoanGuide/              # 대출 가이드
│   ├── Property/               # 매물 등록
│   ├── Saved/                  # 매물 관리
│   ├── My/                     # 마이페이지
│   ├── Login/                  # 로그인
│   ├── SignUp/                 # 회원가입
│   └── Splash/                 # 스플래시
│
├── Model/                      # 데이터 레이어
│   └── Core/Network/
│       ├── API/                # API 정의 (Moya TargetType)
│       ├── Service/            # 서비스 레이어
│       └── APIModel/           # DTO (Request/Response)
│
└── Assets.xcassets/            # 이미지 및 컬러 리소스
```

## 아키텍처

```
┌─────────────┐
│    View      │  SwiftUI 화면
├─────────────┤
│  ViewModel   │  비즈니스 로직 + 상태 관리 (@Published)
├─────────────┤
│   Service    │  API 호출 (Combine Publisher 반환)
├─────────────┤
│  API (Moya)  │  엔드포인트 정의 + DTO
├─────────────┤
│   Backend    │  Spring Boot 서버
└─────────────┘
```

각 Feature 모듈은 **View → ViewModel → Service → API** 흐름으로 구성되어 있으며, Combine의 `AnyPublisher`를 통해 비동기 데이터를 처리합니다.

## 실행 방법

### 사전 요구사항
- Xcode 15.0+
- CocoaPods
- iOS 16.0+ 디바이스 또는 시뮬레이터

### 빌드 & 실행

```bash
# 1. 저장소 클론
git clone https://github.com/your-repo/Capstone-IOS.git
cd Capstone-IOS

# 2. Pod 설치
pod install

# 3. 워크스페이스 열기 (.xcworkspace로 열어야 합니다)
open JeepChak.xcworkspace
```

> **참고:** `.xcodeproj`가 아닌 `.xcworkspace`로 프로젝트를 열어야 CocoaPods 의존성이 정상적으로 로드됩니다.

## 탭 구성

| 탭 | 아이콘 | 설명 |
|----|--------|------|
| 홈 | 🏠 | 매물 검색 및 추천 |
| 매물 분석 | 🔍 | AI 기반 전월세 위험도 분석 |
| 지도 | 🗺️ | 네이버 지도 매물 탐색 |
| 체크리스트 | ✅ | AI 자동 점검 체크리스트 |
| 마이 | 👤 | 회원 정보 및 매물 관리 |

## 팀 정보

캡스톤 디자인 프로젝트로 개발되었습니다.

---

<p align="center">
  <a href="https://apps.apple.com/kr/app/%EC%A7%91%EC%B0%A9/id6757211728">App Store에서 다운로드</a>
</p>
