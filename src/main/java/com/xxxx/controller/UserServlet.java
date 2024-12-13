package com.xxxx.controller;

import com.xxxx.bean.vo.MessageModel;
import com.xxxx.service.UserService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
/*用于获得用户请求并返回响应，其中获得的请求交给service层处理*/
@WebServlet("/login")
public class UserServlet extends HttpServlet {


    private UserService userService = new UserService();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uname = request.getParameter("username");
        String upwd = request.getParameter("password");

        MessageModel messageModel = userService.userLogin(uname,upwd);

        if(messageModel.getCode() == 1){
            request.getSession().setAttribute("user",messageModel.getObject());
            response.sendRedirect("homepages/home.jsp");
        }else{
            request.setAttribute("messageModel",messageModel);
            request.getRequestDispatcher("login.jsp").forward(request,response);
        }
    }
}
