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

	public List<ReviewBoardDTO> getBoardList() {
		System.out.println("ReviewBoardDAO getBoardList()");
		List<ReviewBoardDTO> boardList = null;
		try {
			con = new SQLConnection().getConnection();
			String sql = "select * from review order by reviewNum desc";
			pstmt.getConnection().prepareStatement(sql);
			rs = pstmt.executeQuery();
			boardList = new ArrayList<>();
			while(rs.next()) {
				ReviewBoardDTO boardDTO = new ReviewBoardDTO();
				boardDTO.setReviewNum(rs.getInt("reviewNum"));
				boardDTO.setClassNum(rs.getInt("classNum"));
				boardDTO.setReviewId(rs.getString("reviewId"));
				
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		return null;
	}

}
