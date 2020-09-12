package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.ShippingCompany;
import org.springframework.data.repository.CrudRepository;
import java.util.Optional;

public interface ShippingRepository extends CrudRepository<ShippingCompany,Integer> {
    Optional<ShippingCompany> findShippingCompanyByCompanyName(String name);
    Optional<ShippingCompany> findShippingCompanyByShippingCompanyID(Integer shippingCompanyID);
}
