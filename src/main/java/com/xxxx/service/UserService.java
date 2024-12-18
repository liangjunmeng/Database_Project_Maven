package com.xxxx.service;

import com.xxxx.bean.User;
import com.xxxx.bean.vo.MessageModel;
import com.xxxx.mapper.UserMapper;
import com.xxxx.util.GetSqlSession;
import com.xxxx.util.StringUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.List;

/*
* 业务逻辑,判断登录时用户是否存在
*/
public class UserService {
    //用户登录
    public MessageModel userLogin(String uname, String upwd) {
        MessageModel messageModel = new MessageModel();
        User u = new User();
        u.setUsername(uname);
        u.setPassword(upwd);
        messageModel.setObject(u);

        if(StringUtil.isEmpty(uname) || StringUtil.isEmpty(upwd)){
            messageModel.setCode(0);
            messageModel.setMsg("Username or password cannot be empty.");
            return messageModel;
        }

        SqlSession session = GetSqlSession.createSqlSession();
        UserMapper userMapper = session.getMapper(UserMapper.class);
        User user = userMapper.queryuserByName(uname);


        if(user == null){
            messageModel.setCode(0);
            messageModel.setMsg("Username doesnot exit!");
            return messageModel;
        }

        if(!upwd.equals(user.getPassword())){
            messageModel.setCode(0);
            messageModel.setMsg("Wrong Password!");
            return messageModel;
        }

        messageModel.setObject(user);

        return messageModel;
    }
    //用户注册
    public MessageModel userRegister(String uname, String upwd) {
        MessageModel messageModel = new MessageModel();
        User u = new User();
        u.setUsername(uname);
        u.setPassword(upwd);
        messageModel.setObject(u);

        if(StringUtil.isEmpty(uname) || StringUtil.isEmpty(upwd)){
            messageModel.setCode(0);
            messageModel.setMsg("Username or password cannot be empty.");
            return messageModel;
        }

        SqlSession session = GetSqlSession.createSqlSession();
        UserMapper userMapper = session.getMapper(UserMapper.class);
        User user = userMapper.queryuserByName(uname);


        if(user != null){
            messageModel.setCode(0);
            messageModel.setMsg("Username already exits!");
            return messageModel;
        }

        else{
            int userid;
            if(userMapper.selectAmount() == 0){
                userid = 1;
            }
            else{
                userid = userMapper.maxUserid() + 1;
            }
            u.setUserid(userid);
            userMapper.insertUser(u);
            session.commit(); //提交事务，让数据库得以更新
            
            /*默认情况下，MyBatis 使用的是事务管理。如果你在执行插入操作后没有显式提交事务，
            则插入操作可能不会立即生效。特别是如果没有显式调用
            session.commit()，插入操作可能只是存在于本地事务中，
            直到事务结束时才会提交，或者事务在没有提交时被回滚。*/

        }

        messageModel.setObject(user);
        return messageModel;
    }

}
