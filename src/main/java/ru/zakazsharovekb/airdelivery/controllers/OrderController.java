package ru.zakazsharovekb.airdelivery.controllers;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import ru.zakazsharovekb.airdelivery.model.Order;
import ru.zakazsharovekb.airdelivery.model.dto.NewOrderDto;
import ru.zakazsharovekb.airdelivery.model.dto.OrderDto;
import ru.zakazsharovekb.airdelivery.model.dto.UpdateOrderDto;
import ru.zakazsharovekb.airdelivery.service.OrderService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@Slf4j
@RestController
@CrossOrigin
@RequestMapping("/order")
@AllArgsConstructor
public class OrderController {

    private OrderService orderService;

    @PostMapping(value = "/parse", produces = "application/json; charset=utf-8")
    public List<Order> parseOrders() throws IOException {
        return orderService.parseOrders();
    }


    @PostMapping
    public OrderDto addOrder(@RequestBody NewOrderDto orderDto) {
        System.out.println("POST");
        return orderService.createOrder(orderDto);
    }


    @GetMapping(value = "/{id}", produces = "application/json; charset=utf-8")
    public OrderDto getOrderById(@PathVariable Long id) {
        return orderService.getOrderById(id);
    }

    //    public List<Order> getOrdersWithFilter(@RequestParam(required = false) String text,
//                                                 @RequestParam(required = false) Integer[] categories,
//                                                 @RequestParam(required = false) Boolean paid,
//                                                 @RequestParam(required = false) Boolean onlyAvailable,
//                                                 @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
//                                                 @RequestParam(required = false) String rangeStart,
//                                                 @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
//                                                 @RequestParam(required = false) String rangeEnd,
//                                                 @RequestParam(required = false)
//                                                 @SortTypeSubset(anyOf = {
//                                                         SortType.VIEWS,
//                                                         SortType.EVENT_DATE,
//                                                         SortType.DISTANCE}) SortType sort,
//                                                 @RequestParam(required = false, defaultValue = "0") int from,
//                                                 @RequestParam(required = false, defaultValue = "10") int size,
//                                                 @RequestParam(required = false) Double lon,
//                                                 @RequestParam(required = false) Double lat,
//                                                 @RequestParam(required = false, defaultValue = "0") Double distance,
//                                                 HttpServletRequest request)

    @GetMapping(produces = "application/json; charset=utf-8")
    public List<Order> getOrders(
            @DateTimeFormat(pattern = "yyyy-MM-dd")
            @RequestParam(required = false, defaultValue = "#{T(java.time.LocalDate).now()}") LocalDate startDate) {

        return orderService.getOrders(startDate);
    }

    @PutMapping
    public OrderDto updateOrder( @RequestBody UpdateOrderDto updateOrderDto){
        System.out.println("Edit Order");
        return orderService.updateOrder(updateOrderDto);
    }

    @DeleteMapping("/{id}")
    public void deleteBookById(@PathVariable Long id) {
        orderService.deleteOrder(id);
    }

}
