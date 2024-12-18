package com.xxxx.mapper;

import com.xxxx.bean.Product;
import com.xxxx.bean.User;

public interface ProductMapper {
    public int selectAmount();
    public Product queryProductByName(String productName);
    public void insertProduct(Product product);
    public int maxProductId();
}
