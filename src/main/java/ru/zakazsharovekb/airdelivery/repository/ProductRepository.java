package ru.zakazsharovekb.airdelivery.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.zakazsharovekb.airdelivery.model.Product;

public interface ProductRepository  extends JpaRepository<Product, Long> {
}
