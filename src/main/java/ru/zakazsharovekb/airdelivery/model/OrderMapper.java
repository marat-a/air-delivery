package ru.zakazsharovekb.airdelivery.model;

import org.mapstruct.Mapper;
import ru.zakazsharovekb.airdelivery.model.dto.NewOrderDto;
import ru.zakazsharovekb.airdelivery.model.dto.OrderDto;
import ru.zakazsharovekb.airdelivery.model.dto.UpdateOrderDto;

import java.util.List;

@Mapper
public interface OrderMapper {
    OrderDto orderToDto(Order order);
    Order newOrderDtoToOrder(NewOrderDto newOrderDto);
    List<OrderDto> orderToDtoList (List<Order> orderList);
    Order orderDtoToOrder(OrderDto orderDto);

    Order updateOrderDtoToOrder(UpdateOrderDto updateOrderDto);
}