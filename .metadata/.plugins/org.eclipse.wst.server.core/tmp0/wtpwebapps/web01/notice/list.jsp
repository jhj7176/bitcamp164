
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page trimDirectiveWhitespaces="true"%>

<%
	int cardinality = 0; //��ü �Խñ� �� 
int pageNum = 1;
if (request.getParameter("pageNum") != null) {
	pageNum = Integer.parseInt(request.getParameter("pageNum"));
}
int startNum = 1 + (pageNum - 1) * 20;
int endNum = 20 + (pageNum - 1) * 20;//�������� �Խñ� ��
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
				<h1>��������</h1>
			</td>
		</tr>

		<tr>
			<td colspan="4"><a style="color: black;" href="add.jsp">�۾���</a></td>
		</tr>
		<tr align="center">
			<td bgcolor="#8c8cf5" width="100" style="color: white;">�۹�ȣ</td>
			<td bgcolor="#8c8cf5" width="400" style="color: white;">����</td>
			<td bgcolor="#8c8cf5" width="150" style="color: white;">�۾���</td>
			<td bgcolor="#8c8cf5" width="150" style="color: white;">��¥</td>
		</tr>

		<%
		String key= request.getParameter("key");
		String word = request.getParameter("search");
		if(key==null) key = "title";
		if(word==null) word = "";
		
		
		String sql = "select * from (select num,title, writer, wtime, ref, no, lev, rownum as rwn from ";
		sql += "(select num, title, writer, wtime, ref, no, lev from notice order by ref desc, no)) ";
		sql += "where rwn between " + startNum + " and " + endNum + "";
		String sql2 = "select count(*) from notice";
		SimpleDateFormat sdf1 = new SimpleDateFormat("hh:mm");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yy-MM-dd");
		Date date = new Date();
		String today = sdf2.format(date);
		String wtime = "";
		try {
			conn = DriverManager.getConnection(url, info);
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql2);
			if (rs.next())
				cardinality = rs.getInt(1);
		System.out.println(cardinality);
			stmt.close();

			stmt = conn.createStatement();
			stmt.executeQuery(sql);
			rs = stmt.executeQuery(sql);
			while (rs.next()) {
		%>

		<tr>
			<td align="center"><%=rs.getString(1)%></td><!-- �۹�ȣ ���� �۾��� ��¥ -->
			<td><a style="color: black;"
				href="detail.jsp?num=<%=rs.getInt(1)%>&writer=<%=rs.getString(3) %>"><%=rs.getString(2)%></a></td>
			<td align="center"><%=rs.getString(3)%></td>

			<%
				if (sdf2.format(rs.getDate(4)).equals(today)) {
			%>
			<td align="center"><%=sdf1.format(rs.getTimestamp(4))%></td>
			<%
				} else {
			%>
			<td align="center"><%=sdf2.format(rs.getDate(4))%></td>
		</tr>
		<%
			}
		} //while
		} finally {
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
		%>

	</table>
	<!-- �Խ��� �� -->

	
	<table align="center">	<!-- ��������ȣ -->
		<tr>
			<td>
				<%
					//1~19 ������.
				int left = 0;
				if (cardinality % 20 != 0)
					left = 1;
				int totalPage = (cardinality - cardinality % 20) / 20 + left;
				System.out.println(totalPage);
				int start = 1 + ((pageNum - 1) / 10) * 10;
				int end = start + 10;
				if (end > totalPage)
					end = totalPage + 1;
				//pageNum
				/*
				page	start
				1-10		1			1+((pageNum-1)/10)*10
				11-20		11
				21-30		21

				*/
				if (start > 10) {
				%> <a href="list.jsp?pageNum=<%=start - 10%>">[prev]</a> <%
 	}

 for (int i = start; i < end; i++) {
 %> <a href="list.jsp?pageNum=<%=i%>">[<%=i%>]
			</a> <%
 	} //for
 if (end < totalPage) {
 %> <a href="list.jsp?pageNum=<%=end%>">[next]</a> <%
 	} //if
 %>
			</td>
		</tr>
	</table>


	<br>
	<form>
		<table align="center"> <!-- �� �˻� -->
			<tr>
				<td><select name="key">
						<option value="title">����</option>
						<option value="writer">�۾���</option>
				</select> <input type="text" name="search"><input type="submit"
					value="�˻�"></td>
			</tr>
		</table>
	</form>

	<br>
	<%@ include file="../template/footer.jspf"%>


</body>
</html>