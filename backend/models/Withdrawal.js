const mongoose = require('mongoose');

const withdrawalSchema = new mongoose.Schema({
  organizer: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  amount: {
    type: Number,
    required: true
  },
  bankDetails: {
    accountNumber: String,
    ifscCode: String,
    bankName: String,
    accountHolderName: String
  },
  status: {
    type: String,
    enum: ['Pending', 'Processing', 'Completed', 'Rejected'],
    default: 'Pending'
  },
  transactionId: {
    type: String
  },
  adminRemarks: {
    type: String
  }
}, { timestamps: true });

module.exports = mongoose.model('Withdrawal', withdrawalSchema);
