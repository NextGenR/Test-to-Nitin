const fs = require('fs');
const path = require('path');

function escapeSql(str) {
  if (str === null || str === undefined) return 'NULL';
  return "'" + String(str).replace(/'/g, "''") + "'";
}

function escapeJson(obj) {
  if (obj === null || obj === undefined) return 'NULL';
  return escapeSql(JSON.stringify(obj)) + '::jsonb';
}

function convertToMonochromeSvg(svg) {
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

function run() {
  let jsonPath = path.join(__dirname, '..', 'RRB_NTPC_GRADUATE_MOCK', 'mock_test_1_v3.json');
  if (!fs.existsSync(jsonPath)) {
    jsonPath = path.join(__dirname, '..', 'RRB_NTPC_GRADUATE_MOCK', 'mock_test_1_v2.json');
  }
  if (!fs.existsSync(jsonPath)) {
    jsonPath = path.join(__dirname, '..', 'RRB_NTPC_GRADUATE_MOCK', 'mock_test_1.json');
  }
  if (!fs.existsSync(jsonPath)) {
    console.error('File not found:', jsonPath);
    return;
  }

  const rawQuestions = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));
  const testId = 'rrb_ntpc_graduate_mock_1';
  const testTitle = 'RRB NTPC (Graduate Level) CBT-1 Mock Test 01 (v3 Fresh)';
  const responseTable = 'RRB_NTPC_MOCK_1_responses';

  let sql = `-- =========================================================================\n`;
  sql += `-- TURNKEY REMOTE CLOUD DATABASE MIGRATION FOR RRB NTPC GRADUATE MOCK TEST 01 (v3 FRESH)\n`;
  sql += `-- Source: mock_test_1_v3.json (${rawQuestions.length} Questions)\n`;
  sql += `-- Schema: mock_tests entry, "${responseTable}" table, clean slate DELETE & fresh INSERT\n`;
  sql += `-- Safe, Idempotent, and Fully Compatible with PostgreSQL\n`;
  sql += `-- =========================================================================\n\n`;

  // 1. Register test in mock_tests
  sql += `-- 1. Register test in mock_tests table (Foreign key parent)\n`;
  sql += `INSERT INTO public.mock_tests (id, title, total_questions, total_time_minutes, sectional_time_minutes, has_sectional_timing)\n`;
  sql += `VALUES (\n`;
  sql += `  ${escapeSql(testId)},\n`;
  sql += `  ${escapeSql(testTitle)},\n`;
  sql += `  ${rawQuestions.length},\n`;
  sql += `  90,\n`;
  sql += `  0,\n`;
  sql += `  false\n`;
  sql += `)\n`;
  sql += `ON CONFLICT (id) DO UPDATE SET\n`;
  sql += `  title = EXCLUDED.title,\n`;
  sql += `  total_questions = EXCLUDED.total_questions,\n`;
  sql += `  total_time_minutes = EXCLUDED.total_time_minutes;\n\n`;

  // Also in tests table if present
  sql += `-- Register in tests table (catalog discovery)\n`;
  sql += `DO $$\nBEGIN\n`;
  sql += `  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'tests') THEN\n`;
  sql += `    INSERT INTO public.tests (test_id, title, description, questions_count, duration_mins, response_table, is_active)\n`;
  sql += `    VALUES (\n`;
  sql += `      ${escapeSql(testId)},\n`;
  sql += `      ${escapeSql(testTitle)},\n`;
  sql += `      'Official RRB NTPC Graduate Level CBT-1 pattern: Mathematics (30 Qs), Reasoning (30 Qs), General Awareness (40 Qs). Total 100 Questions, 90 Minutes.',\n`;
  sql += `      ${rawQuestions.length}, 90, ${escapeSql(responseTable)}, true\n`;
  sql += `    )\n`;
  sql += `    ON CONFLICT (test_id) DO UPDATE SET\n`;
  sql += `      title = EXCLUDED.title,\n`;
  sql += `      description = EXCLUDED.description,\n`;
  sql += `      questions_count = EXCLUDED.questions_count,\n`;
  sql += `      duration_mins = EXCLUDED.duration_mins,\n`;
  sql += `      response_table = EXCLUDED.response_table,\n`;
  sql += `      is_active = EXCLUDED.is_active;\n`;
  sql += `  END IF;\n`;
  sql += `END $$;\n\n`;

  // 2. Create Response Table
  sql += `-- 2. Create dedicated candidate responses table: "${responseTable}"\n`;
  sql += `CREATE TABLE IF NOT EXISTS public."${responseTable}" (\n`;
  sql += `    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n`;
  sql += `    name_of_candidate VARCHAR(100) NOT NULL,\n`;
  sql += `    candidate_mobile VARCHAR(15) NOT NULL,\n`;
  sql += `    question_number INTEGER NOT NULL,\n`;
  sql += `    section VARCHAR(100) NOT NULL,\n`;
  sql += `    correct_answer VARCHAR(10) NOT NULL,\n`;
  sql += `    his_answer VARCHAR(10),\n`;
  sql += `    time_taken_by_him INTEGER DEFAULT 0,\n`;
  sql += `    is_correct BOOLEAN GENERATED ALWAYS AS (correct_answer = his_answer) STORED,\n`;
  sql += `    attempt_number INTEGER DEFAULT 1,\n`;
  sql += `    try1 VARCHAR(10),\n`;
  sql += `    try2 VARCHAR(10),\n`;
  sql += `    try3 VARCHAR(10),\n`;
  sql += `    try4 VARCHAR(10),\n`;
  sql += `    try5 VARCHAR(10),\n`;
  sql += `    time_taken_try1 INTEGER DEFAULT 0,\n`;
  sql += `    time_taken_try2 INTEGER DEFAULT 0,\n`;
  sql += `    time_taken_try3 INTEGER DEFAULT 0,\n`;
  sql += `    submitted_at TIMESTAMPTZ DEFAULT NOW(),\n`;
  sql += `    CONSTRAINT unique_ntpc_mock1_candidate_question UNIQUE (candidate_mobile, question_number)\n`;
  sql += `);\n\n`;

  sql += `ALTER TABLE public."${responseTable}" ENABLE ROW LEVEL SECURITY;\n`;
  sql += `DROP POLICY IF EXISTS "Allow anon all on ${responseTable}" ON public."${responseTable}";\n`;
  sql += `CREATE POLICY "Allow anon all on ${responseTable}" ON public."${responseTable}" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);\n\n`;
  sql += `CREATE INDEX IF NOT EXISTS idx_ntpc_mock1_candidate ON public."${responseTable}"(candidate_mobile);\n\n`;

  // 3. Clean slate remove previous mock questions before fresh insert
  sql += `-- 3. Clean slate: Remove any prior mock 1 questions\n`;
  sql += `DELETE FROM public.questions WHERE test_id = ${escapeSql(testId)};\n\n`;

  // 4. Fresh Insert of 100 Questions from mock_test_1_v2.json
  sql += `-- 4. Fresh Insert of ${rawQuestions.length} Questions for ${testTitle} (${testId})\n\n`;

  for (const q of rawQuestions) {
    const qNum = q.question_number;
    const partNum = q.part_number || (qNum <= 30 ? 1 : qNum <= 60 ? 2 : 3);
    const sectionName = q.section_name || `PART-${partNum}`;
    const sectionTitle = q.section_title || (qNum <= 30 ? 'Mathematics' : qNum <= 60 ? 'General Intelligence & Reasoning' : 'General Awareness');
    const chapterName = q.topic || q.chapter_name || null;
    const difficulty = q.difficulty || 'Moderate';
    let qText = q.question_text || '';
    let qTextHi = q.question_text_hi || qText;

    let extractedSvgEn = null;
    if (typeof qText === 'string' && qText.includes('<svg')) {
      const m = qText.match(/<svg[\s\S]*?<\/svg>/i);
      if (m) {
        extractedSvgEn = m[0];
        qText = qText.replace(/<svg[\s\S]*?<\/svg>/i, '').trim();
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

    const options = q.options || {};
    const optionsHi = q.options_hi || options;
    const correctOption = (q.correct_option || 'a').toLowerCase();
    const solutionText = q.solution_text || '';
    const solutionTextHi = q.solution_text_hi || solutionText;
    const imageSvg = convertToMonochromeSvg(q.image_svg || q.svg_content || extractedSvgEn || extractedSvgHi || null);
    const imageSvgHi = convertToMonochromeSvg(q.image_svg_hi || extractedSvgHi || imageSvg || null);
    const optionSvgs = q.option_svgs || null;

    sql += `INSERT INTO public.questions (\n`;
    sql += `  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,\n`;
    sql += `  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,\n`;
    sql += `  image_svg, image_svg_hi, option_svgs\n`;
    sql += `) VALUES (\n`;
    sql += `  ${escapeSql(testId)},\n`;
    sql += `  ${qNum},\n`;
    sql += `  ${partNum},\n`;
    sql += `  ${escapeSql(sectionName)},\n`;
    sql += `  ${escapeSql(sectionTitle)},\n`;
    sql += `  ${escapeSql(chapterName)},\n`;
    sql += `  ${escapeSql(difficulty)},\n`;
    sql += `  ${escapeSql(qText)},\n`;
    sql += `  ${escapeSql(qTextHi)},\n`;
    sql += `  ${escapeJson(options)},\n`;
    sql += `  ${escapeJson(optionsHi)},\n`;
    sql += `  ${escapeSql(correctOption)},\n`;
    sql += `  ${escapeSql(solutionText)},\n`;
    sql += `  ${escapeSql(solutionTextHi)},\n`;
    sql += `  ${escapeSql(imageSvg)},\n`;
    sql += `  ${escapeSql(imageSvgHi)},\n`;
    sql += `  ${escapeJson(optionSvgs)}\n`;
    sql += `)\n`;
    sql += `ON CONFLICT (test_id, question_number) DO UPDATE SET\n`;
    sql += `  part_number = EXCLUDED.part_number,\n`;
    sql += `  section_name = EXCLUDED.section_name,\n`;
    sql += `  section_title = EXCLUDED.section_title,\n`;
    sql += `  chapter_name = EXCLUDED.chapter_name,\n`;
    sql += `  difficulty = EXCLUDED.difficulty,\n`;
    sql += `  question_text = EXCLUDED.question_text,\n`;
    sql += `  question_text_hi = EXCLUDED.question_text_hi,\n`;
    sql += `  options = EXCLUDED.options,\n`;
    sql += `  options_hi = EXCLUDED.options_hi,\n`;
    sql += `  correct_option = EXCLUDED.correct_option,\n`;
    sql += `  solution_text = EXCLUDED.solution_text,\n`;
    sql += `  solution_text_hi = EXCLUDED.solution_text_hi,\n`;
    sql += `  image_svg = EXCLUDED.image_svg,\n`;
    sql += `  image_svg_hi = EXCLUDED.image_svg_hi,\n`;
    sql += `  option_svgs = EXCLUDED.option_svgs;\n\n`;
  }

  const outPath = path.join(__dirname, '..', 'src', 'sql', 'migrate_ntpc_mock_1_v3.sql');
  fs.writeFileSync(outPath, sql, 'utf8');

  console.log(`Successfully generated fresh turnkey SQL migration:`);
  console.log(`  ${outPath} (${rawQuestions.length} questions)`);
}

run();
