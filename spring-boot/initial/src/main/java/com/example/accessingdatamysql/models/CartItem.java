package com.example.accessingdatamysql.models;

import com.example.accessingdatamysql.models.embeddedKey.CartItemKey;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.hibernate.annotations.ManyToAny;
import org.springframework.data.annotation.Id;

import javax.persistence.*;
import java.util.Set;

@Entity
@Table(name = "cart")
public class CartItem {



    @EmbeddedId
    private CartItemKey cartItemID = new CartItemKey();

    @Column
    private Integer amount;

    @Transient
    private float price;

    @Transient
    private Integer sellerID;

    @Transient
    private Product product;



    @JsonIgnoreProperties("cart")
    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("cartUserID")
    @JoinColumn(name = "cartUserID", referencedColumnName = "userID")
    private User user;



    @JsonIgnoreProperties("cart")
    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("sellID")
    @JoinColumn(name = "sellID",referencedColumnName = "sellingID")
    private Sells sells;

    public CartItem() {

    }

    public CartItem(Integer amount,User user, Sells sells) {
        this.amount = amount;
        this.user = user;
        this.sells = sells;
    }
    @JsonIgnore
    public CartItemKey getCartItemID() {
        return cartItemID;
    }
    @JsonIgnore
    public void setCartItemID(CartItemKey cartItemID) {
        this.cartItemID = cartItemID;
    }
    @JsonIgnore
    public User getUser() {
        return user;
    }
    @JsonIgnore
    public void setUser(User user) {
        this.user = user;
    }

    public Product getProduct() {
        return sells.getProduct();
    }

    public Integer getAmount() {
        return amount;
    }
    public Double getPrice()
    {
        return this.sells.getCurrentPrice();
    }
    public void setAmount(Integer amount) {
        this.amount = amount;
    }
    @JsonIgnore
    public Sells getSells() {
        return sells;
    }
    @JsonIgnore
    public void setSells(Sells sells) {
        this.sells = sells;
    }

    public Integer getSellerID() {
        return this.sells.getSellerID();
    }

    public Integer getProductID() {
        return this.sells.getProductID();
    }
}
