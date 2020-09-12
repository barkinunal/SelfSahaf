package com.example.accessingdatamysql.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.hibernate.search.annotations.*;

import javax.persistence.*;
import java.util.Set;

@Indexed
@Entity // This tells Hibernate to make a table out of this class
@Table(name = "user")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer userID;
    @Column(length = 45)
    @Field(termVector = TermVector.YES, index = org.hibernate.search.annotations.Index.YES, analyze = Analyze.YES, analyzer = @Analyzer(definition = "edgeNgram"), store = Store.NO)
    private String name;
    @Column(length = 82)
    private String password;
    @Column(length = 45)
    @Field(termVector = TermVector.YES, index = org.hibernate.search.annotations.Index.YES, analyze = Analyze.YES, analyzer = @Analyzer(definition = "edgeNgram"), store = Store.NO)
    private String surname;

    private String dob;
    @Column(length = 45)
    private String phoneNumber;
    @Column(length = 45)
    private String email;
    @Column(length = 45)
    private String role;


    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private Set<CartItem> cart;

    @OneToOne
    @JoinColumn(name = "sellerAddressID")
    private Address sellerAddressID;

    @JsonIgnoreProperties("user")
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL,fetch = FetchType.EAGER)
    private Set<Sells> sells;


    @JsonIgnoreProperties("users")
    @ManyToMany(cascade = CascadeType.ALL,fetch = FetchType.EAGER)
    @JoinTable(
            name = "cardowner",
            joinColumns = @JoinColumn(name = "userID"),
            inverseJoinColumns = @JoinColumn(name = "cardnumber")
    )
    private Set<CardInfo> cards;

    @OneToMany(cascade = CascadeType.ALL)
    @JoinTable(
            name = "useraddress",
            joinColumns = @JoinColumn(name = "userID"),
            inverseJoinColumns = @JoinColumn(name = "addressID")
    )
    private Set<Address> addresses;




    @JsonIgnoreProperties("user")
    @OneToMany(mappedBy = "user", fetch = FetchType.EAGER)
    private Set<OrderDetail> orderdetails;

    @JsonIgnoreProperties("buyer")
    @OneToMany(mappedBy = "buyer", fetch = FetchType.EAGER)
    private Set<Order> orders;




    public User(){
    }

    public User(String name, String password, String surname, String dob, String phoneNumber, String email) {
        this.name = name;
        this.password = password;
        this.surname = surname;
        this.dob = dob;
        this.phoneNumber = phoneNumber;
        this.email = email;
    }

    @JsonIgnore
    public Set<Order> getOrders() {
        return orders;
    }
    @JsonIgnore
    public void setOrders(Set<Order> orders) {
        this.orders = orders;
    }

    @JsonIgnore
    public Set<OrderDetail> getOrderdetails() {
        return orderdetails;
    }

    public void setOrderdetails(Set<OrderDetail> orderdetails) {
        this.orderdetails = orderdetails;
    }

    @JsonIgnore
    public Set<CardInfo> getCards() {
        return cards;
    }

    public void setCards(Set<CardInfo> cards) {
        this.cards = cards;
    }



    @JsonIgnore
    public Set<Sells> getSells() {
        return sells;
    }

    public void setSells(Set<Sells> sells) {
        this.sells = sells;
    }


    public void setSurname(String surname) {
        this.surname = surname;
    }

    @JsonIgnore
    public Set<Address> getAddresses() {
        return addresses;
    }

    public void setAddresses(Set<Address> addresses) {
        this.addresses = addresses;
    }
    @JsonIgnore
    public Address getSellerAddressID() {
        return sellerAddressID;
    }

    public void setSellerAddressID(Address sellerAddressID) {
        this.sellerAddressID = sellerAddressID;
    }

    public Integer getUserID() {
        return userID;
    }

    public void setUserID(Integer userID) {
        this.userID = userID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    public String getSurname() {
        return surname;
    }
    @JsonIgnore
    public Set<CartItem> getCart() {
        return cart;
    }

    @JsonIgnore
    public void setCart(Set<CartItem> cart) {
        this.cart = cart;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

}