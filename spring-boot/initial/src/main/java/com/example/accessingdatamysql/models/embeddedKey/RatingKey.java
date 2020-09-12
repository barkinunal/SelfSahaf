package com.example.accessingdatamysql.models.embeddedKey;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class RatingKey implements Serializable {


    @Column
    private Integer receiverID;

    @Column
    private Integer raterID;

    @Column
    private Integer productID;



    public RatingKey() {
    }

    public RatingKey(Integer receiverID, Integer raterID, Integer productID) {
        this.receiverID = receiverID;
        this.raterID = raterID;
        this.productID = productID;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof RatingKey)) return false;
        RatingKey that = (RatingKey) o;
        return Objects.equals(getReceiverID(), that.getReceiverID()) &&
                Objects.equals(getRaterID(), that.getRaterID()) &&
                Objects.equals(getProductID(), that.getProductID());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getReceiverID(), getRaterID(), getProductID());
    }


    public Integer getReceiverID() {
        return receiverID;
    }

    public void setReceiverID(Integer receiverID) {
        this.receiverID = receiverID;
    }

    public Integer getRaterID() {
        return raterID;
    }

    public void setRaterID(Integer raterID) {
        this.raterID = raterID;
    }

    public Integer getProductID() {
        return productID;
    }

    public void setProductID(Integer productID) {
        this.productID = productID;
    }



}

