# 💰 CoinFlow

> **실시간 차트부터 인기 코인·NFT 정보, 거래소 검색과 즐겨찾기까지 한눈에 보는 통합 가상자산 정보 앱**

<br>

## 📆 개발 기간

- 2025.03.06 ~ 2025.03.11 (6일간 개발)  
- 이후 추가 기능 및 성능 개선
- 개인 프로젝트 (1인 개발)

<br>

## ✨ 핵심 기능

- 실시간 거래소 차트 확인 (5초 단위 갱신)
- 인기 코인 검색어 및 NFT 순위 확인 (60초 단위 갱신)
- 코인 거래소 검색 및 상세 정보 확인
- 자주 찾는 거래소 즐겨찾기 기능
- 정렬 기준 선택: 현재가 / 전일대비 / 거래대금

<br>


## ⚙️ 상세 구현 사항

### 상세 기능

- **실시간 차트 갱신**: 5초 주기의 거래소 차트, 60초 주기의 인기 차트를 자동 갱신하여 최신 정보 제공  
- **정렬 기능 지원**: 현재가, 전일 대비, 거래대금 기준으로 거래소 차트를 정렬 가능
- **Toast 피드백 제공**: 거래소 즐겨찾기 시 Toast 메시지를 통해 사용자에게 즉각적인 동작 결과 안내  
- **숫자 데이터 포맷팅**: 증감율, 시가 총액 등의 데이터를 가독성 높은 숫자 형식으로 표시  
- **즐겨찾기 상태 동기화**: 화면 간 즐겨찾기 정보의 일관성을 유지하여 사용자 경험 개선  

### 네트워크

- **네트워크 단절 대응**: 네트워크 연결 해제 시 사용자 상호작용을 차단하고 안내 메시지로 대응  
- **에러 상태 세분화 처리**: 네트워크 오류를 상태 코드별로 분류하여 상황에 맞는 안내 메시지 제공  
- **서버 효율성 고려**: 동일 검색어의 반복 요청을 차단하여 서버 부하를 줄이고 성능 최적화  

### 향상/대응

- **이미지 로딩 대응**: 이미지 지연 로딩 상황에 대비해 로딩 인디케이터 표시로 사용자 피드백 강화  
- **화면 내 재검색 기능**: 검색 결과 화면에서도 재검색 가능하여 자연스럽고 유연한 사용자 흐름 제공



<br>

## 🛠 사용 기술

- **플랫폼**: iOS
- **언어 및 프레임워크**: Swift, UIKit
- **아키텍처**: MVVM (Input/Output 패턴 기반)
- **데이터관리**:
  - `Realm` – 로컬 데이터 영속 저장소
- **사용 라이브러리 및 도구**
  - `RxSwift` – 반응형 프로그래밍을 통한 비동기 데이터 흐름 처리
  - `SnapKit` – 코드 기반 UI 레이아웃 구성
  - `Alamofire` – RESTful API 네트워크 통신 처리
  - `Kingfisher` – 이미지 비동기 로딩 및 캐싱
  - `Network` – 네트워크 연결 상태를 실시간으로 감지하고, 단절 시 사용자 상호작용을 제한하며 안내 메시지를 제공
    
<br>

## 📸 스크린샷

| 실시간 차트 | 인기 코인·NFT | 검색 및 즐겨찾기 | 상세 | 네트워크 안내 메시지 |
|:--:|:--:|:--:|:--:|:--:|
| ![차트](https://github.com/user-attachments/assets/df76cf36-57da-47de-b0e1-dfb2e8a6681a) | ![인기](https://github.com/user-attachments/assets/eb727141-6b27-4ec2-afa0-dcc4812e45ce) | ![검색 및 즐겨찾기](https://github.com/user-attachments/assets/994a8d45-326c-4cff-954b-c837fe0b7a6a) | ![상세](https://github.com/user-attachments/assets/e11ba6ae-fb9a-4213-8b44-3745911ea74e) | ![네트워크](https://github.com/user-attachments/assets/81687130-a1ac-44bc-a38f-decb2e23f9ad) |





<br>
