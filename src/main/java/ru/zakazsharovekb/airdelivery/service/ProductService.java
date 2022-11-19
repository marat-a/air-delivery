package ru.zakazsharovekb.airdelivery.service;

import ru.zakazsharovekb.airdelivery.model.Product;

public interface ProductService {
    Iterable<Product> getAllProducts();

    Product getProduct(long id);

    Product save(Product product);
}
