package com.xxxx.controller;

import com.google.gson.Gson;
import com.xxxx.service.ProductService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/product_deleting")
public class ProductsDeletingServlet extends HttpServlet {

    private ProductService productService = new ProductService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 读取请求体中的 JSON 数据
        StringBuilder sb = new StringBuilder();
        String line;
        try (InputStream is = request.getInputStream(); BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        } catch (Exception e) {
            throw new ServletException("Error reading request body", e);
        }

        // 将 JSON 数据转换为 Java 对象
        String json = sb.toString();
        Gson gson = new Gson();
        DeleteProductRequest deleteProductRequest = gson.fromJson(json, DeleteProductRequest.class);

        // 获取产品 ID 数组
        List<Integer> productIds = deleteProductRequest.getProductIds();


        // 执行删除操作
        productService.productDeleting(productIds);

        // 构建响应 JSON 数据
        Map<String, Object> responseMap = new HashMap<>();
        boolean success = true;
        responseMap.put("success", success);

        // 设置响应类型和编码
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 输出 JSON 数据
        response.getWriter().write(gson.toJson(responseMap));
    }

    // 辅助类用于解析请求体中的 JSON 数据
    public static class DeleteProductRequest {
        private List<Integer> productIds;

        public List<Integer> getProductIds() {
            return productIds;
        }

        public void setProductIds(List<Integer> productIds) {
            this.productIds = productIds;
        }
    }
}
