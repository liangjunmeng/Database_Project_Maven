package com.xxxx.controller;

import com.xxxx.bean.vo.MessageModel;
import com.xxxx.service.ProductService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/product_updating")
public class ProductUpdatingServlet extends HttpServlet {
    private ProductService productService = new ProductService();

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取请求参数
        String pid = request.getParameter("productId");
        String pname = request.getParameter("productName");
        String pamount = request.getParameter("productAmount");
        String pprice = request.getParameter("productPrice");

        // 调用业务层方法更新商品
        MessageModel messageModel = productService.productUpdating(pid,pname,pamount,pprice);

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
