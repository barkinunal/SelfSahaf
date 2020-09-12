package com.example.accessingdatamysql.controllers;

import com.example.accessingdatamysql.Services.ProductService;
import com.example.accessingdatamysql.auth.UserDetailsImp;
import com.example.accessingdatamysql.dao.*;
import com.example.accessingdatamysql.models.*;
import com.example.accessingdatamysql.models.embeddedKey.PriceKey;
import com.example.accessingdatamysql.models.embeddedKey.SellsKey;
import com.example.accessingdatamysql.models.enums.ProductStatus;
import com.example.accessingdatamysql.storage.StorageService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import com.example.accessingdatamysql.models.FilterObject;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import org.springframework.core.io.Resource;

import javax.print.attribute.standard.Media;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.List;

@Controller
@RequestMapping("/product")
@Api(value = "product", description = "Controller about products and categories")
public class ProductController {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductRepositoryWithoutPage productRepositoryWithoutPage;

    @Autowired
    private ProductService service;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private SellerRepository sellerRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StorageService storageService;


    @ApiOperation("add new selling")
    @PostMapping(path ="/addBook")
    public @ResponseBody
    String addBook(@RequestParam Double price, @RequestParam Integer quantity, @RequestBody Product product) {
        Product pr = productRepository.save(product);
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Integer sellerID = ((UserDetailsImp) auth.getPrincipal()).getUserID();

        Sells sells = new Sells();

        sells.setProductID(pr.getProductID());
        sells.setSellerID(sellerID);

        Price price1 = new Price();
        LocalDateTime datetime = LocalDateTime.ofInstant(Instant.now(), ZoneOffset.ofHoursMinutes(3,0));
        String formatted = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm:ss").format(datetime);
        price1.setPriceID(new PriceKey(pr.getProductID(),sellerID, formatted));
        price1.setPrice(price);
        price1.setDiscount(0);
        Set<Price> prices = new HashSet<Price>();

        prices.add(price1);
        sells.setPrice(prices);
        sells.setQuantity(quantity);
        sells.setCurrentPrice(price);
        sells.setProduct(pr);
        Optional<User> user = userRepository.findUserByUserID(sellerID);
        sells.setUser(user.get());

        sellerRepository.save(sells);
        return pr.getProductID().toString();
    }
    @ApiOperation("update Product")
    @PostMapping(path ="/updateBook")
    public @ResponseBody
    String updateBook( @RequestBody Product product,@RequestParam Double price, @RequestParam Integer quantity,  @RequestParam(defaultValue = "0") Integer discount,HttpServletResponse response)
    {
        boolean flag = false;
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Integer sellerID = ((UserDetailsImp) auth.getPrincipal()).getUserID();
        if(product.getProductID() == null){
            response.setStatus( HttpServletResponse.SC_FORBIDDEN);
            return "there is no such book";
        }
        Product pr  =productRepositoryWithoutPage.findById(product.getProductID()).get();

        for (Sells sell : pr.getSells())
        {
            if(sell.getSellerID() == sellerID)
            {
                LocalDateTime datetime = LocalDateTime.ofInstant(Instant.now(), ZoneOffset.ofHoursMinutes(3,0));
                String formatted = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm:ss").format(datetime);
                PriceKey priceKey = new PriceKey(product.getProductID(),sell.getSellerID(),formatted);
                Set<Price> prices = sell.getPriceList();
                prices.add(new Price(priceKey,sell,price,discount));
                sell.setPrice(prices);
                sell.setCurrentPrice(price);
                if(quantity == 0){
                    sell.getProduct().setStatus(ProductStatus.DEACTIVE);
                }
                sell.setQuantity(quantity);
                flag = true;
            }
        }
        product.setSoldCount(pr.getSoldCount());
        if(!flag)
        {
            response.setStatus( HttpServletResponse.SC_FORBIDDEN);
            return "Product you want to update is either not your product or nonexistent";
        }
        productRepositoryWithoutPage.save(product);
        return "saved";

    }

    @ApiOperation("Get Best Sellers")
    @GetMapping("/bestSeller")
    public @ResponseBody Iterable<Product> getBestSellers(@RequestParam(defaultValue = "0") Integer pageNo,
                                                          @RequestParam(defaultValue = "10") Integer pageSize)
    {
        return service.getBestSellers(pageNo,pageSize);
    }

