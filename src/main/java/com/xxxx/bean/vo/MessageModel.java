package com.xxxx.bean.vo;
/*用于数据响应的消息模型对象
* 状态码（1为正确，0为失败）
* 提示信息（字符串）
* 回显数据（Object对象）
* */
public class MessageModel {
    private Integer code = 1;//状态码
    private String msg = "Success！";//提示信息
    private Object object;//回显对象

    public Integer getCode() {
        return code;
    }

    public String getMsg() {
        return msg;
    }

    public Object getObject() {
        return object;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public void setObject(Object object) {
        this.object = object;
    }
}


