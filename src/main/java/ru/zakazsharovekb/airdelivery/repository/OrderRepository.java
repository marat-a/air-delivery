package ru.zakazsharovekb.airdelivery.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.zakazsharovekb.airdelivery.model.Order;


public interface OrderRepository extends JpaRepository<Order, Long> {
}
