-- =========================================================================
-- TURNKEY REMOTE CLOUD DATABASE MIGRATION FOR RRB NTPC GRADUATE MOCK TEST 01 (v2 FRESH)
-- Source: mock_test_1_v2.json (100 Questions)
-- Schema: mock_tests entry, "RRB_NTPC_MOCK_1_responses" table, clean slate DELETE & fresh INSERT
-- Safe, Idempotent, and Fully Compatible with PostgreSQL
-- =========================================================================

-- 1. Register test in mock_tests table (Foreign key parent)
INSERT INTO public.mock_tests (id, title, total_questions, total_time_minutes, sectional_time_minutes, has_sectional_timing)
VALUES (
  'rrb_ntpc_graduate_mock_1',
  'RRB NTPC (Graduate Level) CBT-1 Mock Test 01 (v2 Fresh)',
  100,
  90,
  0,
  false
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  total_questions = EXCLUDED.total_questions,
  total_time_minutes = EXCLUDED.total_time_minutes;

-- Register in tests table (catalog discovery)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'tests') THEN
    INSERT INTO public.tests (test_id, title, description, questions_count, duration_mins, response_table, is_active)
    VALUES (
      'rrb_ntpc_graduate_mock_1',
      'RRB NTPC (Graduate Level) CBT-1 Mock Test 01 (v2 Fresh)',
      'Official RRB NTPC Graduate Level CBT-1 pattern: Mathematics (30 Qs), Reasoning (30 Qs), General Awareness (40 Qs). Total 100 Questions, 90 Minutes.',
      100, 90, 'RRB_NTPC_MOCK_1_responses', true
    )
    ON CONFLICT (test_id) DO UPDATE SET
      title = EXCLUDED.title,
      description = EXCLUDED.description,
      questions_count = EXCLUDED.questions_count,
      duration_mins = EXCLUDED.duration_mins,
      response_table = EXCLUDED.response_table,
      is_active = EXCLUDED.is_active;
  END IF;
END $$;

-- 2. Create dedicated candidate responses table: "RRB_NTPC_MOCK_1_responses"
CREATE TABLE IF NOT EXISTS public."RRB_NTPC_MOCK_1_responses" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name_of_candidate VARCHAR(100) NOT NULL,
    candidate_mobile VARCHAR(15) NOT NULL,
    question_number INTEGER NOT NULL,
    section VARCHAR(100) NOT NULL,
    correct_answer VARCHAR(10) NOT NULL,
    his_answer VARCHAR(10),
    time_taken_by_him INTEGER DEFAULT 0,
    is_correct BOOLEAN GENERATED ALWAYS AS (correct_answer = his_answer) STORED,
    attempt_number INTEGER DEFAULT 1,
    try1 VARCHAR(10),
    try2 VARCHAR(10),
    try3 VARCHAR(10),
    try4 VARCHAR(10),
    try5 VARCHAR(10),
    time_taken_try1 INTEGER DEFAULT 0,
    time_taken_try2 INTEGER DEFAULT 0,
    time_taken_try3 INTEGER DEFAULT 0,
    submitted_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT unique_ntpc_mock1_candidate_question UNIQUE (candidate_mobile, question_number)
);

ALTER TABLE public."RRB_NTPC_MOCK_1_responses" ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon all on RRB_NTPC_MOCK_1_responses" ON public."RRB_NTPC_MOCK_1_responses";
CREATE POLICY "Allow anon all on RRB_NTPC_MOCK_1_responses" ON public."RRB_NTPC_MOCK_1_responses" FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

CREATE INDEX IF NOT EXISTS idx_ntpc_mock1_candidate ON public."RRB_NTPC_MOCK_1_responses"(candidate_mobile);

-- 3. Clean slate: Remove any prior mock 1 questions
DELETE FROM public.questions WHERE test_id = 'rrb_ntpc_graduate_mock_1';

-- 4. Fresh Insert of 100 Questions for RRB NTPC (Graduate Level) CBT-1 Mock Test 01 (v2 Fresh) (rrb_ntpc_graduate_mock_1)

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  1,
  1,
  'PART-1',
  'Mathematics',
  'Number System & Divisibility',
  'Moderate',
  'If the 6-digit number 738a6a is divisible by 11, what is the value of the digit ''a''?',
  'यदि 6-अंकीय संख्या 738a6a, 11 से पूर्णतः विभाज्य है, तो अंक ''a'' का मान क्या होगा?',
  '{"a":"3","b":"6","c":"9","d":"4"}'::jsonb,
  '{"a":"3","b":"6","c":"9","d":"4"}'::jsonb,
  'c',
  'Divisibility by 11:
Sum of odd-place digits (1st, 3rd, 5th from right): a + a + 3 = 2a + 3.
Sum of even-place digits (2nd, 4th, 6th from right): 6 + 8 + 7 = 21.
Difference = 21 - (2a + 3) = 18 - 2a.
For divisibility by 11, (18 - 2a) must be 0 or a multiple of 11.
18 - 2a = 0 => 2a = 18 => a = 9.

Correct Option: (c)',
  '11 की विभाज्यता नियम:
विषम स्थानों के अंकों का योग = a + a + 3 = 2a + 3
सम स्थानों के अंकों का योग = 6 + 8 + 7 = 21
अंतर = 21 - (2a + 3) = 18 - 2a = 0 => 2a = 18 => a = 9.

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  2,
  1,
  'PART-1',
  'Mathematics',
  'Number System (Unit Digit)',
  'Moderate',
  'What is the unit digit of the product expression (7⁹⁵ - 3⁵⁸)?',
  'व्यंजक (7⁹⁵ - 3⁵⁸) के प्रसार का इकाई अंक क्या होगा?',
  '{"a":"0","b":"4","c":"6","d":"7"}'::jsonb,
  '{"a":"0","b":"4","c":"6","d":"7"}'::jsonb,
  'b',
  'Cyclicity of powers for 7 and 3 is 4:
1. For 7⁹⁵: 95 mod 4 = 3 => Unit digit = 7³ = 343 => 3.
2. For 3⁵⁸: 58 mod 4 = 2 => Unit digit = 3² = 9.
Since (unit digit 3) < (unit digit 9), borrow 10: 13 - 9 = 4.
Therefore, the unit digit is 4.

Correct Option: (b)',
  '7 और 3 की चक्रीयता 4 होती है:
1. 7⁹⁵ के लिए: 95 ÷ 4 का शेषफल = 3 => 7³ का इकाई अंक = 3.
2. 3⁵⁸ के लिए: 58 ÷ 4 का शेषफल = 2 => 3² का इकाई अंक = 9.
घटाने पर: (13 - 9) = 4.
अतः इकाई का अंक 4 होगा।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  3,
  1,
  'PART-1',
  'Mathematics',
  'LCM & HCF',
  'Moderate',
  'The HCF and LCM of two numbers are 12 and 336 respectively. If one of the numbers is 48, what is the other number?',
  'दो संख्याओं का म.स. (HCF) और ल.स. (LCM) क्रमशः 12 और 336 हैं। यदि उनमें से एक संख्या 48 है, तो दूसरी संख्या क्या होगी?',
  '{"a":"72","b":"84","c":"96","d":"108"}'::jsonb,
  '{"a":"72","b":"84","c":"96","d":"108"}'::jsonb,
  'b',
  'Fundamental theorem: First number × Second number = HCF × LCM
48 × N₂ = 12 × 336
N₂ = (12 × 336) / 48 = 336 / 4 = 84.

Correct Option: (b)',
  'सूत्र: पहली संख्या × दूसरी संख्या = HCF × LCM
48 × N₂ = 12 × 336 => N₂ = (12 × 336) / 48 = 84.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  4,
  1,
  'PART-1',
  'Mathematics',
  'Simplification (Identities)',
  'Moderate',
  'Find the value of the algebraic fraction:
[(0.73)³ + (0.27)³] / [(0.73)² - 0.73 × 0.27 + (0.27)²]',
  'निम्नलिखित व्यंजक का मान ज्ञात कीजिए:
[(0.73)³ + (0.27)³] / [(0.73)² - 0.73 × 0.27 + (0.27)²]',
  '{"a":"0.46","b":"1.00","c":"0.54","d":"0.1971"}'::jsonb,
  '{"a":"0.46","b":"1.00","c":"0.54","d":"0.1971"}'::jsonb,
  'b',
  'Using identity: a³ + b³ = (a + b)(a² - ab + b²)
Here numerator is (a³ + b³) and denominator is (a² - ab + b²).
Fraction = a + b = 0.73 + 0.27 = 1.00.

Correct Option: (b)',
  'सर्वसमिका: a³ + b³ = (a + b)(a² - ab + b²)
मान = a + b = 0.73 + 0.27 = 1.00.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  5,
  1,
  'PART-1',
  'Mathematics',
  'Surds & Radicals',
  'Moderate',
  'Find the value of the infinite radical expression:
√(20 + √(20 + √(20 + ... ∞)))',
  'अनंत करणी व्यंजक का मान ज्ञात कीजिए:
√(20 + √(20 + √(20 + ... ∞)))',
  '{"a":"4","b":"5","c":"10","d":"20"}'::jsonb,
  '{"a":"4","b":"5","c":"10","d":"20"}'::jsonb,
  'b',
  'Let x = √(20 + x).
Squaring both sides: x² = 20 + x
x² - x - 20 = 0
(x - 5)(x + 4) = 0
Since radical values are positive, x = 5.
(Shortcut: 20 factors into consecutive integers n(n+1) = 4 × 5. With ''+'' sign, the answer is the larger factor 5).

Correct Option: (b)',
  'माना x = √(20 + x).
x² = 20 + x => x² - x - 20 = 0 => (x - 5)(x + 4) = 0 => x = 5.
(शॉर्टकट: 20 = 4 × 5; ''+'' चिन्ह होने पर बड़ा गुणनखंड 5 उत्तर होता है)।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  6,
  1,
  'PART-1',
  'Mathematics',
  'Percentages (Exam Marks)',
  'Moderate',
  'In an examination, a candidate must secure a minimum of 40% marks to pass. A student gets 178 marks and fails by 22 marks. What are the maximum aggregate marks of the exam?',
  'एक परीक्षा में उत्तीर्ण होने के लिए एक अभ्यर्थी को न्यूनतम 40% अंक प्राप्त करने होते हैं। एक छात्र 178 अंक प्राप्त करता है और 22 अंकों से अनुत्तीर्ण हो जाता है। परीक्षा के अधिकतम पूर्णांक क्या हैं?',
  '{"a":"450","b":"500","c":"550","d":"600"}'::jsonb,
  '{"a":"450","b":"500","c":"550","d":"600"}'::jsonb,
  'b',
  'Pass marks required = 178 + 22 = 200 marks.
Since pass percentage = 40%:
40% of Maximum Marks = 200
Maximum Marks = 200 × (100 / 40) = 500 marks.

Correct Option: (b)',
  'उत्तीर्ण होने के लिए आवश्यक न्यूनतम अंक = 178 + 22 = 200.
40% = 200 => पूर्णांक (100%) = 200 × (100 / 40) = 500 अंक।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  7,
  1,
  'PART-1',
  'Mathematics',
  'Profit & Loss (Dishonest Dealer)',
  'Hard',
  'A dishonest dealer professes to sell his goods at cost price, but uses a false weight of 900 grams instead of a 1 kg weight. What is his actual gain percentage?',
  'एक बेईमान व्यापारी अपनी वस्तुओं को क्रय मूल्य पर बेचने का दावा करता है, लेकिन 1 किग्रा के स्थान पर 900 ग्राम के गलत बाट का उपयोग करता है। उसका वास्तविक लाभ प्रतिशत क्या है?',
  '{"a":"10%","b":"11 1/9%","c":"12 1/2%","d":"9 1/11%"}'::jsonb,
  '{"a":"10%","b":"11 1/9%","c":"12 1/2%","d":"9 1/11%"}'::jsonb,
  'b',
  'Gain % = [Error / (True Value - Error)] × 100%
= [100 g / 900 g] × 100% = 1/9 × 100% = 11 1/9% (or 11.11%).

Correct Option: (b)',
  'लाभ % = [त्रुटि / वास्तविक दिया गया भार] × 100%
= [100 / 900] × 100% = 11 1/9% (11.11%)।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  8,
  1,
  'PART-1',
  'Mathematics',
  'Profit & Loss',
  'Moderate',
  'If the cost price of 15 articles is equal to the selling price of 12 articles, what is the profit percentage?',
  'यदि 15 वस्तुओं का क्रय मूल्य 12 वस्तुओं के विक्रय मूल्य के बराबर है, तो लाभ प्रतिशत क्या होगा?',
  '{"a":"20%","b":"25%","c":"30%","d":"16.67%"}'::jsonb,
  '{"a":"20%","b":"25%","c":"30%","d":"16.67%"}'::jsonb,
  'b',
  'Given: 15 × CP = 12 × SP
SP / CP = 15 / 12 = 5 / 4.
Profit per unit = 5 - 4 = 1.
Profit % = (Profit / CP) × 100% = (1 / 4) × 100% = 25%.

Correct Option: (b)',
  '15 CP = 12 SP => SP / CP = 5 / 4.
लाभ = 5 - 4 = 1 इकाई।
लाभ % = (1 / 4) × 100% = 25%.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  9,
  1,
  'PART-1',
  'Mathematics',
  'Profit, Loss & Discount',
  'Moderate',
  'A retailer marks his goods 40% above the cost price and allows a discount of 20% on the marked price. What is his net gain percentage?',
  'एक खुदरा विक्रेता अपने माल पर क्रय मूल्य से 40% अधिक अंकित करता है और अंकित मूल्य पर 20% की छूट देता है। उसका शुद्ध लाभ प्रतिशत क्या है?',
  '{"a":"10%","b":"12%","c":"15%","d":"20%"}'::jsonb,
  '{"a":"10%","b":"12%","c":"15%","d":"20%"}'::jsonb,
  'b',
  'Let Cost Price (CP) = 100.
Marked Price (MP) = 140.
Selling Price (SP) = MP × (1 - Discount/100) = 140 × 0.80 = 112.
Net Profit = SP - CP = 112 - 100 = 12%.
Formula: Profit % = m - d - (m × d)/100 = 40 - 20 - (40 × 20)/100 = 20 - 8 = 12%.

Correct Option: (b)',
  'माना क्रय मूल्य = 100.
अंकित मूल्य = 140.
विक्रय मूल्य = 140 × 0.80 = 112.
शुद्ध लाभ % = 112 - 100 = 12%.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  10,
  1,
  'PART-1',
  'Mathematics',
  'Simple Interest',
  'Moderate',
  'At what rate of simple interest per annum will a sum of money double itself in 8 years?',
  'साधारण ब्याज की किस वार्षिक दर पर कोई धनराशि 8 वर्ष में स्वयं की दोगुनी हो जाएगी?',
  '{"a":"10%","b":"12.5%","c":"15%","d":"11.25%"}'::jsonb,
  '{"a":"10%","b":"12.5%","c":"15%","d":"11.25%"}'::jsonb,
  'b',
  'If Principal = P and Amount = 2P, SI = P. $SI = (P \times R \times T)/100 \Rightarrow P = (P \times R \times 8)/100 \Rightarrow R = 100/8 = 12.5\%$.',
  'ब्याज SI = P। $R = (SI \times 100) / (P \times T) = (100) / 8 = 12.5\%$ वार्षिक।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  11,
  1,
  'PART-1',
  'Mathematics',
  'Simple Interest (Sum & Rate)',
  'Hard',
  'A certain sum invested at simple interest amounts to ₹756 in 2 years and to ₹873 in 3.5 years. What is the annual rate of interest?',
  'साधारण ब्याज पर निवेश की गई कोई राशि 2 वर्ष में ₹756 और 3.5 वर्ष में ₹873 हो जाती है। ब्याज की वार्षिक दर क्या है?',
  '{"a":"10%","b":"12%","c":"13%","d":"14%"}'::jsonb,
  '{"a":"10%","b":"12%","c":"13%","d":"14%"}'::jsonb,
  'c',
  'Interest in 1.5 years (3.5 - 2 years) = 873 - 756 = ₹117.
Interest for 1 year = 117 / 1.5 = ₹78.
Interest for 2 years = 78 × 2 = ₹156.
Principal P = Amount in 2 years - Interest in 2 years = 756 - 156 = ₹600.
Rate R = (SI × 100) / (P × T) = (78 × 100) / (600 × 1) = 78 / 6 = 13% per annum.

Correct Option: (c)',
  '1.5 वर्ष का ब्याज = 873 - 756 = ₹117.
1 वर्ष का ब्याज = 117 / 1.5 = ₹78.
2 वर्ष का ब्याज = ₹156.
मूलधन P = 756 - 156 = ₹600.
दर R = (78 × 100) / (600 × 1) = 13% वार्षिक।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  12,
  1,
  'PART-1',
  'Mathematics',
  'Compound Interest (CI - SI)',
  'Hard',
  'The difference between compound interest and simple interest on ₹8,000 for 2 years at 5% per annum is:',
  '₹8,000 पर 5% वार्षिक दर से 2 वर्ष के चक्रवृद्धि ब्याज और साधारण ब्याज का अंतर क्या है?',
  '{"a":"₹15","b":"₹20","c":"₹25","d":"₹30"}'::jsonb,
  '{"a":"₹15","b":"₹20","c":"₹25","d":"₹30"}'::jsonb,
  'b',
  'For 2 years: $\text{Difference} = P(R/100)^2 = 8000 \times (5/100)^2 = 8000 \times (1/400) = ₹20$.',
  '2 वर्ष का अंतर $D = P(R/100)^2 = 8000 \times (25/10000) = ₹20$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  13,
  1,
  'PART-1',
  'Mathematics',
  'Ratio & Proportion',
  'Moderate',
  '₹8,400 is divided among A, B, and C in the ratio 1/2 : 1/3 : 1/4. What is the share of B?',
  '₹8,400 को A, B और C के बीच 1/2 : 1/3 : 1/4 के अनुपात में विभाजित किया जाता है। B का हिस्सा क्या होगा?',
  '{"a":"₹2,400","b":"₹2,584","c":"₹2,800","d":"₹3,200"}'::jsonb,
  '{"a":"₹2,400","b":"₹2,584","c":"₹2,800","d":"₹3,200"}'::jsonb,
  'b',
  'Simplifying ratio by multiplying with LCM(2, 3, 4) = 12:
A : B : C = (12/2) : (12/3) : (12/4) = 6 : 4 : 3.
Total parts = 6 + 4 + 3 = 13 parts.
Share of B = (4 / 13) × ₹8,400 = 33,600 / 13 ≈ ₹2,584.6.

Correct Option: (b)',
  'अनुपात को सरल करने पर (12 से गुणा):
A : B : C = 6 : 4 : 3.
कुल अनुपात = 6 + 4 + 3 = 13.
B का हिस्सा = (4 / 13) × 8,400 ≈ ₹2,584.6.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  14,
  1,
  'PART-1',
  'Mathematics',
  'Time & Work (Efficiency)',
  'Moderate',
  'A is twice as efficient as B and together they can finish a piece of work in 18 days. In how many days can A alone complete the work?',
  'A की कार्यक्षमता B से दोगुनी है और दोनों मिलकर एक काम को 18 दिनों में पूरा कर सकते हैं। A अकेला उस काम को कितने दिनों में पूरा कर सकता है?',
  '{"a":"24 days","b":"27 days","c":"36 days","d":"54 days"}'::jsonb,
  '{"a":"24 दिन","b":"27 दिन","c":"36 दिन","d":"54 दिन"}'::jsonb,
  'b',
  'Efficiency ratio A : B = 2 : 1.
Combined efficiency = 2 + 1 = 3 units/day.
Total Work = Combined Efficiency × Total Days = 3 × 18 = 54 units.
Time taken by A alone = 54 / 2 = 27 days.

Correct Option: (b)',
  'कार्यक्षमता अनुपात: A : B = 2 : 1.
