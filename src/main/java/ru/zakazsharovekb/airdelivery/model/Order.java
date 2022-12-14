package ru.zakazsharovekb.airdelivery.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;
import ru.zakazsharovekb.airdelivery.common.enums.OrderStatus;
import ru.zakazsharovekb.airdelivery.common.enums.PayStatus;
import ru.zakazsharovekb.airdelivery.common.enums.ReceivingType;
import ru.zakazsharovekb.airdelivery.common.enums.TransferType;

import javax.persistence.*;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Embedded
    private Customer customer;
    @JsonFormat(pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime dateCreated;
    @Enumerated(EnumType.STRING)
    private TransferType transferType;
    @Embedded
    private Delivery delivery;
    @Enumerated(EnumType.STRING)
    private OrderStatus status;
    private String orderComment;
    @Enumerated(EnumType.STRING)
    private PayStatus payStatus;

    public Order() {
        this.customer = new Customer();
        this.delivery = new Delivery();
    }

    @Enumerated(EnumType.STRING)
    private ReceivingType receivingType;
    private double sum;
}
