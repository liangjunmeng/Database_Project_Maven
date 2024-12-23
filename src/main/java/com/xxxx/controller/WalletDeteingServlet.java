package com.xxxx.controller;

import com.xxxx.bean.vo.MessageModel;
import com.xxxx.service.WalletService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/wallet_deleting")
public class WalletDeteingServlet extends HttpServlet {
    private WalletService walletService = new WalletService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取请求参数
        String uid = request.getParameter("userid");
        String sos = request.getParameter("sources");

        // 调用业务层方法验证
        MessageModel messageModel = walletService.deleteWallet(uid,sos);

        // 设置响应内容类型为 JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 定义返回的 JSON 数据
        PrintWriter out = response.getWriter();

        if (messageModel.getCode() == 1) {
            // 返回 JSON 数据
            out.write("{\"success\": true, \"message\": \"" + messageModel.getMsg() + "\"}");
        }else {
            // 注册失败：返回错误信息
            out.write("{\"success\": false, \"message\": \"" + messageModel.getMsg() + "\"}");
        }
        out.flush();
    }
}
