package com.example.accessingdatamysql.models.embeddedKey;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class PriceKey implements Serializable {


    @Column
    private Integer productID;

    @Column
    private Integer sellerID;

    @Column(length = 64)
    private String datetime;

    public PriceKey() {
    }

    public PriceKey(Integer productID, Integer sellerID, String datetime) {
        this.productID = productID;
        this.sellerID = sellerID;
        this.datetime = datetime;

    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PriceKey)) return false;
        PriceKey that = (PriceKey) o;
        return Objects.equals(getDatetime(), that.getDatetime()) &&
                Objects.equals(getSellerID(), that.getSellerID()) &&
                Objects.equals(getProductID(), that.getProductID());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getDatetime(), getProductID(), getSellerID());
    }


    public Integer getProductID() {
        return productID;
    }

    public void setProductID(Integer productID) {
        this.productID = productID;
    }

    public Integer getSellerID() {
        return sellerID;
    }

    public void setSellerID(Integer sellerID) {
        this.sellerID = sellerID;
    }

    public String getDatetime() {
        return datetime;
    }

    public void setDatetime(String datetime) {
        this.datetime = datetime;
    }


}
