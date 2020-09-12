package com.example.accessingdatamysql.dao;

import com.example.accessingdatamysql.models.Category;
import org.springframework.data.repository.CrudRepository;

public interface CategoryRepository extends CrudRepository<Category,Integer>{
}
