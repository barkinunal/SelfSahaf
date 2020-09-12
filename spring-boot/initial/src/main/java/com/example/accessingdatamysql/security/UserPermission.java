package com.example.accessingdatamysql.security;

public enum UserPermission {

    PRODUCT_READ("product:read"),
    PRODUCT_WRITE("product:write"),
    USER_READ("user:read"),
    USER_WRITE("user:write"),
    SELLER_READ("seller:read"),
    SELLER_WRITE("seller:write");

    private String permission;

    UserPermission(String permission) {
        this.permission = permission;
    }

    public String getPermissions() {
        return permission;
    }
}
