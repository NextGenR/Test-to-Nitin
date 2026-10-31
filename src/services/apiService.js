import { API_ENDPOINT, getHeaders } from '../config/api';
import { MOCK_QUESTIONS } from '../data/mockQuestions';

const CANDIDATE_STORAGE_KEY = 'rrb_active_candidate';
const ATTEMPT_STORAGE_KEY_PREFIX = 'rrb_test_attempt_';

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
 * Saves passcode to remote database and caches session locally
 */
export const loginOrRegisterCandidate = async (name, mobile, passcode) => {
  const cleanMobile = mobile.trim();
  const cleanPasscode = passcode.trim();
  const cleanName = name.trim();

  // Primary attempt: Remote Backend Cloud DB
  try {
    const checkUrl = `${API_ENDPOINT}/candidates?mobile_number=eq.${cleanMobile}&select=*`;
    const checkRes = await fetch(checkUrl, {
      method: 'GET',
      headers: getHeaders()
    });

    if (checkRes.ok) {
      const candidates = await checkRes.json();

      if (candidates && candidates.length > 0) {
        // Returning candidate
        const existing = candidates[0];
        if (existing.passcode !== cleanPasscode) {
          return { success: false, error: 'Incorrect 4-digit passcode for this mobile number.' };
        }

        // Update last login
        fetch(`${API_ENDPOINT}/candidates?mobile_number=eq.${cleanMobile}`, {
          method: 'PATCH',
          headers: getHeaders(),
          body: JSON.stringify({ last_login_at: new Date().toISOString() })
        }).catch(() => {});

        localStorage.setItem(CANDIDATE_STORAGE_KEY, JSON.stringify(existing));
        return { success: true, candidate: existing, isNew: false };
      } else {
        // New candidate: Record in remote database
        const rollNumber = 'RRB26' + cleanMobile.slice(-4) + Math.floor(100 + Math.random() * 900);
        const newRecord = {
          name: cleanName,
          mobile_number: cleanMobile,
          passcode: cleanPasscode,
          roll_number: rollNumber,
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
          throw new Error("Remote DB table pending");
        }
      }
    } else {
      throw new Error(`Remote DB responded with status ${checkRes.status}`);
    }
  } catch (err) {
    console.warn("Operating with local candidate session backup:", err.message);
    const fallbackRoll = 'RRB26' + cleanMobile.slice(-4) + '101';
    const fallbackCandidate = {
      name: cleanName,
      mobile_number: cleanMobile,
      passcode: cleanPasscode,
      roll_number: fallbackRoll,
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

/**
 * Fetch Questions from Database (Supports existing database schema & JSON options)
 */
export const fetchTestQuestions = async (testId = 'rrb_cbt_mock_1') => {
  try {
    // Try provided testId, fallback to rrb_cbt_mock_1 or rrb-group-d-01
    const url = `${API_ENDPOINT}/questions?test_id=eq.${testId}&order=question_number.asc`;
    const res = await fetch(url, {
      method: 'GET',
      headers: getHeaders()
    });

    if (res.ok) {
      const data = await res.json();
      if (data && data.length > 0) {
        return data.map((q) => {
          // Parse options (handles both JSON object {a, b, c, d} and array)
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

          return {
            id: q.question_number || q.id,
            section: q.section_title || q.section || 'General Science',
            question_en: q.question_text || q.question_en || '',
            question_hi: q.question_text_hi || q.question_hi || q.question_text || '',
            options_en: optsEn,
            options_hi: optsHi,
            correct_option: (q.correct_option || 'A').toUpperCase(),
            positive_marks: Number(q.positive_marks || 1.0),
            negative_marks: Number(q.negative_marks || 0.33),
            explanation_en: q.solution_text || q.explanation_en || '',
            explanation_hi: q.solution_text_hi || q.explanation_hi || ''
          };
        });
      }
    }
  } catch (err) {
    console.warn("Using built-in question bank:", err.message);
  }
  return MOCK_QUESTIONS;
};

/**
 * Live sync test attempt to database and local cache
 */
export const syncTestAttempt = async (attemptData) => {
  const { candidateMobile, testId } = attemptData;
  const storageKey = `${ATTEMPT_STORAGE_KEY_PREFIX}${testId}_${candidateMobile}`;

  // Local storage cache
  try {
    localStorage.setItem(storageKey, JSON.stringify({
      ...attemptData,
      updated_at: new Date().toISOString()
    }));
  } catch (e) {
    console.error("Local sync error:", e);
  }

  // Live Sync to remote backend DB
  try {
    const payload = {
      candidate_mobile: candidateMobile,
      candidate_name: attemptData.candidateName || 'Candidate',
      test_id: testId,
      remaining_seconds: attemptData.remainingSeconds,
      current_question_index: attemptData.currentQuestionIndex,
      responses: attemptData.responses || {},
      question_states: attemptData.questionStates || {},
      status: attemptData.status || 'in_progress',
      score: attemptData.score || 0,
      correct_count: attemptData.correctCount || 0,
      incorrect_count: attemptData.incorrectCount || 0,
      unattempted_count: attemptData.unattemptedCount || 0,
      accuracy: attemptData.accuracy || 0,
      updated_at: new Date().toISOString(),
      completed_at: attemptData.status === 'completed' ? new Date().toISOString() : null
    };

    const url = `${API_ENDPOINT}/test_attempts?on_conflict=candidate_mobile,test_id`;
    await fetch(url, {
      method: 'POST',
      headers: {
        ...getHeaders(),
        "Prefer": "resolution=merge-duplicates"
      },
      body: JSON.stringify(payload)
    });
  } catch (err) {
    console.warn("Live DB sync background heartbeat notice:", err.message);
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

  // Query remote backend
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
