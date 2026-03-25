const express = require('express');
const router = express.Router();
const {
  getEvents,
  getOrganizerEvents,
  getEventById,
  createEvent,
  updateEvent,
  deleteEvent
} = require('../controllers/eventController');
const { protect, authorizeRoles } = require('../middleware/authMiddleware');

router.route('/')
  .get(getEvents)
  .post(protect, authorizeRoles('Organizer', 'Admin', 'SuperAdmin'), createEvent);

router.route('/organizer/my-events')
  .get(protect, authorizeRoles('Organizer'), getOrganizerEvents);

router.route('/:id')
  .get(getEventById)
  .put(protect, authorizeRoles('Organizer', 'Admin', 'SuperAdmin'), updateEvent)
  .delete(protect, authorizeRoles('Organizer', 'Admin', 'SuperAdmin'), deleteEvent);

module.exports = router;
