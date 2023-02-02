package ru.zakazsharovekb.airdelivery.service;


import org.springframework.transaction.annotation.Transactional;
import ru.zakazsharovekb.airdelivery.model.Order;
import ru.zakazsharovekb.airdelivery.model.dto.NewOrderDto;
import ru.zakazsharovekb.airdelivery.model.dto.OrderDto;
import ru.zakazsharovekb.airdelivery.model.dto.UpdateOrderDto;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

public interface OrderService {

    List<Order> parseOrders() throws IOException;

    OrderDto createOrder(NewOrderDto orderDto);

    @Transactional
    OrderDto updateOrder(UpdateOrderDto updateOrderDto);

    void deleteOrder(Long id);


    List<Order> getOrders(LocalDate startDate);

    OrderDto getOrderById(Long id);
}
