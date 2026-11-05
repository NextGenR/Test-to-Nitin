import { API_ENDPOINT, getHeaders } from '../config/api';
import { MOCK_TESTS_DATA, MOCK_QUESTIONS } from '../data/mockQuestions';

const CANDIDATE_STORAGE_KEY = 'rrb_active_candidate';
const ATTEMPT_STORAGE_KEY_PREFIX = 'rrb_test_attempt_';
const OFFLINE_SYNC_QUEUE_KEY = 'rrb_offline_sync_queue';

export const MOCK_TESTS_CATALOG = [
  {
    id: 1,
    testId: 'rrb_cbt_mock_1',
    category: 'rrb-group-d',
    categoryLabel: 'RRB Group D (10th Pass Level)',
    mockNumber: 1,
    title: 'RRB Group D CBT Mock Test 01',
    description: 'Based on official Railway Recruitment Board pattern with high-yield General Science and Math.',
    questionsCount: 100,
    durationMins: 90,
    responseTable: 'RRB_MOCK_1_responses'
  },
  {
    id: 2,
    testId: 'rrb_cbt_mock_2',
    category: 'rrb-group-d',
    categoryLabel: 'RRB Group D (10th Pass Level)',
    mockNumber: 2,
    title: 'RRB Group D CBT Mock Test 02',
    description: 'Comprehensive evaluation covering Physics, Chemistry, Reasoning series, and Railway GK.',
    questionsCount: 100,
    durationMins: 90,
    responseTable: 'RRB_MOCK_2_responses'
  },
  {
    id: 3,
    testId: 'rrb_cbt_mock_3',
    category: 'rrb-group-d',
    categoryLabel: 'RRB Group D (10th Pass Level)',
    mockNumber: 3,
    title: 'RRB Group D CBT Mock Test 03',
    description: 'Advanced full-length test simulation with authentic TCS iON timing and negative marking.',
    questionsCount: 100,
    durationMins: 90,
    responseTable: 'RRB_MOCK_3_responses'
  },
  {
    id: 4,
    testId: 'rrb_ntpc_graduate_mock_1',
    category: 'rrb-ntpc',
    categoryLabel: 'RRB NTPC (Graduate Level)',
    mockNumber: 1,
    title: 'RRB NTPC Graduate Level CBT-1 Mock Test 01 (v5 Multi-SVG)',
    description: 'Official CBT-1 pattern with 30 Mathematics, 30 General Intelligence & Reasoning, and 40 General Awareness. Authentic monochrome SVG vector diagrams and visual option cards.',
    questionsCount: 100,
    durationMins: 90,
    responseTable: 'RRB_NTPC_MOCK_1_responses'
  }
];

/**
 * Helper to determine the dedicated candidate responses table name
 */
export const getResponseTableName = (mockNumber = 1, testId = null) => {
  const activeId = testId || (typeof mockNumber === 'string' ? mockNumber : '');
  if (activeId && String(activeId).includes('ntpc')) {
    const m = String(activeId).match(/mock_(\d+)/);
    const n = m ? m[1] : '1';
    return `RRB_NTPC_MOCK_${n}_responses`;
  }
  const num = typeof mockNumber === 'number' ? mockNumber : (String(activeId).slice(-1) || '1');
  return `RRB_MOCK_${num}_responses`;
};

/**
 * Dynamically fetch published active tests from the cloud database
 * Falls back to default catalog if table does not exist or network unavailable
 */
export const fetchPublishedTests = async () => {
  try {
    const res = await fetchWithTimeout(`${API_ENDPOINT}/mock_tests?order=id.asc`, {
      method: 'GET',
      headers: getHeaders()
    }, 6000);

    if (res.ok) {
      const data = await res.json();
      if (data && Array.isArray(data) && data.length > 0) {
        return data.map((t) => {
          const isNtpc = String(t.id).toLowerCase().includes('ntpc');
          let mNum = 1;
          const match = String(t.id).match(/mock_(\d+)/);
          if (match) mNum = Number(match[1]);

          return {
            id: isNtpc ? 100 + mNum : mNum,
            testId: t.id,
            category: isNtpc ? 'rrb-ntpc' : 'rrb-group-d',
            categoryLabel: isNtpc ? 'RRB NTPC (Graduate Level)' : 'RRB Group D (10th Pass Level)',
            mockNumber: mNum,
            title: t.title,
            description: isNtpc
              ? 'Official CBT-1 pattern with 30 Mathematics, 30 General Intelligence & Reasoning, and 40 General Awareness.'
              : 'Based on official Railway Recruitment Board pattern with high-yield General Science and Math.',
            questionsCount: Number(t.total_questions || 100),
            durationMins: Number(t.total_time_minutes || 90),
            responseTable: isNtpc ? `RRB_NTPC_MOCK_${mNum}_responses` : `RRB_MOCK_${mNum}_responses`
          };
        });
      }
    }
  } catch (e) {
    // Graceful fallback to default catalog
  }
  return MOCK_TESTS_CATALOG;
};

