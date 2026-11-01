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

function run() {
  const mocks = [
    { num: 1, testId: 'rrb_cbt_mock_1', file: 'mock1.json' },
    { num: 2, testId: 'rrb_cbt_mock_2', file: 'mock2.json' },
    { num: 3, testId: 'rrb_cbt_mock_3', file: 'mock3.json' }
  ];

  let sql = `-- =========================================================================\n`;
  sql += `-- AUTOMATED MIGRATION: 300 QUESTIONS WITH INLINE SVG DIAGRAMS\n`;
  sql += `-- Compatible with Remote Cloud Database / PostgreSQL\n`;
  sql += `-- Safe & Idempotent\n`;
  sql += `-- =========================================================================\n\n`;

  sql += `-- 1. Add schema columns for vector diagrams\n`;
  sql += `ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS image_svg TEXT;\n`;
  sql += `ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS image_svg_hi TEXT;\n`;
  sql += `ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS image_url TEXT;\n`;
  sql += `ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS image_url_hi TEXT;\n`;
  sql += `ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS option_svgs JSONB;\n`;
  sql += `ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS option_images JSONB;\n\n`;

  sql += `-- 2. Ensure unique constraint on (test_id, question_number) for clean upserts\n`;
  sql += `DO $$\nBEGIN\n`;
  sql += `  IF NOT EXISTS (\n`;
  sql += `    SELECT 1 FROM pg_constraint WHERE conname = 'unique_test_question'\n`;
  sql += `  ) THEN\n`;
  sql += `    ALTER TABLE public.questions ADD CONSTRAINT unique_test_question UNIQUE (test_id, question_number);\n`;
  sql += `  END IF;\n`;
  sql += `END $$;\n\n`;

  sql += `-- 3. Enable RLS and public access\n`;
  sql += `ALTER TABLE IF EXISTS public.questions ENABLE ROW LEVEL SECURITY;\n`;
  sql += `DROP POLICY IF EXISTS "Allow anon read on questions" ON public.questions;\n`;
  sql += `CREATE POLICY "Allow anon read on questions" ON public.questions FOR SELECT TO anon, authenticated USING (true);\n`;
  sql += `DROP POLICY IF EXISTS "Allow anon all on questions" ON public.questions;\n`;
  sql += `CREATE POLICY "Allow anon all on questions" ON public.questions FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);\n\n`;

  sql += `-- 4. Upsert 300 Questions with Diagrams\n`;

  let totalQuestions = 0;
  for (const mock of mocks) {
    const filePath = path.join(__dirname, '..', 'src', 'data', mock.file);
    const questions = JSON.parse(fs.readFileSync(filePath, 'utf8'));

    sql += `-- -------------------------------------------------------------------------\n`;
    sql += `-- ${mock.testId} (${questions.length} questions)\n`;
    sql += `-- -------------------------------------------------------------------------\n\n`;

    for (const q of questions) {
      totalQuestions++;
      const qNum = q.question_number;
      const partNum = q.part_number || (qNum <= 25 ? 1 : qNum <= 50 ? 2 : qNum <= 80 ? 3 : 4);
      const secName = q.section_name || `PART-${partNum}`;
      const secTitle = q.section_title || (partNum === 1 ? 'General Science' : partNum === 2 ? 'Mathematics' : partNum === 3 ? 'General Intelligence & Reasoning' : 'General Awareness');
      const diff = q.difficulty || 'Moderate';
      const chName = q.chapter_name || '';

      const qText = q.question_text || '';
      const qTextHi = q.question_text_hi || qText;
      const opts = q.options || {};
      const optsHi = q.options_hi || opts;
      const corrOpt = (q.correct_option || 'a').toLowerCase();
      const sol = q.solution_text || '';
      const solHi = q.solution_text_hi || sol;

      // Note: General Science questions (Part 1, 1-25) have no diagrams
      const isSci = partNum === 1 || secTitle === 'General Science' || qNum <= 25;
      const imgSvg = isSci ? null : (q.image_svg || null);
      const imgSvgHi = isSci ? null : (q.image_svg_hi || null);
      const optSvgs = isSci ? null : (q.option_svgs || null);

      sql += `INSERT INTO public.questions (\n`;
      sql += `  test_id, question_number, part_number, section_name, section_title,\n`;
      sql += `  chapter_name, difficulty, question_text, question_text_hi,\n`;
      sql += `  options, options_hi, correct_option, solution_text, solution_text_hi,\n`;
      sql += `  image_svg, image_svg_hi, option_svgs\n`;
      sql += `) VALUES (\n`;
      sql += `  ${escapeSql(mock.testId)},\n`;
      sql += `  ${qNum},\n`;
      sql += `  ${partNum},\n`;
      sql += `  ${escapeSql(secName)},\n`;
      sql += `  ${escapeSql(secTitle)},\n`;
      sql += `  ${escapeSql(chName)},\n`;
      sql += `  ${escapeSql(diff)},\n`;
      sql += `  ${escapeSql(qText)},\n`;
      sql += `  ${escapeSql(qTextHi)},\n`;
      sql += `  ${escapeJson(opts)},\n`;
      sql += `  ${escapeJson(optsHi)},\n`;
      sql += `  ${escapeSql(corrOpt)},\n`;
      sql += `  ${escapeSql(sol)},\n`;
      sql += `  ${escapeSql(solHi)},\n`;
      sql += `  ${escapeSql(imgSvg)},\n`;
      sql += `  ${escapeSql(imgSvgHi)},\n`;
      sql += `  ${escapeJson(optSvgs)}\n`;
      sql += `)\n`;
      sql += `ON CONFLICT (test_id, question_number) DO UPDATE SET\n`;
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
  }

  const outPath = path.join(__dirname, '..', 'src', 'sql', 'migrate_questions_with_svgs.sql');
  fs.writeFileSync(outPath, sql, 'utf8');
  console.log(`Successfully generated migration SQL with ${totalQuestions} questions at: ${outPath}`);
}

run();

