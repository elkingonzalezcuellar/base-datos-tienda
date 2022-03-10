DROP DATABASE Store;
-- 1) CREAR LAS TABLAS REQUERIDAS ---------------------------------------------
CREATE SCHEMA IF NOT EXISTS Store DEFAULT CHARACTER SET utf8 ;
USE Store;

-- -----------------------------------------------------
-- Table  Store . supplier
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS supplier(
  id_supplier INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(40) NOT NULL,
  cellphone_number VARCHAR(15) NOT NULL,
  address VARCHAR(60) NOT NULL,
  PRIMARY KEY (id_supplier),
  UNIQUE INDEX id_supplier_UNIQUE (id_supplier ASC) VISIBLE,
  UNIQUE INDEX cellphone_number_UNIQUE (cellphone_number) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table  Store . product
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS product (
  id_product INT NOT NULL AUTO_INCREMENT,
  supplier_id_supplier INT NOT NULL,
  name VARCHAR(40) NOT NULL,
  price DECIMAL(8,2) UNSIGNED NOT NULL,
  PRIMARY KEY (id_product),
  UNIQUE INDEX id_sale_UNIQUE (id_product ASC) VISIBLE,
  UNIQUE INDEX fk_product_supplier_idx (supplier_id_supplier ASC) VISIBLE,
  CONSTRAINT fk_product_supplier
    FOREIGN KEY (supplier_id_supplier)
    REFERENCES supplier (id_supplier)
    ON DELETE NO ACTION
    ON UPDATE CASCADE )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table  Store . customer
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS customer (
  id_customer INT NOT NULL AUTO_INCREMENT,
  id_type VARCHAR(12) NOT NULL,
  num_id VARCHAR(13) NOT NULL,
  PRIMARY KEY (id_customer),
  UNIQUE INDEX num_id_UNIQUE (num_id ASC, id_type ASC) VISIBLE,
  UNIQUE INDEX id_customer_UNIQUE (id_customer ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table  Store . sales
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS sales (
  id_sale INT NOT NULL AUTO_INCREMENT,
  customer_id_customer INT NOT NULL,
  amount INT NOT NULL,
  estate BINARY NOT NULL,
  PRIMARY KEY (id_sale),
  INDEX fk_sales_customer1_idx (customer_id_customer ASC) VISIBLE,
  UNIQUE INDEX id_sale_UNIQUE (id_sale ASC) VISIBLE,
  UNIQUE INDEX customer_id_customer_UNIQUE (customer_id_customer ASC) VISIBLE,
  CONSTRAINT fk_sales_customer1
    FOREIGN KEY ( customer_id_customer )
    REFERENCES customer  ( id_customer )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table  Store . sales_has_product
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS  sales_has_product  (
   sales_id_sale  INT NOT NULL,
   product_id_product  INT NOT NULL,
  PRIMARY KEY ( sales_id_sale ,  product_id_product ),
  INDEX  fk_sales_has_product_product1_idx  ( product_id_product  ASC) VISIBLE,
  INDEX  fk_sales_has_product_sales1_idx  ( sales_id_sale  ASC) VISIBLE,
  CONSTRAINT  fk_sales_has_product_sales1
    FOREIGN KEY ( sales_id_sale )
    REFERENCES  sales  ( id_sale )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION ,
    CONSTRAINT  fk_sales_has_product_product1
    FOREIGN KEY ( product_id_product )
    REFERENCES  product  ( id_product )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION )
ENGINE = InnoDB;

 -- 2) LLENAR LAS TABLAS ---------------------------------------------
-- Tabla proveedores

INSERT INTO supplier(id_supplier,name, cellphone_number, address)
VALUES (1010,'Samsung','1-285-336-3207','258-3678 Mauris Avenue'),
  (null,'LG','1-476-457-3114','3024 Dolor Ave'),
  (null,'Xiaomi','1-762-908-8636','734-1297 Purus Avenue'),
  (null,'Motorola','1-684-372-7767','P.O. Box 504, 8015 Cum Rd.'),
  (null,'Philips','1-891-801-6416','379-2267 Ultrices. Avenue');
-- Tabla Cliente
INSERT INTO customer (id_customer ,id_type, num_id)
VALUES  (3001,'CC',38913711039),
        (null,'TI',49298680200),
        (null,'CC',104918651895),
        (null,'CC',22969457086),
        (null,'TI',262126737);

-- Tabla Producto
INSERT INTO product ( id_product,name, price,supplier_id_supplier)
VALUES (2001,'Lavadora',2980,1010),
       (null,'Televisor',9200,1011),
       (null,'Nevera',5600,1012),
       (null,'Celular',1600,1013),
       (null,'Microondas',1350,1014);


INSERT INTO sales (id_sale,customer_id_customer, amount,estate)
VALUES
  (9001,3001,10,1),
  (null,3002,25,1),
  (null,3003,45,1),
  (null,3004,28,1),
  (null,3005,24,1);

INSERT INTO sales_has_product(sales_id_sale, product_id_product)
VALUES
        (9001, 2001),
        (9002,2003),
        (9003,2003),
        (9004,2002),
        (9005,2001);

SELECT id_sale,estate,amount,customer_id_customer FROM sales; -- Mostrar la tabla ventas con la información

-- 1)Consulta SQL donde pueda obtener los productos vendidos digitando tipo de documento y número de documento.
SELECT name ,c.id_type, c.num_id  from product
INNER JOIN  sales_has_product shp
    ON product.id_product = shp.product_id_product
INNER JOIN sales s
    ON shp.sales_id_sale = s.id_sale
INNER JOIN customer c
    ON s.customer_id_customer = c.id_customer
WHERE num_id = 104918651895
and id_type = 'CC';

-- 2) Consultar productos por medio del nombre, el cual debe mostrar quien o quienes han sido sus proveedores.
SELECT  s.name, product.name FROM product
INNER JOIN supplier s
    ON product.supplier_id_supplier = s.id_supplier
WHERE product.name = 'Lavadora';