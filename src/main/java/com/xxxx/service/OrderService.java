package com.xxxx.service;

import com.xxxx.bean.Order;
import com.xxxx.bean.Product;
import com.xxxx.bean.vo.MessageModel;
import com.xxxx.mapper.ProductMapper;
import com.xxxx.util.GetSqlSession;
import com.xxxx.util.StringUtil;
import org.apache.ibatis.session.SqlSession;

public class OrderService {
    //增加订单，其中bAt表示buyingAmount（购买数量），bPr表示buyingPrice（某订单总价）
    public MessageModel orderAdding(String uid, String pid, String bAt, String bPr) {
        MessageModel messageModel = new MessageModel();
        Order o = new Order();
        o.setUserid(Integer.valueOf(uid));
        o.setProductId(Integer.valueOf(pid));
        o.setBuyingAmount(Integer.valueOf(bAt));
        o.setBuyingPrice(Integer.valueOf(bPr));

        messageModel.setObject(o);

        if(StringUtil.isEmpty(uid) || StringUtil.isEmpty(pid) || StringUtil.isEmpty(bAt)
          || StringUtil.isEmpty(bPr)){
            messageModel.setCode(0);
            messageModel.setMsg("出现空值！");
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
}
