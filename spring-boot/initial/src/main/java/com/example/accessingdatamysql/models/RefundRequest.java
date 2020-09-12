package com.example.accessingdatamysql.models;

import com.example.accessingdatamysql.models.enums.RefundStatus;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "refunds")
public class RefundRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer refundID;


    @JsonIgnoreProperties("ratings")
    @OneToOne
    @JoinColumn(name="orderDetailID", referencedColumnName="orderDetailID")
    private OrderDetail orderDetail;

    @JsonIgnoreProperties("refunds")
    @ManyToOne
    @JoinColumn(name="buyerID", referencedColumnName="userID")
    private User user;

    private String datetime;


    private RefundStatus status;

    @Column(length = 255)
    private String message;

    public RefundRequest() {

    }

    public RefundRequest(OrderDetail orderDetail, String datetime, String message) {
        this.orderDetail = orderDetail;
        this.datetime = datetime;
        this.message = message;
    }

    public Integer getRefundID() {
        return refundID;
    }

    public void setRefundID(Integer refundID) {
        this.refundID = refundID;
    }

    public OrderDetail getOrderDetail() {


        return orderDetail;
    }

    public void setOrderDetail(OrderDetail orderDetail) {
        this.orderDetail = orderDetail;
    }
    @JsonIgnore
    public User getUser() {
        return user;
    }
    @JsonIgnore
    public void setUser(User user) {
        this.user = user;
    }

    public String getDatetime() {
        return datetime;
    }

    public void setDatetime(String datetime) {
        this.datetime = datetime;
    }



    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public RefundStatus getStatus() {
        return status;
    }
    public void setStatus(RefundStatus status) {
        this.status = status;
    }
}