कुल कार्यक्षमता = 2 + 1 = 3 इकाई/दिन।
कुल कार्य = 3 × 18 = 54 इकाई।
A अकेले समय लेगा = 54 / 2 = 27 दिन।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  15,
  1,
  'PART-1',
  'Mathematics',
  'Time & Work (Men-Women)',
  'Hard',
  '4 men or 6 women can complete a work in 12 days. In how many days can 2 men and 3 women complete the same work?',
  '4 पुरुष या 6 महिलाएं किसी कार्य को 12 दिनों में पूरा कर सकते हैं। 2 पुरुष और 3 महिलाएं मिलकर उसी कार्य को कितने दिनों में पूरा करेंगे?',
  '{"a":"12 days","b":"10 days","c":"8 days","d":"15 days"}'::jsonb,
  '{"a":"12 दिन","b":"10 दिन","c":"8 दिन","d":"15 दिन"}'::jsonb,
  'a',
  'Equivalence: 4 Men = 6 Women -> 2 Men = 3 Women.
Target group: (2 Men + 3 Women) = (3 Women + 3 Women) = 6 Women.
Since 6 women take 12 days to complete the work, 6 women will also take 12 days.

Correct Option: (a)',
  'कार्यक्षमता: 4 पुरुष = 6 महिलाएं => 2 पुरुष = 3 महिलाएं।
पूछा गया समूह = 2 पुरुष + 3 महिलाएं = 3 महिलाएं + 3 महिलाएं = 6 महिलाएं।
चूंकि 6 महिलाएं कार्य को 12 दिनों में करती हैं, अतः 6 महिलाओं को 12 दिन ही लगेंगे।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  16,
  1,
  'PART-1',
  'Mathematics',
  'Speed, Time & Distance (Trains)',
  'Hard',
  'Two trains of lengths 150 m and 120 m are running in opposite directions on parallel tracks at speeds of 42 km/h and 30 km/h respectively. In how many seconds will they completely cross each other?',
  '150 मीटर और 120 मीटर लंबी दो रेलगाड़ियाँ समानांतर पटरियों पर विपरीत दिशाओं में क्रमशः 42 किमी/घंटा और 30 किमी/घंटा की गति से चल रही हैं। वे कितने सेकंड में एक-दूसरे को पूरी तरह पार कर लेंगी?',
  '{"a":"12 seconds","b":"13.5 seconds","c":"15 seconds","d":"16 seconds"}'::jsonb,
  '{"a":"12 सेकंड","b":"13.5 सेकंड","c":"15 सेकंड","d":"16 सेकंड"}'::jsonb,
  'b',
  'Total distance = Length of train 1 + Length of train 2 = 150 + 120 = 270 metres.
Relative speed (opposite direction) = 42 + 30 = 72 km/h.
Converting to m/s: 72 × (5 / 18) = 20 m/s.
Time taken = Total distance / Relative speed = 270 / 20 = 13.5 seconds.

Correct Option: (b)',
  'कुल दूरी = 150 + 120 = 270 मीटर।
सापेक्ष गति (विपरीत दिशा) = 42 + 30 = 72 किमी/घंटा = 72 × (5/18) = 20 मी/से।
पार करने में लगा समय = 270 / 20 = 13.5 सेकंड।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  17,
  1,
  'PART-1',
  'Mathematics',
  'Speed, Time & Distance (Relative Speed)',
  'Hard',
  'A thief is noticed by a policeman from a distance of 200 metres. The thief starts running at 10 km/h and the policeman chases him at 11 km/h. What distance will the thief have run before being overtaken?',
  'एक पुलिसकर्मी 200 मीटर की दूरी पर एक चोर को देखता है। चोर 10 किमी/घंटा की गति से भागने लगता है और पुलिसकर्मी 11 किमी/घंटा की गति से उसका पीछा करता है। पकड़े जाने से पहले चोर कितनी दूरी तय कर चुका होगा?',
  '{"a":"1.5 km","b":"2.0 km","c":"2.5 km","d":"1.8 km"}'::jsonb,
  '{"a":"1.5 किमी","b":"2.0 किमी","c":"2.5 किमी","d":"1.8 किमी"}'::jsonb,
  'b',
  'Relative speed = 11 - 10 = 1 km/h = 1 × (5 / 18) m/s.
Initial gap = 200 metres.
Time to catch = Gap / Relative speed = 200 / (5 / 18) = (200 × 18) / 5 = 720 seconds.
Distance run by thief = Speed × Time = (10 × 5 / 18) m/s × 720 s = 2000 metres = 2.0 km.

Correct Option: (b)',
  'सापेक्ष गति = 11 - 10 = 1 किमी/घंटा।
पकड़ने में लगा समय = दूरी / सापेक्ष गति = 0.2 किमी / 1 किमी/घंटा = 0.2 घंटा।
चोर द्वारा तय की गई दूरी = 10 किमी/घंटा × 0.2 घंटा = 2.0 किमी।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  18,
  1,
  'PART-1',
  'Mathematics',
  'Averages & Mixtures (Alligation)',
  'Moderate',
  'A 60-litre mixture of milk and water contains milk and water in the ratio 2 : 1. How many litres of water must be added to this mixture so that the ratio of milk to water becomes 1 : 2?',
  'दूध और पानी के 60 लीटर मिश्रण में दूध और पानी का अनुपात 2 : 1 है। इस मिश्रण में कितने लीटर पानी मिलाया जाना चाहिए ताकि दूध और पानी का अनुपात 1 : 2 हो जाए?',
  '{"a":"40 litres","b":"60 litres","c":"50 litres","d":"30 litres"}'::jsonb,
  '{"a":"40 लीटर","b":"60 लीटर","c":"50 लीटर","d":"30 लीटर"}'::jsonb,
  'b',
  'In 60 litres:
Milk = (2/3) × 60 = 40 litres.
Water = (1/3) × 60 = 20 litres.
Let x litres of water be added. The milk quantity remains 40 litres:
Milk / Water = 40 / (20 + x) = 1 / 2
20 + x = 80 => x = 60 litres.

Correct Option: (b)',
  'प्रारंभिक मात्रा: दूध = 40 लीटर, पानी = 20 लीटर।
माना x लीटर पानी मिलाया जाता है:
40 / (20 + x) = 1 / 2 => 20 + x = 80 => x = 60 लीटर।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  19,
  1,
  'PART-1',
  'Mathematics',
  'Algebra (Polynomial Identities)',
  'Hard',
  'If x + 1/x = 4, find the value of x^4 + 1/x^4.',
  'यदि x + 1/x = 4 है, तो x^4 + 1/x^4 का मान ज्ञात कीजिए।',
  '{"a":"194","b":"196","c":"192","d":"214"}'::jsonb,
  '{"a":"194","b":"196","c":"192","d":"214"}'::jsonb,
  'a',
  'Given x + 1/x = 4:
Squaring both sides:
(x + 1/x)^2 = x^2 + 1/x^2 + 2 = 16
x^2 + 1/x^2 = 16 - 2 = 14
Now squarring again:
(x^2 + 1/x^2)^2 = x^4 + 1/x^4 + 2 = 14^2 = 196
x^4 + 1/x^4 = 196 - 2 = 194.

Correct Option: (a)',
  'x + 1/x = 4
दोनों पक्षों का वर्ग करने पर: x^2 + 1/x^2 = 4^2 - 2 = 16 - 2 = 14.
पुनः वर्ग करने पर: x^4 + 1/x^4 = 14^2 - 2 = 196 - 2 = 194.

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  20,
  1,
  'PART-1',
  'Mathematics',
  'Algebra (Quadratic Roots)',
  'Hard',
  'If α and β are the roots of the quadratic equation 2x² - 7x + 3 = 0, find the value of (α/β + β/α).',
  'यदि α और β द्विघात समीकरण 2x² - 7x + 3 = 0 के मूल हैं, तो (α/β + β/α) का मान ज्ञात कीजिए।',
  '{"a":"37/6","b":"49/6","c":"43/6","d":"35/6"}'::jsonb,
  '{"a":"37/6","b":"49/6","c":"43/6","d":"35/6"}'::jsonb,
  'a',
  'For 2x² - 7x + 3 = 0:
Sum of roots: α + β = -(-7)/2 = 7/2
Product of roots: αβ = 3/2
Now, α/β + β/α = (α² + β²) / (αβ) = [(α + β)² - 2αβ] / (αβ)
Numerator = (7/2)² - 2*(3/2) = 49/4 - 3 = 49/4 - 12/4 = 37/4.
Denominator = 3/2 = 6/4.
Ratio = (37/4) / (3/2) = (37/4) * (2/3) = 37 / 6.

Correct Option: (a)',
  'α + β = 7/2, αβ = 3/2
α/β + β/α = (α² + β²) / (αβ) = [(α + β)² - 2αβ] / (αβ)
= [(7/2)² - 2(3/2)] / (3/2) = [49/4 - 3] / (3/2) = (37/4) * (2/3) = 37/6.

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  21,
  1,
  'PART-1',
  'Mathematics',
  'Algebra (Conditional Identity)',
  'Hard',
  'If a + b + c = 0, what is the value of (a²/bc + b²/ca + c²/ab)?',
  'यदि a + b + c = 0 है, तो (a²/bc + b²/ca + c²/ab) का मान क्या होगा?',
  '{"a":"0","b":"1","c":"3","d":"-3"}'::jsonb,
  '{"a":"0","b":"1","c":"3","d":"-3"}'::jsonb,
  'c',
  'Taking the common denominator abc:
a²/bc + b²/ca + c²/ab = (a³ + b³ + c³) / abc
According to the algebraic identity:
If a + b + c = 0, then a³ + b³ + c³ = 3abc.
Therefore: (3abc) / abc = 3.

Correct Option: (c)',
  'लघुत्तम समापवर्त्य (abc) लेने पर:
व्यंजक = (a³ + b³ + c³) / abc
बीजगणितीय सर्वसमिका: यदि a + b + c = 0 हो, तो a³ + b³ + c³ = 3abc होता है।
अतः मान = 3abc / abc = 3.

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  22,
  1,
  'PART-1',
  'Mathematics',
  'Trigonometry (Identities)',
  'Hard',
  'If sin θ + cos θ = √2 cos θ, what is the value of (cos θ - sin θ)?',
  'यदि sin θ + cos θ = √2 cos θ है, तो (cos θ - sin θ) का मान क्या होगा?',
  '{"a":"√2 sin θ","b":"2 sin θ","c":"√2 cos θ","d":"sin θ"}'::jsonb,
  '{"a":"√2 sin θ","b":"2 sin θ","c":"√2 cos θ","d":"sin θ"}'::jsonb,
  'a',
  'Given: sin θ + cos θ = √2 cos θ
sin θ = √2 cos θ - cos θ = (√2 - 1) cos θ
Multiplying both sides by (√2 + 1):
(√2 + 1) sin θ = (√2 + 1)(√2 - 1) cos θ = (2 - 1) cos θ = cos θ
√2 sin θ + sin θ = cos θ
cos θ - sin θ = √2 sin θ.

Correct Option: (a)',
  'sin θ = (√2 - 1) cos θ
दोनों पक्षों में (√2 + 1) से गुणा करने पर:
(√2 + 1) sin θ = cos θ => √2 sin θ + sin θ = cos θ
cos θ - sin θ = √2 sin θ.

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  23,
  1,
  'PART-1',
  'Mathematics',
  'Trigonometry (Standard Values)',
  'Moderate',
  'Evaluate the value of: [sin 30° + tan 45° - cosec 60°] / [sec 30° + cos 60° + cot 45°].',
  'मान ज्ञात कीजिए: [sin 30° + tan 45° - cosec 60°] / [sec 30° + cos 60° + cot 45°].',
  '{"a":"(43 - 24√3) / 11","b":"(43 + 24√3) / 11","c":"1","d":"√3 / 2"}'::jsonb,
  '{"a":"(43 - 24√3) / 11","b":"(43 + 24√3) / 11","c":"1","d":"√3 / 2"}'::jsonb,
  'a',
  'Standard values:
sin 30° = 1/2, tan 45° = 1, cosec 60° = 2/√3
sec 30° = 2/√3, cos 60° = 1/2, cot 45° = 1
Numerator = 1/2 + 1 - 2/√3 = 3/2 - 2/√3 = (3√3 - 4) / 2√3
Denominator = 2/√3 + 1/2 + 1 = 3/2 + 2/√3 = (3√3 + 4) / 2√3
Ratio = (3√3 - 4) / (3√3 + 4)
Rationalizing denominator with (3√3 - 4):
Numerator = (3√3 - 4)^2 = 27 + 16 - 24√3 = 43 - 24√3
Denominator = (3√3)^2 - 4^2 = 27 - 16 = 11
Result = (43 - 24√3) / 11.

Correct Option: (a)',
  'मान रखने पर:
अंश = 1/2 + 1 - 2/√3 = (3√3 - 4) / 2√3
हर = 2/√3 + 1/2 + 1 = (3√3 + 4) / 2√3
व्यंजक = (3√3 - 4) / (3√3 + 4)
हर का परिमेयकरण करने पर = (43 - 24√3) / 11.

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  24,
  1,
  'PART-1',
  'Mathematics',
  'Heights & Distances',
  'Hard',
  'A 15-metre long ladder leans against a vertical wall, reaching a window 12 metres above the ground. How far is the foot of the ladder from the base of the wall?',
  '15 मीटर लंबी एक सीढ़ी एक ऊर्ध्वाधर दीवार के सहारे टिकी है, जो जमीन से 12 मीटर ऊपर एक खिड़की तक पहुँचती है। दीवार के आधार से सीढ़ी के निचले सिरे की दूरी क्या है?',
  '{"a":"8 m","b":"9 m","c":"10 m","d":"11 m"}'::jsonb,
  '{"a":"8 मीटर","b":"9 मीटर","c":"10 मीटर","d":"11 मीटर"}'::jsonb,
  'b',
  'By Pythagoras Theorem in right-angled triangle:
Distance d = √(Hypotenuse² - Height²) = √(15² - 12²) = √(225 - 144) = √81 = 9 metres.

Correct Option: (b)',
  'पाइथागोरस प्रमेय से:
दूरी = √(कर्ण² - लंब²) = √(15² - 12²) = √(225 - 144) = √81 = 9 मीटर।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  25,
  1,
  'PART-1',
  'Mathematics',
  'Geometry (Triangles)',
  'Moderate',
  'The area of an equilateral triangle is 16√3 cm². What is the perimeter of this equilateral triangle?',
  'एक समबाहु त्रिभुज का क्षेत्रफल 16√3 सेमी² है। इस समबाहु त्रिभुज का परिमाप क्या होगा?',
  '{"a":"18 cm","b":"24 cm","c":"32 cm","d":"28 cm"}'::jsonb,
  '{"a":"18 सेमी","b":"24 सेमी","c":"32 सेमी","d":"28 सेमी"}'::jsonb,
  'b',
  'Area of equilateral triangle = (√3 / 4) × a²
(√3 / 4) × a² = 16√3
a² / 4 = 16 => a² = 64 => side a = 8 cm.
Perimeter = 3 × a = 3 × 8 = 24 cm.

Correct Option: (b)',
  'समबाहु त्रिभुज का क्षेत्रफल = (√3 / 4) × a² = 16√3
a² = 64 => भुजा a = 8 सेमी।
परिमाप = 3a = 3 × 8 = 24 सेमी।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  26,
  1,
  'PART-1',
  'Mathematics',
  'Geometry (Circles & Tangents)',
  'Hard',
  'From an external point P, a tangent PT of length 12 cm is drawn to a circle. A secant PAB intersects the circle at A and B. If PA = 8 cm, what is the length of chord AB?',
  'एक बाहरी बिंदु P से वृत्त पर 12 सेमी लंबाई की एक स्पर्श रेखा PT खींची जाती है। एक छेदक रेखा PAB वृत्त को A और B पर प्रतिच्छेद करती है। यदि PA = 8 सेमी है, तो जीवा AB की लंबाई क्या है?',
  '{"a":"10 cm","b":"18 cm","c":"12 cm","d":"8 cm"}'::jsonb,
  '{"a":"10 सेमी","b":"18 सेमी","c":"12 सेमी","d":"8 सेमी"}'::jsonb,
  'a',
  'By the Tangent-Secant Theorem:
PT^2 = PA * PB
Given: PT = 12 cm, PA = 8 cm
12^2 = 8 * PB
144 = 8 * PB
PB = 144 / 8 = 18 cm.
Since PB = PA + AB:
18 = 8 + AB
AB = 18 - 8 = 10 cm.

Correct Option: (a)',
  'स्पर्श रेखा-छेदक रेखा प्रमेय (Tangent-Secant Theorem) से:
PT^2 = PA * PB
(12)^2 = 8 * PB => 144 = 8 * PB => PB = 18 सेमी।
चूंकि PB = PA + AB => 18 = 8 + AB => AB = 10 सेमी।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  27,
  1,
  'PART-1',
  'Mathematics',
  'Mensuration 3D (Cone)',
  'Hard',
  'A right circular cone has a base radius of 7 cm and a slant height of 25 cm. What is its curved surface area? (Take π = 22/7)',
  'एक लंब वृत्तीय शंकु की आधार त्रिज्या 7 सेमी और तिर्यक ऊंचाई 25 सेमी है। इसका वक्र पृष्ठीय क्षेत्रफल क्या होगा? (π = 22/7 लें)',
  '{"a":"500 cm²","b":"550 cm²","c":"600 cm²","d":"616 cm²"}'::jsonb,
  '{"a":"500 सेमी²","b":"550 सेमी²","c":"600 सेमी²","d":"616 सेमी²"}'::jsonb,
  'b',
  'Curved surface area of a cone = π × r × l
= (22/7) × 7 × 25
= 22 × 25 = 550 cm².

Correct Option: (b)',
  'शंकु का वक्र पृष्ठीय क्षेत्रफल = π r l
= (22/7) × 7 × 25 = 22 × 25 = 550 सेमी²।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  28,
  1,
  'PART-1',
  'Mathematics',
  'Mensuration 3D (Cylinder)',
  'Hard',
  'The radius of the base of a right circular cylinder is 7 cm and its height is 15 cm. Find its total surface area. (Take π = 22/7)',
  'एक लम्ब वृत्तीय बेलन के आधार की त्रिज्या 7 सेमी और ऊंचाई 15 सेमी है। इसका कुल पृष्ठीय क्षेत्रफल ज्ञात कीजिए। (π = 22/7 लें)',
  '{"a":"968 cm²","b":"880 cm²","c":"1,056 cm²","d":"660 cm²"}'::jsonb,
  '{"a":"968 सेमी²","b":"880 सेमी²","c":"1,056 सेमी²","d":"660 सेमी²"}'::jsonb,
  'a',
  'Total Surface Area (TSA) of a cylinder = 2 * π * r * (r + h)
Given:
- r = 7 cm
- h = 15 cm
TSA = 2 * (22/7) * 7 * (7 + 15)
= 44 * 22 = 968 cm².

Correct Option: (a)',
  'बेलन का कुल पृष्ठीय क्षेत्रफल = 2πr(r + h)
= 2 * (22/7) * 7 * (7 + 15)
= 44 * 22 = 968 सेमी²।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  29,
  1,
  'PART-1',
  'Mathematics',
  'Elementary Statistics (Empirical Formula)',
  'Moderate',
  'If the mean and median of a moderately skewed distribution are 24 and 26 respectively, what is the empirical mode of the distribution?',
  'यदि किसी मध्यम विषम बंटन का माध्य (Mean) और माध्यिका (Median) क्रमशः 24 और 26 हैं, तो बंटन का बहुलक (Mode) क्या होगा?',
  '{"a":"28","b":"30","c":"32","d":"25"}'::jsonb,
  '{"a":"28","b":"30","c":"32","d":"25"}'::jsonb,
  'b',
  'Empirical relationship formula:
Mode = 3 × Median - 2 × Mean
= 3 × 26 - 2 × 24
= 78 - 48 = 30.

Correct Option: (b)',
  'अनुभवजन्य संबंध सूत्र:
बहुलक = 3 × माध्यिका - 2 × माध्य
= 3 × 26 - 2 × 24 = 78 - 48 = 30.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  30,
  1,
  'PART-1',
  'Mathematics',
  'Elementary Statistics (Mean)',
  'Moderate',
  'What is the arithmetic mean of the first 5 prime numbers?',
  'प्रथम 5 अभाज्य संख्याओं का समांतर माध्य क्या है?',
  '{"a":"5.2","b":"5.6","c":"6.0","d":"6.4"}'::jsonb,
  '{"a":"5.2","b":"5.6","c":"6.0","d":"6.4"}'::jsonb,
  'b',
  'The first 5 prime numbers are: 2, 3, 5, 7, 11.
