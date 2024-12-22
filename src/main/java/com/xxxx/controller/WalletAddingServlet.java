package com.xxxx.controller;

import com.xxxx.bean.vo.MessageModel;
import com.xxxx.service.WalletService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/wallet_adding")
public class WalletAddingServlet extends HttpServlet {
    private WalletService walletService = new WalletService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取请求参数
        String uid = request.getParameter("userid");
        String sos = request.getParameter("sources");

        // 调用业务层方法验证用户
        MessageModel messageModel = walletService.walletAdding(Integer.valueOf(uid),sos);

        // 设置响应内容类型为 JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 定义返回的 JSON 数据
        PrintWriter out = response.getWriter();

        if (messageModel.getCode() == 1) {
            // 注册成功：将用户信息设置到 session
            request.getSession().setAttribute("user", messageModel.getObject());
            // 返回 JSON 数据
            out.write("{\"success\": true, \"message\": \"" + messageModel.getMsg() + "\"}");
        }
        else if(messageModel.getCode() == 2){
            // 注册成功：将管理员信息设置到 session
            request.getSession().setAttribute("user", messageModel.getObject());
            // 返回 JSON 数据
            out.write("{\"success\": true, \"message\": \"" + messageModel.getMsg() + "\"}");
        }else {
            // 注册失败：返回错误信息
            out.write("{\"success\": false, \"message\": \"" + messageModel.getMsg() + "\"}");
        }
        out.flush();
    }
}