    @ApiOperation("delete book by id")
    @DeleteMapping("/deleteBook")
    public @ResponseBody String deleteBook(@RequestParam Integer productId, HttpServletResponse response)
    {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Integer sellerID = ((UserDetailsImp) auth.getPrincipal()).getUserID();
        List<Product> prs = productRepositoryWithoutPage.findProductBySellerID(sellerID);
        for (Product pr:prs) {
            if(pr.getProductID() == productId){
                productRepositoryWithoutPage.deleteById(productId);
                return "deleted";
            }
        }
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        return "Product you want to delete is either not your product or nonexistent";
    }


    @ApiOperation("add new category, this will have admin auth")
    @PostMapping(path = "/addCategory") // Admin
    public @ResponseBody String addCategory(@RequestParam String name) {
        Category category = new Category(name);
        categoryRepository.save(category);
        return "Category Saved";
    }
    @ApiOperation("get categories")
    @GetMapping(path = "/getCategories")
    public @ResponseBody Iterable<Category> getCategories()
    {
        return categoryRepository.findAll();
    }

    @ApiOperation("Get Products")
    @GetMapping(path = "/getBooks")
    public @ResponseBody
    Iterable<Product> getProducts(@RequestParam(defaultValue = "0") Integer pageNo,
                                  @RequestParam(defaultValue = "2") Integer pageSize,
                                  @RequestParam(defaultValue = "productID") String sortBy,
                                  @RequestParam(defaultValue = "true") boolean ascending) {
        Iterable<Product> list = service.getAll(pageNo,pageSize,sortBy,ascending);
        return list;
        //return productRepository.findAll(pageable);
    }

    @GetMapping(path = "/getSellerBooks")
    public @ResponseBody
    List<Product> getSellerProducts(@RequestParam Integer  sellerID) {

        return productRepositoryWithoutPage.findProductBySellerID(sellerID);
        //return productRepository.findAll(pageable);
    }

    @GetMapping(path = "/getSelfBooks")
    public @ResponseBody
    List<Product> getSelfProducts() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Integer sellerID = ((UserDetailsImp) auth.getPrincipal()).getUserID();
        return productRepositoryWithoutPage.findProductBySellerID(sellerID);
        //return productRepository.findAll(pageable);
    }

//    @PostMapping(path = "/uploadImage", consumes = {"multipart/form-data" })
    @RequestMapping(path= "/uploadImages", method = RequestMethod.POST, consumes = {"multipart/form-data"})
    @ResponseBody
    public String uploadFile(@RequestParam("file")  List<MultipartFile> file, @RequestParam Integer productID, HttpServletResponse response)
    {

//        List<MultipartFile> files = uploadFiles.getFiles();

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Integer sellerID = ((UserDetailsImp) auth.getPrincipal()).getUserID();

        User user = userRepository.findUserByUserID(sellerID).get();
        boolean flag = false;
        for (Sells sells :user.getSells())
        {
            if(sells.getProductID() == productID)
            {
                flag = true;
            }
        }
        if(!flag){
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return "Wrong product ID";
        }


        String name = storageService.storeAll(file,productID);
        String uri = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/images/")
                .path(productRepositoryWithoutPage.findById(productID).get().getPath())
                .toUriString();

        return name;
    }


    @RequestMapping(path= "/uploadMainImage", method = RequestMethod.POST, consumes = {"multipart/form-data"})
    @ResponseBody
    public String uploadFile(@RequestParam("file") MultipartFile file, @RequestParam Integer productID, HttpServletResponse response)
    {



        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Integer sellerID = ((UserDetailsImp) auth.getPrincipal()).getUserID();

        User user = userRepository.findUserByUserID(sellerID).get();
        boolean flag = false;
        for (Sells sells :user.getSells())
        {
            if(sells.getProductID() == productID)
            {
                flag = true;
            }
        }
        if(!flag){
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return "Wrong product ID";
        }


        String name = storageService.storeMain(file,productID);
        String uri = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/images/")
                .path(productRepositoryWithoutPage.findById(productID).get().getPath())
                .toUriString();

        return name + "\n" + uri;
    }

    @GetMapping("/getImagePaths")
    public @ResponseBody List<String> GetImagePaths(@RequestParam Integer productID) {


        List<Resource> resources = storageService.loadAllResources(productID.toString());
        List<String> resourcesS = new ArrayList<>();
        for (Resource res :
                resources) {
            try {
                resourcesS.add(res.getURL().toString().substring(5)); //cut "file:" part from url
            }
            catch (IOException e){
                continue;
            }
        }
        return resourcesS;
    }
    @GetMapping("/images")
    public @ResponseBody Resource getImage(@RequestParam String path){
        return storageService.loadAsResource(path);
    }

}
