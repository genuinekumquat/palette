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
| 회원 (`*.me`) | 완료 | 게스트/호스트 가입, 로그인, 아이디·비밀번호 찾기 |
| 클래스 게시판 (`*.cbo`) | 완료 | 목록(페이징)·작성·상세·수정·삭제 |
| 공지 게시판 (`*.nbo`) | 완료 | 목록·작성·상세·수정·삭제 |
| 후기 게시판 (`*.rbo`) | 진행 중 | 목록 조회 일부만 구현 |
| 예약 (`*.re`) | 코드 유실 | 원본에는 구현돼 있었으나 프로젝트 이관 과정에서 소실, 컨트롤러 골격만 남음 |
| 결제 (`*.pa`) | 코드 유실 | 〃 |
| FAQ (`*.qbo`) | 코드 유실 | 〃 |
| 검색 로그 (`*.se`) | 코드 유실 | 〃 |

> `web.xml`의 서블릿 매핑과 `*DTO`, `schema.sql`의 테이블 정의는 남아 있어
> 유실된 `reserve` / `payment` / `question` / `searchlog` 도메인의 원래 데이터 구조는 복원 가능하다.
> 서비스·DAO 로직 재작성은 별도 TODO.

## 로컬 실행 방법 (IntelliJ IDEA Ultimate)

### 1. 데이터베이스 준비

```bash
mysql -u root -p < src/main/sql/schema.sql
```

`teamproject2` 데이터베이스와 테이블, 샘플 데이터가 생성됩니다.
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
- `ReviewBoardDAO.getBoardList`: `pstmt`가 null 상태에서 사용되어 항상 실패
- 비밀번호가 평문으로 저장됨 (해싱 미적용)
- `reserve` / `payment` / `question` / `searchlog` 서비스·DAO 로직 재작성 필요 (코드 유실분)
