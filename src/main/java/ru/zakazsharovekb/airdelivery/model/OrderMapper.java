package ru.zakazsharovekb.airdelivery.model;

import org.mapstruct.Mapper;
import ru.zakazsharovekb.airdelivery.model.dto.NewOrderDto;
import ru.zakazsharovekb.airdelivery.model.dto.OrderDto;

import java.util.List;

@Mapper
public interface OrderMapper {
    OrderDto orderToDto(Order order);
    Order newOrderDtoToOrder(NewOrderDto newOrderDto);
    List<OrderDto> orderToDtoList (List<Order> orderList);
}