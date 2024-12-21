package com.xxxx.controller;

import com.xxxx.bean.vo.MessageModel;
import com.xxxx.service.ProductService;
import com.xxxx.service.UserService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/user_updating")
public class UserUpdatingServlet extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取请求参数
        String uid = request.getParameter("userid");
        String uname = request.getParameter("username");
        String upwn= request.getParameter("password");

        // 调用业务层方法更新用户
        MessageModel messageModel = userService.userUpdating(uid,uname,upwn);

        // 设置响应内容类型为 JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 定义返回的 JSON 数据
        PrintWriter out = response.getWriter();

        if (messageModel.getCode() == 1) {
            // 登录成功：将用户信息设置到 session
            request.getSession().setAttribute("user", messageModel.getObject());
            // 返回 JSON 数据
            out.write("{\"success\": true, \"message\": \"" + messageModel.getMsg() + "\"}");
        } else {
            // 登录失败：返回错误信息
            out.write("{\"success\": false, \"message\": \"" + messageModel.getMsg() + "\"}");
        }
        out.flush();
    }
}
