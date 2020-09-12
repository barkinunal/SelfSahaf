package com.example.accessingdatamysql.controllers;

import com.example.accessingdatamysql.auth.UserDetailsImp;
import com.example.accessingdatamysql.dao.*;
import com.example.accessingdatamysql.models.*;
import com.example.accessingdatamysql.models.enums.OrderStatus;
import com.example.accessingdatamysql.models.enums.ProductStatus;
import com.example.accessingdatamysql.models.enums.RefundStatus;
import com.example.accessingdatamysql.storage.StorageService;
import com.example.accessingdatamysql.thirdparty.PaypalPayment;
import io.swagger.annotations.ApiOperation;
import io.swagger.models.auth.In;
import org.springframework.core.io.Resource;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import sun.reflect.generics.reflectiveObjects.NotImplementedException;
import io.swagger.annotations.Api;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Ref;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.*;


@Controller
@RequestMapping("/order")

@Api(value = "order", description = "Controller about order")
public class OrderController {
    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private AddressRepository addressRepository;

    @Autowired
    private OrderDetailRepository orderDetailRepository;

    @Autowired
    private CardRepository cardRepository;

    @Autowired
    private SellerRepository sellerRepository;

    @Autowired
    private ShippingRepository shippingRepository;

    @Autowired
    private ShippingInfoRepository shippingInfoRepository;


    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StorageService storageService;

    @Autowired
    private RefundRepository refundRepository;

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private EmailController emailController;


    private PaypalPayment paypal = PaypalPayment.getInstance();

    @ApiOperation("Confirm Order")
    @PostMapping(path="/confirmOrder")
    @Transactional(rollbackFor={RuntimeException.class,Exception.class})
    public @ResponseBody String confirmOrder(@RequestParam Integer addressID, @RequestParam Integer shippingCompanyID,
                                            @RequestBody CardInfo card, HttpServletResponse response) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Integer userID = ((UserDetailsImp) auth.getPrincipal()).getUserID();

        User user = userRepository.findUserByUserID(userID).get();
        Address address = addressRepository.findAddressByAddressID(addressID).get();
        ShippingCompany shippingCompany = shippingRepository.findShippingCompanyByShippingCompanyID(shippingCompanyID).get();


        Set<CartItem> cart = user.getCart();
        LocalDateTime datetime = LocalDateTime.ofInstant(Instant.now(), ZoneOffset.ofHoursMinutes(3,0));
        String formattedDatetime = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm:ss").format(datetime);




