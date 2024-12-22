package com.xxxx.service;

import com.xxxx.bean.Wallet;
import com.xxxx.bean.vo.MessageModel;
import com.xxxx.mapper.WalletMapper;
import com.xxxx.util.GetSqlSession;
import org.apache.ibatis.session.SqlSession;

import java.util.List;

public class WalletService {
    //根据用户id遍历所有钱包
    public List<Wallet> walletGetting(int uid) {
        int userid = uid;
        SqlSession session = GetSqlSession.createSqlSession();
        WalletMapper walletMapper = session.getMapper(WalletMapper.class);
        return walletMapper.selectAll(userid);
    }
    //钱包添加(sos表示sources,blc表示balance,isP表示isPrior)
    public MessageModel walletAdding(int uid, String sos) {
        MessageModel messageModel = new MessageModel();
        Wallet w = new Wallet();
        w.setUserid(uid);
        w.setSources(sos);
        w.setBalance(0);
        w.setIsPrior(0);
        messageModel.setObject(w);

        SqlSession session = GetSqlSession.createSqlSession();
        WalletMapper walletMapper = session.getMapper(WalletMapper.class);
        Wallet wallet = walletMapper.queryWalletByPri(w);

        if(wallet != null){
            messageModel.setCode(0);
            messageModel.setMsg("该支付方式已存在！");
            return messageModel;
        }

        else{
            messageModel.setMsg("支付方式添加成功！");
            walletMapper.insertWallet(w);
            session.commit(); //提交事务，让数据库得以更新

        }

        messageModel.setObject(wallet);
        return messageModel;
    }
}
