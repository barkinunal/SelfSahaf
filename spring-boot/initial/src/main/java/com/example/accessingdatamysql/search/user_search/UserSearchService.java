package com.example.accessingdatamysql.search.user_search;

import com.example.accessingdatamysql.models.User;
import org.apache.lucene.search.Query;
import org.hibernate.search.jpa.FullTextEntityManager;
import org.hibernate.search.jpa.Search;
import org.hibernate.search.query.dsl.QueryBuilder;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@Repository
public class UserSearchService {

    @PersistenceContext
    private EntityManager entityManager;

    List<User> findUserByName(String name) {

        FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
        try {
            fullTextEntityManager
                    .createIndexer().startAndWait();
        } catch (InterruptedException e) {
            System.out.println(e.getMessage());
            System.out.println(e.fillInStackTrace());
        }

        QueryBuilder queryBuilder = fullTextEntityManager.getSearchFactory()
                .buildQueryBuilder().forEntity(User.class)
                .overridesForField("name", "edgeNGram_query")
                .get();

        Query query = queryBuilder
                .keyword()
                .onFields("name", "surname")
                .matching(name)
                .createQuery();

        javax.persistence.Query jpaQuery = fullTextEntityManager
                .createFullTextQuery(query, User.class);

        return jpaQuery.getResultList();

    }

}
