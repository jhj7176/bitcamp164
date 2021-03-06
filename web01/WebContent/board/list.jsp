
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%
	int cardinality = 0; //전체 게시글 수 
int pageNum = 1;
if (request.getParameter("pageNum") != null) {
	pageNum = Integer.parseInt(request.getParameter("pageNum"));
}
int startNum = 1 + (pageNum - 1) * 20;
int endNum = 20 + (pageNum - 1) * 20;//페이지당 게시글 수
/*
1~20 1p					20+(pageNum-1)20
21~40 2p
41~60 3p

max(rn)  maxrn-20


*/
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<style>
a {
	text-decoration: none;
}
</style>
</head>
<body>

	<%@ include file="../template/header.jspf"%>
	<%@ include file="../template/menu.jspf"%>
	<br>


	<table align="center">
		<tr>
			<td colspan="4">
				<h1>자유게시판</h1>
			</td>
		</tr>

		<tr>
			<td colspan="4"><a style="color: black;" href="add.jsp">글쓰기</a></td>
		</tr>
		<tr align="center">
			<td bgcolor="#8c8cf5" width="100" style="color: white;">글번호</td>
			<td bgcolor="#8c8cf5" width="400" style="color: white;">제목</td>
			<td bgcolor="#8c8cf5" width="150" style="color: white;">글쓴이</td>
			<td bgcolor="#8c8cf5" width="150" style="color: white;">날짜</td>
		</tr>

		<%
			String key = request.getParameter("key"); //게시글 컬럼명 제목 or 글쓴이
		String word = request.getParameter("search"); //게시글 검색어
		if (key == null)
			key = "title";
		if (word == null)
			word = "";
		String sql = "select * from (select num,title, writer, wtime, ref, no, lev, rownum as rwn from ";
		sql += "(select * from board where " + key + " like '%" + word + "%' order by ref desc)) ";
		sql += "where rwn between " + startNum + " and " + endNum + "order by ref desc, no";

		String sql2 = "select count(*) from board where " + key + " like '%" + word + "%'"; //총 게시글 수
		SimpleDateFormat sdf1 = new SimpleDateFormat("hh:mm"); //오늘 게시글 시간
		SimpleDateFormat sdf2 = new SimpleDateFormat("yy-MM-dd");//오늘 아닌 게시글 날짜
		Date date = new Date();
		String today = sdf2.format(date); //오늘 날짜 yy-MM-dd, 게시글 날짜와 비교용. 
		String wtime = ""; //게시글 날짜
		try {
			conn = DriverManager.getConnection(url, info);
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql2);
			if (rs.next())
			cardinality = rs.getInt(1); //총 게시글 수, 튜플 수 
			System.out.println(cardinality);
			stmt.close();

			stmt = conn.createStatement();
			stmt.executeQuery(sql);
			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				String replyTitleSpace = "";//답글 제목 앞 여백 
				int lev = rs.getInt("lev");
				for (int i = 0; i < lev; i++) {
			replyTitleSpace += "&nbsp;&nbsp;&nbsp;";
				}
				String re = replyTitleSpace + "[re]"; //여백+[답글마크]
				if (lev == 0)
			re = "";
		%>

		<tr>
			<!-- 글번호 제목 글쓴이 날짜 -->

			<td align="center"><%=rs.getString(1)%></td>
			<!-- 글번호 -->
			<td><a style="color: black;"
				href="detail.jsp?num=<%=rs.getInt(1)%>&writer=<%=rs.getString(3)%>
				&ref=<%=rs.getString("ref")%>&no=<%=rs.getString("no")%>&lev=<%=rs.getString("lev")%>">
					<%=re%> <%=rs.getString(2)%></a></td>
			<!-- 제목 , 파라미터로 글번호,작성자,참조글번호, 글 순서 번호, 들여쓰기레벨 전달-->
			<td align="center"><%=rs.getString(3)%></td>
			<!-- 글쓴이 -->

			<%
				if (sdf2.format(rs.getDate(4)).equals(today)) {
			%>
			<td align="center"><%=sdf1.format(rs.getTimestamp(4))%></td>
			<!-- 오늘날짜면 시간으로 표시 -->
			<%
				} else {
			%>
			<td align="center"><%=sdf2.format(rs.getDate(4))%></td>
			<!-- 오늘 이전이면 yy-MM-dd형식 -->
		</tr>
		<%
			}
		} //while
		} catch (Exception e) {
		e.printStackTrace();
		} finally {
		if (stmt != null)
		stmt.close();
		if (conn != null)
		conn.close();
		}
		%>

	</table>
	<!-- 게시판 끝 -->


	<table align="center">
		<!-- 페이지번호 -->
		<tr>
			<td>
				<%
					//1~19 나머지.

				int lang = 10; //한 페이지당 페이지 링크번호 수. 10개 
				int left = 0;
				if (cardinality % 20 != 0) //게시글 나누기 20의 나머지가 있는 경우 1페이지 추가
					left = 1;
				int totalPage = (cardinality - cardinality % 20) / 20 + left;
				System.out.println(totalPage);
				int start = 1 + ((pageNum - 1) / lang) * lang; //페이지 번호링크 시작
				int end = start + lang; //페이지 번호링크 끝
				if (end > totalPage)
					end = totalPage + 1;
				//pageNum
				/*
				page	start
				1-10		1			1+((pageNum-1)/10)*10
				11-20		11
				21-30		21

				*/
				if (start > lang) {//페이지 링크번호 누른게 10번 페이지보다 크면 prev링크 생성
				%> <a href="list.jsp?pageNum=<%=start - lang%>">[prev]</a> <%
 	}

 for (int i = start; i < end; i++) {
 %> <a href="list.jsp?pageNum=<%=i%>">[<%=i%>]
			</a> <%
 	} //for
 if (end < totalPage) { //마지막 페이지번호링크가 전체페이지수보다 작을때만 next생성
 %> <a href="list.jsp?pageNum=<%=end%>">[next]</a> <%
 	} //if
 %>
			</td>
		</tr>
	</table>


	<br>
	<form action="list.jsp">
		<table align="center">
			<!-- 게시글 검색 -->
			<tr>
				<td><select name="key">
						<!-- 컬럼명 -->
						<option value="title">제목</option>
						<option value="writer">글쓴이</option>
				</select> <input type="text" name="search"><input type="submit"
					value="검색"></td>
				<!-- 검색어 입력 -->
			</tr>
		</table>
	</form>

	<br>
	<%@ include file="../template/footer.jspf"%>


</body>
</html>