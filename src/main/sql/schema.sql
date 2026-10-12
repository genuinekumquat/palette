-- =====================================================================
--  TeamProject2 - schema reconstructed from the DAO layer
--  (the original academy DB dump was lost)
--
--  Usage (local MySQL 8.x):
--    mysql -u root -p < src/main/sql/schema.sql
--
--  Column names/types are inferred from com.itwillbs.dao.* and
--  com.itwillbs.domain.*DTO. Tables for unfinished features
--  (reserve / payment / question / searchlog) are included for
--  completeness but no DAO writes to them yet.
-- =====================================================================

DROP DATABASE IF EXISTS teamproject2;
CREATE DATABASE teamproject2
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;
USE teamproject2;

-- ---------------------------------------------------------------------
--  member : guest / host accounts
--  DAO: com.itwillbs.dao.MemberDAO
-- ---------------------------------------------------------------------
CREATE TABLE member (
    memberNum        INT          NOT NULL AUTO_INCREMENT,
    memberId         VARCHAR(50)  NOT NULL,
    memberPassword   VARCHAR(100) NOT NULL,
    memberName       VARCHAR(50),
    memberNickname   VARCHAR(50),
    memberGender     VARCHAR(10),
    memberBirthday   VARCHAR(20),          -- kept as String in MemberDTO
    memberPhoneNum   VARCHAR(20),
    memberEmail      VARCHAR(100),
    memberType       VARCHAR(10)  DEFAULT 'guest',   -- 'guest' | 'host'
    memberLocation   VARCHAR(50),
    businessNum      VARCHAR(30),          -- host only
    mailOrderNum     VARCHAR(30),          -- host only
    memberFile       VARCHAR(255),         -- profile image path
    PRIMARY KEY (memberNum),
    UNIQUE KEY uq_member_id (memberId),
    UNIQUE KEY uq_member_nickname (memberNickname)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
--  class : lessons opened by a host  ("class" is a reserved word)
--  DAO: com.itwillbs.dao.ClassBoardDAO
-- ---------------------------------------------------------------------
CREATE TABLE `class` (
    classNum        INT          NOT NULL AUTO_INCREMENT,
    classSubject    VARCHAR(200) NOT NULL,
    hostId          VARCHAR(50)  NOT NULL,
    classPrice      INT          DEFAULT 0,
    classCategory   VARCHAR(50),
    classLocation   VARCHAR(100),
    classContent    TEXT,
    classIssuedate  DATETIME     DEFAULT CURRENT_TIMESTAMP,
    classFile       VARCHAR(255),
    PRIMARY KEY (classNum),
    KEY idx_class_host (hostId)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
--  notice : admin announcements
--  DAO: com.itwillbs.dao.NoticeBoardDAO
--  (noticeNum is assigned by the DAO as max(noticeNum)+1, not AUTO_INCREMENT)
-- ---------------------------------------------------------------------
CREATE TABLE notice (
    noticeNum        INT          NOT NULL,
    noticeSubject    VARCHAR(200) NOT NULL,
    noticeContent    TEXT,
    noticeIssuedate  DATETIME     DEFAULT CURRENT_TIMESTAMP,
    noticeReadcount  INT          DEFAULT 0,
    PRIMARY KEY (noticeNum)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
--  review : lesson reviews written by guests
--  DAO: com.itwillbs.dao.ReviewBoardDAO
--  Only a guest with a paid reservation (reserve + payment) for the
--  class may write a review.
-- ---------------------------------------------------------------------
CREATE TABLE review (
    reviewNum        INT          NOT NULL AUTO_INCREMENT,
    classNum         INT          NOT NULL,
    reviewId         VARCHAR(50)  NOT NULL,
    reviewIssuedate  DATETIME     DEFAULT CURRENT_TIMESTAMP,
    reviewContent    TEXT,
    reviewFile       VARCHAR(255),
    PRIMARY KEY (reviewNum),
    KEY idx_review_class (classNum)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
--  reserve / payment / question / searchlog
--  Features scaffolded in web.xml but not implemented in the DAO layer.
--  Shapes taken from the matching *DTO classes.
-- ---------------------------------------------------------------------
CREATE TABLE reserve (
    reserveNum            INT      NOT NULL AUTO_INCREMENT,
    classNum              INT      NOT NULL,
    reserveDate           DATETIME DEFAULT CURRENT_TIMESTAMP,
    reserveGuestNum       INT      NOT NULL,
    theNumOfReserveGuest  INT      DEFAULT 1,
    PRIMARY KEY (reserveNum),
    KEY idx_reserve_class (classNum),
    KEY idx_reserve_guest (reserveGuestNum)
) ENGINE=InnoDB;

CREATE TABLE payment (
    paymentNum     INT      NOT NULL AUTO_INCREMENT,
    reserveNum     INT      NOT NULL,
    paymentPrice   INT      DEFAULT 0,
    paymentMethod  INT,
    paymentDate    DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (paymentNum),
    KEY idx_payment_reserve (reserveNum)
) ENGINE=InnoDB;

CREATE TABLE question (
    questionNum       INT          NOT NULL AUTO_INCREMENT,
    questionQuestion  VARCHAR(300) NOT NULL,
    questionAnswer    TEXT,
    questionCategory  VARCHAR(50),
    PRIMARY KEY (questionNum)
) ENGINE=InnoDB;

CREATE TABLE searchlog (
    searchNum      INT          NOT NULL AUTO_INCREMENT,
    searchId       VARCHAR(50),
    searchContent  VARCHAR(200),
    searchDate     DATETIME     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (searchNum)
) ENGINE=InnoDB;


-- =====================================================================
--  Seed data - just enough for the pages to render
-- =====================================================================
INSERT INTO member (memberId, memberPassword, memberName, memberNickname, memberGender,
                    memberBirthday, memberPhoneNum, memberEmail, memberType, memberLocation)
VALUES
    ('guest01', '1234', '김게스트', '주말클래스러', 'F', '1995-03-01', '010-1111-2222', 'guest01@example.com', 'guest', '서울 마포구'),
    ('guest02', '1234', '이수강', '쿠킹러버',     'M', '1990-07-15', '010-3333-4444', 'guest02@example.com', 'guest', '서울 강남구');

INSERT INTO member (memberId, memberPassword, memberName, memberNickname, memberGender,
                    memberBirthday, memberPhoneNum, memberEmail, memberType, businessNum, mailOrderNum)
VALUES
    ('host01', '1234', '박호스트', '베이킹클래스', 'F', '1985-11-20', '010-5555-6666', 'host01@example.com', 'host', '123-45-67890', '2024-서울마포-0001');

INSERT INTO `class` (classSubject, hostId, classPrice, classCategory, classLocation, classContent)
VALUES
    ('초보를 위한 홈베이킹 원데이 클래스', 'host01', 45000, '베이킹', '서울 마포구', '스콘과 파운드케이크를 직접 만들어 갑니다.'),
    ('주말 프렌치 요리 클래스',            'host01', 60000, '쿠킹',   '서울 마포구', '가정에서 즐기는 프렌치 3코스.'),
    ('원데이 수채화 드로잉',               'host01', 35000, '드로잉', '서울 마포구', '재료 일체 포함, 엽서 2장 완성.');

INSERT INTO notice (noticeNum, noticeSubject, noticeContent, noticeReadcount)
VALUES
    (1, '서비스 오픈 안내', '클래스 예약 플랫폼이 오픈했습니다.', 0),
    (2, '환불 규정 안내',   '클래스 시작 3일 전까지 전액 환불됩니다.', 0);

-- reserveGuestNum = member.memberNum (guest01 = 1, guest02 = 2)
--   guest01 : class 1 paid            -> can review class 1
--   guest02 : class 2 paid            -> can review class 2
--   guest02 : class 1 reserved, unpaid -> cannot review class 1
INSERT INTO reserve (classNum, reserveGuestNum, theNumOfReserveGuest)
VALUES
    (1, 1, 2),
    (2, 2, 1),
    (1, 2, 1);

INSERT INTO payment (reserveNum, paymentPrice, paymentMethod)
VALUES
    (1, 90000, 1),
    (2, 60000, 1);

INSERT INTO review (classNum, reviewId, reviewContent)
VALUES
    (1, 'guest01', '재료도 넉넉하고 설명이 친절했어요.'),
    (2, 'guest02', '3코스 전부 맛있게 완성했습니다.');
