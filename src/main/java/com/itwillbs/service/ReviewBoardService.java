package com.itwillbs.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.itwillbs.dao.ReviewBoardDAO;
import com.itwillbs.domain.ReviewBoardDTO;
import com.itwillbs.util.FileUpload;
import com.oreilly.servlet.MultipartRequest;

public class ReviewBoardService {

	ReviewBoardDAO boardDAO = null;

	public List<ReviewBoardDTO> getBoardList(int classNum) {
		System.out.println("ReviewBoardService getBoardList()");
		List<ReviewBoardDTO> boardList = null;
		try {
			boardDAO = new ReviewBoardDAO();
			boardList = boardDAO.getBoardList(classNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return boardList;
	}// getBoardList

	public List<ReviewBoardDTO> getMyBoardList(String reviewId) {
		System.out.println("ReviewBoardService getMyBoardList()");
		List<ReviewBoardDTO> boardList = null;
		try {
			boardDAO = new ReviewBoardDAO();
			boardList = boardDAO.getMyBoardList(reviewId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return boardList;
	}// getMyBoardList

	public boolean checkReviewAuth(String memberId, int classNum) {
		System.out.println("ReviewBoardService checkReviewAuth()");
		boolean result = false;
		try {
			// 로그인 안했으면 작성 불가
			if(memberId == null) {
				return false;
			}
			boardDAO = new ReviewBoardDAO();
			result = boardDAO.checkReviewAuth(memberId, classNum);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}// checkReviewAuth

	// 리뷰 작성 => 작성 권한 있으면 저장 후 classNum 리턴, 권한 없으면 -1 리턴
	public int insertBoard(HttpServletRequest request) {
		System.out.println("ReviewBoardService insertBoard()");
		int classNum = -1;
		try {
			// cos.jar MultipartRequest => 파일 업로드
			MultipartRequest multi = FileUpload.upload(request);

			// multi 파라미터값 가져오기
			int reqClassNum = Integer.parseInt(multi.getParameter("classNum"));
			String reviewContent = multi.getParameter("reviewContent");
			String reviewFile = multi.getFilesystemName("reviewFile");

			// 세션에서 로그인 아이디 가져오기
			HttpSession session = request.getSession();
			String memberId = (String)session.getAttribute("memberId");

			// 결제까지 완료한 게스트만 작성 가능
			if(!checkReviewAuth(memberId, reqClassNum)) {
				// 권한 없으면 업로드된 파일 삭제
				FileUpload.delete(request, reviewFile);
				return -1;
			}

			// ReviewBoardDTO 객체생성 set메서드 호출 파라미터값 저장
			ReviewBoardDTO boardDTO = new ReviewBoardDTO();
			boardDTO.setClassNum(reqClassNum);
			boardDTO.setReviewId(memberId);
			boardDTO.setReviewContent(reviewContent);
			boardDTO.setReviewFile(reviewFile);

			// ReviewBoardDAO 객체생성 insertBoard(boardDTO) 호출
			boardDAO = new ReviewBoardDAO();
			boardDAO.insertBoard(boardDTO);
			classNum = reqClassNum;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return classNum;
	}// insertBoard

}
