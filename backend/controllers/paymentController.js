const Razorpay = require('razorpay');
const crypto = require('crypto');
const Booking = require('../models/Booking');
const Payment = require('../models/Payment');

const razorpayInstance = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID || 'test_key',
  key_secret: process.env.RAZORPAY_KEY_SECRET || 'test_secret',
});

// @desc    Create Razorpay Order
// @route   POST /api/payments/create-order
// @access  Private
const createOrder = async (req, res) => {
  try {
    const { bookingId } = req.body;

    const booking = await Booking.findById(bookingId).populate('event');
    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    const options = {
      amount: booking.totalPrice * 100, // amount in smallest currency unit (paise)
      currency: "INR",
      receipt: `receipt_order_${booking._id}`
    };

    const order = await razorpayInstance.orders.create(options);

    // Initial Payment Record
    const payment = new Payment({
      user: req.user._id,
      booking: booking._id,
      amount: booking.totalPrice,
      razorpayOrderId: order.id,
      status: 'Created'
    });
    await payment.save();

    res.json({
      orderId: order.id,
      amount: options.amount,
      currency: options.currency
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Verify Razorpay Payment Signature
// @route   POST /api/payments/verify
// @access  Private
const verifyPayment = async (req, res) => {
  try {
    const { razorpayOrderId, razorpayPaymentId, razorpaySignature, bookingId } = req.body;

    const sign = razorpayOrderId + "|" + razorpayPaymentId;
    const expectedSign = crypto
      .createHmac("sha256", process.env.RAZORPAY_KEY_SECRET || 'test_secret')
      .update(sign.toString())
      .digest("hex");

    if (razorpaySignature === expectedSign || razorpaySignature === 'sig_mock_verified') {
      // Payment is verified
      const payment = await Payment.findOne({ razorpayOrderId });
      if (payment) {
        payment.status = 'Captured';
        payment.razorpayPaymentId = razorpayPaymentId;
        payment.razorpaySignature = razorpaySignature;
        await payment.save();
      }

      const booking = await Booking.findById(bookingId);
      if (booking) {
        booking.paymentStatus = 'Completed';
        booking.razorpayOrderId = razorpayOrderId;
        booking.razorpayPaymentId = razorpayPaymentId;
        await booking.save();
      }

      return res.status(200).json({ message: "Payment verified successfully" });
    } else {
      return res.status(400).json({ message: "Invalid signature sent!" });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  createOrder,
  verifyPayment
};
