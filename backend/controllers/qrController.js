const QRCode = require('qrcode');
const Booking = require('../models/Booking');

// @desc    Generate QR Code for Booking
// @route   GET /api/qr/:bookingId
// @access  Private
const generateBookingQR = async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.bookingId);
    
    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    if (booking.user.toString() !== req.user._id.toString() && !['Organizer', 'Admin', 'SuperAdmin'].includes(req.user.role)) {
       return res.status(403).json({ message: 'Not authorized to view this QR code' });
    }

    const qrData = JSON.stringify({
      bookingId: booking._id,
      qrToken: booking.qrCodeToken,
      eventId: booking.event
    });

    const qrCodeImage = await QRCode.toDataURL(qrData);
    
    res.json({ qrCode: qrCodeImage });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Scan QR Code and Check-in
// @route   POST /api/qr/scan
// @access  Private/Organizer
const scanQRCode = async (req, res) => {
  try {
    const { qrToken } = req.body;

    const booking = await Booking.findOne({ qrCodeToken: qrToken }).populate('event');

    if (!booking) {
      return res.status(404).json({ message: 'Invalid QR Code' });
    }

    if (booking.event.organizer.toString() !== req.user._id.toString() && !['Admin', 'SuperAdmin'].includes(req.user.role)) {
       return res.status(403).json({ message: 'Not authorized to scan tickets for this event' });
    }

    if (booking.checkInStatus) {
      return res.status(400).json({ message: 'Ticket already used for check-in' });
    }

    booking.checkInStatus = true;
    await booking.save();

    res.json({ message: 'Check-in successful', booking });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  generateBookingQR,
  scanQRCode
};
