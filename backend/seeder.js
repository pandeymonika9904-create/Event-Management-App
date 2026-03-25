require('dotenv').config();
const mongoose = require('mongoose');
const User = require('./models/User');
const Event = require('./models/Event');

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('MongoDB Connected for Seeding');
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1);
  }
};

const importData = async () => {
  try {
    await connectDB();

    await Event.deleteMany();
    await User.deleteMany();

    // Create Demo Organizer
    const orgUser = await User.create({
      name: 'Tech Events Inc',
      email: 'organizer@demo.com',
      password: 'password123',
      role: 'Organizer',
      kycStatus: 'Approved'
    });

    const orgUser2 = await User.create({
      name: 'Music Festivals Co',
      email: 'music@demo.com',
      password: 'password123',
      role: 'Organizer',
      kycStatus: 'Approved'
    });

    // Create Demo Regular User
    await User.create({
      name: 'John Doe',
      email: 'user@demo.com',
      password: 'password123',
      role: 'User'
    });

    // Create Demo Events
    const events = [
      {
        title: 'Global Tech Conference 2026',
        description: 'Join thousands of developers, founders, and investors for the biggest tech conference of the year. Featuring keynotes from industry leaders, workshops, and networking opportunities. Experience the future of technology firsthand.',
        bannerImage: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
        organizer: orgUser._id,
        category: 'Tech',
        date: new Date('2026-05-15'),
        time: '09:00 AM',
        location: 'Silicon Valley Convention Center, CA',
        status: 'Approved',
        isTrending: true,
        tickets: [
          { type: 'General Admission', price: 199, totalAvailable: 500, sold: 120 },
          { type: 'VIP Pass', price: 499, totalAvailable: 100, sold: 85 }
        ]
      },
      {
        title: 'Summer EDM Festival',
        description: 'The ultimate summer music experience featuring top international DJs. Three days of non-stop music, amazing light shows, and unforgettable memories under the stars.',
        bannerImage: 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800&q=80',
        organizer: orgUser2._id,
        category: 'Music',
        date: new Date('2026-07-20'),
        time: '04:00 PM',
        location: 'Miami Beach, FL',
        status: 'Approved',
        isTrending: true,
        tickets: [
          { type: 'Early Bird', price: 89, totalAvailable: 1000, sold: 1000 },
          { type: 'Regular', price: 129, totalAvailable: 2000, sold: 450 },
          { type: 'Backstage VIP', price: 299, totalAvailable: 200, sold: 50 }
        ]
      },
      {
        title: 'Street Food Carnival',
        description: 'Taste the world at our annual Street Food Carnival. Over 100 vendors serving delicious street food from every continent. Live music, cooking demonstrations, and family-friendly activities.',
        bannerImage: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&q=80',
        organizer: orgUser._id,
        category: 'Food',
        date: new Date('2026-04-10'),
        time: '11:00 AM',
        location: 'Downtown Park, NY',
        status: 'Rejected',
        isTrending: false,
        tickets: [
          { type: 'Entry + Tasting Pass', price: 45, totalAvailable: 5000, sold: 1200 },
          { type: 'Entry Only', price: 15, totalAvailable: 10000, sold: 3400 }
        ]
      },
      {
        title: 'Startup Pitch Summit',
        description: 'Watch the most promising startups pitch their ideas to top venture capitalists. A must-attend event for founders, investors, and anyone interested in the startup ecosystem.',
        bannerImage: 'https://images.unsplash.com/photo-1556761175-4b46a572b786?w=800&q=80',
        organizer: orgUser._id,
        category: 'Business',
        date: new Date('2026-06-05'),
        time: '10:00 AM',
        location: 'Innovation Hub, Boston',
        status: 'Pending',
        isTrending: false,
        tickets: [
          { type: 'Standard Access', price: 299, totalAvailable: 300, sold: 150 },
          { type: 'Investor Pass', price: 999, totalAvailable: 50, sold: 10 }
        ]
      },
      {
        title: 'Jazz in the Park',
        description: 'A relaxing evening of smooth jazz performed by award-winning artists. Bring a blanket, pack a picnic, and enjoy the beautiful sunset vibes.',
        bannerImage: 'https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=800&q=80',
        organizer: orgUser2._id,
        category: 'Music',
        date: new Date('2026-08-12'),
        time: '06:00 PM',
        location: 'Central Park Amphitheater, NY',
        status: 'Approved',
        isTrending: false,
        tickets: [
          { type: 'General', price: 35, totalAvailable: 1500, sold: 800 },
          { type: 'VIP Seating', price: 85, totalAvailable: 200, sold: 180 }
        ]
      }
    ];

    await Event.insertMany(events);
    console.log('Data Imported successfully!');
    process.exit();
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1);
  }
};

importData();