Sum = 2 + 3 + 5 + 7 + 11 = 28.
Mean = Sum / 5 = 28 / 5 = 5.6.

Correct Option: (b)',
  'प्रथम 5 अभाज्य संख्याएँ: 2, 3, 5, 7, 11.
योग = 2 + 3 + 5 + 7 + 11 = 28.
माध्य = 28 / 5 = 5.6.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  31,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Linear Seating / Row Order',
  'Hard',
  'In a row of students, Neha is 15th from the left and Priya is 18th from the right. If they interchange their positions, Neha becomes 23rd from the left. How many total students are there in the row?',
  'विद्यार्थियों की एक पंक्ति में, नेहा बायें से 15वें और प्रिया दायें से 18वें स्थान पर है। यदि वे अपना स्थान आपस में बदल लेती हैं, तो नेहा बायें से 23वीं हो जाती है। पंक्ति में कुल कितने विद्यार्थी हैं?',
  '{"a":"39","b":"40","c":"41","d":"42"}'::jsonb,
  '{"a":"39","b":"40","c":"41","d":"42"}'::jsonb,
  'b',
  'After interchange, Neha occupies Priya''s original seat.
Therefore, that seat is:
- 23rd from the left end.
- 18th from the right end.
Total students = (Left position + Right position) - 1
= (23 + 18) - 1 = 41 - 1 = 40 students.

Correct Option: (b)',
  'स्थान परिवर्तन के बाद नेहा, प्रिया की पूर्व स्थिति पर आ जाती है।
वह स्थान बायें से 23वाँ और दायें से 18वाँ है।
कुल विद्यार्थी = 23 + 18 - 1 = 40.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  32,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Linear Seating / Position Shift',
  'Hard',
  'In a row of 30 girls, when Radhika was shifted by 4 places towards her left, she became 10th from the left end. What was her earlier position from the right end of the row?',
  '30 लड़कियों की एक पंक्ति में, जब राधिका को उसके बायें ओर 4 स्थान स्थानांतरित किया गया, तो वह बायें छोर से 10वीं हो गई। पंक्ति के दायें छोर से उसकी पूर्व स्थिति क्या थी?',
  '{"a":"16th","b":"17th","c":"18th","d":"19th"}'::jsonb,
  '{"a":"16वीं","b":"17वीं","c":"18वीं","d":"19वीं"}'::jsonb,
  'b',
  'After shifting 4 places left, position from left = 10th.
Original position from left = 10 + 4 = 14th.
Position from right end = Total - (Position from left) + 1
= 30 - 14 + 1 = 17th.

Correct Option: (b)',
  'बायें 4 स्थान खिसकने के बाद स्थिति = 10वीं।
मूल स्थिति (बायें से) = 10 + 4 = 14वीं।
दायें छोर से मूल स्थिति = 30 - 14 + 1 = 17वीं।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  33,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Linear Seating (Facing North)',
  'Hard',
  'Six persons U, V, W, X, Y, and Z are sitting in a row facing North. W is sitting between V and Y. X is sitting between U and Z. U is to the immediate left of V. Z is at the extreme right end. Who is sitting at the extreme left end?',
  'छह व्यक्ति U, V, W, X, Y, और Z उत्तर की ओर मुख करके एक पंक्ति में बैठे हैं। W, V और Y के बीच बैठा है। X, U और Z के बीच बैठा है। U, V के ठीक बायें है। Z एकदम दायें छोर पर बैठा है। एकदम बायें छोर पर कौन बैठा है?',
  '{"a":"Y","b":"V","c":"W","d":"U"}'::jsonb,
  '{"a":"Y","b":"V","c":"W","d":"U"}'::jsonb,
  'a',
  'Arrangement deduction:
- Z is at position 6 (extreme right).
- X is between U and Z => X is at position 5, U is at position 4.
- U is to the immediate left of V => V is at position 3 (wait, if facing North, left of V is U, so U is pos 3, V is pos 4).
Let''s check: Y - W - V - U - X - Z:
- W is between Y and V.
- U is to the left of X, and X is between U and Z.
- Extreme left is Y.

Correct Option: (a)',
  'बैठक व्यवस्था (बायें से दायें):
Y - W - V - U - X - Z.
अतः एकदम बायें छोर पर Y बैठा है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  34,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Circular Seating Arrangement',
  'Hard',
  'Six persons A, B, C, D, E, and F are sitting around a circular table facing the centre. B is between A and C. E is between D and F. D is to the immediate left of A. Who is sitting opposite to B?',
  'छह व्यक्ति A, B, C, D, E और F केंद्र की ओर मुख करके एक वृत्ताकार मेज के चारों ओर बैठे हैं। B, A और C के बीच में है। E, D और F के बीच में है। D, A के ठीक बायें है। B के विपरीत कौन बैठा है?',
  '{"a":"E","b":"D","c":"F","d":"C"}'::jsonb,
  '{"a":"E","b":"D","c":"F","d":"C"}'::jsonb,
  'a',
  'Placing in circular order facing centre (clockwise):
- Let A be at position 1.
- D is immediate left of A (clockwise) -> D is at position 2.
- E is between D and F -> E is at position 3, F is at position 4.
- B is between A and C -> C is at position 5, B is at position 6.
Opposite pairs in 6-person circle (pos i is opposite pos i+3):
- Position 6 (B) is opposite Position 3 (E).
Thus, E is sitting opposite to B.

Correct Option: (a)',
  'वृत्ताकार व्यवस्था (केंद्रोन्मुख):
क्रमशः स्थिति: A(1) - D(2) - E(3) - F(4) - C(5) - B(6).
6 व्यक्तियों की मेज में आमने-सामने की स्थितियां (1-4, 2-5, 3-6) होती हैं।
अतः B के विपरीत E बैठा है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  35,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Non-Verbal Reasoning (Triangle Figure Counting)',
  'Moderate',
  'How many triangles are there in the given geometric figure?
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 220" width="100%" height="auto" style="max-width:320px; display:block; margin:10px auto; background:#ffffff;">
  <rect x="60" y="20" width="180" height="180" fill="none" stroke="#000000" stroke-width="2.5"/>
  <line x1="60" y1="20" x2="240" y2="200" stroke="#000000" stroke-width="2"/>
  <line x1="60" y1="200" x2="240" y2="20" stroke="#000000" stroke-width="2"/>
  <line x1="150" y1="20" x2="150" y2="200" stroke="#000000" stroke-width="2"/>
  <line x1="60" y1="110" x2="240" y2="110" stroke="#000000" stroke-width="2"/>
  <text x="120" y="55" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">1</text>
  <text x="175" y="55" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">2</text>
  <text x="210" y="90" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">3</text>
  <text x="210" y="145" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">4</text>
  <text x="175" y="180" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">5</text>
  <text x="120" y="180" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">6</text>
  <text x="80" y="145" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">7</text>
  <text x="80" y="90" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">8</text>
</svg>',
  'दी गई ज्यामितीय आकृति में कुल कितने त्रिभुज हैं?
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 220" width="100%" height="auto" style="max-width:320px; display:block; margin:10px auto; background:#ffffff;">
  <rect x="60" y="20" width="180" height="180" fill="none" stroke="#000000" stroke-width="2.5"/>
  <line x1="60" y1="20" x2="240" y2="200" stroke="#000000" stroke-width="2"/>
  <line x1="60" y1="200" x2="240" y2="20" stroke="#000000" stroke-width="2"/>
  <line x1="150" y1="20" x2="150" y2="200" stroke="#000000" stroke-width="2"/>
  <line x1="60" y1="110" x2="240" y2="110" stroke="#000000" stroke-width="2"/>
  <text x="120" y="55" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">1</text>
  <text x="175" y="55" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">2</text>
  <text x="210" y="90" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">3</text>
  <text x="210" y="145" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">4</text>
  <text x="175" y="180" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">5</text>
  <text x="120" y="180" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">6</text>
  <text x="80" y="145" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">7</text>
  <text x="80" y="90" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">8</text>
</svg>',
  '{"a":"12","b":"16","c":"14","d":"18"}'::jsonb,
  '{"a":"12","b":"16","c":"14","d":"18"}'::jsonb,
  'b',
  'Method for counting triangles in a square with diagonals and medians:
1. Count the small individual triangles numbered around the center: 8 individual triangles (numbered 1 to 8).
2. Triangles formed by combination of 2 adjacent sectors: (1+2), (3+4), (5+6), (7+8) = 4 triangles.
3. Triangles formed along the main diagonals dividing the entire square in half: 4 large triangles.
Total number of triangles = 8 × 2 = 16 triangles.

Correct Option: (b)',
  'विकर्णों और मध्य रेखाओं द्वारा विभाजित वर्ग में त्रिभुजों की गणना का नियम:
1. केंद्र के चारों ओर बने छोटे त्रिभुजों की संख्या = 8 (1 से 8 तक)।
2. किन्हीं 2 संलग्न छोटे त्रिभुजों से बने त्रिभुज = 4।
3. मुख्य विकर्णों द्वारा बने बड़े त्रिभुज = 4।
कुल त्रिभुज = 8 × 2 = 16 त्रिभुज।

