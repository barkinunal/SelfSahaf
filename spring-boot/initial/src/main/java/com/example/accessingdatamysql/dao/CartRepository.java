package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.CartItem;
import com.example.accessingdatamysql.models.Product;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface CartRepository extends CrudRepository<CartItem,Integer>{

    @Query("SELECT cart FROM CartItem cart WHERE cart.cartItemID.cartUserID = ?1")
    List<CartItem> findCartItemsByUserID(Integer userID);

    @Query("SELECT cart FROM CartItem cart WHERE cart.cartItemID.cartUserID = ?1 AND cart.cartItemID.sellID = ?2")
    CartItem findCartItemByUserIDAndSellID(Integer userID, Integer sellID);


    @Transactional
    @Modifying
    @Query("DELETE FROM CartItem cart WHERE cartUserID = ?1 and sellID = ?2")
    void deleteByUserIDAndSellID(Integer userID, Integer selllID);
}
