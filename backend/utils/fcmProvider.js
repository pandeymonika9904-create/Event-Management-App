// This is a mocked Firebase Cloud Messaging Utility
// Setup actual admin.initializeApp() with serviceAccount JSON for production

const admin = require('firebase-admin');

// Mock init
// const serviceAccount = require('./serviceAccountKey.json');
// admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

const sendPushNotification = async (fcmToken, title, body, data = {}) => {
  try {
    console.log(`[FCM Mock] Sending notification to ${fcmToken}`);
    console.log(`[FCM Mock] Title: ${title}, Body: ${body}`);
    // Actual implementation
    // const message = { notification: { title, body }, data, token: fcmToken };
    // const response = await admin.messaging().send(message);
    // return response;
    return true;
  } catch (error) {
    console.error('Error sending message:', error);
    return false;
  }
};

module.exports = { sendPushNotification };
