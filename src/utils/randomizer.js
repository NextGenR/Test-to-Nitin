/**
 * Option Randomizer Utility for RRB CBT Exam
 * Shuffles answer options deterministically per candidate exam attempt,
 * keeping bilingual translations in sync and accurately updating correct_option.
 */

function createSeededRNG(seedStr) {
  let h = 1779033703 ^ (seedStr ? seedStr.length : 0);
  const s = String(seedStr || 'default_seed');
  for (let i = 0; i < s.length; i++) {
    h = Math.imul(h ^ s.charCodeAt(i), 3432918353);
    h = (h << 13) | (h >>> 19);
  }
  return function() {
    h = Math.imul(h ^ (h >>> 16), 2246822507);
    h = Math.imul(h ^ (h >>> 13), 3266489909);
    return ((h ^= h >>> 16) >>> 0) / 4294967296;
  };
}

/**
 * Randomize answer options for an array of questions.
 * @param {Array} questions - Array of parsed question objects
 * @param {string} seedKey - Unique seed for candidate session (e.g. mobile_mock_attempt)
 * @returns {Array} - Array of questions with randomized options and updated correct_option
 */
export function randomizeQuestionsOptions(questions, seedKey = '') {
  if (!questions || !Array.isArray(questions)) return [];

  return questions.map((q, qIndex) => {
    const qNum = q.id || q.question_number || qIndex + 1;
    const qSeed = `${seedKey}_q_${qNum}`;
    const rng = createSeededRNG(qSeed);

    const optsEn = Array.isArray(q.options_en) ? [...q.options_en] : [];
    const optsHi = Array.isArray(q.options_hi) ? [...q.options_hi] : [];

    if (optsEn.length < 2) {
      return { ...q };
    }

    // Original correct index: 'A' -> 0, 'B' -> 1, 'C' -> 2, 'D' -> 3
    const origLetter = (q.correct_option || 'A').toUpperCase();
    const origIdx = Math.max(0, origLetter.charCodeAt(0) - 65);

    // Shuffle permutation indices: [0, 1, 2, 3]
    const indices = optsEn.map((_, i) => i);
    for (let i = indices.length - 1; i > 0; i--) {
      const j = Math.floor(rng() * (i + 1));
      const temp = indices[i];
      indices[i] = indices[j];
      indices[j] = temp;
    }

    // Reorder both English and Hindi options according to the shuffled permutation
    const newOptsEn = indices.map(idx => optsEn[idx]);
    const newOptsHi = indices.map(idx => (optsHi[idx] !== undefined ? optsHi[idx] : optsEn[idx]));

    // Find where the original correct answer moved
    const newCorrectIdx = indices.indexOf(origIdx);
    const newCorrectLetter = String.fromCharCode(65 + (newCorrectIdx >= 0 ? newCorrectIdx : 0));

    return {
      ...q,
      options_en: newOptsEn,
      options_hi: newOptsHi,
      correct_option: newCorrectLetter,
      original_correct_option: origLetter
    };
  });
}

