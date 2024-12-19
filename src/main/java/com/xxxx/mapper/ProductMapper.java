package com.xxxx.mapper;

import com.xxxx.bean.Product;

import java.util.List;


public interface ProductMapper {
    public int selectAmount();
    public List<Product> selectAll();
    public Product queryProductByName(String productName);
    public void insertProduct(Product product);
    public int maxProductId();
}
