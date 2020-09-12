package com.example.accessingdatamysql.models;

import com.example.accessingdatamysql.models.embeddedKey.PriceKey;
import com.example.accessingdatamysql.models.embeddedKey.RatingKey;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.persistence.*;

@Entity
@Table(name = "ratings")
public class Ratings {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer ratingID;

    @JsonIgnoreProperties("ratings")
    @OneToOne
    @JoinColumn(name="orderDetailID", referencedColumnName="orderDetailID")

    private OrderDetail orderDetail;



    @JsonIgnoreProperties("ratings")
    @ManyToOne
    @JoinColumn(name="buyerID", referencedColumnName="userID")
    private User user;

    private String datetime;
    private Integer rating;
    @Column(length = 255)
    private String comment;

    public Ratings() {
    }

    public Ratings(User user, String datetime, Integer rating, String comment) {
        this.user = user;
        this.datetime = datetime;
        this.rating = rating;
        this.comment = comment;
    }

    public Integer getRatingID() {
        return ratingID;
    }
    @JsonIgnore
    public void setRatingID(Integer ratingID) {
        this.ratingID = ratingID;
    }
    @JsonIgnore
    public OrderDetail getOrderDetail() {
        return orderDetail;
    }
    @JsonIgnore
    public void setOrderDetail(OrderDetail orderDetail) {
        this.orderDetail = orderDetail;
    }

    @JsonIgnore
    public User getUser() {
        return user;
    }
    @JsonIgnore
    public void setUser(User userr) {
        this.user = userr;
    }

    public String getDatetime() {
        return datetime;
    }
    @JsonIgnore
    public void setDatetime(String datetime) {
        this.datetime = datetime;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }
}

