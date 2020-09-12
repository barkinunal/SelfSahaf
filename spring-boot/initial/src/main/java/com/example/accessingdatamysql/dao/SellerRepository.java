package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.Sells;
import org.springframework.data.repository.CrudRepository;

public interface SellerRepository extends CrudRepository<Sells,Integer> {
    Sells findBySellerIDAndProductID(Integer sellerID, Integer productID);
}
