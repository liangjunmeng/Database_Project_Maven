package com.xxxx.bean;

public class Wallet {
    private String sources;
    private int balance;
    private int userid;
    private boolean isPrior;//钱包的优先级，便于退订时的资金回退

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
}
