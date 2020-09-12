package com.example.accessingdatamysql.models.embeddedKey;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.util.Objects;

@Embeddable
public class ProductCategoryKey {
    @Column
    private Integer productID;
    @Column
    private Integer categoryID;

    public ProductCategoryKey() {
    }

    public ProductCategoryKey(Integer productID, Integer categoryID) {
        this.productID = productID;
        this.categoryID = categoryID;
    }

    public Integer getProductID() {
        return productID;
    }

    public void setProductID(Integer productID) {
        this.productID = productID;
    }

    public Integer getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(Integer categoryID) {
        this.categoryID = categoryID;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof UserAddressKey)) return false;
        UserAddressKey that = (UserAddressKey) o;
        return Objects.equals(getProductID(), that.getUserID()) &&
                Objects.equals(getCategoryID(), that.getAddressID());
    }
    @Override
    public int hashCode() {
        return Objects.hash(getProductID(), getCategoryID());
    }
}
