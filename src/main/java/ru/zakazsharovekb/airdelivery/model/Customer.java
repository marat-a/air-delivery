package ru.zakazsharovekb.airdelivery.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Embeddable;

@Getter
@Setter
@Embeddable
public class Customer {
    private String name;
    private String phone;
    private String email;
}
