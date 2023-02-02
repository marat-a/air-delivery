package ru.zakazsharovekb.airdelivery.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.zakazsharovekb.airdelivery.model.Order;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {


    List<Order> findAllByDelivery_DeliveryTime_StartTimeAfterOrderByDelivery_DeliveryTime_StartTime(LocalDateTime startDate);
}
