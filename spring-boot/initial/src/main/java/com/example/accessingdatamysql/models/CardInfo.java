package com.example.accessingdatamysql.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.hibernate.annotations.ManyToAny;

import javax.persistence.*;
import java.util.Set;

@Entity // This tells Hibernate to make a table out of this class
@Table(name = "cardInfo")
public class CardInfo {
    @Id
    @Column(length = 16)
    private String cardNumber;

    @Column(length = 45)
    private String ownerSurname;
    @Column(length = 45)
    private String ownerName;

    @Transient
    private String cvv;

    @Transient
    private String expirationYear;

    @Transient
    private String expirationMonth;

    @JsonIgnoreProperties("cards")
    @ManyToMany(mappedBy = "cards",fetch = FetchType.LAZY)
    private Set<User> users;

    @JsonIgnoreProperties("cardNumber")
    @OneToMany(mappedBy = "cardNumber",fetch = FetchType.LAZY)
    private Set<Order> orders;


    public CardInfo(){

    }

    public CardInfo(String cardNumber, String ownerSurname, String ownerName, String cvv, String expirationYear, String expirationMonth) {
        this.cardNumber = cardNumber;
        this.ownerSurname = ownerSurname;
        this.ownerName = ownerName;
        this.cvv = cvv;
        this.expirationYear = expirationYear;
        this.expirationMonth = expirationMonth;
    }


    @JsonIgnore
    public Set<User> getUsers() {
        return users;
    }
    @JsonIgnore
    public void setUsers(Set<User> users) {
        this.users = users;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public String getOwnerSurname() {
        return ownerSurname;
    }

    public void setOwnerSurname(String ownerSurname) {
        this.ownerSurname = ownerSurname;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }


    public String getCvv() {
        return cvv;
    }

    public void setCvv(String cvv) {
        this.cvv = cvv;
    }

    public String getExpirationYear() {
        return expirationYear;
    }

    public void setExpirationYear(String expirationYear) {
        this.expirationYear = expirationYear;
    }

    public String getExpirationMonth() {
        return expirationMonth;
    }

    public void setExpirationMonth(String expirationMonth) {
        this.expirationMonth = expirationMonth;
    }
}