/**
 * Robust fetch with timeout wrapper
 */
const fetchWithTimeout = async (url, options = {}, timeoutMs = 15000) => {
  const controller = typeof AbortController !== 'undefined' ? new AbortController() : null;
  const timeoutId = controller ? setTimeout(() => controller.abort(), timeoutMs) : null;

  try {
    const fetchOptions = controller ? { ...options, signal: controller.signal } : options;
    const response = await fetch(url, fetchOptions);
    if (timeoutId) clearTimeout(timeoutId);
    return response;
  } catch (error) {
    if (timeoutId) clearTimeout(timeoutId);
    throw error;
  }
};

/**
 * Enqueue a failed or offline request to local storage queue
 */
const enqueueOfflineSync = (url, options) => {
  try {
    const raw = localStorage.getItem(OFFLINE_SYNC_QUEUE_KEY);
    const queue = raw ? JSON.parse(raw) : [];
    queue.push({
      id: Date.now() + Math.random().toString(36).substring(2, 7),
      url,
      options,
      timestamp: new Date().toISOString()
    });
    // Cap at 250 requests
    if (queue.length > 250) queue.splice(0, queue.length - 250);
    localStorage.setItem(OFFLINE_SYNC_QUEUE_KEY, JSON.stringify(queue));
  } catch (err) {
    console.warn("Failed to buffer offline sync:", err);
  }
};

/**
 * Flush all buffered offline sync requests to the remote database
 */
export const flushOfflineSyncQueue = async () => {
  if (typeof window === 'undefined' || !navigator.onLine) return;
  try {
    const raw = localStorage.getItem(OFFLINE_SYNC_QUEUE_KEY);
    if (!raw) return;
    const queue = JSON.parse(raw);
    if (!Array.isArray(queue) || queue.length === 0) return;

    const remaining = [];
    for (const item of queue) {
      try {
        const res = await fetch(item.url, item.options);
        if (!res.ok && res.status >= 500) {
          remaining.push(item);
        }
      } catch (err) {
        remaining.push(item);
      }
    }

    if (remaining.length > 0) {
      localStorage.setItem(OFFLINE_SYNC_QUEUE_KEY, JSON.stringify(remaining));
    } else {
      localStorage.removeItem(OFFLINE_SYNC_QUEUE_KEY);
    }
  } catch (err) {
    console.warn("Error processing offline sync queue:", err);
  }
};

// Auto-trigger queue flush whenever connectivity is restored
if (typeof window !== 'undefined') {
  window.addEventListener('online', () => {
    flushOfflineSyncQueue();
  });
}

/**
 * Get cached candidate session
 */
export const getCachedCandidate = () => {
  try {
    const raw = localStorage.getItem(CANDIDATE_STORAGE_KEY);
    return raw ? JSON.parse(raw) : null;
  } catch (err) {
    console.error("Failed to read local cache:", err);
    return null;
  }
};

/**
 * Clear cached candidate session (Logout)
 */
export const clearCandidateSession = () => {
  try {
    localStorage.removeItem(CANDIDATE_STORAGE_KEY);
  } catch (err) {
    console.error("Failed to clear local cache:", err);
  }
};

/**
 * Login or Register Candidate
 */
