package com.xxxx.service;

import com.xxxx.bean.User;
import com.xxxx.bean.Wallet;
import com.xxxx.bean.vo.MessageModel;
import com.xxxx.mapper.UserMapper;
import com.xxxx.mapper.WalletMapper;
import com.xxxx.util.GetSqlSession;
import com.xxxx.util.StringUtil;
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
    //
    public MessageModel moneyUpdate(String uid, String sos, String mny) {
        MessageModel messageModel = new MessageModel();
        Wallet w = new Wallet();
        w.setUserid(Integer.valueOf(uid));
        w.setSources(sos);
        w.setBalance(Integer.valueOf(mny));
        /*
        将字符串转化为数字，因为前端ajax将这些数据转换为var，即字符串形式再传给后端，
        因为前端需要通过检验字符串是否为空判断用户输入的合法性
        */
        messageModel.setObject(w);

        if(StringUtil.isEmpty(sos) || StringUtil.isEmpty(mny)){
            messageModel.setCode(0);
            messageModel.setMsg("存在空值！");
            return messageModel;
        }

        SqlSession session = GetSqlSession.createSqlSession();
        WalletMapper walletMapper = session.getMapper(WalletMapper.class);
        Wallet wallet = walletMapper.queryWalletByPri(w);

        if(wallet == null){
            messageModel.setCode(0);
            messageModel.setMsg("该钱包不存在！");
            return messageModel;
        }

        else{
            messageModel.setMsg("金额更新成功！");
            walletMapper.moneyChange(w);
            session.commit(); //提交事务，让数据库得以更新
        }

        return messageModel;
    }
}
