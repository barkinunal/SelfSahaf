package com.example.accessingdatamysql.models.embeddedKey;

import javax.persistence.Column;
import javax.persistence.Embeddable;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class CartItemKey implements Serializable {




    @Column
    private Integer cartUserID;

    @Column
    private Integer sellID;




    public CartItemKey(){

    }

    public CartItemKey(Integer userID, Integer sellID){

        this.cartUserID = userID;
        this.sellID = sellID;

    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof CartItemKey)) return false;
        CartItemKey that = (CartItemKey) o;
        return Objects.equals(getCartUserID(), that.getCartUserID()) &&
                Objects.equals(getSellID(), that.getSellID());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getCartUserID(), getSellID());
    }



    public Integer getSellID() {
        return sellID;
    }

    public void setSellID(Integer sellID) {
        this.sellID = sellID;
    }

    public Integer getCartUserID() {
        return cartUserID;
    }

    public void setCartUserID(Integer cartUserID) {
        this.cartUserID = cartUserID;
    }



}
