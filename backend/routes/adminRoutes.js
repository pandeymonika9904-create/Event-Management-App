const express = require('express');
const router = express.Router();
const {
  getOrganizers,
  updateOrganizerStatus,
  updateEventStatus,
  getAdminStats
} = require('../controllers/adminController');
const { protect, authorizeRoles } = require('../middleware/authMiddleware');

// Mount protect and restrict to Admin/SuperAdmin for all routes in this router
router.use(protect);
router.use(authorizeRoles('Admin', 'SuperAdmin'));

router.get('/organizers', getOrganizers);
router.put('/organizer/:id/status', updateOrganizerStatus);
router.put('/event/:id/status', updateEventStatus);
router.get('/stats', getAdminStats);

module.exports = router;
