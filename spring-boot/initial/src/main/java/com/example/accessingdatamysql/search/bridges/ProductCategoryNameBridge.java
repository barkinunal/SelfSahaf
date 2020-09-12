package com.example.accessingdatamysql.search.bridges;

import com.example.accessingdatamysql.models.Category;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexableField;
import org.hibernate.search.bridge.FieldBridge;
import org.hibernate.search.bridge.LuceneOptions;
import org.hibernate.search.bridge.TwoWayFieldBridge;

import java.util.*;

// NOT USED.
public class ProductCategoryNameBridge implements TwoWayFieldBridge {

    @Override
    public String objectToString(Object o) {
        Category category = (Category) o;
        return category.getName();
    }

    @Override
    public Object get(String s, Document document) {
        Set<Category> categories = new HashSet<>();
        // TODO: NEED TO IMPLEMENT IT.
        return null;
    }

    @Override
    public void set(String name, Object value, Document document, LuceneOptions luceneOptions) {

        if (value == null) {
            return;
        }
        if (!(value instanceof Collection)) {
            throw new IllegalArgumentException("This FieldBridge only supports Collection of String properties.");
        }

        Collection<?> objects = (Collection<?>) value;

        for (Object object : objects) {
            luceneOptions.addFieldToDocument(name, objectToString(object), document);
        }
    }
}
