package com.itwillbs.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.itwillbs.domain.ReviewBoardDTO;

public class ReviewBoardDAO {
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs =null;

	public void dbClose() {
		if(rs != null) {try {rs.close();} catch (SQLException e) {	}}
		if(pstmt != null) {try {pstmt.close();} catch (SQLException e) {	}}
		if(con != null) {try {con.close();} catch (SQLException e) {	}}
	}

	// 클래스 상세페이지 리뷰탭 => 해당 클래스 리뷰 최신 작성순
	public List<ReviewBoardDTO> getBoardList(int classNum) {
		System.out.println("ReviewBoardDAO getBoardList()");
		List<ReviewBoardDTO> boardList = null;
		try {
			// 1 2
			con = new SQLConnection().getConnection();
			// 3
			String sql = "select * from review where classNum=? order by reviewNum desc";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, classNum);
			// 4
			rs = pstmt.executeQuery();
			// 5
			boardList = getList(rs);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbClose();
		}
		return boardList;
	}// getBoardList

	// 마이페이지 나의 리뷰 => 로그인한 아이디로 작성된 리뷰 최신 작성순
	public List<ReviewBoardDTO> getMyBoardList(String reviewId) {
		System.out.println("ReviewBoardDAO getMyBoardList()");
		List<ReviewBoardDTO> boardList = null;
		try {
			// 1 2
			con = new SQLConnection().getConnection();
			// 3
			String sql = "select * from review where reviewId=? order by reviewNum desc";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, reviewId);
			// 4
			rs = pstmt.executeQuery();
			// 5
			boardList = getList(rs);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbClose();
		}
		return boardList;
	}// getMyBoardList

	// 결과 행 => ReviewBoardDTO 리스트로 담기
	private List<ReviewBoardDTO> getList(ResultSet rs) throws SQLException {
		List<ReviewBoardDTO> boardList = new ArrayList<>();
		while(rs.next()) {
			ReviewBoardDTO boardDTO = new ReviewBoardDTO();
			boardDTO.setReviewNum(rs.getInt("reviewNum"));
			boardDTO.setClassNum(rs.getInt("classNum"));
			boardDTO.setReviewId(rs.getString("reviewId"));
			boardDTO.setReviewIssueDate(rs.getTimestamp("reviewIssuedate"));
			boardDTO.setReviewContent(rs.getString("reviewContent"));
			boardDTO.setReviewFile(rs.getString("reviewFile"));
			boardList.add(boardDTO);
		}
		return boardList;
	}// getList

	// 리뷰 작성 권한 => 게스트 + 해당 클래스 예약 + 결제 완료된 내역 있는지 확인
	public boolean checkReviewAuth(String memberId, int classNum) {
		System.out.println("ReviewBoardDAO checkReviewAuth()");
		boolean result = false;
		try {
			// 1 2
			con = new SQLConnection().getConnection();
			// 3 reserve(예약) - payment(결제) - member(회원) 연결
			String sql = "select count(*) from reserve r "
					+ "join payment p on p.reserveNum = r.reserveNum "
					+ "join member m on m.memberNum = r.reserveGuestNum "
					+ "where r.classNum=? and m.memberId=? and m.memberType='guest'";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, classNum);
			pstmt.setString(2, memberId);
			// 4
			rs = pstmt.executeQuery();
			// 5 결제 완료된 예약이 1건 이상이면 작성 가능
			if(rs.next()) {
				result = rs.getInt(1) > 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbClose();
		}
		return result;
	}// checkReviewAuth

	public void insertBoard(ReviewBoardDTO boardDTO) {
		System.out.println("ReviewBoardDAO insertBoard()");
		try {
			// 1 2
			con = new SQLConnection().getConnection();
			// 3
			String sql = "insert into review(classNum,reviewId,reviewIssuedate,reviewContent,reviewFile) values(?,?,now(),?,?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, boardDTO.getClassNum());
			pstmt.setString(2, boardDTO.getReviewId());
			pstmt.setString(3, boardDTO.getReviewContent());
			pstmt.setString(4, boardDTO.getReviewFile());
			// 4
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbClose();
		}
	}// insertBoard

}
