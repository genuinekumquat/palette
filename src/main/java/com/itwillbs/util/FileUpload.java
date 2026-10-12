package com.itwillbs.util;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

// cos.jar 파일 업로드 공통 처리 (리뷰 사진, 클래스 대표 이미지)
public class FileUpload {

	// 업로드 파일 최대 크기 10MB
	static final int MAX_SIZE = 10 * 1024 * 1024;

	// 업로드 폴더 (webapp/upload) => 없으면 생성
	public static File getUploadDir(HttpServletRequest request) {
		File uploadDir = new File(request.getServletContext().getRealPath("/upload"));
		if(!uploadDir.exists()) {
			uploadDir.mkdirs();
		}
		return uploadDir;
	}

	// MultipartRequest 객체생성 => 파일 업로드 (같은 이름 파일은 이름 변경)
	public static MultipartRequest upload(HttpServletRequest request) throws IOException {
		String uploadPath = getUploadDir(request).getPath();
		System.out.println(uploadPath);
		return new MultipartRequest(request, uploadPath, MAX_SIZE, "utf-8",
				new DefaultFileRenamePolicy());
	}

	// 업로드된 파일 삭제 (권한 없을 때, 이미지 교체할 때)
	public static void delete(HttpServletRequest request, String fileName) {
		if(fileName != null) {
			new File(getUploadDir(request), fileName).delete();
		}
	}
}
