package com.example.accessingdatamysql.controllers;

import com.example.accessingdatamysql.dao.ShippingRepository;
import com.example.accessingdatamysql.models.ShippingCompany;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/shipping")
@Api(value = "shipping", description = "Controller about shipment")
public class ShippingController {

    @Autowired
    ShippingRepository shippingRepository;

    @ApiOperation("Add Shipping Company")
    @PostMapping("/addCompany")
    public @ResponseBody String addShippingCompany(@RequestParam String companyName, @RequestParam(defaultValue = "No website") String website, @RequestParam float price)
    {
        Optional<ShippingCompany> comp = shippingRepository.findShippingCompanyByCompanyName(companyName);
        ShippingCompany shippingCompany;
        if(!comp.isPresent())
            shippingCompany = new ShippingCompany(companyName,price,website);
        else{
            shippingCompany = comp.get();
            shippingCompany.setCompanyName(companyName);
            shippingCompany.setWebsite(website);
            shippingCompany.setPrice(price);
        }
        shippingRepository.save(shippingCompany);
        return "saved";
    }

    @ApiOperation("Remove Shipping Company")
    @DeleteMapping("/removeCompany")
    public @ResponseBody String removeShippingCompany(@RequestParam String companyName)
    {
        ShippingCompany comp = shippingRepository.findShippingCompanyByCompanyName(companyName).get();
        shippingRepository.delete(comp);
        return "deleted";
    }

    @ApiOperation("Get All Shipping Options")
    @GetMapping("/getCompanies")
    public @ResponseBody Iterable<ShippingCompany> getCompanies()
    {
        return shippingRepository.findAll();
    }
}
