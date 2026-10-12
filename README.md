# TeamProject2 — 클래스 예약 플랫폼

호스트가 원데이 클래스를 등록하고 게스트가 예약·결제하는 웹 서비스.
학원(itwillbs) 팀 프로젝트로 시작했으며, 포트폴리오 정리를 위해
**Eclipse Dynamic Web Project → Maven 프로젝트**로 마이그레이션했습니다.

## 기술 스택

| 구분 | 사용 |
|------|------|
| 언어 | Java 11+ (빌드/테스트는 JDK 21) |
| 웹 | Servlet 3.1 · JSP (scriptlet), MVC 2 패턴 |
| DB | MySQL 8.x, JDBC + JNDI DataSource |
| WAS | Apache Tomcat 9 (javax.* 네임스페이스) |
| 빌드 | Maven (war) |

## 아키텍처

```
controller (HttpServlet)  ─▶  service  ─▶  dao (JDBC)  ─▶  MySQL
        │                                     ▲
        └────────────  domain (DTO) ──────────┘
url-pattern: *.me *.cbo *.nbo *.rbo *.qbo *.re *.pa *.se  (web.xml)
```

## 구현 현황

| 도메인 | 상태 | 비고 |
|--------|------|------|
| 회원 (`*.me`) | 완료 | 게스트/호스트 가입, 로그인, 아이디·비밀번호 찾기, 마이페이지\* |
| 클래스 게시판 (`*.cbo`) | 완료 | 목록(페이징)·작성·상세·수정·삭제, 이미지 업로드\*, 호스트 권한\*, 검색·카테고리\*, 나의 클래스 관리\* |
| 공지 게시판 (`*.nbo`) | 완료 | 목록·작성·상세·수정·삭제 |
| 후기 게시판 (`*.rbo`) | 완료\* | 결제 완료 게스트만 작성, 사진 첨부, 최신순 조회, 나의 리뷰 |

\* 표시는 2026년에 복원한 기능입니다. 아래 [코드 복원 안내](#코드-복원-안내)를 참고하세요.
| 예약 (`*.re`) | 코드 유실 | 원본에는 구현돼 있었으나 프로젝트 이관 과정에서 소실, 컨트롤러 골격만 남음 |
| 결제 (`*.pa`) | 코드 유실 | 〃 |
| FAQ (`*.qbo`) | 코드 유실 | 〃 |
| 검색 로그 (`*.se`) | 코드 유실 | 〃 |

> `web.xml`의 서블릿 매핑과 `*DTO`, `schema.sql`의 테이블 정의는 남아 있어
> 유실된 `reserve` / `payment` / `question` / `searchlog` 도메인의 원래 데이터 구조는 복원 가능하다.
> 서비스·DAO 로직 재작성은 별도 TODO.

## 코드 복원 안내

이 저장소에는 프로젝트 기간(2023.08 ~ 2023.09) 중간 시점의 코드만 남아 있었고,
최종 완성본은 유실되었습니다. 2026년 10월, 포트폴리오 정리 과정에서
**당시 포트폴리오 문서(기능 설명, 화면 캡처, 코드 캡처)를 근거로 담당 기능을 다시 작성**했습니다.
복원 작업은 AI 코딩 도구(Claude Code)의 도움을 받아 진행했습니다.

따라서 아래 표의 "복원" 코드는 **2023년 원본 코드가 아니라, 같은 기능을 재현한 코드**입니다.

| 구분 | 내용 | 시점 |
|------|------|------|
| 원본 | 로그인 · 아이디 찾기 · 비밀번호 재설정 로직, 클래스 목록 페이징, 클래스 등록·수정·삭제 기본 구조 | 2023 (커밋 `ad601d3`) |
| 복원 | 리뷰 작성·조회, 클래스 이미지 업로드, 호스트/게스트 권한, 키워드 검색·카테고리 조회, 나의 클래스 관리, 마이페이지, 메인 페이지, 화면 디자인 | 2026.10 |
| 개선 | 프로젝트 이후 코드 점검에서 발견한 문제 수정 (아래) | 2026.10 |

### 프로젝트 이후 개선 사항

- **아이디·비밀번호 찾기 인증 문제** (`1e07daf`)
  본인확인 결과를 로그인용 세션 값(`memberId`)에 저장해, 이름·이메일만 알면 비밀번호 없이
  로그인 상태가 되던 문제를 수정했습니다. 비밀번호 재설정도 폼에서 넘어온 아이디가 아니라
  서버에서 본인확인된 아이디(`resetId`)만 변경하도록 바꿨습니다.
- **클래스 수정이 저장되지 않던 문제** (`1103d39`)
  수정 폼이 `classNum`을 보내지 않아 `where classNum=0`으로 실행되던 문제를 수정했습니다.
- **삭제 후 이동 주소 오류, 없는 클래스 접근 시 500 오류** (`52d6d6e`)

복원·개선 이력은 `restore/portfolio-features` 브랜치의 커밋에서 기능별로 확인할 수 있습니다.

## 로컬 실행 방법 (IntelliJ IDEA Ultimate)

### 1. 데이터베이스 준비

```bash
mysql -u root -p < src/main/sql/schema.sql
```

`teamproject2` 데이터베이스와 테이블, 샘플 데이터가 생성됩니다.
샘플 계정은 `guest01`, `guest02`, `host01`이며 비밀번호는 모두 `1234`입니다.
(`guest01`은 1번 클래스, `guest02`는 2번 클래스에 결제한 예약이 있어 리뷰를 쓸 수 있습니다.)
스키마는 원본 DB 덤프가 유실되어 DAO 계층에서 역으로 재구성한 것입니다.

### 2. DataSource 자격 증명 설정

`src/main/webapp/META-INF/context.xml`의 `password="CHANGE_ME"`를 로컬 MySQL
비밀번호로 바꿉니다. (실제 비밀번호는 커밋하지 않습니다.)

### 3. Tomcat 실행 구성 추가

1. **Run ▸ Edit Configurations ▸ + ▸ Tomcat Server ▸ Local**
2. **Application server**: Tomcat 9 설치 경로 지정 (없으면 다운로드)
3. **Deployment** 탭: `TeamProject:war exploded` 아티팩트 추가,
   **Application context** = `/TeamProject`
4. **Run** — 브라우저에서 `http://localhost:8080/TeamProject/`

> MySQL JDBC 드라이버는 `pom.xml` 의존성으로 WAR에 포함되므로 Tomcat `lib`에
> 따로 넣지 않아도 됩니다.

### 커맨드라인 빌드

```bash
mvn clean package      # target/TeamProject.war
```

## 알려진 이슈 (정리 예정)

- `NoticeBoardDAO`: `update notice set = noticeReadcount+1 ...` 등 SQL 문법 오류
- `NoticeBoardDAO.updateBoard`: `where num=?` — 존재하지 않는 컬럼
- `MemberDAO.insertHost`: 게스트용 INSERT를 재사용해 `businessNum`이 `memberLocation`
  컬럼에 저장됨
- 비밀번호가 평문으로 저장됨 (해싱 미적용)
- `reserve` / `payment` / `question` / `searchlog` 서비스·DAO 로직 재작성 필요 (코드 유실분)
