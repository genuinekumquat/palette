package com.itwillbs.util;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

// JSP 출력용 공통 처리
public class Html {

	// 사용자가 입력한 값 => HTML 태그로 실행되지 않게 변환
	public static String escape(String str) {
		if(str == null) {
			return "";
		}
		return str.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
				.replace("\"", "&quot;").replace("'", "&#39;");
	}

	// 여러 줄 내용 => 변환 후 줄바꿈을 <br>로
	public static String escapeLines(String str) {
		return escape(str).replace("\r\n", "\n").replace("\n", "<br>");
	}

	// 주소에 붙일 값 => 한글, 특수문자 인코딩
	public static String encode(String str) {
		try {
			return URLEncoder.encode(str, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			return "";
		}
	}

	// 작성일시 => 2023-09-12 20:06 형식
	public static String date(Timestamp time) {
		if(time == null) {
			return "";
		}
		return new SimpleDateFormat("yyyy-MM-dd HH:mm").format(time);
	}

	// 클래스 이미지 경로 => 업로드 이미지 없으면 기본 이미지
	public static String classImage(String fileName) {
		return fileName != null ? "upload/" + encodePath(fileName) : "images/no-image.svg";
	}

	// 업로드 파일명 => 주소용 (공백 등 인코딩)
	public static String encodePath(String fileName) {
		return encode(fileName).replace("+", "%20");
	}
}
