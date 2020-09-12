package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.PostalCode;
import org.springframework.data.repository.CrudRepository;

public interface PostalRepository extends CrudRepository<PostalCode, Integer>
{
    PostalCode findByPostalCode(String postalCode);
}
