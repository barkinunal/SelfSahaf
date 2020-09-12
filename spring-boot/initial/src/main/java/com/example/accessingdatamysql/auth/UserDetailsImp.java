package com.example.accessingdatamysql.auth;

import com.example.accessingdatamysql.models.User;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.*;
import java.util.stream.Collectors;

public class UserDetailsImp implements UserDetails {

    private String email;
    private String password;
    private Set<GrantedAuthority> authorities;
    private boolean isEnabled;
    private int userID;

    public UserDetailsImp(User user) {
        this.email = user.getEmail();
        this.password = user.getPassword();
        this.isEnabled = true;
        this.userID = user.getUserID();
        this.authorities = Arrays.stream(user.getRole().split(","))
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toSet());
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    public String getEmail() {
        return email;
    }

    public int getUserID() {
        return userID;
    }
}
