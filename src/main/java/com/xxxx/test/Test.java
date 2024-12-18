package com.xxxx.test;

import com.xxxx.bean.User;
import com.xxxx.mapper.UserMapper;
import com.xxxx.util.GetSqlSession;
import org.apache.ibatis.session.SqlSession;


public class Test {
    public static void main(String[] args) {

        SqlSession session = GetSqlSession.createSqlSession();
        UserMapper userMapper = session.getMapper(UserMapper.class);
        User user = new User();
        user.setUserid(2);
        user.setUsername("user1");
        user.setPassword("123456");
        userMapper.insertUser(user);
        session.commit();
        System.out.println(userMapper.selectAmount());
        session.close();
    }

}
