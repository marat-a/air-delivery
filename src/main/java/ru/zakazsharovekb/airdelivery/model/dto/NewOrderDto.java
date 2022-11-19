package ru.zakazsharovekb.airdelivery.model.dto;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.validation.annotation.Validated;
import ru.zakazsharovekb.airdelivery.common.enums.PayStatus;
import ru.zakazsharovekb.airdelivery.common.enums.ReceivingType;
import ru.zakazsharovekb.airdelivery.common.enums.TransferType;
import ru.zakazsharovekb.airdelivery.model.Delivery;
import ru.zakazsharovekb.airdelivery.model.OrderProduct;

import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.List;

@Getter
@Validated
public class NewOrderDto {

    @NotNull
    private List<OrderProduct> orderProducts = new ArrayList<>();
    @NotNull
    private TransferType transferType;
    @NotNull
    private Delivery delivery;

    private String comment;

    @Value("NOTPAID")
    private PayStatus payStatus;

    private ReceivingType receivingType;
}
