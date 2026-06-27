const fs = require('fs');
const admin = require('firebase-admin');

function initializeFirebaseAdmin() {
  if (admin.apps.length) return admin.app();

  if (process.env.FIREBASE_CLIENT_EMAIL && process.env.FIREBASE_PRIVATE_KEY) {
    return admin.initializeApp({
      credential: admin.credential.cert({
        projectId: process.env.FIREBASE_PROJECT_ID,
        clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
        privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
      }),
    });
  }

  if (fs.existsSync('./serviceAccountKey.json')) {
    const serviceAccount = JSON.parse(fs.readFileSync('./serviceAccountKey.json', 'utf8'));
    return admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
  }

  if (process.env.GOOGLE_APPLICATION_CREDENTIALS && !fs.existsSync(process.env.GOOGLE_APPLICATION_CREDENTIALS)) {
    throw new Error(`Firebase credential file not found: ${process.env.GOOGLE_APPLICATION_CREDENTIALS}`);
  }

  return admin.initializeApp({ credential: admin.credential.applicationDefault() });
}

module.exports = { admin, initializeFirebaseAdmin };
