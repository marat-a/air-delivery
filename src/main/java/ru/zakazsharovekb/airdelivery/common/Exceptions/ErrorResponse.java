package ru.zakazsharovekb.airdelivery.common.Exceptions;

import lombok.Data;

@Data
public class ErrorResponse {
    String error;
    public ErrorResponse(String error) {
        this.error = error;
    }
}
