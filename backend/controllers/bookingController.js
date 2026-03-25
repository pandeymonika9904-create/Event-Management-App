const Booking = require('../models/Booking');
const Event = require('../models/Event');
const crypto = require('crypto');
const Razorpay = require('razorpay');

const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID || 'dummy_id',
  key_secret: process.env.RAZORPAY_KEY_SECRET || 'dummy_secret',
});

// @desc    Create new booking
// @route   POST /api/bookings
// @access  Private
const createBooking = async (req, res) => {
  try {
    const { eventId, ticketType, quantity } = req.body;

    const event = await Event.findById(eventId);
    if (!event) {
      return res.status(404).json({ message: 'Event not found' });
    }

    const ticketCategory = event.tickets.find((t) => t.type === ticketType);
    if (!ticketCategory) {
      return res.status(404).json({ message: 'Ticket type not found' });
    }

    if (ticketCategory.totalAvailable - ticketCategory.sold < quantity) {
      return res.status(400).json({ message: 'Not enough tickets available' });
    }

    const totalPrice = ticketCategory.price * quantity;

    // Create Razorpay Order
    const options = {
      amount: totalPrice * 100, // amount in paise
      currency: 'INR',
      receipt: `receipt_order_${Math.floor(Math.random() * 100000)}`,
    };

    const order = await razorpay.orders.create(options);

    const booking = new Booking({
      user: req.user._id,
      event: eventId,
      ticketType,
      quantity,
      totalPrice,
      paymentStatus: 'Pending',
    });

    const createdBooking = await booking.save();
    
    // We update sold count after payment success usually
    res.status(201).json({
      booking: createdBooking,
      orderId: order.id,
      amount: order.amount,
      currency: order.currency
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Verify Razorpay payment
// @route   POST /api/bookings/verify
// @access  Private
const verifyPayment = async (req, res) => {
  try {
    const { razorpay_order_id, razorpay_payment_id, razorpay_signature, bookingId } = req.body;
    
    // Verify signature
    const sign = razorpay_order_id + "|" + razorpay_payment_id;
    const expectedSign = crypto
      .createHmac("sha256", process.env.RAZORPAY_KEY_SECRET || 'dummy_secret')
      .update(sign.toString())
      .digest("hex");

    if (razorpay_signature === expectedSign) {
      // Payment is successful
      const booking = await Booking.findById(bookingId);
      if (!booking) return res.status(404).json({ message: 'Booking not found' });

      booking.paymentStatus = 'Paid';
      booking.qrCodeToken = crypto.randomUUID(); // Generate QR code token
      await booking.save();

      // Update event ticket sold count
      const event = await Event.findById(booking.event);
      const ticketCategory = event.tickets.find((t) => t.type === booking.ticketType);
      if (ticketCategory) {
        ticketCategory.sold += booking.quantity;
        await event.save();
      }

      return res.status(200).json({ message: "Payment verified successfully", booking });
    } else {
      return res.status(400).json({ message: "Invalid signature sent!" });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get logged in user bookings
// @route   GET /api/bookings/mybookings
// @access  Private
const getMyBookings = async (req, res) => {
  try {
    const bookings = await Booking.find({ user: req.user._id }).populate('event', 'title bannerImage date time location');
    res.json(bookings);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get booking by ID
// @route   GET /api/bookings/:id
// @access  Private
const getBookingById = async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id)
      .populate('user', 'name email')
      .populate('event', 'title bannerImage date location category organizer tickets');

    if (booking) {
      if (booking.user._id.toString() !== req.user._id.toString() && !['Organizer', 'Admin', 'SuperAdmin'].includes(req.user.role)) {
         return res.status(403).json({ message: 'Not authorized to view this booking' });
      }
      res.json(booking);
    } else {
      res.status(404).json({ message: 'Booking not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  createBooking,
  verifyPayment,
  getMyBookings,
  getBookingById
};
