package com.example.accessingdatamysql.models.embeddedKey;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class UserAddressKey implements Serializable{
    @Column
    private Integer userID;
    @Column
    private Integer addressID;

    public UserAddressKey() {
    }

    public UserAddressKey(Integer userID, Integer addressID) {
        this.userID = userID;
        this.addressID = addressID;
    }

    public Integer getUserID() {
        return userID;
    }

    public void setUserID(Integer userID) {
        this.userID = userID;
    }

    public Integer getAddressID() {
        return addressID;
    }

    public void setAddressID(Integer addressID) {
        this.addressID = addressID;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof UserAddressKey)) return false;
        UserAddressKey that = (UserAddressKey) o;
        return Objects.equals(getUserID(), that.getUserID()) &&
                Objects.equals(getAddressID(), that.getAddressID());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getUserID(), getAddressID());
    }
}
