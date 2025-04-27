# HotChix Restaurant Management System

A complete restaurant management system for HotChix, a pure vegetarian luxury restaurant.

## Project Overview

- **Frontend**: HTML, CSS, JavaScript
- **Backend**: Python (Flask) + MySQL
- **Theme**: Luxurious, 3D effects, Parallax animations, Glassmorphism login/register page
- **Color Scheme**: Charcoal black, Royal red, Gold tones, Bold primaries

## Features

- User authentication (login/register)
- Responsive design with luxury aesthetics
- Menu browsing by cuisine type
- Online ordering system
- Admin panel for restaurant management
- Table reservation system

## Project Structure

\`\`\`
hotchix_restaurant/
├── index.html                # Main landing page with login/register
├── admin.html                # Admin panel
├── north-indian.html         # North Indian cuisine page
├── italian.html              # Italian cuisine page (to be created)
├── mexican.html              # Mexican cuisine page (to be created)
├── continental.html          # Continental cuisine page (to be created)
├── chinese.html              # Chinese cuisine page (to be created)
├── south-indian.html         # South Indian cuisine page (to be created)
├── css/
│   ├── style.css             # Main stylesheet
│   ├── admin.css             # Admin panel styles
│   ├── indian.css            # North Indian cuisine styles
│   └── ...                   # Other cuisine-specific styles
├── js/
│   ├── script.js             # Main JavaScript file
│   └── admin.js              # Admin panel JavaScript
├── app.py                    # Flask backend
├── database.sql              # SQL schema and sample data
└── requirements.txt          # Python dependencies
\`\`\`

## Setup Instructions

### Frontend

1. Clone the repository
2. Open `index.html` in your browser to view the frontend

### Backend

1. Set up a MySQL database:
   \`\`\`
   mysql -u root -p < database.sql
   \`\`\`

2. Install Python dependencies:
   \`\`\`
   pip install -r requirements.txt
   \`\`\`

3. Run the Flask application:
   \`\`\`
   python app.py
   \`\`\`

4. Access the application at `http://localhost:5000`

## Database Schema

The database follows the ER diagram with the following entities:
- Customer
- Waiter
- Staff
- Order
- Chef

And relationships:
- Orders (Customer to Order)
- Manages (Staff to Order)
- Has (Waiter to Order)
- Prepared By (Chef to Order)

## Future Enhancements

- Complete all cuisine pages
- Implement real-time order tracking
- Add payment gateway integration
- Develop mobile application
- Implement analytics dashboard

## Credits

- Developed by: [Your Name]
- Design: Luxury restaurant theme with glassmorphism effects
- Icons: Font Awesome
- Fonts: Playfair Display, Poppins
