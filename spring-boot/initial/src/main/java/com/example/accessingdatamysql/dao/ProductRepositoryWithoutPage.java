package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.Product;
import com.example.accessingdatamysql.models.Sells;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface ProductRepositoryWithoutPage extends CrudRepository<Product,Integer> {

    /* RAW QUERY VERSION

    SELECT * FROM sells  INNER JOIN (SELECT * FROM price
INNER JOIN
(SELECT productID, sellerID, MAX(datetime) as datetime FROM price group by productID, sellerID ) AS max_id
USING(productID, sellerID, datetime)) as this
  USING(productID, sellerID)
  WHERE sellerID = 1

     */

    @Query("SELECT sell.product FROM Sells sell WHERE sellerID = ?1")
    List<Product> findProductBySellerID(Integer sellerID);


}

