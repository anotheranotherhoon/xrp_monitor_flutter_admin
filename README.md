# XRP Monitor Flutter Admin

XRP Monitor 시스템의 관리자 웹 대시보드입니다. 사용자, 키워드, 버전,
팝업 관리 및 시스템 모니터링 기능을 제공합니다.

## 🔗 Links

- **Admin Dashboard**: https://xrp-monitor.p-e.kr
- **API Server**: https://xrp-monitor.p-e.kr
- **API Documentation (Swagger)**: https://xrp-monitor.p-e.kr/docs

## 🧑‍💼 Test Admin Account

```
Email: superadmin@xrpmonitor.com
Password: superadmin123
```

## 🚀 Getting Started

### Prerequisites

- **FVM (Flutter Version Manager)**: 프로젝트는 FVM을 통해 Flutter 버전을 관리합니다
- **Node.js & npm**: Git hooks (commitlint, husky) 사용을 위해 필요합니다

### Installation

1. **저장소 클론**
```bash
git clone <repository-url>
cd xrp_monitor_flutter_admin
```

2. **프로젝트 초기 설정**
```bash
./configure.sh
```
이 명령어는 다음을 수행합니다:
- Git submodule 초기화 및 업데이트
- Flutter 클린
- 의존성 설치 (flutter pub get)
- 코드 생성 (build_runner)

### Development

**개발 서버 실행**
```bash
fvm flutter run -d chrome --web-port 8080
```

로컬 NestJS 서버의 최신 코드를 바로 확인하려면 서버를 먼저 실행합니다.

```bash
# xrp_monitor_nest_server
npm run start:dev

# xrp_monitor_flutter_admin
fvm flutter run -d chrome --web-port 8080
```

Debug/Profile 실행은 `http://localhost:3000`, Release 빌드는
`https://xrp-monitor.p-e.kr`을 자동으로 사용합니다.

로컬 DB에도 관리자 계정이 있어야 로그인할 수 있습니다. NestJS 저장소에서
다음 명령을 실행하면 기본 슈퍼관리자를 생성하거나 기존 계정을 갱신합니다.

```bash
npm run create-super-admin
```

**코드 생성기 (권장: 별도 터미널에서 실행)**
```bash
./code_generator.sh
```
개발 중에는 watch 모드로 코드 생성기를 실행하여 자동으로 코드가 생성되도록 하는 것을 권장합니다.

### Build

**프로덕션 빌드**
```bash
fvm flutter build web
```

빌드된 파일은 `build/web/` 디렉토리에 생성됩니다.

### Cleanup

