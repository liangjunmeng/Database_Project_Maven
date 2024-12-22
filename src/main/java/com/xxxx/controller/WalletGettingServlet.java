package com.xxxx.controller;

import com.google.gson.Gson;
import com.xxxx.bean.Wallet;
import com.xxxx.service.WalletService;
import org.json.JSONObject;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

@WebServlet("/wallet_getting")
public class WalletGettingServlet extends HttpServlet {
    private WalletService walletService = new WalletService();

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
        String userid = jsonObject.getString("userid");
        int uid = Integer.valueOf(userid);


        //获取产品列表
        List<Wallet> wallets = walletService.walletGetting(uid);

        // 将产品列表转换为JSON
        Gson gson = new Gson();
        String json = gson.toJson(wallets);


        // 输出JSON数据
        response.getWriter().write(json);
    }
}
