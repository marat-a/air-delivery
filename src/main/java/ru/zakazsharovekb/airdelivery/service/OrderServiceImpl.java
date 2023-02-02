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
import java.lang.reflect.Field;
import java.time.LocalDate;
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
        orderRepository.flush();
        orderRepository.saveAll(excelOrdersParser.parseOrdersFromXlsx());
        return orderRepository.findAllByDelivery_DeliveryTime_StartTimeAfterOrderByDelivery_DeliveryTime_StartTime(LocalDate.now().atStartOfDay().minusSeconds(1));
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
    public OrderDto updateOrder(UpdateOrderDto update) {

        Order editedOrder = orderRepository.findById(update.getId())
                .orElseThrow(() -> new NotFoundException("Order not found"));
        System.out.println(" запрос в репо");
        if (update.getCustomer().getName() != null) {
            editedOrder
                    .getCustomer().setName(update
                            .getCustomer().getName());
        } else editedOrder.getCustomer().setName(null);

        if (update.getCustomer().getPhone() != null) {
            editedOrder
                    .getCustomer().setPhone(update
                            .getCustomer().getPhone());
        } else editedOrder.getCustomer().setPhone(null);

        if (update.getCustomer().getEmail() != null) {
            editedOrder
                    .getCustomer().setEmail(update
                            .getCustomer().getEmail());
        } else editedOrder.getCustomer().setEmail(null);



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

        if (update.getDelivery().getComment() != null) {
            editedOrder
                    .getDelivery()
                    .setComment(update
                            .getDelivery().getComment());
        }

        if (update.getDelivery().getAddress() != null) {
            editedOrder
                    .getDelivery()
                    .setAddress(update
                            .getDelivery().getAddress());
        }

        if (update.getDelivery().getCost() != editedOrder.getDelivery().getCost()) {
            editedOrder
                    .getDelivery()
                    .setCost(update
                            .getDelivery().getCost());
        }


        if (update.getOrderComment() != null) {
            editedOrder
                    .setOrderComment(update
                            .getOrderComment());
        } else editedOrder.setOrderComment(null);

        editedOrder.setTransferType(update.getTransferType() == null ? null : update.getTransferType());

        editedOrder.setSum(update.getSum() == 0 ? 0 : update.getSum());



        return mapper.orderToDto(orderRepository.save(editedOrder));
    }


    @Override
    public void deleteOrder(Long id) {
        orderRepository.deleteById(id);
    }



    @Override
    public List<Order> getOrders(LocalDate startDate) {

        return orderRepository.findAllByDelivery_DeliveryTime_StartTimeAfterOrderByDelivery_DeliveryTime_StartTime(startDate.atStartOfDay().minusSeconds(1));
    }

    @Override
    public OrderDto getOrderById(Long id) {
        Order order =  orderRepository
                .findById(id)
                .orElseThrow(() -> new NotFoundException("Order not found: id = " + id));
       return mapper.orderToDto(order);
    }
}
