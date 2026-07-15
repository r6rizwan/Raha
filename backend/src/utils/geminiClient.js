const { GoogleGenerativeAI } = require('@google/generative-ai');
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

const FALLBACK_EN = [
  { type: 'food', title: 'Explore Local Cuisine', subtitle: 'Discover restaurants popular with expats in your area.', ctaLabel: 'Explore', referenceId: '' },
  { type: 'service', title: 'Book a Home Cleaner', subtitle: 'Keep your space fresh with a trusted local cleaner.', ctaLabel: 'Book Now', referenceId: '' },
  { type: 'tip', title: 'Friday Brunch Culture', subtitle: 'Friday brunch is the social anchor for expats across UAE.', ctaLabel: 'Read More', referenceId: '' },
];

const FALLBACK_AR = [
  { type: 'food', title: 'استكشف المأكولات المحلية', subtitle: 'اكتشف المطاعم الشهيرة بين المغتربين في منطقتك.', ctaLabel: 'Explore', referenceId: '' },
  { type: 'service', title: 'احجز خدمة تنظيف المنزل', subtitle: 'حافظ على نظافة مساحتك مع منظف محلي موثوق.', ctaLabel: 'Book Now', referenceId: '' },
  { type: 'tip', title: 'ثقافة غداء يوم الجمعة', subtitle: 'غداء يوم الجمعة هو المحور الاجتماعي للمغتربين في الإمارات.', ctaLabel: 'Read More', referenceId: '' },
];

async function getRecommendations({ nationality, city, neighbourhood, interests, lang = 'en' }) {
  const isArabic = lang === 'ar';
  const fallback = isArabic ? FALLBACK_AR : FALLBACK_EN;

  try {
    const model = genAI.getGenerativeModel({ model: 'gemini-2.0-flash' });
    const prompt = `You are a local concierge for expats in ${city}, UAE.
User is from ${nationality}, lives in ${neighbourhood || city}, interested in: ${(interests || []).join(', ') || 'general lifestyle'}.

You must return the response in ${isArabic ? 'Arabic (العربية)' : 'English'}.
${isArabic ? 'Translate all text values (title, subtitle) to natural, polite Arabic suitable for UAE expats.' : ''}

Return ONLY a raw JSON array with exactly 3 objects. No markdown, no backticks, no preamble.
Each object must have exactly these keys: type, title, subtitle, ctaLabel, referenceId.
Valid type: "food" | "service" | "tip".
Valid ctaLabel MUST be exactly: "Explore" | "Book Now" | "Read More" (do not translate ctaLabel, keep it in English as specified).`;

    const result = await model.generateContent(prompt);
    const parsed = JSON.parse(result.response.text().trim());
    if (!Array.isArray(parsed) || parsed.length !== 3) throw new Error('Bad shape');
    return parsed;
  } catch (err) {
    console.error('Gemini error, using fallback:', err.message);
    return fallback;
  }
}

module.exports = { getRecommendations, FALLBACK_EN, FALLBACK_AR };
