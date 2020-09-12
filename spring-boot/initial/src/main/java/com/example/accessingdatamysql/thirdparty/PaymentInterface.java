package com.example.accessingdatamysql.thirdparty;

import com.example.accessingdatamysql.models.CardInfo;
import com.example.accessingdatamysql.models.OrderDetail;

public interface PaymentInterface {


    boolean validateCard(CardInfo card);
    boolean refundPayment(CardInfo card, OrderDetail orderDetail);

}
