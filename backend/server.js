const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');

// Load env vars
dotenv.config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Routes imports
const authRoutes = require('./routes/authRoutes');
const eventRoutes = require('./routes/eventRoutes');
const bookingRoutes = require('./routes/bookingRoutes');
const paymentRoutes = require('./routes/paymentRoutes');
const qrRoutes = require('./routes/qrRoutes');
const adminRoutes = require('./routes/adminRoutes');

// Mount routes
app.use('/api/auth', authRoutes);
app.use('/api/events', eventRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/qr', qrRoutes);
app.use('/api/admin', adminRoutes);

app.get('/', (req, res) => {
  res.send('Event Management API is running...');
});

// Database Connection
const PORT = process.env.PORT || 5000;
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/event_management';

mongoose
  .connect(MONGO_URI)
  .then(() => {
    console.log('MongoDB Connected');
    app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
  })
  .catch((err) => {
    console.error(`Error connecting to MongoDB: ${err.message}`);
    process.exit(1);
  });
