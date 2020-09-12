
package com.example.accessingdatamysql.models;

import javax.persistence.*;

@Entity // This tells Hibernate to make a table out of this class
@Table(name = "address")
public class Address {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer addressID;
    @Column(name = "addressName", length = 45)
    private String addressName;
    @Column(name = "addressLine", length = 255)
    private String addressLine;
    @OneToOne(cascade=CascadeType.ALL)
    @JoinColumn(name = "postalCode")
    private PostalCode postalCode;

    public PostalCode getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(PostalCode postalCode) {
        this.postalCode = postalCode;
    }

    public Address() {
    }

    public Address(String addressLine) {
        this.addressLine = addressLine;
    }

    public Address(String addressLine, PostalCode postalCode) {
        this.addressLine = addressLine;
        this.postalCode= postalCode;
    }


    public String getAddressName() {
        return addressName;
    }

    public void setAddressName(String addressName) {
        this.addressName = addressName;
    }

    public Integer getAddressID() {
        return addressID;
    }

    public void setAddressID(Integer addressID) {
        this.addressID = addressID;
    }

    public String getAddressLine() {
        return addressLine;
    }

    public void setAddressLine(String addressLine) {
        this.addressLine = addressLine;
    }

}

