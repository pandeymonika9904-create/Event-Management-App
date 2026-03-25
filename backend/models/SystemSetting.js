const mongoose = require('mongoose');

const systemSettingSchema = new mongoose.Schema({
  platformCommissionPercent: {
    type: Number,
    default: 10
  },
  supportEmail: {
    type: String,
    default: 'support@eventapp.com'
  },
  maintenanceMode: {
    type: Boolean,
    default: false
  }
}, { timestamps: true });

module.exports = mongoose.model('SystemSetting', systemSettingSchema);
