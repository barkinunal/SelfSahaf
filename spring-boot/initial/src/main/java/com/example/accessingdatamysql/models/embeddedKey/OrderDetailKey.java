package com.example.accessingdatamysql.models.embeddedKey;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;


@Embeddable
public class OrderDetailKey implements Serializable{

    @Column(unique = false, nullable = false)
    private Integer orderID;

    @Column(unique = false, nullable = false)
    private Integer sellerID;

    @Column(unique = false, nullable = false)
    private Integer productID;

    @Column(unique = false, nullable = false)
    private Integer shippingInfoID;



    public OrderDetailKey() {
    }

    public OrderDetailKey(Integer orderID, Integer sellerID, Integer productID, Integer shippingInfoID) {
        this.orderID = orderID;
        this.sellerID = sellerID;
        this.productID = productID;
        this.shippingInfoID = shippingInfoID;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof OrderDetailKey)) return false;
        OrderDetailKey that = (OrderDetailKey) o;
        return Objects.equals(getOrderID(), that.getOrderID()) &&
                Objects.equals(getSellerID(), that.getSellerID()) &&
                        Objects.equals(getProductID(), that.getProductID()) &&
                                Objects.equals(getShippingInfoID(), that.getShippingInfoID());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getOrderID(), getSellerID(), getProductID(), getShippingInfoID());
    }


    public Integer getOrderID() {
        return orderID;
    }

    public void setOrderID(Integer orderID) {
        this.orderID = orderID;
    }

    public Integer getSellerID() {
        return sellerID;
    }

    public void setSellerID(Integer sellerID) {
        this.sellerID = sellerID;
    }

    public Integer getProductID() {
        return productID;
    }

    public void setProductID(Integer productID) {
        this.productID = productID;
    }

    public Integer getShippingInfoID() {
        return shippingInfoID;
    }

    public void setShippingInfoID(Integer shippingInfoID) {
        this.shippingInfoID = shippingInfoID;
    }




}
