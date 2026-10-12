package com.itwillbs.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.itwillbs.domain.ClassBoardDTO;
import com.itwillbs.domain.MemberDTO;
import com.itwillbs.domain.PageDTO;
import com.itwillbs.domain.ReviewBoardDTO;
import com.itwillbs.service.ClassBoardService;
import com.itwillbs.service.MemberService;
import com.itwillbs.service.ReviewBoardService;

public class ClassBoardController extends HttpServlet { 
	
	RequestDispatcher dispatcher =null;
	ClassBoardService boardService = null;
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("ClassBoardController doGet()");
		doProcess(request, response);
	}//doGet()

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("ClassBoardController doPost()");
		doProcess(request, response);
	}//doPost() 
		
	
	protected void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("ClassBoardController doProcess()");
		String sPath = request.getServletPath();
		System.out.println("뽑은 가상주소"+sPath);
		
		if (sPath.equals("/classList.cbo")) { // 메인에서 클래스테스트 누르면 클래스 리스트 보여줌 
			// 한페이지에 출력될 게시물 수 pageSize
			int pageSize = 6;
			//페이지 번호
			String pageNum = request.getParameter("pageNum");
			// 페이지 번호 없으면 1페이지 설정 
			if(pageNum == null) {
				pageNum = "1";
			}
			// 페이지 번호를 정수형으로 변겅
			 int currentPage = Integer.parseInt(pageNum);
				
			 PageDTO pageDTO = new PageDTO();
			 pageDTO.setPageSize(pageSize);
			 pageDTO.setPageNum(pageNum);
			 pageDTO.setCurrentPage(currentPage);

			//ClassBoardService 객체생성
			boardService = new ClassBoardService();
			List<ClassBoardDTO> boardList = boardService.getBoardList(pageDTO);

			// 게시판 전체 글 개수 구하기 
			int count = boardService.getBoardCount();
			// 한화면에 출력될 페이지개수  pageBlock
			int pageBlock = 10;
			// 시작하는 페이지번호 startPage
			int startPage=(currentPage-1)/pageBlock*pageBlock+1;
			// 끝나는페이지번호 endPage
			int endPage=startPage+pageBlock-1;
			int pageCount = count/pageSize + (count%pageSize==0?0:1);
			
			if(endPage >pageCount) {
				endPage = pageCount; 
			}
			
			// pageDTO에 저장  
			pageDTO.setCount(count);
			pageDTO.setPageBlock(pageBlock);
			pageDTO.setStartPage(startPage);
			pageDTO.setEndPage(endPage);
			pageDTO.setPageCount(pageCount);
			
			
			request.setAttribute("boardList", boardList);
			request.setAttribute("pageDTO", pageDTO);
			// 로그인한 회원정보 => 호스트면 클래스 등록 버튼 보이기
			request.setAttribute("memberDTO", getLoginMember(request));

			System.out.println(boardList);
			dispatcher = request.getRequestDispatcher("board/class/list.jsp");
			dispatcher.forward(request, response);
			} // list
		
		if (sPath.equals("/classWrite.cbo")) { // 클래스 등록
			// 호스트 계정만 등록 가능
			if(!isHost(getLoginMember(request))) {
				alert(request, response, "호스트 계정만 클래스를 등록할 수 있습니다.");
				return;
			}
			// 주소변경없이 이동 board/class/write.jsp
			dispatcher = request.getRequestDispatcher("board/class/write.jsp");
			dispatcher.forward(request, response);
		} // classWrite

		if(sPath.equals("/classWritePro.cbo")) {
			System.out.println("뽑은가상주소비교 :/classWritePro.cbo");
			// 호스트 계정만 등록 가능
			if(!isHost(getLoginMember(request))) {
				alert(request, response, "호스트 계정만 클래스를 등록할 수 있습니다.");
				return;
			}
			// ClassBoardService 객체생성
			boardService = new ClassBoardService();
			// classNum = insertBoard(request) 메서드 호출
			int classNum = boardService.insertBoard(request);
			// 등록한 클래스 상세페이지로 주소변경되면서 이동
			response.sendRedirect("classContent.cbo?classNum=" + classNum);
		} // classWritePro
		
		if(sPath.equals("/classContent.cbo")) { // 클래스 리스트에서 게시물 클릭하면 글내용보기 
			System.out.println("뽑은 가상주소 비교  : /classContent.cbo");
			// BoardService 객체생성
			boardService = new ClassBoardService();
			ClassBoardDTO boardDTO = boardService.getBoard(request);
			// 삭제됐거나 없는 클래스 => 알림 후 클래스 리스트로 이동
			if(boardDTO == null) {
				request.setAttribute("url", "classList.cbo");
				alert(request, response, "존재하지 않는 클래스입니다.");
				return;
			}
			request.setAttribute("boardDTO", boardDTO);
			// 리뷰탭에 보여줄 해당 클래스 리뷰 리스트 (최신 작성순)
			List<ReviewBoardDTO> reviewList = new ReviewBoardService().getBoardList(boardDTO.getClassNum());
			request.setAttribute("reviewList", reviewList);
			// 로그인한 회원정보 => 클래스 등록한 호스트 본인이면 수정, 삭제 버튼 보이기
			request.setAttribute("memberDTO", getLoginMember(request));
			dispatcher = request.getRequestDispatcher("board/class/content.jsp");
			dispatcher.forward(request, response);
		}// classContent
		
		if(sPath.equals("/classUpdate.cbo")) { // 클래스 수정
			// BoardService 객체생성
			boardService = new ClassBoardService();
			// ClassBoardDTO boardDTO  = getBoard(request) 메서드 호출
			ClassBoardDTO boardDTO = boardService.getBoard(request);
			// 클래스 등록한 호스트 본인만 수정 가능
			if(!isOwner(getLoginMember(request), boardDTO)) {
				alert(request, response, "클래스를 등록한 호스트만 수정할 수 있습니다.");
				return;
			}
			// request 데이터(boardDTO) 담아서
			request.setAttribute("boardDTO", boardDTO);
			// 수정하면 board/class/update.jsp 이동
			dispatcher = request.getRequestDispatcher("board/class/update.jsp");
			dispatcher.forward(request, response);
		} // classUpdate
		
		if(sPath.equals("/classUpdatePro.cbo")) {
			// BoardService 객체생성
			boardService = new ClassBoardService();
			// classNum = updateBoard(request) 호출 (등록한 호스트 본인 아니면 -1)
			int classNum = boardService.updateBoard(request);
			if(classNum == -1) {
				alert(request, response, "클래스를 등록한 호스트만 수정할 수 있습니다.");
				return;
			}
			// 수정한 클래스 상세페이지로 주소 변경되면서 이동
			response.sendRedirect("classContent.cbo?classNum=" + classNum);
		} // classUpdatePro

		if(sPath.equals("/classDelete.cbo")) { // 클래스 삭제
			// BoardService 객체생성
			boardService = new ClassBoardService();
			// 클래스 등록한 호스트 본인만 삭제 가능
			ClassBoardDTO boardDTO = boardService.getBoard(request);
			if(!isOwner(getLoginMember(request), boardDTO)) {
				alert(request, response, "클래스를 등록한 호스트만 삭제할 수 있습니다.");
				return;
			}
			//  deleteBoard(request) 호출
			boardService.deleteBoard(request);
			// 주소 변경되면서 classList.cbo 이동
			response.sendRedirect("classList.cbo");
		} // classDelete

	} // doProcess

	// 세션에 로그인한 회원정보 가져오기 (로그인 안했으면 null)
	private MemberDTO getLoginMember(HttpServletRequest request) {
		String memberId = (String) request.getSession().getAttribute("memberId");
		if(memberId == null) {
			return null;
		}
		return new MemberService().getMember(memberId);
	}

	// 멤버 타입이 'host'인지
	private boolean isHost(MemberDTO memberDTO) {
		return memberDTO != null && "host".equals(memberDTO.getMemberType());
	}

	// 클래스를 등록한 호스트 본인인지
	private boolean isOwner(MemberDTO memberDTO, ClassBoardDTO boardDTO) {
		return isHost(memberDTO) && boardDTO != null
				&& memberDTO.getMemberId().equals(boardDTO.getHostId());
	}

	// 알림 메시지 띄우고 뒤로이동 (request에 "url" 있으면 해당 주소로 이동)
	private void alert(HttpServletRequest request, HttpServletResponse response, String msg)
			throws ServletException, IOException {
		request.setAttribute("msg", msg);
		dispatcher = request.getRequestDispatcher("board/msg.jsp");
		dispatcher.forward(request, response);
	}
}// class
