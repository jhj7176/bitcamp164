package com.bitjeju.stu.att.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bitjeju.member.model.MemberDto;
import com.bitjeju.stu.att.model.StuAttDao;
import com.bitjeju.stu.att.model.StuAttDto;

@WebServlet("/lmsstuattendance.bit")
public class stuAttListController extends HttpServlet {
	HttpSession session;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		session=request.getSession(false);
		StuAttDto bean=new StuAttDto();
		MemberDto bean2=(MemberDto) session.getAttribute("login");
		int num=bean2.getNum();
		
		try {
			StuAttDao dao=new StuAttDao();
			bean=dao.selectAll(num);
			
			request.setAttribute("bean", bean);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		request.getRequestDispatcher("stuAttendance.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
