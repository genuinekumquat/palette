package com.itwillbs.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.itwillbs.domain.ClassBoardDTO;
import com.itwillbs.domain.PageDTO;

public class ClassBoardDAO {

	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs =null;

	public void dbClose() {
		if(rs != null) {try {rs.close();} catch (SQLException e) {	}}			
		if(pstmt != null) {try {pstmt.close();} catch (SQLException e) {	}}
		if(con != null) {try {con.close();} catch (SQLException e) {	}}
	}
		
	public List<ClassBoardDTO> getBoardList(PageDTO pageDTO) {
		System.out.println("ClassBoardDAO getBoardList()");
		List<ClassBoardDTO> boardList = null;
		try { 
			// 1 2
			con = new SQLConnection().getConnection();
			// 검색어, 카테고리 있으면 조건 추가
			String sql = "select * from class" + getWhere(pageDTO) + " order by classNum desc limit ?, ?";
			// 3
			pstmt=con.prepareStatement(sql);
			int index = setWhere(pageDTO);
			pstmt.setInt(index, pageDTO.getStartRow()-1); // 시작행 -1
			pstmt.setInt(index+1, pageDTO.getPageSize());//몇개
			//4
			rs =pstmt.executeQuery();
			//5
			boardList = getList(rs);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbClose();
		}
		return boardList;
	}// getBoardList

