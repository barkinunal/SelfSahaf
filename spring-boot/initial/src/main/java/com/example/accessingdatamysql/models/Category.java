package com.example.accessingdatamysql.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.hibernate.search.annotations.*;

import javax.persistence.*;
import java.util.Set;

@Entity // This tells Hibernate to make a table out of this class
@Table(name = "categories")
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer categoryID;
    @Column(length = 45)
    @Field(termVector = TermVector.YES, index = org.hibernate.search.annotations.Index.YES, analyze = Analyze.YES, analyzer = @Analyzer(definition = "edgeNgram"), store = Store.NO)
    private String name;

    public Category() {
    }

    public Category(String name) {
        this.name = name;
    }

    @JsonIgnoreProperties("categories")
    @ManyToMany(mappedBy = "categories",fetch = FetchType.LAZY)
    private Set<Product> products;
    @Column
    private Integer discount = 0;

    @JsonIgnore
    public Set<Product> getProducts() {
        return products;
    }

    public Integer getDiscount() {
        return discount;
    }

    public void setDiscount(Integer discount) {
        this.discount = discount;
    }

    public void setProducts(Set<Product> products) {
        this.products = products;
    }

    public Integer getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(Integer categoryID) {
        this.categoryID = categoryID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
