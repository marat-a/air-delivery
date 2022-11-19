package ru.zakazsharovekb.airdelivery.service;


import ru.zakazsharovekb.airdelivery.model.dto.NewOrderDto;
import ru.zakazsharovekb.airdelivery.model.dto.OrderDto;

import java.io.IOException;
import java.util.List;

public interface OrderService {

    void parseOrders(String source) throws IOException;

    OrderDto createOrder(NewOrderDto orderDto);

    void deleteOrder(Long id);

//    OrderDto updateOrder(OrderDto orderDto);

    List<OrderDto> getAllOrders();

    OrderDto getOrderById(Long id);
}
