package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.Address;
import com.example.accessingdatamysql.models.User;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface AddressRepository extends CrudRepository<Address, Integer>
{
    Optional<Address> findAddressByAddressID(Integer addressID);

}
