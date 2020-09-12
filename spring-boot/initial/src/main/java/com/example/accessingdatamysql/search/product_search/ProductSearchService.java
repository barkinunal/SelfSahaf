package com.example.accessingdatamysql.search.product_search;

import com.example.accessingdatamysql.models.Product;
import com.example.accessingdatamysql.models.enums.ProductStatus;
import org.apache.lucene.search.BooleanClause;
import org.apache.lucene.search.BooleanQuery;
import org.apache.lucene.search.Query;
import org.hibernate.search.jpa.FullTextEntityManager;
import org.hibernate.search.jpa.FullTextQuery;
import org.hibernate.search.jpa.Search;
import org.hibernate.search.query.dsl.QueryBuilder;
import org.hibernate.search.query.engine.spi.FacetManager;
import org.hibernate.search.query.facet.Facet;
import org.hibernate.search.query.facet.FacetSelection;
import org.hibernate.search.query.facet.FacetingRequest;
import org.hibernate.search.query.*;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.ArrayList;
import java.util.List;

@Repository
public class ProductSearchService {

    // TODO: Instead of reindexing every time an API called, can check if the data changed.

    @PersistenceContext
    private EntityManager entityManager;


    /*Helper function to create keyword queries*/
    private Query createFieldsQuery(QueryBuilder queryBuilder, List<String> fields, Object match){

        return queryBuilder.keyword()
                .onFields(fields.toArray(new String[0]))
                .matching(match.toString()).createQuery();



    }

    public List<Product> findProductByName(String name, int pageNo, int pageSize) {
        FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
        try {
            fullTextEntityManager.createIndexer().startAndWait();
        } catch (InterruptedException e) {
            System.out.println(e.getMessage());
            System.out.println(e.fillInStackTrace());
        }

        QueryBuilder queryBuilder = fullTextEntityManager
                .getSearchFactory()
                .buildQueryBuilder().forEntity(Product.class)
                .overridesForField( "name", "edgeNGram_query" )
                .get();



        List<String> fields = new ArrayList<String>();
        fields.add("name");
        fields.add("author");

        org.apache.lucene.search.Query query = queryBuilder
                .bool()
                .must(createFieldsQuery(queryBuilder, fields, name))
                .must(queryBuilder.keyword()
                        .onFields("status")
                        .matching(ProductStatus.ACTIVE).createQuery())
                .createQuery();

        // wrap Lucene query in a javax.persistence.Query
        javax.persistence.Query jpaQuery =
                fullTextEntityManager.createFullTextQuery(query, Product.class);

        System.out.println(jpaQuery.getResultList().size());
        jpaQuery.setFirstResult(pageNo * pageSize); // Page size starts at 0.
        jpaQuery.setMaxResults(pageSize);

        // execute search
        return jpaQuery.getResultList();
    }

    public List<Product> findProductByCategory(String category, int pageNo, int pageSize) {
        FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
        try {
            fullTextEntityManager.createIndexer().startAndWait();
        } catch (InterruptedException e) {
            System.out.println(e.getMessage());
            System.out.println(e.fillInStackTrace());
        }

        QueryBuilder queryBuilder = fullTextEntityManager
                .getSearchFactory()
                .buildQueryBuilder().forEntity(Product.class)
                .get();

        org.apache.lucene.search.Query query = queryBuilder
                .bool()
                .must(queryBuilder.keyword()
                    .onField("categories.name")
                    .matching(category)
                    .createQuery())
                .must(queryBuilder.keyword()
                        .onFields("status")
                        .matching(ProductStatus.ACTIVE).createQuery())
                .createQuery();

        // wrap Lucene query in a javax.persistence.Query
        javax.persistence.Query jpaQuery =
                fullTextEntityManager.createFullTextQuery(query, Product.class);

        System.out.println(jpaQuery.getResultList().size());
        jpaQuery.setFirstResult(pageNo * pageSize); // Page size starts at 0.
        jpaQuery.setMaxResults(pageSize);

        return jpaQuery.getResultList();

    }

    public List<Product> findProductByLanguage(String language, int pageNo, int pageSize) {
        FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
        try {
            fullTextEntityManager.createIndexer().startAndWait();
        } catch (InterruptedException e) {
            System.out.println(e.getMessage());
            System.out.println(e.fillInStackTrace());
        }

        QueryBuilder queryBuilder = fullTextEntityManager
                .getSearchFactory()
                .buildQueryBuilder().forEntity(Product.class)
                .get();

        Query query = queryBuilder
                .bool()
                .must(queryBuilder.keyword()
                    .onField("language")
                    .matching(language)
                    .createQuery())
                .must(queryBuilder.keyword()
                        .onFields("status")
                        .matching(ProductStatus.ACTIVE).createQuery())
                .createQuery();

        javax.persistence.Query jpaQuery =
                fullTextEntityManager.createFullTextQuery(query, Product.class);

        System.out.println(jpaQuery.getResultList().size());
        jpaQuery.setFirstResult(pageNo * pageSize); // Page size starts at 0.
        jpaQuery.setMaxResults(pageSize);

        return jpaQuery.getResultList();

    }

    public List<Product> findProductByPriceRange(double from, double to, int pageNo, int pageSize) {
        FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
        try {
            fullTextEntityManager.createIndexer().startAndWait();
        } catch (InterruptedException e) {
            System.out.println(e.getMessage());
            System.out.println(e.fillInStackTrace());
        }

        QueryBuilder queryBuilder = fullTextEntityManager.getSearchFactory().buildQueryBuilder()
                .forEntity(Product.class).get();

        Query query = queryBuilder
                .bool()
                .must(queryBuilder.range()
                        .onField("sells.currentPrice")
                        .from(from).to(to).excludeLimit()
                        .createQuery())
                .must(queryBuilder.keyword()
                        .onFields("status")
                        .matching(ProductStatus.ACTIVE).createQuery())
                .createQuery();


        javax.persistence.Query jpaQuery =
                fullTextEntityManager.createFullTextQuery(query, Product.class);

        System.out.println(jpaQuery.getResultList().size());
        jpaQuery.setFirstResult(pageNo * pageSize); // Page size starts at 0.
        jpaQuery.setMaxResults(pageSize);

        return jpaQuery.getResultList();

    }

    public List<Product> findProductByISBN(String isbn, int pageNo, int pageSize) {
        FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
        try {
            fullTextEntityManager.createIndexer().startAndWait();
        } catch (InterruptedException e) {
            System.out.println(e.getMessage());
            System.out.println(e.fillInStackTrace());
        }

        QueryBuilder queryBuilder = fullTextEntityManager
                .getSearchFactory()
                .buildQueryBuilder().forEntity(Product.class)
                .get();

        Query query = queryBuilder
                .keyword()
                .onField("ISBN")
                .matching(isbn)
                .createQuery();

        javax.persistence.Query jpaQuery =
                fullTextEntityManager.createFullTextQuery(query, Product.class);

        System.out.println(jpaQuery.getResultList().size());
        jpaQuery.setFirstResult(pageNo * pageSize); // Page size starts at 0.
        jpaQuery.setMaxResults(pageSize);

        return jpaQuery.getResultList();

    }
}
