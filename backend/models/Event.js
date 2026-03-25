const mongoose = require('mongoose');

const ticketCategorySchema = new mongoose.Schema({
  type: {
    type: String, // e.g., 'VIP', 'General', 'Early Bird'
    required: true
  },
  price: {
    type: Number,
    required: true
  },
  totalAvailable: {
    type: Number,
    required: true
  },
  sold: {
    type: Number,
    default: 0
  }
});

const eventSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  bannerImage: {
    type: String, // URL of the image
    required: true
  },
  organizer: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  category: {
    type: String,
    enum: ['Music', 'Tech', 'Food', 'Business', 'Other'],
    required: true
  },
  date: {
    type: Date,
    required: true
  },
  time: {
    type: String,
    required: true
  },
  location: {
    type: String,
    required: true
  },
  tickets: [ticketCategorySchema],
  status: {
    type: String,
    enum: ['Pending', 'Approved', 'Rejected', 'Completed', 'Cancelled'],
    default: 'Pending'
  },
  isTrending: {
    type: Boolean,
    default: false
  }
}, { timestamps: true });

module.exports = mongoose.model('Event', eventSchema);
