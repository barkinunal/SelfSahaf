package com.example.accessingdatamysql.models;

import javax.persistence.*;

@Entity // This tells Hibernate to make a table out of this class
@Table(name = "shippingcompany")
public class ShippingCompany {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer shippingCompanyID;
    @Column(length = 45)
    private String companyName;

    private float price;
    @Column(length = 45)
    private String website;

    public ShippingCompany() {
    }

    public ShippingCompany(String companyName, float price, String website) {
        this.companyName = companyName;
        this.price = price;
        this.website = website;
    }

    public Integer getShippingCompanyID() {
        return shippingCompanyID;
    }

    public void setShippingCompanyID(Integer shippingCompanyID) {
        this.shippingCompanyID = shippingCompanyID;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }
}
