/*
	스키마 초기세팅
*/

DROP DATABASE IF EXISTS piccup;
CREATE DATABASE piccup DEFAULT CHARACTER SET utf8mb4;

USE piccup;

-- 유저 테이블 생성

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `nickname` varchar(15) NOT NULL,
  `password` varchar(255) NOT NULL,
  `profile_img` varchar(255) DEFAULT NULL,
  `mobile_phone` varchar(20) DEFAULT NULL,
  `created_at` date NOT NULL DEFAULT (curdate()),
  `token` varchar(255),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nickname` (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- DROP TABLE IF EXISTS user;
-- CREATE TABLE user (
-- 	user_id				INT				NOT NULL AUTO_INCREMENT,
-- 	email 				VARCHAR(255)	NOT NULL UNIQUE,
-- 	nickname 			VARCHAR(15) 	NOT NULL UNIQUE,
-- 	password 			VARCHAR(255) 	NOT NULL,
-- 	profile_img_name	VARCHAR(255) 	DEFAULT 'default.png',
--     profile_img_path 	VARCHAR(255) 	DEFAULT 'user_images/default.png',
-- 	mobile_phone 		VARCHAR(20),
--     created_at 			TIMESTAMP 		DEFAULT CURRENT_TIMESTAMP,
--     token 				VARCHAR(1000) 	NULL,
--     
--     PRIMARY KEY (user_id)
-- ) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;


/* (자소서, 마이데이터 파트) 접수일정 apply_schedule */
CREATE TABLE apply_schedule (
  schedule_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  apply_id INT NOT NULL,
  start_date DATETIME,
  end_date DATETIME,
  FOREIGN KEY (apply_id) REFERENCES apply(apply_id) ON DELETE CASCADE
);

/* (자소서) 항목 테이블 */
CREATE TABLE cover_letter (
  cover_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  apply_id INT NOT NULL,
  user_id INT NOT NULL,
  category VARCHAR(100),
  cover_title VARCHAR(255) NOT NULL,
  cover_content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (apply_id) REFERENCES apply(apply_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
  CHECK (category IN ('성장과정', '성격', '지원동기', '입사 후 포부', '기타'))
);

/* (마이데이터) 피드백 테이블 */
CREATE TABLE apply_feedback (
  feedback_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  apply_id INT,
  user_id INT NOT NULL,
  feedback_status VARCHAR(50) NOT NULL DEFAULT '미지정',
  content TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (apply_id) REFERENCES apply(apply_id) ON DELETE SET NULL,
  FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
  CHECK (feedback_status IN ('서류', '인적성', '코딩테스트', '면접', '최종합격', '미지정'))
);

/* (마이데이터 캘린더) 일정 입력 */
CREATE TABLE my_schedule (
  schedule_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  schedule_name VARCHAR(50) NOT NULL,
  start_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  end_at DATETIME NOT NULL DEFAULT (CONCAT(CURRENT_DATE, ' 23:59:59')),
  importance INT NOT NULL DEFAULT 2
);

/* (헬프데스크) 공지 */
CREATE TABLE notice (
  notice_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

/* (헬프데스크) 문의 */
CREATE TABLE support (
  support_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

/* 사람인 API용 DB */
CREATE TABLE job_position (
  job_position_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  job_url VARCHAR(500) NOT NULL,
  is_active BOOLEAN NOT NULL,
  company_href VARCHAR(500),
  company_name VARCHAR(255) NOT NULL,
  position_title VARCHAR(255) NOT NULL,
  industry_code VARCHAR(50) NOT NULL,
  industry_name VARCHAR(255),
  location_code VARCHAR(255),
  location_name VARCHAR(255),
  job_type_code VARCHAR(50),
  job_type_name VARCHAR(100),
  job_mid_code VARCHAR(50),
  job_mid_name VARCHAR(100),
  job_code_code VARCHAR(50),
  job_code_name VARCHAR(100),
  experience_level_code INT,
  experience_level_min INT,
  experience_level_max INT,
  experience_level_name VARCHAR(100),
  education_code VARCHAR(50),
  education_name VARCHAR(100),
  job_id VARCHAR(20) NOT NULL,
  posting_timestamp BIGINT NOT NULL,
  posting_date DATETIME,
  modification_timestamp BIGINT NOT NULL,
  opening_timestamp BIGINT NOT NULL,
  expiration_timestamp BIGINT NOT NULL,
  expiration_date DATETIME,
  close_type_code VARCHAR(50),
  close_type_name VARCHAR(100),
  keyword VARCHAR(255),
  read_count VARCHAR(50),
  apply_count VARCHAR(50),
  salary_code VARCHAR(50),
  salary_name VARCHAR(100)
);

/* (이력서) 이력서 테이블 모음 */

-- 이력서 테이블 생성

-- 이력서 테이블 생성 (1:1)
DROP TABLE IF EXISTS resume;

CREATE TABLE resume (
	resume_id 	INT 		NOT NULL AUTO_INCREMENT,
	user_id 	INT			NOT NULL UNIQUE,
	updated_at 	TIMESTAMP 	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (resume_id),
    CONSTRAINT resume_user_fk FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 인적사항 테이블 생성 (1:1)
DROP TABLE IF EXISTS personal_info;
CREATE TABLE personal_info (
	info_id 			INT 			NOT NULL AUTO_INCREMENT,
	resume_id 			INT 			NOT NULL UNIQUE,
	username 			VARCHAR(50),
	birth_date			DATE,
	gender 				VARCHAR(10) 	DEFAULT '미지정' CHECK (gender IN ('남', '여', '미지정')),
	email 				VARCHAR(255),
	home_phone			VARCHAR(20),
	mobile_phone 		VARCHAR(20),
	address 			VARCHAR(255),
	address_detail 		VARCHAR(255),
	postal_code 		INT,
	profile_img_path 	VARCHAR(255) 	DEFAULT 'profile_images/default.png',
    profile_img_name 	VARCHAR(255) 	DEFAULT 'default.png',
	degree 				VARCHAR(10) 	NOT NULL DEFAULT '미지정' CHECK (degree IN('미지정', '중등교육이수', '학사', '석사', '박사')),
	hobby 				VARCHAR(255),
	specialty			VARCHAR(255),
    
	CONSTRAINT personal_resume_fk FOREIGN KEY (resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE, 
    PRIMARY KEY (info_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 스킬 테이블 생성 (1:N)
DROP TABLE IF EXISTS skill;
CREATE TABLE skill (
	skill_id INT NOT NULL AUTO_INCREMENT,
	resume_id INT,
	skill_name VARCHAR(100) NOT NULL,
	skill_level VARCHAR(10) NOT NULL DEFAULT '미지정' CHECK (skill_level IN ('미지정', '초급', '중급', '고급', '전문가')),
    
    CONSTRAINT skill_resume_fk FOREIGN KEY (resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY (skill_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 교육 테이블 생성 (1:N)
DROP TABLE IF EXISTS training;
CREATE TABLE training (
	training_id 	INT 			NOT NULL AUTO_INCREMENT,
	resume_id 		INT				NOT NULL,
	training_name 	VARCHAR(255) 	NOT NULL,
	institution 	VARCHAR(255) 	NOT NULL,
	start_date 		DATE,
	end_date 		DATE,
	description 	TEXT,
    
    CONSTRAINT training_resume_fk FOREIGN KEY (resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY (training_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 자격증 테이블 생성 (1:N)
DROP TABLE IF EXISTS certification;
CREATE TABLE certification (
	cert_id			INT 			NOT NULL AUTO_INCREMENT,
	resume_id 		INT				NOT NULL,
	cert_name 		VARCHAR(255) 	NOT NULL,
	publisher 		VARCHAR(255),
	obtained_date 	DATE,
	cert_code 		VARCHAR(100),
    
    CONSTRAINT cert_resume_fk FOREIGN KEY (resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY (cert_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 해외경험 테이블 생성 (1:N)
DROP TABLE IF EXISTS oversea;
CREATE TABLE oversea (
	oversea_id 	INT 			NOT NULL AUTO_INCREMENT,
	resume_id 	INT				NOT NULL,
	country		VARCHAR(100) 	NOT NULL,
	start_date 	DATE,
	end_date 	DATE,
	description TEXT,
    
    CONSTRAINT oversea_resume_fk FOREIGN KEY (resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY (oversea_id)
)ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 어학 테이블 생성 (1:N)
DROP TABLE IF EXISTS language;
CREATE TABLE language (
	language_id		INT				NOT NULL AUTO_INCREMENT,
	resume_id 		INT				NOT NULL,
	language_name 	VARCHAR(100) 	NOT NULL,
	test_name 		VARCHAR(100) 	NOT NULL,
	score 			VARCHAR(50),
	obtained_date 	DATE,
	cert_code 		VARCHAR(100),
    
    CONSTRAINT language_resume_fk FOREIGN KEY (resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY (language_id)
)ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 프로젝트 데이블 생성 (1:N)
DROP TABLE IF EXISTS project;
CREATE TABLE project (
	project_id 		INT 			NOT NULL AUTO_INCREMENT,
	resume_id 		INT				NOT NULL,
	project_name 	VARCHAR(255) 	NOT NULL,
	role 			VARCHAR(255),
	start_date 		DATE,
	end_date 		DATE,
	description		TEXT,
    
    CONSTRAINT project_resume_fk FOREIGN KEY (resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY (project_id)
)ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 수상내역 테이블 생성 (1:N)
DROP TABLE IF EXISTS award;
CREATE TABLE award (
	award_id 			INT 			NOT NULL AUTO_INCREMENT,
	resume_id 			INT,
	award_name 			VARCHAR(255) 	NOT NULL,
	award_organization 	VARCHAR(255) 	NOT NULL,
	award_date 			DATE,
	description			TEXT,
    
    CONSTRAINT award_resume_fk FOREIGN KEY(resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY (award_id)
)ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 논문 테이블 생성 (1:N)
DROP TABLE IF EXISTS paper;
CREATE TABLE paper (
	paper_id 		INT 			NOT NULL AUTO_INCREMENT,
	resume_id 		INT				NOT NULL,
	paper_title		VARCHAR(255) 	NOT NULL,
	journal			VARCHAR(255) 	NOT NULL,
	published_date 	DATE,
	description 	TEXT,
    
    CONSTRAINT paper_resume_fk FOREIGN KEY(resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY(paper_id)
)ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 특허 테이블 생성 (1:N)
DROP TABLE IF EXISTS patent;
CREATE TABLE patent (
	patent_id 		INT 			NOT NULL AUTO_INCREMENT,
	resume_id 		INT				NOT NULL,
	patent_title 	VARCHAR(255) 	NOT NULL,
	inventor 		VARCHAR(255) 	NOT NULL,
	patent_code 	VARCHAR(100) 	NOT NULL,
	description 	TEXT,
    
    CONSTRAINT patent_resume_fk FOREIGN KEY(resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY(patent_id)
)ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 포트폴리오 테이블 생성 (1:N)
DROP TABLE IF EXISTS portfolio;
CREATE TABLE portfolio (
	port_id			INT				NOT NULL AUTO_INCREMENT,
	resume_id 		INT,
	port_url 		VARCHAR(255),
    
    CONSTRAINT portfolio_resume_fk FOREIGN KEY(resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY(port_id)
)ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 경력 테이블 생성 (1:N)
DROP TABLE IF EXISTS work_exp;
CREATE TABLE work_exp (
	exp_id 			INT 			NOT NULL AUTO_INCREMENT,
	resume_id 		INT				NOT NULL,
	company 		VARCHAR(255) 	NOT NULL,
	department 		VARCHAR(100),
	start_date 		DATE,
	end_date 		DATE,
	is_current 		BOOLEAN 		DEFAULT FALSE,
	position 		VARCHAR(50),
	salary 			INT				CHECK (salary >= 0),
	description 	TEXT,
    
    CONSTRAINT exp_resume_fk FOREIGN KEY(resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY(exp_id)
)ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 취업우대 테이블 생성 (1:1)
DROP TABLE IF EXISTS preference;
CREATE TABLE preference (
	pre_id 			INT 		NOT NULL AUTO_INCREMENT,
	resume_id 		INT 		NOT NULL UNIQUE,
	is_veteran 		BOOLEAN 	NOT NULL DEFAULT FALSE,
	is_protected 	BOOLEAN 	NOT NULL DEFAULT FALSE,
	is_disabled		BOOLEAN		NOT NULL DEFAULT FALSE,
	dis_level 		VARCHAR(10) DEFAULT '해당없음' CHECK (dis_level IN ('중증', '경증', '1급', '2급', '3급', '4급', '5급', '6급', '해당없음')),
	military 		VARCHAR(10) DEFAULT '해당없음' CHECK (military IN ('군필', '미필', '면제', '비대상', '해당없음')),
	is_agree 		BOOLEAN 	NOT NULL DEFAULT FALSE,
    
    CONSTRAINT pre_resume_fk FOREIGN KEY(resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY(pre_id)
)ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 대내외활동 테이블 생성 (1:N)
DROP TABLE IF EXISTS activity;
CREATE TABLE activity (
	act_id 		INT 			NOT NULL AUTO_INCREMENT,
	resume_id 	INT				NOT NULL,
	act_type 	VARCHAR(20) 	DEFAULT '기타' CHECK (act_type IN ('아르바이트', '동아리', '자원봉사', '교내활동', '기타')	),
	title 		VARCHAR(255) 	NOT NULL,
	start_date 	DATE,
	end_date 	DATE,
	description TEXT,
    
    CONSTRAINT act_resume_fk FOREIGN KEY(resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY(act_id)
)ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 학력 테이블 생성 (1:N)
DROP TABLE IF EXISTS education;
CREATE TABLE education ( 
	edu_id 					INT 			NOT NULL AUTO_INCREMENT,
	resume_id 				INT				NOT NULL,
	school_type 			VARCHAR(20) 	DEFAULT '선택안함' CHECK (school_type IN ('선택안함', '고등학교', '대학(2,3년)', '대학교(4년)', '대학원')),
	school_name				VARCHAR(255) 	NOT NULL,
	major 					VARCHAR(100),
	start_date 				DATE,
	end_date 				DATE,
	status 					VARCHAR(20) 	DEFAULT '선택안함' CHECK (status IN ('선택안함', '졸업', '졸업예정', '재학 중', '중퇴', '수료', '휴학')),
	is_transfer				BOOLEAN			DEFAULT FALSE,
	gpa						DECIMAL(3,2)	CHECK (gpa >= 0),
	major_gpa 				DECIMAL(3,2)	CHECK (major_gpa >= 0),
	gpa_scale 				DECIMAL(3,2)	CHECK (gpa_scale >= 0),
	is_qe 					BOOLEAN 		NOT NULL DEFAULT FALSE,
	qe_year 				YEAR,
    
    CONSTRAINT edu_resume_fk FOREIGN KEY(resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY(edu_id)
)ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;

-- 파일 테이블 (1:N)
DROP TABLE IF EXISTS file;
CREATE TABLE file (
	file_id	INT NOT NULL AUTO_INCREMENT,
    resume_id INT NOT NULL,
    edu_file_name VARCHAR(255),
    edu_file_path VARCHAR(255),
	port_file_name 	VARCHAR(255),
    port_file_path 	VARCHAR(255),
	work_file_name 	VARCHAR(255),
    work_file_path 	VARCHAR(255),
	updated_at 	TIMESTAMP 	DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT file_resume_fk FOREIGN KEY(resume_id) REFERENCES resume(resume_id) ON DELETE CASCADE,
    PRIMARY KEY(file_id)
)ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4;
	
/*
**** resume 외
*/
DROP TABLE IF EXISTS `support`;
CREATE TABLE `support` (
  `support_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`support_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `support_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `my_schedule`;
