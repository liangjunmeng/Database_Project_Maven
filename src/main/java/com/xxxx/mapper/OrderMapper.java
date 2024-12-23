package com.xxxx.mapper;

import com.xxxx.bean.Order;
import java.util.List;

public interface OrderMapper {
    public List<Order> selectAll(int userid);
    public int selectAmount();
    public int maxOrderId();
    public void insertOrder(Order order);
}
