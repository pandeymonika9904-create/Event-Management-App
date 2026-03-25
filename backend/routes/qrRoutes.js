const express = require('express');
const router = express.Router();
const {
  generateBookingQR,
  scanQRCode
} = require('../controllers/qrController');
const { protect, authorizeRoles } = require('../middleware/authMiddleware');

router.get('/:bookingId', protect, generateBookingQR);
router.post('/scan', protect, authorizeRoles('Organizer', 'Admin', 'SuperAdmin'), scanQRCode);

module.exports = router;
