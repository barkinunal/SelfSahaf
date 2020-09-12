package com.example.accessingdatamysql.models.embeddedKey;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.util.Objects;

@Embeddable
public class CardOwnerKey {
    @Column
    private Integer userID;
    @Column(length = 45)
    private String  cardNumber;

    public CardOwnerKey() {
    }

    public CardOwnerKey(Integer userID, String cardNumber) {
        this.userID = userID;
        this.cardNumber = cardNumber;
    }

    public Integer getUserID() {
        return userID;
    }

    public void setUserID(Integer userID) {
        this.userID = userID;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof UserAddressKey)) return false;
        UserAddressKey that = (UserAddressKey) o;
        return Objects.equals(getUserID(), that.getUserID()) &&
                Objects.equals(getCardNumber(), that.getAddressID());
    }
    @Override
    public int hashCode() {
        return Objects.hash(getUserID(), getCardNumber());
    }
}
