package com.xxxx.mapper;

import com.xxxx.bean.Order;

public interface OrderMapper {
    public int selectAmount();
    public int maxOrderId();
    public void insertOrder(Order order);
}
