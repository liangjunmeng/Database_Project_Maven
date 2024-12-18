package com.xxxx.mapper;

import com.xxxx.bean.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;


/*用户接口类*/
public interface UserMapper {
    public int selectAmount();
    public User queryuserByName(String username);
    public void insertUser(User user);
    public int maxUserid();
}
