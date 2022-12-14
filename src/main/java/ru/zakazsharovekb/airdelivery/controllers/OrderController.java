package ru.zakazsharovekb.airdelivery.controllers;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import ru.zakazsharovekb.airdelivery.model.Order;
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
    public List<Order> parseOrders() throws IOException {
       return orderService.parseOrders();
    }

    @PostMapping
    public OrderDto addOrder( @RequestBody NewOrderDto orderDto){
        return orderService.createOrder(orderDto);
    }

    @CrossOrigin
    @GetMapping(value = "/{id}", produces = "application/json; charset=utf-8")
    public OrderDto getOrderById (@PathVariable Long id){
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
@CrossOrigin
    @GetMapping(produces = "application/json; charset=utf-8")
    public List<Order> getAllOrders (){
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
