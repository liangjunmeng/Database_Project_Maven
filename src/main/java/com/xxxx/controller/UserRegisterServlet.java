package com.xxxx.controller;

import com.xxxx.bean.vo.MessageModel;
import com.xxxx.service.UserService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/register")
public class UserRegisterServlet extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取请求参数
        String uname = request.getParameter("username");
        String upwd = request.getParameter("password");

        // 调用业务层方法验证用户
        MessageModel messageModel = userService.userRegister(uname, upwd);

        // 设置响应内容类型为 JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 定义返回的 JSON 数据
        PrintWriter out = response.getWriter();

        if (messageModel.getCode() == 1) {
            // 注册成功：将用户信息设置到 session
            request.getSession().setAttribute("user", messageModel.getObject());
            // 返回 JSON 数据
            out.write("{\"success\": true, \"message\": \"" + messageModel.getMsg() + "\",\"isManager\": false}");
        }
        else if(messageModel.getCode() == 2){
            // 注册成功：将管理员信息设置到 session
            request.getSession().setAttribute("user", messageModel.getObject());
            // 返回 JSON 数据
            out.write("{\"success\": true, \"message\": \"" + messageModel.getMsg() + "\",\"isManager\": true}");
        }else {
            // 注册失败：返回错误信息
            out.write("{\"success\": false, \"message\": \"" + messageModel.getMsg() + "\",\"isManager\": false}");
        }
        out.flush();
    }
}
