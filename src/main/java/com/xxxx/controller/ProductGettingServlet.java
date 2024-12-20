package com.xxxx.controller;

import com.google.gson.Gson;
import com.xxxx.bean.Product;
import com.xxxx.service.ProductService;
import org.json.JSONObject;


import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

@WebServlet("/product_getting")
public class ProductGettingServlet extends HttpServlet {

    private ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //获取产品列表
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

    //根据用户输入来搜索相关商品
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 设置响应类型和编码
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 从请求中获取输入流（请求体中的JSON数据）
        StringBuilder stringBuilder = new StringBuilder();
        String line;
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(request.getInputStream(), "UTF-8"))) {
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
            }
        }

        // 将请求体的JSON字符串转换为JSONObject对象(获取了用户输入)
        String requestData = stringBuilder.toString();
        JSONObject jsonObject = new JSONObject(requestData);
        String managerInput = jsonObject.getString("managerInput");



        //获取产品列表
        List<Product> products = productService.productSearching(managerInput);

        // 将产品列表转换为JSON
        Gson gson = new Gson();
        String json = gson.toJson(products);


        // 输出JSON数据
       response.getWriter().write(json);
    }

}
