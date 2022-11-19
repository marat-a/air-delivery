package ru.zakazsharovekb.airdelivery.model.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import ru.zakazsharovekb.airdelivery.common.enums.OrderStatus;
import ru.zakazsharovekb.airdelivery.common.enums.PayStatus;
import ru.zakazsharovekb.airdelivery.common.enums.ReceivingType;
import ru.zakazsharovekb.airdelivery.common.enums.TransferType;
import ru.zakazsharovekb.airdelivery.model.Delivery;
import ru.zakazsharovekb.airdelivery.model.OrderProduct;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;


@Getter
@Setter
@NoArgsConstructor
public class OrderDto {

    private Long id;

    private List<OrderProduct> orderProducts = new ArrayList<>();

    private LocalDateTime dateCreated;

    private TransferType transferType;

    @Embedded
    private Delivery delivery;

    private String address;

    private OrderStatus status;

    private String comment;

    private PayStatus payStatus;

    private ReceivingType receivingType;
}
