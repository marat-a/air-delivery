package ru.zakazsharovekb.airdelivery;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import ru.zakazsharovekb.airdelivery.service.ExcelOrdersParser;
import ru.zakazsharovekb.airdelivery.service.OrderService;

import java.io.IOException;

@SpringBootApplication
public class AirDeliveryApplication {
    public static void main(String[] args) throws IOException {
        SpringApplication.run(AirDeliveryApplication.class, args);

    }
}
