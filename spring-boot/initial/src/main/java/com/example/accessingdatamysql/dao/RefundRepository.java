package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.RefundRequest;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface RefundRepository extends CrudRepository<RefundRequest,Integer>{
    @Query("SELECT refund FROM RefundRequest refund WHERE refund.orderDetail.user.userID = ?1")
    List<RefundRequest> findRefundRequestsBySellerID(Integer sellerID);

    List<RefundRequest> findAll();
}