	// 클래스 관리 => 로그인한 호스트가 등록한 클래스 리스트
	public List<ClassBoardDTO> getMyBoardList(String hostId) {
		System.out.println("ClassBoardDAO getMyBoardList()");
		List<ClassBoardDTO> boardList = null;
		try {
			// 1 2
			con = new SQLConnection().getConnection();
			String sql = "select * from class where hostId=? order by classNum desc";
			// 3
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, hostId);
			//4
			rs =pstmt.executeQuery();
			//5
			boardList = getList(rs);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbClose();
		}
		return boardList;
	}// getMyBoardList

	// 등록된 클래스 카테고리 목록 (중복 제거)
	public List<String> getCategoryList() {
		System.out.println("ClassBoardDAO getCategoryList()");
		List<String> categoryList = new ArrayList<>();
		try {
			// 1 2
			con = new SQLConnection().getConnection();
			String sql = "select distinct classCategory from class where classCategory is not null order by classCategory";
			// 3
			pstmt=con.prepareStatement(sql);
			//4
			rs =pstmt.executeQuery();
			//5
			while(rs.next()) {
				categoryList.add(rs.getString("classCategory"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbClose();
		}
		return categoryList;
	}// getCategoryList

	// 검색어 => 제목에 키워드 포함, 카테고리 => 해당 카테고리만
	private String getWhere(PageDTO pageDTO) {
		String where = " where 1=1";
		if(pageDTO.getSearch() != null) {
			where += " and classSubject like ?";
		}
		if(pageDTO.getCategory() != null) {
			where += " and classCategory = ?";
		}
		return where;
	}// getWhere

	// getWhere() 조건 ? 값 넣기 => 다음 ? 번호 리턴
	private int setWhere(PageDTO pageDTO) throws SQLException {
		int index = 1;
		if(pageDTO.getSearch() != null) {
			// 검색어의 %, _ 는 글자 그대로 검색 (like 와일드카드로 쓰이지 않게)
			String search = pageDTO.getSearch().replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
			pstmt.setString(index++, "%" + search + "%");
		}
		if(pageDTO.getCategory() != null) {
			pstmt.setString(index++, pageDTO.getCategory());
		}
		return index;
	}// setWhere

	// 결과 행 => ClassBoardDTO 리스트로 담기
	private List<ClassBoardDTO> getList(ResultSet rs) throws SQLException {
		List<ClassBoardDTO> boardList = new ArrayList<>();
			while(rs.next()) {
				ClassBoardDTO boardDTO = new ClassBoardDTO();
				boardDTO.setClassNum(rs.getInt("classNum"));
				boardDTO.setClassSubject(rs.getString("classSubject"));
				boardDTO.setHostId(rs.getString("hostId"));
				boardDTO.setClassIssueDate(rs.getTimestamp("classIssuedate"));
				boardDTO.setClassLocation(rs.getString("classLocation"));
				boardDTO.setClassCategory(rs.getString("classCategory"));
				boardDTO.setClassContent(rs.getString("classContent"));
				boardDTO.setClassPrice(rs.getInt("classPrice"));
				boardDTO.setClassFile(rs.getString("classFile"));
				boardList.add(boardDTO);
				}
		return boardList;
	}// getList

	public int getBoardCount(PageDTO pageDTO) {
		System.out.println("ClassBoardDAO getBoardCount()");
		int count =0;
		try {
			// 1단계 2단계
			con = new SQLConnection().getConnection();
			// 3단계 문자열 -> sql구문 변경 (검색어, 카테고리 조건 포함)
			String sql = "select count(*) from class" + getWhere(pageDTO);
			pstmt=con.prepareStatement(sql);
			setWhere(pageDTO);
			//4 실행 => 결과저장
			rs =pstmt.executeQuery();
		if(rs.next()) {
			count = rs.getInt("count(*)");
		}
			// 실행  -> 결과 저장 
			// 5결과 행접근 -> 열접근-> count 변수 저장 
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbClose();
		}
		return count;
	}//getBoardCount

	// 클래스 등록 => 등록된 classNum 리턴 (상세페이지로 이동하기 위해)
	public int insertBoard(ClassBoardDTO boardDTO) {
		System.out.println("BoardDAO insertBoard()");
		int classNum = 0;
		try {
			// 1단계 JDBC 프로그램 가져오기
			// 2단계 디비 연결
			con = new SQLConnection().getConnection();

			// 3단계 문자열 -> sql구문 변경
			String sql = "insert into class(classSubject,hostId,classPrice,classCategory,classLocation,classContent,classFile) values(?,?,?,?,?,?,?)";
			// 자동 증가된 classNum 값 받아오기
			pstmt=con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, boardDTO.getClassSubject());
			pstmt.setString(2, boardDTO.getHostId());
			pstmt.setInt(3, boardDTO.getClassPrice());
			pstmt.setString(4, boardDTO.getClassCategory());
			pstmt.setString(5, boardDTO.getClassLocation());
			pstmt.setString(6, boardDTO.getClassContent());
			// 대표 이미지 파일
			pstmt.setString(7, boardDTO.getClassFile());
			// 4단계 sql구문 실행
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if(rs.next()) {
				classNum = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			dbClose();
		}
		return classNum;
	}//insertBoard()

	public ClassBoardDTO getBoard(int classNum) {
		System.out.println("ClassBoardDAO getBoard()");
		ClassBoardDTO boardDTO = null;
		try {
			con = new SQLConnection().getConnection();
			String sql = "select * from class where classNum=?";
			pstmt=con.prepareStatement(sql);
			pstmt.setInt(1, classNum);
			rs =pstmt.executeQuery();
			
			if(rs.next()) {
				boardDTO = new ClassBoardDTO();
				boardDTO.setClassNum(rs.getInt("classNum"));
				boardDTO.setClassSubject(rs.getString("classSubject"));
				boardDTO.setHostId(rs.getString("hostId"));
				boardDTO.setClassIssueDate(rs.getTimestamp("classIssuedate"));
				boardDTO.setClassLocation(rs.getString("classLocation"));
				boardDTO.setClassCategory(rs.getString("classCategory"));
				boardDTO.setClassContent(rs.getString("classContent"));
				boardDTO.setClassPrice(rs.getInt("classPrice"));
				boardDTO.setClassFile(rs.getString("classFile"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			dbClose();
		}
		return boardDTO;
	} // getBoard
	
	public void updateBoard(ClassBoardDTO boardDTO) {
		try {
			// 1단계 JDBC 프로그램 가져오기 
			// 2단계 디비 연결
			con= new SQLConnection().getConnection();
			// 3단계 sql구문 
			String sql = "update class set classSubject=?,classPrice=?,classCategory=?,classLocation=?,classContent=?,classFile=? where classNum=?";
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, boardDTO.getClassSubject());
			pstmt.setInt(2, boardDTO.getClassPrice());
			pstmt.setString(3, boardDTO.getClassCategory());
			pstmt.setString(4, boardDTO.getClassLocation());
			pstmt.setString(5, boardDTO.getClassContent());
			pstmt.setString(6, boardDTO.getClassFile());
			pstmt.setInt(7, boardDTO.getClassNum());
			// 4단계 실행
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			dbClose();
		}
	}// updateBoard

	public void deleteBoard(int classNum) {
		try {
			// 1단계 JDBC 프로그램 가져오기 
			// 2단계 디비 연결
			con= new SQLConnection().getConnection();
			// 3
			String sql = "delete from class where classNum=?";
			pstmt=con.prepareStatement(sql);
			pstmt.setInt(1, classNum);  
			// 4
			pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				dbClose();
			}
	}// deleteBoard
	
}
