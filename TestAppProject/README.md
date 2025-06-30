# TestApp - React Native + Java Spring Boot

React Native와 Java Spring Boot로 구성된 크로스 플랫폼 모바일 앱입니다.

## 프로젝트 구조

```
TestAppProject/
├── TestApp/                 # React Native 앱
│   ├── src/
│   │   ├── screens/         # 화면 컴포넌트
│   │   ├── services/        # API 서비스
│   │   └── navigation/      # 네비게이션
│   └── App.tsx
└── backend/                 # Java Spring Boot 백엔드
    ├── src/main/java/
    │   └── com/testapp/backend/
    │       ├── controller/  # REST API 컨트롤러
    │       ├── service/     # 비즈니스 로직
    │       ├── repository/  # 데이터 접근
    │       ├── model/       # 엔티티
    │       └── dto/         # 데이터 전송 객체
    └── pom.xml
```

## 기능

### 사용자 관리

- 회원가입
- 로그인/로그아웃

### 게시판

- 게시글 목록 조회
- 게시글 작성
- 게시글 상세 조회
- 게시글 수정 (작성자만)
- 게시글 삭제 (작성자만)

## 기술 스택

### Frontend (React Native)

- React Native 0.73.0
- React Navigation
- Axios (HTTP 클라이언트)

### Backend (Java Spring Boot)

- Spring Boot 3.2.0
- Spring Data JPA
- H2 Database (개발용)
- MySQL/PostgreSQL (운영용)

## 설치 및 실행

### 1. 백엔드 실행

```bash
cd backend

# 개발용 (H2 인메모리)
mvn spring-boot:run

# 개발용 (H2 파일)
mvn spring-boot:run -Dspring.profiles.active=dev

# 운영용 (MySQL)
mvn spring-boot:run -Dspring.profiles.active=prod
```

### 2. React Native 앱 실행

```bash
cd TestApp

# iOS
npx react-native run-ios

# Android
npx react-native run-android
```

## API 엔드포인트

### 사용자 API

- `POST /api/users/register` - 회원가입
- `POST /api/users/login` - 로그인
- `GET /api/users/{id}` - 사용자 정보 조회

### 게시글 API

- `GET /api/posts` - 게시글 목록 조회
- `GET /api/posts/{id}` - 게시글 상세 조회
- `POST /api/posts` - 게시글 작성
- `PUT /api/posts/{id}` - 게시글 수정
- `DELETE /api/posts/{id}` - 게시글 삭제

## 데이터베이스 설정

### 개발용 (H2)

- 인메모리: `jdbc:h2:mem:testdb`
- 파일: `jdbc:h2:file:./data/testdb`

### 운영용

- MySQL: `jdbc:mysql://localhost:3306/testapp`
- PostgreSQL: `jdbc:postgresql://localhost:5432/testapp`

## 주의사항

1. **백엔드 서버가 실행 중이어야 앱이 정상 작동합니다.**
2. **iOS 시뮬레이터에서 localhost 접근 시**: `http://localhost:8080` 대신 `http://127.0.0.1:8080` 사용
3. **Android 에뮬레이터에서 localhost 접근 시**: `http://10.0.2.2:8080` 사용

## 개발 환경

- macOS 24.5.0
- Node.js 18+
- Java 17+
- Maven 3.6+
- React Native CLI
- Xcode (iOS 개발용)
- Android Studio (Android 개발용)
