package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.CartItem;
import com.example.accessingdatamysql.models.Order;
import com.example.accessingdatamysql.models.OrderDetail;
import com.example.accessingdatamysql.models.User;
import org.aspectj.weaver.ast.Or;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface OrderDetailRepository extends CrudRepository<OrderDetail, Integer>{
    @Query("SELECT ord FROM OrderDetail ord WHERE ord.user.userID = ?1")
    List<OrderDetail> findOrderDetailBySellerID(Integer sellerID);

    @Query("SELECT ord.order FROM OrderDetail ord WHERE ord.user.userID = ?1")
    List<Order> findOrdersBySellerID(Integer sellerID);

    @Query("SELECT ord FROM OrderDetail ord WHERE ord.order.orderID = ?1 AND ord.product.productID = ?2 AND ord.user.userID = ?3")
    OrderDetail findOrderDetailByOrderIDAndProductIDAndSellerID(Integer orderID, Integer productID, Integer sellerID);

    @Query("SELECT ord FROM OrderDetail ord WHERE ord.order.orderID = ?1")
    List<OrderDetail> findOrderDetailsByOrderID(Integer orderID);

    @Query("SELECT ord FROM OrderDetail ord WHERE ord.orderDetailID = ?1")
    OrderDetail findOrderDetailsByOrderDetailID(Integer orderDetailID);


    @Query("SELECT ord.user FROM OrderDetail ord GROUP BY ord.user.userID ORDER BY SUM(ord.quantity) DESC")
    List<User> getTopSellers();
}
