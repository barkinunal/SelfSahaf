package com.example.accessingdatamysql.thirdparty;

import com.example.accessingdatamysql.dao.OrderDetailRepository;
import com.example.accessingdatamysql.models.CardInfo;
import com.example.accessingdatamysql.models.OrderDetail;
import com.example.accessingdatamysql.models.enums.OrderStatus;
import org.hibernate.validator.internal.constraintvalidators.bv.time.pastorpresent.PastOrPresentValidatorForYear;
import org.springframework.beans.factory.annotation.Autowired;

import javax.transaction.Transactional;

public class PaypalPayment implements PaymentInterface {


    private static PaypalPayment instance = new PaypalPayment();




    @Autowired
    private OrderDetailRepository orderDetailRepository;


    public static PaypalPayment getInstance(){
        return instance;
    }

    @Override
    public boolean validateCard(CardInfo card) {

        /*
        Check card credentials
        */

        return true;
    }

    @Override
    @Transactional
    public boolean refundPayment(CardInfo card, OrderDetail orderDetail) {

        orderDetail.setStatus(OrderStatus.CANCELLED);
        orderDetailRepository.save(orderDetail);

        return true;
    }
}
