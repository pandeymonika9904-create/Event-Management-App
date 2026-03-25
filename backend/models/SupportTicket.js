const mongoose = require('mongoose');

const supportTicketSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  subject: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  status: {
    type: String,
    enum: ['Open', 'InProgress', 'Resolved', 'Closed'],
    default: 'Open'
  },
  adminResponse: {
    type: String
  }
}, { timestamps: true });

module.exports = mongoose.model('SupportTicket', supportTicketSchema);
