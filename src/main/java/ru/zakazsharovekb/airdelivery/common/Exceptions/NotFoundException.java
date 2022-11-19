package ru.zakazsharovekb.airdelivery.common.Exceptions;

public class NotFoundException extends RuntimeException {
    public NotFoundException (String mes) {
        super(mes);
    }
}
