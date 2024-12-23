package com.xxxx.service;

import com.xxxx.bean.Order;
import com.xxxx.bean.Product;
import com.xxxx.bean.Wallet;
import com.xxxx.bean.vo.MessageModel;
import com.xxxx.mapper.OrderMapper;
import com.xxxx.mapper.ProductMapper;
import com.xxxx.mapper.WalletMapper;
import com.xxxx.util.GetSqlSession;
import com.xxxx.util.StringUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.List;


public class OrderService {
    //增加订单，其中bAt表示buyingAmount（购买数量），bPr表示buyingPrice（某订单总价）
    public MessageModel orderAdding(String uid, String pid, String bAt, String bPr, String selectedValue) {
        MessageModel messageModel = new MessageModel();
        Order o = new Order();
        o.setUserid(Integer.valueOf(uid));
        o.setProductId(Integer.valueOf(pid));
        o.setBuyingAmount(Integer.valueOf(bAt));
        o.setBuyingPrice(Integer.valueOf(bPr));
        Wallet w =new Wallet();
        w.setUserid(Integer.valueOf(uid));
        w.setBalance(0);
        w.setSources(selectedValue);

        if(StringUtil.isEmpty(uid) || StringUtil.isEmpty(pid) || StringUtil.isEmpty(bAt)
          || StringUtil.isEmpty(bPr) || StringUtil.isEmpty(selectedValue)){
            messageModel.setCode(0);
            messageModel.setMsg("出现空值！");
            return messageModel;
        }

        SqlSession session = GetSqlSession.createSqlSession();
        OrderMapper orderMapper = session.getMapper(OrderMapper.class);
        ProductMapper productMapper = session.getMapper(ProductMapper.class);
        WalletMapper walletMapper = session.getMapper(WalletMapper.class);

        Wallet wallet = walletMapper.queryWalletByPri(w);
        if(wallet == null){
            messageModel.setCode(0);
            messageModel.setMsg("未添加该支付方式！");
            return messageModel;
        }

        if(wallet.getBalance() < Integer.valueOf(bPr)){
            messageModel.setCode(0);
            messageModel.setMsg("余额不足！");
            return messageModel;
        }

        int orderId;
        if(orderMapper.selectAmount() == 0){
            orderId = 1;
        }
        else {
            orderId = orderMapper.maxOrderId() + 1;
        }
        o.setOrderId(orderId);
        Product product = productMapper.queryProductById(Integer.valueOf(pid));
        if(product == null){
            messageModel.setCode(0);
            messageModel.setMsg("商品已下架！");
            return messageModel;
        }
        if(product.getProductAmount() < Integer.valueOf(bAt)){
            messageModel.setCode(0);
            messageModel.setMsg("商品库存不足！");
            return messageModel;
        }
        //购买后钱包余额减少
        wallet.setBalance(0-Integer.valueOf(bPr));
        walletMapper.moneyChange(wallet);
        //购买后商品数量减少
        product.setProductAmount(product.getProductAmount()-Integer.valueOf(bAt));
        productMapper.updateProductById(product);
        o.setProductName(product.getProductName());
        //插入订单
        orderMapper.insertOrder(o);
        messageModel.setMsg("商品购买成功！");
        session.commit(); //提交事务，让数据库得以更新

        messageModel.setObject(o);
        return messageModel;
    }
    //根据用户id遍历所有订单
    public List<Order> orderGetting(int uid) {
        int userid = uid;
        SqlSession session = GetSqlSession.createSqlSession();
        OrderMapper orderMapper = session.getMapper(OrderMapper.class);
        return orderMapper.selectAll(userid);
    }
    //删除订单
    public void orderDeleting(List<Integer> orderIds) {
        SqlSession session = GetSqlSession.createSqlSession();
        ProductMapper productMapper = session.getMapper(ProductMapper.class);
        WalletMapper walletMapper = session.getMapper(WalletMapper.class);
        OrderMapper orderMapper = session.getMapper(OrderMapper.class);

        for (Integer id : orderIds) {
            Order order = orderMapper.queryOrderById(id);
            Product product = productMapper.queryProductById(order.getProductId());
            Wallet wallet = walletMapper.highPriorWallet(order.getUserid());
            List<Wallet> wallets = walletMapper.selectAll(order.getUserid());
            //退订后商品库存增加
            if(product != null){
                product.setProductAmount(product.getProductAmount()+order.getBuyingAmount());
                productMapper.updateProductById(product);
            }
            //退订后钱包余额增加
            //高优先级的钱包余额先增加
            if(wallet != null){
                wallet.setBalance(order.getBuyingPrice());
                walletMapper.moneyChange(wallet);
            }
            //再查看有没有钱包,有则挑选出第一个钱包进行加钱
            else if(!wallets.isEmpty()){
                Wallet wallet2 = wallets.get(0);
                wallet2.setBalance(order.getBuyingPrice());
                walletMapper.moneyChange(wallet2);
            }
            orderMapper.deleteOrderById(id);
        }
        session.commit(); //提交事务，让数据库得以更新
    }
}
