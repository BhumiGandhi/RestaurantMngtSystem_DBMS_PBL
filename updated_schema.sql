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

-- Create Staff table (for managers)
CREATE TABLE IF NOT EXISTS Staff (
    S_id INT AUTO_INCREMENT PRIMARY KEY,
    S_name VARCHAR(100) NOT NULL,
    S_email VARCHAR(100) UNIQUE NOT NULL,
    S_contact VARCHAR(20) NOT NULL,
    S_role ENUM('manager', 'admin', 'receptionist') NOT NULL,
    S_password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Waiter table
CREATE TABLE IF NOT EXISTS Waiter (
    W_id INT AUTO_INCREMENT PRIMARY KEY,
    W_name VARCHAR(100) NOT NULL,
    W_email VARCHAR(100) UNIQUE NOT NULL,
    W_contact VARCHAR(20) NOT NULL,
    W_password VARCHAR(255) NOT NULL,
    W_experience INT DEFAULT 0, -- Years of experience
    W_shift ENUM('morning', 'evening', 'night') DEFAULT 'morning',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Chef table
CREATE TABLE IF NOT EXISTS Chef (
    CH_id INT AUTO_INCREMENT PRIMARY KEY,
    CH_name VARCHAR(100) NOT NULL,
    CH_email VARCHAR(100) UNIQUE NOT NULL,
    CH_contact VARCHAR(20) NOT NULL,
    CH_speciality VARCHAR(100),
    CH_password VARCHAR(255) NOT NULL,
    CH_experience INT DEFAULT 0, -- Years of experience
    CH_shift ENUM('morning', 'evening', 'night') DEFAULT 'morning',
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
    chef_id INT, -- Chef who specializes in this item
    FOREIGN KEY (category_id) REFERENCES MenuCategory(category_id),
    FOREIGN KEY (chef_id) REFERENCES Chef(CH_id)
);

-- Create Table table for restaurant tables
CREATE TABLE IF NOT EXISTS RestaurantTable (
    table_id INT AUTO_INCREMENT PRIMARY KEY,
    table_number INT NOT NULL UNIQUE,
    capacity INT NOT NULL,
    is_available BOOLEAN DEFAULT TRUE
);

-- Create Order table
CREATE TABLE IF NOT EXISTS `Order` (
    Order_Id INT AUTO_INCREMENT PRIMARY KEY,
    C_id INT,
    W_id INT,
    S_id INT,
    CH_id INT,
    table_id INT,
    Order_Date_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Order_Amount DECIMAL(10, 2) NOT NULL,
    Order_Status ENUM('Pending', 'Confirmed', 'Preparing', 'Ready', 'Served', 'Paid', 'Cancelled') DEFAULT 'Pending',
    special_instructions TEXT,
    payment_method ENUM('Cash', 'Credit Card', 'Debit Card', 'Online') DEFAULT 'Cash',
    payment_status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (C_id) REFERENCES Customer(C_id),
    FOREIGN KEY (W_id) REFERENCES Waiter(W_id),
    FOREIGN KEY (S_id) REFERENCES Staff(S_id),
    FOREIGN KEY (CH_id) REFERENCES Chef(CH_id),
    FOREIGN KEY (table_id) REFERENCES RestaurantTable(table_id)
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

-- Create Reservation table
CREATE TABLE IF NOT EXISTS Reservation (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    C_id INT NOT NULL,
    table_id INT,
    reservation_date DATE NOT NULL,
    reservation_time TIME NOT NULL,
    num_guests INT NOT NULL,
    status ENUM('Pending', 'Confirmed', 'Cancelled') DEFAULT 'Pending',
    special_request TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (C_id) REFERENCES Customer(C_id),
    FOREIGN KEY (table_id) REFERENCES RestaurantTable(table_id)
);

-- Insert sample data for staff (managers)
INSERT INTO Staff (S_name, S_email, S_contact, S_role, S_password) VALUES
('John Smith', 'john.smith@hotchix.com', '555-123-4567', 'manager', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy'),
('Sarah Johnson', 'sarah.johnson@hotchix.com', '555-234-5678', 'admin', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy'),
('Michael Brown', 'michael.brown@hotchix.com', '555-345-6789', 'receptionist', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy');
-- Password is 'admin123' for all

-- Insert sample data for waiters
INSERT INTO Waiter (W_name, W_email, W_contact, W_password, W_experience, W_shift) VALUES
('Emily Davis', 'emily.davis@hotchix.com', '555-456-7890', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy', 3, 'morning'),
('David Wilson', 'david.wilson@hotchix.com', '555-567-8901', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy', 5, 'evening'),
('Jessica Martinez', 'jessica.martinez@hotchix.com', '555-678-9012', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy', 2, 'night'),
('Robert Taylor', 'robert.taylor@hotchix.com', '555-789-0123', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy', 4, 'morning');
-- Password is 'admin123' for all

-- Insert sample data for chefs
INSERT INTO Chef (CH_name, CH_email, CH_contact, CH_speciality, CH_password, CH_experience, CH_shift) VALUES
('Amit Sharma', 'amit.sharma@hotchix.com', '555-890-1234', 'North Indian', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy', 8, 'morning'),
('Marco Rossi', 'marco.rossi@hotchix.com', '555-901-2345', 'Italian', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy', 10, 'evening'),
('Carlos Rodriguez', 'carlos.rodriguez@hotchix.com', '555-012-3456', 'Mexican', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy', 7, 'night'),
('Pierre Dubois', 'pierre.dubois@hotchix.com', '555-123-4567', 'Continental', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy', 12, 'morning'),
('Li Wei', 'li.wei@hotchix.com', '555-234-5678', 'Chinese', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy', 9, 'evening'),
('Venkat Rao', 'venkat.rao@hotchix.com', '555-345-6789', 'South Indian', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy', 15, 'morning');
-- Password is 'admin123' for all

-- Insert sample restaurant tables
INSERT INTO RestaurantTable (table_number, capacity, is_available) VALUES
(1, 2, TRUE),
(2, 2, TRUE),
(3, 4, TRUE),
(4, 4, TRUE),
(5, 6, TRUE),
(6, 6, TRUE),
(7, 8, TRUE),
(8, 8, TRUE),
(9, 10, TRUE),
(10, 10, TRUE);

-- Insert sample menu categories
INSERT INTO MenuCategory (category_name, description) VALUES
('North Indian', 'Traditional North Indian cuisine with rich flavors and aromatic spices'),
('South Indian', 'Authentic South Indian dishes known for their distinct flavors and spices'),
('Chinese', 'Vegetarian Chinese cuisine with a blend of traditional and Indo-Chinese flavors'),
('Italian', 'Authentic Italian vegetarian dishes with fresh ingredients'),
('Mexican', 'Spicy and flavorful vegetarian Mexican cuisine'),
('Continental', 'A variety of vegetarian continental dishes from across Europe');

-- Insert sample menu items with chef specializations
INSERT INTO MenuItem (category_id, item_name, description, price, is_veg, is_available, image_url, chef_id) VALUES
-- North Indian items by Chef Amit Sharma
(1, 'Paneer Butter Masala', 'Cottage cheese cubes in rich tomato gravy', 250.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 1),
(1, 'Dal Makhani', 'Black lentils cooked overnight with butter and cream', 200.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 1),
(1, 'Vegetable Biryani', 'Fragrant basmati rice cooked with mixed vegetables and aromatic spices', 220.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 1),

-- South Indian items by Chef Venkat Rao
(2, 'Masala Dosa', 'Crispy rice crepe filled with spiced potato filling', 150.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 6),
(2, 'Idli Sambar', 'Steamed rice cakes served with lentil soup and chutney', 120.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 6),
(2, 'Vegetable Chettinad', 'Mixed vegetables cooked in a spicy Chettinad masala with coconut and curry leaves', 180.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 6),

-- Chinese items by Chef Li Wei
(3, 'Veg Manchurian', 'Vegetable dumplings in spicy sauce', 180.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 5),
(3, 'Hakka Noodles', 'Stir-fried noodles with vegetables', 160.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 5),
(3, 'Kung Pao Vegetables', 'Stir-fried vegetables with peanuts, dried chili peppers, and Sichuan peppercorns', 190.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 5),

-- Italian items by Chef Marco Rossi
(4, 'Margherita Pizza', 'Classic pizza with tomato sauce, mozzarella, and basil', 300.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 2),
(4, 'Pasta Arrabiata', 'Penne pasta in spicy tomato sauce', 250.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 2),
(4, 'Risotto ai Funghi', 'Creamy Arborio rice with wild mushrooms, white wine, and Parmesan', 280.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 2),

-- Mexican items by Chef Carlos Rodriguez
(5, 'Veg Burrito', 'Flour tortilla filled with beans, rice, and vegetables', 220.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 3),
(5, 'Nachos Grande', 'Tortilla chips topped with beans, cheese, and salsa', 200.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 3),
(5, 'Vegetable Fajitas', 'Sizzling skillet of grilled bell peppers, onions, and mushrooms', 240.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 3),

-- Continental items by Chef Pierre Dubois
(6, 'Veg Lasagna', 'Layered pasta with vegetables and cheese', 280.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 4),
(6, 'Ratatouille', 'French vegetable stew with herbs', 240.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 4),
(6, 'Vegetable Wellington', 'Roasted vegetables and mushroom duxelles wrapped in puff pastry', 320.00, TRUE, TRUE, '/placeholder.svg?height=200&width=300', 4);
