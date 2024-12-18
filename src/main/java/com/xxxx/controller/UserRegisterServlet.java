package com.xxxx.controller;

import com.xxxx.bean.vo.MessageModel;
import com.xxxx.service.UserService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/register")
public class UserRegisterServlet extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uname = request.getParameter("username");
        String upwd = request.getParameter("password");

        MessageModel messageModel = userService.userRegister(uname,upwd);

        if(messageModel.getCode() == 1){
            //将消息模型中的用户信息设置到session作用域中，重定向跳转到首页
            request.getSession().setAttribute("user",messageModel.getObject());
            response.sendRedirect("homepages/home.jsp");
        }else{
            //将消息模型对象设置到request作用域中，请求转发跳转到register.jsp
            request.setAttribute("messageModel",messageModel);
            request.getRequestDispatcher("register.jsp").forward(request,response);
        }
    }
}
