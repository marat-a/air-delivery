package ru.zakazsharovekb.airdelivery.service;

import lombok.RequiredArgsConstructor;
import org.mapstruct.factory.Mappers;
import org.springframework.stereotype.Service;
import ru.zakazsharovekb.airdelivery.common.Exceptions.NotFoundException;
import ru.zakazsharovekb.airdelivery.common.enums.OrderStatus;
import ru.zakazsharovekb.airdelivery.model.Order;
import ru.zakazsharovekb.airdelivery.model.OrderMapper;
import ru.zakazsharovekb.airdelivery.model.dto.NewOrderDto;
import ru.zakazsharovekb.airdelivery.model.dto.OrderDto;
import ru.zakazsharovekb.airdelivery.repository.OrderRepository;

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
    public void parseOrders(String source) throws IOException {
        ExcelOrdersParser excelOrdersParser = new ExcelOrdersParser();
        orderRepository.saveAll(excelOrdersParser.parseOrdersFromXlsx(source));
    }

    @Override
    public OrderDto createOrder(NewOrderDto orderDto) {
        Order order = mapper.newOrderDtoToOrder(orderDto);

        order.setStatus(OrderStatus.NEW);
        order.setDateCreated(LocalDateTime.now().truncatedTo(ChronoUnit.SECONDS));
        order = orderRepository.save(order);
        return mapper.orderToDto(order);
    }

//    @Override
//    @Transactional
//    public OrderDto updateOrder(OrderDto orderDto) {
//        Order order = mapper.orderDtoToOrder(orderDto);
//        orderRepository.findById(order.getId()) // returns Optional<User>
//                .ifPresent(orderFromDb -> {
//                    orderFromDb.setAddress(order.getAddress());
//                    orderFromDb.setCustomerPhone(order.);
//                    orderFromDb.setDeliveryType(order.getDeliveryType());
//                    orderFromDb.setStatus(order.getStatus());
//                    orderFromDb.setOrderProducts(order.getOrderProducts());
//                    orderFromDb.setComment(order.getComment());
//                    orderFromDb.setPayStatus(order.getPayStatus());
//                    orderFromDb.setReceivingType(order.getReceivingType());
//                    orderRepository.save(orderNew);
//                });
//    }
//

    @Override
    public void deleteOrder(Long id) {
        orderRepository.deleteById(id);
    }

    @Override
    public List<OrderDto> getAllOrders() {
        List<Order> orders = orderRepository.findAll();
        return mapper.orderToDtoList(orders);
    }

    @Override
    public OrderDto getOrderById(Long id) {
        Order order = orderRepository
                .findById(id)
                .orElseThrow(() -> new NotFoundException("Order not found: id = " + id));
        return mapper.orderToDto(order);
    }
}
