package com.xxxx.bean;
/*用户实体类*/
public class User {
    private Integer userid; //用户编号
    private String username; //用户名
    private String password; //用户密码

    public Integer getUserid() {
        return userid;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public void setUserid(Integer userid) {
        this.userid = userid;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}