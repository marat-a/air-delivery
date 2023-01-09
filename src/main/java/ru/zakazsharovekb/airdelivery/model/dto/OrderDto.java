package ru.zakazsharovekb.airdelivery.model.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import ru.zakazsharovekb.airdelivery.common.enums.OrderStatus;
import ru.zakazsharovekb.airdelivery.common.enums.PayStatus;
import ru.zakazsharovekb.airdelivery.common.enums.ReceivingType;
import ru.zakazsharovekb.airdelivery.common.enums.TransferType;
import ru.zakazsharovekb.airdelivery.model.Customer;
import ru.zakazsharovekb.airdelivery.model.Delivery;

import javax.persistence.Embedded;
import java.time.LocalDateTime;

@Getter
@Setter
public class OrderDto {
    private Long id;

    @Embedded
    private Customer customer;

    @JsonFormat(pattern = "dd/MM/yyyy HH:mm:ss")
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
