-- Create database
CREATE DATABASE IF NOT EXISTS hotchix_db;
USE hotchix_db;

-- Create Customer table
CREATE TABLE IF NOT EXISTS Customer (
    C_id INT AUTO_INCREMENT PRIMARY KEY,
    C_name VARCHAR(100) NOT NULL,
    C_email VARCHAR(100) UNIQUE NOT NULL,
    C_contact VARCHAR(20) NOT NULL,
    C_password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Waiter table
CREATE TABLE IF NOT EXISTS Waiter (
    W_id INT AUTO_INCREMENT PRIMARY KEY,
    W_name VARCHAR(100) NOT NULL,
    W_email VARCHAR(100) UNIQUE NOT NULL,
    W_contact VARCHAR(20) NOT NULL,
    W_password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Staff table
CREATE TABLE IF NOT EXISTS Staff (
    S_id INT AUTO_INCREMENT PRIMARY KEY,
    S_name VARCHAR(100) NOT NULL,
    S_contact VARCHAR(20) NOT NULL,
    S_role VARCHAR(50) NOT NULL,
    S_password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Chef table
CREATE TABLE IF NOT EXISTS Chef (
    CH_id INT AUTO_INCREMENT PRIMARY KEY,
    CH_name VARCHAR(100) NOT NULL,
    CH_contact VARCHAR(20) NOT NULL,
    CH_speciality VARCHAR(100),
    CH_password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Menu Categories table
CREATE TABLE IF NOT EXISTS MenuCategory (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Create Menu Items table
CREATE TABLE IF NOT EXISTS MenuItem (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    is_veg BOOLEAN DEFAULT TRUE,
    is_available BOOLEAN DEFAULT TRUE,
    image_url VARCHAR(255),
    FOREIGN KEY (category_id) REFERENCES MenuCategory(category_id)
);

-- Create Order table
CREATE TABLE IF NOT EXISTS `Order` (
    Order_Id INT AUTO_INCREMENT PRIMARY KEY,
    C_id INT,
    W_id INT,
    S_id INT,
    CH_id INT,
    Order_Date_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Order_Amount DECIMAL(10, 2) NOT NULL,
    Order_Status ENUM('Pending', 'Preparing', 'Ready', 'Served', 'Paid', 'Cancelled') DEFAULT 'Pending',
    table_number INT,
    special_instructions TEXT,
    FOREIGN KEY (C_id) REFERENCES Customer(C_id),
    FOREIGN KEY (W_id) REFERENCES Waiter(W_id),
    FOREIGN KEY (S_id) REFERENCES Staff(S_id),
    FOREIGN KEY (CH_id) REFERENCES Chef(CH_id)
);

-- Create Order Items table
CREATE TABLE IF NOT EXISTS OrderItem (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    Order_Id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    item_price DECIMAL(10, 2) NOT NULL,
    special_instructions TEXT,
    FOREIGN KEY (Order_Id) REFERENCES `Order`(Order_Id),
    FOREIGN KEY (item_id) REFERENCES MenuItem(item_id)
);

-- Insert sample menu categories
INSERT INTO MenuCategory (category_name, description) VALUES
('North Indian', 'Traditional North Indian cuisine with rich flavors and aromatic spices'),
('South Indian', 'Authentic South Indian dishes known for their distinct flavors and spices'),
('Chinese', 'Vegetarian Chinese cuisine with a blend of traditional and Indo-Chinese flavors'),
('Italian', 'Authentic Italian vegetarian dishes with fresh ingredients'),
('Mexican', 'Spicy and flavorful vegetarian Mexican cuisine'),
('Continental', 'A variety of vegetarian continental dishes from across Europe');

-- Insert sample menu items
INSERT INTO MenuItem (category_id, item_name, description, price, is_veg, is_available) VALUES
(1, 'Paneer Butter Masala', 'Cottage cheese cubes in rich tomato gravy', 250.00, TRUE, TRUE),
(1, 'Dal Makhani', 'Black lentils cooked overnight with butter and cream', 200.00, TRUE, TRUE),
(2, 'Masala Dosa', 'Crispy rice crepe filled with spiced potato filling', 150.00, TRUE, TRUE),
(2, 'Idli Sambar', 'Steamed rice cakes served with lentil soup and chutney', 120.00, TRUE, TRUE),
(3, 'Veg Manchurian', 'Vegetable dumplings in spicy sauce', 180.00, TRUE, TRUE),
(3, 'Hakka Noodles', 'Stir-fried noodles with vegetables', 160.00, TRUE, TRUE),
(4, 'Margherita Pizza', 'Classic pizza with tomato sauce, mozzarella, and basil', 300.00, TRUE, TRUE),
(4, 'Pasta Arrabiata', 'Penne pasta in spicy tomato sauce', 250.00, TRUE, TRUE),
(5, 'Veg Burrito', 'Flour tortilla filled with beans, rice, and vegetables', 220.00, TRUE, TRUE),
(5, 'Nachos Grande', 'Tortilla chips topped with beans, cheese, and salsa', 200.00, TRUE, TRUE),
(6, 'Veg Lasagna', 'Layered pasta with vegetables and cheese', 280.00, TRUE, TRUE),
(6, 'Ratatouille', 'French vegetable stew with herbs', 240.00, TRUE, TRUE);
