package com.example.accessingdatamysql.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.persistence.*;
import java.util.Set;

@Entity
@Table(name = "order")
public class Order {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer orderID;


    @JsonIgnoreProperties("orders")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "buyerID", referencedColumnName = "userID")
    private User buyer;

    @ManyToOne
    @JoinColumn(name = "cardNumber")
    private CardInfo cardNumber;


    private String datetime;


    private Integer itemCount;



    @OneToOne
    @JoinColumn(name = "receiverAddressID", referencedColumnName = "addressID")
    private Address receiverAddressID;

    public Integer getItemCount() {
        return itemCount;
    }

    public void setItemCount(Integer itemCount) {
        this.itemCount = itemCount;
    }

    public Integer getOrderID() {
        return orderID;
    }

    public void setOrderID(Integer orderID) {
        this.orderID = orderID;
    }
    @JsonIgnore
    public User getBuyer() {
        return buyer;
    }
    @JsonIgnore
    public void setBuyer(User buyer) {
        this.buyer = buyer;
    }
    @JsonIgnore
    public CardInfo getCardNumber() {
        return cardNumber;
    }
    @JsonIgnore
    public void setCardNumber(CardInfo cardNumber) {
        this.cardNumber = cardNumber;
    }

    public String getDatetime() {
        return datetime;
    }

    public void setDatetime(String datetime) {
        this.datetime = datetime;
    }
    @JsonIgnore
    public Address getReceiverAddressID() {
        return receiverAddressID;
    }
    @JsonIgnore
    public void setReceiverAddressID(Address receiverAddressID) {
        this.receiverAddressID = receiverAddressID;
    }


}
