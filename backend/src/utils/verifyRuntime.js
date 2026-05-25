require('dotenv').config();
const mongoose = require('mongoose');
const { initializeFirebaseAdmin, admin } = require('./firebaseAdmin');
const { requireEnv } = require('./env');

async function verifyRuntime() {
  requireEnv(['MONGO_URI', 'FIREBASE_PROJECT_ID']);
  let failed = false;

  initializeFirebaseAdmin();

  try {
    await admin.auth().listUsers(1);
    console.log('Firebase Admin verified');
  } catch (err) {
    failed = true;
    console.error(`Firebase Admin failed: ${err.message}`);
  }

  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('MongoDB verified');
  } catch (err) {
    failed = true;
    console.error(`MongoDB failed: ${err.message}`);
  } finally {
    await mongoose.disconnect().catch(() => {});
  }

  if (failed) process.exit(1);
}

verifyRuntime().catch(async (err) => {
  console.error(err.message);
  await mongoose.disconnect().catch(() => {});
  process.exit(1);
});
