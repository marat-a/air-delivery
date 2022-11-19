package ru.zakazsharovekb.airdelivery.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.zakazsharovekb.airdelivery.common.Exceptions.NotFoundException;
import ru.zakazsharovekb.airdelivery.model.Product;
import ru.zakazsharovekb.airdelivery.repository.ProductRepository;


@Service
@Transactional
public class ProductServiceImpl implements ProductService {

    ProductRepository productRepository;

    @Override
    public Iterable<Product> getAllProducts() {
        return productRepository.findAll();
    }

    @Override
    public Product getProduct(long id) {
        return productRepository
                .findById(id)
                .orElseThrow(() -> new NotFoundException("Product not found"));
    }

    @Override
    public Product save(Product product) {
        return productRepository.save(product);
    }
}