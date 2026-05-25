const { GoogleGenerativeAI } = require('@google/generative-ai');
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

const FALLBACK = [
  { type: 'food', title: 'Explore Local Cuisine', subtitle: 'Discover restaurants popular with expats in your area.', ctaLabel: 'Explore', referenceId: '' },
  { type: 'service', title: 'Book a Home Cleaner', subtitle: 'Keep your space fresh with a trusted local cleaner.', ctaLabel: 'Book Now', referenceId: '' },
  { type: 'tip', title: 'Friday Brunch Culture', subtitle: 'Friday brunch is the social anchor for expats across UAE.', ctaLabel: 'Read More', referenceId: '' },
];

async function getRecommendations({ nationality, city, neighbourhood, interests }) {
  try {
    const model = genAI.getGenerativeModel({ model: 'gemini-2.0-flash' });
    const prompt = `You are a local concierge for expats in ${city}, UAE.
User is from ${nationality}, lives in ${neighbourhood || city}, interested in: ${(interests || []).join(', ') || 'general lifestyle'}.
Return ONLY a raw JSON array with exactly 3 objects. No markdown, no backticks, no preamble.
Each object must have exactly these keys: type, title, subtitle, ctaLabel, referenceId.
Valid type: "food" | "service" | "tip". Valid ctaLabel: "Explore" | "Book Now" | "Read More".`;
    const result = await model.generateContent(prompt);
    const parsed = JSON.parse(result.response.text().trim());
    if (!Array.isArray(parsed) || parsed.length !== 3) throw new Error('Bad shape');
    return parsed;
  } catch (err) {
    console.error('Gemini error, using fallback:', err.message);
    return FALLBACK;
  }
}

module.exports = { getRecommendations, FALLBACK };
