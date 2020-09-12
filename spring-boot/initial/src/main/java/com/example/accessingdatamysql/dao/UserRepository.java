package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.User;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.Optional;

// This will be AUTO IMPLEMENTED by Spring into a Bean called userRepository
// CRUD refers Create, Read, Update, Delete

public interface UserRepository extends CrudRepository<User, Integer> {
    Optional<User> findUserByEmail(String email);
    Optional<User> findUserByUserID(Integer userID);

    @Query("SELECT Count(user) FROM User user")
    Integer getUserCount();

    @Query("SELECT Count(user) FROM User user WHERE 'ROLE_SELLER' IN user.role")
    Integer getSellerCount();

    @Query("SELECT user.email from User user")
    Iterable<String> getUserEmails();

}