अतः सही उत्तर विकल्प (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  36,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Order & Ranking',
  'Moderate',
  'In a class of 50 students, Mahesh ranks 15th from the top and Suresh ranks 20th from the bottom. How many students are there between Mahesh and Suresh?',
  '50 विद्यार्थियों की एक कक्षा में महेश शीर्ष से 15वें और सुरेश नीचे से 20वें स्थान पर है। महेश और सुरेश के बीच कितने विद्यार्थी हैं?',
  '{"a":"14","b":"15","c":"16","d":"17"}'::jsonb,
  '{"a":"14","b":"15","c":"16","d":"17"}'::jsonb,
  'b',
  'Sum of ranks = 15 + 20 = 35.
Since (Sum of ranks) < Total students (35 < 50), there is non-overlapping order:
Number of students between = Total - (Rank from top + Rank from bottom)
= 50 - 35 = 15 students.

Correct Option: (b)',
  'दोनों सिरों से स्थानों का योग = 15 + 20 = 35.
चूँकि 35 < 50 (कुल छात्र), अतः दोनों के बीच छात्र = 50 - 35 = 15.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  37,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Comparison / Heights Puzzle',
  'Moderate',
  'Five friends A, B, C, D, and E have different heights. A is taller than B but shorter than C. D is taller than C. E is the shortest. Who is the tallest?',
  'पाँच मित्र A, B, C, D और E की ऊँचाइयाँ अलग-अलग हैं। A, B से लंबा है लेकिन C से छोटा है। D, C से लंबा है। E सबसे छोटा है। सबसे लंबा कौन है?',
  '{"a":"C","b":"D","c":"A","d":"B"}'::jsonb,
  '{"a":"C","b":"D","c":"A","d":"B"}'::jsonb,
  'b',
  'From conditions: C > A > B; D > C => D > C > A > B; E is shortest => D > C > A > B > E. The tallest is D.',
  'शर्तों के अनुसार: C > A > B; D > C => D > C > A > B; E सबसे छोटा है => D > C > A > B > E। सबसे लंबा D है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  38,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Non-Verbal Reasoning (Cube & Dice Net Folding)',
  'Moderate',
  'The given figure shows an unfolded sheet of cardboard with numbered faces. If this sheet is folded along the lines to form a cube (dice), which number will appear on the face opposite to the face with number ''2''?
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 220" width="100%" height="auto" style="max-width:380px; display:block; margin:10px auto; background:#ffffff;">
  <!-- Top Face 1 -->
  <rect x="130" y="15" width="55" height="55" fill="#f8fafc" stroke="#000000" stroke-width="2"/>
  <text x="157" y="50" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle" fill="#000000">1</text>
  <!-- Middle Strip: 4, 2, 3, 5 -->
  <rect x="75" y="70" width="55" height="55" fill="#f8fafc" stroke="#000000" stroke-width="2"/>
  <text x="102" y="105" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle" fill="#000000">4</text>
  <rect x="130" y="70" width="55" height="55" fill="#f8fafc" stroke="#000000" stroke-width="2"/>
  <text x="157" y="105" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle" fill="#000000">2</text>
  <rect x="185" y="70" width="55" height="55" fill="#f8fafc" stroke="#000000" stroke-width="2"/>
  <text x="212" y="105" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle" fill="#000000">3</text>
  <rect x="240" y="70" width="55" height="55" fill="#f8fafc" stroke="#000000" stroke-width="2"/>
  <text x="267" y="105" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle" fill="#000000">5</text>
  <!-- Bottom Face 6 -->
  <rect x="130" y="125" width="55" height="55" fill="#f8fafc" stroke="#000000" stroke-width="2"/>
  <text x="157" y="160" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle" fill="#000000">6</text>
  <!-- Dashed Fold Indication Lines -->
  <line x1="130" y1="70" x2="185" y2="70" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <line x1="130" y1="125" x2="185" y2="125" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <line x1="130" y1="70" x2="130" y2="125" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <line x1="185" y1="70" x2="185" y2="125" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <line x1="240" y1="70" x2="240" y2="125" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <!-- Subtitle -->
  <text x="190" y="205" font-family="Arial, sans-serif" font-size="12" font-style="italic" text-anchor="middle" fill="#333333">[ Unfolded Cube Net / खुला हुआ पासा ]</text>
</svg>',
  'दी गई आकृति में संख्यांकित फलकों वाली एक खुली शीट (Dice Net) दर्शायी गई है। यदि इस शीट को रेखाओं के अनुदिश मोड़कर एक घन (पासा) बनाया जाता है, तो संख्या ''2'' वाले फलक के विपरीत फलक पर कौन सी संख्या दिखाई देगी?
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 380 220" width="100%" height="auto" style="max-width:380px; display:block; margin:10px auto; background:#ffffff;">
  <!-- Top Face 1 -->
  <rect x="130" y="15" width="55" height="55" fill="#f8fafc" stroke="#000000" stroke-width="2"/>
  <text x="157" y="50" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle" fill="#000000">1</text>
  <!-- Middle Strip: 4, 2, 3, 5 -->
  <rect x="75" y="70" width="55" height="55" fill="#f8fafc" stroke="#000000" stroke-width="2"/>
  <text x="102" y="105" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle" fill="#000000">4</text>
  <rect x="130" y="70" width="55" height="55" fill="#f8fafc" stroke="#000000" stroke-width="2"/>
  <text x="157" y="105" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle" fill="#000000">2</text>
  <rect x="185" y="70" width="55" height="55" fill="#f8fafc" stroke="#000000" stroke-width="2"/>
  <text x="212" y="105" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle" fill="#000000">3</text>
  <rect x="240" y="70" width="55" height="55" fill="#f8fafc" stroke="#000000" stroke-width="2"/>
  <text x="267" y="105" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle" fill="#000000">5</text>
  <!-- Bottom Face 6 -->
  <rect x="130" y="125" width="55" height="55" fill="#f8fafc" stroke="#000000" stroke-width="2"/>
  <text x="157" y="160" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle" fill="#000000">6</text>
  <!-- Dashed Fold Indication Lines -->
  <line x1="130" y1="70" x2="185" y2="70" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <line x1="130" y1="125" x2="185" y2="125" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <line x1="130" y1="70" x2="130" y2="125" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <line x1="185" y1="70" x2="185" y2="125" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <line x1="240" y1="70" x2="240" y2="125" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <!-- Subtitle -->
  <text x="190" y="205" font-family="Arial, sans-serif" font-size="12" font-style="italic" text-anchor="middle" fill="#333333">[ Unfolded Cube Net / खुला हुआ पासा ]</text>
</svg>',
  '{"a":"3","b":"5","c":"6","d":"4"}'::jsonb,
  '{"a":"3","b":"5","c":"6","d":"4"}'::jsonb,
  'b',
  'Standard rules of an unfolded cube net:
In a continuous linear row of four squares [4, 2, 3, 5], alternate faces are opposite to each other:
1. Face 4 is opposite Face 3.
2. Face 2 is opposite Face 5.
3. The remaining two projecting flaps (Face 1 and Face 6) are opposite to each other.
Therefore, the number on the face opposite to ''2'' is 5.

Correct Option: (b)',
  'खुले पासे (Dice Net) को मोड़ने का नियम:
सीधी पट्टी [4, 2, 3, 5] में एकान्तर (Alternate) फलक एक-दूसरे के विपरीत होते हैं:
1. फलक 4 के विपरीत फलक 3 है।
2. फलक 2 के विपरीत फलक 5 है।
3. ऊपर और नीचे वाले फलक 1 और 6 एक-दूसरे के विपरीत हैं।
अतः संख्या ''2'' वाले फलक के विपरीत संख्या 5 होगी।

अतः सही उत्तर विकल्प (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  39,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Non-Verbal Reasoning (Geometric Venn Diagram)',
  'Moderate',
  'In the given geometric Venn diagram, the Triangle represents ''Engineers'', the Circle represents ''Doctors'', and the Rectangle represents ''Artists''. Which number represents individuals who are both Engineers and Artists, but NOT Doctors?
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 420 260" width="100%" height="auto" style="max-width:420px; display:block; margin:10px auto; background:#ffffff;">
  <!-- Rectangle: Artists -->
  <rect x="60" y="80" width="220" height="130" fill="none" stroke="#000000" stroke-width="2"/>
  <text x="65" y="100" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">Artists / कलाकार</text>
  <!-- Circle: Doctors -->
  <circle cx="260" cy="140" r="75" fill="none" stroke="#000000" stroke-width="2"/>
  <text x="270" y="235" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">Doctors / डॉक्टर</text>
  <!-- Triangle: Engineers -->
  <polygon points="170,25 90,200 250,200" fill="none" stroke="#000000" stroke-width="2"/>
  <text x="130" y="20" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">Engineers / अभियंता</text>
  <!-- Region Numbers -->
  <!-- Only Triangle: 7 -->
  <text x="165" y="70" font-family="Arial, sans-serif" font-size="15" font-weight="bold" fill="#000000">7</text>
  <!-- Only Rectangle: 12 -->
  <text x="90" y="140" font-family="Arial, sans-serif" font-size="15" font-weight="bold" fill="#000000">12</text>
  <!-- Only Circle: 9 -->
  <text x="300" y="145" font-family="Arial, sans-serif" font-size="15" font-weight="bold" fill="#000000">9</text>
  <!-- Triangle & Rectangle only (not Circle): 5 -->
  <text x="145" y="150" font-family="Arial, sans-serif" font-size="16" font-weight="bold" fill="#b91c1c">5</text>
  <!-- Triangle & Circle only (not Rectangle): 4 -->
  <text x="215" y="95" font-family="Arial, sans-serif" font-size="15" font-weight="bold" fill="#000000">4</text>
  <!-- Rectangle & Circle only (not Triangle): 3 -->
  <text x="240" y="175" font-family="Arial, sans-serif" font-size="15" font-weight="bold" fill="#000000">3</text>
  <!-- All three: 2 -->
  <text x="200" y="145" font-family="Arial, sans-serif" font-size="15" font-weight="bold" fill="#000000">2</text>
</svg>',
  'दिए गए ज्यामितीय वेन आरेख में, त्रिभुज ''अभियंताओं'' (Engineers) को, वृत्त ''डॉक्टरों'' (Doctors) को, और आयत ''कलाकारों'' (Artists) को दर्शाता है। कौन सी संख्या उन व्यक्तियों को दर्शाती है जो अभियंता और कलाकार दोनों हैं, लेकिन डॉक्टर नहीं हैं?
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 420 260" width="100%" height="auto" style="max-width:420px; display:block; margin:10px auto; background:#ffffff;">
  <!-- Rectangle: Artists -->
  <rect x="60" y="80" width="220" height="130" fill="none" stroke="#000000" stroke-width="2"/>
  <text x="65" y="100" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">Artists / कलाकार</text>
  <!-- Circle: Doctors -->
  <circle cx="260" cy="140" r="75" fill="none" stroke="#000000" stroke-width="2"/>
  <text x="270" y="235" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">Doctors / डॉक्टर</text>
  <!-- Triangle: Engineers -->
  <polygon points="170,25 90,200 250,200" fill="none" stroke="#000000" stroke-width="2"/>
  <text x="130" y="20" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">Engineers / अभियंता</text>
  <!-- Region Numbers -->
  <!-- Only Triangle: 7 -->
  <text x="165" y="70" font-family="Arial, sans-serif" font-size="15" font-weight="bold" fill="#000000">7</text>
  <!-- Only Rectangle: 12 -->
  <text x="90" y="140" font-family="Arial, sans-serif" font-size="15" font-weight="bold" fill="#000000">12</text>
  <!-- Only Circle: 9 -->
  <text x="300" y="145" font-family="Arial, sans-serif" font-size="15" font-weight="bold" fill="#000000">9</text>
  <!-- Triangle & Rectangle only (not Circle): 5 -->
  <text x="145" y="150" font-family="Arial, sans-serif" font-size="16" font-weight="bold" fill="#b91c1c">5</text>
  <!-- Triangle & Circle only (not Rectangle): 4 -->
  <text x="215" y="95" font-family="Arial, sans-serif" font-size="15" font-weight="bold" fill="#000000">4</text>
  <!-- Rectangle & Circle only (not Triangle): 3 -->
  <text x="240" y="175" font-family="Arial, sans-serif" font-size="15" font-weight="bold" fill="#000000">3</text>
  <!-- All three: 2 -->
  <text x="200" y="145" font-family="Arial, sans-serif" font-size="15" font-weight="bold" fill="#000000">2</text>
</svg>',
  '{"a":"4","b":"5","c":"2","d":"3"}'::jsonb,
  '{"a":"4","b":"5","c":"2","d":"3"}'::jsonb,
  'b',
  'Analysis of overlapping geometric regions:
- Required: Region inside Triangle (Engineers) AND inside Rectangle (Artists) AND outside Circle (Doctors).
- Intersection of Triangle and Rectangle gives the numbers 5 and 2.
- Number 2 also lies inside the Circle (Doctors).
- Therefore, the number representing individuals who are Engineers and Artists but NOT Doctors is 5.

Correct Option: (b)',
  'आकृति का विश्लेषण:
- वांछित क्षेत्र: त्रिभुज (अभियंता) और आयत (कलाकार) का उभयनिष्ठ क्षेत्र, जो वृत्त (डॉक्टर) से बाहर हो।
- त्रिभुज और आयत के प्रतिच्छेदन में 5 और 2 आते हैं।
- 2 वृत्त के भी अंदर है, अतः केवल त्रिभुज और आयत में 5 आता है।
अतः सही उत्तर 5 है।

अतः सही उत्तर विकल्प (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  40,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Syllogisms (Universal Affirmative)',
  'Moderate',
  'Statements:
1. All birds are animals.
2. All animals are living beings.
Conclusions:
I. All birds are living beings.
II. Some living beings are birds.',
  'कथन:
1. सभी पक्षी जानवर हैं।
2. सभी जानवर जीवित प्राणी हैं।
निष्कर्ष:
I. सभी पक्षी जीवित प्राणी हैं।
II. कुछ जीवित प्राणी पक्षी हैं।',
  '{"a":"Only conclusion I follows","b":"Only conclusion II follows","c":"Both conclusions I and II follow","d":"Neither follows"}'::jsonb,
  '{"a":"केवल निष्कर्ष I अनुसरण करता है","b":"केवल निष्कर्ष II अनुसरण करता है","c":"निष्कर्ष I और II दोनों अनुसरण करते हैं","d":"कोई अनुसरण नहीं करता"}'::jsonb,
  'c',
  'Venn set containment: Birds ⊂ Animals ⊂ Living Beings.
- Conclusion I: Birds ⊂ Living Beings => Valid.
- Conclusion II: Some Living Beings are Birds => Valid.
Both conclusions I and II follow.

Correct Option: (c)',
  'वेन आरेख: पक्षी ⊂ जानवर ⊂ जीवित प्राणी।
निष्कर्ष I (सभी पक्षी जीवित प्राणी हैं) और निष्कर्ष II (कुछ जीवित प्राणी पक्षी हैं) दोनों सत्य हैं।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  41,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Syllogisms (Particular & Universal)',
  'Moderate',
  'Statements:
1. Some doctors are teachers.
2. All teachers are researchers.
Conclusions:
I. Some researchers are doctors.
II. Some teachers are not doctors.',
  'कथन:
1. कुछ डॉक्टर शिक्षक हैं।
2. सभी शिक्षक शोधकर्ता हैं।
निष्कर्ष:
I. कुछ शोधकर्ता डॉक्टर हैं।
II. कुछ शिक्षक डॉक्टर नहीं हैं।',
  '{"a":"Only conclusion I follows","b":"Only conclusion II follows","c":"Both follow","d":"Neither follows"}'::jsonb,
  '{"a":"केवल निष्कर्ष I अनुसरण करता है","b":"केवल निष्कर्ष II अनुसरण करता है","c":"दोनों अनुसरण करते हैं","d":"कोई अनुसरण नहीं करता"}'::jsonb,
  'a',
  'Since some doctors are teachers and all teachers are researchers, the intersection of Doctors and Teachers is completely contained in Researchers. Therefore, ''Some researchers are doctors'' is definitely true. However, from positive premises, a negative conclusion (''Some teachers are not doctors'') cannot be definitively deduced. Hence, only conclusion I follows.

Correct Option: (a)',
  'चूँकि कुछ डॉक्टर शिक्षक हैं और सभी शिक्षक शोधकर्ता हैं, अतः शोधकर्ताओं और डॉक्टरों में सामान्य भाग अवश्य है (निष्कर्ष I सत्य)। सकारात्मक कथनों से नकारात्मक निष्कर्ष (निष्कर्ष II) निश्चित रूप से नहीं निकाला जा सकता। अतः केवल निष्कर्ष I अनुसरण करता है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  42,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Syllogisms (Negative Deduction)',
  'Moderate',
  'Statements:
1. All stones are hammers.
2. No hammer is a ring.
Conclusions:
I. No stone is a ring.
II. Some rings are stones.',
  'कथन:
1. सभी पत्थर हथौड़े हैं।
2. कोई हथौड़ा अंगूठी नहीं है।
निष्कर्ष:
I. कोई पत्थर अंगूठी नहीं है।
II. कुछ अंगूठियां पत्थर हैं।',
  '{"a":"Only conclusion I follows","b":"Only conclusion II follows","c":"Either I or II follows","d":"Neither follows"}'::jsonb,
  '{"a":"केवल निष्कर्ष I अनुसरण करता है","b":"केवल निष्कर्ष II अनुसरण करता है","c":"या तो I या II अनुसरण करता है","d":"कोई अनुसरण नहीं करता"}'::jsonb,
  'a',
  'Since All Stones are inside Hammers, and Hammers have zero intersection with Rings, Stones also have zero intersection with Rings. Therefore, ''No stone is a ring'' is definitely true. Conclusion II is false.

Correct Option: (a)',
  'चूँकि सभी पत्थर हथौड़े हैं और हथौड़ों का अंगूठियों से कोई संबंध नहीं है, अतः पत्थरों का भी अंगूठियों से कोई संबंध नहीं हो सकता। निष्कर्ष I पूर्णतः सत्य है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  43,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Statement & Assumptions (Railway Policy)',
  'Moderate',
  'Statement: ''The government has decided to provide free Wi-Fi connectivity at all major railway stations across the country.''
Assumptions:
I. Passengers use internet services during their travel and transit time.
II. Many passengers cannot afford internet on their mobile phones.',
  'कथन: ''सरकार ने देश के सभी प्रमुख रेलवे स्टेशनों पर मुफ्त वाई-फाई कनेक्टिविटी प्रदान करने का निर्णय लिया है।''
पूर्वधारणाएं:
I. यात्री अपनी यात्रा और पारगमन (Transit) समय के दौरान इंटरनेट सेवाओं का उपयोग करते हैं।
II. कई यात्री अपने मोबाइल फोन पर इंटरनेट का खर्च वहन नहीं कर सकते।',
  '{"a":"Only assumption I is implicit","b":"Only assumption II is implicit","c":"Both assumptions are implicit","d":"Neither assumption is implicit"}'::jsonb,
  '{"a":"केवल पूर्वधारणा I अंतर्निहित है","b":"केवल पूर्वधारणा II अंतर्निहित है","c":"दोनों पूर्वधारणाएं अंतर्निहित हैं","d":"कोई भी पूर्वधारणा अंतर्निहित नहीं है"}'::jsonb,
  'a',
  '- Assumption I is implicit because providing a facility at railway stations directly presumes that passengers need, demand, and utilize internet connectivity while waiting for trains.
- Assumption II is not necessarily implicit because public amenities are installed for overall public convenience and digital inclusion, not solely because passengers cannot afford cellular data.
Hence, only assumption I is implicit.

Correct Option: (a)',
  '- पूर्वधारणा I अंतर्निहित है क्योंकि रेलवे स्टेशनों पर वाई-फाई सुविधा प्रदान करना यह मानकर किया गया है कि यात्री प्रतीक्षा अवधि में इंटरनेट का उपयोग करते हैं।
- पूर्वधारणा II अंतर्निहित नहीं है क्योंकि सार्वजनिक सुविधाएं केवल सामर्थ्य की कमी के आधार पर नहीं बल्कि आम जन-सुविधा हेतु शुरू की जाती हैं।
अतः केवल पूर्वधारणा I अंतर्निहित है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  44,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Statement & Assumptions (Passenger Safety)',
  'Moderate',
  'Statement: ''Passengers are requested to use the foot overbridge and not cross the railway tracks directly.'' - Railway Station Notice.
Assumptions:
I. Crossing railway tracks directly on foot is dangerous and poses a risk to life.
II. People can read and understand notices displayed at railway platforms.',
  'कथन: ''यात्रियों से अनुरोध है कि वे फुट ओवरब्रिज का उपयोग करें और रेलवे पटरियों को सीधे पार न करें।'' - रेलवे स्टेशन की सूचना।
पूर्वधारणाएं:
I. पैदल सीधे रेलवे ट्रैक पार करना खतरनाक है और इससे जान का जोखिम रहता है।
II. लोग रेलवे प्लेटफॉर्म पर प्रदर्शित सूचनाओं को पढ़ और समझ सकते हैं।',
  '{"a":"Both assumptions I and II are implicit","b":"Only assumption I is implicit","c":"Only assumption II is implicit","d":"Neither assumption is implicit"}'::jsonb,
  '{"a":"पूर्वधारणा I और II दोनों अंतर्निहित हैं","b":"केवल पूर्वधारणा I अंतर्निहित है","c":"केवल पूर्वधारणा II अंतर्निहित है","d":"कोई भी पूर्वधारणा अंतर्निहित नहीं है"}'::jsonb,
  'a',
  '- Assumption I is implicit because issuing a warning not to cross tracks directly is grounded on the fact that track crossing is life-threatening.
- Assumption II is implicit because any official public advisory/notice is posted with the underlying expectation that commuters will read and heed it.
Therefore, both assumptions I and II are implicit.

Correct Option: (a)',
  '- पूर्वधारणा I अंतर्निहित है क्योंकि रेलवे ट्रैक पार करने से रोकने की सूचना इसी आधार पर दी जाती है कि यह जानलेवा है।
- पूर्वधारणा II भी अंतर्निहित है क्योंकि सूचना पट्ट इसी उम्मीद से लगाए जाते हैं कि यात्री उन्हें पढ़ेंगे और पालन करेंगे।
अतः दोनों पूर्वधारणाएं अंतर्निहित हैं।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  45,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Statement & Conclusions (Health)',
  'Moderate',
  'Statement: Regular physical exercise helps lower blood pressure and reduces the risk of heart disease.
Conclusions:
I. People who do not exercise will always suffer from heart disease.
II. Moderate regular exercise is beneficial for maintaining cardiovascular health.',
  'कथन: नियमित शारीरिक व्यायाम रक्तचाप को कम करने और हृदय रोग के जोखिम को घटाने में मदद करता है।
निष्कर्ष:
I. जो लोग व्यायाम नहीं करते वे हमेशा हृदय रोग से पीड़ित होंगे।
II. मध्यम नियमित व्यायाम हृदय स्वास्थ्य को बनाए रखने के लिए लाभकारी है।',
  '{"a":"Only conclusion II follows","b":"Only conclusion I follows","c":"Both conclusions follow","d":"Neither conclusion follows"}'::jsonb,
  '{"a":"केवल निष्कर्ष II अनुसरण करता है","b":"केवल निष्कर्ष I अनुसरण करता है","c":"दोनों निष्कर्ष अनुसरण करते हैं","d":"कोई भी निष्कर्ष अनुसरण नहीं करता"}'::jsonb,
  'a',
  '- Conclusion I is an extreme and invalid generalization (''will always suffer'').
- Conclusion II directly restates the positive premise established in the statement.
Therefore, only conclusion II logically follows.

Correct Option: (a)',
  '- निष्कर्ष I एक अतिवादी और गलत अनुमान है (''हमेशा पीड़ित होंगे'')।
- निष्कर्ष II सीधे कथन के तथ्य की पुष्टि करता है।
अतः केवल निष्कर्ष II अनुसरण करता है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  46,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Statement & Conclusions (Economy)',
  'Moderate',
  'Statement: ''The price of petroleum crude oil in the international market has dropped by 25%.'' Conclusion I: ''Domestic oil companies may consider reducing retail petrol and diesel rates.'' Conclusion II: ''Demand for public transport will immediately collapse.''',
  'कथन: ''अंतर्राष्ट्रीय बाजार में कच्चे तेल की कीमतों में 25% की गिरावट आई है।'' निष्कर्ष I: ''घरेलू तेल कंपनियां खुदरा पेट्रोल और डीजल की दरों में कमी करने पर विचार कर सकती हैं।'' निष्कर्ष II: ''सार्वजनिक परिवहन की मांग तुरंत पूरी तरह समाप्त हो जाएगी।''',
  '{"a":"Only conclusion I follows","b":"Only conclusion II follows","c":"Both conclusions I and II follow","d":"Neither I nor II follows"}'::jsonb,
  '{"a":"केवल निष्कर्ष I अनुसरण करता है","b":"केवल निष्कर्ष II अनुसरण करता है","c":"दोनों निष्कर्ष I और II अनुसरण करते हैं","d":"न तो I और न ही II अनुसरण करता है"}'::jsonb,
  'a',
  'Lower input crude costs directly allow retail price rationalization (I follows). Demands for mass public transit depend on urbanization, traffic, and affordability, not collapsing outright (II is invalid).',
  'कच्चे तेल की कीमत घटने पर खुदरा दरों में कमी की संभावना बनती है (I सही)। सार्वजनिक परिवहन की मांग समाप्त होना बेतुका निष्कर्ष है (II गलत)।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  47,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Statement & Arguments (Environment)',
  'Moderate',
  'Statement: Should single-use plastics be completely banned across India?
Arguments:
I. Yes, because single-use plastics are non-biodegradable and cause severe environmental pollution and marine hazards.
II. No, because plastic manufacturing industries provide employment to millions of workers.',
  'कथन: क्या पूरे भारत में एकल-उपयोग वाले प्लास्टिक (Single-use plastics) पर पूर्ण प्रतिबंध लगाया जाना चाहिए?
तर्क:
I. हां, क्योंकि एकल-उपयोग वाले प्लास्टिक गैर-बायोडिग्रेडेबल हैं और गंभीर पर्यावरण प्रदूषण व जलीय जीवों के लिए खतरा पैदा करते हैं।
II. नहीं, क्योंकि प्लास्टिक विनिर्माण उद्योग लाखों श्रमिकों को रोजगार प्रदान करता है।',
  '{"a":"Only argument I is strong","b":"Only argument II is strong","c":"Both arguments I and II are strong","d":"Neither argument is strong"}'::jsonb,
  '{"a":"केवल तर्क I ठोस है","b":"केवल तर्क II ठोस है","c":"तर्क I और II दोनों ठोस हैं","d":"कोई भी तर्क ठोस नहीं है"}'::jsonb,
  'a',
  'Argument I is strong because environmental sustainability, ecological survival, and health hazards represent a critical public and existential priority recognized globally.
Argument II is weak because economic transition towards sustainable alternatives can generate green employment, and economic benefits cannot override severe irreversible environmental degradation.
Therefore, only argument I is strong.

Correct Option: (a)',
  'तर्क I एक अत्यंत ठोस और वैज्ञानिक तर्क है क्योंकि पर्यावरण और पारिस्थितिकी तंत्र की सुरक्षा सर्वोच्च प्राथमिकता है।
तर्क II कमजोर है क्योंकि पर्यावरण के विनाश की कीमत पर रोजगार का तर्क स्थायी नीति नहीं हो सकता और इसके स्थान पर वैकल्पिक हरित उद्योग रोजगार प्रदान कर सकते हैं।
अतः केवल तर्क I ठोस है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  48,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Course of Action (Urban Disaster)',
  'Moderate',
  'Statement: Heavy monsoon rains have inundated low-lying areas of the city, causing waterlogging and traffic paralysis.
Courses of Action:
I. The civic administration should deploy emergency water pumps immediately to drain water from major roads.
II. Citizens should be advised through media to avoid unnecessary travel and take alternate elevated routes.',
  'कथन: भारी मानसूनी बारिश के कारण शहर के निचले इलाकों में पानी भर गया है, जिससे जलभराव और यातायात ठप हो गया है।
कार्यवाही के उपाय:
I. नागरिक प्रशासन को प्रमुख सड़कों से पानी निकालने के लिए तुरंत आपातकालीन पानी के पंप तैनात करने चाहिए।
II. नागरिकों को मीडिया के माध्यम से सलाह दी जानी चाहिए कि वे अनावश्यक यात्रा से बचें और वैकल्पिक ऊंचे मार्गों का उपयोग करें।',
  '{"a":"Only I follows","b":"Only II follows","c":"Both I and II follow","d":"Neither I nor II follows"}'::jsonb,
  '{"a":"केवल I अनुसरण करता है","b":"केवल II अनुसरण करता है","c":"I और II दोनों अनुसरण करते हैं","d":"न तो I और न ही II अनुसरण करता है"}'::jsonb,
  'c',
  '- Course of Action I is a direct and necessary remedial operational measure to restore mobility and remove excess water.
- Course of Action II is a sensible preventive advisory to minimize congestion and protect citizen safety.
Both actions address the problem practically and constructively.

Correct Option: (c)',
  '- उपाय I जलभराव की समस्या को दूर करने के लिए आवश्यक त्वरित प्रशासनिक कदम है।
- उपाय II नागरिकों की सुरक्षा और जाम से बचने के लिए उचित परामर्श है।
अतः दोनों कार्यवाहियां उचित और आवश्यक हैं।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  49,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Coding & Decoding (Direct Substitution)',
  'Moderate',
  'In a certain code language, ''ROSE'' is coded as ''6821'' and ''CHAIR'' is coded as ''73456''. How is ''SEARCH'' coded in that language?',
  'एक निश्चित कूट भाषा में, ''ROSE'' को ''6821'' और ''CHAIR'' को ''73456'' के रूप में कूटबद्ध किया जाता है। उसी भाषा में ''SEARCH'' को कैसे कूटबद्ध किया जाएगा?',
  '{"a":"214573","b":"214673","c":"214763","d":"215473"}'::jsonb,
  '{"a":"214573","b":"214673","c":"214763","d":"215473"}'::jsonb,
  'b',
  'Direct letter-to-digit substitution:
- R=6, O=8, S=2, E=1
- C=7, H=3, A=4, I=5, R=6
Now for ''SEARCH'':
S -> 2
E -> 1
A -> 4
R -> 6
C -> 7
H -> 3
Code = 214673.

Correct Option: (b)',
  'प्रत्यक्ष कूट प्रतिस्थापन:
S=2, E=1, A=4, R=6, C=7, H=3.
अतः ''SEARCH'' = 214673.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  50,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Coding & Decoding (Direct Letter Codes)',
  'Moderate',
  'If ''DELHI'' is coded as 73541 and ''CALCUTTA'' is coded as 82589662, how is ''CALICUT'' coded in that language?',
  'यदि ''DELHI'' को 73541 और ''CALCUTTA'' को 82589662 के रूप में कूटबद्ध किया जाता है, तो ''CALICUT'' को कैसे कूटबद्ध किया जाएगा?',
  '{"a":"8251896","b":"8251869","c":"8258196","d":"8251986"}'::jsonb,
  '{"a":"8251896","b":"8251869","c":"8258196","d":"8251986"}'::jsonb,
  'a',
  'Direct letter mapping:
C=8, A=2, L=5, H=4, I=1, U=9, T=6.
For ''CALICUT'':
C -> 8
A -> 2
L -> 5
I -> 1
C -> 8
U -> 9
T -> 6
Code = 8251896.

Correct Option: (a)',
  'प्रत्यक्ष कूट मिलान:
C=8, A=2, L=5, I=1, C=8, U=9, T=6.
अतः ''CALICUT'' = 8251896.

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  51,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Coding & Decoding (Letter Shift Pattern)',
  'Moderate',
  'In a certain code, ''TEACHER'' is written as ''VGCEJGT''. How will ''STUDENT'' be written in that code language?',
  'एक निश्चित कूट में, ''TEACHER'' को ''VGCEJGT'' लिखा जाता है। उसी कूट भाषा में ''STUDENT'' को कैसे लिखा जाएगा?',
  '{"a":"UVWFGPV","b":"UVWGFPV","c":"UWVFGVP","d":"TUVEFOS"}'::jsonb,
  '{"a":"UVWFGPV","b":"UVWGFPV","c":"UWVFGVP","d":"TUVEFOS"}'::jsonb,
  'a',
  'Pattern: Forward shift of +2 for every letter:
T(+2)=V, E(+2)=G, A(+2)=C, C(+2)=E, H(+2)=J, E(+2)=G, R(+2)=T.
Applying to STUDENT:
S(19)+2 = U(21)
T(20)+2 = V(22)
U(21)+2 = W(23)
D(4)+2 = F(6)
E(5)+2 = G(7)
N(14)+2 = P(16)
T(20)+2 = V(22)
Result = UVWFGPV.

Correct Option: (a)',
  'प्रत्येक अक्षर में +2 का अग्रिम विस्थापन:
S+2=U, T+2=V, U+2=W, D+2=F, E+2=G, N+2=P, T+2=V.
अतः अभीष्ट कूट UVWFGPV है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  52,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Coding & Decoding (Railway Domain)',
  'Moderate',
  'In a certain code language, ''RAILWAY'' is coded as ''TCKNYCA''. How will ''STATION'' be coded in that same language?',
  'एक निश्चित कूट भाषा में ''RAILWAY'' को ''TCKNYCA'' लिखा जाता है। उसी कूट भाषा में ''STATION'' को किस प्रकार लिखा जाएगा?',
  '{"a":"UVCVKQP","b":"UVBVKPO","c":"TVCUKQP","d":"UVCWLRQ"}'::jsonb,
  '{"a":"UVCVKQP","b":"UVBVKPO","c":"TVCUKQP","d":"UVCWLRQ"}'::jsonb,
  'a',
  'The pattern adds $+2$ to each letter''s alphabetical rank: R(+2)->T, A(+2)->C, I(+2)->K, L(+2)->N, W(+2)->Y, A(+2)->C, Y(+2)->A. Applying to STATION: S(+2)=U, T(+2)=V, A(+2)=C, T(+2)=V, I(+2)=K, O(+2)=Q, N(+2)=P -> ''UVCVKQP''.',
  'पैटर्न में प्रत्येक अक्षर के वर्णमाला क्रम में $+2$ जोड़ा गया है: R(+2)->T, A(+2)->C, आदि। अतः STATION के लिए: S(+2)=U, T(+2)=V, A(+2)=C, T(+2)=V, I(+2)=K, O(+2)=Q, N(+2)=P -> ''UVCVKQP''।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  53,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Number Series (Arithmetic Difference)',
  'Moderate',
  'Find the missing number in the following series:
3, 8, 18, 38, 78, ?',
  'निम्नलिखित संख्या श्रृंखला में लुप्त पद ज्ञात कीजिए:
3, 8, 18, 38, 78, ?',
  '{"a":"148","b":"158","c":"168","d":"156"}'::jsonb,
  '{"a":"148","b":"158","c":"168","d":"156"}'::jsonb,
  'b',
  'Pattern:
- 3 × 2 + 2 = 8
- 8 × 2 + 2 = 18
- 18 × 2 + 2 = 38
- 38 × 2 + 2 = 78
- 78 × 2 + 2 = 156 + 2 = 158.
(Or differences: +5, +10, +20, +40, +80 => 78 + 80 = 158).

Correct Option: (b)',
  'पैटर्न: प्रत्येक पद × 2 + 2
78 × 2 + 2 = 158 (अथवा अंतर: +5, +10, +20, +40, +80 => 78 + 80 = 158)।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  54,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Number Series (Geometric Double + 3)',
  'Moderate',
  'Find the missing number in the following sequence:
5, 13, 29, 61, 125, ?',
  'निम्नलिखित अनुक्रम में लुप्त संख्या ज्ञात कीजिए:
5, 13, 29, 61, 125, ?',
  '{"a":"251","b":"253","c":"257","d":"249"}'::jsonb,
  '{"a":"251","b":"253","c":"257","d":"249"}'::jsonb,
  'b',
  'Pattern: Multiply by 2 and add 3:
- 5 × 2 + 3 = 13
- 13 × 2 + 3 = 29
- 29 × 2 + 3 = 61
- 61 × 2 + 3 = 125
- 125 × 2 + 3 = 250 + 3 = 253.

Correct Option: (b)',
  'पैटर्न: संख्या × 2 + 3
5×2+3=13, 13×2+3=29, 29×2+3=61, 61×2+3=125, 125×2+3 = 253.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  55,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Non-Verbal Reasoning (Mirror Image across MN)',
  'Moderate',
  'Select the correct mirror image of the given figure when the plane mirror is placed vertically along the line MN as shown:
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 440 180" width="100%" height="auto" style="max-width:440px; display:block; margin:10px auto; background:#ffffff;">
  <!-- Left Side: Object Figure -->
  <rect x="40" y="25" width="120" height="120" fill="none" stroke="#000000" stroke-width="2"/>
  <line x1="40" y1="25" x2="160" y2="145" stroke="#000000" stroke-width="2"/>
  <!-- Arrow pointing Right at (100, 85) -->
  <line x1="65" y1="85" x2="135" y2="85" stroke="#000000" stroke-width="2.5"/>
  <polygon points="135,85 120,77 120,93" fill="#000000"/>
  <!-- Dot at top-left -->
  <circle cx="70" cy="55" r="8" fill="#000000"/>
  <!-- Shaded small triangle at bottom-right -->
  <polygon points="160,110 160,145 125,145" fill="#000000"/>
  <text x="100" y="165" font-family="Arial, sans-serif" font-size="12" font-weight="bold" text-anchor="middle" fill="#000000">Object / मूल आकृति</text>

  <!-- Mirror Line M - N -->
  <line x1="220" y1="15" x2="220" y2="165" stroke="#000000" stroke-width="2.5" stroke-dasharray="6,4"/>
  <text x="220" y="12" font-family="Arial, sans-serif" font-size="13" font-weight="bold" text-anchor="middle" fill="#000000">M</text>
  <text x="220" y="178" font-family="Arial, sans-serif" font-size="13" font-weight="bold" text-anchor="middle" fill="#000000">N</text>

  <!-- Right Side: Mirror Placeholder with Question Mark -->
  <rect x="280" y="25" width="120" height="120" fill="#f8fafc" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <text x="340" y="95" font-family="Arial, sans-serif" font-size="36" font-weight="bold" text-anchor="middle" fill="#555555">?</text>
  <text x="340" y="165" font-family="Arial, sans-serif" font-size="12" font-weight="bold" text-anchor="middle" fill="#000000">Mirror Image / दर्पण प्रतिबिम्ब</text>
</svg>',
  'दी गई आकृति का सही दर्पण प्रतिबिम्ब चुनिए जब समतल दर्पण को रेखा MN के अनुदिश लंबवत रखा जाता है जैसा कि दर्शाया गया है:
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 440 180" width="100%" height="auto" style="max-width:440px; display:block; margin:10px auto; background:#ffffff;">
  <!-- Left Side: Object Figure -->
  <rect x="40" y="25" width="120" height="120" fill="none" stroke="#000000" stroke-width="2"/>
  <line x1="40" y1="25" x2="160" y2="145" stroke="#000000" stroke-width="2"/>
  <!-- Arrow pointing Right at (100, 85) -->
  <line x1="65" y1="85" x2="135" y2="85" stroke="#000000" stroke-width="2.5"/>
  <polygon points="135,85 120,77 120,93" fill="#000000"/>
  <!-- Dot at top-left -->
  <circle cx="70" cy="55" r="8" fill="#000000"/>
  <!-- Shaded small triangle at bottom-right -->
  <polygon points="160,110 160,145 125,145" fill="#000000"/>
  <text x="100" y="165" font-family="Arial, sans-serif" font-size="12" font-weight="bold" text-anchor="middle" fill="#000000">Object / मूल आकृति</text>

  <!-- Mirror Line M - N -->
  <line x1="220" y1="15" x2="220" y2="165" stroke="#000000" stroke-width="2.5" stroke-dasharray="6,4"/>
  <text x="220" y="12" font-family="Arial, sans-serif" font-size="13" font-weight="bold" text-anchor="middle" fill="#000000">M</text>
  <text x="220" y="178" font-family="Arial, sans-serif" font-size="13" font-weight="bold" text-anchor="middle" fill="#000000">N</text>

  <!-- Right Side: Mirror Placeholder with Question Mark -->
  <rect x="280" y="25" width="120" height="120" fill="#f8fafc" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <text x="340" y="95" font-family="Arial, sans-serif" font-size="36" font-weight="bold" text-anchor="middle" fill="#555555">?</text>
  <text x="340" y="165" font-family="Arial, sans-serif" font-size="12" font-weight="bold" text-anchor="middle" fill="#000000">Mirror Image / दर्पण प्रतिबिम्ब</text>
</svg>',
  '{"a":"Arrow points left; black dot shifts to top-right; shaded triangle shifts to bottom-left","b":"Arrow points right; black dot remains at top-left; shaded triangle shifts to top-right","c":"Figure is inverted upside down; arrow points left at bottom","d":"Arrow points vertically upward; dot moves to bottom-left"}'::jsonb,
  '{"a":"तीर बायीं ओर इंगित करता है; काला बिंदु शीर्ष-दायें जाता है; छायांकित त्रिभुज तल-बायें जाता है","b":"तीर दायीं ओर रहता है; बिंदु शीर्ष-बायें रहता है; छायांकित त्रिभुज शीर्ष-दायें जाता है","c":"आकृति उल्टी (Inverted) हो जाती है; तीर नीचे की ओर इंगित करता है","d":"तीर लंबवत ऊपर की ओर इंगित करता है; बिंदु नीचे चला जाता है"}'::jsonb,
  'a',
  'Rules of lateral inversion in a vertical plane mirror (line MN):
1. Lateral Reversal: Left elements shift to the right, and right elements shift to the left.
2. Vertical Invariance: Top and bottom orientations remain unaltered.
- The arrow originally pointing to the right now points to the left.
- The black dot at the top-left shifts to the top-right.
- The shaded triangle at the bottom-right shifts to the bottom-left.
Therefore, Option (a) accurately describes the exact mirror reflection.

Correct Option: (a)',
  'लंबवत दर्पण (रेखा MN) में पाश्विक परावर्तन (Lateral Inversion) के नियम:
1. बायाँ भाग दायें और दायाँ भाग बायें दिखाई देता है, जबकि ऊपर और नीचे की स्थिति अपरिवर्तित रहती है।
2. दायीं ओर इंगित करने वाला तीर बायीं ओर इंगित करेगा।
3. शीर्ष-बायें स्थित बिंदु शीर्ष-दायें चला जाएगा।
4. तल-दायें स्थित छायांकित त्रिभुज तल-बायें आ जाएगा।
अतः सही उत्तर विकल्प (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  56,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Blood Relations (Family Tree)',
  'Moderate',
  'A is the brother of B. C is the father of A. D is the brother of E. E is the daughter of B. Who is the uncle of D?',
  'A, B का भाई है। C, A का पिता है। D, E का भाई है। E, B की पुत्री है। D का चाचा/मामा कौन है?',
  '{"a":"A","b":"B","c":"C","d":"E"}'::jsonb,
  '{"a":"A","b":"B","c":"C","d":"E"}'::jsonb,
  'a',
  'Family tree analysis:
- E is daughter of B, and D is brother of E => D is the son of B.
- A is the brother of B.
Since A is the brother of D''s parent (B), A is the uncle of D.

Correct Option: (a)',
  'संबंध विश्लेषण:
- D, E का भाई है और E, B की पुत्री है => D, B का पुत्र है।
- A, B का भाई है।
अतः A, D का चाचा/मामा (Uncle) है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  57,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Blood Relations (Generational Chain)',
  'Moderate',
  'A is B''s sister. C is B''s mother. D is C''s father. E is D''s mother. How is A related to D?',
  'A, B की बहन है। C, B की माँ है। D, C का पिता है। E, D की माँ है। A, D से किस प्रकार संबंधित है?',
  '{"a":"Daughter","b":"Granddaughter","c":"Great granddaughter","d":"Niece"}'::jsonb,
  '{"a":"पुत्री","b":"पौत्री / नातिन (Granddaughter)","c":"परपौत्री","d":"भांजी"}'::jsonb,
  'b',
  '- A is the daughter of C (since A is sister of B, and C is mother of B).
- D is the father of C.
Therefore, A is the daughter of D''s daughter, which makes A the Granddaughter (नातिन) of D.

Correct Option: (b)',
  'A, C की पुत्री है और D, C का पिता है। अतः A, D की नातिन (Granddaughter) है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  58,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Direction & Distance Sense',
  'Moderate',
  'Starting from point P, Sachin walks 20 metres South. He turns left and walks 30 metres. He then turns left and walks 20 metres. Finally, he turns left once more and walks 40 metres to stop at point Q. How far and in which direction is point Q from point P?',
  'बिंदु P से शुरू होकर, सचिन 20 मीटर दक्षिण की ओर चलता है। वह बायें मुड़ता है और 30 मीटर चलता है। फिर वह बायें मुड़कर 20 मीटर चलता है। अंत में, वह पुनः बायें मुड़ता है और बिंदु Q पर रुकने के लिए 40 मीटर चलता है। बिंदु Q, बिंदु P से कितनी दूर और किस दिशा में है?',
  '{"a":"10 metres West","b":"10 metres East","c":"20 metres West","d":"10 metres North"}'::jsonb,
  '{"a":"10 मीटर पश्चिम","b":"10 मीटर पूर्व","c":"20 मीटर पश्चिम","d":"10 मीटर उत्तर"}'::jsonb,
  'a',
  'Tracking coordinates from P(0, 0):
1. 20 m South -> (0, -20)
2. Turns left (East) 30 m -> (30, -20)
3. Turns left (North) 20 m -> (30, 0)
4. Turns left (West) 40 m -> (30 - 40, 0) = (-10, 0).
Point Q is at (-10, 0), which is exactly 10 metres West of P.

Correct Option: (a)',
  'निर्देशांक विश्लेषण P(0,0) से:
1. दक्षिण 20 मी -> (0, -20)
2. बायें (पूर्व) 30 मी -> (30, -20)
3. बायें (उत्तर) 20 मी -> (30, 0)
4. बायें (पश्चिम) 40 मी -> (-10, 0)।
अतः Q, बिंदु P से 10 मीटर पश्चिम में है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  59,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Direction & Sun Shadow',
  'Moderate',
  'One morning after sunrise, Suresh was standing facing a pole. The shadow of the pole fell exactly to his right. Which direction was Suresh facing?',
  'एक सुबह सूर्योदय के बाद सुरेश एक खंभे के सामने खड़ा था। खंभे की परछाई ठीक उसके दायीं ओर पड़ रही थी। सुरेश का मुख किस दिशा में था?',
  '{"a":"East","b":"West","c":"North","d":"South"}'::jsonb,
  '{"a":"पूर्व","b":"पश्चिम","c":"उत्तर","d":"दक्षिण"}'::jsonb,
  'd',
  'In the morning, the sun rises in the East, so all shadows fall towards the West.
- Shadow of the pole is to Suresh''s right, which means West is to Suresh''s right.
- When a person faces South, West is to their right (and East is to their left).
Therefore, Suresh was facing South.

Correct Option: (d)',
  'सुबह के समय सूर्य पूर्व में होता है, अतः सभी परछाइयाँ पश्चिम दिशा में पड़ती हैं।
खंभे की परछाई सुरेश के दायीं ओर है, अर्थात पश्चिम दिशा उसके दायीं ओर है।
जब कोई व्यक्ति दक्षिण की ओर देखता है, तो पश्चिम उसके दायीं ओर होता है। अतः सुरेश का मुख दक्षिण दिशा में था।

अतः सही उत्तर (d) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  60,
  2,
  'PART-2',
  'General Intelligence & Reasoning',
  'Non-Verbal Reasoning (Pattern Series & Rotation)',
  'Moderate',
  'Select the figure from the given options that will replace the question mark (?) in the sequential figure pattern series:
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 460 140" width="100%" height="auto" style="max-width:460px; display:block; margin:10px auto; background:#ffffff;">
  <!-- Frame 1: Diagonal 45 deg line, 1 dot -->
  <rect x="20" y="20" width="85" height="85" fill="none" stroke="#000000" stroke-width="2"/>
  <line x1="25" y1="100" x2="100" y2="25" stroke="#000000" stroke-width="2.5"/>
  <circle cx="45" cy="45" r="5" fill="#000000"/>
  <text x="62" y="122" font-family="Arial, sans-serif" font-size="12" font-weight="bold" text-anchor="middle" fill="#000000">(1)</text>

  <!-- Frame 2: Vertical 90 deg line, 2 dots -->
  <rect x="130" y="20" width="85" height="85" fill="none" stroke="#000000" stroke-width="2"/>
  <line x1="172" y1="25" x2="172" y2="100" stroke="#000000" stroke-width="2.5"/>
  <circle cx="152" cy="50" r="5" fill="#000000"/>
  <circle cx="192" cy="75" r="5" fill="#000000"/>
  <text x="172" y="122" font-family="Arial, sans-serif" font-size="12" font-weight="bold" text-anchor="middle" fill="#000000">(2)</text>

  <!-- Frame 3: Diagonal 135 deg line, 3 dots -->
  <rect x="240" y="20" width="85" height="85" fill="none" stroke="#000000" stroke-width="2"/>
  <line x1="245" y1="25" x2="320" y2="100" stroke="#000000" stroke-width="2.5"/>
  <circle cx="260" cy="75" r="5" fill="#000000"/>
  <circle cx="282" cy="45" r="5" fill="#000000"/>
  <circle cx="305" cy="45" r="5" fill="#000000"/>
  <text x="282" y="122" font-family="Arial, sans-serif" font-size="12" font-weight="bold" text-anchor="middle" fill="#000000">(3)</text>

  <!-- Frame 4: Question Mark ''?'' -->
  <rect x="350" y="20" width="85" height="85" fill="#f8fafc" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <text x="392" y="73" font-family="Arial, sans-serif" font-size="32" font-weight="bold" text-anchor="middle" fill="#555555">?</text>
  <text x="392" y="122" font-family="Arial, sans-serif" font-size="12" font-weight="bold" text-anchor="middle" fill="#000000">(4)</text>
</svg>',
  'दिए गए विकल्पों में से उस आकृति का चयन करें जो क्रमिक आकृति श्रृंखला में प्रश्नवाचक चिह्न (?) को प्रतिस्थापित करेगी:
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 460 140" width="100%" height="auto" style="max-width:460px; display:block; margin:10px auto; background:#ffffff;">
  <!-- Frame 1: Diagonal 45 deg line, 1 dot -->
  <rect x="20" y="20" width="85" height="85" fill="none" stroke="#000000" stroke-width="2"/>
  <line x1="25" y1="100" x2="100" y2="25" stroke="#000000" stroke-width="2.5"/>
  <circle cx="45" cy="45" r="5" fill="#000000"/>
  <text x="62" y="122" font-family="Arial, sans-serif" font-size="12" font-weight="bold" text-anchor="middle" fill="#000000">(1)</text>

  <!-- Frame 2: Vertical 90 deg line, 2 dots -->
  <rect x="130" y="20" width="85" height="85" fill="none" stroke="#000000" stroke-width="2"/>
  <line x1="172" y1="25" x2="172" y2="100" stroke="#000000" stroke-width="2.5"/>
  <circle cx="152" cy="50" r="5" fill="#000000"/>
  <circle cx="192" cy="75" r="5" fill="#000000"/>
  <text x="172" y="122" font-family="Arial, sans-serif" font-size="12" font-weight="bold" text-anchor="middle" fill="#000000">(2)</text>

  <!-- Frame 3: Diagonal 135 deg line, 3 dots -->
  <rect x="240" y="20" width="85" height="85" fill="none" stroke="#000000" stroke-width="2"/>
  <line x1="245" y1="25" x2="320" y2="100" stroke="#000000" stroke-width="2.5"/>
  <circle cx="260" cy="75" r="5" fill="#000000"/>
  <circle cx="282" cy="45" r="5" fill="#000000"/>
  <circle cx="305" cy="45" r="5" fill="#000000"/>
  <text x="282" y="122" font-family="Arial, sans-serif" font-size="12" font-weight="bold" text-anchor="middle" fill="#000000">(3)</text>

  <!-- Frame 4: Question Mark ''?'' -->
  <rect x="350" y="20" width="85" height="85" fill="#f8fafc" stroke="#000000" stroke-width="2" stroke-dasharray="4,4"/>
  <text x="392" y="73" font-family="Arial, sans-serif" font-size="32" font-weight="bold" text-anchor="middle" fill="#555555">?</text>
  <text x="392" y="122" font-family="Arial, sans-serif" font-size="12" font-weight="bold" text-anchor="middle" fill="#000000">(4)</text>
</svg>',
  '{"a":"A vertical line with 4 black dots","b":"A horizontal line with 4 black dots (2 above and 2 below)","c":"A diagonal line with 3 black dots","d":"A diagonal line at 45° with 5 black dots"}'::jsonb,
  '{"a":"4 काले बिंदुओं वाली एक ऊर्ध्वाधर (Vertical) रेखा","b":"4 काले बिंदुओं वाली एक क्षैतिज (Horizontal) रेखा (2 ऊपर और 2 नीचे)","c":"3 काले बिंदुओं वाली एक विकर्ण रेखा","d":"45° पर 5 काले बिंदुओं वाली एक विकर्ण रेखा"}'::jsonb,
  'b',
  'Two independent geometric transformations occur in the sequence:
1. Rotation of Central Line: The line rotates 45° clockwise in every subsequent step:
   - Frame 1: Diagonal (45°)
   - Frame 2: Vertical (90°)
   - Frame 3: Diagonal (135°)
   - Frame 4: Horizontal (180° / 0°)
2. Number of Black Dots: Increases by 1 in each successive frame:
   - Frame 1: 1 dot
   - Frame 2: 2 dots
   - Frame 3: 3 dots
   - Frame 4: Must contain 4 dots.
Hence, the correct figure replacing (?) is a horizontal line with 4 dots (Option b).

Correct Option: (b)',
  'श्रृंखला में दो समानांतर नियम लागू होते हैं:
1. केंद्रीय रेखा का घूर्णन: रेखा प्रत्येक अगले पद में 45° दक्षिणावर्त (Clockwise) घूमती है:
   - पद 1: 45° (विकर्ण) -> पद 2: 90° (ऊर्ध्वाधर) -> पद 3: 135° (विकर्ण) -> पद 4: 180° (क्षैतिज)।
2. काले बिंदुओं की संख्या: प्रत्येक पद में 1 की वृद्धि होती है:
   - 1 बिंदु -> 2 बिंदु -> 3 बिंदु -> पद 4 में 4 बिंदु होने चाहिए।
अतः सही आकृति 4 बिंदुओं वाली एक क्षैतिज रेखा होगी (विकल्प b)।

अतः सही उत्तर विकल्प (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  61,
  3,
  'PART-3',
  'General Awareness',
  'Physics (Free Fall & Kinematics)',
  'Moderate',
  'A stone is released from the top of a tower of height 45 metres. What is its velocity just before it strikes the ground? (Take g = 10 m/s²)',
  '45 मीटर ऊँचे एक टॉवर के शीर्ष से एक पत्थर को विरामावस्था से छोड़ा जाता है। जमीन से टकराने से ठीक पहले इसका वेग क्या होगा? (g = 10 मी/से² लें)',
  '{"a":"25 m/s","b":"30 m/s","c":"35 m/s","d":"40 m/s"}'::jsonb,
  '{"a":"25 मी/से","b":"30 मी/से","c":"35 मी/से","d":"40 मी/से"}'::jsonb,
  'b',
  'Using third equation of motion under gravity:
v² = u² + 2gh
Here initial velocity u = 0, h = 45 m, g = 10 m/s²:
v² = 0 + 2 × 10 × 45 = 900
v = √900 = 30 m/s.

Correct Option: (b)',
  'गति के तीसरे समीकरण से: v² = u² + 2gh
यहाँ u = 0, h = 45 मीटर, g = 10 मी/से²
v² = 0 + 2 × 10 × 45 = 900 => v = 30 मी/से।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  62,
  3,
  'PART-3',
  'General Awareness',
  'Physics (Current Electricity & Resistance)',
  'Moderate',
  'If a wire of length L and uniform cross-sectional area A has a resistance of 16 Ω, what will be the resistance of another wire of the same material having length 2L and cross-sectional area 2A?',
  'यदि L लंबाई और एकसमान अनुप्रस्थ काट क्षेत्रफल A वाले एक तार का प्रतिरोध 16 Ω है, तो उसी पदार्थ से बने 2L लंबाई और 2A अनुप्रस्थ काट क्षेत्रफल वाले दूसरे तार का प्रतिरोध क्या होगा?',
  '{"a":"8 Ω","b":"16 Ω","c":"32 Ω","d":"64 Ω"}'::jsonb,
  '{"a":"8 Ω","b":"16 Ω","c":"32 Ω","d":"64 Ω"}'::jsonb,
  'b',
  'Resistance formula: R = ρ × (L / A).
For the new wire:
R'' = ρ × (2L / 2A) = ρ × (L / A) = R = 16 Ω.
Since both length and cross-sectional area doubled, the ratio (L/A) remains unchanged.

Correct Option: (b)',
  'प्रतिरोध का सूत्र: R = ρ × (L / A).
नए तार के लिए:
R'' = ρ × (2L / 2A) = ρ × (L / A) = 16 Ω.
चूँकि लंबाई और क्षेत्रफल दोनों दोगुने हो गए हैं, अतः प्रतिरोध अपरिवर्तित रहेगा।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  63,
  3,
  'PART-3',
  'General Awareness',
  'Physics (Optics & Mirror Formula)',
  'Moderate',
  'An object is placed at a distance of 20 cm in front of a concave mirror of focal length 15 cm. What is the distance of the image from the mirror?',
  '15 सेमी फोकस दूरी वाले अवतल दर्पण के सामने 20 सेमी की दूरी पर एक वस्तु रखी गई है। दर्पण से प्रतिबिम्ब की दूरी क्या होगी?',
  '{"a":"-30 cm","b":"-60 cm","c":"+60 cm","d":"-45 cm"}'::jsonb,
  '{"a":"-30 सेमी","b":"-60 सेमी","c":"+60 सेमी","d":"-45 सेमी"}'::jsonb,
  'b',
  'Using the mirror formula: 1/f = 1/v + 1/u.
According to sign convention for concave mirror:
f = -15 cm, u = -20 cm.
1/v = 1/f - 1/u = 1/(-15) - 1/(-20) = -1/15 + 1/20 = (-4 + 3) / 60 = -1/60.
v = -60 cm (real, inverted image formed in front of the mirror).

Correct Option: (b)',
  'दर्पण सूत्र: 1/f = 1/v + 1/u.
चिह्न परिपाटी के अनुसार: f = -15 सेमी, u = -20 सेमी।
1/v = -1/15 - (-1/20) = -1/15 + 1/20 = -1/60 => v = -60 सेमी।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  64,
  3,
  'PART-3',
  'General Awareness',
  'Physics (Electric Power & Joule''s Heating)',
  'Moderate',
  'An electric heater having a resistance of 50 Ω draws a current of 4 A from the mains. How much heat energy (in Joules) is produced by the heater in 2 minutes?',
  '50 Ω प्रतिरोध वाला एक विद्युत हीटर मुख्य लाइन से 4 A की धारा लेता है। 2 मिनट में हीटर द्वारा कितनी ऊष्मा ऊर्जा (जूल में) उत्पन्न होगी?',
  '{"a":"48,000 J","b":"96,000 J","c":"12,000 J","d":"120,000 J"}'::jsonb,
  '{"a":"48,000 जूल","b":"96,000 जूल","c":"12,000 जूल","d":"120,000 जूल"}'::jsonb,
  'b',
  'By Joule''s law of heating: H = I² × R × t
Given: I = 4 A, R = 50 Ω, t = 2 minutes = 2 × 60 = 120 seconds.
H = (4)² × 50 × 120 = 16 × 50 × 120 = 800 × 120 = 96,000 Joules (96 kJ).

Correct Option: (b)',
  'जूल के तापन नियम के अनुसार: H = I² × R × t
दिया है: I = 4 A, R = 50 Ω, t = 2 मिनट = 120 सेकंड।
H = (4)² × 50 × 120 = 16 × 50 × 120 = 96,000 जूल।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  65,
  3,
  'PART-3',
  'General Awareness',
  'Physics (Gravitation & Universal Law)',
  'Moderate',
  'What is the SI unit and accepted value of the Universal Gravitational Constant (G)?',
  'सार्वत्रिक गुरुत्वाकर्षण नियतांक (G) का SI मात्रक और स्वीकृत मान क्या है?',
  '{"a":"6.67 × 10⁻¹¹ N·m²/kg²","b":"6.67 × 10⁻¹¹ N·m/kg","c":"9.8 m/s²","d":"6.67 × 10⁻⁸ N·m²/kg²"}'::jsonb,
  '{"a":"6.67 × 10⁻¹¹ N·m²/kg²","b":"6.67 × 10⁻¹¹ N·m/kg","c":"9.8 m/s²","d":"6.67 × 10⁻⁸ N·m²/kg²"}'::jsonb,
  'a',
  'From Newton''s law of gravitation F = G (m₁ m₂ / r²), we get G = (F × r²) / (m₁ × m₂).
Its SI unit is N·m²/kg² and its experimentally determined value (by Henry Cavendish) is 6.673 × 10⁻¹¹ N·m²/kg².

Correct Option: (a)',
  'न्यूटन के गुरुत्वाकर्षण नियम F = G(m₁m₂/r²) से, G = F·r² / (m₁m₂).
इसका SI मात्रक N·m²/kg² है तथा इसका मान 6.67 × 10⁻¹¹ N·m²/kg² होता है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  66,
  3,
  'PART-3',
  'General Awareness',
  'Chemistry (Periodic Trends & Atomic Radius)',
  'Moderate',
  'As we move from left to right across a period in the Modern Periodic Table, the atomic radius generally:',
  'आधुनिक आवर्त सारणी में किसी आवर्त में बायें से दायें जाने पर परमाणु त्रिज्या सामान्यतः:',
  '{"a":"Increases","b":"Decreases","c":"Remains constant","d":"First decreases then increases"}'::jsonb,
  '{"a":"बढ़ती है","b":"घटती है","c":"अपरिवर्तित रहती है","d":"पहले घटती है फिर बढ़ती है"}'::jsonb,
  'b',
  'Moving left to right across a period, the atomic number (nuclear charge) increases while electrons enter the same principal valence shell. The increased nuclear attraction pulls valence electrons closer to the nucleus, decreasing atomic radius.

Correct Option: (b)',
  'किसी आवर्त में बायें से दायें जाने पर प्रभावी नाभिकीय आवेश बढ़ता है, जिससे बाह्यतम कोश के इलेक्ट्रॉन नाभिक की ओर अधिक आकर्षित होते हैं और परमाणु त्रिज्या घटती है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  67,
  3,
  'PART-3',
  'General Awareness',
  'Chemistry (Acids & Bases in Nature)',
  'Moderate',
  'Which organic acid is naturally present in tomato?',
  'टमाटर में प्राकृतिक रूप से कौन सा कार्बनिक अम्ल उपस्थित होता है?',
  '{"a":"Citric and Oxalic acid","b":"Tartaric acid","c":"Methanoic acid","d":"Lactic acid"}'::jsonb,
  '{"a":"साइट्रिक और ऑक्सालिक अम्ल","b":"टार्टरिक अम्ल","c":"मेथेनॉइक अम्ल","d":"लैक्टिक अम्ल"}'::jsonb,
  'a',
  'Tomatoes naturally contain Oxalic acid and Citric acid. Tartaric acid is found in tamarind, Methanoic (formic) acid in ant stings, and Lactic acid in sour milk/curd.

Correct Option: (a)',
  'टमाटर में मुख्य रूप से ऑक्सालिक अम्ल और साइट्रिक अम्ल पाए जाते हैं। इमली में टार्टरिक अम्ल, चींटी के डंक में मेथेनॉइक अम्ल तथा दही में लैक्टिक अम्ल होता है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  68,
  3,
  'PART-3',
  'General Awareness',
  'Physics/Chemistry (Total Internal Reflection)',
  'Moderate',
  'Optical fibres used in modern high-speed telecommunications transmit light signals based on which optical principle?',
  'आधुनिक उच्च-गति दूरसंचार में उपयोग किए जाने वाले ऑप्टिकल फाइबर (प्रकाशिक तंतु) किस प्रकाशीय सिद्धांत के आधार पर प्रकाश संकेतों का संचरण करते हैं?',
  '{"a":"Diffraction of light","b":"Total Internal Reflection","c":"Interference of light","d":"Polarization of light"}'::jsonb,
  '{"a":"प्रकाश का विवर्तन","b":"पूर्ण आंतरिक परावर्तन (Total Internal Reflection)","c":"प्रकाश का व्यतिकरण","d":"प्रकाश का ध्रुवण"}'::jsonb,
  'b',
  'Optical fibres transmit light by repeated Total Internal Reflection (TIR). Light entering the denser core at an angle greater than the critical angle strikes the core-cladding boundary and undergoes total internal reflection without loss of signal strength.

Correct Option: (b)',
  'ऑप्टिकल फाइबर पूर्ण आंतरिक परावर्तन (Total Internal Reflection) के सिद्धांत पर कार्य करते हैं। जब प्रकाश क्रांतिक कोण से अधिक कोण पर सघन क्रोड में प्रवेश करता है, तो वह बिना ऊर्जा ह्रास के बार-बार परावर्तित होकर आगे बढ़ता है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  69,
  3,
  'PART-3',
  'General Awareness',
  'Chemistry (Chemical Formulas & Hydrates)',
  'Moderate',
  'Plaster of Paris (POP) is chemically calcium sulphate hemihydrate. At what temperature is gypsum (CaSO4·2H2O) heated to produce Plaster of Paris?',
  'प्लास्टर ऑफ पेरिस (POP) रासायनिक रूप से कैल्शियम सल्फेट हेमीहाइड्रेट (CaSO4·1/2H2O) है। इसे बनाने के लिए जिप्सम (CaSO4·2H2O) को किस तापमान पर गर्म किया जाता है?',
  '{"a":"373 K (100°C)","b":"273 K (0°C)","c":"473 K (200°C)","d":"300 K (27°C)"}'::jsonb,
  '{"a":"373 K (100°C)","b":"273 K (0°C)","c":"473 K (200°C)","d":"300 K (27°C)"}'::jsonb,
  'a',
  'When gypsum (CaSO4·2H2O) is heated to 373 K (100°C), it loses three-fourths of its water of crystallization to form calcium sulphate hemihydrate (Plaster of Paris):
CaSO4·2H2O -> CaSO4·(1/2)H2O + 1.5H2O
If heated above 373 K, all water of crystallization is lost, forming anhydrous calcium sulphate (''dead burnt plaster'').

Correct Option: (a)',
  'जब जिप्सम (CaSO4·2H2O) को 373 K (100°C) पर गर्म किया जाता है, तो यह अपने क्रिस्टलन जल का 1.5 अणु त्यागकर कैल्शियम सल्फेट हेमीहाइड्रेट (CaSO4·1/2H2O) बनाता है, जिसे प्लास्टर ऑफ पेरिस कहते हैं।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  70,
  3,
  'PART-3',
  'General Awareness',
  'Chemistry (Chemical Reactions & Displacement)',
  'Moderate',
  'When an iron nail is immersed in a blue copper sulphate (CuSO₄) solution, the color of the solution gradually turns pale green due to the formation of which compound?',
  'जब लोहे की एक कील को नीले कॉपर सल्फेट (CuSO₄) के विलयन में डुबोया जाता है, तो किस यौगिक के बनने के कारण विलयन का रंग धीरे-धीरे हल्का हरा हो जाता है?',
  '{"a":"Iron Oxide","b":"Ferrous Sulphate (FeSO₄)","c":"Copper Oxide","d":"Ferric Hydroxide"}'::jsonb,
  '{"a":"आयरन ऑक्साइड","b":"फेरस सल्फेट (FeSO₄)","c":"कॉपर ऑक्साइड","d":"फेरिक हाइड्रॉक्साइड"}'::jsonb,
  'b',
  'Iron is more reactive than copper in the metal activity series. It displaces copper from copper sulphate solution:
Fe + CuSO₄ (blue) → FeSO₄ (pale green) + Cu (reddish-brown deposit).

Correct Option: (b)',
  'आयरन कॉपर से अधिक क्रियाशील धातु है। यह कॉपर को विस्थापित कर फेरस सल्फेट (FeSO₄) बनाता है:
Fe + CuSO₄ (नीला) → FeSO₄ (हल्का हरा) + Cu (भूरा निक्षेप)।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  71,
  3,
  'PART-3',
  'General Awareness',
  'Biology (Cell Division - Meiosis Crossing Over)',
  'Moderate',
  'Crossing over (recombination of genetic material between homologous chromosomes) takes place during which sub-stage of Prophase-I in meiosis?',
  'अर्धसूत्रीविभाजन (Meiosis) के प्रोफेज-I की किस उप-अवस्था के दौरान क्रॉसिंग ओवर (जीन विनिमय) होता है?',
  '{"a":"Leptotene","b":"Zygotene","c":"Pachytene","d":"Diakinesis"}'::jsonb,
  '{"a":"लेप्टोटीन","b":"जाइगोटीन","c":"पैचीटीन (Pachytene)","d":"डायकाइनेसिस"}'::jsonb,
  'c',
  'Crossing over between non-sister chromatids of homologous chromosomes occurs during the Pachytene stage of Prophase-I, facilitated by the enzyme recombinase.

Correct Option: (c)',
  'समजात गुणसूत्रों के गैर-सहोदर क्रोमैटिड्स के बीच क्रॉसिंग ओवर (जीन विनिमय) प्रोफेज-I की पैचीटीन (Pachytene) उप-अवस्था में रिकॉम्बिनेज एंजाइम द्वारा होता है।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  72,
  3,
  'PART-3',
  'General Awareness',
  'Biology (Human Respiratory System & Alveoli)',
  'Moderate',
  'In human beings, where does the exchange of gases (oxygen and carbon dioxide) actually occur in the lungs?',
  'मनुष्य के फेफड़ों में गैसों (ऑक्सीजन और कार्बन डाइऑक्साइड) का वास्तविक विनिमय कहाँ होता है?',
  '{"a":"Trachea","b":"Bronchioles","c":"Alveoli","d":"Larynx"}'::jsonb,
  '{"a":"श्वासनली (Trachea)","b":"श्वसनिका (Bronchioles)","c":"कूपिकाएँ (Alveoli)","d":"कंठ (Larynx)"}'::jsonb,
  'c',
  'Alveoli are balloon-like microstructures with extremely thin epithelial walls surrounded by extensive capillary networks. They provide a massive surface area for diffusion of oxygen into blood and CO₂ out of blood.

Correct Option: (c)',
  'फेफड़ों में कूपिकाएँ (Alveoli) गुब्बारेनुमा सूक्ष्म संरचनाएँ हैं जिनकी पतली झिल्ली के चारों ओर रक्त केशिकाओं का घना जाल होता है, जहाँ गैसों का वास्तविक विनिमय होता है।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  73,
  3,
  'PART-3',
  'General Awareness',
  'Biology (Human Nervous System & Medulla)',
  'Moderate',
  'Which part of the human brain regulates involuntary actions like heartbeat, blood pressure, and peristalsis?',
  'मानव मस्तिष्क का कौन सा भाग हृदय की धड़कन, रक्तचाप और क्रमाकुंचन (peristalsis) जैसी अनैच्छिक क्रियाओं को नियंत्रित करता है?',
  '{"a":"Cerebrum","b":"Cerebellum","c":"Medulla Oblongata","d":"Hypothalamus"}'::jsonb,
  '{"a":"प्रमस्तिष्क (Cerebrum)","b":"अनुमस्तिष्क (Cerebellum)","c":"मेडुला ऑबलांगाटा (Medulla Oblongata)","d":"हाइपोथैलेमस"}'::jsonb,
  'c',
  'The Medulla Oblongata (part of the hindbrain) controls autonomic involuntary functions such as cardiac rate, respiration, vasomotor reflexes, and swallowing/vomiting.

Correct Option: (c)',
  'पश्च मस्तिष्क में स्थित मेडुला ऑबलांगाटा (Medulla Oblongata) हृदय गति, रक्तचाप, उल्टी आना और श्वसन जैसी जीवन रक्षक अनैच्छिक क्रियाओं का मुख्य केंद्र है।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  74,
  3,
  'PART-3',
  'General Awareness',
  'Biology (Plant Tissues & Sclerenchyma)',
  'Moderate',
  'The husk of a coconut is made up of which type of plant tissue?',
  'नारियल का रेशेदार छिलका (husk) किस प्रकार के पादप ऊतक से बना होता है?',
  '{"a":"Parenchyma","b":"Collenchyma","c":"Sclerenchyma","d":"Aerenchyma"}'::jsonb,
  '{"a":"मृदूतक (Parenchyma)","b":"स्थूलकोण ऊतक (Collenchyma)","c":"दृढ़ोतक (Sclerenchyma)","d":"वायुतक (Aerenchyma)"}'::jsonb,
  'c',
  'The husk of coconut consists of sclerenchymatous fibers. Sclerenchyma cells are dead, long, narrow, and have heavily lignified thick walls providing mechanical stiffness and protection.

Correct Option: (c)',
  'नारियल का छिलका दृढ़ोतक (Sclerenchyma) रेशों से बना होता है। ये मृत कोशिकाएं होती हैं जिनकी भित्तियाँ लिग्निन के जमाव के कारण अत्यधिक मोटी और कठोर होती हैं।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  75,
  3,
  'PART-3',
  'General Awareness',
  'Indian History (Modern - Dandi Salt March)',
  'Moderate',
  'The historic Dandi March (Salt Satyagraha) was launched by Mahatma Gandhi in 1930 from which place?',
  'महात्मा गांधी द्वारा 1930 में ऐतिहासिक दांडी मार्च (नमक सत्याग्रह) किस स्थान से प्रारंभ किया गया था?',
  '{"a":"Champaran","b":"Sabarmati Ashram (Ahmedabad)","c":"Wardha","d":"Sevagram"}'::jsonb,
  '{"a":"चंपारण","b":"साबरमती आश्रम (अहमदाबाद)","c":"वर्धा","d":"सेवाग्राम"}'::jsonb,
  'b',
  'Mahatma Gandhi began the Dandi March on 12 March 1930 from Sabarmati Ashram with 78 followers and walked 241 miles to the coastal village of Dandi, breaking the salt law on 6 April 1930 to inaugurate the Civil Disobedience Movement.

Correct Option: (b)',
  'महात्मा गांधी ने 12 मार्च 1930 को साबरमती आश्रम (अहमदाबाद) से 78 अनुयायियों के साथ दांडी मार्च शुरू किया और 6 अप्रैल 1930 को दांडी पहुँचकर नमक कानून तोड़ा।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  76,
  3,
  'PART-3',
  'General Awareness',
  'Indian History (Ancient - Kailash Temple Ellora)',
  'Moderate',
  'The famous rock-cut Kailash Temple at Ellora (Cave 16) was built during the reign of which dynasty?',
  'एलोरा का प्रसिद्ध शैलकृत कैलाश मंदिर (गुफा संख्या 16) किस राजवंश के शासनकाल में बनवाया गया था?',
  '{"a":"Chola Dynasty","b":"Rashtrakuta Dynasty","c":"Pallava Dynasty","d":"Chalukya Dynasty"}'::jsonb,
  '{"a":"चोल राजवंश","b":"राष्ट्रकूट राजवंश","c":"पल्लव राजवंश","d":"चालुक्य राजवंश"}'::jsonb,
  'b',
  'The Kailash Temple at Ellora (Maharashtra) is a monolithic rock-cut monument commissioned by the Rashtrakuta King Krishna I (756–774 CE).

Correct Option: (b)',
  'एलोरा का कैलाश मंदिर एकाश्म चट्टान को काटकर बनाया गया एक भव्य मंदिर है, जिसका निर्माण राष्ट्रकूट राजा कृष्ण प्रथम (8वीं शताब्दी) ने करवाया था।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  77,
  3,
  'PART-3',
  'General Awareness',
  'Indian History (Modern - Indian National Congress)',
  'Moderate',
  'Who was the founder of the Indian National Congress (INC) in December 1885, and who presided over its first session in Bombay?',
  'दिसंबर 1885 में भारतीय राष्ट्रीय कांग्रेस (INC) के संस्थापक कौन थे और बॉम्बे में इसके पहले अधिवेशन की अध्यक्षता किसने की थी?',
  '{"a":"A.O. Hume; W.C. Bonnerjee","b":"Dadabhai Naoroji; Dinshaw Wacha","c":"Surendranath Banerjee; Gopal Krishna Gokhale","d":"Lord Dufferin; Badruddin Tyabji"}'::jsonb,
  '{"a":"ए.ओ. ह्यूम; व्योमेश चंद्र बनर्जी (W.C. Bonnerjee)","b":"दादाभाई नौरोजी; दिनशा वाचा","c":"सुरेंद्रनाथ बनर्जी; गोपाल कृष्ण गोखले","d":"लॉर्ड डफरिन; बदरुद्दीन तैयबजी"}'::jsonb,
  'a',
  'The Indian National Congress was founded by retired British civil servant Allan Octavian Hume (A.O. Hume) in December 1885. The first session was held at Gokuldas Tejpal Sanskrit College, Bombay, presided over by Womesh Chandra Bonnerjee (W.C. Bonnerjee) with 72 delegates.

Correct Option: (a)',
  'भारतीय राष्ट्रीय कांग्रेस की स्थापना ए.ओ. ह्यूम (A.O. Hume) ने दिसंबर 1885 में की थी। इसके पहले अधिवेशन की अध्यक्षता व्योमेश चंद्र बनर्जी ने बॉम्बे में की थी जिसमें 72 प्रतिनिधियों ने भाग लिया था।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  78,
  3,
  'PART-3',
  'General Awareness',
  'Indian History (Medieval - Mughal Architecture)',
  'Moderate',
  'Which Mughal Emperor commissioned the construction of the Red Fort (Lal Qila) and Jama Masjid in Delhi?',
  'किस मुगल सम्राट ने दिल्ली में लाल किला और जामा मस्जिद का निर्माण करवाया था?',
  '{"a":"Akbar","b":"Jahangir","c":"Shah Jahan","d":"Aurangzeb"}'::jsonb,
  '{"a":"अकबर","b":"जहाँगीर","c":"शाहजहाँ","d":"औरंगजेब"}'::jsonb,
  'c',
  'Shah Jahan (reigned 1628–1658) shifted the Mughal capital from Agra to Delhi (Shahjahanabad) in 1638 and commissioned the Red Fort (completed in 1648) and the grand Jama Masjid.

Correct Option: (c)',
  'मुगल सम्राट शाहजहाँ ने अपनी राजधानी आगरा से दिल्ली स्थानांतरित की और लाल किला तथा जामा मस्जिद का भव्य निर्माण करवाया।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  79,
  3,
  'PART-3',
  'General Awareness',
  'Indian History (Modern - Battle of Plassey 1757)',
  'Moderate',
  'On which date was the decisive Battle of Plassey fought between the British East India Company under Robert Clive and Siraj-ud-Daulah, the Nawab of Bengal?',
  'रॉबर्ट क्लाइव के नेतृत्व में ब्रिटिश ईस्ट इंडिया कंपनी और बंगाल के नवाब सिराजुद्दौला के बीच प्लासी का निर्णायक युद्ध किस तिथि को लड़ा गया था?',
  '{"a":"23 June 1757","b":"22 October 1764","c":"14 January 1761","d":"10 May 1857"}'::jsonb,
  '{"a":"23 जून 1757","b":"22 अक्टूबर 1764","c":"14 जनवरी 1761","d":"10 मई 1857"}'::jsonb,
  'a',
  'The Battle of Plassey was fought on 23 June 1757 along the Bhagirathi River in Bengal. Clive defeated Siraj-ud-Daulah due to the treachery of Mir Jafar, establishing British political dominance in India.

Correct Option: (a)',
  'प्लासी का युद्ध 23 जून 1757 को लड़ा गया था, जिसमें रॉबर्ट क्लाइव ने मीर जाफर के विश्वासघात के कारण नवाब सिराजुद्दौला को हराकर भारत में ब्रिटिश शासन की नींव रखी।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  80,
  3,
  'PART-3',
  'General Awareness',
  'Indian Geography (Rift Valley Rivers - Narmada)',
  'Moderate',
  'Which of the following west-flowing rivers flows through a rift valley between the Vindhya and Satpura mountain ranges?',
  'निम्नलिखित में से कौन सी पश्चिम की ओर बहने वाली नदी विंध्य और सतपुड़ा पर्वत श्रृंखलाओं के बीच भ्रंश घाटी (Rift Valley) से होकर बहती है?',
  '{"a":"Godavari","b":"Narmada","c":"Mahanadi","d":"Krishna"}'::jsonb,
  '{"a":"गोदावरी","b":"नर्मदा","c":"महानदी","d":"कृष्णा"}'::jsonb,
  'b',
  'The Narmada River originates from the Amarkantak plateau in Madhya Pradesh and flows westward through a linear tectonic rift valley between the Vindhya range (north) and Satpura range (south) before emptying into the Arabian Sea.

Correct Option: (b)',
  'नर्मदा नदी अमरकंटक से निकलकर विंध्य (उत्तर) और सतपुड़ा (दक्षिण) के बीच भ्रंश घाटी से होकर पश्चिम की ओर बहती है और अरब सागर (खंभात की खाड़ी) में गिरती है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  81,
  3,
  'PART-3',
  'General Awareness',
  'Indian Geography (Black Regur Soil & Agriculture)',
  'Moderate',
  'Black soil, extensively found in the Deccan Lava Plateau and ideal for cotton cultivation, is also known by which name?',
  'दक्कन के लावा पठार में पाई जाने वाली और कपास की खेती के लिए सर्वाधिक उपयुक्त काली मिट्टी को किस अन्य नाम से भी जाना जाता है?',
  '{"a":"Khadar soil","b":"Regur soil","c":"Bangar soil","d":"Laterite soil"}'::jsonb,
  '{"a":"खादर मिट्टी","b":"रेगुर मिट्टी (Regur soil)","c":"बांगर मिट्टी","d":"लेटराइट मिट्टी"}'::jsonb,
  'b',
  'Black soil is popularly called ''Regur soil'' (from Telugu reguda) or ''Black Cotton Soil''. It has high moisture retention capacity and is rich in montmorillonite clay.

Correct Option: (b)',
  'काली मिट्टी को ''रेगुर मिट्टी'' या ''काली कपास मिट्टी'' भी कहा जाता है। इसमें जल धारण की असाधारण क्षमता होती है और यह बेसाल्टिक लावा के अपक्षय से बनती है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  82,
  3,
  'PART-3',
  'General Awareness',
  'Indian Geography (Majuli River Island - Brahmaputra)',
  'Moderate',
  'Majuli, officially recognized by Guinness World Records as the largest inhabited river island in the world, is situated on which river in Assam?',
  'गिनीज वर्ल्ड रिकॉर्ड्स द्वारा दुनिया के सबसे बड़े बसे हुए नदी द्वीप के रूप में मान्यता प्राप्त ''माजुली'' द्वीप असम में किस नदी पर स्थित है?',
  '{"a":"Brahmaputra River","b":"Ganga River","c":"Godavari River","d":"Barak River"}'::jsonb,
  '{"a":"ब्रह्मपुत्र नदी (Brahmaputra)","b":"गंगा नदी","c":"गोदावरी नदी","d":"बराक नदी"}'::jsonb,
  'a',
  'Majuli is a large riverine island formed by the Brahmaputra River and the Kherkutia Xuti (an anabranch) in Assam. In September 2016, it became the first island in India to be made a full-fledged administrative district.

Correct Option: (a)',
  'माजुली द्वीप असम में ब्रह्मपुत्र नदी के मध्य में स्थित है। यह विश्व का सबसे बड़ा नदी द्वीप है और 2016 में भारत का पहला द्वीप जिला बना। यह नव-वैष्णव संस्कृति का प्रमुख केंद्र है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  83,
  3,
  'PART-3',
  'General Awareness',
  'Indian Geography (Tropic of Cancer in India)',
  'Moderate',
  'Through how many Indian states does the Tropic of Cancer (23.5° N latitude) pass?',
  'कर्क रेखा (23.5° N अक्षांश) भारत के कितने राज्यों से होकर गुजरती है?',
  '{"a":"6 states","b":"7 states","c":"8 states","d":"9 states"}'::jsonb,
  '{"a":"6 राज्य","b":"7 राज्य","c":"8 राज्य","d":"9 राज्य"}'::jsonb,
  'c',
  'The Tropic of Cancer passes through 8 Indian states (from west to east): Gujarat, Rajasthan, Madhya Pradesh, Chhattisgarh, Jharkhand, West Bengal, Tripura, and Mizoram.

Correct Option: (c)',
  'कर्क रेखा भारत के 8 राज्यों से होकर गुजरती है: गुजरात, राजस्थान, मध्य प्रदेश, छत्तीसगढ़, झारखंड, पश्चिम बंगाल, त्रिपुरा और मिजोरम।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  84,
  3,
  'PART-3',
  'General Awareness',
  'Indian Polity (Election Commission of India)',
  'Moderate',
  'Under Article 324 of the Constitution of India, what is the official tenure of the Chief Election Commissioner (CEC) of India?',
  'भारतीय संविधान के अनुच्छेद 324 के तहत भारत के मुख्य चुनाव आयुक्त (CEC) का आधिकारिक कार्यकाल कितना होता है?',
  '{"a":"6 years or up to 65 years of age, whichever is earlier","b":"5 years or up to 65 years of age, whichever is earlier","c":"6 years or up to 62 years of age, whichever is earlier","d":"5 years or up to 60 years of age, whichever is earlier"}'::jsonb,
  '{"a":"6 वर्ष या 65 वर्ष की आयु, जो भी पहले हो","b":"5 वर्ष या 65 वर्ष की आयु, जो भी पहले हो","c":"6 वर्ष या 62 वर्ष की आयु, जो भी पहले हो","d":"5 वर्ष या 60 वर्ष की आयु, जो भी पहले हो"}'::jsonb,
  'a',
  'The Chief Election Commissioner and Election Commissioners hold office for a term of 6 years or until they attain the age of 65 years, whichever is earlier. They enjoy the same status and salary as Judges of the Supreme Court of India.

Correct Option: (a)',
  'भारत के मुख्य चुनाव आयुक्त और अन्य चुनाव आयुक्तों का कार्यकाल 6 वर्ष या 65 वर्ष की आयु तक (जो भी पहले हो) होता है। उन्हें सर्वोच्च न्यायालय के न्यायाधीश के समान दर्जा प्राप्त होता है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  85,
  3,
  'PART-3',
  'General Awareness',
  'Indian Polity (42nd Constitutional Amendment 1976)',
  'Moderate',
  'Which three words were added to the Preamble of the Constitution of India by the 42nd Constitutional Amendment Act, 1976?',
  '42वें संविधान संशोधन अधिनियम, 1976 द्वारा भारतीय संविधान की प्रस्तावना में कौन से तीन शब्द जोड़े गए थे?',
  '{"a":"Socialist, Secular, Integrity","b":"Sovereign, Democratic, Republic","c":"Liberty, Equality, Fraternity","d":"Justice, Liberty, Socialist"}'::jsonb,
  '{"a":"समाजवादी, पंथनिरपेक्ष, अखंडता (Socialist, Secular, Integrity)","b":"संप्रभु, लोकतांत्रिक, गणराज्य","c":"स्वतंत्रता, समानता, बंधुत्व","d":"न्याय, स्वतंत्रता, समाजवादी"}'::jsonb,
  'a',
  'The 42nd Constitutional Amendment Act of 1976 amended the Preamble to add three new terms: ''Socialist'', ''Secular'', and ''Integrity''.

Correct Option: (a)',
  '1976 के 42वें संविधान संशोधन द्वारा प्रस्तावना में ''समाजवादी'', ''पंथनिरपेक्ष'' और ''अखंडता'' शब्द जोड़े गए थे।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  86,
  3,
  'PART-3',
  'General Awareness',
  'Indian Polity (Lok Sabha Qualifications)',
  'Moderate',
  'What is the minimum age prescribed by the Constitution to be eligible for election as a member of the Lok Sabha?',
  'लोकसभा सदस्य के रूप में चुनाव लड़ने के लिए संविधान द्वारा निर्धारित न्यूनतम आयु क्या है?',
  '{"a":"21 years","b":"25 years","c":"30 years","d":"35 years"}'::jsonb,
  '{"a":"21 वर्ष","b":"25 वर्ष","c":"30 वर्ष","d":"35 वर्ष"}'::jsonb,
  'b',
  'Under Article 84(b) of the Constitution of India, a person must be not less than 25 years of age to be qualified to be chosen as a member of the Lok Sabha (and not less than 30 years for Rajya Sabha).

Correct Option: (b)',
  'अनुच्छेद 84(b) के अनुसार लोकसभा सदस्य बनने के लिए न्यूनतम आयु 25 वर्ष (और राज्यसभा के लिए 30 वर्ष) होनी चाहिए।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  87,
  3,
  'PART-3',
  'General Awareness',
  'Indian Polity (Article 352 National Emergency)',
  'Moderate',
  'Under which Article of the Constitution of India can the President proclaim a National Emergency on grounds of war, external aggression, or armed rebellion?',
  'भारतीय संविधान के किस अनुच्छेद के तहत राष्ट्रपति युद्ध, बाह्य आक्रमण या सशस्त्र विद्रोह के आधार पर राष्ट्रीय आपातकाल की घोषणा कर सकते हैं?',
  '{"a":"Article 352","b":"Article 356","c":"Article 360","d":"Article 368"}'::jsonb,
  '{"a":"अनुच्छेद 352","b":"अनुच्छेद 356","c":"अनुच्छेद 360","d":"अनुच्छेद 368"}'::jsonb,
  'a',
  'Article 352 deals with the Proclamation of National Emergency. Article 356 deals with President''s Rule in States (State Emergency), and Article 360 deals with Financial Emergency.

Correct Option: (a)',
  'अनुच्छेद 352 के तहत राष्ट्रपति राष्ट्रीय आपातकाल की घोषणा करते हैं। अनुच्छेद 356 राज्य में राष्ट्रपति शासन तथा अनुच्छेद 360 वित्तीय आपातकाल से संबंधित है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  88,
  3,
  'PART-3',
  'General Awareness',
  'Indian Economy (RBI Lender of Last Resort)',
  'Moderate',
  'Which institution in India acts as the ''Lender of Last Resort'' for the commercial banking system?',
  'भारत में कौन सा संस्थान वाणिज्यिक बैंकिंग प्रणाली के लिए ''अंतिम ऋणदाता'' (Lender of Last Resort) के रूप में कार्य करता है?',
  '{"a":"State Bank of India (SBI)","b":"Reserve Bank of India (RBI)","c":"Ministry of Finance","d":"National Bank for Agriculture and Rural Development (NABARD)"}'::jsonb,
  '{"a":"भारतीय स्टेट बैंक (SBI)","b":"भारतीय रिज़र्व बैंक (RBI)","c":"वित्त मंत्रालय","d":"नाबार्ड (NABARD)"}'::jsonb,
  'b',
  'The Reserve Bank of India (RBI) functions as the Lender of Last Resort to provide emergency liquidity assistance to solvent banks facing temporary liquidity crunches, safeguarding financial stability.

Correct Option: (b)',
  'भारतीय रिज़र्व बैंक (RBI) संकट के समय वाणिज्यिक बैंकों को तरलता सहायता प्रदान करके देश की वित्तीय स्थिरता की रक्षा हेतु ''अंतिम ऋणदाता'' के रूप में कार्य करता है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  89,
  3,
  'PART-3',
  'General Awareness',
  'Indian Economy (National Income & GDP)',
  'Moderate',
  'Gross Domestic Product (GDP) is defined as the total monetary market value of all:',
  'सकल घरेलू उत्पाद (GDP) को किसके कुल मौद्रिक बाजार मूल्य के रूप में परिभाषित किया जाता है?',
  '{"a":"Intermediate goods produced within a country in a year","b":"Final goods and services produced within the domestic territory of a country in a specified time period","c":"Consumer goods consumed in a country","d":"Export goods sent abroad"}'::jsonb,
  '{"a":"एक वर्ष में देश के भीतर उत्पादित मध्यवर्ती वस्तुएं","b":"एक निश्चित समय अवधि में देश की घरेलू सीमा के भीतर उत्पादित सभी अंतिम वस्तुओं और सेवाओं","c":"देश में उपभोग की जाने वाली उपभोक्ता वस्तुएं","d":"विदेशों में भेजी जाने वाली निर्यात वस्तुएं"}'::jsonb,
  'b',
  'GDP represents the total monetary value of all final goods and services produced within the geographic borders of a nation during a specific time period (usually a financial year).

Correct Option: (b)',
  'सकल घरेलू उत्पाद (GDP) किसी देश की भौगोलिक सीमा के भीतर एक वित्तीय वर्ष में उत्पादित सभी अंतिम वस्तुओं और सेवाओं का कुल मौद्रिक बाजार मूल्य होता है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  90,
  3,
  'PART-3',
  'General Awareness',
  'Indian Economy (NITI Aayog Policy)',
  'Moderate',
  'What is the full form of NITI Aayog, which replaced the 65-year-old Planning Commission of India on 1 January 2015?',
  '1 जनवरी 2015 को योजना आयोग के स्थान पर गठित ''नीति आयोग'' (NITI Aayog) का पूर्ण रूप क्या है?',
  '{"a":"National Institute for Transforming India","b":"National Institution for Transforming India","c":"National Initiative for Technical India","d":"National Integration for Trade in India"}'::jsonb,
  '{"a":"नेशनल इंस्टीट्यूट फॉर ट्रांसफॉर्मिंग इंडिया","b":"नेशनल इंस्टीट्यूशन फॉर ट्रांसफॉर्मिंग इंडिया (National Institution for Transforming India)","c":"नेशनल इनिशिएटिव फॉर टेक्निकल इंडिया","d":"नेशनल इंटीग्रेशन फॉर ट्रेड इन इंडिया"}'::jsonb,
  'b',
  'NITI Aayog stands for ''National Institution for Transforming India''. It serves as the apex public policy think tank of the Government of India, headed by the Prime Minister as its Chairperson.

Correct Option: (b)',
  'नीति आयोग का पूर्ण रूप ''National Institution for Transforming India'' (राष्ट्रीय भारत परिवर्तन संस्थान) है। प्रधानमंत्री इसके पदेन अध्यक्ष होते हैं।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  91,
  3,
  'PART-3',
  'General Awareness',
  'Indian Railways GK (Northern Railway Headquarters)',
  'Moderate',
  'Where is the headquarters of the Northern Railway (NR) zone of Indian Railways situated?',
  'भारतीय रेलवे के उत्तर रेलवे (Northern Railway) ज़ोन का मुख्यालय कहाँ स्थित है?',
  '{"a":"Gorakhpur","b":"New Delhi","c":"Prayagraj","d":"Jaipur"}'::jsonb,
  '{"a":"गोरखपुर","b":"नई दिल्ली (New Delhi)","c":"प्रयागराज","d":"जयपुर"}'::jsonb,
  'b',
  'The headquarters of Northern Railway (the largest railway zone by route route length in India) is located at Baroda House, New Delhi.

Correct Option: (b)',
  'उत्तर रेलवे (NR) का मुख्यालय बड़ौदा हाउस, नई दिल्ली में स्थित है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  92,
  3,
  'PART-3',
  'General Awareness',
  'Indian Railways GK (Hubballi Junction Platform Record)',
  'Moderate',
  'Which railway station currently holds the Guinness World Record for the longest railway platform in the world (1,507 metres long)?',
  'वर्तमान में किस रेलवे स्टेशन के पास 1,507 मीटर लंबे विश्व के सबसे लंबे रेलवे प्लेटफॉर्म का गिनीज वर्ल्ड रिकॉर्ड है?',
  '{"a":"Gorakhpur Junction (Uttar Pradesh)","b":"Kollam Junction (Kerala)","c":"Shree Siddharoodha Swamiji Hubballi Station (Karnataka)","d":"Kharagpur Railway Station (West Bengal)"}'::jsonb,
  '{"a":"गोरखपुर जंक्शन (उत्तर प्रदेश)","b":"कोल्लम जंक्शन (केरल)","c":"श्री सिद्धारूढ़ स्वामीजी हुबली स्टेशन (कर्नाटक)","d":"खड़गपुर रेलवे स्टेशन (पश्चिम बंगाल)"}'::jsonb,
  'c',
  'Platform No. 8 of Shree Siddharoodha Swamiji Hubballi Junction (SWR) in Karnataka measures 1,507 metres, making it the longest railway platform in the world, certified by Guinness World Records in March 2023 (surpassing Gorakhpur''s 1,366 m).

Correct Option: (c)',
  'कर्नाटक के श्री सिद्धारूढ़ स्वामीजी हुबली जंक्शन का प्लेटफॉर्म नंबर 8 (1,507 मीटर) वर्तमान में विश्व का सबसे लंबा रेलवे प्लेटफॉर्म है।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  93,
  3,
  'PART-3',
  'General Awareness',
  'Indian Railways GK (Kavach Indigenous ATP System)',
  'Moderate',
  'What is ''KAVACH'', indigenously developed by the Indian Railways?',
  'भारतीय रेल द्वारा स्वदेशी रूप से विकसित ''कवच'' (KAVACH) क्या है?',
  '{"a":"An anti-collision automatic train protection (ATP) system","b":"Bullet-proof passenger coaches","c":"A railway satellite surveillance system","d":"An automated ticket vending machine"}'::jsonb,
  '{"a":"ट्रेनों की टक्कर रोकने वाली स्वचालित सुरक्षा प्रणाली (Automatic Train Protection - ATP)","b":"बुलेटप्रूफ बोगियां","c":"रेलवे उपग्रह निगरानी प्रणाली","d":"स्वचालित टिकट वेंडिंग मशीन"}'::jsonb,
  'a',
  'Kavach is an indigenous Automatic Train Protection (ATP) system certified to Safety Integrity Level-4 (SIL-4) to prevent collisions caused by signal passing at danger.',
  '''कवच'' भारतीय रेल की स्वदेशी ऑटोमैटिक ट्रेन प्रोटेक्शन प्रणाली है जो ट्रेनों को आमने-सामने की टक्कर से बचाती है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  94,
  3,
  'PART-3',
  'General Awareness',
  'Indian Railways GK (Vande Bharat - ICF Chennai)',
  'Moderate',
  'India''s indigenous semi-high speed train, Vande Bharat Express (initially known as Train 18), was designed and manufactured by which Indian Railways production unit?',
  'भारत की स्वदेशी सेमी-हाई स्पीड ट्रेन ''वंदे भारत एक्सप्रेस'' (शुरुआत में ट्रेन 18 के नाम से जानी गई) को भारतीय रेलवे की किस उत्पादन इकाई द्वारा डिजाइन और निर्मित किया गया था?',
  '{"a":"Chittaranjan Locomotive Works (CLW), Asansol","b":"Integral Coach Factory (ICF), Chennai","c":"Rail Coach Factory (RCF), Kapurthala","d":"Diesel Locomotive Works (DLW), Varanasi"}'::jsonb,
  '{"a":"चित्तरंजन लोकोमोटिव वर्क्स (CLW), आसनसोल","b":"सवारी डिब्बा कारखाना (ICF), चेन्नई","c":"रेल कोच फैक्ट्री (RCF), कपूरथला","d":"डीजल रेलइंजन कारखाना (DLW), वाराणसी"}'::jsonb,
  'b',
  'Vande Bharat Express (Train 18) was designed and manufactured by the Integral Coach Factory (ICF) at Perambur, Chennai under the ''Make in India'' initiative. The first Vande Bharat train was flagged off on February 15, 2019, between New Delhi and Varanasi.

Correct Option: (b)',
  'वंदे भारत एक्सप्रेस (ट्रेन 18) को इंटीग्रल कोच फैक्ट्री (ICF), चेन्नई द्वारा ''मेक इन इंडिया'' पहल के तहत स्वदेशी रूप से डिजाइन और निर्मित किया गया था। पहली वंदे भारत ट्रेन 15 फरवरी 2019 को नई दिल्ली से वाराणसी के बीच शुरू की गई थी।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  95,
  3,
  'PART-3',
  'General Awareness',
  'Current Affairs & Tech (ISRO Gaganyaan Mission)',
  'Moderate',
  'What is the official project name of India''s first indigenous human spaceflight mission aiming to send astronauts to Low Earth Orbit (LEO)?',
  'अंतरिक्ष यात्रियों को पृथ्वी की निचली कक्षा (LEO) में भेजने के लिए इसरो द्वारा संचालित भारत के पहले स्वदेशी मानव अंतरिक्ष उड़ान मिशन का आधिकारिक नाम क्या है?',
  '{"a":"Gaganyaan","b":"Mangalyaan-2","c":"Shukrayaan","d":"Vyommitra"}'::jsonb,
  '{"a":"गगनयान (Gaganyaan)","b":"मंगलयान-2","c":"शुक्रयान","d":"व्योममित्र"}'::jsonb,
  'a',
  'Gaganyaan is ISRO''s flagship human spaceflight programme aimed at demonstrating human spaceflight capability by sending a crew of astronauts to an orbit of 400 km for a 3-day mission and returning them safely to Earth.

Correct Option: (a)',
  'गगनयान (Gaganyaan) इसरो का महत्वाकांक्षी मानवयुक्त अंतरिक्ष मिशन है, जिसका उद्देश्य 3 सदस्यीय चालक दल को 400 किमी की निचली कक्षा में भेजकर सुरक्षित वापस लाना है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  96,
  3,
  'PART-3',
  'General Awareness',
  'Current Affairs & Sports (Badminton World Championships)',
  'Moderate',
  'The prestigious ''Thomas Cup'' (Men''s) and ''Uber Cup'' (Women''s) are premier world team championships associated with which sport?',
  'प्रतिष्ठित ''थॉमस कप'' (पुरुष) और ''उबेर कप'' (महिला) किस खेल से संबंधित प्रमुख विश्व टीम चैंपियनशिप हैं?',
  '{"a":"Lawn Tennis","b":"Badminton","c":"Table Tennis","d":"Squash"}'::jsonb,
  '{"a":"लॉन टेनिस","b":"बैडमिंटन (Badminton)","c":"टेबल टेनिस","d":"स्क्वैश"}'::jsonb,
  'b',
  'The Thomas Cup and Uber Cup are the premier international team tournaments in Badminton governed by the Badminton World Federation (BWF). India made history by winning its maiden Thomas Cup title in 2022.

Correct Option: (b)',
  'थॉमस कप और उबेर कप बैडमिंटन (Badminton) की प्रतिष्ठित अंतरराष्ट्रीय टीम प्रतियोगिताएं हैं। भारत ने 2022 में ऐतिहासिक रूप से थॉमस कप जीता था।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  97,
  3,
  'PART-3',
  'General Awareness',
  'Computer & IT (India''s First Supercomputer - PARAM 8000)',
  'Moderate',
  'What was the name of India''s first indigenously developed supercomputer built by C-DAC Pune in 1991 under the leadership of Dr. Vijay Bhatkar?',
  'डॉ. विजय भटकर के नेतृत्व में 1991 में C-DAC पुणे द्वारा विकसित भारत के पहले स्वदेशी सुपरकंप्यूटर का क्या नाम था?',
  '{"a":"PARAM 8000","b":"PARAM Shivay","c":"Pratyush","d":"Mihir"}'::jsonb,
  '{"a":"परम 8000 (PARAM 8000)","b":"परम शिवाय","c":"प्रत्युष","d":"मिहिर"}'::jsonb,
  'a',
  'PARAM 8000 was unveiled in 1991 by the Centre for Development of Advanced Computing (C-DAC), Pune, marking India''s entry into supercomputing capability.

Correct Option: (a)',
  'C-DAC पुणे द्वारा 1991 में विकसित ''परम 8000'' (PARAM 8000) भारत का पहला स्वदेशी सुपरकंप्यूटर था।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  98,
  3,
  'PART-3',
  'General Awareness',
  'Computer & IT (Computer Memory & Architecture)',
  'Moderate',
  'Which type of computer memory is volatile in nature, meaning it loses its stored contents immediately when the electrical power is switched off?',
  'कंप्यूटर की कौन सी मेमोरी प्रकृति में अस्थिर (Volatile) होती है, जिसका अर्थ है कि बिजली बंद होते ही इसमें संग्रहीत डेटा तुरंत नष्ट हो जाता है?',
  '{"a":"ROM (Read-Only Memory)","b":"RAM (Random Access Memory)","c":"Hard Disk Drive (HDD)","d":"Flash Memory"}'::jsonb,
  '{"a":"रॉम (ROM - Read-Only Memory)","b":"रैम (RAM - Random Access Memory)","c":"हार्ड डिस्क ड्राइव (HDD)","d":"फ्लैश मेमोरी (Flash Memory)"}'::jsonb,
  'b',
  'RAM (Random Access Memory) is a primary, volatile computer memory that temporarily stores data and machine instructions required by the CPU during program execution. Since its memory cells require continuous power to maintain state, all stored information is wiped when power is turned off. Conversely, ROM, HDD, SSD, and Flash memory are non-volatile storage media.',
  'रैम (RAM - Random Access Memory) कंप्यूटर की प्राथमिक अस्थिर (Volatile) मेमोरी है, जो प्रोग्राम निष्पादन के दौरान सीपीयू द्वारा आवश्यक डेटा को अस्थायी रूप से संग्रहीत करती है। बिजली की आपूर्ति बंद होने पर इसमें संग्रहीत सभी डेटा नष्ट हो जाता है। जबकि रॉम (ROM), हार्ड डिस्क तथा फ्लैश मेमोरी गैर-अस्थिर (Non-volatile) मेमोरी हैं।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  99,
  3,
  'PART-3',
  'General Awareness',
  'Computer & IT (Networking Protocols & IP Addressing)',
  'Moderate',
  'What is the size (address length) in bits of an Internet Protocol Version 4 (IPv4) address and an Internet Protocol Version 6 (IPv6) address respectively?',
  'इंटरनेट प्रोटोकॉल संस्करण 4 (IPv4) पते और इंटरनेट प्रोटोकॉल संस्करण 6 (IPv6) पते का आकार (Address Length) बिट्स में क्रमशः कितना होता है?',
  '{"a":"32 bits and 64 bits","b":"32 bits and 128 bits","c":"64 bits and 128 bits","d":"16 bits and 32 bits"}'::jsonb,
  '{"a":"32 बिट्स और 64 बिट्स","b":"32 बिट्स और 128 बिट्स","c":"64 बिट्स और 128 बिट्स","d":"16 बिट्स और 32 बिट्स"}'::jsonb,
  'b',
  'An IPv4 address is 32 bits (4 bytes) long, written in dot-decimal notation (e.g., 192.168.1.1), providing approximately 4.3 billion unique addresses ($2^{32}$). An IPv6 address is 128 bits (16 bytes) long, written in hexadecimal notation separated by colons (e.g., 2001:0db8:85a3::8a2e:0370:7334), providing $2^{128}$ addresses.',
  'IPv4 (इंटरनेट प्रोटोकॉल संस्करण 4) का पता 32 बिट्स (4 बाइट्स) लंबा होता है, जो दशमलव प्रारूप में लिखा जाता है (लगभग $2^{32} \approx 4.3$ बिलियन पते)। जबकि IPv6 का पता 128 बिट्स (16 बाइट्स) लंबा होता है, जिसे हेक्साडेसिमल प्रारूप में कोलन द्वारा अलग करके लिखा जाता है ($2^{128}$ पते)। अतः सही उत्तर विकल्प (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title, chapter_name, difficulty,
  question_text, question_text_hi, options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_ntpc_graduate_mock_1',
  100,
  3,
  'PART-3',
  'General Awareness',
  'Computer & IT (Operating System Shortcuts & Architecture)',
  'Moderate',
  'What is the primary function of the keyboard shortcut ''Alt + Tab'' in the Microsoft Windows Operating System?',
  'माइक्रोसॉफ्ट विंडोज ऑपरेटिंग सिस्टम में कीबोर्ड शॉर्टकट ''Alt + Tab'' का प्राथमिक कार्य क्या होता है?',
  '{"a":"Close the active window or document immediately","b":"Switch between currently open running applications and windows","c":"Open the Windows Task Manager dialog","d":"Permanently delete the selected file without sending to Recycle Bin"}'::jsonb,
  '{"a":"सक्रिय विंडो या दस्तावेज़ को तुरंत बंद करना","b":"वर्तमान में खुली हुई सक्रिय एप्लिकेशन/विंडोज के बीच स्विच (अदला-बदली) करना","c":"विंडोज टास्क मैनेजर डायलॉग बॉक्स खोलना","d":"चयनित फ़ाइल को रीसायकल बिन में भेजे बिना स्थायी रूप से हटाना"}'::jsonb,
  'b',
  'In Windows, pressing Alt + Tab displays the Task Switcher interface, allowing users to rapidly navigate and switch between currently running applications and active windows. Alt + F4 is used to close an active window, Ctrl + Shift + Esc opens Task Manager, and Shift + Delete permanently deletes a file.',
  'विंडोज़ ऑपरेटिंग सिस्टम में ''Alt + Tab'' दबाने पर टास्क स्विचर इंटरफेस खुलता है, जिससे उपयोगकर्ता वर्तमान में चल रहे खुले हुए विभिन्न प्रोग्रामों और विंडोज़ के बीच तेजी से स्विच (अदला-बदली) कर सकता है। Alt + F4 विंडो बंद करने के लिए और Ctrl + Shift + Esc टास्क मैनेजर खोलने के लिए उपयोग होता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
  part_number = EXCLUDED.part_number,
  section_name = EXCLUDED.section_name,
  section_title = EXCLUDED.section_title,
  chapter_name = EXCLUDED.chapter_name,
  difficulty = EXCLUDED.difficulty,
  question_text = EXCLUDED.question_text,
  question_text_hi = EXCLUDED.question_text_hi,
  options = EXCLUDED.options,
  options_hi = EXCLUDED.options_hi,
  correct_option = EXCLUDED.correct_option,
  solution_text = EXCLUDED.solution_text,
  solution_text_hi = EXCLUDED.solution_text_hi,
  image_svg = EXCLUDED.image_svg,
  image_svg_hi = EXCLUDED.image_svg_hi,
  option_svgs = EXCLUDED.option_svgs;

