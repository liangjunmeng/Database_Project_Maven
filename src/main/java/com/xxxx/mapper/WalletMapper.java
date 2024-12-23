package com.xxxx.mapper;

import com.xxxx.bean.Wallet;
import java.util.List;

public interface WalletMapper {
    public List<Wallet> selectAll(int userid);
    public void insertWallet(Wallet wallet);
    public Wallet queryWalletByPri(Wallet wallet);//通过主码查询钱包是否存在
    public void moneyChange(Wallet wallet);
    public void priorChange(Wallet wallet);
    public int queryHighPrior(int userid);//查询高优先级的钱包数
    public Wallet highPriorWallet(int userid);//查询高优先级的钱包对象
    public void deleteWallet(Wallet wallet);//查询高优先级的钱包数
}