        if(isCartValid(cart)){


                /*validate card if validated return true*/

            if(paypal.validateCard(card)) {


                card = cardRepository.save(card);


                Order order = new Order();
                order.setBuyer(user);
                order.setCardNumber(card);
                order.setDatetime(formattedDatetime);
                order.setReceiverAddressID(address);
                order.setItemCount(cart.size());

                orderRepository.save(order);

                for (CartItem item : cart) {

                    ShippingInfo shippingInfo = new ShippingInfo();
                    shippingInfo.setShippingCompanyID(shippingCompany);
                    shippingInfo.setTrackingNumber("0000");

                    shippingInfo = shippingInfoRepository.save(shippingInfo);


                    Sells sells = item.getSells();
                    Product product = sells.getProduct();
                    int newQuantity = sells.getQuantity() - item.getAmount();

                    if (product.getStatus() != ProductStatus.ACTIVE) {
                        throw new RuntimeException("Product is not active,  transaction rollback");
                    } else if (newQuantity < 0) {
                        throw new RuntimeException("Not enough stock, transaction rollback");
                    }
                    product.setSoldCount(product.getSoldCount()+item.getAmount());

                    /* Product Soldout */
                    if (newQuantity == 0) {
                        product.setStatus(ProductStatus.DEACTIVE);
                    }

                    /* Update the product quantity */
                    sells.setQuantity(newQuantity);

                    OrderDetail orderDetail = new OrderDetail();
                    orderDetail.setQuantity(item.getAmount());
                    orderDetail.setOrder(order);
                    orderDetail.setProduct(product);
                    orderDetail.setUser(sells.getUser());
                    orderDetail.setShippingInfo(shippingInfo);
                    orderDetail.setStatus(OrderStatus.ACTIVE);



                    /*Change refund to enum
                     * throw new RuntimeException("throwing exception to test transaction rollback");*/
                    /*orderDetail.setRefund(0);*/

                    orderDetailRepository.save(orderDetail);
                    productRepository.save(product);
                    sellerRepository.save(sells);
                    cartRepository.deleteByUserIDAndSellID(userID, item.getCartItemID().getSellID());



                }



                /* Send email to User about the order*/
                String email = user.getEmail();
                String context = "Your Order has ben taken. \n\n Regards, \nSelfsahaf Support";
                String title = "Selfsahaf Order";


                String emailReturn =  emailController.sendEmailToUser(email, title, context);


                if(emailReturn.equals("Email could not be send.")){
                    throw new RuntimeException("Email could not be send, transaction rollback");
                }


                return "confirmed";
            }
            else{
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return "Card could not be confirmed";
            }






        }
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        return "Cart is not valid.";

    }




    public boolean isCartValid(Set<CartItem> cart){

        for(CartItem item : cart){

            Sells sells = item.getSells();
            Integer amount = item.getAmount();

            if(sells.getProduct().getStatus() != ProductStatus.ACTIVE){
                return false;
            }
            else if (sells.getQuantity() < amount)
            {
                return false;
            }

        }
        return true;
    }

    @ApiOperation("Mark Order as shipping, Confirmed or delivered. for seller")
    @PostMapping(path = "/markOrder")
    public  @ResponseBody String MarkShipping(@RequestParam Integer orderDetailID, @RequestParam OrderStatus status,HttpServletResponse response)
    {
        if(!(status == OrderStatus.CONFIRMED || status == OrderStatus.SHIPPING || status == OrderStatus.DELIVERED))
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return "You can only mark confirmed, delivered or shipping";
        }
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Integer userID = ((UserDetailsImp) auth.getPrincipal()).getUserID();

        OrderDetail orderDetail = orderDetailRepository.findOrderDetailsByOrderDetailID(orderDetailID);

        orderDetail.setStatus(status);
        orderDetailRepository.save(orderDetail);
        return "status marked as" + status.name();
    }

    @ApiOperation("Get Order Details. Lists details for every product")
    @GetMapping(path = "/getOrderDetails")
    public @ResponseBody List<OrderDetail> getOrderDetails(@RequestParam Integer orderID)
    {
        return orderDetailRepository.findOrderDetailsByOrderID(orderID);
    }


    @ApiOperation("Get list of given orders by user")
    @GetMapping(path="/givenOrders")
    public @ResponseBody List<Order> givenOrders()
    {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Integer userID = ((UserDetailsImp) auth.getPrincipal()).getUserID();
        return orderRepository.findOrderByUserID(userID);
    }

    @ApiOperation("Get list of taken orders by seller")
    @GetMapping(path="/takenOrders")
    public @ResponseBody List<OrderDetail> getTakenOrders()
    {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Integer userID = ((UserDetailsImp) auth.getPrincipal()).getUserID();
        return  orderDetailRepository.findOrderDetailBySellerID(userID);
    }

    @ApiOperation("Cancel Order")
    @PostMapping(path="/cancel")
    public @ResponseBody String cancelOrder(@RequestParam Integer orderDetailID, HttpServletResponse response)
    {
        OrderDetail orderDetail = orderDetailRepository.findOrderDetailsByOrderDetailID(orderDetailID);
        if(orderDetail.getStatus() == OrderStatus.ACTIVE)
            orderDetail.setStatus(OrderStatus.CANCELLED);
        else{
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return "You can't cancel an order after beginning it's shipment process. Look for refunding.";
        }
        orderDetailRepository.save(orderDetail);
        return "Your order has canceled";
    }

    @ApiOperation("Change Address Not implemented")
    @PostMapping(path="/updateAddress")
    public @ResponseBody String updateAddress(@RequestParam Integer orderID, Address address)
    {
        throw new NotImplementedException();
    }

    @Transactional(rollbackFor={RuntimeException.class,Exception.class})
    @ApiOperation("Refund Request, orderId productId and sellerId needed for finding specific product order. file is optional")
    @PostMapping(path="/refundRequest")
    public @ResponseBody String refundRequest(@RequestParam Integer orderDetailID,@RequestBody(required = false) List<MultipartFile> file,@RequestParam String message)
    {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Integer userID = ((UserDetailsImp) auth.getPrincipal()).getUserID();

        User user = userRepository.findUserByUserID(userID).get();

        LocalDateTime datetime = LocalDateTime.ofInstant(Instant.now(), ZoneOffset.ofHoursMinutes(3,0));
        String formattedDatetime = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm:ss").format(datetime);

        OrderDetail orderDetail = orderDetailRepository.findOrderDetailsByOrderDetailID(orderDetailID);
        orderDetail.setStatus(OrderStatus.REFUNDREQUEST);
        RefundRequest refundRequest = new RefundRequest(orderDetail,formattedDatetime,message);
        refundRequest.setUser(user);
        refundRequest.setStatus(RefundStatus.PENDING);

        refundRequest = refundRepository.save(refundRequest);
        if(file != null)
        {
            storageService.storeAllRefund(file,refundRequest.getRefundID());

            refundRepository.save(refundRequest);
        }
        orderDetailRepository.save(orderDetail);
        return "refund request created with id " + refundRequest.getRefundID().toString();
    }

    @ApiOperation("RefundImagePath")
    @GetMapping("/refundImagePath")
    public @ResponseBody List<String> refundPaths(@RequestParam Integer refundID){
        List<Resource> resources = storageService.loadAllResourcesRefund(refundID.toString());
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
        return  resourcesS;
    }


    @ApiOperation("List Refund Requests, for seller")
    @GetMapping(path = "/sellerRefundRequests")
    public @ResponseBody List<RefundRequest> getSellerRefundRequests()
    {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Integer userID = ((UserDetailsImp) auth.getPrincipal()).getUserID();

        List<RefundRequest> ref = refundRepository.findRefundRequestsBySellerID(userID);
        Collections.sort(ref, Comparator.comparing(RefundRequest::getDatetime));
        Collections.reverse(ref);
        return ref;
    }

    @ApiOperation("List all refund requests, for admin")
    @GetMapping(path = "/refundRequests")
    public @ResponseBody List<RefundRequest> getAllRefundRequests()
    {
        List<RefundRequest> ref = refundRepository.findAll();
        Collections.sort(ref, Comparator.comparing(RefundRequest::getDatetime));
        Collections.reverse(ref);
        return ref;
    }

    @ApiOperation("Refund Confirm or Reject")
    @PostMapping(path="/refundEvaluate")
    public @ResponseBody String evaluateRefundRequest(@RequestParam Integer refundId, @RequestParam boolean confirm)
    {
        RefundRequest refundRequest = refundRepository.findById(refundId).get();
        if(confirm) {
            refundRequest.setStatus(RefundStatus.CONFIRMED);
            refundRequest.getOrderDetail().setStatus(OrderStatus.REFUNDED);
        }
        else{
            refundRequest.setStatus(RefundStatus.DECLINED);
        }
        refundRepository.save(refundRequest);

        return "status changed";

    }
}
