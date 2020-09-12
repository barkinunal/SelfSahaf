package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.Product;
import com.example.accessingdatamysql.models.Ratings;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.Optional;

public interface RatingsRepository extends CrudRepository<Ratings,Integer>{
    @Query("SELECT rating.rating FROM Ratings rating WHERE rating.orderDetail.user.userID = ?1")
    List<Integer> findRatingValuesBySellerID(Integer sellerID);

    @Query("SELECT rating FROM Ratings rating WHERE rating.orderDetail.order.orderID = ?1")
    Optional<Ratings> findRatingByOrderID(Integer orderID);

    @Query("SELECT rating FROM Ratings rating WHERE rating.orderDetail.orderDetailID = ?1")
    Optional<Ratings> findRatingsByOrderDetailID(Integer orderDetailID);

    @Query("SELECT rating FROM Ratings rating WHERE rating.orderDetail.user.userID = ?1")
    List<Ratings> findRatingsBySellerID(Integer sellerID);
}
