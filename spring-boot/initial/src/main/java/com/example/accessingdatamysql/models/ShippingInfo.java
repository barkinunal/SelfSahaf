package com.example.accessingdatamysql.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.persistence.*;
import java.util.Set;

@Entity
@Table(name = "shippinginfo")
public class ShippingInfo {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer shippingInfoID;

    @Column(length = 45)
    private String trackingNumber;

    @OneToOne
    @JoinColumn(name = "shippingCompanyID")
    private ShippingCompany shippingCompanyID;

    /*@OneToOne(mappedBy = "shippingInfo")
    @JoinColumn(name = "shippingCompanyID")
    private OrderDetail orderDetail;*/


    public ShippingInfo(){

    }

    public ShippingInfo(boolean delivered, String trackingNumber, ShippingCompany shippingCompanyID) {
        this.trackingNumber = trackingNumber;
        this.shippingCompanyID = shippingCompanyID;
    }

    public Integer getShippingInfoID() {
        return shippingInfoID;
    }

    public void setShippingInfoID(Integer shippingInfoID) {
        this.shippingInfoID = shippingInfoID;
    }

    public String getTrackingNumber() {
        return trackingNumber;
    }

    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }

    public ShippingCompany getShippingCompanyID() {
        return shippingCompanyID;
    }

    public void setShippingCompanyID(ShippingCompany shippingCompanyID) {
        this.shippingCompanyID = shippingCompanyID;
    }

}
