package com.xxxx.mapper;

import com.xxxx.bean.User;

/*用户接口类*/
public interface UserMapper {
    public User queryuserByName(String username);
    public void insertUser(String username,String password);
}
