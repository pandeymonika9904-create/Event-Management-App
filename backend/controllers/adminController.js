const User = require('../models/User');
const Event = require('../models/Event');
const Withdrawal = require('../models/Withdrawal');
const SystemSetting = require('../models/SystemSetting');
const Booking = require('../models/Booking');

// @desc    Get all organizers waiting for KYC check
// @route   GET /api/admin/organizers
// @access  Private/Admin
const getOrganizers = async (req, res) => {
  try {
    const organizers = await User.find({ role: 'Organizer' }).select('-password');
    res.json(organizers);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Approve/Reject Organizer KYC
// @route   PUT /api/admin/organizer/:id/status
// @access  Private/Admin
const updateOrganizerStatus = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (user && user.role === 'Organizer') {
      user.kycStatus = req.body.status || user.kycStatus;
      await user.save();
      res.json(user);
    } else {
      res.status(404).json({ message: 'Organizer not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Approve/Reject Event
// @route   PUT /api/admin/event/:id/status
// @access  Private/Admin
const updateEventStatus = async (req, res) => {
  try {
    const event = await Event.findById(req.params.id);
    if (event) {
      event.status = req.body.status || event.status;
      await event.save();
      res.json(event);
    } else {
      res.status(404).json({ message: 'Event not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get dashboard stats
// @route   GET /api/admin/stats
// @access  Private/Admin
const getAdminStats = async (req, res) => {
  try {
    const usersCount = await User.countDocuments();
    const eventsCount = await Event.countDocuments();
    const bookingsCount = await Booking.countDocuments();
    
    // Total revenue sum
    const totalRevenueResult = await Booking.aggregate([
      { $match: { paymentStatus: 'Paid' } },
      { $group: { _id: null, total: { $sum: '$totalPrice' } } }
    ]);
    const totalRevenue = totalRevenueResult.length > 0 ? totalRevenueResult[0].total : 0;

    res.json({ usersCount, eventsCount, bookingsCount, totalRevenue });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getOrganizers,
  updateOrganizerStatus,
  updateEventStatus,
  getAdminStats
};
