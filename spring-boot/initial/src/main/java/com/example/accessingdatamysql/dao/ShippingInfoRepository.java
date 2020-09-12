package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.ShippingCompany;
import com.example.accessingdatamysql.models.ShippingInfo;
import org.springframework.data.repository.CrudRepository;

public interface ShippingInfoRepository extends CrudRepository<ShippingInfo,Integer> {

}
