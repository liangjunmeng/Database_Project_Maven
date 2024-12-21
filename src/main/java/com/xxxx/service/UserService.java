package com.xxxx.service;

import com.xxxx.bean.Product;
import com.xxxx.bean.User;
import com.xxxx.bean.vo.MessageModel;
import com.xxxx.mapper.ProductMapper;
import com.xxxx.mapper.UserMapper;
import com.xxxx.util.GetSqlSession;
import com.xxxx.util.StringUtil;
import org.apache.ibatis.session.SqlSession;


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
            messageModel.setMsg("Username or password can't be empty！");
            return messageModel;
        }

        SqlSession session = GetSqlSession.createSqlSession();
        UserMapper userMapper = session.getMapper(UserMapper.class);
        User user = userMapper.queryuserByName(uname);


        if(user == null){
            messageModel.setCode(0);
            messageModel.setMsg("Username doesn't exit!");
            return messageModel;
        }

        if(!upwd.equals(user.getPassword())){
            messageModel.setCode(0);
            messageModel.setMsg("Wrong Password!");
            return messageModel;
        }

        //判断是否为管理员登录，若id为1则是管理员
        if(user.getUserid() == 1){
            messageModel.setCode(2);
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
            messageModel.setMsg("Username or password can't be empty！");
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

    //用户更新（以id为依据）
    public MessageModel userUpdating(String uid, String uname, String upwn) {
        MessageModel messageModel = new MessageModel();
        User u =new User();
        u.setUserid(Integer.valueOf(uid));
        u.setUsername(uname);
        u.setPassword(upwn);
        /*
        将字符串转化为数字，因为前端ajax将这些数据转换为var，即字符串形式再传给后端，
        因为前端需要通过检验字符串是否为空判断用户输入的合法性
        */
        messageModel.setObject(u);

        if(StringUtil.isEmpty(uname) || StringUtil.isEmpty(upwn)){
            messageModel.setCode(0);
            messageModel.setMsg("用户名或密码不能为空！");
            return messageModel;
        }

        SqlSession session = GetSqlSession.createSqlSession();
        UserMapper userMapper = session.getMapper(UserMapper.class);
        User user = userMapper.queryuserByName(uname);

        //如果更改后的用户名和其他用户（id不同）名有冲突
        if(user != null && user.getUserid()!=u.getUserid()){
            messageModel.setCode(0);
            messageModel.setMsg("用户名已存在！");
            return messageModel;
        }

        else{
            messageModel.setMsg("个人信息更新成功！");
            userMapper.updateUser(u);
            session.commit(); //提交事务，让数据库得以更新


        }

        return messageModel;
    }
}
