const Event = require('../models/Event');

// @desc    Get all active events
// @route   GET /api/events
// @access  Public
const getEvents = async (req, res) => {
  try {
    const keyword = req.query.keyword ? {
      title: {
        $regex: req.query.keyword,
        $options: 'i',
      },
    } : {};

    const category = req.query.category ? { category: req.query.category } : {};

    const events = await Event.find({ ...keyword, ...category, status: 'Approved' }).populate('organizer', 'name email');
    res.json(events);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get logged in organizer's events
// @route   GET /api/events/organizer/my-events
// @access  Private/Organizer
const getOrganizerEvents = async (req, res) => {
  try {
    const events = await Event.find({ organizer: req.user._id })
      .sort({ createdAt: -1 })
      .populate('organizer', 'name email');
    res.json(events);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get single event by ID
// @route   GET /api/events/:id
// @access  Public
const getEventById = async (req, res) => {
  try {
    const event = await Event.findById(req.params.id).populate('organizer', 'name email');
    if (event) {
      res.json(event);
    } else {
      res.status(404).json({ message: 'Event not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Create new event
// @route   POST /api/events
// @access  Private/Organizer
const createEvent = async (req, res) => {
  try {
    const { title, description, bannerImage, category, date, time, location, tickets } = req.body;

    const event = new Event({
      title,
      description,
      bannerImage,
      organizer: req.user._id, // Available from authMiddleware
      category,
      date,
      time,
      location,
      tickets,
      status: 'Pending' // Admin needs to approve
    });

    const createdEvent = await event.save();
    res.status(201).json(createdEvent);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Update an event
// @route   PUT /api/events/:id
// @access  Private/Organizer
const updateEvent = async (req, res) => {
  try {
    const event = await Event.findById(req.params.id);

    if (event) {
      // Check if user is the organizer (or Admin/SuperAdmin)
      if (event.organizer.toString() !== req.user._id.toString() && !['Admin', 'SuperAdmin'].includes(req.user.role)) {
         return res.status(403).json({ message: 'Not authorized to edit this event' });
      }

      event.title = req.body.title || event.title;
      event.description = req.body.description || event.description;
      event.bannerImage = req.body.bannerImage || event.bannerImage;
      event.category = req.body.category || event.category;
      event.date = req.body.date || event.date;
      event.time = req.body.time || event.time;
      event.location = req.body.location || event.location;
      
      if(req.body.tickets) {
        event.tickets = req.body.tickets;
      }

      const updatedEvent = await event.save();
      res.json(updatedEvent);
    } else {
      res.status(404).json({ message: 'Event not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Delete an event
// @route   DELETE /api/events/:id
// @access  Private/Organizer
const deleteEvent = async (req, res) => {
  try {
    const event = await Event.findById(req.params.id);

    if (event) {
      if (event.organizer.toString() !== req.user._id.toString() && !['Admin', 'SuperAdmin'].includes(req.user.role)) {
         return res.status(403).json({ message: 'Not authorized to delete this event' });
      }
      
      await event.deleteOne();
      res.json({ message: 'Event removed' });
    } else {
      res.status(404).json({ message: 'Event not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getEvents,
  getOrganizerEvents,
  getEventById,
  createEvent,
  updateEvent,
  deleteEvent
};
