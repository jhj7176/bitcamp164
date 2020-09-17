package com.bitjeju.stu.att.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bitjeju.stu.att.model.StuAttDao;
import com.bitjeju.stu.att.model.StuAttDto;

@WebServlet("/lmsstuattdetail.bit")
public class stuAttDetailController extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		int num=Integer.parseInt(request.getParameter("num").trim());
		String state=request.getParameter("state").trim();
		System.out.println(num+state);
		try {
			StuAttDao dao=new StuAttDao();
			ArrayList<StuAttDto> list=dao.selectState(num, state);
			request.setAttribute("list", list);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		request.getRequestDispatcher("stuAttDetail.jsp").forward(request, response);
		
	}

}
