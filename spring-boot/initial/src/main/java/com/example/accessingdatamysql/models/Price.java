package com.example.accessingdatamysql.models;

import com.example.accessingdatamysql.models.embeddedKey.PriceKey;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
@Entity
@Table(name = "price")
public class Price {

    @EmbeddedId
    private PriceKey priceID;


    @JsonIgnoreProperties("prices")
    @ManyToOne

    @JoinColumns(
            {
                    @JoinColumn(updatable=false,insertable=false, name="sellerID", referencedColumnName="sellerID"),
                    @JoinColumn(updatable=false,insertable=false, name="productID", referencedColumnName="productID"),
            })
    private Sells sells;



    private Double price;

    @Column
    private Integer discount;

    public Price(){}


    public Price(PriceKey priceID, Sells sells, Double price, Integer discount) {
        this.priceID = priceID;
        this.sells = sells;
        this.price = price;
        this.discount = discount;
    }

    public Price(PriceKey priceID, Sells sells, Double price) {
        this.priceID = priceID;
        this.sells = sells;
        this.price = price;
        this.discount = 0;
    }

    public Integer getDiscount() {
        return discount;
    }

    public void setDiscount(Integer discount) {
        this.discount = discount;
    }

    @JsonIgnore
    public PriceKey getPriceID() {
        return priceID;
    }

    public void setPriceID(PriceKey priceID) {
        this.priceID = priceID;
    }
    public String getDate(){ return priceID.getDatetime();}


    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Sells getSells() {
        return sells;
    }

    public void setSells(Sells sells) {
        this.sells = sells;
    }


}
