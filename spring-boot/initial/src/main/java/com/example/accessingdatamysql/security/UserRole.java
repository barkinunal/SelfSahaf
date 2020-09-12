package com.example.accessingdatamysql.security;

import com.google.common.collect.Sets;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.util.Set;
import java.util.stream.Collectors;

import static com.example.accessingdatamysql.security.UserPermission.*;

public enum UserRole {

    USER(Sets.newHashSet(PRODUCT_READ, SELLER_READ)),
    ADMIN(Sets.newHashSet(PRODUCT_READ, PRODUCT_WRITE, USER_READ, USER_WRITE, SELLER_READ, SELLER_WRITE)),
    SELLER(Sets.newHashSet(PRODUCT_READ, SELLER_READ, PRODUCT_WRITE)),
    ANON(Sets.newHashSet());


    private final Set<UserPermission> permissions;

    UserRole(Set<UserPermission> permissions) {
        this.permissions = permissions;
    }

    public Set<UserPermission> getPermissions() {
        return permissions;
    }

    public Set<SimpleGrantedAuthority> getGrantedAuthorities() {
        Set<SimpleGrantedAuthority> permissions = getPermissions().stream()
                .map(permission -> new SimpleGrantedAuthority(permission.getPermissions()))
                .collect(Collectors.toSet());

        permissions.add(new SimpleGrantedAuthority("ROLE_" + this.name()));
        return permissions;
    }
}
