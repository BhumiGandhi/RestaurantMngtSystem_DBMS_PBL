-- Create the database
CREATE DATABASE IF NOT EXISTS hotchix_db;
USE hotchix_db;

-- Customer table
CREATE TABLE IF NOT EXISTS customer (
    c_id INT AUTO_INCREMENT PRIMARY KEY,
    c_name VARCHAR(100) NOT NULL,
    c_email VARCHAR(100) NOT NULL UNIQUE,
    c_contact VARCHAR(20) NOT NULL,
    c_password VARCHAR(255) NOT NULL
);

-- Staff table
CREATE TABLE IF NOT EXISTS staff (
    s_id INT AUTO_INCREMENT PRIMARY KEY,
    s_name VARCHAR(100) NOT NULL,
    s_email VARCHAR(100) NOT NULL UNIQUE,
    s_contact VARCHAR(20) NOT NULL,
    s_password VARCHAR(255) NOT NULL,
    s_role ENUM('manager', 'waiter', 'receptionist') NOT NULL
);

-- Waiter table
CREATE TABLE IF NOT EXISTS waiter (
    w_id INT AUTO_INCREMENT PRIMARY KEY,
    w_name VARCHAR(100) NOT NULL,
    w_email VARCHAR(100) NOT NULL UNIQUE,
    w_contact VARCHAR(20) NOT NULL
);

-- Chef table
CREATE TABLE IF NOT EXISTS chef (
    ch_id INT AUTO_INCREMENT PRIMARY KEY,
    ch_name VARCHAR(100) NOT NULL,
    ch_email VARCHAR(100) NOT NULL UNIQUE,
    ch_contact VARCHAR(20) NOT NULL
);

-- Order table
CREATE TABLE IF NOT EXISTS `order` (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    waiter_id INT,
    chef_id INT,
    order_date_time DATETIME NOT NULL,
    order_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'preparing', 'ready', 'delivered', 'cancelled') DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES customer(c_id),
    FOREIGN KEY (waiter_id) REFERENCES waiter(w_id),
    FOREIGN KEY (chef_id) REFERENCES chef(ch_id)
);

-- Order items table
CREATE TABLE IF NOT EXISTS order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    item_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES `order`(order_id)
);

-- Menu categories table
CREATE TABLE IF NOT EXISTS menu_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Menu items table
CREATE TABLE IF NOT EXISTS menu_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    is_vegetarian BOOLEAN DEFAULT TRUE,
    is_spicy BOOLEAN DEFAULT FALSE,
    is_popular BOOLEAN DEFAULT FALSE,
    image_url VARCHAR(255),
    FOREIGN KEY (category_id) REFERENCES menu_category(category_id)
);

-- Table reservation
CREATE TABLE IF NOT EXISTS reservation (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    reservation_date DATE NOT NULL,
    reservation_time TIME NOT NULL,
    num_guests INT NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending',
    special_request TEXT,
    FOREIGN KEY (customer_id) REFERENCES customer(c_id)
);

-- Insert sample data for menu categories
INSERT INTO menu_category (category_name, description) VALUES
('North Indian', 'Rich, aromatic flavors with exotic spices'),
('Italian', 'Authentic pastas and Mediterranean delights'),
('Mexican', 'Bold flavors with a spicy kick'),
('Continental', 'Refined European culinary traditions'),
('Chinese', 'Wok-tossed perfection with umami flavors'),
('South Indian', 'Traditional delicacies with coconut and curry leaves');

-- Insert sample menu items for North Indian category
INSERT INTO menu_item (category_id, item_name, description, price, is_vegetarian, is_spicy, is_popular, image_url) VALUES
(1, 'Paneer Tikka', 'Marinated cottage cheese cubes grilled to perfection with bell peppers and onions', 12.99, TRUE, TRUE, TRUE, '/placeholder.svg?height=200&width=300'),
(1, 'Vegetable Samosa', 'Crispy pastry filled with spiced potatoes and peas, served with mint and tamarind chutneys', 8.99, TRUE, FALSE, TRUE, '/placeholder.svg?height=200&width=300'),
(1, 'Aloo Tikki Chaat', 'Spiced potato patties topped with yogurt, chutneys, and crunchy sev', 10.99, TRUE, FALSE, FALSE, '/placeholder.svg?height=200&width=300'),
(1, 'Butter Paneer Masala', 'Cottage cheese cubes in a rich, creamy tomato sauce with aromatic spices', 16.99, TRUE, FALSE, TRUE, '/placeholder.svg?height=200&width=300'),
(1, 'Dal Makhani', 'Black lentils and kidney beans slow-cooked with cream, butter, and spices', 14.99, TRUE, FALSE, TRUE, '/placeholder.svg?height=200&width=300'),
(1, 'Vegetable Biryani', 'Fragrant basmati rice cooked with mixed vegetables and aromatic spices', 18.99, TRUE, TRUE, TRUE, '/placeholder.svg?height=200&width=300');

-- Insert sample staff (admin)
INSERT INTO staff (s_name, s_email, s_contact, s_password, s_role) VALUES
('Admin User', 'admin@hotchix.com', '1234567890', '$2b$12$1oE8Cv8Vh6HvMX5VnYIrKOHZVnRR3ou4x0yHzOiMfsTuEJ9VfA2Vy', 'manager');
-- Password is 'admin123'
