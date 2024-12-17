package com.xxxx.mapper;

import com.xxxx.bean.User;
import org.apache.ibatis.annotations.Param;

/*用户接口类*/
public interface UserMapper {
    public User queryuserByName(String username);
    public void insertUser(@Param("userid") int userid, @Param("username") String username, @Param("password") String password);
    public int maxUserid();
}
