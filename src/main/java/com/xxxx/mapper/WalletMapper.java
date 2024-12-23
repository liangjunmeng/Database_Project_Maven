package com.xxxx.mapper;

import com.xxxx.bean.Wallet;
import java.util.List;

public interface WalletMapper {
    public List<Wallet> selectAll(int userid);
    public void insertWallet(Wallet wallet);
    //通过主码查询钱包是否存在
    public Wallet queryWalletByPri(Wallet wallet);
    public void moneyChange(Wallet wallet);
}
