
package com.example.accessingdatamysql.models.embeddedKey;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class SellsKey implements Serializable {
    @Column
    private Integer sellerID;
    @Column
    private Integer productID;

    public SellsKey() {
    }

    public SellsKey(Integer sellerID, Integer productID) {
        this.sellerID = sellerID;
        this.productID = productID;
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

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof SellsKey)) return false;
        SellsKey that = (SellsKey) o;
        return Objects.equals(getSellerID(), that.getSellerID()) &&
                Objects.equals(getProductID(), that.getProductID());
    }
    @Override
    public int hashCode() {
        return Objects.hash(getSellerID(), getProductID());
    }
}

