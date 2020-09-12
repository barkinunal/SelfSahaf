package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.CartItem;
import com.example.accessingdatamysql.models.Order;
import com.example.accessingdatamysql.models.OrderDetail;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface OrderRepository extends CrudRepository<Order, Integer>{
    @Query("SELECT ord FROM Order ord WHERE ord.buyer.userID = ?1")
    List<Order> findOrderByUserID(Integer userID);


    @Query("SELECT Count(ord) FROM Order ord")
    Integer getOrderCount();


}
