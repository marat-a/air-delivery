package ru.zakazsharovekb.airdelivery.model.dto;

import lombok.Getter;
import lombok.Setter;
import ru.zakazsharovekb.airdelivery.common.enums.OrderStatus;
import ru.zakazsharovekb.airdelivery.common.enums.PayStatus;
import ru.zakazsharovekb.airdelivery.common.enums.ReceivingType;
import ru.zakazsharovekb.airdelivery.common.enums.TransferType;
import ru.zakazsharovekb.airdelivery.model.Customer;
import ru.zakazsharovekb.airdelivery.model.Delivery;

import javax.persistence.Embedded;
import javax.validation.constraints.NotBlank;
import java.time.LocalDateTime;

@Getter
@Setter
public class UpdateOrderDto {

    @NotBlank
    private Long id;

    @Embedded
    private Customer customer;

    private LocalDateTime dateCreated;

    private TransferType transferType;

    @Embedded
    private Delivery delivery;

    private OrderStatus status;

    private String orderComment;

    private PayStatus payStatus;

    private ReceivingType receivingType;

    private double sum;
}
