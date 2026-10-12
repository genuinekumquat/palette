package com.itwillbs.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.itwillbs.dao.ClassBoardDAO;
import com.itwillbs.domain.ClassBoardDTO;
import com.itwillbs.domain.PageDTO;
import com.itwillbs.util.FileUpload;
import com.oreilly.servlet.MultipartRequest;

public class ClassBoardService {
	
	ClassBoardDAO boardDAO = null; 

	public List<ClassBoardDTO> getBoardList(PageDTO pageDTO) {
		System.out.println("ClassBoardService getBoardList()");
		List<ClassBoardDTO>boardList = null;
		try {
			// int startRow = 계산식; 
			int startRow = (pageDTO.getCurrentPage()-1)*pageDTO.getPageSize()+1;
			// 시작하는 행	부터 끝나는 행까지 뽑아오기 

			// int endRow = 계산식;      
			int endRow = startRow+pageDTO.getPageSize()-1;
			//pageDTO 저장 <- startRow, endRow
			pageDTO.setStartRow(startRow);
			pageDTO.setEndRow(endRow);
					
			boardDAO = new ClassBoardDAO();
			boardList = boardDAO.getBoardList(pageDTO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return boardList;
	}// getBoardList

	public int getBoardCount() {
		System.out.println("ClassBoardService getBoardCount()");
		int count=0;
		try {
			// BoardDAO 객체생성
			boardDAO = new ClassBoardDAO();
			// count = getBoardCount() 호출
			count = boardDAO.getBoardCount();
		} catch (Exception e) {
			e.printStackTrace();
			}
		return count;
	}//getBoardCount

	// 클래스 등록 => 등록된 classNum 리턴
	public int insertBoard(HttpServletRequest request) {
		System.out.println("ClassBoardService insertBoard()");
		int classNum = 0;
		try {
			// cos.jar MultipartRequest => 대표 이미지 업로드 (한글처리 utf-8 포함)
			MultipartRequest multi = FileUpload.upload(request);
			// multi 파라미터값 가져오기
			String classSubject = multi.getParameter("classSubject");
			int classPrice = Integer.parseInt(multi.getParameter("classPrice"));
			String classCategory = multi.getParameter("classCategory");
			String classLocation = multi.getParameter("classLocation");
			String classContent = multi.getParameter("classContent");
			String classFile = multi.getFilesystemName("classFile");
			// BoardDAO 객체생성 
			boardDAO = new ClassBoardDAO();
			// BoardDTO 객체생성  
			ClassBoardDTO boardDTO = new ClassBoardDTO();
			HttpSession session = request.getSession();
			// set메서드 호출 파라미터값 저장 
			boardDTO.setClassSubject(classSubject);
			boardDTO.setHostId(session.getAttribute("memberId").toString());
			boardDTO.setClassPrice(classPrice);
			boardDTO.setClassCategory(classCategory);
			boardDTO.setClassLocation(classLocation);
			boardDTO.setClassContent(classContent);
			boardDTO.setClassFile(classFile);
			System.out.println(boardDTO.getHostId());
			// classNum = insertBoard(boardDTO) 호출
			classNum = boardDAO.insertBoard(boardDTO);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return classNum;
	}//insertBoard()

	public ClassBoardDTO getBoard(HttpServletRequest request) {
		System.out.println("ClassBoardService getBoard()");
		ClassBoardDTO boardDTO = null;
		try {
			// request 한글처리 
			request.setCharacterEncoding("utf-8");
			// request에 classNum 파라미터 값 가져오기
			int classNum = Integer.parseInt(request.getParameter("classNum"));
			System.out.println(classNum);
			// BoardDAO 객체생성 
			boardDAO = new ClassBoardDAO();
			// boardDTO = getBoard(classNum);
			boardDTO = boardDAO.getBoard(classNum);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return boardDTO;
	} // getBoard
	
	// 클래스 수정 => 수정된 classNum 리턴, 등록한 호스트 본인 아니면 -1 리턴
	public int updateBoard(HttpServletRequest request) {
		int classNum = 0;
		try {
			// cos.jar MultipartRequest => 새 대표 이미지 업로드 (한글처리 utf-8 포함)
			MultipartRequest multi = FileUpload.upload(request);
			// multi 값 가져오기, BoardDTO 값저장
			classNum = Integer.parseInt(multi.getParameter("classNum"));
			String classSubject = multi.getParameter("classSubject");
			int classPrice = Integer.parseInt(multi.getParameter("classPrice"));
			String classCategory = multi.getParameter("classCategory");
			String classLocation = multi.getParameter("classLocation");
			String classContent = multi.getParameter("classContent");
			String classFile = multi.getFilesystemName("classFile");

			// 기존 이미지 => 디비에서 가져오기
			boardDAO = new ClassBoardDAO();
			ClassBoardDTO oldDTO = boardDAO.getBoard(classNum);

			// 세션 로그인 아이디 == 클래스 등록한 호스트 아이디 인지 확인
			String memberId = (String)request.getSession().getAttribute("memberId");
			if(oldDTO == null || memberId == null || !memberId.equals(oldDTO.getHostId())) {
				// 본인 아니면 업로드된 파일 삭제
				FileUpload.delete(request, classFile);
				return -1;
			}

			String oldFile = oldDTO.getClassFile();
			if(classFile == null) {
				// 새 이미지 선택 안했으면 기존 이미지 유지
				classFile = oldFile;
			} else if(oldFile != null && !oldFile.equals(classFile)) {
				// 새 이미지로 교체했으면 기존 이미지 파일 삭제
				FileUpload.delete(request, oldFile);
			}

			ClassBoardDTO boardDTO =new ClassBoardDTO();
			boardDTO.setClassNum(classNum);
			boardDTO.setClassSubject(classSubject);
			boardDTO.setClassPrice(classPrice);
			boardDTO.setClassCategory(classCategory);
			boardDTO.setClassLocation(classLocation);
			boardDTO.setClassContent(classContent);
			boardDTO.setClassFile(classFile);

			// BoardDAO 객체생성 updateBoard(boardDTO) 호출
			boardDAO = new ClassBoardDAO();
			boardDAO.updateBoard(boardDTO);

		} catch (Exception e) {
			e.printStackTrace();
		}// updateBoard
		return classNum;
	}

	public void deleteBoard(HttpServletRequest request) {
		try {
			// request 파라미터값 가져오기
			int classNum = Integer.parseInt(request.getParameter("classNum"));
			// => BoardDAO 객체생성 deleteBoard(classNum) 호출
			boardDAO = new ClassBoardDAO();
			// 삭제할 클래스 대표 이미지 파일도 삭제
			ClassBoardDTO boardDTO = boardDAO.getBoard(classNum);
			boardDAO.deleteBoard(classNum);
			if(boardDTO != null) {
				FileUpload.delete(request, boardDTO.getClassFile());
			}
			} catch (Exception e) {
				e.printStackTrace();
			}
	}// deleteBoard
	

}// 클래스



