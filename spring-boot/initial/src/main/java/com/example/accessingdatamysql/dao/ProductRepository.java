package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.Product;
import com.example.accessingdatamysql.models.User;
import com.example.accessingdatamysql.models.enums.ProductStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;

public interface ProductRepository extends PagingAndSortingRepository<Product, Integer>
{
    @Query("SELECT sell.product FROM Sells sell WHERE quantity > 0 AND sell.product.status = ?1")
    Page<Product> findAllActive(ProductStatus productStatus,Pageable paging);

}
