DROP TABLE IF EXISTS order_product, orders, products CASCADE;

CREATE TABLE IF NOT EXISTS  products (
                                         id int8 generated by default as identity,
                                         name varchar(255) not null,
                                         price float8,
                                         CONSTRAINT PK_PRODUCTS PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS orders (
                                      id int8 generated by default as identity,
                                      email varchar(50),
                                      name varchar(50),
                                      phone varchar(15),
                                      date_created timestamp,
                                      address varchar(255),
                                      comment varchar(1000),
                                      cost float8 not null,
                                      end_time timestamp,
                                      start_time timestamp,
                                      order_comment varchar(1000),
                                      pay_status varchar(20),
                                      receiving_type varchar(20),
                                      status varchar(20),
                                      sum float8,
                                      transfer_type varchar(20),
                                      CONSTRAINT PK_ORDERS PRIMARY KEY (id));

CREATE TABLE IF NOT EXISTS order_product (
    quantity int4 not null,
    product_id int8 not null,
    order_id int8 not null,
    CONSTRAINT PK_ORDER_PRODUCT PRIMARY KEY (order_id, product_id),
    CONSTRAINT FK_ORDER_PRODUCT_PRODUCT_ID_PRODUCTS foreign key (product_id) references products,
    CONSTRAINT FK_ORDER_PRODUCT_ORDER_ID_PRODUCTS foreign key (order_id) references orders);



