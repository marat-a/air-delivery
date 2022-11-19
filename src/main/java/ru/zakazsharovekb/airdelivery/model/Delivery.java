package ru.zakazsharovekb.airdelivery.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Embeddable;
import javax.persistence.Embedded;

@Getter
@Setter
@Embeddable
public class Delivery {
    @Embedded
    private DeliveryTime deliveryTime;
    private String comment;
    private String address;
    private double cost;
}
