package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.CardInfo;
import org.springframework.data.repository.CrudRepository;

public interface CardRepository extends CrudRepository<CardInfo,Integer> {
}