CREATE TABLE `my_schedule` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `schedule_name` varchar(50) NOT NULL,
  `start_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_at` datetime NOT NULL DEFAULT (concat(curdate(),_utf8mb4' 23:59:59')),
  `importance` int NOT NULL DEFAULT '2',
  PRIMARY KEY (`schedule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `job_position`;
CREATE TABLE `job_position` (
  `job_position_id` int NOT NULL AUTO_INCREMENT,
  `job_url` varchar(500) NOT NULL,
  `is_active` tinyint NOT NULL,
  `company_href` varchar(500) DEFAULT NULL,
  `company_name` varchar(255) NOT NULL,
  `position_title` varchar(255) NOT NULL,
  `industry_code` varchar(50) NOT NULL,
  `industry_name` varchar(255) DEFAULT NULL,
  `location_code` varchar(255) DEFAULT NULL,
  `location_name` varchar(255) DEFAULT NULL,
  `job_type_code` varchar(50) DEFAULT NULL,
  `job_type_name` varchar(100) DEFAULT NULL,
  `job_mid_code` varchar(50) DEFAULT NULL,
  `job_mid_name` varchar(100) DEFAULT NULL,
  `job_code_code` varchar(50) DEFAULT NULL,
  `job_code_name` varchar(100) DEFAULT NULL,
  `experience_level_code` int DEFAULT NULL,
  `experience_level_min` int DEFAULT NULL,
  `experience_level_max` int DEFAULT NULL,
  `experience_level_name` varchar(100) DEFAULT NULL,
  `education_code` varchar(50) DEFAULT NULL,
  `education_name` varchar(100) DEFAULT NULL,
  `job_id` varchar(20) NOT NULL,
  `posting_timestamp` bigint NOT NULL,
  `posting_date` datetime DEFAULT NULL,
  `modification_timestamp` bigint NOT NULL,
  `opening_timestamp` bigint NOT NULL,
  `expiration_timestamp` bigint NOT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `close_type_code` varchar(50) DEFAULT NULL,
  `close_type_name` varchar(100) DEFAULT NULL,
  `keyword` varchar(255) DEFAULT NULL,
  `read_count` varchar(50) DEFAULT NULL,
  `apply_count` varchar(50) DEFAULT NULL,
  `salary_code` varchar(50) DEFAULT NULL,
  `salary_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`job_position_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `apply`;
CREATE TABLE `apply` (
  `apply_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `company_name` varchar(100) DEFAULT NULL,
  `company_size` varchar(50) DEFAULT NULL,
  `job` varchar(100) DEFAULT NULL,
  `industry` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`apply_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `apply_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `apply_chk_1` CHECK ((`company_size` in (_utf8mb4'대기업',_utf8mb4'중견기업',_utf8mb4'중소기업',_utf8mb4'스타트업',_utf8mb4'공기업',_utf8mb4'공공기관',_utf8mb4'기타'))),
  CONSTRAINT `apply_chk_2` CHECK ((`industry` in (_utf8mb4'IT',_utf8mb4'금융',_utf8mb4'제조',_utf8mb4'의료',_utf8mb4'서비스',_utf8mb4'유통',_utf8mb4'교육',_utf8mb4'건설',_utf8mb4'예술',_utf8mb4'기타')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `cover_letter`;
CREATE TABLE `cover_letter` (
  `cover_id` int NOT NULL AUTO_INCREMENT,
  `apply_id` int NOT NULL,
  `user_id` int NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `cover_title` varchar(255) NOT NULL,
  `cover_content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cover_id`),
  KEY `apply_id` (`apply_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `cover_letter_ibfk_1` FOREIGN KEY (`apply_id`) REFERENCES `apply` (`apply_id`) ON DELETE CASCADE,
  CONSTRAINT `cover_letter_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `cover_letter_chk_1` CHECK ((`category` in (_utf8mb4'성장과정',_utf8mb4'성격',_utf8mb4'지원동기',_utf8mb4'입사 후 포부',_utf8mb4'기타')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `apply_status`;
CREATE TABLE `apply_status` (
  `status_id` int NOT NULL AUTO_INCREMENT,
  `apply_id` int NOT NULL,
  `is_progressing` tinyint NOT NULL DEFAULT '1',
  `current_status` varchar(50) NOT NULL DEFAULT '미지정',
  PRIMARY KEY (`status_id`),
  KEY `apply_id` (`apply_id`),
  CONSTRAINT `apply_status_ibfk_1` FOREIGN KEY (`apply_id`) REFERENCES `apply` (`apply_id`) ON DELETE CASCADE,
  CONSTRAINT `apply_status_chk_1` CHECK ((`current_status` in (_utf8mb4'서류',_utf8mb4'인적성',_utf8mb4'코딩테스트',_utf8mb4'면접',_utf8mb4'최종합격',_utf8mb4'미지정')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `apply_schedule`;
CREATE TABLE `apply_schedule` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `apply_id` int NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  PRIMARY KEY (`schedule_id`),
  KEY `apply_id` (`apply_id`),
  CONSTRAINT `apply_schedule_ibfk_1` FOREIGN KEY (`apply_id`) REFERENCES `apply` (`apply_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `apply_feedback`;
CREATE TABLE `apply_feedback` (
  `feedback_id` int NOT NULL AUTO_INCREMENT,
  `apply_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  `feedback_status` varchar(50) NOT NULL DEFAULT '미정',
  `content` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`feedback_id`),
  KEY `apply_id` (`apply_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `apply_feedback_ibfk_1` FOREIGN KEY (`apply_id`) REFERENCES `apply` (`apply_id`) ON DELETE SET NULL,
  CONSTRAINT `apply_feedback_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `apply_feedback_chk_1` CHECK ((`feedback_status` in (_utf8mb4'서류',_utf8mb4'인적성',_utf8mb4'코딩테스트',_utf8mb4'면접',_utf8mb4'최종합격',_utf8mb4'미정')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
