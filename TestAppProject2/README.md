# Test App Flutter

React Native 앱을 Flutter로 변환한 게시판 애플리케이션입니다.

## 기능

- **사용자 인증**: 로그인/회원가입
- **게시글 관리**: 목록 조회, 상세 보기, 생성, 수정, 삭제
- **반응형 UI**: Material Design 기반의 모던한 UI
- **상태 관리**: Provider 패턴을 사용한 효율적인 상태 관리

## 기술 스택

- **Flutter**: 크로스 플랫폼 모바일 앱 개발
- **Dio**: HTTP 클라이언트
- **Provider**: 상태 관리
- **SharedPreferences**: 로컬 데이터 저장

## 설치 및 실행

### 필수 요구사항

- Flutter SDK (3.0.0 이상)
- Android Studio / VS Code
- Android SDK (Android 앱 실행 시)
- iOS 개발 환경 (iOS 앱 실행 시)

### 설치 단계

1. **의존성 설치**

   ```bash
   flutter pub get
   ```

2. **백엔드 서버 실행**

   - Spring Boot 백엔드가 실행 중이어야 합니다
   - 기본 URL: `http://10.0.2.2:8080/api` (Android 에뮬레이터용)
   - 실제 기기 사용 시 IP 주소를 변경해야 합니다

3. **앱 실행**

   ```bash
   # Android
   flutter run

   # iOS
   flutter run -d ios
   ```

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── models/                   # 데이터 모델
│   ├── user.dart
│   └── post.dart
├── services/                 # API 서비스
│   └── api_service.dart
├── providers/                # 상태 관리
│   ├── auth_provider.dart
│   └── post_provider.dart
└── screens/                  # 화면
    ├── login_screen.dart
    ├── register_screen.dart
    ├── post_list_screen.dart
    ├── create_post_screen.dart
    ├── post_detail_screen.dart
    └── edit_post_screen.dart
```

## 주요 기능 설명

### 1. 사용자 인증

- 로그인/회원가입 기능
- 로그인 정보 자동 저장
- 로그아웃 기능

### 2. 게시글 관리

- 게시글 목록 조회 (새로고침 지원)
- 게시글 상세 보기
- 게시글 생성
- 게시글 수정 (작성자만 가능)
- 게시글 삭제 (작성자만 가능)

### 3. UI/UX

- Material Design 기반의 모던한 디자인
- 로딩 상태 표시
- 에러 메시지 표시
- 반응형 레이아웃

## API 엔드포인트

앱은 다음 백엔드 API를 사용합니다:

- `POST /api/users/register` - 회원가입
- `POST /api/users/login` - 로그인
- `GET /api/users/{id}` - 사용자 정보 조회
- `GET /api/posts` - 게시글 목록 조회
- `GET /api/posts/{id}` - 게시글 상세 조회
- `POST /api/posts` - 게시글 생성
- `PUT /api/posts/{id}` - 게시글 수정
- `DELETE /api/posts/{id}` - 게시글 삭제

## 설정

### 네트워크 설정

Android 에뮬레이터에서 실행할 때는 `10.0.2.2`를 사용하고, 실제 기기에서는 백엔드 서버의 실제 IP 주소를 사용해야 합니다.

`lib/services/api_service.dart` 파일에서 `baseUrl`을 수정하세요:

```dart
static const String baseUrl = 'http://YOUR_SERVER_IP:8080/api';
```

## 빌드

### Android APK 빌드

```bash
flutter build apk
```

### Android App Bundle 빌드

```bash
flutter build appbundle
```

### iOS 빌드

```bash
flutter build ios
```

## 문제 해결

### 네트워크 오류

- 백엔드 서버가 실행 중인지 확인
- IP 주소가 올바른지 확인
- 방화벽 설정 확인

### 빌드 오류

- Flutter SDK 버전 확인
- 의존성 충돌 확인
- Android/iOS 개발 환경 설정 확인

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.
