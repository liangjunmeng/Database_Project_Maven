package com.xxxx.controller;

import com.google.gson.Gson;
import com.xxxx.bean.Product;
import com.xxxx.service.ProductService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/product_getting")
public class ProductGettingServlet extends HttpServlet {

    private ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 假设你有一个方法来获取产品列表
        List<Product> products = productService.productGetting();

        // 将产品列表转换为JSON
        Gson gson = new Gson();
        String json = gson.toJson(products);

        // 设置响应类型和编码
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 输出JSON数据
        response.getWriter().write(json);
    }

}
