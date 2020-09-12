package com.example.accessingdatamysql.controllers;

import com.example.accessingdatamysql.auth.UserDetailsImp;
import com.example.accessingdatamysql.dao.OrderDetailRepository;
import com.example.accessingdatamysql.dao.OrderRepository;
import com.example.accessingdatamysql.dao.RatingsRepository;
import com.example.accessingdatamysql.models.Order;
import com.example.accessingdatamysql.models.OrderDetail;
import com.example.accessingdatamysql.models.Ratings;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/rating")
@Api(value = "Rating", description = "Controller about reyytings")
public class RatingController {
    @Autowired
    private RatingsRepository ratingsRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderDetailRepository orderDetailRepository;


    @ApiOperation("Rates product in given order. Takes order id and product id")
    @PostMapping(path = "/rateSeller")
    public @ResponseBody
    String rateSeller(@RequestBody Ratings ratings, @RequestParam Integer orderDetailID, HttpServletResponse response)
    {
        Optional<Ratings> ratingsOptional = ratingsRepository.findRatingsByOrderDetailID(orderDetailID);
        if(ratingsOptional.isPresent())
            ratings.setRatingID(ratingsOptional.get().getRatingID());

        if(ratings.getRating() < 1 || ratings.getRating() > 5)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return "rating must be between 1 and 5";
        }


        OrderDetail orderDetail = orderDetailRepository.findOrderDetailsByOrderDetailID(orderDetailID);
        Order order = orderRepository.findById(orderDetail.getOrder().getOrderID()).get();

        LocalDateTime datetime = LocalDateTime.ofInstant(Instant.now(), ZoneOffset.ofHoursMinutes(3,0));
        String formatted = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm:ss").format(datetime);
        ratings.setDatetime(formatted);

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Integer userID = ((UserDetailsImp) auth.getPrincipal()).getUserID();

        if(order.getBuyer().getUserID() != userID)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return "You can only rate your order";
        }

        ratings.setOrderDetail(orderDetail);


        Ratings rat = ratingsRepository.save(ratings);

        return "You gave " + ratings.getRating() + " stars";
    }

    @ApiOperation("Get Average Rating of seller")
    @GetMapping(path = "/getAverageRating")
    public @ResponseBody Integer getAverageRating(@RequestParam Integer sellerID)
    {
        List<Integer> ratings = ratingsRepository.findRatingValuesBySellerID(sellerID);
        Integer sum = 0;
        for (Integer i: ratings) {
            sum+=i;
        }
        return Math.round((float)sum /ratings.size());
    }

    @ApiOperation("Get a list of Ratings Of Seller")
    @GetMapping(path = "getRatings")
    public @ResponseBody List<Ratings> getSellerRatings(@RequestParam  Integer sellerID)
    {
        return ratingsRepository.findRatingsBySellerID(sellerID);
    }

}
