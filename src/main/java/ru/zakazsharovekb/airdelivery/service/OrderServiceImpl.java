package ru.zakazsharovekb.airdelivery.service;

import lombok.RequiredArgsConstructor;
import org.mapstruct.factory.Mappers;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.zakazsharovekb.airdelivery.common.Exceptions.NotFoundException;
import ru.zakazsharovekb.airdelivery.common.enums.OrderStatus;
import ru.zakazsharovekb.airdelivery.model.Order;
import ru.zakazsharovekb.airdelivery.model.OrderMapper;
import ru.zakazsharovekb.airdelivery.model.dto.NewOrderDto;
import ru.zakazsharovekb.airdelivery.model.dto.OrderDto;
import ru.zakazsharovekb.airdelivery.model.dto.UpdateOrderDto;
import ru.zakazsharovekb.airdelivery.repository.OrderRepository;
import ru.zakazsharovekb.airdelivery.service.parser.ExcelOrdersParser;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {
    private final OrderMapper mapper = Mappers.getMapper(OrderMapper.class);
    private final OrderRepository orderRepository;

    @Override
    public List<Order> parseOrders() throws IOException {
        ExcelOrdersParser excelOrdersParser = new ExcelOrdersParser();
        orderRepository.deleteAll();
        return orderRepository.saveAll(excelOrdersParser.parseOrdersFromXlsx());
    }

    @Override
    public OrderDto createOrder(NewOrderDto orderDto) {
        Order order = mapper.newOrderDtoToOrder(orderDto);

        order.setStatus(OrderStatus.NEW);
        order.setDateCreated(LocalDateTime.now().truncatedTo(ChronoUnit.SECONDS));
        order = orderRepository.save(order);
        return mapper.orderToDto(order);
    }

    @Override
    @Transactional
    public OrderDto updateOrder(UpdateOrderDto update) {

        Order editedOrder = orderRepository.findById(update.getId())
                .orElseThrow(() -> new NotFoundException("Order not found"));
        if (update.getDelivery().getDeliveryTime().getStartTime() != null) {
            editedOrder
                    .getDelivery()
                    .getDeliveryTime()
                    .setStartTime(update
                            .getDelivery()
                            .getDeliveryTime()
                            .getStartTime());
        }
        if (update.getDelivery().getDeliveryTime().getEndTime() != null) {
            editedOrder
                    .getDelivery()
                    .getDeliveryTime()
                    .setEndTime(update
                            .getDelivery()
                            .getDeliveryTime()
                            .getEndTime());

        }
        return mapper.orderToDto(orderRepository.save(editedOrder));
    }


    @Override
    public void deleteOrder(Long id) {
        orderRepository.deleteById(id);
    }



    @Override
    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    @Override
    public OrderDto getOrderById(Long id) {
        Order order =  orderRepository
                .findById(id)
                .orElseThrow(() -> new NotFoundException("Order not found: id = " + id));
       return mapper.orderToDto(order);
    }
}
