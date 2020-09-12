package com.example.accessingdatamysql.models;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.persistence.*;

@Entity // This tells Hibernate to make a table out of this class
@Table(name = "postalcodecity")
public class PostalCode {

    @Id
    @Column(length = 45)
    private String postalCode;
    @Column(length = 45)
    private String city;
    @Column(length = 45)
    private String country;

    public PostalCode() {
    }

    public PostalCode(String postalCode, String city, String country) {
        this.postalCode = postalCode;
        this.city = city;
        this.country = country;
    }


    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }
}