export const loginOrRegisterCandidate = async (name, mobile, passcode, category = "UR") => {
  const cleanMobile = mobile.trim();
  const cleanPasscode = passcode.trim();
  const cleanName = name.trim();

  try {
    const checkUrl = `${API_ENDPOINT}/candidates?mobile_number=eq.${cleanMobile}&select=*`;
    const checkRes = await fetchWithTimeout(checkUrl, {
      method: 'GET',
      headers: getHeaders()
    });

    if (checkRes.ok) {
      const candidates = await checkRes.json();

      if (candidates && candidates.length > 0) {
        const existing = candidates[0];
        if (existing.passcode !== cleanPasscode) {
          return { success: false, error: 'Incorrect 4-digit passcode for this mobile number.' };
        }

        fetch(`${API_ENDPOINT}/candidates?mobile_number=eq.${cleanMobile}`, {
          method: 'PATCH',
          headers: getHeaders(),
          body: JSON.stringify({ last_login_at: new Date().toISOString() })
        }).catch(() => {});

        const updatedCandidate = { ...existing, category: category || existing.category || "UR" };
        localStorage.setItem(CANDIDATE_STORAGE_KEY, JSON.stringify(updatedCandidate));
        return { success: true, candidate: updatedCandidate, isNew: false };
      } else {
        const rollNumber = 'RRB26' + cleanMobile.slice(-4) + Math.floor(100 + Math.random() * 900);
        const newRecord = {
          name: cleanName,
          mobile_number: cleanMobile,
          passcode: cleanPasscode,
          roll_number: rollNumber,
          category: category || "UR",
          created_at: new Date().toISOString(),
          last_login_at: new Date().toISOString()
        };

        const createRes = await fetch(`${API_ENDPOINT}/candidates`, {
          method: 'POST',
          headers: getHeaders(),
          body: JSON.stringify(newRecord)
        });

        if (createRes.ok) {
          const created = await createRes.json();
          const candidateData = Array.isArray(created) && created[0] ? created[0] : newRecord;
          localStorage.setItem(CANDIDATE_STORAGE_KEY, JSON.stringify(candidateData));
          return { success: true, candidate: candidateData, isNew: true };
        } else {
          throw new Error("Remote DB candidate registration pending");
        }
      }
    } else {
      throw new Error(`Remote DB status ${checkRes.status}`);
    }
  } catch (err) {
    console.warn("Using local candidate session backup:", err.message);
    const fallbackRoll = 'RRB26' + cleanMobile.slice(-4) + '101';
    const fallbackCandidate = {
      name: cleanName,
      mobile_number: cleanMobile,
      passcode: cleanPasscode,
      roll_number: fallbackRoll,
      category: category || "UR",
      created_at: new Date().toISOString(),
      is_local_session: true
    };
    localStorage.setItem(CANDIDATE_STORAGE_KEY, JSON.stringify(fallbackCandidate));
    return {
      success: true,
      candidate: fallbackCandidate,
      isNew: true,
      notice: 'Connected in fast-mode. Execute the SQL script in your database to persist to the remote cloud server.'
    };
  }
};

