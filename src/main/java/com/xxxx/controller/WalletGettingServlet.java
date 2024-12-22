package com.xxxx.controller;

import com.google.gson.Gson;
import com.xxxx.bean.Wallet;
import com.xxxx.service.WalletService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/wallet_getting")
public class WalletGettingServlet extends HttpServlet {
    private WalletService walletService = new WalletService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String uid = request.getParameter("userid");
        int userid = Integer.valueOf(uid);
        //获取产品列表
        List<Wallet> wallets = walletService.walletGetting(userid);

        // 将产品列表转换为JSON
        Gson gson = new Gson();
        String json = gson.toJson(wallets);

        // 设置响应类型和编码
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 输出JSON数据
        response.getWriter().write(json);
    }
}
