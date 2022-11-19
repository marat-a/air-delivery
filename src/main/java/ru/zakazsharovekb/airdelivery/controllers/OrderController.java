package ru.zakazsharovekb.airdelivery.controllers;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import ru.zakazsharovekb.airdelivery.model.dto.NewOrderDto;
import ru.zakazsharovekb.airdelivery.model.dto.OrderDto;
import ru.zakazsharovekb.airdelivery.service.OrderService;

import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/order")
@AllArgsConstructor
@Validated
public class OrderController {

    private OrderService orderService;

    @PostMapping("/parse")
    public void parseOrders() throws IOException {
       orderService.parseOrders("orders.xlsx");
    }

    @PostMapping
    public OrderDto addOrder( @RequestBody NewOrderDto orderDto){
        return orderService.createOrder(orderDto);
    }

    @GetMapping("/{id}")
    public OrderDto getBookById (@PathVariable Long id){
        return orderService.getOrderById(id);
    }

    @GetMapping
    public List<OrderDto> getAllOrders (){
        return orderService.getAllOrders();
    }

//    @PutMapping
//    public OrderDto updateOrder( @RequestBody OrderDto orderDto){
//        return orderService.updateOrder(orderDto);
//    }

    @DeleteMapping("/{id}")
    public void deleteBookById (@PathVariable Long id){
        orderService.deleteOrder(id);
    }

}
