QUESTION 1: ACHIEVING 1NF
-- Split comma-separated products into individual rows
WITH RECURSIVE split_products AS (
    SELECT 
        OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
        SUBSTRING(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2) AS RemainingProducts
    FROM ProductDetail
    WHERE Products IS NOT NULL AND Products != ''
    
    UNION ALL
    
    SELECT 
        OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(RemainingProducts, ',', 1)),
        SUBSTRING(RemainingProducts, LENGTH(SUBSTRING_INDEX(RemainingProducts, ',', 1)) + 2)
    FROM split_products
    WHERE RemainingProducts IS NOT NULL AND RemainingProducts != ''
)
SELECT 
    OrderID,
    CustomerName,
    Product
FROM split_products
ORDER BY OrderID;

QUESTION 2: ACHIEVING 2NF

-- Create Orders table to remove partial dependency
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Create OrderItems table for order-specific details
CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert data into Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Insert data into OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