export function convertToMonochromeSvg(svg) {
  if (!svg || typeof svg !== 'string') return svg;
  return svg
    .replace(/stroke=(\\?["'])(?!none|#000000|#000|black)[^\\"']+(\\?["'])/gi, (m, q1, q2) => `stroke=${q1}#000000${q2}`)
    .replace(/fill=(\\?["'])(#f8fafc|#f1f5f9|#e2e8f0|#e6f7f9|#f0fdf4|#eff6ff|#fafafa|#ffffff|white|#fff)(\\?["'])/gi, (m, q1, c, q2) => `fill=${q1}#ffffff${q2}`)
    .replace(/fill=(\\?["'])(?!none|#ffffff|#fff|white|#000000|#000|black)[^\\"']+(\\?["'])/gi, (m, q1, q2) => `fill=${q1}#000000${q2}`)
    .replace(/stroke:\s*(?!none|#000000|#000|black)[^;"]+/gi, 'stroke: #000000')
    .replace(/fill:\s*(?!none|#ffffff|#fff|white|#000000|#000|black)[^;"]+/gi, 'fill: #000000')
    .replace(/color:\s*(?!#000000|#000|black)[^;"]+/gi, 'color: #000000')
    .replace(/background:\s*[^;"]+/gi, 'background:#ffffff');
}

/**
 * Fetch Questions for any mock test (supports rrb_cbt_mock_X or rrb_ntpc_graduate_mock_X)
 */
export const fetchTestQuestions = async (testIdOrMock = 1) => {
  const testId = typeof testIdOrMock === 'string' && testIdOrMock.startsWith('rrb_')
    ? testIdOrMock
    : `rrb_cbt_mock_${testIdOrMock}`;

  try {
    const url = `${API_ENDPOINT}/questions?test_id=eq.${testId}&order=question_number.asc`;
    const res = await fetchWithTimeout(url, {
      method: 'GET',
      headers: getHeaders()
    });

    if (res.ok) {
      const data = await res.json();
      if (data && data.length > 0) {
        const isNtpc = testId.includes('ntpc');
        return data.map((q) => {
          const qNum = Number(q.question_number || q.id);
          let optsEn = [];
          if (q.options) {
            if (Array.isArray(q.options)) {
              optsEn = q.options;
            } else {
              optsEn = [q.options.a || '', q.options.b || '', q.options.c || '', q.options.d || ''];
            }
          } else {
            optsEn = [q.option_a_en || '', q.option_b_en || '', q.option_c_en || '', q.option_d_en || ''];
          }

          let optsHi = [];
          if (q.options_hi) {
            if (Array.isArray(q.options_hi)) {
              optsHi = q.options_hi;
            } else {
              optsHi = [
                q.options_hi.a || optsEn[0],
                q.options_hi.b || optsEn[1],
                q.options_hi.c || optsEn[2],
                q.options_hi.d || optsEn[3]
              ];
            }
          } else {
            optsHi = [
              q.option_a_hi || optsEn[0],
              q.option_b_hi || optsEn[1],
              q.option_c_hi || optsEn[2],
              q.option_d_hi || optsEn[3]
            ];
          }

          const isScience = !isNtpc && ((q.part_number === 1) || (q.section_title === 'General Science') || (qNum <= 25));

          let fallbackSection = 'General Science';
          if (isNtpc) {
            fallbackSection = qNum <= 30 ? 'Mathematics' : qNum <= 60 ? 'General Intelligence & Reasoning' : 'General Awareness';
          } else {
            fallbackSection = qNum <= 25 ? 'General Science' : qNum <= 50 ? 'Mathematics' : qNum <= 80 ? 'General Intelligence & Reasoning' : 'General Awareness';
          }

          let qTextEn = q.question_text || q.question_en || '';
          let qTextHi = q.question_text_hi || q.question_hi || qTextEn;

          let extractedSvgEn = null;
          if (typeof qTextEn === 'string' && qTextEn.includes('<svg')) {
            const m = qTextEn.match(/<svg[\s\S]*?<\/svg>/i);
            if (m) {
              extractedSvgEn = m[0];
              qTextEn = qTextEn.replace(/<svg[\s\S]*?<\/svg>/i, '').trim();
            }
          }

          let extractedSvgHi = null;
          if (typeof qTextHi === 'string' && qTextHi.includes('<svg')) {
            const m = qTextHi.match(/<svg[\s\S]*?<\/svg>/i);
            if (m) {
              extractedSvgHi = m[0];
              qTextHi = qTextHi.replace(/<svg[\s\S]*?<\/svg>/i, '').trim();
            }
          }

          const rawSvg = q.image_svg || q.question_image_svg || q.svg_content || extractedSvgEn || extractedSvgHi || null;
          const rawSvgHi = q.image_svg_hi || extractedSvgHi || rawSvg || null;
          const baseSvg = convertToMonochromeSvg(rawSvg);
          const baseSvgHi = convertToMonochromeSvg(rawSvgHi);

          let baseOptionSvgs = null;
          if (q.option_svgs && typeof q.option_svgs === 'object') {
            baseOptionSvgs = {};
            for (const [key, val] of Object.entries(q.option_svgs)) {
              baseOptionSvgs[key] = convertToMonochromeSvg(val);
            }
          }

          return {
            id: qNum,
            section: q.section_title || q.section_name || q.section || fallbackSection,
            chapter_name: q.chapter_name || q.topic || '',
            question_en: qTextEn,
            question_hi: qTextHi,
            options_en: optsEn,
            options_hi: optsHi,
            correct_option: (q.correct_option || 'A').toUpperCase(),
            positive_marks: Number(q.positive_marks || 1.0),
            negative_marks: Number(q.negative_marks || 0.33),
            image_svg: isScience ? null : baseSvg,
            image_svg_hi: isScience ? null : baseSvgHi,
            image_url: isScience ? null : (q.image_url || q.question_image_url || null),
            image_url_hi: isScience ? null : (q.image_url_hi || null),
            option_svgs: isScience ? null : (baseOptionSvgs || q.option_svgs || null),
            option_images: isScience ? null : (q.option_images || null),
            explanation_en: q.solution_text || q.explanation_en || '',
            explanation_hi: q.solution_text_hi || q.explanation_hi || ''
          };
        });
      }
    }
  } catch (err) {
    console.warn(`Database questions fetch for ${testId} notice:`, err.message);
  }

  return [];
};

/**
 * Detect current attempt number for candidate on given mock test
 */
export const getCandidateAttemptNumber = async (mockNumber = 1, candidateMobile, testId = null) => {
  if (!candidateMobile) return 1;
  const tableName = getResponseTableName(mockNumber, testId);

  try {
    const checkUrl = `${API_ENDPOINT}/${tableName}?candidate_mobile=eq.${candidateMobile}&select=attempt_number,try1,try2,try3,try4,try5&order=attempt_number.desc&limit=1`;
    const res = await fetch(checkUrl, {
      method: 'GET',
      headers: getHeaders()
    });

    if (res.ok) {
      const rows = await res.json();
      if (rows && rows.length > 0) {
        const row = rows[0];
        let maxAttempt = row.attempt_number || 1;
        if (row.try5 !== null && row.try5 !== undefined) maxAttempt = Math.max(maxAttempt, 5);
        else if (row.try4 !== null && row.try4 !== undefined) maxAttempt = Math.max(maxAttempt, 4);
        else if (row.try3 !== null && row.try3 !== undefined) maxAttempt = Math.max(maxAttempt, 3);
        else if (row.try2 !== null && row.try2 !== undefined) maxAttempt = Math.max(maxAttempt, 2);
        else if (row.try1 !== null && row.try1 !== undefined) maxAttempt = Math.max(maxAttempt, 1);
        return maxAttempt;
      }
    }
  } catch (err) {
    console.warn("Could not determine attempt number:", err);
  }
  return 1;
};

/**
 * Real-time sync for a single question response.
 * Called immediately when candidate clicks "Save & Next", "Save & Mark for Review", or "Clear Response".
 * Writes directly to the candidate's active attempt column (try1, try2, try3...) and his_answer in dedicated response table.
 */
export const saveSingleQuestionResponse = async ({
  mockNumber = 1,
  testId = null,
  candidateName,
  candidateMobile,
  questionNumber,
  section,
  correctAnswer,
  hisAnswer, // 'A', 'B', 'C', 'D' or null
  timeTaken = 0,
  attemptNumber = 1
}) => {
  if (!candidateMobile || !questionNumber) return;
  const tableName = getResponseTableName(mockNumber, testId);
  const tryCol = `try${attemptNumber}`;
  const timeCol = `time_taken_try${Math.min(attemptNumber, 3)}`;

  // Notice: We do NOT insert 'is_correct' because it is a generated stored column in PostgreSQL
  const payload = {
    name_of_candidate: candidateName || 'Candidate',
    candidate_mobile: candidateMobile,
    question_number: questionNumber,
    section: section || 'General Section',
    correct_answer: correctAnswer || '',
    his_answer: hisAnswer || null,
    time_taken_by_him: timeTaken,
    attempt_number: attemptNumber,
    [tryCol]: hisAnswer || null,
    [timeCol]: timeTaken
  };

  const url = `${API_ENDPOINT}/${tableName}?on_conflict=candidate_mobile,question_number`;
  const options = {
    method: 'POST',
    headers: {
      ...getHeaders(),
      "Prefer": "resolution=merge-duplicates"
    },
    body: JSON.stringify([payload])
  };

  try {
    if (typeof navigator !== 'undefined' && !navigator.onLine) {
      enqueueOfflineSync(url, options);
      return;
    }
    const res = await fetch(url, options);
    if (!res.ok && res.status >= 500) {
      enqueueOfflineSync(url, options);
    } else {
      flushOfflineSyncQueue();
    }
  } catch (err) {
    enqueueOfflineSync(url, options);
    console.warn(`Real-time question sync notice (Q${questionNumber}):`, err.message);
  }
};

/**
 * Save candidate responses to dedicated table: RRB_MOCK_X_responses or RRB_NTPC_MOCK_X_responses
 * Supports Retakes: saves answers into try1, try2, try3, try4, try5 columns!
 */
export const saveMockResponses = async ({
  mockNumber = 1,
  testId = null,
  candidateName,
  candidateMobile,
  questions,
  responses,
  timeSpentMap = {},
  attemptNumber = 1
}) => {
  if (!candidateMobile || !questions || questions.length === 0) return;
  const tableName = getResponseTableName(mockNumber, testId);

  let nextAttemptNum = attemptNumber || 1;
  const existingMap = {};

  try {
    const checkUrl = `${API_ENDPOINT}/${tableName}?candidate_mobile=eq.${candidateMobile}&select=question_number,attempt_number,try1,try2,try3,try4,try5`;
    const checkRes = await fetch(checkUrl, {
      method: 'GET',
      headers: getHeaders()
    });

    if (checkRes.ok) {
      const records = await checkRes.json();
      if (records && records.length > 0) {
        records.forEach((r) => {
          existingMap[r.question_number] = r;
        });

        if (!attemptNumber || attemptNumber === 1) {
          // If caller didn't specify attemptNumber > 1, determine from DB records
          let maxTry = 1;
          for (const r of records) {
            if (r.try5 !== null && r.try5 !== undefined) maxTry = Math.max(maxTry, 5);
            else if (r.try4 !== null && r.try4 !== undefined) maxTry = Math.max(maxTry, 4);
            else if (r.try3 !== null && r.try3 !== undefined) maxTry = Math.max(maxTry, 3);
            else if (r.try2 !== null && r.try2 !== undefined) maxTry = Math.max(maxTry, 2);
            else if (r.try1 !== null && r.try1 !== undefined) maxTry = Math.max(maxTry, 1);
            if (r.attempt_number) maxTry = Math.max(maxTry, r.attempt_number);
          }
          nextAttemptNum = maxTry;
        }
      }
    }
  } catch (e) {
    console.warn("Could not query prior attempts, defaulting to try 1:", e);
  }

  const tryCol = `try${nextAttemptNum}`;
  const timeCol = `time_taken_try${Math.min(nextAttemptNum, 3)}`;

  const rows = questions.map((q, idx) => {
    const qNum = idx + 1;
    const userOptIdx = responses[idx];
    const hisAnswer = userOptIdx !== undefined && userOptIdx !== null ? String.fromCharCode(65 + userOptIdx) : null;
    const timeTaken = timeSpentMap[idx] || 0;
    const existing = existingMap[qNum] || {};

    const payload = {
      name_of_candidate: candidateName || 'Candidate',
      candidate_mobile: candidateMobile || 'N/A',
      question_number: qNum,
      section: q.section,
      correct_answer: q.correct_option,
      his_answer: hisAnswer,
      time_taken_by_him: timeTaken,
      attempt_number: nextAttemptNum,
      [tryCol]: hisAnswer,
      [timeCol]: timeTaken
    };

    // Preserve earlier attempt answers
    if (existing.try1) payload.try1 = existing.try1;
    if (existing.try2 && nextAttemptNum > 2) payload.try2 = existing.try2;
    if (existing.try3 && nextAttemptNum > 3) payload.try3 = existing.try3;
    if (existing.try4 && nextAttemptNum > 4) payload.try4 = existing.try4;
    if (nextAttemptNum === 1) payload.try1 = hisAnswer;

    return payload;
  });

  try {
    const url = `${API_ENDPOINT}/${tableName}?on_conflict=candidate_mobile,question_number`;
    await fetch(url, {
      method: 'POST',
      headers: {
        ...getHeaders(),
        "Prefer": "resolution=merge-duplicates"
      },
      body: JSON.stringify(rows)
    });
    console.log(`Successfully recorded attempt ${nextAttemptNum} into column ${tryCol} of ${tableName}`);
  } catch (err) {
    console.warn(`Notice while saving attempt ${nextAttemptNum} to ${tableName}:`, err.message);
  }
};

/**
 * Live sync test attempt to database and local cache
 * Uses resilient GET check followed by PATCH or POST to avoid ON CONFLICT constraint mismatch
 */
export const syncTestAttempt = async (attemptData) => {
  const { candidateMobile, testId } = attemptData;
  if (!candidateMobile || !testId) return;

  const storageKey = `${ATTEMPT_STORAGE_KEY_PREFIX}${testId}_${candidateMobile}`;

  try {
    localStorage.setItem(storageKey, JSON.stringify({
      ...attemptData,
      updated_at: new Date().toISOString()
    }));
  } catch (e) {
    console.error("Local sync error:", e);
  }

  try {
    const payload = {
      candidate_mobile: candidateMobile,
      candidate_name: attemptData.candidateName || 'Candidate',
      roll_number: attemptData.rollNumber || null,
      test_id: testId,
      remaining_seconds: attemptData.remainingSeconds !== undefined ? attemptData.remainingSeconds : 5400,
      current_question_index: attemptData.currentQuestionIndex || 0,
      responses: attemptData.responses || {},
      question_states: attemptData.questionStates || {},
      status: attemptData.status || 'in_progress',
      score: attemptData.score || 0,
      correct_count: attemptData.correctCount || 0,
      incorrect_count: attemptData.incorrectCount || 0,
      unattempted_count: attemptData.unattemptedCount || 0,
      accuracy: attemptData.accuracy || 0,
      updated_at: new Date().toISOString(),
      submitted_at: attemptData.status === 'completed' ? new Date().toISOString() : null
    };

    // If offline, enqueue update to push when back online
    if (typeof navigator !== 'undefined' && !navigator.onLine) {
      enqueueOfflineSync(`${API_ENDPOINT}/test_attempts?candidate_mobile=eq.${candidateMobile}&test_id=eq.${testId}`, {
        method: 'POST',
        headers: getHeaders(),
        body: JSON.stringify(payload)
      });
      return;
    }

    // First check if a record for this candidate and test already exists
    const checkUrl = `${API_ENDPOINT}/test_attempts?candidate_mobile=eq.${candidateMobile}&test_id=eq.${testId}&select=id`;
    const checkRes = await fetch(checkUrl, {
      method: 'GET',
      headers: getHeaders()
    });

    if (checkRes.ok) {
      const records = await checkRes.json();
      if (records && records.length > 0) {
        // Record exists -> PATCH
        const targetId = records[0].id;
        await fetch(`${API_ENDPOINT}/test_attempts?id=eq.${targetId}`, {
          method: 'PATCH',
          headers: getHeaders(),
          body: JSON.stringify(payload)
        });
        return;
      }
    }

    // Record does not exist -> POST
    await fetch(`${API_ENDPOINT}/test_attempts`, {
      method: 'POST',
      headers: getHeaders(),
      body: JSON.stringify(payload)
    });
  } catch (err) {
    console.warn("Live DB sync heartbeat buffered locally:", err.message);
  }
};

/**
 * Load test attempt state for resuming
 */
export const getTestAttempt = async (candidateMobile, testId = 'rrb_cbt_mock_1') => {
  const storageKey = `${ATTEMPT_STORAGE_KEY_PREFIX}${testId}_${candidateMobile}`;
  let localData = null;
  try {
    const raw = localStorage.getItem(storageKey);
    if (raw) localData = JSON.parse(raw);
  } catch (e) {}

  try {
    const url = `${API_ENDPOINT}/test_attempts?candidate_mobile=eq.${candidateMobile}&test_id=eq.${testId}&select=*`;
    const res = await fetch(url, {
      method: 'GET',
      headers: getHeaders()
    });

    if (res.ok) {
      const records = await res.json();
      if (records && records.length > 0) {
        const record = records[0];
        return {
          candidateMobile: record.candidate_mobile,
          candidateName: record.candidate_name,
          testId: record.test_id,
          remainingSeconds: record.remaining_seconds,
          currentQuestionIndex: record.current_question_index,
          responses: record.responses || {},
          questionStates: record.question_states || {},
          status: record.status,
          score: record.score,
          correctCount: record.correct_count,
          incorrectCount: record.incorrect_count,
          unattemptedCount: record.unattempted_count,
          accuracy: record.accuracy
        };
      }
    }
  } catch (err) {
    console.warn("Could not fetch remote attempt, using local state:", err.message);
  }

  return localData;
};

/**
 * Fetch leaderboard rankings for all candidates or a specific mock test
 */
export const fetchLeaderboard = async (testId = null) => {
  try {
    let url = `${API_ENDPOINT}/test_attempts?select=candidate_name,candidate_mobile,roll_number,test_id,score,accuracy,status,submitted_at,updated_at&order=score.desc,accuracy.desc&limit=50`;
    if (testId && testId !== 'all') {
      url += `&test_id=eq.${testId}`;
    }
    const res = await fetch(url, {
      method: 'GET',
      headers: getHeaders()
    });
    if (res.ok) {
      const data = await res.json();
      return data || [];
    }
  } catch (err) {
    console.warn("Could not fetch remote leaderboard:", err.message);
  }
  return [];
};


/**
 * Fetch all candidates for Admin View
 */
export const fetchAllCandidates = async () => {
  try {
    const res = await fetch(`${API_ENDPOINT}/candidates?select=*&order=created_at.desc&limit=100`, {
      method: 'GET',
      headers: getHeaders()
    });
    if (res.ok) {
      return await res.json();
    }
  } catch (e) {
    console.warn("Could not fetch candidates:", e);
  }
  return [];
};

/**
 * Fetch all test attempts for Admin View
 */
export const fetchAllAttempts = async () => {
  try {
    const res = await fetch(`${API_ENDPOINT}/test_attempts?select=*&order=updated_at.desc&limit=100`, {
      method: 'GET',
      headers: getHeaders()
    });
    if (res.ok) {
      return await res.json();
    }
  } catch (e) {
    console.warn("Could not fetch attempts:", e);
  }
  return [];
};

/**
 * Save candidate response for a single PYQ question to dedicated table:
 * public."RRB_NTPC_PYQ_responses"
 */
export const savePyqResponse = async ({
  candidateName = 'Candidate',
  candidateMobile,
  questionId,
  subject = 'General Intelligence & Reasoning',
  chapterId = '',
  chapterName = '',
  correctAnswer,
  hisAnswer,
  timeTakenSeconds = 0,
  attemptNumber = 1
}) => {
  if (!candidateMobile || !questionId) return;

  const payload = {
    name_of_candidate: candidateName || 'Candidate',
    candidate_mobile: candidateMobile,
    question_id: questionId,
    subject: subject || 'General Intelligence & Reasoning',
    chapter_id: chapterId || '',
    chapter_name: chapterName || '',
    correct_answer: (correctAnswer || '').toUpperCase(),
    his_answer: (hisAnswer || '').toUpperCase(),
    time_taken_seconds: timeTakenSeconds || 0,
    attempt_number: attemptNumber || 1
  };

  const url = `${API_ENDPOINT}/RRB_NTPC_PYQ_responses?on_conflict=candidate_mobile,question_id`;
  const options = {
    method: 'POST',
    headers: {
      ...getHeaders(),
      "Prefer": "resolution=merge-duplicates"
    },
    body: JSON.stringify([payload])
  };

  try {
    if (typeof navigator !== 'undefined' && !navigator.onLine) {
      enqueueOfflineSync(url, options);
      return;
    }
    const res = await fetch(url, options);
    if (!res.ok && res.status >= 500) {
      enqueueOfflineSync(url, options);
    } else {
      flushOfflineSyncQueue();
    }
  } catch (err) {
    enqueueOfflineSync(url, options);
    console.warn(`PYQ response sync notice (${questionId}):`, err.message);
  }
};

/**
 * Fetch candidate's PYQ attempt history from public."RRB_NTPC_PYQ_responses"
 */
export const fetchCandidatePyqResponses = async (candidateMobile) => {
  if (!candidateMobile) return {};
  try {
    const url = `${API_ENDPOINT}/RRB_NTPC_PYQ_responses?candidate_mobile=eq.${candidateMobile}&select=question_id,his_answer,correct_answer,time_taken_seconds`;
    const res = await fetch(url, {
      method: 'GET',
      headers: getHeaders()
    });
    if (res.ok) {
      const data = await res.json();
      const responseMap = {};
      if (Array.isArray(data)) {
        data.forEach(item => {
          if (item.question_id && item.his_answer) {
            responseMap[item.question_id] = item.his_answer.toLowerCase();
          }
        });
      }
      return responseMap;
    }
  } catch (err) {
    console.warn('Failed to fetch candidate PYQ responses:', err.message);
  }
  return {};
};
