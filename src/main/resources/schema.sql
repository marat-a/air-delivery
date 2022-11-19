CREATE TABLE IF NOT EXISTS orders (
                                      id BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
                                      customerId BIGINT,
                                      date_created TIMESTAMP WITHOUT TIME ZONE,
                                      name VARCHAR(200) NOT NULL,
                                      price NUMERIC(8,2) NOT NULL,
                                      description VARCHAR(4000) NOT NULL,
                                      pictureUrl VARCHAR (500),
                                      CONSTRAINT PK_ORDERS PRIMARY KEY (id)
);