**생성된 파일 삭제**
```bash
./clean.sh
```
모든 생성된 파일 (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`)을 삭제합니다.

**전체 클린**
```bash
fvm flutter clean
```

## 🏗️ Tech Stack

### Core Framework
- **Flutter Web** (3.x)
- **Dart** (3.7.2+)

### State Management & Code Generation
- **Riverpod 2.6.x**: 상태 관리 및 의존성 주입
  - `flutter_riverpod`, `hooks_riverpod`, `riverpod_annotation`
  - `@riverpod` 어노테이션 기반 코드 생성
- **Freezed 3.x**: 불변 모델 및 유니온 타입
- **JSON Serialization**: API 모델 직렬화/역직렬화
- **build_runner**: 코드 생성 도구

### Routing & Navigation
- **Auto Route 10.x**: 선언적 라우팅
  - `@AutoRouterConfig()` 및 `@RoutePage()` 어노테이션
  - 타입 세이프 네비게이션
  - 인증 가드 (AuthGuard)

### HTTP & API
- **Dio 5.x**: HTTP 클라이언트
  - JWT 토큰 자동 주입
  - 토큰 리프레시 인터셉터
  - 401 에러 자동 처리

### UI & Utilities
- **flutter_screenutil**: 반응형 디자인
- **flutter_hooks**: React-style hooks
- **flutter_html**: HTML 렌더링
- **intl**: 국제화 및 날짜 포맷팅

### Storage
- **shared_preferences**: 로컬 스토리지 (토큰 저장)
- **jwt_decoder**: JWT 토큰 디코딩

### File Upload
- **file_picker**: 팝업 이미지 선택
- **Dio FormData**: 인증 토큰을 포함한 이미지 multipart 업로드

### Dev Tools
- **commitlint & husky**: Git commit 메시지 검증
- **flutter_lints**: Dart/Flutter 린팅 규칙

## 📁 Project Structure

```
lib/
├── constants/              # 앱 전역 상수
├── core/
│   ├── constants/          # API 경로 및 환경 설정
│   │   └── api_path.dart   # 서버 환경 (dev/beta/prod)
│   ├── route/              # 라우팅 설정
│   │   ├── app_router.dart # 메인 라우터
│   │   └── auth_guard.dart # 인증 가드
│   └── services/           # 도메인 서비스 (API 클라이언트)
│       ├── base/           # 기본 API 인프라
│       ├── user/           # 사용자 관리
│       ├── keyword/        # 키워드 관리
│       ├── popup/          # 팝업 모델, API 서비스
│       └── version/        # 버전 관리
├── service/                # 애플리케이션 레벨 서비스
│   ├── authentication/     # 인증 상태 관리
│   └── storage/            # 로컬 스토리지
├── ui/
│   ├── layout/             # 레이아웃 컴포넌트
│   ├── screen/             # 화면 (auth, dashboard, user, etc.)
│   ├── themes/             # 테마 설정
│   └── utils/              # UI 유틸리티
├── utils/                  # 일반 유틸리티
└── widgets/                # 재사용 가능한 위젯
```

## 🖼️ Popup Management

- 관리자 메뉴에서 팝업 등록, 수정, 삭제, 활성화 상태 변경
- JPG, PNG, WebP 이미지 업로드 및 미리보기
- 최대 10개 팝업과 `1~10` 노출 순서 설정
- DatePicker와 TimePicker를 이용한 시작일/종료일 설정
- 날짜를 `yyyy-MM-dd HH:mm:ss`로 표시하고 API에는 UTC ISO 형식으로 전송
- 현재 시간에 따라 `노출 예정`, `노출 중`, `노출 종료`, `비활성` 상태 표시
- 이미지 클릭 동작을 라디오 버튼으로 `이동 없음` 또는 `외부 링크`로 설정
- 외부 링크 선택 시 `http://` 또는 `https://` URL 검증
- Debug/Profile은 로컬 API와 로컬 이미지 저장소, Release는 운영 API와 OCI
  Object Storage 사용

## 🔐 Authentication Flow

1. **로그인**: 이메일/비밀번호로 로그인하여 JWT 토큰 획득
2. **토큰 저장**: Access Token과 Refresh Token을 로컬 스토리지에 저장
3. **자동 주입**: `AuthInterceptor`가 모든 API 요청에 토큰을 자동으로 추가
4. **토큰 리프레시**: 401 에러 발생 시 자동으로 Refresh Token으로 갱신 시도
5. **자동 로그아웃**: 리프레시 실패 시 로그인 페이지로 리다이렉트

## 🎨 Commit Convention

이 프로젝트는 이모지 기반 커밋 컨벤션을 사용합니다:

```
<type>(optional scope): <subject>
```

**Types:**
- ✨ Feat: 새로운 기능
- 🐛 Fix: 버그 수정
- ⭐️ Style: 코드 포맷팅 (로직 변경 없음)
- ♻️ Refactor: 리팩토링
- 📁 File: 파일/에셋 추가
- 🎨 Design: UI/스타일 변경
- 🏷 Comment: 주석 추가/수정
- ✅ Test: 테스트 추가/수정
- 📝 Docs: 문서 수정
- 🚑 Hotfix: 긴급 버그 수정
- 🔥 Remove: 파일/코드 삭제
- 💚 Ci: CI/CD 변경
- 🔖 Release: 버전 릴리즈
- 🔧 Chore: 설정 변경

**예시:**
```bash
git commit -m "✨ Feat: 사용자 목록 조회 기능 추가"
git commit -m "🐛 Fix(auth): 토큰 갱신 버그 수정"
git commit -m "♻️ Refactor(user): 사용자 서비스 코드 개선"
```

## 🚀 Deployment

이 프로젝트는 GitHub Actions를 통해 자동으로 배포됩니다.

**Workflow**: `.github/workflows/deploy.yml`

**트리거**: `master` 브랜치에 push 시 자동 배포

**배포 단계**:
1. Flutter 환경 설정
2. 의존성 설치 (`flutter pub get`)
3. 코드 생성 (`dart run build_runner build`)
4. 웹 빌드 (`flutter build web`)
5. Oracle Cloud VM에 SSH를 통해 배포

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Auto Route Documentation](https://autoroute.vercel.app/)
- [Freezed Documentation](https://pub.dev/packages/freezed)

## 🤝 Contributing

1. 새로운 브랜치 생성
2. 변경사항 커밋 (커밋 컨벤션 준수)
3. 브랜치에 푸시
4. Pull Request 생성

## 📄 License

This project is private and confidential.
