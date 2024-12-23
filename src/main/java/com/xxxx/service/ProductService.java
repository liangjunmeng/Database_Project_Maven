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

public class ProductService {
    //商品添加
    public MessageModel productAdding(String pname, String pamount, String pprice) {
        MessageModel messageModel = new MessageModel();
        Product p = new Product();
        p.setProductName(pname);
        p.setProductAmount(Integer.valueOf(pamount));
        /*
        将字符串转化为数字，因为前端ajax将这些数据转换为var，即字符串形式再传给后端，
        因为前端需要通过检验字符串是否为空判断用户输入的合法性
        */
        p.setProductPrice(Integer.valueOf(pprice));
        messageModel.setObject(p);

        if(StringUtil.isEmpty(pname) || StringUtil.isEmpty(pamount) || StringUtil.isEmpty(pprice)){
            messageModel.setCode(0);
            messageModel.setMsg("商品名、数量或单价不能为空！");
            return messageModel;
        }

        SqlSession session = GetSqlSession.createSqlSession();
        ProductMapper productMapper = session.getMapper(ProductMapper.class);
        Product product = productMapper.queryProductByName(pname);


        if(product != null){
            messageModel.setCode(0);
            messageModel.setMsg("商品名已存在！");
            return messageModel;
        }

        else{
            messageModel.setMsg("商品添加成功！");
            int productId;
            if(productMapper.selectAmount() == 0){
                productId = 1;
            }
            else{
                productId = productMapper.maxProductId() + 1;
            }
            p.setProductId(productId);
            productMapper.insertProduct(p);
            session.commit(); //提交事务，让数据库得以更新


        }

        messageModel.setObject(product);
        return messageModel;
    }

    //商品遍历
    public List<Product> productGetting() {

        SqlSession session = GetSqlSession.createSqlSession();
        ProductMapper productMapper = session.getMapper(ProductMapper.class);
        return productMapper.selectAll();
    }

    //商品遍历(like搜索)
    public List<Product> productSearching(String str) {

        str = StringUtil.addPercentSign(str);

        SqlSession session = GetSqlSession.createSqlSession();
        ProductMapper productMapper = session.getMapper(ProductMapper.class);
        return productMapper.searchProductByLike(str);
    }

    //通过商品id将商品成批删除
    public void productDeleting(List<Integer> ids) {

        SqlSession session = GetSqlSession.createSqlSession();
        ProductMapper productMapper = session.getMapper(ProductMapper.class);
        WalletMapper walletMapper = session.getMapper(WalletMapper.class);
        OrderMapper orderMapper = session.getMapper(OrderMapper.class);

        for (Integer productId : ids) {
            List<Order> orders = orderMapper.queryByProductId(productId);
            if(orders.isEmpty()) {
                productMapper.deleteProductById(productId);
                break;
            }
            for(Order order : orders){
                Wallet wallet = walletMapper.highPriorWallet(order.getUserid());
                List<Wallet> wallets = walletMapper.selectAll(order.getUserid());
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
                orderMapper.deleteOrderById(order.getOrderId());
            }
            productMapper.deleteProductById(productId);
        }
        session.commit(); //提交事务，让数据库得以更新
    }

    //商品更新（以id为依据）
    public MessageModel productUpdating(String pid, String pname, String pamount, String pprice) {
        MessageModel messageModel = new MessageModel();
        Product p = new Product();
        p.setProductId(Integer.valueOf(pid));
        p.setProductName(pname);
        p.setProductAmount(Integer.valueOf(pamount));
        p.setProductPrice(Integer.valueOf(pprice));
        /*
        将字符串转化为数字，因为前端ajax将这些数据转换为var，即字符串形式再传给后端，
        因为前端需要通过检验字符串是否为空判断用户输入的合法性
        */
        messageModel.setObject(p);

        if(StringUtil.isEmpty(pname) || StringUtil.isEmpty(pamount) || StringUtil.isEmpty(pprice)){
            messageModel.setCode(0);
            messageModel.setMsg("商品名、数量或单价不能为空！");
            return messageModel;
        }

        SqlSession session = GetSqlSession.createSqlSession();
        ProductMapper productMapper = session.getMapper(ProductMapper.class);
        Product product = productMapper.queryProductByName(pname);

        //如果更改后的商品名和其他商品（id不同）名有冲突
        if(product != null && product.getProductId()!=p.getProductId()){
            messageModel.setCode(0);
            messageModel.setMsg("商品名已存在！");
            return messageModel;
        }

        else{
            messageModel.setMsg("商品更新成功！");
            productMapper.updateProductById(p);
            session.commit(); //提交事务，让数据库得以更新


        }

        return messageModel;
    }
}
