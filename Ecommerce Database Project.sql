-- ===========================================
-- E-COMMERCE DATABASE PROJECT
-- This SQL script creates an e-commerce database 
-- and its related tables to manage products, 
-- customers, orders, and categories.
-- ===========================================

-- Create a new database for the e-commerce project
CREATE DATABASE IF NOT EXISTS ecommerce;

-- Switch to the newly created database
USE ecommerce;

-- Create a table for storing product information
CREATE TABLE IF NOT EXISTS Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each product
    ProductName VARCHAR(100) NOT NULL,         -- Name of the product
    Description TEXT,                          -- Description of the product
    Price DECIMAL(10, 2) NOT NULL,             -- Price of the product (max 10 digits, 2 decimal places)
    Stock INT DEFAULT 0,                        -- Number of items available in stock
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp for when the product was added
);

-- Create a table for storing customer information
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each customer
    FirstName VARCHAR(50) NOT NULL,            -- Customer's first name
    LastName VARCHAR(50) NOT NULL,              -- Customer's last name
    Email VARCHAR(100) UNIQUE NOT NULL,         -- Customer's email (must be unique)
    Phone VARCHAR(15),                          -- Customer's phone number
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Timestamp for when the customer was created
);

-- Create a table for storing orders placed by customers
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,     -- Unique identifier for each order
    CustomerID INT NOT NULL,                    -- Reference to the customer placing the order
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date and time when the order was placed
    TotalAmount DECIMAL(10, 2) NOT NULL,       -- Total amount for the order
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)  -- Foreign key constraint linking to Customers
);

-- Create a table for storing order items (details of each item in an order)
CREATE TABLE IF NOT EXISTS OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each order item
    OrderID INT NOT NULL,                       -- Reference to the related order
    ProductID INT NOT NULL,                     -- Reference to the purchased product
    Quantity INT NOT NULL,                      -- Number of items purchased
    Price DECIMAL(10, 2) NOT NULL,              -- Price of the product at the time of purchase
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),  -- Foreign key constraint linking to Orders
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)  -- Foreign key constraint linking to Products
);

-- Create a table for storing product categories
CREATE TABLE IF NOT EXISTS Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each category
    CategoryName VARCHAR(50) NOT NULL           -- Name of the product category
);

-- Create a table for linking products to categories (many-to-many relationship)
CREATE TABLE IF NOT EXISTS ProductCategories (
    ProductID INT NOT NULL,                     -- Reference to the product
    CategoryID INT NOT NULL,                    -- Reference to the category
    PRIMARY KEY (ProductID, CategoryID),       -- Composite primary key for the relationship
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),  -- Foreign key constraint linking to Products
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)  -- Foreign key constraint linking to Categories
);

-- Insert sample products
INSERT INTO Products (ProductName, Description, Price, Stock)
VALUES
('Laptop', 'High-performance laptop', 999.99, 10),
('Smartphone', 'Latest model smartphone', 699.99, 20),
('Headphones', 'Noise-cancelling headphones', 199.99, 15);

-- Insert sample customers
INSERT INTO Customers (FirstName, LastName, Email, Phone)
VALUES
('John', 'Doe', 'john.doe@example.com', '123-456-7890'),
('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210');


-- Insert sample orders
 INSERT INTO Orders (CustomerID, TotalAmount)
 VALUES
 (1, 1199.98),  
 (2, 699.99);   

-- Insert sample order items
 INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price)
 VALUES
 (1, 1, 1, 999.99),  
 (1, 3, 1, 199.99),  
 (2, 2, 1, 699.99);  

-- Insert sample categories
 INSERT INTO Categories (CategoryName)
 VALUES
 ('Electronics'),
 ('Accessories');

-- Link products to categories
 INSERT INTO ProductCategories (ProductID, CategoryID)
 VALUES
 (1, 1),  
 (2, 1),  
 (3, 2);  
 
 -- Retrieve all products along with their details
SELECT * FROM Products;

-- Retrieve all products with a price greater than $100
SELECT * FROM Products;

-- Retrieve all customers and their details
SELECT * FROM Customers;

-- Retrieve all orders placed by the customer with CustomerID = 1
SELECT * FROM Orders
WHERE CustomerID = 1;

-- Retrieve all items in the order with OrderID = 1
SELECT oi.OrderItemID, p.ProductName, oi.Quantity, oi.Price
FROM OrderItems oi
JOIN Products p ON oi.ProductID = p.ProductID
WHERE oi.OrderID = 1;

-- Calculate total sales for each product based on order items
SELECT p.ProductName, SUM(oi.Quantity * oi.Price) AS TotalSales
FROM OrderItems oi
JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY p.ProductName;

-- Count the total number of orders placed
SELECT COUNT(*) AS TotalOrders
FROM Orders;

-- Retrieve all categories
SELECT * FROM Categories;

-- Retrieve all products in the 'Electronics' category
SELECT p.*
FROM Products p
JOIN ProductCategories pc ON p.ProductID = pc.ProductID
JOIN Categories c ON pc.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Electronics';

-- Retrieve all customers who have placed orders
SELECT c.CustomerID, c.FirstName, c.LastName, c.Email
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;



