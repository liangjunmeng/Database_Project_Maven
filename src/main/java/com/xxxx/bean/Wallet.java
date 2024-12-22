package com.xxxx.bean;

public class Wallet {
    private String sources;
    private int balance;
    private int userid;
    private int isPrior = 0;//钱包的优先级，便于退订时的资金回退(1表示true，0表示false)

    public String getSources() {
        return sources;
    }

    public void setSources(String sources) {
        this.sources = sources;
    }

    public int getBalance() {
        return balance;
    }

    public void setBalance(int balance) {
        this.balance = balance;
    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public int getIsPrior() {
        return isPrior;
    }

    public void setIsPrior(int isPrior) {
        this.isPrior = isPrior;
    }
}
