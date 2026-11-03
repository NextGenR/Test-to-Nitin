export const GROUP_D_SECTIONS = [
  { id: 'science', nameEn: 'General Science', nameHi: 'सामान्य विज्ञान', total: 25, startIndex: 0, endIndex: 24 },
  { id: 'math', nameEn: 'Mathematics', nameHi: 'गणित', total: 25, startIndex: 25, endIndex: 49 },
  { id: 'reasoning', nameEn: 'General Intelligence & Reasoning', nameHi: 'सामान्य बुद्धिमत्ता एवं तर्कशक्ति', total: 30, startIndex: 50, endIndex: 79 },
  { id: 'ga', nameEn: 'General Awareness', nameHi: 'सामान्य जागरूकता', total: 20, startIndex: 80, endIndex: 99 }
];

export const NTPC_GRADUATE_SECTIONS = [
  { id: 'math', nameEn: 'Mathematics', nameHi: 'गणित', total: 30, startIndex: 0, endIndex: 29 },
  { id: 'reasoning', nameEn: 'General Intelligence & Reasoning', nameHi: 'सामान्य बुद्धिमत्ता एवं तर्कशक्ति', total: 30, startIndex: 30, endIndex: 59 },
  { id: 'ga', nameEn: 'General Awareness', nameHi: 'सामान्य जागरूकता', total: 40, startIndex: 60, endIndex: 99 }
];

// Backwards compatibility default
export const SECTIONS = GROUP_D_SECTIONS;

/**
 * Returns dynamic section structure based on the active test ID or type
 */
export function getTestSections(testId = '') {
  if (testId && String(testId).toLowerCase().includes('ntpc')) {
    return NTPC_GRADUATE_SECTIONS;
  }
  return GROUP_D_SECTIONS;
}

export const MOCK_TESTS_DATA = {
  1: [],
  2: [],
  3: []
};

export const MOCK_QUESTIONS = [];
