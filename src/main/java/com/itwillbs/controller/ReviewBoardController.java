package com.itwillbs.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.itwillbs.domain.ReviewBoardDTO;
import com.itwillbs.service.ReviewBoardService;

public class ReviewBoardController extends HttpServlet{
	RequestDispatcher dispatcher =null;
	ReviewBoardService boardService = null;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("ReviewBoardController doGet()");
		doProcess(request, response);
	}//doGet()

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("ReviewBoardController doPost()");
		doProcess(request, response);
	}//doPost()

	protected void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("ReviewBoardController doProcess()");
		String sPath = request.getServletPath();
		System.out.println("뽑은 가상주소"+sPath);

		if(sPath.equals("/reviewWrite.rbo")) { // 리뷰 작성
			System.out.println("뽑은 가상주소 비교 : /reviewWrite.rbo");
			HttpSession session = request.getSession();
			// "memberId" 세션값 가져오기 => String memberId 변수 저장
			String memberId = (String) session.getAttribute("memberId");
			int classNum = Integer.parseInt(request.getParameter("classNum"));

			boardService = new ReviewBoardService();
			if(memberId == null) {
				// 로그인 안했으면 => 알림 후 로그인페이지 이동
				request.setAttribute("msg", "로그인 후 리뷰를 작성할 수 있습니다.");
				request.setAttribute("url", "login.me");
				dispatcher = request.getRequestDispatcher("board/msg.jsp");
				dispatcher.forward(request, response);
			} else if(boardService.checkReviewAuth(memberId, classNum)) {
				// 결제까지 완료한 게스트 => board/review/write.jsp 주소변경없이 이동
				request.setAttribute("classNum", classNum);
				dispatcher = request.getRequestDispatcher("board/review/write.jsp");
				dispatcher.forward(request, response);
			} else {
				// 결제 내역 없으면 => 알림 후 뒤로이동
				request.setAttribute("msg", "클래스 결제를 완료한 게스트만 리뷰를 작성할 수 있습니다.");
				dispatcher = request.getRequestDispatcher("board/msg.jsp");
				dispatcher.forward(request, response);
			}
		} // reviewWrite

		if(sPath.equals("/reviewWritePro.rbo")) {
			System.out.println("뽑은 가상주소 비교 : /reviewWritePro.rbo");
			// ReviewBoardService 객체생성
			boardService = new ReviewBoardService();
			// insertBoard(request) 메서드 호출 => 저장된 classNum 리턴 (권한 없으면 -1)
			int classNum = boardService.insertBoard(request);
			if(classNum != -1) {
				// 상품 상세페이지 리뷰탭으로 주소변경되면서 이동
				response.sendRedirect("classContent.cbo?classNum=" + classNum + "&tab=review");
			} else {
				request.setAttribute("msg", "리뷰를 작성할 수 없습니다.");
				dispatcher = request.getRequestDispatcher("board/msg.jsp");
				dispatcher.forward(request, response);
			}
		} // reviewWritePro

		if(sPath.equals("/reviewList.rbo")) { // 마이페이지 나의 리뷰
			System.out.println("뽑은 가상주소 비교 : /reviewList.rbo");
			HttpSession session = request.getSession();
			String memberId = (String) session.getAttribute("memberId");

			if(memberId == null) {
				request.setAttribute("msg", "로그인 후 이용할 수 있습니다.");
				request.setAttribute("url", "login.me");
				dispatcher = request.getRequestDispatcher("board/msg.jsp");
				dispatcher.forward(request, response);
			} else {
				boardService = new ReviewBoardService();
				List<ReviewBoardDTO> boardList = boardService.getMyBoardList(memberId);
				request.setAttribute("boardList", boardList);
				dispatcher = request.getRequestDispatcher("board/review/list.jsp");
				dispatcher.forward(request, response);
			}
		} // reviewList

	} // doProcess
}
