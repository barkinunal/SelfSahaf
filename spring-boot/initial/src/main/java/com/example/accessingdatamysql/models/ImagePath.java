package com.example.accessingdatamysql.models;

import com.example.accessingdatamysql.models.embeddedKey.UserAddressKey;
import com.fasterxml.jackson.annotation.JsonInclude;

import javax.persistence.Embeddable;
import javax.persistence.Transient;
import java.util.Objects;
import javax.persistence.Column;

@Embeddable
public class ImagePath
{
    private static final String cons = "root/images/";
    @Column(length = 45)
    private String allPath;


    @Transient
    private String path;

    public ImagePath(){}

    public ImagePath(String path) {
        this.path = path;
        this.allPath = path;
    }

    public void setPath(String path) {
        this.path = path;
        this.allPath = path;
    }

    public String getAllPath() {
        return allPath;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ImagePath)) return false;
        ImagePath that = (ImagePath) o;
        return Objects.equals(this.getAllPath(), that.getAllPath());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getAllPath());
    }
}
