package com.xxxx.controller;

import com.xxxx.bean.vo.MessageModel;
import com.xxxx.service.OrderService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/order_adding")
public class OrderAddingServlet extends HttpServlet {

    private OrderService orderService = new OrderService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取请求参数
        String uid = request.getParameter("userid");
        String pid = request.getParameter("productId");
        String bAt = request.getParameter("buyingAmount");
        String bPr = request.getParameter("buyingPrice");
        String selectedValue = request.getParameter("sources");

        // 调用业务层方法验证订单
        MessageModel messageModel = orderService.orderAdding(uid,pid,bAt,bPr,selectedValue);

        // 设置响应内容类型为 JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 定义返回的 JSON 数据
        PrintWriter out = response.getWriter();

        if (messageModel.getCode() == 1) {
            // 返回 JSON 数据
            out.write("{\"success\": true, \"message\": \"" + messageModel.getMsg() + "\"}");
        } else {
            // 登录失败：返回错误信息
            out.write("{\"success\": false, \"message\": \"" + messageModel.getMsg() + "\"}");
        }
        out.flush();
    }
}
