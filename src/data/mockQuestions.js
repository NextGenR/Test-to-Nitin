import mock1Raw from './mock1.json';
import mock2Raw from './mock2.json';
import mock3Raw from './mock3.json';

export const SECTIONS = [
  { id: 'science', nameEn: 'General Science', nameHi: 'सामान्य विज्ञान', total: 25, startIndex: 0, endIndex: 24 },
  { id: 'math', nameEn: 'Mathematics', nameHi: 'गणित', total: 25, startIndex: 25, endIndex: 49 },
  { id: 'reasoning', nameEn: 'General Intelligence & Reasoning', nameHi: 'सामान्य बुद्धिमत्ता एवं तर्कशक्ति', total: 30, startIndex: 50, endIndex: 79 },
  { id: 'ga', nameEn: 'General Awareness', nameHi: 'सामान्य जागरूकता', total: 20, startIndex: 80, endIndex: 99 }
];

const parseJsonMock = (rawList) => {
  return rawList.map((q) => {
    const optsEn = q.options
      ? [q.options.a || '', q.options.b || '', q.options.c || '', q.options.d || '']
      : [];
    const optsHi = q.options_hi
      ? [
          q.options_hi.a || optsEn[0] || '',
          q.options_hi.b || optsEn[1] || '',
          q.options_hi.c || optsEn[2] || '',
          q.options_hi.d || optsEn[3] || ''
        ]
      : optsEn;

    return {
      id: q.question_number,
      section: q.section_title || 'General Science',
      question_en: q.question_text || '',
      question_hi: q.question_text_hi || q.question_text || '',
      options_en: optsEn,
      options_hi: optsHi,
      correct_option: (q.correct_option || 'A').toUpperCase(),
      positive_marks: 1.0,
      negative_marks: 0.33,
      image_svg: q.image_svg || q.question_image_svg || null,
      image_svg_hi: q.image_svg_hi || null,
      image_url: q.image_url || q.question_image_url || null,
      image_url_hi: q.image_url_hi || null,
      option_svgs: q.option_svgs || null,
      option_images: q.option_images || null,
      explanation_en: q.solution_text || '',
      explanation_hi: q.solution_text_hi || ''
    };
  });
};

export const MOCK_TESTS_DATA = {
  1: parseJsonMock(mock1Raw),
  2: parseJsonMock(mock2Raw),
  3: parseJsonMock(mock3Raw)
};

export const MOCK_QUESTIONS = MOCK_TESTS_DATA[1];
