const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Initialize Firebase Admin SDK
const serviceAccount = require('./preganancy-tracker-firebase-adminsdk-fdnuw-4cc835fd64.json');
// Path to your service account key
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// Function to import data from JSON to Firestore
async function importCollection(collectionName, filePath) {
  const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));

  for (const doc of data) {
    // Use the MongoDB _id as the Firestore document ID (optional)
    const docRef = db.collection(collectionName).doc(doc._id.$oid);
    await docRef.set(doc);
    console.log(`Imported document ${doc._id.$oid} into ${collectionName}`);
  }

  console.log(`Finished importing ${collectionName}`);
}

// Import collections
(async () => {
  try {
    await importCollection('Users', path.join(__dirname, 'exported mangodb data', 'Pregnancy.users.json'));
    await importCollection('Appointments', path.join(__dirname, 'exported mangodb data', 'Pregnancy.appointments.json'));
    await importCollection('Notes', path.join(__dirname, 'exported mangodb data', 'Pregnancy.notes.json'));
    await importCollection('Profiles', path.join(__dirname, 'exported mangodb data', 'pregnancy.profiles.json'));
    await importCollection('Tips', path.join(__dirname, 'exported mangodb data', 'Pregnancy.tips.json'));
    await importCollection('Comments', path.join(__dirname, 'exported mangodb data', 'pregnancy.comments.json'));
    await importCollection('Posts', path.join(__dirname, 'exported mangodb data', 'pregnancy.posts.json'));

    console.log('All collections imported successfully!');
  } catch (error) {
    console.error('Error importing data:', error);
  }
})();