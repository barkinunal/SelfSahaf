package com.example.accessingdatamysql.search.product_search;

import com.example.accessingdatamysql.models.Product;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@Api(value = "product_search")
@RequestMapping("/product_search")
public class ProductSearchController {

    @Autowired
    ProductSearchService repository;

    @ApiOperation("search product by name")
    @GetMapping(path = "/searchBookByName")
    public @ResponseBody
    List<Product> searchBookByName(@RequestParam("name") String name,
                                   @RequestParam(defaultValue = "0") Integer pageNo,
                                   @RequestParam(defaultValue = "8") Integer pageSize) {
        return repository.findProductByName(name, pageNo, pageSize);
    }

    @ApiOperation("search product by category")
    @GetMapping(path = "/searchBookByCategory")
    public @ResponseBody
    List<Product> searchBookByCategory(@RequestParam("category") String category,
                                       @RequestParam(defaultValue = "0") Integer pageNo,
                                       @RequestParam(defaultValue = "8") Integer pageSize) {
        return repository.findProductByCategory(category, pageNo, pageSize);
    }

    @ApiOperation("search product by language")
    @GetMapping(path = "/searchBookByLanguage")
    public @ResponseBody
    List<Product> searchBookByLanguage (@RequestParam("language") String language,
                                        @RequestParam(defaultValue = "0") Integer pageNo,
                                        @RequestParam(defaultValue = "8") Integer pageSize) {
        return repository.findProductByLanguage(language, pageNo, pageSize);
    }

    @ApiOperation("search product by price range")
    @GetMapping(path = "/searchBookByPriceRange")
    public @ResponseBody
    List<Product> searchBookByPriceRange (@RequestParam(defaultValue = "0") Double from,
                                          @RequestParam(defaultValue = "999999999") Double to,
                                          @RequestParam(defaultValue = "0") Integer pageNo,
                                          @RequestParam(defaultValue = "8") Integer pageSize) {
        return repository.findProductByPriceRange(from, to, pageNo, pageSize);
    }

    @ApiOperation("search product by ISBN")
    @GetMapping(path = "/searchBookByISBN")
    public @ResponseBody
    List<Product> searchBookByISBN (@RequestParam("isbn") String isbn,
                                        @RequestParam(defaultValue = "0") Integer pageNo,
                                        @RequestParam(defaultValue = "8") Integer pageSize) {
        return repository.findProductByISBN(isbn, pageNo, pageSize);
    }
}
