const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../.env') });
const https = require('https');

const restaurants = [
    'Ravi Restaurant Dubai',
    'Karachi Darbar Dubai',
    'Hatam Iranian Restaurant Dubai',
    'Tagpuan Filipino Restaurant Dubai',
    'Manam Restaurant Dubai',
    'Al Ustad Special Kabab Dubai',
    'Calicut Notebook Dubai',
    'Bait Al Mandi Dubai',
    'Manila Garden Restaurant Dubai',
    'Beirut Restaurant Dubai',
];

async function fetchPlaceIds() {
    for (const name of restaurants) {
        const key = process.env.GOOGLE_PLACES_API_KEY;
        const body = JSON.stringify({ textQuery: name });
        const options = {
            hostname: 'places.googleapis.com',
            path: '/v1/places:searchText',
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Goog-Api-Key': key,
                'X-Goog-FieldMask': 'places.id,places.displayName',
            },
        };

        await new Promise((resolve) => {
            const req = https.request(options, (res) => {
                let data = '';
                res.on('data', chunk => data += chunk);
                res.on('end', () => {
                    const parsed = JSON.parse(data);
                    console.log(JSON.stringify(parsed, null, 2));
                    const place = parsed.places?.[0];
                    console.log(`${name}: ${place?.id ?? 'NOT FOUND'}`);
                    resolve();
                });
            });
            req.write(body);
            req.end();
        });
    }
}

fetchPlaceIds();