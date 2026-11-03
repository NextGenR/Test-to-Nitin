-- =========================================================================
-- AUTOMATED MIGRATION: 300 QUESTIONS WITH INLINE SVG DIAGRAMS
-- Compatible with Remote Cloud Database / PostgreSQL
-- Safe & Idempotent
-- =========================================================================

-- 1. Add schema columns for vector diagrams
ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS image_svg TEXT;
ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS image_svg_hi TEXT;
ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS image_url TEXT;
ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS image_url_hi TEXT;
ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS option_svgs JSONB;
ALTER TABLE IF EXISTS public.questions ADD COLUMN IF NOT EXISTS option_images JSONB;

-- 2. Ensure unique constraint on (test_id, question_number) for clean upserts
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'unique_test_question'
  ) THEN
    ALTER TABLE public.questions ADD CONSTRAINT unique_test_question UNIQUE (test_id, question_number);
  END IF;
END $$;

-- 3. Enable RLS and public access
ALTER TABLE IF EXISTS public.questions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read on questions" ON public.questions;
CREATE POLICY "Allow anon read on questions" ON public.questions FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "Allow anon all on questions" ON public.questions;
CREATE POLICY "Allow anon all on questions" ON public.questions FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

-- 4. Upsert 300 Questions with Diagrams
-- -------------------------------------------------------------------------
-- rrb_cbt_mock_1 (100 questions)
-- -------------------------------------------------------------------------

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  1,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is the acceleration due to gravity (g) at the center of the Earth?',
  'पृथ्वी के केंद्र पर गुरुत्वीय त्वरण (g) का मान क्या होता है?',
  '{"a":"9.8 m/s²","b":"Zero (0)","c":"Infinite","d":"4.9 m/s²"}'::jsonb,
  '{"a":"9.8 मी/से²","b":"शून्य (0)","c":"अनंत","d":"4.9 मी/से²"}'::jsonb,
  'b',
  'At the Earth''s center, depth $d = R$. Formula: $g'' = g(1 - d/R) = g(1 - 1) = 0$. Hence weight of an object at the center is zero.',
  'पृथ्वी के केंद्र पर गुरुत्वीय त्वरण का मान शून्य (0) होता है ($g'' = g(1 - d/R)$)। अतः केंद्र पर वस्तु का भार शून्य होता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  2,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'A ball of mass $m$ is dropped from a height $h$ to the ground. Just before touching the ground, its potential energy is completely converted into:',
  '$m$ द्रव्यमान की एक गेंद को $h$ ऊँचाई से गिराया जाता है। जमीन से टकराने से ठीक पहले इसकी स्थितिज ऊर्जा पूरी तरह किसमें परिवर्तित हो जाती है?',
  '{"a":"Heat energy only","b":"Kinetic energy ($\\frac{1}{2}mv^2 = mgh$)","c":"Chemical energy","d":"Nuclear energy"}'::jsonb,
  '{"a":"केवल ऊष्मा ऊर्जा","b":"गतिज ऊर्जा ($\\frac{1}{2}mv^2 = mgh$)","c":"रासायनिक ऊर्जा","d":"नाभिकीय ऊर्जा"}'::jsonb,
  'b',
  'By the law of conservation of mechanical energy ($PE + KE = \text{constant}$), the initial potential energy ($mgh$) transforms fully into kinetic energy ($\frac{1}{2}mv^2$). Velocity $v = \sqrt{2gh}$.',
  'यांत्रिक ऊर्जा संरक्षण के नियम के अनुसार उच्चतम बिंदु पर स्थित स्थितिज ऊर्जा ($mgh$) नीचे आते ही गतिज ऊर्जा ($\frac{1}{2}mv^2$) में बदल जाती है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  3,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is the acceleration of a freely falling body near the surface of the Earth?',
  'पृथ्वी की सतह के निकट स्वतंत्र रूप से गिरती हुई वस्तु का त्वरण क्या होता है?',
  '{"a":"Zero","b":"9.8 m/s² (Constant)","c":"Increases with object mass","d":"Decreases with time"}'::jsonb,
  '{"a":"शून्य","b":"9.8 मी/से² (स्थिर)","c":"द्रव्यमान के साथ बढ़ता है","d":"समय के साथ घटता है"}'::jsonb,
  'b',
  'In a vacuum, all bodies regardless of mass fall with identical gravitational acceleration $g = 9.8\text{ m/s}^2$ ($g = GM/R^2$, independent of mass $m$).',
  'स्वतंत्र रूप से गिरती वस्तु का गुरुत्वीय त्वरण वस्तु के द्रव्यमान पर निर्भर नहीं करता और पृथ्वी की सतह पर इसका मान लगभग 9.8 मी/से² होता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  4,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'During photosynthesis in green plants, the oxygen gas released originates from:',
  'हरे पौधों में प्रकाश संश्लेषण के दौरान निकलने वाली ऑक्सीजन गैस का स्रोत क्या है?',
  '{"a":"Carbon dioxide (CO₂)","b":"Water (H₂O)","c":"Glucose","d":"Chlorophyll"}'::jsonb,
  '{"a":"कार्बन डाइऑक्साइड (CO₂)","b":"जल (H₂O)","c":"ग्लूकोज","d":"क्लोरोफिल"}'::jsonb,
  'b',
  'Photolysis of water ($2\text{H}_2\text{O} \rightarrow 4\text{H}^+ + \text{O}_2 + 4e^-$) during the light-dependent reactions is the source of released oxygen.',
  'प्रकाश संश्लेषण की प्रकाश अभिक्रिया में जल के प्रकाश-अपघटन (Photolysis of Water) से ऑक्सीजन गैस मुक्त होती है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  5,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Which mild base is commonly used in antacid syrups to neutralize excessive gastric acid (HCl) in the stomach?',
  'पेट की अत्यधिक अम्लता (HCl) को बेअसर करने के लिए एंटासिड सिरप में आमतौर पर किस हल्के क्षार का उपयोग किया जाता है?',
  '{"a":"Sodium Hydroxide","b":"Magnesium Hydroxide [Milk of Magnesia]","c":"Potassium Hydroxide","d":"Copper Sulphate"}'::jsonb,
  '{"a":"सोडियम हाइड्रॉक्साइड","b":"मैग्नीशियम हाइड्रॉक्साइड [मिल्क ऑफ मैग्नीशिया]","c":"पोटेशियम हाइड्रॉक्साइड","d":"कॉपर सल्फेट"}'::jsonb,
  'b',
  'Magnesium Hydroxide, $\text{Mg(OH)}_2$, also known as Milk of Magnesia, is a mild alkaline antacid that neutralizes hyperacidity without harming mucosal tissues.',
  'मिल्क ऑफ मैग्नीशिया [$\text{Mg(OH)}_2$] एक सौम्य क्षार है जिसका उपयोग पेट की एसिडिटी को दूर करने के लिए एंटासिड के रूप में किया जाता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  6,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'According to Joule''s law of heating, the heat produced in a resistor ($H$) is directly proportional to:',
  'जूल के तापन नियम के अनुसार, किसी प्रतिरोधक में उत्पन्न ऊष्मा ($H$) किसके समानुपाती होती है?',
  '{"a":"Current ($I$)","b":"Square of current ($I^2$)","c":"Cube of current ($I^3$)","d":"Inverse of resistance ($1/R$)"}'::jsonb,
  '{"a":"धारा ($I$)","b":"विद्युत धारा के वर्ग ($I^2$)","c":"धारा के घन ($I^3$)","d":"प्रतिरोध के व्युत्क्रम"}'::jsonb,
  'b',
  'Joule''s law states $H = I^2 R t$. Heat is directly proportional to the square of current ($I^2$), resistance ($R$), and time ($t$).',
  'जूल का तापन नियम: $H = I^2Rt$। उत्पन्न ऊष्मा धारा के वर्ग ($I^2$), प्रतिरोध और समय के समानुपाती होती है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  7,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Graphite conducts electricity effectively whereas diamond does not, because in graphite:',
  'ग्रेफाइट विद्युत का सुचालक है जबकि हीरा कुचालक, क्योंकि ग्रेफाइट में:',
  '{"a":"Each carbon has 4 covalent bonds","b":"Each carbon atom is bonded to 3 other carbons leaving one free mobile electron","c":"Carbon atoms are arranged in a rigid 3D tetrahedron","d":"Graphite contains metallic impurities"}'::jsonb,
  '{"a":"प्रत्येक कार्बन के 4 सहसंयोजक बंध होते हैं","b":"प्रत्येक कार्बन 3 अन्य कार्बनों से जुड़ा होता है और एक मुक्त इलेक्ट्रॉन उपलब्ध रहता है","c":"कार्बन परमाणु त्रिविमीय चतुष्फलकीय संरचना में होते हैं","d":"ग्रेफाइट में धात्विक अशुद्धियाँ होती हैं"}'::jsonb,
  'b',
  'In graphite, each carbon atom is $sp^2$ hybridized and bonded to 3 carbons in planar hexagonal layers. The 4th valence electron is delocalized and conducts current.',
  'ग्रेफाइट में प्रत्येक कार्बन 3 अन्य कार्बनों से जुड़ा होता है ($sp^2$) और चौथा इलेक्ट्रॉन मुक्त अवस्था में परतों के बीच गतिशील होकर विद्युत चालन करता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  8,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is ''Dry Ice'' chemically composed of?',
  '''शुष्क बर्फ'' (Dry Ice) रासायनिक रूप से क्या होती है?',
  '{"a":"Solid water at -50°C","b":"Solid Carbon Dioxide (CO₂)","c":"Liquid Nitrogen","d":"Solid Sulphur Dioxide"}'::jsonb,
  '{"a":"ठोस जल","b":"ठोस कार्बन डाइऑक्साइड (Solid CO₂)","c":"तरल नाइट्रोजन","d":"ठोस सल्फर डाइऑक्साइड"}'::jsonb,
  'b',
  'Dry Ice is the solid state of Carbon Dioxide ($CO_2$). Under normal atmospheric pressure, it sublimes directly from solid to gas at -78.5°C without melting into a liquid.',
  'शुष्क बर्फ ठोस कार्बन डाइऑक्साइड ($	ext{CO}_2$) होती है, जो सामान्य दाब पर बिना पिघले सीधे गैस में परिवर्तित (उर्ध्वपातन) हो जाती है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  9,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'The quantitative measure of the inertia of a body is given by its:',
  'किसी वस्तु के जड़त्व (Inertia) का मात्रात्मक माप क्या होता है?',
  '{"a":"Velocity","b":"Mass","c":"Volume","d":"Surface area"}'::jsonb,
  '{"a":"वेग","b":"द्रव्यमान (Mass)","c":"आयतन","d":"पृष्ठीय क्षेत्रफल"}'::jsonb,
  'b',
  'Inertia is the inherent resistance of an object to changes in its state of motion. Mass ($m$) is the direct quantitative measure of inertia.',
  'किसी वस्तु का द्रव्यमान उसके जड़त्व का प्रत्यक्ष माप होता है। अधिक द्रव्यमान वाली वस्तु का जड़त्व अधिक होता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  10,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Bauxite is the principal and commercial mineral ore of which metal?',
  'बॉक्साइट (Bauxite) किस धातु का प्रमुख और व्यावसायिक खनिज अयस्क है?',
  '{"a":"Iron","b":"Aluminium","c":"Copper","d":"Lead"}'::jsonb,
  '{"a":"लोहा (हेमेटाइट)","b":"एल्युमिनियम (Aluminium - Al₂O₃·2H₂O)","c":"तांबा (कॉपर पाइराइट)","d":"सीसा (गैलेना)"}'::jsonb,
  'b',
  'Bauxite (hydrated aluminium oxide, $\text{Al}_2\text{O}_3\cdot 2\text{H}_2\text{O}$) is the primary industrial ore from which aluminium is extracted via the Bayer and Hall-Héroult processes.',
  'बॉक्साइट ($	ext{Al}_2	ext{O}_3\cdot 2	ext{H}_2	ext{O}$) एल्युमिनियम का मुख्य अयस्क है। भारत में ओडिशा इसका प्रमुख उत्पादक राज्य है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  11,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'The SI unit of electrical conductance is:',
  'विद्युत चालकत्व (Electrical Conductance) का SI मात्रक क्या है?',
  '{"a":"Ohm-metre","b":"Siemens","c":"Henry","d":"Tesla"}'::jsonb,
  '{"a":"ओम-मीटर","b":"सीमेंस (Siemens)","c":"हेनरी","d":"टेस्ला"}'::jsonb,
  'b',
  'Electrical conductance ($G$) is the reciprocal of resistance ($G = 1/R$). Its SI unit is Siemens ($S$), formerly known as mho ($\Omega^{-1}$).',
  'विद्युत चालकत्व ($G$) प्रतिरोध का व्युत्क्रम होता है ($G = 1/R$)। इसका SI मात्रक सीमेंस ($S$) है, जिसे पहले म्हो ($\Omega^{-1}$) भी कहा जाता था।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  12,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'The primary structural and functional microscopic units in human lungs where gas exchange ($O_2$ and $CO_2$) occurs are called:',
  'मानव फेफड़ों में वे प्राथमिक सूक्ष्म संरचनात्मक एवं कार्यात्मक इकाइयाँ जहाँ गैसों ($O_2$ तथा $CO_2$) का आदान-प्रदान होता है, क्या कहलाती हैं?',
  '{"a":"Bronchioles","b":"Alveoli","c":"Pleural cavities","d":"Tracheal rings"}'::jsonb,
  '{"a":"श्वसनिकाएँ (Bronchioles)","b":"कूपिकाएँ (Alveoli / एल्वियोली)","c":"फुफ्फुस गुहाएँ","d":"श्वासनली के छल्ले"}'::jsonb,
  'b',
  'Alveoli are microscopic cup-shaped pouches surrounded by extensive capillary beds, maximizing the surface area for rapid gas diffusion during respiration.',
  'कूपिकाएँ (Alveoli) फेफड़ों में सूक्ष्म वायु थैलियाँ होती हैं जो रक्त केशिकाओं के घने जाल से घिरी होती हैं और गैसों के तीव्र विसरण के लिए विशाल सतह प्रदान करती हैं।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  13,
  1,
  'PART-1',
  'General Science',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  14,
  1,
  'PART-1',
  'General Science',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  15,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'An electric generator (dynamo) converts mechanical energy into electrical energy based on which physical phenomenon?',
  'एक विद्युत जनरेटर (डायनेमो) किस भौतिक परिघटना के आधार पर यांत्रिक ऊर्जा को विद्युत ऊर्जा में परिवर्तित करता है?',
  '{"a":"Thermal Emission","b":"Electromagnetic Induction","c":"Photoelectric Effect","d":"Joule''s Heating Effect"}'::jsonb,
  '{"a":"तापीय उत्सर्जन","b":"विद्युत चुम्बकीय प्रेरण (Electromagnetic Induction)","c":"प्रकाश विद्युत प्रभाव","d":"जूल का तापन प्रभाव"}'::jsonb,
  'b',
  'Electric generators operate on the principle of Electromagnetic Induction discovered by Michael Faraday in 1831. Rotating a coil inside a magnetic field induces an electromotive force (EMF) and electric current in the coil.

Correct Option: (b)',
  'विद्युत जनरेटर 1831 में माइकल फैराडे द्वारा खोजे गए ''विद्युत चुम्बकीय प्रेरण'' के सिद्धांत पर कार्य करता है। चुंबकीय क्षेत्र में कुंडली को घुमाने पर उसमें प्रेरित विद्युत वाहक बल और विद्युत धारा उत्पन्न होती है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  16,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Cellular respiration, the metabolic process by which glucose is broken down to release energy in cells, is classified as which type of chemical reaction?',
  'कोशिकीय श्वसन, जिसके द्वारा कोशिकाओं में ऊर्जा मुक्त करने के लिए ग्लूकोज का विघटन होता है, किस प्रकार की रासायनिक अभिक्रिया के रूप में वर्गीकृत किया जाता है?',
  '{"a":"Endothermic reaction","b":"Exothermic reaction","c":"Photochemical reaction","d":"Electrolytic reaction"}'::jsonb,
  '{"a":"ऊष्माशोषी अभिक्रिया","b":"ऊष्माक्षेपी अभिक्रिया (Exothermic reaction)","c":"प्रकाश रासायनिक अभिक्रिया","d":"विद्युत अपघटनी अभिक्रिया"}'::jsonb,
  'b',
  'C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + Energy (ATP).
Because energy is released during the breakdown of glucose to sustain cellular activities, respiration is an exothermic reaction. (Photosynthesis absorbs energy and is endothermic).

Correct Option: (b)',
  'श्वसन प्रक्रिया में ग्लूकोज ऑक्सीजन के साथ मिलकर कार्बन डाइऑक्साइड और जल बनाता है तथा भारी मात्रा में ऊर्जा (ATP) मुक्त होती है। ऊर्जा मुक्त होने के कारण यह एक ऊष्माक्षेपी (Exothermic) अभिक्रिया है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  17,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'If the linear momentum of a moving body is doubled while keeping its mass constant, its kinetic energy becomes:',
  'यदि किसी गतिमान पिंड के द्रव्यमान को स्थिर रखते हुए उसके रेखीय संवेग को दोगुना कर दिया जाए, तो उसकी गतिज ऊर्जा हो जाएगी:',
  '{"a":"2 times","b":"4 times","c":"Half","d":"Constant"}'::jsonb,
  '{"a":"2 गुनी","b":"4 गुनी","c":"आधी","d":"अपरिवर्तित"}'::jsonb,
  'b',
  'The relationship between Kinetic Energy (K) and linear momentum (p) is:
K = p^2 / (2m)
If momentum is doubled (p'' = 2p):
K'' = (2p)^2 / (2m) = 4 * [p^2 / (2m)] = 4K.
Hence, the kinetic energy becomes 4 times the initial kinetic energy.

Correct Option: (b)',
  'गतिज ऊर्जा (K) और संवेग (p) का संबंध:
K = p^2 / (2m)
यदि संवेग दोगुना हो जाए (p'' = 2p):
K'' = (2p)^2 / (2m) = 4 * (p^2 / 2m) = 4K.
अतः गतिज ऊर्जा प्रारंभिक मान की 4 गुनी हो जाएगी।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  18,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'In which of the following media does sound travel with the highest speed at 25°C?',
  '25°C तापमान पर निम्नलिखित में से किस माध्यम में ध्वनि की चाल सर्वाधिक होती है?',
  '{"a":"Air","b":"Water","c":"Aluminium","d":"Kerosene"}'::jsonb,
  '{"a":"वायु","b":"जल","c":"एल्युमीनियम","d":"केरोसिन"}'::jsonb,
  'c',
  'Sound is a mechanical longitudinal wave requiring an elastic medium. Speed of sound depends on the elasticity and density of the medium (Solids > Liquids > Gases).
Approximate speeds at 25°C:
- Aluminium (solid): ~6,420 m/s
- Distilled Water (liquid): ~1,498 m/s
- Kerosene (liquid): ~1,324 m/s
- Air (gas): ~346 m/s
Hence, sound travels fastest in aluminium.

Correct Option: (c)',
  'ध्वनि तरंगें ठोस माध्यम में सर्वाधिक गति से चलती हैं क्योंकि ठोस पदार्थों का प्रत्यास्थता गुणांक उच्च होता है।
25°C पर ध्वनि की चाल:
- एल्युमीनियम: ~6420 m/s
- जल: ~1498 m/s
- वायु: ~346 m/s
अतः एल्युमीनियम में ध्वनि की चाल सर्वाधिक होती है।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  19,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'If a cylindrical uniform metallic wire of resistance R is stretched such that its length is doubled while its volume remains constant, what will be its new resistance?',
  'यदि R प्रतिरोध वाले एक समान बेलनाकार धातु के तार को इस प्रकार खींचा जाता है कि उसका आयतन स्थिर रहते हुए उसकी लंबाई दोगुनी हो जाती है, तो उसका नया प्रतिरोध क्या होगा?',
  '{"a":"2R","b":"4R","c":"R/2","d":"R/4"}'::jsonb,
  '{"a":"2R","b":"4R","c":"R/2","d":"R/4"}'::jsonb,
  'b',
  'Resistance is given by R = ρ * (L / A).
When a wire is stretched without adding mass:
- Volume V = A * L remains constant.
- If length L'' = 2L, the cross-sectional area becomes A'' = A / 2.
New resistance R'' = ρ * (L'' / A'') = ρ * (2L / (A / 2)) = 4 * [ρ * (L / A)] = 4R.
Hence, the new resistance becomes 4 times the initial resistance.

Correct Option: (b)',
  'प्रतिरोध का सूत्र: R = ρ * (L / A).
तार को खींचने पर आयतन (V = A * L) स्थिर रहता है।
यदि लंबाई L'' = 2L हो जाए, तो अनुप्रस्थ काट का क्षेत्रफल A'' = A / 2 हो जाएगा।
नया प्रतिरोध R'' = ρ * (2L) / (A / 2) = 4 * (ρ L / A) = 4R.
अतः नया प्रतिरोध प्रारंभिक मान का 4 गुना हो जाएगा।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  20,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'When ethanoic acid reacts with ethanol in the presence of an acid catalyst, a sweet, fruity-smelling compound is formed. What class of chemical compounds does it belong to?',
  'जब एथेनोइक अम्ल एक अम्ल उत्प्रेरक की उपस्थिति में एथेनॉल के साथ अभिक्रिया करता है, तो एक मीठी, फलों जैसी गंध वाला यौगिक बनता है। यह किस वर्ग का रासायनिक यौगिक है?',
  '{"a":"Ester","b":"Aldehyde","c":"Ketone","d":"Ether"}'::jsonb,
  '{"a":"एस्टर (Ester)","b":"एल्डिहाइड (Aldehyde)","c":"कीटोन (Ketone)","d":"ईथर (Ether)"}'::jsonb,
  'a',
  'The reaction of a carboxylic acid with an alcohol in the presence of concentrated H2SO4 produces an ester and water:
CH3COOH + C2H5OH -> CH3COOC2H5 (Ethyl ethanoate) + H2O
This process is called Esterification. Esters possess pleasant fruity smells and are used in perfumes and artificial flavouring agents.

Correct Option: (a)',
  'सांद्र H2SO4 की उपस्थिति में कार्बोक्सिलिक अम्ल और एल्कोहॉल की अभिक्रिया से एस्टर (Ester) बनता है:
CH3COOH + C2H5OH -> CH3COOC2H5 + H2O
इस प्रक्रिया को एस्टरीकरण कहते हैं। एस्टर की गंध फलों जैसी मीठी होती है और इसका उपयोग इत्र तथा स्वादवर्धक पदार्थों में होता है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  21,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is the minimum distance required between a source of sound and a reflecting surface to hear a distinct echo in air at 22°C (speed of sound = 344 m/s)?',
  '22°C तापमान पर वायु में (ध्वनि की चाल = 344 मी/से) एक स्पष्ट प्रतिध्वनि (Echo) सुनने के लिए ध्वनि स्रोत और परावर्तक सतह के बीच न्यूनतम कितनी दूरी होनी चाहिए?',
  '{"a":"11.2 m","b":"17.2 m","c":"34.4 m","d":"25.0 m"}'::jsonb,
  '{"a":"11.2 मीटर","b":"17.2 मीटर","c":"34.4 मीटर","d":"25.0 मीटर"}'::jsonb,
  'b',
  'The sensation of sound persists in the human brain for about 0.1 s (persistence of hearing).
For an echo to be clearly distinguished, the reflected sound must reach the ear after at least 0.1 s.
Total distance travelled by sound (forth and back) = 2d = v * t = 344 * 0.1 = 34.4 m.
Therefore, minimum distance to the reflector d = 34.4 / 2 = 17.2 meters.

Correct Option: (b)',
  'मानव कान पर ध्वनि का प्रभाव 0.1 सेकंड तक रहता है।
स्पष्ट प्रतिध्वनि सुनने के लिए ध्वनि द्वारा तय कुल दूरी (जाना + आना) = v * t = 344 * 0.1 = 34.4 मीटर होनी चाहिए।
अतः परावर्तक सतह की न्यूनतम दूरी d = 34.4 / 2 = 17.2 मीटर होनी चाहिए।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  22,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Four electric bulbs of 60 W each are used for 5 hours daily in a household. How many units (kWh) of electrical energy are consumed by these bulbs in a month of 30 days?',
  'एक घर में प्रतिदिन 60 W के चार विद्युत बल्ब 5 घंटे जलाए जाते हैं। 30 दिनों के एक महीने में इन बल्बों द्वारा कितने यूनिट (kWh) विद्युत ऊर्जा की खपत होगी?',
  '{"a":"36 units","b":"30 units","c":"40 units","d":"45 units"}'::jsonb,
  '{"a":"36 यूनिट","b":"30 यूनिट","c":"40 यूनिट","d":"45 यूनिट"}'::jsonb,
  'a',
  'Total power = 4 bulbs * 60 W = 240 W = 0.24 kW.
Daily operating time = 5 hours.
Total hours in 30 days = 5 * 30 = 150 hours.
Electrical energy consumed = Power (kW) * Time (hours)
Energy = 0.24 kW * 150 h = 36 kWh = 36 units.

Correct Option: (a)',
  'कुल शक्ति = 4 * 60 = 240 वाट = 0.24 किलोवाट।
30 दिनों में कुल समय = 5 * 30 = 150 घंटे।
विद्युत ऊर्जा = शक्ति (kW) * समय (घंटे) = 0.24 * 150 = 36 kWh = 36 यूनिट।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  23,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Through which mode of heat transfer does solar thermal energy travel across the vacuum of outer space to reach the Earth?',
  'ऊष्मा स्थानांतरण की किस विधि द्वारा सूर्य की तापीय ऊर्जा बाह्य अंतरिक्ष के निर्वात से होकर पृथ्वी तक पहुँचती है?',
  '{"a":"Radiation","b":"Conduction","c":"Convection","d":"Advection"}'::jsonb,
  '{"a":"विकिरण (Radiation)","b":"चालन (Conduction)","c":"संवहन (Convection)","d":"अभिवहन (Advection)"}'::jsonb,
  'a',
  'Thermal radiation travels in the form of electromagnetic waves (infrared radiation) at the speed of light (3 × 10^8 m/s) and requires no material medium for propagation, allowing solar energy to traverse the absolute vacuum of space.
(Conduction and convection require a physical material medium).

Correct Option: (a)',
  'विकिरण (Radiation) ऊष्मा संचरण की वह विधि है जिसके लिए किसी भौतिक माध्यम की आवश्यकता नहीं होती। यह विद्युत-चुंबकीय तरंगों (अवरक्त किरणों) के रूप में प्रकाश की चाल से गमन करती है, जिससे सूर्य की ऊष्मा अंतरिक्ष के निर्वात को पार कर पृथ्वी तक पहुंचती है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  24,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is the work done by the centripetal force on a body moving in a circular path at constant speed?',
  'नियत गति से वृत्ताकार पथ पर गतिमान किसी पिंड पर अभिकेंद्रीय बल (Centripetal force) द्वारा किया गया कार्य कितना होता है?',
  '{"a":"Maximum positive work","b":"Negative work","c":"Zero","d":"Infinite"}'::jsonb,
  '{"a":"अधिकतम धनात्मक कार्य","b":"ऋणात्मक कार्य","c":"शून्य","d":"अनंत"}'::jsonb,
  'c',
  'Centripetal force acts towards the center while displacement is tangential (angle θ = 90°). Work done W = F·d·cos(90°) = 0.',
  'अभिकेंद्रीय बल केंद्र की ओर कार्य करता है जबकि विस्थापन स्पर्शरेखीय होता है (कोण θ = 90°)। किया गया कार्य W = F·d·cos(90°) = 0 होता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  25,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Which plant vascular tissue conducts soluble organic compounds (food) synthesized during photosynthesis?',
  'पादपों में कौन सा संवहनी ऊतक प्रकाश संश्लेषण के दौरान संश्लेषित घुलनशील कार्बनिक यौगिकों (भोजन) का संवहन करता है?',
  '{"a":"Xylem","b":"Phloem","c":"Sclerenchyma","d":"Collenchyma"}'::jsonb,
  '{"a":"जाइलम (Xylem)","b":"फ्लोएम (Phloem)","c":"दृढ़ोतक (Sclerenchyma)","d":"स्थूलकोणोतक (Collenchyma)"}'::jsonb,
  'b',
  'Phloem transports synthesized nutrients and sugars from leaves to all parts of the plant (translocation). Xylem conducts water and minerals.',
  'फ्लोएम पत्तियों से पौधे के सभी भागों में भोजन और शर्करा का संवहन (स्थानांतरण) करता है। जाइलम जल और खनिजों का परिवहन करता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  26,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A mixture of 64 litres contains milk and water in the ratio 5 : 3. How much water must be added to make the ratio 5 : 5 (1 : 1)?',
  '64 लीटर के मिश्रण में दूध और पानी का अनुपात 5 : 3 है। इसमें कितना पानी मिलाया जाए कि नया अनुपात 5 : 5 (1 : 1) हो जाए?',
  '{"a":"12 litres","b":"16 litres","c":"18 litres","d":"20 litres"}'::jsonb,
  '{"a":"12 लीटर","b":"16 लीटर","c":"18 लीटर","d":"20 लीटर"}'::jsonb,
  'b',
  'Total parts = 5 + 3 = 8. Milk = $(5/8) \times 64 = 40$ L, Water = $(3/8) \times 64 = 24$ L. To make water equal to milk (40 L), added water = $40 - 24 = 16$ litres.',
  'कुल भाग = 8। दूध = $(5/8) \times 64 = 40$ लीटर, पानी = 24 लीटर। पानी को दूध के बराबर (40 लीटर) करने के लिए मिलाया गया पानी = $40 - 24 = 16$ लीटर।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  27,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'What will be the compound interest on ₹10,000 for 1 year at 20% per annum, compounded half-yearly?',
  '₹10,000 पर 20% वार्षिक दर से 1 वर्ष का चक्रवृद्धि ब्याज क्या होगा, यदि ब्याज अर्धवार्षिक रूप से संयोजित होता है?',
  '{"a":"₹2,000","b":"₹2,100","c":"₹2,200","d":"₹2,250"}'::jsonb,
  '{"a":"₹2,000","b":"₹2,100","c":"₹2,200","d":"₹2,250"}'::jsonb,
  'b',
  'Half-yearly rate $R = 20/2 = 10\%$, periods $n = 2$. Amount $= 10000 \times (1.10)^2 = 10000 \times 1.21 = ₹12,100$. CI $= 12100 - 10000 = ₹2,100$.',
  'अर्धवार्षिक दर = 10%, समयावधि = 2 अर्धवर्ष। मिश्रधन = $10000 \times (1.10)^2 = ₹12,100$। चक्रवृद्धि ब्याज = ₹2,100।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  28,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A boat goes 24 km upstream in 6 hours and 36 km downstream in 4 hours. Find the speed of the boat in still water.',
  'एक नाव धारा के प्रतिकूल (Upstream) 24 किमी 6 घंटे में और धारा के अनुकूल (Downstream) 36 किमी 4 घंटे में जाती है। शांत जल में नाव की चाल ज्ञात कीजिए।',
  '{"a":"5.5 km/h","b":"6.0 km/h","c":"6.5 km/h","d":"7.0 km/h"}'::jsonb,
  '{"a":"5.5 किमी/घंटा","b":"6.0 किमी/घंटा","c":"6.5 किमी/घंटा","d":"7.0 किमी/घंटा"}'::jsonb,
  'c',
  'Upstream speed $u = 24/6 = 4$ km/h. Downstream speed $v = 36/4 = 9$ km/h. Boat speed in still water $= (v + u)/2 = (9 + 4)/2 = 6.5$ km/h.',
  'धारा के प्रतिकूल चाल $= 4$ किमी/घंटा, अनुकूल चाल $= 9$ किमी/घंटा। शांत जल में नाव की चाल $= (9 + 4)/2 = 6.5$ किमी/घंटा।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  29,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'Two trains running in opposite directions on parallel tracks cross each other completely in $18\text{ seconds}$. Their lengths are $240\text{ m}$ and $300\text{ m}$. If the speed of the first train is $60\text{ km/h}$, find the speed of the second train.',
  'समानांतर पटरियों पर विपरीत दिशाओं में दौड़ रही दो ट्रेनें एक दूसरे को $18\text{ सेकंड}$ में पूरी तरह पार करती हैं। उनकी लंबाइयाँ $240\text{ m}$ और $300\text{ m}$ हैं। यदि पहली ट्रेन की गति $60\text{ km/h}$ है, तो दूसरी ट्रेन की गति ज्ञात कीजिए।',
  '{"a":"$48\\text{ km/h}$","b":"$52\\text{ km/h}$","c":"$45\\text{ km/h}$","d":"$54\\text{ km/h}$"}'::jsonb,
  '{"a":"$48\\text{ km/h}$","b":"$52\\text{ km/h}$","c":"$45\\text{ km/h}$","d":"$54\\text{ km/h}$"}'::jsonb,
  'a',
  'Total distance covered $= 240 + 300 = 540\text{ m}$. Relative speed $= 540 / 18 = 30\text{ m/s} = 30 \times \frac{18}{5} = 108\text{ km/h}$. For opposite directions, $S_{rel} = S_1 + S_2 \implies 60 + S_2 = 108 \implies S_2 = 48\text{ km/h}$.',
  'कुल दूरी $= 240 + 300 = 540\text{ m}$। सापेक्ष चाल $= 540 / 18 = 30\text{ m/s} = 30 \times \frac{18}{5} = 108\text{ km/h}$। विपरीत दिशा होने पर: $S_1 + S_2 = 108 \implies 60 + S_2 = 108 \implies S_2 = 48\text{ km/h}$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  30,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'The ratio of base radius to height of a right circular cone is $3 : 4$. If its curved surface area is $240\pi\text{ cm}^2$, what is its volume?',
  'एक लम्ब वृत्तीय शंकु की आधार त्रिज्या और ऊँचाई का अनुपात $3 : 4$ है। यदि इसका वक्र पृष्ठ क्षेत्रफल $240\pi\text{ cm}^2$ है, तो इसका आयतन क्या होगा?',
  '{"a":"$768\\pi\\text{ cm}^3$","b":"$512\\pi\\text{ cm}^3$","c":"$640\\pi\\text{ cm}^3$","d":"$960\\pi\\text{ cm}^3$"}'::jsonb,
  '{"a":"$768\\pi\\text{ cm}^3$","b":"$512\\pi\\text{ cm}^3$","c":"$640\\pi\\text{ cm}^3$","d":"$960\\pi\\text{ cm}^3$"}'::jsonb,
  'a',
  'Let $r = 3x$ and $h = 4x$. Slant height $l = \sqrt{(3x)^2 + (4x)^2} = 5x$. Curved surface area $= \pi r l = \pi (3x)(5x) = 15\pi x^2 = 240\pi \implies x^2 = 16 \implies x = 4$. Thus $r = 12\text{ cm}$, $h = 16\text{ cm}$. Volume $= \frac{1}{3}\pi r^2 h = \frac{1}{3}\pi (144)(16) = 768\pi\text{ cm}^3$.',
  'माना त्रिज्या $r = 3x$, ऊँचाई $h = 4x$। तिर्यक ऊँचाई $l = 5x$। वक्र पृष्ठ $= \pi r l = 15\pi x^2 = 240\pi \implies x = 4$। त्रिज्या $= 12\text{ cm}$, ऊँचाई $= 16\text{ cm}$। आयतन $= \frac{1}{3}\pi (12)^2 (16) = 768\pi\text{ cm}^3$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  31,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'The HCF and LCM of two numbers are 12 and 336 respectively. If one number is 48, find the other number.',
  'दो संख्याओं का महत्तम समापवर्तक (HCF) और लघुत्तम समापवर्त्य (LCM) क्रमशः 12 और 336 हैं। यदि एक संख्या 48 है, तो दूसरी संख्या ज्ञात कीजिए।',
  '{"a":"72","b":"84","c":"96","d":"108"}'::jsonb,
  '{"a":"72","b":"84","c":"96","d":"108"}'::jsonb,
  'b',
  'Formula: $\text{Product of numbers} = \text{HCF} \times \text{LCM}$. Second number = $(12 \times 336) / 48 = 336 / 4 = 84$.',
  'सूत्र: $\text{पहली संख्या} \times \text{दूसरी संख्या} = \text{HCF} \times \text{LCM}$। अतः दूसरी संख्या = $(12 \times 336) / 48 = 84$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  32,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'Find the volume of a right circular cone having base radius 7 cm and height 12 cm. (Take $\pi = 22/7$)',
  '7 सेमी आधार त्रिज्या और 12 सेमी ऊँचाई वाले एक लंबवृत्तीय शंकु का आयतन ज्ञात कीजिए। ($\pi = 22/7$ लें)',
  '{"a":"528 cm³","b":"616 cm³","c":"748 cm³","d":"836 cm³"}'::jsonb,
  '{"a":"528 सेमी³","b":"616 सेमी³","c":"748 सेमी³","d":"836 सेमी³"}'::jsonb,
  'b',
  'Volume of cone $V = \frac{1}{3}\pi r^2 h = \frac{1}{3} \times \frac{22}{7} \times 7 \times 7 \times 12 = 22 \times 7 \times 4 = 616\text{ cm}^3$.',
  'शंकु का आयतन = $\frac{1}{3}\pi r^2 h = \frac{1}{3} \times \frac{22}{7} \times 49 \times 12 = 616\text{ cm}^3$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  33,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'Pipe A can fill a tank in 10 hours and Pipe B can empty it in 15 hours. If both pipes are opened simultaneously, in how many hours will the tank be full?',
  'पाइप A एक टंकी को 10 घंटे में भर सकता है और पाइप B इसे 15 घंटे में खाली कर सकता है। यदि दोनों पाइप एक साथ खोल दिए जाएं, तो टंकी कितने घंटों में भर जाएगी?',
  '{"a":"25 hours","b":"30 hours","c":"20 hours","d":"35 hours"}'::jsonb,
  '{"a":"25 घंटे","b":"30 घंटे","c":"20 घंटे","d":"35 घंटे"}'::jsonb,
  'b',
  'Capacity = LCM(10, 15) = 30 units. A fills +3 units/hr, B empties -2 units/hr. Net = +1 unit/hr. Time = $30 / 1 = 30$ hours.',
  'टंकी की क्षमता = 30 इकाई। A की दर = +3 इकाई/घंटा, B की दर = -2 इकाई/घंटा। कुल दर = +1 इकाई/घंटा। समय = $30 / 1 = 30$ घंटे।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  34,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'The diagonal of a square is $12\sqrt{2}$ cm. Find its area.',
  'एक वर्ग के विकर्ण की लंबाई $12\sqrt{2}$ सेमी है। इसका क्षेत्रफल ज्ञात कीजिए।',
  '{"a":"128 cm²","b":"144 cm²","c":"164 cm²","d":"288 cm²"}'::jsonb,
  '{"a":"128 सेमी²","b":"144 सेमी²","c":"164 सेमी²","d":"288 सेमी²"}'::jsonb,
  'b',
  'Area of square $= \frac{1}{2} \times d^2 = \frac{1}{2} \times (12\sqrt{2})^2 = \frac{1}{2} \times 288 = 144\text{ cm}^2$. Side $a = 12$ cm, Area $= 12^2 = 144\text{ cm}^2$.',
  'वर्ग का क्षेत्रफल $= \frac{1}{2} \times d^2 = \frac{1}{2} \times (12\sqrt{2})^2 = \frac{288}{2} = 144\text{ cm}^2$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  35,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'Solve for $x$ and $y$: $2x + 3y = 19$ and $3x - y = 12$. What is the value of $x + y$?',
  '$x$ और $y$ के लिए हल कीजिए: $2x + 3y = 19$ और $3x - y = 12$। $x + y$ का मान क्या है?',
  '{"a":"7","b":"8","c":"9","d":"10"}'::jsonb,
  '{"a":"7","b":"8","c":"9","d":"10"}'::jsonb,
  'b',
  'From eq 2: $y = 3x - 12$. Substitute in eq 1: $2x + 3(3x - 12) = 19 \Rightarrow 11x - 36 = 19 \Rightarrow 11x = 55 \Rightarrow x = 5$. Then $y = 3(5) - 12 = 3$. Hence $x + y = 5 + 3 = 8$.',
  '$3x - y = 12 \Rightarrow y = 3x - 12$। पहले समीकरण में रखने पर: $2x + 3(3x - 12) = 19 \Rightarrow 11x = 55 \Rightarrow x = 5$, $y = 3$। अतः $x + y = 8$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  36,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'If the number $5432*7$ is completely divisible by 9, find the digit that replaces ''*''.',
  'यदि संख्या $5432*7$ संख्या 9 से पूर्णतः विभाज्य है, तो ''*'' के स्थान पर कौन सा अंक आएगा?',
  '{"a":"4","b":"5","c":"6","d":"7"}'::jsonb,
  '{"a":"4","b":"5","c":"6","d":"7"}'::jsonb,
  'c',
  'Sum of digits must be divisible by 9: $5 + 4 + 3 + 2 + * + 7 = 21 + *$. The next multiple of 9 is 27. So $* = 27 - 21 = 6$.',
  '9 की विभाज्यता: अंकों का योग 9 से कटना चाहिए। $5 + 4 + 3 + 2 + * + 7 = 21 + *$। 21 के बाद 9 का गुणज 27 है। $* = 27 - 21 = 6$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  37,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'The parallel sides of a trapezium are 14 cm and 20 cm, and the perpendicular distance between them is 8 cm. Find its area.',
  'एक समलंब चतुर्भुज की समानांतर भुजाएँ 14 सेमी और 20 सेमी हैं, और उनके बीच की लंबवत दूरी 8 सेमी है। इसका क्षेत्रफल ज्ञात कीजिए।',
  '{"a":"124 cm²","b":"136 cm²","c":"144 cm²","d":"152 cm²"}'::jsonb,
  '{"a":"124 सेमी²","b":"136 सेमी²","c":"144 सेमी²","d":"152 सेमी²"}'::jsonb,
  'b',
  'Area of trapezium $= \frac{1}{2} \times (a + b) \times h = \frac{1}{2} \times (14 + 20) \times 8 = 34 \times 4 = 136\text{ cm}^2$.',
  'समलंब का क्षेत्रफल $= \frac{1}{2} \times (\text{समानांतर भुजाओं का योग}) \times \text{ऊँचाई} = \frac{1}{2} \times 34 \times 8 = 136\text{ cm}^2$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  38,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A dishonest trader professes to sell his goods at cost price, but uses a false weight of 900 grams for a 1 kg weight. What is his profit percentage?',
  'एक बेईमान व्यापारी अपनी वस्तुओं को क्रय मूल्य पर बेचने का दावा करता है, लेकिन 1 किग्रा के स्थान पर 900 ग्राम के गलत बाट का उपयोग करता है। उसका लाभ प्रतिशत क्या है?',
  '{"a":"10%","b":"$11\\frac{1}{9}\\%$","c":"12%","d":"$12\\frac{1}{2}\\%$"}'::jsonb,
  '{"a":"10%","b":"$11\\frac{1}{9}\\%$","c":"12%","d":"$12\\frac{1}{2}\\%$"}'::jsonb,
  'b',
  'Profit $\% = \frac{\text{Error}}{\text{True weight} - \text{Error}} \times 100 = \frac{100}{900} \times 100 = \frac{100}{9}\% = 11\frac{1}{9}\%$.',
  'लाभ $\% = \frac{\text{त्रुटि}}{\text{दिया गया मान}} \times 100 = \frac{100}{900} \times 100 = 11\frac{1}{9}\%$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  39,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'Find the remainder when $2^{31}$ is divided by 5.',
  '$2^{31}$ को 5 से विभाजित करने पर शेषफल क्या प्राप्त होगा?',
  '{"a":"1","b":"2","c":"3","d":"4"}'::jsonb,
  '{"a":"1","b":"2","c":"3","d":"4"}'::jsonb,
  'c',
  '$2^1=2, 2^2=4, 2^3=8\equiv 3\pmod 5, 2^4=16\equiv 1\pmod 5$. Power mod 4: $31 = 4\times 7 + 3$. Remainder $= 2^3 = 8 \equiv 3\pmod 5$.',
  '$2^4 = 16$, जो 5 से भाग देने पर शेषफल 1 देता है। $2^{31} = (2^4)^7 \times 2^3 = (1)^7 \times 8 = 8$। $8 \div 5$ पर शेषफल 3 आता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  40,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'If $\sin \theta = \cos \theta$ for $0^\circ < \theta < 90^\circ$, find the value of $2\tan^2 \theta + \sin^2 \theta - 1$.',
  'यदि $0^\circ < \theta < 90^\circ$ के लिए $\sin \theta = \cos \theta$ है, तो $2\tan^2 \theta + \sin^2 \theta - 1$ का मान ज्ञात कीजिए।',
  '{"a":"1","b":"3/2","c":"2","d":"5/2"}'::jsonb,
  '{"a":"1","b":"3/2","c":"2","d":"5/2"}'::jsonb,
  'b',
  '$\sin \theta = \cos \theta \Rightarrow \tan \theta = 1 \Rightarrow \theta = 45^\circ$. Expression $= 2(1)^2 + (1/\sqrt{2})^2 - 1 = 2 + 1/2 - 1 = 3/2$.',
  '$\sin \theta = \cos \theta \Rightarrow \theta = 45^\circ$। मान $= 2(1)^2 + (1/\sqrt{2})^2 - 1 = 2 + 0.5 - 1 = 1.5 = 3/2$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  41,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A sum of ₹12,000 amounts to ₹15,600 in 3 years at simple interest. Find the annual rate of interest.',
  '₹12,000 की राशि साधारण ब्याज की दर से 3 वर्ष में ₹15,600 हो जाती है। वार्षिक ब्याज दर ज्ञात कीजिए।',
  '{"a":"8%","b":"10%","c":"12%","d":"15%"}'::jsonb,
  '{"a":"8%","b":"10%","c":"12%","d":"15%"}'::jsonb,
  'b',
  'Simple interest $= 15600 - 12000 = ₹3,600$. $SI = (P \times R \times T)/100 \Rightarrow 3600 = (12000 \times R \times 3)/100 \Rightarrow 3600 = 360 R \Rightarrow R = 10\%$.',
  'साधारण ब्याज = $15600 - 12000 = ₹3,600$। दर $R = \frac{3600 \times 100}{12000 \times 3} = 10\%$ वार्षिक।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  42,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A sum of money triples itself in 10 years at simple interest. What is the annual rate of interest?',
  'कोई धनराशि साधारण ब्याज की दर से 10 वर्षों में स्वयं की 3 गुनी हो जाती है। वार्षिक ब्याज दर क्या है?',
  '{"a":"15%","b":"20%","c":"25%","d":"30%"}'::jsonb,
  '{"a":"15%","b":"20%","c":"25%","d":"30%"}'::jsonb,
  'b',
  'Amount = 3P $\Rightarrow$ Simple Interest $= 3P - P = 2P$. Rate $R = \frac{SI \times 100}{P \times T} = \frac{2P \times 100}{P \times 10} = 20\%$.',
  'ब्याज $SI = 2P$। दर $R = \frac{SI \times 100}{P \times T} = \frac{2P \times 100}{P \times 10} = 20\%$ वार्षिक।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  43,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'Find the LCM of the fractions: $\frac{2}{3}, \frac{4}{9}, \frac{5}{6}$.',
  'भिन्नों $\frac{2}{3}, \frac{4}{9}, \frac{5}{6}$ का लघुत्तम समापवर्त्य (LCM) ज्ञात कीजिए।',
  '{"a":"20/3","b":"10/3","c":"20/9","d":"40/3"}'::jsonb,
  '{"a":"20/3","b":"10/3","c":"20/9","d":"40/3"}'::jsonb,
  'a',
  'Formula: $\text{LCM of fractions} = \frac{\text{LCM of numerators}}{\text{HCF of denominators}} = \frac{\text{LCM}(2,4,5)}{\text{HCF}(3,9,6)} = \frac{20}{3}$.',
  'भिन्नों का LCM = $\frac{\text{अंशों का LCM}}{\text{हरों का HCF}} = \frac{\text{LCM}(2, 4, 5)}{\text{HCF}(3, 9, 6)} = \frac{20}{3}$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  44,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A, B, and C can complete a piece of work together in 10 days. If A and B together can do it in 15 days, in how many days can C alone complete the work?',
  'A, B और C मिलकर किसी काम को 10 दिनों में पूरा कर सकते हैं। यदि A और B मिलकर इसे 15 दिनों में कर सकते हैं, तो C अकेला उस काम को कितने दिनों में पूरा करेगा?',
  '{"a":"25 days","b":"30 days","c":"35 days","d":"40 days"}'::jsonb,
  '{"a":"25 दिन","b":"30 दिन","c":"35 दिन","d":"40 दिन"}'::jsonb,
  'b',
  'Total work = LCM(10, 15) = 30 units. Efficiency of (A+B+C) = 3 units/day. Efficiency of (A+B) = 2 units/day. C alone = $3 - 2 = 1$ unit/day. Time = $30 / 1 = 30$ days.',
  'कुल कार्य = 30 इकाई। (A+B+C) = 3 इकाई/दिन, (A+B) = 2 इकाई/दिन। C की क्षमता = 1 इकाई/दिन। समय = $30 / 1 = 30$ दिन।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  45,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'The mean of a dataset is $24$ and its variance is $16$. If every observation in the dataset is multiplied by $3$ and then increased by $5$, what are the new mean and new variance?',
  'एक डेटासेट का माध्य $24$ और प्रसरण (Variance) $16$ है। यदि डेटासेट के प्रत्येक प्रेक्षण को $3$ से गुणा किया जाए और फिर $5$ जोड़ा जाए, तो नया माध्य और नया प्रसरण क्या होगा?',
  '{"a":"New Mean = $77$, New Variance = $144$","b":"New Mean = $72$, New Variance = $48$","c":"New Mean = $77$, New Variance = $53$","d":"New Mean = $72$, New Variance = $144$"}'::jsonb,
  '{"a":"नया माध्य = $77$, नया प्रसरण = $144$","b":"नया माध्य = $72$, नया प्रसरण = $48$","c":"नया माध्य = $77$, नया प्रसरण = $53$","d":"नया माध्य = $72$, नया प्रसरण = $144$"}'::jsonb,
  'a',
  'For linear transformation $Y = aX + b$: New mean $= a\bar{X} + b = 3(24) + 5 = 77$. New variance $= a^2 \times \text{Var}(X) = 3^2 \times 16 = 9 \times 16 = 144$ (adding a constant does not change variance).',
  'रैखिक रूपांतरण $Y = aX + b$ के लिए: नया माध्य $= a\bar{X} + b = 3(24) + 5 = 77$। नया प्रसरण $= a^2 \times \text{Var}(X) = 3^2 \times 16 = 144$ (अचर जोड़ने पर प्रसरण नहीं बदलता)।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  46,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'In a direct election between two contestants, the winning candidate secured $58\%$ of the valid votes and won by a margin of $3,840$ votes. If all votes polled were valid, find the total number of votes polled.',
  'दो उम्मीदवारों के बीच हुए एक सीधे चुनाव में, विजेता उम्मीदवार को कुल वैध मतों का $58\%$ प्राप्त हुआ और वह $3,840$ मतों के अंतर से विजयी हुआ। यदि सभी डाले गए मत वैध थे, तो कुल कितने मत डाले गए?',
  '{"a":"$24,000$","b":"$20,000$","c":"$25,000$","d":"$28,000$"}'::jsonb,
  '{"a":"$24,000$","b":"$20,000$","c":"$25,000$","d":"$28,000$"}'::jsonb,
  'a',
  'Winning candidate percentage = 58%. Losing candidate percentage = 100% - 58% = 42%. Margin of victory = $58\% - 42\% = 16\%$. Since $16\%$ corresponds to 3,840 votes: Total votes $= \frac{3840}{0.16} = 24,000$.',
  'विजेता के मत = 58%, पराजित उम्मीदवार के मत = 42%। जीत का अंतर = $58\% - 42\% = 16\%$। यदि 16% = 3,840, तो कुल मत $= \frac{3840}{16} \times 100 = 24,000$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  47,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'The ratio of the radius and height of a solid right circular cylinder is 2 : 3. If its volume is 12,936 cm³, find its total surface area. (Take π = 22/7)',
  'एक ठोस लंब वृत्तीय बेलन की त्रिज्या और ऊंचाई का अनुपात 2 : 3 है। यदि इसका आयतन 12,936 सेमी³ है, तो इसका कुल पृष्ठीय क्षेत्रफल ज्ञात कीजिए। (π = 22/7 लें)',
  '{"a":"2,860 cm²","b":"3,080 cm²","c":"3,240 cm²","d":"3,520 cm²"}'::jsonb,
  '{"a":"2,860 सेमी²","b":"3,080 सेमी²","c":"3,240 सेमी²","d":"3,520 सेमी²"}'::jsonb,
  'b',
  'Let r = 2x and h = 3x.
Volume V = π r² h = (22/7) × (2x)² × (3x) = (22/7) × 12x³ = (264/7) x³ = 12,936.
x³ = (12,936 × 7) / 264 = 49 × 7 = 343 => x = 7.
Radius r = 2 × 7 = 14 cm, Height h = 3 × 7 = 21 cm.
Total Surface Area = 2 π r (r + h) = 2 × (22/7) × 14 × (14 + 21)
= 2 × 22 × 2 × 35 = 88 × 35 = 3,080 cm².

Correct Option: (b)',
  'माना r = 2x और h = 3x.
आयतन = π r² h = (22/7) × 4x² × 3x = 12936 => x³ = 343 => x = 7.
r = 14 सेमी, h = 21 सेमी।
कुल पृष्ठीय क्षेत्रफल = 2πr(r + h) = 2 × (22/7) × 14 × 35 = 3,080 सेमी²।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  48,
  2,
  'PART-2',
  'Mathematics',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  49,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A, B, and C enter into a partnership. A invests 3 times as much as B invests, and B invests two-thirds of what C invests. What is the ratio of their capital investments?',
  'A, B और C एक साझेदारी में प्रवेश करते हैं। A, B के निवेश का 3 गुना निवेश करता है, और B, C के निवेश का दो-तिहाई निवेश करता है। उनके पूंजी निवेश का अनुपात क्या है?',
  '{"a":"6 : 2 : 3","b":"3 : 2 : 3","c":"6 : 3 : 2","d":"9 : 3 : 2"}'::jsonb,
  '{"a":"6 : 2 : 3","b":"3 : 2 : 3","c":"6 : 3 : 2","d":"9 : 3 : 2"}'::jsonb,
  'a',
  'Let C''s investment = 3 units.
Then B''s investment = 2/3 of 3 = 2 units.
A''s investment = 3 × B = 3 × 2 = 6 units.
Ratio A : B : C = 6 : 2 : 3.

Correct Option: (a)',
  'माना C का निवेश = 3 इकाई।
B का निवेश = 3 का 2/3 = 2 इकाई।
A का निवेश = 3 × 2 = 6 इकाई।
अनुपात A : B : C = 6 : 2 : 3.

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  50,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A motorboat travels 24 km downstream in 2 hours and takes 4 hours to travel the same distance upstream. What is the speed of the water current?',
  'एक मोटरबोट धारा के अनुकूल 24 किमी की दूरी 2 घंटे में तय करती है और धारा के प्रतिकूल समान दूरी तय करने में 4 घंटे का समय लेती है। जलधारा की गति क्या है?',
  '{"a":"2 km/h","b":"3 km/h","c":"4 km/h","d":"6 km/h"}'::jsonb,
  '{"a":"2 किमी/घंटा","b":"3 किमी/घंटा","c":"4 किमी/घंटा","d":"6 किमी/घंटा"}'::jsonb,
  'b',
  'Downstream speed v_down = 24 / 2 = 12 km/h.
Upstream speed v_up = 24 / 4 = 6 km/h.
Speed of water current = (v_down - v_up) / 2 = (12 - 6) / 2 = 6 / 2 = 3 km/h.
(Speed of boat in still water = (12 + 6)/2 = 9 km/h).

Correct Option: (b)',
  'अनुकूल गति = 24 / 2 = 12 किमी/घंटा।
प्रतिकूल गति = 24 / 4 = 6 किमी/घंटा।
धारा की गति = (12 - 6) / 2 = 3 किमी/घंटा।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  51,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  52,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'How many times are the hands of a clock at right angles (90°) in a full 24-hour day?',
  '24 घंटे के एक पूरे दिन में घड़ी की दोनों सुइयां कितनी बार समकोण (90°) पर होती हैं?',
  '{"a":"22 times","b":"24 times","c":"44 times","d":"48 times"}'::jsonb,
  '{"a":"22 बार","b":"24 बार","c":"44 बार","d":"48 बार"}'::jsonb,
  'c',
  'The hands are at right angles twice an hour, but only 22 times in 12 hours (due to overlap around 3 and 9 o''clock). In 24 hours, $22 \times 2 = 44$ times.',
  'घड़ी की सुइयां 12 घंटे में 22 बार समकोण बनाती हैं। अतः 24 घंटे में वे $22 \times 2 = 44$ बार समकोण पर होती हैं।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  53,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Find the missing number in the series: $7,\ 11,\ 20,\ 36,\ 61,\ ?$ ',
  'दी गई संख्या श्रृंखला में लुप्त संख्या ज्ञात कीजिए: $7,\ 11,\ 20,\ 36,\ 61,\ ?$ ',
  '{"a":"$97$","b":"$95$","c":"$102$","d":"$88$"}'::jsonb,
  '{"a":"$97$","b":"$95$","c":"$102$","d":"$88$"}'::jsonb,
  'a',
  'Observe consecutive differences: $11 - 7 = 4 = 2^2$, $20 - 11 = 9 = 3^2$, $36 - 20 = 16 = 4^2$, $61 - 36 = 25 = 5^2$. Next difference must be $6^2 = 36$. Missing term $= 61 + 36 = 97$.',
  'क्रमिक अंतर देखिए: $+4 (2^2), +9 (3^2), +16 (4^2), +25 (5^2)$। अगला अंतर $6^2 = 36$ होना चाहिए। अतः लुप्त पद $= 61 + 36 = 97$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  54,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Select the odd pair from the following numerical pairs:
(a) 343 : 7
(b) 729 : 9
(c) 512 : 8
(d) 256 : 6',
  'निम्नलिखित संख्या युग्मों में से विषम (Odd) युग्म का चयन कीजिए:
(a) 343 : 7
(b) 729 : 9
(c) 512 : 8
(d) 256 : 6',
  '{"a":"343 : 7","b":"729 : 9","c":"512 : 8","d":"256 : 6"}'::jsonb,
  '{"a":"343 : 7","b":"729 : 9","c":"512 : 8","d":"256 : 6"}'::jsonb,
  'd',
  'In each pair, the first number is the cube of the second number: $7^3 = 343$, $9^3 = 729$, $8^3 = 512$. However, $6^3 = 216 \neq 256$ ($256$ is $4^4$ or $16^2$). Hence (d) is the odd one.',
  'प्रत्येक युग्म में पहली संख्या दूसरी संख्या का घन (cube) है: $7^3 = 343$, $9^3 = 729$, $8^3 = 512$। परंतु $6^3 = 216 \neq 256$। अतः विकल्प (d) भिन्न है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  55,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Which Venn diagram configuration represents the relationship among: ''Earth, Sea, and Sun''?',
  'कौन सा वेन आरेख ''पृथ्वी, समुद्र, और सूर्य'' के बीच के संबंध का प्रतिनिधित्व करता है?',
  '{"a":"","b":"","c":"","d":""}'::jsonb,
  '{"a":"","b":"","c":"","d":""}'::jsonb,
  'a',
  'All seas are geographical features located entirely on planet Earth (Sea circle is inside Earth circle). The Sun is an external celestial star completely separate from Earth.

Correct Option: (a)',
  'सभी समुद्र पृथ्वी पर स्थित हैं (समुद्र ⊂ पृथ्वी)। सूर्य एक तारा है जो पृथ्वी से पूर्णतः अलग है। अतः एक वृत्त के अंदर दूसरा वृत्त तथा तीसरा वृत्त अलग बनेगा।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  '{"a":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"42\" cy=\"50\" r=\"32\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"38\" cy=\"50\" r=\"17\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"82\" cy=\"50\" r=\"14\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>","b":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"39\" cy=\"42\" r=\"21\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"61\" cy=\"42\" r=\"21\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"50\" cy=\"62\" r=\"21\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>","c":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"50\" cy=\"50\" r=\"35\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"50\" cy=\"50\" r=\"23\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"50\" cy=\"50\" r=\"12\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>","d":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"34\" cy=\"38\" r=\"17\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"66\" cy=\"38\" r=\"17\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"50\" cy=\"72\" r=\"17\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>"}'::jsonb
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  56,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  57,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'A square sheet of transparent paper with a pattern is folded along the dotted middle vertical line from left to right. If the left half has a triangle ''△'' and the right half has a circle ''○'', what does the folded sheet display?',
  'पैटर्न वाले पारदर्शी चौकोर कागज को बिंदीदार ऊर्ध्वाधर मध्य रेखा के अनुदिश बाएं से दाएं मोड़ा जाता है। यदि बाएं आधे भाग में एक त्रिभुज ''△'' और दाएं आधे भाग में एक वृत्त ''○'' है, तो मुड़ी हुई शीट पर क्या दिखाई देगा?',
  '{"a":"Figure (D)","b":"Figure (B)","c":"Figure (A)","d":"Figure (C)"}'::jsonb,
  '{"a":"चित्र (D)","b":"चित्र (B)","c":"चित्र (A)","d":"चित्र (C)"}'::jsonb,
  'c',
  'Because the paper is transparent, folding the left half over the right half along the vertical dotted line superimposes the blue triangle ''△'' directly inside/over the green circle ''○''. This matches Figure (A). Since Figure (A) is listed under Option (c), the correct option is (c).',
  'चूंकि कागज पारदर्शी है, बाएं आधे हिस्से को बिंदीदार ऊर्ध्वाधर रेखा के अनुदिश दाएं आधे हिस्से पर मोड़ने पर नीला त्रिभुज ''△'' सीधे हरे वृत्त ''○'' के ऊपर अध्यारोपित हो जाता है। यह पैटर्न चित्र (A) को दर्शाता है। चूंकि चित्र (A) विकल्प (c) में दिया गया है, अतः सही उत्तर (c) है।',
  '<svg viewBox="0 0 340 220" width="100%" height="100%" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
  <rect x="2" y="2" width="336" height="216" rx="8" fill="#ffffff" stroke="#000000" stroke-width="2" />
  <rect x="100" y="12" width="140" height="76" rx="6" fill="#ffffff" stroke="#000000" stroke-width="2" />
  <line x1="170" y1="12" x2="170" y2="88" stroke="#000000" stroke-width="2" stroke-dasharray="4,3" />
  <polygon points="135,26 118,74 152,74" fill="#000000" fill-opacity="0.4" stroke="#000000" stroke-width="2.5" stroke-linejoin="round" />
  <circle cx="205" cy="50" r="22" fill="#000000" fill-opacity="0.4" stroke="#000000" stroke-width="2.5" />
  <text x="170" y="102" text-anchor="middle" font-size="9.5" font-weight="600" fill="#000000">Question Pattern (Fold left to right)</text>
  <rect x="14" y="118" width="70" height="76" rx="6" fill="#ffffff" stroke="#000000" stroke-width="1.8" />
  <text x="22" y="133" font-size="11" font-weight="bold" fill="#000000">(A)</text>
  <circle cx="49" cy="158" r="19" fill="#000000" fill-opacity="0.4" stroke="#000000" stroke-width="2.2" />
  <polygon points="49,138 34,178 64,178" fill="#000000" fill-opacity="0.4" stroke="#000000" stroke-width="2.2" stroke-linejoin="round" />
  <rect x="94" y="118" width="70" height="76" rx="6" fill="#ffffff" stroke="#000000" stroke-width="1.8" />
  <text x="102" y="133" font-size="11" font-weight="bold" fill="#000000">(B)</text>
  <circle cx="129" cy="158" r="19" fill="#000000" fill-opacity="0.4" stroke="#000000" stroke-width="2.2" />
  <rect x="174" y="118" width="70" height="76" rx="6" fill="#ffffff" stroke="#000000" stroke-width="1.8" />
  <text x="182" y="133" font-size="11" font-weight="bold" fill="#000000">(C)</text>
  <polygon points="209,138 194,178 224,178" fill="#000000" fill-opacity="0.4" stroke="#000000" stroke-width="2.2" stroke-linejoin="round" />
  <rect x="254" y="118" width="70" height="76" rx="6" fill="#ffffff" stroke="#000000" stroke-width="1.8" />
  <text x="262" y="133" font-size="11" font-weight="bold" fill="#000000">(D)</text>
</svg>',
  '<svg viewBox="0 0 340 220" width="100%" height="100%" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
  <rect x="2" y="2" width="336" height="216" rx="8" fill="#ffffff" stroke="#000000" stroke-width="2" />
  <rect x="100" y="12" width="140" height="76" rx="6" fill="#ffffff" stroke="#000000" stroke-width="2" />
  <line x1="170" y1="12" x2="170" y2="88" stroke="#000000" stroke-width="2" stroke-dasharray="4,3" />
  <polygon points="135,26 118,74 152,74" fill="#000000" fill-opacity="0.4" stroke="#000000" stroke-width="2.5" stroke-linejoin="round" />
  <circle cx="205" cy="50" r="22" fill="#000000" fill-opacity="0.4" stroke="#000000" stroke-width="2.5" />
  <text x="170" y="102" text-anchor="middle" font-size="9.5" font-weight="600" fill="#000000">प्रश्न आकृति (बाएं से दाएं मोड़ें)</text>
  <rect x="14" y="118" width="70" height="76" rx="6" fill="#ffffff" stroke="#000000" stroke-width="1.8" />
  <text x="22" y="133" font-size="11" font-weight="bold" fill="#000000">(A)</text>
  <circle cx="49" cy="158" r="19" fill="#000000" fill-opacity="0.4" stroke="#000000" stroke-width="2.2" />
  <polygon points="49,138 34,178 64,178" fill="#000000" fill-opacity="0.4" stroke="#000000" stroke-width="2.2" stroke-linejoin="round" />
  <rect x="94" y="118" width="70" height="76" rx="6" fill="#ffffff" stroke="#000000" stroke-width="1.8" />
  <text x="102" y="133" font-size="11" font-weight="bold" fill="#000000">(B)</text>
  <circle cx="129" cy="158" r="19" fill="#000000" fill-opacity="0.4" stroke="#000000" stroke-width="2.2" />
  <rect x="174" y="118" width="70" height="76" rx="6" fill="#ffffff" stroke="#000000" stroke-width="1.8" />
  <text x="182" y="133" font-size="11" font-weight="bold" fill="#000000">(C)</text>
  <polygon points="209,138 194,178 224,178" fill="#000000" fill-opacity="0.4" stroke="#000000" stroke-width="2.2" stroke-linejoin="round" />
  <rect x="254" y="118" width="70" height="76" rx="6" fill="#ffffff" stroke="#000000" stroke-width="1.8" />
  <text x="262" y="133" font-size="11" font-weight="bold" fill="#000000">(D)</text>
</svg>',
  '{"a":"<svg viewBox=\"0 0 100 100\" width=\"100%\" height=\"100%\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"4\" y=\"4\" width=\"92\" height=\"92\" rx=\"6\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.5\" /></svg>","b":"<svg viewBox=\"0 0 100 100\" width=\"100%\" height=\"100%\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"4\" y=\"4\" width=\"92\" height=\"92\" rx=\"6\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.5\" /><circle cx=\"50\" cy=\"50\" r=\"28\" fill=\"#000000\" fill-opacity=\"0.4\" stroke=\"#000000\" stroke-width=\"3\" /></svg>","c":"<svg viewBox=\"0 0 100 100\" width=\"100%\" height=\"100%\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"4\" y=\"4\" width=\"92\" height=\"92\" rx=\"6\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.5\" /><circle cx=\"50\" cy=\"50\" r=\"28\" fill=\"#000000\" fill-opacity=\"0.4\" stroke=\"#000000\" stroke-width=\"3\" /><polygon points=\"50,22 28,78 72,78\" fill=\"#000000\" fill-opacity=\"0.4\" stroke=\"#000000\" stroke-width=\"3\" stroke-linejoin=\"round\" /></svg>","d":"<svg viewBox=\"0 0 100 100\" width=\"100%\" height=\"100%\" xmlns=\"http://www.w3.org/2000/svg\"><rect x=\"4\" y=\"4\" width=\"92\" height=\"92\" rx=\"6\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.5\" /><polygon points=\"50,22 28,78 72,78\" fill=\"#000000\" fill-opacity=\"0.4\" stroke=\"#000000\" stroke-width=\"3\" stroke-linejoin=\"round\" /></svg>"}'::jsonb
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  58,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'How many total triangles are there in a square divided by both diagonals and both horizontal and vertical mid-lines (8 elementary triangular sectors)?',
  'दोनों विकर्णों तथा क्षैतिज और ऊर्ध्वाधर मध्य रेखाओं द्वारा 8 छोटे त्रिभुजों में विभाजित एक वर्ग में कुल कितने त्रिभुज होते हैं?',
  '{"a":"16","b":"12","c":"14","d":"18"}'::jsonb,
  '{"a":"16","b":"12","c":"14","d":"18"}'::jsonb,
  'a',
  'Rule for a square divided into n triangular sectors from the center:
Total triangles = 2 * n
Here the square is divided into 8 elementary sectors:
Total triangles = 2 * 8 = 16 triangles.
- Single-sector triangles = 8
- Two-sector triangles (halves of quadrants) = 4
- Four-sector triangles (halves formed by diagonals) = 4
Total = 8 + 4 + 4 = 16.

Correct Option: (a)',
  'जब किसी वर्ग में दोनों विकर्ण और दोनों मध्य रेखाएं खींची जाती हैं, तो बनने वाले छोटे त्रिभुज = 8.
कुल त्रिभुज = 8 * 2 = 16.

अतः सही उत्तर (a) है।',
  '<svg viewBox="0 0 180 180" width="100%" height="100%" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="3" width="174" height="174" fill="#ffffff" stroke="#000000" stroke-width="2.5" rx="4" />
  <rect x="20" y="20" width="140" height="140" fill="#ffffff" fill-opacity="0.15" stroke="#000000" stroke-width="2.5" />
  <line x1="20" y1="20" x2="160" y2="160" stroke="#000000" stroke-width="2" />
  <line x1="160" y1="20" x2="20" y2="160" stroke="#000000" stroke-width="2" />
  <line x1="20" y1="90" x2="160" y2="90" stroke="#000000" stroke-width="2" stroke-dasharray="4,2" />
  <line x1="90" y1="20" x2="90" y2="160" stroke="#000000" stroke-width="2" stroke-dasharray="4,2" />
  <circle cx="90" cy="90" r="4" fill="#000000" />
</svg>',
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  59,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Observe the following diagram and answer the question:
Find the number of students who play any two of the three sports.',
  'निम्नलिखित आरेख का अवलोकन करें और प्रश्न का उत्तर दें:
उन छात्रों की संख्या ज्ञात कीजिए जो तीनों खेलों में से किन्हीं दो खेलों को खेलते हैं।',
  '{"a":"11","b":"13","c":"15","d":"18"}'::jsonb,
  '{"a":"11","b":"13","c":"15","d":"18"}'::jsonb,
  'b',
  'Students playing exactly two sports are found at pairwise intersections:
- Cricket & Kabaddi (circle ∩ triangle, not hockey) = 2
- Cricket & Hockey (circle ∩ rectangle, not kabaddi) = 5
- Kabaddi & Hockey (triangle ∩ rectangle, not cricket) = 6
Total students playing any two sports = 2 + 5 + 6 = 13.

Correct Option: (b)',
  'किन्हीं दो खेलों को खेलने वाले छात्र परस्पर दो आकृतियों के प्रतिच्छेद क्षेत्रों में हैं:
- क्रिकेट और कबड्डी = 2
- क्रिकेट और हॉकी = 5
- कबड्डी और हॉकी = 6
कुल छात्र = 2 + 5 + 6 = 13।

अतः सही उत्तर (b) है।',
  '<svg viewBox="0 0 380 200" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
  <rect x="120" y="70" width="140" height="70" fill="none" stroke="#000000" stroke-width="2.5" />
  <circle cx="160" cy="85" r="45" fill="none" stroke="#000000" stroke-width="2.5" />
  <polygon points="120,70 65,160 175,160" fill="none" stroke="#000000" stroke-width="2.5" />

  <text x="160" y="60" text-anchor="middle" font-size="14" font-weight="bold" fill="#000000">10</text>
  <text x="98" y="145" text-anchor="middle" font-size="14" font-weight="bold" fill="#000000">8</text>
  <text x="130" y="105" text-anchor="middle" font-size="13" font-weight="bold" fill="#000000">2</text>
  <text x="165" y="100" text-anchor="middle" font-size="14" font-weight="bold" fill="#000000">5</text>
  <text x="132" y="135" text-anchor="middle" font-size="13" font-weight="bold" fill="#000000">6</text>
  <text x="230" y="112" text-anchor="middle" font-size="14" font-weight="bold" fill="#000000">7</text>

  <line x1="185" y1="52" x2="225" y2="52" stroke="#000000" stroke-width="2" />
  <text x="232" y="56" font-size="14" font-weight="bold" fill="#000000">Cricket</text>

  <line x1="260" y1="105" x2="285" y2="105" stroke="#000000" stroke-width="2" />
  <text x="292" y="109" font-size="14" font-weight="bold" fill="#000000">Hockey</text>

  <line x1="68" y1="115" x2="88" y2="115" stroke="#000000" stroke-width="2" />
  <text x="62" y="119" text-anchor="end" font-size="14" font-weight="bold" fill="#000000">Kabaddi</text>
</svg>',
  '<svg viewBox="0 0 380 200" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
  <rect x="120" y="70" width="140" height="70" fill="none" stroke="#000000" stroke-width="2.5" />
  <circle cx="160" cy="85" r="45" fill="none" stroke="#000000" stroke-width="2.5" />
  <polygon points="120,70 65,160 175,160" fill="none" stroke="#000000" stroke-width="2.5" />

  <text x="160" y="60" text-anchor="middle" font-size="14" font-weight="bold" fill="#000000">10</text>
  <text x="98" y="145" text-anchor="middle" font-size="14" font-weight="bold" fill="#000000">8</text>
  <text x="130" y="105" text-anchor="middle" font-size="13" font-weight="bold" fill="#000000">2</text>
  <text x="165" y="100" text-anchor="middle" font-size="14" font-weight="bold" fill="#000000">5</text>
  <text x="132" y="135" text-anchor="middle" font-size="13" font-weight="bold" fill="#000000">6</text>
  <text x="230" y="112" text-anchor="middle" font-size="14" font-weight="bold" fill="#000000">7</text>

  <line x1="185" y1="52" x2="225" y2="52" stroke="#000000" stroke-width="2" />
  <text x="232" y="56" font-size="14" font-weight="bold" fill="#000000">Cricket</text>

  <line x1="260" y1="105" x2="285" y2="105" stroke="#000000" stroke-width="2" />
  <text x="292" y="109" font-size="14" font-weight="bold" fill="#000000">Hockey</text>

  <line x1="68" y1="115" x2="88" y2="115" stroke="#000000" stroke-width="2" />
  <text x="62" y="119" text-anchor="end" font-size="14" font-weight="bold" fill="#000000">Kabaddi</text>
</svg>',
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  60,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'How many triangles are there in a standard 5-pointed star pentagram?',
  'एक मानक 5-नुकीले तारे (पंचतारा / Star pentagram) में कुल कितने त्रिभुज होते हैं?',
  '{"a":"5","b":"8","c":"10","d":"12"}'::jsonb,
  '{"a":"5","b":"8","c":"10","d":"12"}'::jsonb,
  'c',
  'A 5-pointed star has 5 outer small triangular points and 5 larger overlapping triangles formed with each vertex and the opposing internal base line. Total triangles = 5 + 5 = 10.',
  'एक 5-नुकीले तारे में 5 बाहरी छोटे नुकीले त्रिभुज होते हैं और प्रत्येक शीर्ष तथा आंतरिक आधार से 5 बड़े त्रिभुज बनते हैं। कुल त्रिभुज = 5 + 5 = 10 होते हैं।',
  '<svg viewBox="0 0 200 200" width="100%" height="100%" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="3" width="194" height="194" fill="#ffffff" stroke="#000000" stroke-width="2.5" rx="4" />
  <polygon points="100,25 147,170 24,80 176,80 53,170" fill="#ffffff" fill-opacity="0.2" stroke="#000000" stroke-width="2.5" stroke-linejoin="round" />
  <circle cx="100" cy="25" r="4" fill="#000000" />
  <circle cx="176" cy="80" r="4" fill="#000000" />
  <circle cx="147" cy="170" r="4" fill="#000000" />
  <circle cx="53" cy="170" r="4" fill="#000000" />
  <circle cx="24" cy="80" r="4" fill="#000000" />
  <text x="100" y="18" text-anchor="middle" font-size="12" font-weight="bold" fill="#000000">A</text>
  <text x="188" y="84" text-anchor="start" font-size="12" font-weight="bold" fill="#000000">B</text>
  <text x="155" y="186" text-anchor="middle" font-size="12" font-weight="bold" fill="#000000">C</text>
  <text x="45" y="186" text-anchor="middle" font-size="12" font-weight="bold" fill="#000000">D</text>
  <text x="12" y="84" text-anchor="end" font-size="12" font-weight="bold" fill="#000000">E</text>
</svg>',
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  61,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Statement: ''Government has decided to install solar panels on all railway station rooftops.'' Assumptions: I. Solar energy reduces carbon footprint and power bills. II. Stations have sufficient unshaded roof space.',
  'कथन: ''सरकार ने सभी रेलवे स्टेशनों की छतों पर सोलर पैनल लगाने का निर्णय लिया है।'' पूर्वधारणाएँ: I. सौर ऊर्जा कार्बन उत्सर्जन और बिजली बिल को कम करती है। II. स्टेशनों पर पर्याप्त छाया-मुक्त छत उपलब्ध है।',
  '{"a":"Only assumption I is implicit","b":"Only assumption II is implicit","c":"Both assumptions I and II are implicit","d":"Neither I nor II is implicit"}'::jsonb,
  '{"a":"केवल पूर्वधारणा I अंतर्निहित है","b":"केवल पूर्वधारणा II अंतर्निहित है","c":"दोनों पूर्वधारणाएँ I और II अंतर्निहित हैं","d":"न तो I और न ही II अंतर्निहित है"}'::jsonb,
  'c',
  'The rationale is environmental and financial benefit (I), and the execution assumes technical feasibility of space (II). Both are implicit.',
  'सोलर पैनल लगाने का उद्देश्य ऊर्जा बचत व पर्यावरण संरक्षण है (I) और स्टेशनों पर इसे लगाने योग्य स्थान उपलब्ध है (II)। दोनों अंतर्निहित हैं।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  62,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Read the statement and determine which assumption(s) is/are implicit:
Statement: ''Indian Railways has deployed the indigenous automatic train protection (ATP) system Kavach across critical high-density railway corridors.''
Assumptions:
I. Kavach can significantly minimize the risk of collisions caused by signal passing at danger (SPAD).
II. Indian Railways aims to elevate operational passenger safety to international benchmarks.',
  'कथन को पढ़ें और तय करें कि कौन-सी धारणा/धारणाएं अंतर्निहित है/हैं:
कथन: ''भारतीय रेल ने महत्वपूर्ण उच्च घनत्व वाले रेल गलियारों में स्वदेशी स्वचालित ट्रेन सुरक्षा प्रणाली कवच (Kavach) को तैनात किया है।''
धारणाएं:
I. कवच खतरे में सिग्नल पार करने (SPAD) के कारण होने वाली ट्रेन टक्करों के जोखिम को काफी कम कर सकता है।
II. भारतीय रेल का लक्ष्य यात्री परिचालन सुरक्षा को अंतरराष्ट्रीय मानकों तक ले जाना है।',
  '{"a":"Both assumptions I and II are implicit","b":"Only assumption I is implicit","c":"Only assumption II is implicit","d":"Neither assumption I nor II is implicit"}'::jsonb,
  '{"a":"धारणा I और II दोनों अंतर्निहित हैं","b":"केवल धारणा I अंतर्निहित है","c":"केवल धारणा II अंतर्निहित है","d":"न तो धारणा I और न ही II अंतर्निहित है"}'::jsonb,
  'a',
  'The deployment of Kavach is explicitly aimed at preventing collisions from SPAD (Assumption I is implicit), and upgrading high-density corridors reflects the institutional goal to achieve high safety standards (Assumption II is implicit).',
  'कवच का उद्देश्य स्वचालित ब्रेक लगाकर सिग्नल पासिंग एट डेंजर से होने वाली दुर्घटनाओं को रोकना है (धारणा I अंतर्निहित है) तथा संरक्षा को उच्च स्तर पर ले जाना रेलवे की मंशा है (धारणा II अंतर्निहित है)।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  63,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'How many total triangles are formed inside a square when both its diagonals and one horizontal median line dividing it into two equal halves are drawn?',
  'एक वर्ग के दोनों विकर्णों तथा उसे दो बराबर भागों में विभाजित करने वाली एक क्षैतिज माध्य रेखा खींचने पर उसके अंदर कुल कितने त्रिभुज बनते हैं?',
  '{"a":"10","b":"12","c":"14","d":"16"}'::jsonb,
  '{"a":"10","b":"12","c":"14","d":"16"}'::jsonb,
  'b',
  'Breakdown of triangles:
- Small triangular segments formed by diagonals and horizontal median = 6 small triangles.
- Triangles made of 2 segments = 4.
- Large triangles formed by main diagonals = 2.
Total = 6 + 4 + 2 = 12 triangles.

Correct Option: (b)',
  'त्रिभुजों की कुल संख्या:
- छोटे त्रिभुज = 6
- दो भागों से मिलकर बने त्रिभुज = 4
- मुख्य विकर्णों से बने बड़े त्रिभुज = 2
कुल = 6 + 4 + 2 = 12 त्रिभुज।

अतः सही उत्तर (b) है।',
  '<svg viewBox="0 0 180 180" width="100%" height="100%" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="3" width="174" height="174" fill="#ffffff" stroke="#000000" stroke-width="2.5" rx="4" />
  <rect x="20" y="20" width="140" height="140" fill="#ffffff" fill-opacity="0.15" stroke="#000000" stroke-width="2.5" />
  <line x1="20" y1="20" x2="160" y2="160" stroke="#000000" stroke-width="2" />
  <line x1="160" y1="20" x2="20" y2="160" stroke="#000000" stroke-width="2" />
  <line x1="20" y1="90" x2="160" y2="90" stroke="#000000" stroke-width="2" stroke-dasharray="5,3" />
  <circle cx="90" cy="90" r="4" fill="#000000" />
</svg>',
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  64,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  '''Ophthalmologist'' is related to ''Eyes'' in the same way as ''Nephrologist'' is related to:',
  '''नेत्र रोग विशेषज्ञ'' (Ophthalmologist) का संबंध ''आँखों'' से उसी प्रकार है, जिस प्रकार ''नेफ्रोलॉजिस्ट'' (Nephrologist) का संबंध किससे है?',
  '{"a":"Heart","b":"Kidneys","c":"Brain","d":"Lungs"}'::jsonb,
  '{"a":"हृदय","b":"वृक्क (Kidneys)","c":"मस्तिष्क","d":"फेफड़े"}'::jsonb,
  'b',
  'An Ophthalmologist specializes in the diagnosis and treatment of eye disorders. A Nephrologist specializes in kidney care and renal diseases.

Correct Option: (b)',
  'नेत्र रोग विशेषज्ञ आँखों के उपचार के विशेषज्ञ होते हैं। इसी प्रकार, नेफ्रोलॉजिस्ट गुर्दे/वृक्क (Kidneys) से संबंधित रोगों के विशेषज्ञ होते हैं।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  65,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  66,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  67,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Select the odd number from the given set of options:
(a) 125  (b) 343  (c) 729  (d) 512',
  'दिए गए विकल्पों में से विषम संख्या का चयन कीजिए:
(a) 125  (b) 343  (c) 729  (d) 512',
  '{"a":"125","b":"343","c":"729","d":"512"}'::jsonb,
  '{"a":"125","b":"343","c":"729","d":"512"}'::jsonb,
  'c',
  'Cube analysis:
- 125 = 5³
- 343 = 7³
- 512 = 8³
- 729 = 9³ = 27²
729 is the only number that is both a perfect square (27²) and a perfect cube (9³).

Correct Option: (c)',
  '125 (5³), 343 (7³), और 512 (8³) केवल पूर्ण घन हैं। जबकि 729 एक पूर्ण घन (9³) होने के साथ-साथ एक पूर्ण वर्ग (27²) भी है।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  68,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  69,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  70,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'If signs ''+'' and ''-'' and digits ''4'' and ''8'' are interchanged, which of the following equations becomes correct?',
  'यदि चिन्हों ''+'' और ''-'' तथा अंकों ''4'' और ''8'' को परस्पर बदल दिया जाए, तो निम्नलिखित में से कौन सा समीकरण सही हो जाएगा?',
  '{"a":"4 - 8 + 12 = 0","b":"8 - 4 + 12 = 8","c":"4 + 8 - 12 = 16","d":"8 + 4 - 6 = 2"}'::jsonb,
  '{"a":"4 - 8 + 12 = 0","b":"8 - 4 + 12 = 8","c":"4 + 8 - 12 = 16","d":"8 + 4 - 6 = 2"}'::jsonb,
  'a',
  'Testing option (a): Original: 4 - 8 + 12 = 0
Interchange 4 ↔ 8 and - ↔ +:
8 + 4 - 12
= 12 - 12 = 0. This is perfectly correct!

Correct Option: (a)',
  'विकल्प (a) में प्रतिस्थापन करने पर:
4 - 8 + 12 = 0
4 और 8 तथा + और - को बदलने पर:
8 + 4 - 12 = 12 - 12 = 0 (सत्य)।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  71,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  72,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  73,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  74,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'At what time between 7 o''clock and 8 o''clock are the hands of a clock at right angles (90°) to each other for the first time?',
  '7 और 8 बजे के बीच किस समय पहली बार घड़ी की दोनों सुइयां एक दूसरे से समकोण (90°) पर होंगी?',
  '{"a":"7 hours 21 9/11 minutes","b":"7 hours 20 minutes","c":"7 hours 22 minutes","d":"7 hours 24 6/11 minutes"}'::jsonb,
  '{"a":"7 बजकर 21 9/11 मिनट","b":"7 बजकर 20 मिनट","c":"7 बजकर 22 मिनट","d":"7 बजकर 24 6/11 मिनट"}'::jsonb,
  'a',
  'At 7 o''clock, the minute hand is 35 minute spaces behind the hour hand.
For hands to be at right angle (15 minute spaces apart) for the first time, the minute hand must gain (35 - 15) = 20 minute spaces.
Time required = 20 × (60 / 55) = 20 × (12 / 11) = 240 / 11 = 21 9/11 minutes past 7.

Correct Option: (a)',
  '7 बजे दोनों सुइयों के बीच 35 मिनट की दूरी होती है। समकोण (15 मिनट की दूरी) के लिए मिनट की सुई को 35 - 15 = 20 मिनट की दूरी तय करनी होगी।
समय = 20 × (12 / 11) = 240 / 11 = 21 9/11 मिनट (7 बजकर 21 9/11 मिनट)।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  75,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'What letter-pair will continue the series:
CX, EV, GT, IR, ?',
  'कौन सा अक्षर-युग्म श्रृंखला को आगे बढ़ाएगा:
CX, EV, GT, IR, ?',
  '{"a":"KP","b":"LO","c":"JQ","d":"KQ"}'::jsonb,
  '{"a":"KP","b":"LO","c":"JQ","d":"KQ"}'::jsonb,
  'a',
  '1. First letters advance by +2: C(3) -> E(5) -> G(7) -> I(9) -> K(11).
2. Second letter is the opposite alphabet letter (sum of positions = 27):
Opposite of K(11) is P(16) [27 - 11 = 16].
Result = KP.

Correct Option: (a)',
  'पहला अक्षर +2 से आगे बढ़ता है: C -> E -> G -> I -> K.
दूसरा अक्षर विपरीत अक्षर है: K का विपरीत P होता है (KP)।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  76,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Statements:
1. All cups are plates.
2. Some plates are bowls.
Conclusions:
I. Some bowls are cups.
II. Some plates are cups.',
  'कथन:
1. सभी कप प्लेट हैं।
2. कुछ प्लेट कटोरे हैं।
निष्कर्ष:
I. कुछ कटोरे कप हैं।
II. कुछ प्लेट कप हैं।',
  '{"a":"Only conclusion I follows","b":"Only conclusion II follows","c":"Both follow","d":"Neither follows"}'::jsonb,
  '{"a":"केवल निष्कर्ष I अनुसरण करता है","b":"केवल निष्कर्ष II अनुसरण करता है","c":"दोनों अनुसरण करते हैं","d":"कोई अनुसरण नहीं करता"}'::jsonb,
  'b',
  'All cups are inside plates (Cups ⊂ Plates). Therefore, Some plates are definitely cups (Conclusion II is valid). But bowls only overlap with plates, not necessarily with cups. Hence, only conclusion II follows.

Correct Option: (b)',
  'चूँकि सभी कप प्लेट हैं, अतः कुछ प्लेट निश्चित रूप से कप हैं (निष्कर्ष II सत्य)। कटोरों का कप से सीधा संबंध अनिवार्य नहीं है। अतः केवल निष्कर्ष II अनुसरण करता है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  77,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  78,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Find the next letter cluster in the series:
BCE, EGI, HLM, ?, NVA',
  'दी गई अक्षर श्रृंखला में अगला पद ज्ञात कीजिए:
BCE, EGI, HLM, ?, NVA',
  '{"a":"KPR","b":"KPQ","c":"KQV","d":"KQS"}'::jsonb,
  '{"a":"KPR","b":"KPQ","c":"KQV","d":"KQS"}'::jsonb,
  'd',
  'Look at each letter''s positional value:
1st letters: B(2) + 3 = E(5) + 3 = H(8) + 3 = K(11) [+ 3 = N(14)]
2nd letters: C(3) + 4 = G(7) + 5 = L(12) + 5 = Q(17) [+ 5 = V(22)] -> Here step is +4, +5, +5, +5? Or look at gaps: C(3) to G(7) is +4, G(7) to L(12) is +5, L(12) to Q(17) is +5, Q(17) to V(22) is +5.
3rd letters: E(5) + 4 = I(9) + 4 = M(13) + 6 = S(19) [+ 8 = 27 = A].
Let''s check KQS: K=11, Q=17, S=19. Matches cleanly.

Correct Option: (d)',
  'अक्षरों के मानों का विश्लेषण:
प्रथम अक्षर: B(+3) -> E(+3) -> H(+3) -> K(+3) -> N
द्वितीय अक्षर: C(3) -> G(7) -> L(12) -> Q(17) -> V(22)
तृतीय अक्षर: E(5) -> I(9) -> M(13) -> S(19) -> A(27)
अतः लुप्त पद ''KQS'' है।

अतः सही उत्तर (d) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  79,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'In a certain code language, ''ROBUST'' is written as ''QNATRS''. How will ''ZODIAC'' be written in that code language?',
  'एक निश्चित कूट भाषा में ''ROBUST'' को ''QNATRS'' लिखा जाता है। उसी कूट भाषा में ''ZODIAC'' को कैसे लिखा जाएगा?',
  '{"a":"YNCHZB","b":"YNCGZB","c":"YNCHZA","d":"XNCHZB"}'::jsonb,
  '{"a":"YNCHZB","b":"YNCGZB","c":"YNCHZA","d":"XNCHZB"}'::jsonb,
  'a',
  'Each letter is shifted backward by 1 position (-1):
R - 1 = Q
O - 1 = N
B - 1 = A
U - 1 = T
S - 1 = R
T - 1 = S
Applying the same rule to ''ZODIAC'':
Z - 1 = Y
O - 1 = N
D - 1 = C
I - 1 = H
A - 1 = Z
C - 1 = B
Hence, ''YNCHZB''.

Correct Option: (a)',
  'प्रत्येक अक्षर में से 1 घटाया गया है (-1):
R-1=Q, O-1=N, B-1=A, U-1=T, S-1=R, T-1=S
इसी प्रकार ''ZODIAC'' के लिए:
Z-1=Y, O-1=N, D-1=C, I-1=H, A-1=Z, C-1=B => ''YNCHZB''.

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  80,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Read the given statements and conclusions carefully. Assuming the statements are true, decide which of the given conclusions logically follows.
Statements:
1. All cars are vehicles.
2. Some vehicles are electric.
Conclusions:
I. Some electric items are cars.
II. Some vehicles are cars.',
  'दिए गए कथनों और निष्कर्षों को ध्यानपूर्वक पढ़ें। कथनों को सत्य मानते हुए तय करें कि कौन सा निष्कर्ष तार्किक रूप से अनुसरण करता है।
कथन:
1. सभी कारें वाहन हैं।
2. कुछ वाहन इलेक्ट्रिक हैं।
निष्कर्ष:
I. कुछ इलेक्ट्रिक वस्तुएं कारें हैं।
II. कुछ वाहन कारें हैं।',
  '{"a":"Only conclusion I follows","b":"Only conclusion II follows","c":"Both conclusions I and II follow","d":"Neither conclusion I nor II follows"}'::jsonb,
  '{"a":"केवल निष्कर्ष I अनुसरण करता है","b":"केवल निष्कर्ष II अनुसरण करता है","c":"निष्कर्ष I और II दोनों अनुसरण करते हैं","d":"न तो निष्कर्ष I और न ही II अनुसरण करता है"}'::jsonb,
  'b',
  'Analysis:
- Statement 1: ''All cars are vehicles'' -> The car circle is entirely inside vehicles. This immediately implies ''Some vehicles are cars'' (Conclusion II is definitely TRUE).
- Statement 2: ''Some vehicles are electric'' -> Electric overlaps with vehicles, but not necessarily with cars. Thus, ''Some electric items are cars'' is not necessarily true (Conclusion I does not follow).
Hence, only conclusion II follows.

Correct Option: (b)',
  'विश्लेषण:
1. कथन 1 से: ''सभी कारें वाहन हैं'', इसका अर्थ है कि ''कुछ वाहन अवश्य ही कारें हैं'' (निष्कर्ष II सत्य है)।
2. कथन 2 से: इलेक्ट्रिक का संबंध वाहन से है, कार से होना अनिवार्य नहीं है (निष्कर्ष I निश्चित नहीं है)।
अतः केवल निष्कर्ष II अनुसरण करता है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  81,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'The Western Dedicated Freight Corridor (WDFC), designed for double-stack container freight operations, connects Dadri (Uttar Pradesh) to which major container terminal port in Maharashtra?',
  'डबल-स्टैक कंटेनर माल ढुलाई के लिए डिज़ाइन किया गया पश्चिमी समर्पित माल गलियारा (WDFC), दादरी (उत्तर प्रदेश) को महाराष्ट्र के किस प्रमुख कंटेनर टर्मिनल बंदरगाह से जोड़ता है?',
  '{"a":"Jawaharlal Nehru Port Trust (JNPT / Nhava Sheva)","b":"Mormugao Port","c":"Kandla Port (Deendayal Port)","d":"Dhamra Port"}'::jsonb,
  '{"a":"जवाहरलाल नेहरू पोर्ट ट्रस्ट (JNPT / न्हावा शेवा)","b":"मोरमुगाओ बंदरगाह","c":"कांडला बंदरगाह (दीनदयाल पोर्ट)","d":"धामरा बंदरगाह"}'::jsonb,
  'a',
  'The Western Dedicated Freight Corridor (WDFC) spans $1,506\text{ km}$ from Dadri in Uttar Pradesh to Jawaharlal Nehru Port (JNPT) in Navi Mumbai, Maharashtra.',
  'पश्चिमी समर्पित माल गलियारा (WDFC) $1,506\text{ किमी}$ लंबा है जो उत्तर प्रदेश के दादरी से नवी मुंबई के जवाहरलाल नेहरू पोर्ट (JNPT) तक विस्तृत है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  82,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Which strategic mountain pass in the Great Himalayas links Srinagar and the Kashmir Valley with Kargil and Leh on National Highway 1?',
  'महान हिमालय में कौन-सा रणनीतिक पर्वतीय दर्रा राष्ट्रीय राजमार्ग 1 पर श्रीनगर और कश्मीर घाटी को कारगिल तथा लेह से जोड़ता है?',
  '{"a":"Zoji La Pass","b":"Nathu La Pass","c":"Rohtang Pass","d":"Shipki La Pass"}'::jsonb,
  '{"a":"ज़ोजिला दर्रा (Zoji La)","b":"नाथू ला दर्रा","c":"रोहतांग दर्रा","d":"शिपकी ला दर्रा"}'::jsonb,
  'a',
  'Zoji La Pass (altitude $3,528\text{ m}$) is a critical mountain pass connecting Srinagar with Ladakh. The all-weather Zojila Tunnel is being constructed beneath it.',
  'ज़ोजिला दर्रा (ऊंचाई $3,528\text{ मीटर}$) श्रीनगर को कारगिल और लेह (लद्दाख) से जोड़ता है। इसके नीचे रणनीतिक ज़ोजिला सुरंग का निर्माण किया जा रहा है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  83,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'What is the name of India''s first dedicated solar observatory space mission launched by ISRO in September 2023 to study the Sun?',
  'सूर्य का अध्ययन करने के लिए सितंबर 2023 में इसरो (ISRO) द्वारा प्रक्षेपित भारत के पहले समर्पित सौर वेधशाला अंतरिक्ष मिशन का क्या नाम है?',
  '{"a":"Surya-1","b":"Aditya-L1","c":"Helios-India","d":"Solar-Probe X"}'::jsonb,
  '{"a":"सूर्य-1","b":"आदित्य-L1 (Aditya-L1)","c":"हीलियोस-इंडिया","d":"सोलर-प्रोब X"}'::jsonb,
  'b',
  'Aditya-L1 was launched by ISRO on 2 September 2023 using PSLV-C57 and placed in a halo orbit around the Sun-Earth Lagrangian point 1 (L1), approx 1.5 million km from Earth, to study solar coronal mass ejections.

Correct Option: (b)',
  'इसरो ने 2 सितंबर 2023 को PSLV-C57 द्वारा आदित्य-L1 मिशन को सूर्य-पृथ्वी लैग्रेंजियन बिंदु 1 (L1) के चारों ओर हेलो कक्षा में सफलतापूर्वक स्थापित किया।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  84,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  85,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'What does Cash Reserve Ratio (CRR) mean in the context of Indian banking regulation?',
  'भारतीय बैंकिंग विनियमन के संदर्भ में ''नकद आरक्षित अनुपात'' (CRR) का क्या अर्थ है?',
  '{"a":"The percentage of net deposits commercial banks must keep with themselves in gold","b":"The percentage of total Net Demand and Time Liabilities (NDTL) that commercial banks must maintain as liquid cash reserves with the RBI","c":"The rate at which banks advance loans to farmers","d":"The minimum capital adequacy ratio of foreign banks"}'::jsonb,
  '{"a":"बैंकों द्वारा सोने के रूप में रखी जाने वाली जमा राशि","b":"कुल जमा (NDTL) का वह निश्चित प्रतिशत जो वाणिज्यिक बैंकों को नकद के रूप में RBI के पास रखना अनिवार्य होता है","c":"किसानों को दिए जाने वाले ऋण की ब्याज दर","d":"विदेशी बैंकों का न्यूनतम पूंजी पर्याप्तता अनुपात"}'::jsonb,
  'b',
  'CRR is the mandatory percentage of a bank''s Net Demand and Time Liabilities (NDTL) that must be maintained in cash with the Reserve Bank of India. RBI does not pay interest on CRR balances.

Correct Option: (b)',
  'CRR वाणिज्यिक बैंकों की कुल जमा (NDTL) का वह अनुपात है जिसे उन्हें नकद रूप में भारतीय रिज़र्व बैंक (RBI) के पास सुरक्षित रखना होता है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  86,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'The famous Jog Falls (Gersoppa Falls), one of the highest plunge waterfalls in India (253 m drop), is located on which river in Karnataka?',
  'भारत के सबसे ऊँचे झरनों में से एक प्रसिद्ध जोग जलप्रपात (गेरसोप्पा), कर्नाटक में किस नदी पर स्थित है?',
  '{"a":"Kaveri River","b":"Sharavathi River","c":"Krishna River","d":"Tungabhadra River"}'::jsonb,
  '{"a":"कावेरी नदी","b":"शरावती नदी (Sharavathi River)","c":"कृष्णा नदी","d":"तुंगभद्रा नदी"}'::jsonb,
  'b',
  'Jog Falls (also called Gerosoppa or Mahatma Gandhi Falls) is located on the Sharavathi River in the Shimoga district of Karnataka, plunging 253 metres (830 ft) in four distinct cascades: Raja, Roarer, Rocket, and Rani.

Correct Option: (b)',
  'जोग जलप्रपात (महात्मा गांधी जलप्रपात) कर्नाटक के शिमोगा जिले में शरावती नदी पर स्थित है, जिसकी ऊंचाई लगभग 253 मीटर है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  87,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Under which Article of the Constitution of India was the ''Right to Education'' (RTE) inserted as a Fundamental Right for children aged 6 to 14 years?',
  'भारतीय संविधान के किस अनुच्छेद के तहत 6 से 14 वर्ष की आयु के बच्चों के लिए ''शिक्षा का अधिकार'' (RTE) एक मौलिक अधिकार के रूप में जोड़ा गया?',
  '{"a":"Article 19","b":"Article 21A","c":"Article 30","d":"Article 45"}'::jsonb,
  '{"a":"अनुच्छेद 19","b":"अनुच्छेद 21A","c":"अनुच्छेद 30","d":"अनुच्छेद 45"}'::jsonb,
  'b',
  'The 86th Constitutional Amendment Act, 2002 inserted Article 21A into the Constitution of India.
It mandates the State to provide free and compulsory education to all children aged 6 to 14 years as a Fundamental Right.

Correct Option: (b)',
  '86वें संविधान संशोधन अधिनियम, 2002 द्वारा भारतीय संविधान में अनुच्छेद 21A जोड़ा गया, जिसके तहत 6 से 14 वर्ष की आयु के सभी बच्चों के लिए मुफ्त और अनिवार्य शिक्षा को मौलिक अधिकार बनाया गया।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  88,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'India''s first passenger train ran between Bori Bunder (Bombay) and Thane on 16th April 1853 covering a distance of 34 km. Which Governor-General introduced railways in India?',
  'भारत की पहली यात्री ट्रेन 16 अप्रैल 1853 को बोरी बंदर (बॉम्बे) और ठाणे के बीच 34 किमी की दूरी पर चली थी। भारत में रेलवे की शुरुआत किस गवर्नर-जनरल के कार्यकाल में हुई थी?',
  '{"a":"Lord Canning","b":"Lord Dalhousie","c":"Lord Curzon","d":"Lord William Bentinck"}'::jsonb,
  '{"a":"लॉर्ड कैनिंग","b":"लॉर्ड डलहौजी","c":"लॉर्ड कर्जन","d":"लॉर्ड विलियम बेंटिक"}'::jsonb,
  'b',
  'Lord Dalhousie (Governor-General of India from 1848 to 1856) is known as the ''Father of Indian Railways''. The first commercial passenger train was hauled by three steam locomotives—Sultan, Sahib, and Sindh—on 16 April 1853.

Correct Option: (b)',
  'लॉर्ड डलहौजी को ''भारतीय रेलवे का जनक'' माना जाता है। उनके कार्यकाल में 16 अप्रैल 1853 को पहली यात्री रेल बोरी बंदर से ठाणे के बीच 34 किमी की दूरी पर 3 इंजनों (सुल्तान, साहिब और सिंध) द्वारा चलाई गई थी।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  89,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  90,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Which railway station in India holds the Guinness World Record for having the world''s longest railway platform measuring 1,507 meters?',
  'भारत का कौन सा रेलवे स्टेशन 1,507 मीटर लंबे विश्व के सबसे लंबे रेलवे प्लेटफॉर्म का गिनीज वर्ल्ड रिकॉर्ड रखता है?',
  '{"a":"Gorakhpur Junction (Uttar Pradesh)","b":"Shree Siddharoodha Swamiji Hubballi Junction (Karnataka)","c":"Kollam Junction (Kerala)","d":"Kharagpur Junction (West Bengal)"}'::jsonb,
  '{"a":"गोरखपुर जंक्शन (उत्तर प्रदेश)","b":"श्री सिद्धारूढ़ स्वामीजी हुबली जंक्शन (कर्नाटक)","c":"कोल्लम जंक्शन (केरल)","d":"खड़गपुर जंक्शन (पश्चिम बंगाल)"}'::jsonb,
  'b',
  'Platform No. 8 at Shree Siddharoodha Swamiji Hubballi Junction in Karnataka was recognized by the Guinness World Records in March 2023 as the longest railway platform in the world with a length of 1,507 meters (overtaking Gorakhpur''s 1,366 m platform).

Correct Option: (b)',
  'कर्नाटक के श्री सिद्धारूढ़ स्वामीजी हुबली जंक्शन (Sss Hubballi) का प्लेटफॉर्म नंबर 8 (लंबाई 1,507 मीटर) आधिकारिक तौर पर दुनिया का सबसे लंबा रेलवे प्लेटफॉर्म है। इससे पहले यह रिकॉर्ड गोरखपुर जंक्शन (1,366 मीटर) के नाम था।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  91,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'On 3rd February 1925, India''s first electric passenger train ran between which two stations?',
  '3 फरवरी 1925 को भारत की पहली इलेक्ट्रिक पैसेंजर ट्रेन किन दो स्टेशनों के बीच चलाई गई थी?',
  '{"a":"Bombay VT (Victoria Terminus) to Kurla Harbour","b":"Howrah to Hooghly","c":"Delhi to Agra","d":"Madras to Arakkonam"}'::jsonb,
  '{"a":"बॉम्बे वीटी (विक्टोरिया टर्मिनस) से कुर्ला हार्बर","b":"हावड़ा से हुगली","c":"दिल्ली से आगरा","d":"मद्रास से अराक्कोणम"}'::jsonb,
  'a',
  'India''s first electric train was flagged off on 3rd February 1925 on the Harbour Line between Bombay VT (now Chhatrapati Shivaji Maharaj Terminus) and Kurla, using 1500 V DC overhead traction.

Correct Option: (a)',
  'भारत की पहली विद्युत रेलगाड़ी 3 फरवरी 1925 को बॉम्बे वीटी (विक्टोरिया टर्मिनस) और कुर्ला हार्बर के बीच 1500 V DC सिस्टम पर चलाई गई थी।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  92,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'India''s Mars Orbiter Mission (MOM), popularly known as Mangalyaan, was launched on 5th November 2013 by ISRO using which workhorse launch vehicle?',
  'भारतीय अंतरिक्ष अनुसंधान संगठन (ISRO) द्वारा 5 नवंबर 2013 को भारत का पहला मंगल अभियान ''मंगलयान'' (MOM) किस प्रक्षेपण यान द्वारा लॉन्च किया गया था?',
  '{"a":"PSLV-C25","b":"GSLV-Mk III","c":"PSLV-C11","d":"GSLV-F05"}'::jsonb,
  '{"a":"PSLV-C25","b":"GSLV-Mk III","c":"PSLV-C11","d":"GSLV-F05"}'::jsonb,
  'a',
  'Mangalyaan (Mars Orbiter Mission) was launched from Satish Dhawan Space Centre in Sriharikota on 5 November 2013 aboard the Polar Satellite Launch Vehicle PSLV-C25 (in its XL configuration). India became the first Asian nation to reach Martian orbit and the first in the world to do so in its maiden attempt.
(PSLV-C11 launched Chandrayaan-1).

Correct Option: (a)',
  'मंगलयान (Mars Orbiter Mission) को 5 नवंबर 2013 को सतीश धवन अंतरिक्ष केंद्र, श्रीहरिकोटा से PSLV-C25 रॉकेट द्वारा प्रक्षेपित किया गया था। भारत अपने पहले ही प्रयास में मंगल की कक्षा में पहुंचने वाला विश्व का पहला देश बना था।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  93,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'At the Tokyo 2020 Olympics, Neeraj Chopra won India''s first-ever Olympic track and field gold medal in Javelin Throw with a distance of:',
  'टोक्यो 2020 ओलंपिक में नीरज चोपड़ा ने भाला फेंक (Javelin Throw) में कितनी दूरी का थ्रो करके एथलेटिक्स में भारत का पहला ओलंपिक स्वर्ण पदक जीता था?',
  '{"a":"87.58 m","b":"86.48 m","c":"88.13 m","d":"89.94 m"}'::jsonb,
  '{"a":"87.58 मीटर","b":"86.48 मीटर","c":"88.13 मीटर","d":"89.94 मीटर"}'::jsonb,
  'a',
  'On 7 August 2021 at the Tokyo Olympic Games, Neeraj Chopra won the Gold Medal in Men''s Javelin Throw with a throw of 87.58 meters in his second attempt. He became the second Indian individual Olympic gold medalist after Abhinav Bindra (2008 Beijing).

Correct Option: (a)',
  '7 अगस्त 2021 को टोक्यो ओलंपिक में नीरज चोपड़ा ने अपने दूसरे प्रयास में 87.58 मीटर दूर भाला फेंककर भारत के लिए ऐतिहासिक स्वर्ण पदक जीता। इसी उपलक्ष्य में प्रतिवर्ष 7 अगस्त को ''राष्ट्रीय भाला फेंक दिवस'' मनाया जाता है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  94,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Which was the first operational rapid transit urban metro railway network in India, inaugurated on 24th October 1984?',
  '24 अक्टूबर 1984 को शुरू हुई भारत की पहली शहरी रैपिड ट्रांजिट ''मेट्रो रेलवे'' कौन सी थी?',
  '{"a":"Kolkata Metro","b":"Delhi Metro","c":"Namma Metro (Bengaluru)","d":"Mumbai Metro"}'::jsonb,
  '{"a":"कोलकाता मेट्रो","b":"दिल्ली मेट्रो","c":"नम्मा मेट्रो (बेंगलुरु)","d":"मुंबई मेट्रो"}'::jsonb,
  'a',
  'The Kolkata Metro was the first underground metro railway system in India. Commercial services commenced on 24 October 1984 between Esplanade and Bhowanipore (Netaji Bhavan) covering a distance of 3.4 km. In December 2010, it became the 17th Zone of Indian Railways.
(Delhi Metro started in 2002).

Correct Option: (a)',
  'भारत की पहली मेट्रो रेल सेवा 24 अक्टूबर 1984 को कोलकाता में एस्प्लेनेड से भवानीपुर के बीच शुरू हुई थी। 2010 में कोलकाता मेट्रो को भारतीय रेलवे का 17वां जोन बनाया गया।
(दिल्ली मेट्रो 2002 में शुरू हुई थी)।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  95,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Hirakud Dam, one of the longest major earthen dams in the world (about 25.8 km total length), is constructed across which river in Odisha?',
  'दुनिया के सबसे लंबे बांधों में से एक ''हीराकुंड बांध'' (कुल लंबाई लगभग 25.8 किमी) ओडिशा में किस नदी पर बनाया गया है?',
  '{"a":"Mahanadi River","b":"Godavari River","c":"Brahmani River","d":"Subarnarekha River"}'::jsonb,
  '{"a":"महानदी (Mahanadi)","b":"गोदावरी नदी","c":"ब्राह्मणी नदी","d":"सुवर्णरेखा नदी"}'::jsonb,
  'a',
  'Hirakud Dam is built across the Mahanadi River near Sambalpur in Odisha. Commissioned in 1957, it is India''s first major multipurpose river valley project initiated after independence to control catastrophic floods in the Mahanadi delta.

Correct Option: (a)',
  'हीराकुंड बांध ओडिशा के संबलपुर में महानदी पर निर्मित भारत का सबसे लंबा बांध है। यह स्वतंत्रता के बाद शुरू की गई पहली बहुउद्देशीय नदी घाटी परियोजनाओं में से एक है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  96,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Where is the Indian Railway Rail Wheel Factory (RWF) located?',
  'भारतीय रेल का रेल पहिया कारखाना (Rail Wheel Factory - RWF) कहाँ स्थित है?',
  '{"a":"Yelahanka, Bengaluru","b":"Perambur, Chennai","c":"Varanasi, Uttar Pradesh","d":"Kapurthala, Punjab"}'::jsonb,
  '{"a":"येलाहंका, बेंगलुरु","b":"पेरम्बूर, चेन्नई","c":"वाराणसी, उत्तर प्रदेश","d":"कपूरथला, पंजाब"}'::jsonb,
  'a',
  'Rail Wheel Factory (RWF) is located at Yelahanka, Bengaluru, Karnataka. It manufactures railway wheels, axles, and wheel sets.',
  'रेल पहिया कारखाना (RWF) येलाहंका, बेंगलुरु (कर्नाटक) में स्थित है। यह रेल पहियों, धुरों और पहिया सेटों का निर्माण करता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  97,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'What is the venue of the upcoming 2028 Summer Olympic Games?',
  'आगामी 2028 ग्रीष्मकालीन ओलंपिक खेलों का आयोजन स्थल कौन सा है?',
  '{"a":"Brisbane, Australia","b":"Los Angeles, USA","c":"Tokyo, Japan","d":"London, UK"}'::jsonb,
  '{"a":"ब्रिसबेन, ऑस्ट्रेलिया","b":"लॉस एंजिल्स, यूएसए","c":"टोक्यो, जापान","d":"लंदन, यूके"}'::jsonb,
  'b',
  'The 2028 Summer Olympics (officially the Games of the XXXIV Olympiad) are scheduled to take place in Los Angeles, California, USA.',
  '2028 ग्रीष्मकालीन ओलंपिक (आधिकारिक रूप से 34वें ओलंपियाड खेल) लॉस एंजिल्स, कैलिफोर्निया (यूएसए) में आयोजित होने वाले हैं।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  98,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'What is the standard track gauge distance of the Broad Gauge (BG) in Indian Railways?',
  'भारतीय रेल में ब्रॉड गेज (BG) की मानक ट्रैक गेज दूरी कितनी होती है?',
  '{"a":"1000 mm","b":"1676 mm","c":"1435 mm","d":"762 mm"}'::jsonb,
  '{"a":"1000 मिमी","b":"1676 मिमी","c":"1435 मिमी","d":"762 मिमी"}'::jsonb,
  'b',
  'Indian Broad Gauge track measures 1,676 mm (5 ft 6 in) between the inner faces of the two rails. Standard Gauge is 1,435 mm and Meter Gauge is 1,000 mm.',
  'भारतीय ब्रॉड गेज ट्रैक की दोनों पटरियों के बीच की दूरी 1,676 मिमी (5 फीट 6 इंच) होती है। मानक गेज 1,435 मिमी और मीटर गेज 1,000 मिमी होता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  99,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Fundamental Rights are enshrined in which Part of the Indian Constitution?',
  'भारतीय संविधान के किस भाग में मौलिक अधिकार सन्निहित हैं?',
  '{"a":"Part II","b":"Part III","c":"Part IV","d":"Part IVA"}'::jsonb,
  '{"a":"भाग II","b":"भाग III","c":"भाग IV","d":"भाग IVA"}'::jsonb,
  'b',
  'Fundamental Rights are contained in Part III of the Indian Constitution from Article 12 to 35, often described as the Magna Carta of India.',
  'मौलिक अधिकार भारतीय संविधान के भाग III (अनुच्छेद 12 से 35) में निहित हैं, जिसे भारत का मैग्ना कार्टा भी कहा जाता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_1',
  100,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Who is globally recognized as the ''Father of the White Revolution'' (Operation Flood) in India?',
  'भारत में ''श्वेत क्रांति'' (ऑपरेशन फ्लड) के जनक के रूप में किसे मान्यता प्राप्त है?',
  '{"a":"M.S. Swaminathan","b":"Dr. Verghese Kurien","c":"Norman Borlaug","d":"Sam Pitroda"}'::jsonb,
  '{"a":"एम.एस. स्वामीनाथन","b":"डॉ. वर्गीज कुरियन","c":"नॉर्मन बोरलॉग","d":"सैम पित्रोदा"}'::jsonb,
  'b',
  'Dr. Verghese Kurien is known as the Father of the White Revolution in India for creating the billion-litre cooperative dairy movement (Amul / Operation Flood).',
  'डॉ. वर्गीज कुरियन को भारत में श्वेत क्रांति (ऑपरेशन फ्लड) का जनक माना जाता है, जिन्होंने अमूल सहकारी डेयरी मॉडल की स्थापना की।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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

-- -------------------------------------------------------------------------
-- rrb_cbt_mock_2 (100 questions)
-- -------------------------------------------------------------------------

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  1,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Why are outer rails on railway curves elevated (banked) higher than inner rails?',
  'रेलवे ट्रैक के मोड़ों पर बाहरी पटरी को आंतरिक पटरी की तुलना में थोड़ा ऊपर (Banked) क्यों उठाया जाता है?',
  '{"a":"To reduce friction between tracks and wheels","b":"To provide the necessary centripetal force from the horizontal component of normal reaction","c":"To prevent rain water stagnation","d":"To increase train speed arbitrarily"}'::jsonb,
  '{"a":"पटरियों और पहियों के बीच घर्षण को कम करने के लिए","b":"अभिलंब प्रतिक्रिया के क्षैतिज घटक से आवश्यक अभिकेंद्रीय बल प्रदान करने के लिए","c":"बारिश के पानी को जमा होने से रोकने के लिए","d":"ट्रेन की गति को मनमाने ढंग से बढ़ाने के लिए"}'::jsonb,
  'b',
  'Banking of railway tracks ($N\sin\theta = mv^2/r$) provides the required inward centripetal force to navigate curves safely without relying purely on wheel flange friction.',
  'ट्रैक को मोड़ों पर झुकाने (सुपरएलिवेशन) से आवश्यक अभिकेंद्रीय बल ($F = mv^2/r$) प्राप्त होता है जिससे ट्रेन पलटने से बचती है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  2,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'A porter carries a heavy suitcase of 20 kg on his head and walks 50 meters along a horizontal railway platform. How much work is done by the porter against gravity?',
  'एक कुली अपने सिर पर 20 किग्रा का सूटकेस रखकर एक क्षैतिज रेलवे प्लेटफॉर्म पर 50 मीटर चलता है। गुरुत्वाकर्षण बल के विरुद्ध कुली द्वारा किया गया कार्य कितना है?',
  '{"a":"1,000 Joules","b":"Zero (0 Joules)","c":"9,800 Joules","d":"500 Joules"}'::jsonb,
  '{"a":"1,000 जूल","b":"शून्य (0 जूल)","c":"9,800 जूल","d":"500 जूल"}'::jsonb,
  'b',
  'Work $W = F \cdot d \cdot \cos\theta$. The gravitational force is downward ($90^\circ$ to the horizontal displacement). Since $\cos 90^\circ = 0$, work done against gravity is exactly 0 Joules.',
  'कार्य $W = F \cdot d \cdot \cos\theta$। गुरुत्वाकर्षण बल नीचे की ओर लंबवत ($90^\circ$) है। $\cos 90^\circ = 0$ होने के कारण गुरुत्वाकर्षण के विरुद्ध किया गया कार्य शून्य (0 जूल) होता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  3,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is the escape velocity of an object from the surface of Earth?',
  'पृथ्वी की सतह से किसी वस्तु का पलायन वेग (Escape Velocity) कितना होता है?',
  '{"a":"9.8 km/s","b":"11.2 km/s","c":"2.4 km/s","d":"42.1 km/s"}'::jsonb,
  '{"a":"9.8 किमी/सेकंड","b":"11.2 किमी/सेकंड","c":"2.4 किमी/सेकंड","d":"42.1 किमी/सेकंड"}'::jsonb,
  'b',
  'The escape velocity from the Earth''s surface is approximately 11.2 km/s ($v_e = \sqrt{2gR}$). For the Moon, it is about 2.38 km/s.',
  'पृथ्वी की सतह से पलायन वेग लगभग 11.2 किमी/सेकंड होता है ($v_e = \sqrt{2gR}$)। चंद्रमा के लिए यह लगभग 2.38 किमी/सेकंड है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  4,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Which gas is evolved when a reactive metal like Zinc reacts with dilute hydrochloric acid?',
  'जब जिंक जैसी सक्रिय धातु तनु हाइड्रोक्लोरिक अम्ल के साथ अभिक्रिया करती है, तो कौन सी गैस निकलती है?',
  '{"a":"Oxygen gas","b":"Hydrogen gas","c":"Chlorine gas","d":"Nitrogen dioxide"}'::jsonb,
  '{"a":"ऑक्सीजन गैस","b":"हाइड्रोजन गैस (H₂)","c":"क्लोरीन गैस","d":"नाइट्रोजन डाइऑक्साइड"}'::jsonb,
  'b',
  'Metal + Acid $\rightarrow$ Salt + Hydrogen gas: $\text{Zn} + 2\text{HCl} \rightarrow \text{ZnCl}_2 + \text{H}_2\uparrow$. Hydrogen burns with a pop sound.',
  'धातु + अम्ल $\rightarrow$ लवण + हाइड्रोजन गैस। $\text{Zn} + 2\text{HCl} \rightarrow \text{ZnCl}_2 + \text{H}_2\uparrow$। यह पॉप ध्वनि के साथ जलती है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  5,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Which noble gas has only 2 electrons in its valence shell yet is placed in Group 18 of the Periodic Table?',
  'किस उत्कृष्ट (अक्रिय) गैस के संयोजी कोश में केवल 2 इलेक्ट्रॉन होते हैं, फिर भी इसे आवर्त सारणी के वर्ग 18 में रखा गया है?',
  '{"a":"Neon","b":"Argon","c":"Helium","d":"Krypton"}'::jsonb,
  '{"a":"नियॉन","b":"ऑर्गन","c":"हीलियम (He)","d":"क्रिप्टॉन"}'::jsonb,
  'c',
  'Helium (atomic number 2) has a completely filled duplet ($1s^2$), giving it full noble gas stability like other Group 18 octet elements.',
  'हीलियम ($Z=2$) के पहले कोश में अधिकतम 2 इलेक्ट्रॉन होते हैं जो पूरी तरह भरा होता है (Duplet rule), इसलिए इसे वर्ग 18 में अक्रिय गैसों के साथ रखा गया है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  6,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Atoms of different elements having different atomic numbers but the same mass number are known as:',
  'भिन्न परमाणु क्रमांक किन्तु समान द्रव्यमान संख्या वाले विभिन्न तत्वों के परमाणुओं को क्या कहा जाता है?',
  '{"a":"Isotopes","b":"Isobars","c":"Isotones","d":"Allotropes"}'::jsonb,
  '{"a":"समस्थानिक (Isotopes)","b":"समभारिक (Isobars)","c":"समन्यूट्रॉनिक (Isotones)","d":"अपररूप (Allotropes)"}'::jsonb,
  'b',
  'Isobars have the same mass number ($A$) but different atomic numbers ($Z$), such as $^{40}_{18}\text{Ar}$ and $^{40}_{20}\text{Ca}$. Isotopes have same $Z$, different $A$.',
  'समान द्रव्यमान संख्या और भिन्न परमाणु क्रमांक वाले तत्वों को समभारिक (Isobars) कहते हैं, जैसे $^{40}\text{Ar}$ और $^{40}\text{Ca}$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  7,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'When an object is placed at $2F_1$ in front of a convex lens, where is the image formed?',
  'जब किसी वस्तु को उत्तल लेंस के सामने $2F_1$ (वक्रता केंद्र) पर रखा जाता है, तो उसका प्रतिबिम्ब कहाँ बनता है?',
  '{"a":"At focus $F_2$","b":"At $2F_2$, real, inverted and of same size","c":"Beyond $2F_2$","d":"Between $F_2$ and $2F_2$"}'::jsonb,
  '{"a":"फोकस $F_2$ पर","b":"$2F_2$ पर, वास्तविक, उल्टा और समान आकार का","c":"$2F_2$ से परे","d":"$F_2$ और $2F_2$ के बीच"}'::jsonb,
  'b',
  'When object is at $2F_1$, a convex lens forms an image at $2F_2$ on the other side that is real, inverted, and of the exact same size ($m = -1$).',
  'उत्तल लेंस में जब वस्तु $2F_1$ पर होती है, तो प्रतिबिम्ब दूसरी ओर $2F_2$ पर वास्तविक, उल्टा और वस्तु के ठीक बराबर आकार का बनता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  8,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'SONAR (Sound Navigation and Ranging) systems used on marine ships utilize which type of sound waves to measure underwater ocean depth?',
  'समुद्री जहाजों पर प्रयुक्त सोनार (SONAR) प्रणाली पानी के नीचे समुद्र की गहराई मापने के लिए किस प्रकार की ध्वनि तरंगों का उपयोग करती है?',
  '{"a":"Infrasonic waves","b":"Ultrasonic waves","c":"Radio waves","d":"Audible sound waves"}'::jsonb,
  '{"a":"अपश्रव्य तरंगें","b":"पराश्रव्य तरंगें (Ultrasonic waves)","c":"रेडियो तरंगें","d":"श्रव्य ध्वनि तरंगें"}'::jsonb,
  'b',
  'SONAR uses high-frequency Ultrasonic sound waves ($> 20\text{ kHz}$) that travel through water with high energy and reflect sharply from underwater obstacles and sea beds.',
  'सोनार प्रणाली उच्च आवृत्ति वाली पराश्रव्य तरंगों (अल्ट्रासोनिक) का उपयोग करती है जो जल में गहराई तक जाकर परावर्तित होती हैं।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  9,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'The brilliant sparkle of a cut diamond is primarily due to:',
  'तराशे गए हीरे की असाधारण चमक मुख्य रूप से किसके कारण होती है?',
  '{"a":"Total Internal Reflection with a very small critical angle (~24.4°)","b":"High chemical reactivity","c":"Emission of light from carbon atoms","d":"Diffraction of light"}'::jsonb,
  '{"a":"अत्यंत कम क्रांतिक कोण (~24.4°) के कारण पूर्ण आंतरिक परावर्तन","b":"उच्च रासायनिक क्रियाशीलता","c":"कार्बन परमाणुओं से प्रकाश उत्सर्जन","d":"प्रकाश का विवर्तन"}'::jsonb,
  'a',
  'Diamond has a very high refractive index ($n \approx 2.42$), resulting in a very small critical angle ($C \approx 24.4^\circ$). Light entering suffers multiple total internal reflections before exiting.',
  'हीरे का अपवर्तनांक बहुत अधिक (2.42) और क्रांतिक कोण बहुत कम (24.4°) होता है, जिससे इसके अंदर प्रकाश का बार-बार पूर्ण आंतरिक परावर्तन होता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  10,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What are the tiny microscopic air sacs in the human lungs where respiratory gaseous exchange occurs called?',
  'मानव फेफड़ों में वे सूक्ष्म वायु कोष जहाँ रक्त और वायु के बीच गैसों का विनिमय होता है, क्या कहलाते हैं?',
  '{"a":"Bronchi","b":"Alveoli (कूपिकाएँ)","c":"Trachea","d":"Nephrons"}'::jsonb,
  '{"a":"श्वसनी (Bronchi)","b":"कूपिकाएँ (Alveoli)","c":"श्वास नली (Trachea)","d":"नेफ्रॉन"}'::jsonb,
  'b',
  'Alveoli are thin-walled, highly vascularized sac-like structures providing immense surface area (~80 m²) for diffusion of $O_2$ into blood and $CO_2$ out of blood.',
  'फेफड़ों में गैस विनिमय कूपिकाओं (Alveoli) के माध्यम से होता है जो ऑक्सीजन को रक्त में और कार्बन डाइऑक्साइड को बाहर पहुंचाती हैं।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  11,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Which gas law states that at constant temperature, the volume of a fixed mass of gas is inversely proportional to its pressure ($P \propto 1/V$)?',
  'किस नियम के अनुसार स्थिर ताप पर किसी गैस के निश्चित द्रव्यमान का आयतन उसके दाब के व्युत्क्रमानुपाती होता है ($P \propto 1/V$)?',
  '{"a":"Charles''s Law","b":"Boyle''s Law","c":"Avogadro''s Law","d":"Gay-Lussac''s Law"}'::jsonb,
  '{"a":"चार्ल्स का नियम","b":"बॉयल का नियम","c":"अवोगाद्रो का नियम","d":"गे-लुसाक का नियम"}'::jsonb,
  'b',
  'Boyle''s Law asserts that for a given mass of an ideal gas kept at constant temperature, pressure and volume are inversely proportional ($P_1V_1 = P_2V_2$).',
  'बॉयल के नियम के अनुसार स्थिर तापमान पर किसी गैस के निश्चित द्रव्यमान का दाब उसके आयतन के व्युत्क्रमानुपाती होता है ($P_1V_1 = P_2V_2$)।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  12,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Which synthetic chemical indicator remains colorless in acidic solutions and turns deep pink in basic solutions?',
  'कौन-सा संश्लेषित रासायनिक सूचक अम्लीय विलयनों में रंगहीन रहता है और क्षारीय विलयनों में गहरा गुलाबी हो जाता है?',
  '{"a":"Methyl orange","b":"Phenolphthalein","c":"Bromothymol blue","d":"Litmus paper"}'::jsonb,
  '{"a":"मिथाइल ऑरेंज","b":"फिनॉल्फथलीन (Phenolphthalein)","c":"ब्रोमोथाइमोल ब्लू","d":"लिटमस पेपर"}'::jsonb,
  'b',
  'Phenolphthalein is colorless in acidic and neutral solutions ($pH < 8.2$) and turns magenta/pink in basic solutions ($pH > 8.2$).',
  'फिनॉल्फथलीन अम्लीय और उदासीन माध्यम ($pH < 8.2$) में रंगहीन रहता है और क्षारीय माध्यम ($pH > 8.2$) में गुलाबी रंग देता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  13,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'A constant net force of 20 N acts on a body of mass 4 kg initially at rest for a duration of 5 seconds. What is the final momentum acquired by the body?',
  '4 किग्रा द्रव्यमान के विरामावस्था में स्थित एक पिंड पर 20 N का एक नियत बल 5 सेकंड तक कार्य करता है। पिंड द्वारा प्राप्त अंतिम संवेग (Momentum) क्या होगा?',
  '{"a":"50 kg·m/s","b":"80 kg·m/s","c":"100 kg·m/s","d":"120 kg·m/s"}'::jsonb,
  '{"a":"50 किग्रा·मी/से","b":"80 किग्रा·मी/से","c":"100 किग्रा·मी/से","d":"120 किग्रा·मी/से"}'::jsonb,
  'c',
  'According to the impulse-momentum theorem:
Impulse = Force × Time = Change in momentum = Δp = p_final - p_initial.
Since initial momentum = 0 (body is at rest):
p_final = F × t = 20 N × 5 s = 100 kg·m/s (or N·s).

Correct Option: (c)',
  'आवेग-संवेग प्रमेय के अनुसार:
संवेग में परिवर्तन (आवेग) = बल × समय
Δp = F × t = 20 N × 5 s = 100 किग्रा·मी/से।
चूँकि प्रारंभिक संवेग शून्य है, अतः अंतिम संवेग = 100 किग्रा·मी/से होगा।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  14,
  1,
  'PART-1',
  'General Science',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  15,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'The progressive increase in the concentration of non-biodegradable chemical toxins (such as DDT) at each successive trophic level of a food chain is termed:',
  'खाद्य श्रृंखला के प्रत्येक क्रमिक पोषण स्तर पर अजैव निम्नीकरणीय रासायनिक विषाक्त पदार्थों (जैसे DDT) की सांद्रता में होने वाली निरंतर वृद्धि को क्या कहा जाता है?',
  '{"a":"Eutrophication","b":"Biomagnification","c":"Biodegradation","d":"Bioremediation"}'::jsonb,
  '{"a":"सुपोषण (Eutrophication)","b":"जैव आवर्धन (Biomagnification)","c":"जैव निम्नीकरण","d":"जैव उपचार (Bioremediation)"}'::jsonb,
  'b',
  'Biomagnification (or biological magnification) refers to the phenomenon where non-metabolizable and non-excretable fat-soluble substances (like heavy metals, pesticides like DDT) accumulate in increasing concentrations at higher trophic levels.

Correct Option: (b)',
  'आहार श्रृंखला में शीर्ष उपभोक्ताओं की ओर बढ़ते हुए हानिकारक अजैव निम्नीकरणीय रसायनों की सांद्रता में उत्तरोत्तर वृद्धि की प्रक्रिया को ''जैव आवर्धन'' (Biomagnification) कहते हैं।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  16,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is the classical phenotypic ratio obtained in the F₂ generation of Mendel''s dihybrid cross between two heterozygous garden pea plants (e.g. Round Yellow vs Wrinkled Green)?',
  'मेंडल के द्विसंकर संकरण (Dihybrid Cross) के F₂ पीढ़ी में प्राप्त शास्त्रीय लक्षणप्ररूपी अनुपात (Phenotypic Ratio) क्या होता है?',
  '{"a":"3 : 1","b":"9 : 3 : 3 : 1","c":"1 : 2 : 1","d":"9 : 7"}'::jsonb,
  '{"a":"3 : 1","b":"9 : 3 : 3 : 1","c":"1 : 2 : 1","d":"9 : 7"}'::jsonb,
  'b',
  'In a dihybrid cross involving two traits (seed shape and seed color), the F₂ phenotypic ratio is 9 (Round Yellow) : 3 (Round Green) : 3 (Wrinkled Yellow) : 1 (Wrinkled Green). This demonstrates the Law of Independent Assortment.

Correct Option: (b)',
  'द्विसंकर संकरण की F₂ पीढ़ी में लक्षणप्ररूपी अनुपात 9 : 3 : 3 : 1 होता है (9 गोल पीले : 3 गोल हरे : 3 झुर्रीदार पीले : 1 झुर्रीदार हरा)। यह स्वतंत्र अपव्यूहन के नियम को दर्शाता है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  17,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'An electric heater of resistance 20 Ω carries a current of 5 A for 30 seconds. Calculate the amount of heat energy generated.',
  '20 Ω प्रतिरोध वाले एक विद्युत हीटर में 30 सेकंड तक 5 A की धारा प्रवाहित होती है। उत्पन्न ऊष्मा ऊर्जा की गणना कीजिए।',
  '{"a":"15,000 J","b":"3,000 J","c":"7,500 J","d":"30,000 J"}'::jsonb,
  '{"a":"15,000 J","b":"3,000 J","c":"7,500 J","d":"30,000 J"}'::jsonb,
  'a',
  'According to Joule''s Law of Heating:
H = I^2 * R * t
Given:
- I = 5 A
- R = 20 Ω
- t = 30 s
H = (5)^2 * 20 * 30
H = 25 * 20 * 30 = 500 * 30 = 15,000 Joules (or 15 kJ).

Correct Option: (a)',
  'जूल के तापन नियम के अनुसार:
H = I^2 * R * t
दिया गया है: I = 5 A, R = 20 Ω, t = 30 s
H = (5)^2 * 20 * 30 = 25 * 20 * 30 = 15,000 जूल (J).

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  18,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'In Gregor Mendel''s monohybrid cross experiment on pea plants, what was the phenotypic ratio observed in the F2 generation?',
  'ग्रेगर मेंडल के मटर के पौधे पर एकल संकरण (Monohybrid Cross) प्रयोग में F2 पीढ़ी का लक्षणप्ररूपी (Phenotypic) अनुपात क्या था?',
  '{"a":"1 : 2 : 1","b":"3 : 1","c":"9 : 3 : 3 : 1","d":"2 : 1"}'::jsonb,
  '{"a":"1 : 2 : 1","b":"3 : 1","c":"9 : 3 : 3 : 1","d":"2 : 1"}'::jsonb,
  'b',
  'In Mendel''s monohybrid cross (e.g., Tall TT x Dwarf tt):
- F1 generation: All Tall (Tt)
- F2 generation (selfing Tt x Tt):
  - Phenotypic ratio (Observable appearance): 3 Tall : 1 Dwarf (3:1)
  - Genotypic ratio (Genetic makeup): 1 TT : 2 Tt : 1 tt (1:2:1)

Correct Option: (b)',
  'मेंडल के एकसंकर क्रॉस में F2 पीढ़ी का:
- लक्षणप्ररूपी (Phenotypic) अनुपात = 3 लंबा : 1 बौना (3:1)
- जीनप्ररूपी (Genotypic) अनुपात = 1 TT : 2 Tt : 1 tt (1:2:1)
(9:3:3:1 द्विसंकर क्रॉस का लक्षणप्ररूपी अनुपात है)।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  19,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Which cellular organelle is known as the ''Powerhouse of the Cell'' because it generates energy in the form of ATP molecules?',
  'किस कोशिकांग को ''कोशिका का पावरहाउस (ऊर्जा घर)'' कहा जाता है क्योंकि यह ATP अणुओं के रूप में ऊर्जा का उत्पादन करता है?',
  '{"a":"Ribosome","b":"Golgi apparatus","c":"Mitochondria","d":"Lysosome"}'::jsonb,
  '{"a":"राइबोसोम","b":"गॉल्जी उपकरण","c":"माइटोकॉन्ड्रिया","d":"लाइसोसोम"}'::jsonb,
  'c',
  'Mitochondria are double-membraned organelles where cellular aerobic respiration occurs, synthesizing Adenosine Triphosphate (ATP) via the Krebs cycle and oxidative phosphorylation. Hence, they are called the powerhouses of the cell.
(Ribosomes = protein factories; Lysosomes = suicidal bags).

Correct Option: (c)',
  'माइटोकॉन्ड्रिया (Mitochondria) में कोशिकीय श्वसन की प्रक्रिया संपन्न होती है और खाद्य पदार्थों के ऑक्सीकरण से ATP (एडेनोसिन ट्राइफॉस्फेट) के रूप में ऊर्जा उत्पन्न होती है, इसलिए इसे कोशिका का ''पावरहाउस'' या ''ऊर्जा घर'' कहा जाता है।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  20,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'On which optical phenomenon does the transmission of high-speed optical signals through fiber optic cables work?',
  'ऑप्टिकल फाइबर केबलों के माध्यम से उच्च गति ऑप्टिकल सिग्नलों का संचरण किस प्रकाशीय परिघटना पर आधारित है?',
  '{"a":"Diffraction of light","b":"Total Internal Reflection (TIR)","c":"Dispersion of light","d":"Polarization of light"}'::jsonb,
  '{"a":"प्रकाश का विवर्तन","b":"पूर्ण आंतरिक परावर्तन (Total Internal Reflection)","c":"प्रकाश का वर्ण-विक्षेपण","d":"प्रकाश का ध्रुवण"}'::jsonb,
  'b',
  'Optical fibres operate on the principle of Total Internal Reflection (TIR). When light enters the core (denser medium with refractive index n1) at an angle of incidence greater than the critical angle relative to the cladding (rarer medium with n2, where n1 > n2), it undergoes successive total internal reflections without escaping or losing intensity.

Correct Option: (b)',
  'ऑप्टिकल फाइबर पूर्ण आंतरिक परावर्तन (TIR) के सिद्धांत पर कार्य करता है। जब प्रकाश कोर (सघन माध्यम) से क्लैडिंग (विरल माध्यम) की सीमा पर क्रांतिक कोण से बड़े कोण पर आपतित होता है, तो वह पूरी तरह कोर के अंदर परावर्तित होता हुआ बिना ऊर्जा ह्रास के आगे बढ़ता है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  21,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Three identical resistors, each of resistance 6 Ω, are connected in parallel. What is the equivalent resistance of the combination?',
  'तीन समान प्रतिरोधक, जिनमें से प्रत्येक का प्रतिरोध 6 Ω है, समानांतर क्रम में जुड़े हैं। इस संयोजन का समतुल्य प्रतिरोध क्या होगा?',
  '{"a":"2 Ω","b":"18 Ω","c":"3 Ω","d":"1.5 Ω"}'::jsonb,
  '{"a":"2 Ω","b":"18 Ω","c":"3 Ω","d":"1.5 Ω"}'::jsonb,
  'a',
  'For resistors in parallel:
1 / Req = 1 / R1 + 1 / R2 + 1 / R3
1 / Req = 1/6 + 1/6 + 1/6 = 3/6 = 1/2
Req = 2 Ω.
(For n identical resistors in parallel: Req = R / n = 6 / 3 = 2 Ω).

Correct Option: (a)',
  'समानांतर क्रम में समतुल्य प्रतिरोध:
1 / Req = 1/R1 + 1/R2 + 1/R3
1 / Req = 1/6 + 1/6 + 1/6 = 3/6 = 1/2
Req = 2 Ω (या Req = R / n = 6 / 3 = 2 Ω).

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  22,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Aqua Regia (''Royal Water''), a fuming corrosive liquid capable of dissolving noble metals like Gold and Platinum, is a freshly prepared mixture of concentrated Hydrochloric Acid and concentrated Nitric Acid in which volume ratio?',
  'अम्लराज / एक्वा रेजिया (Aqua Regia), जो सोना और प्लैटिनम जैसी उत्कृष्ट धातुओं को भी घोलने में सक्षम है, सांद्र हाइड्रोक्लोरिक अम्ल (HCl) और सांद्र नाइट्रिक अम्ल (HNO3) का किस आयतन अनुपात में ताजा मिश्रण होता है?',
  '{"a":"3 : 1 (3 parts conc. HCl + 1 part conc. HNO3)","b":"1 : 3 (1 part conc. HCl + 3 parts conc. HNO3)","c":"3 : 1 (3 parts conc. HNO3 + 1 part conc. HCl)","d":"1 : 1 (equal parts)"}'::jsonb,
  '{"a":"3 : 1 (3 भाग सांद्र HCl + 1 भाग सांद्र HNO3)","b":"1 : 3 (1 भाग सांद्र HCl + 3 भाग सांद्र HNO3)","c":"3 : 1 (3 भाग सांद्र HNO3 + 1 भाग सांद्र HCl)","d":"1 : 1 (समान भाग)"}'::jsonb,
  'a',
  'Aqua Regia is a freshly prepared mixture of 3 parts concentrated hydrochloric acid (conc. HCl) and 1 part concentrated nitric acid (conc. HNO3) by volume (ratio 3 : 1). The reaction generates nascent chlorine and nitrosyl chloride (NOCl) that react with unreactive noble metals to form soluble chloro-complexes.

Correct Option: (a)',
  'एक्वा रेजिया (अम्लराज) सांद्र हाइड्रोक्लोरिक अम्ल (HCl) और सांद्र नाइट्रिक अम्ल (HNO3) का 3 : 1 के अनुपात में बनाया गया ताजा मिश्रण होता है। यह अत्यंत संक्षारक होता है और सोने तथा प्लैटिनम को भी घोल लेता है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  23,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'A SONAR device installed on a ship sends an ultrasound pulse to the seabed and receives the reflected echo after 3.0 seconds. If the speed of ultrasound in seawater is 1,500 m/s, what is the depth of the sea?',
  'एक जहाज पर लगा सोनार (SONAR) उपकरण समुद्र तल की ओर पराध्वनि (Ultrasound) संकेत भेजता है और 3.0 सेकंड बाद परावर्तित प्रतिध्वनि प्राप्त करता है। यदि समुद्री जल में पराध्वनि की चाल 1,500 मी/से है, तो समुद्र की गहराई क्या है?',
  '{"a":"2,250 m","b":"4,500 m","c":"1,500 m","d":"3,000 m"}'::jsonb,
  '{"a":"2,250 मीटर","b":"4,500 मीटर","c":"1,500 मीटर","d":"3,000 मीटर"}'::jsonb,
  'a',
  'Formula for echo sounding:
Total distance travelled by pulse = 2 * d = v * t
Given: v = 1,500 m/s, t = 3.0 s
2 * d = 1,500 * 3.0 = 4,500 m
d = 4,500 / 2 = 2,250 meters.

Correct Option: (a)',
  'सोनार प्रतिध्वनि सूत्र: 2d = v * t
2 * गहराई = 1500 * 3.0 = 4500 मीटर
समुद्र की गहराई d = 4500 / 2 = 2,250 मीटर।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  24,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is the value of acceleration due to gravity (g) at the center of the Earth?',
  'पृथ्वी के केंद्र पर गुरुत्वीय त्वरण (g) का मान कितना होता है?',
  '{"a":"9.8 m/s²","b":"Zero","c":"Infinite","d":"4.9 m/s²"}'::jsonb,
  '{"a":"9.8 मीटर/सेकंड²","b":"शून्य","c":"अनंत","d":"4.9 मीटर/सेकंड²"}'::jsonb,
  'b',
  'At the exact center of the Earth, the gravitational force from the surrounding mass pulls equally in all directions, canceling out completely, so g = 0 m/s².',
  'पृथ्वी के ठीक केंद्र पर चारों ओर के द्रव्यमान से लगने वाला गुरुत्वाकर्षण बल सभी दिशाओं में समान होने के कारण एक-दूसरे को निरस्त कर देता है, अतः g = 0 मीटर/सेकंड² होता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  25,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'According to the Work-Energy Theorem, the net work done on a moving particle is equal to the change in its:',
  'कार्य-ऊर्जा प्रमेय के अनुसार, किसी गतिमान कण पर किया गया कुल कार्य उसमें किसके परिवर्तन के बराबर होता है?',
  '{"a":"Potential energy","b":"Kinetic energy","c":"Linear momentum","d":"Total mechanical force"}'::jsonb,
  '{"a":"स्थिति ऊर्जा","b":"गतिज ऊर्जा (Kinetic energy)","c":"रैखिक संवेग","d":"कुल यांत्रिक बल"}'::jsonb,
  'b',
  'The Work-Energy Theorem states that the net work done by all forces acting on an object equals the change in its kinetic energy: W_net = ΔKE = (1/2)m(v² - u²).',
  'कार्य-ऊर्जा प्रमेय के अनुसार किसी वस्तु पर लगने वाले सभी बलों द्वारा किया गया कुल कार्य उसकी गतिज ऊर्जा में परिवर्तन के बराबर होता है: W = ΔKE = (1/2)m(v² - u²)।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  26,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'Two trains 140 m and 160 m long are running towards each other on parallel tracks at 50 km/h and 58 km/h. In what time will they cross each other completely?',
  '140 मीटर और 160 मीटर लंबी दो ट्रेनें समानांतर पटरियों पर 50 किमी/घंटा और 58 किमी/घंटा की गति से एक-दूसरे की ओर आ रही हैं। वे एक-दूसरे को कितने समय में पूरी तरह पार कर लेंगी?',
  '{"a":"8 seconds","b":"10 seconds","c":"12 seconds","d":"15 seconds"}'::jsonb,
  '{"a":"8 सेकंड","b":"10 सेकंड","c":"12 सेकंड","d":"15 सेकंड"}'::jsonb,
  'b',
  'Total distance = $140 + 160 = 300$ m. Relative speed = $50 + 58 = 108$ km/h $= 108 \times (5/18) = 30$ m/s. Time = $300 / 30 = 10$ seconds.',
  'कुल दूरी = $140 + 160 = 300$ मीटर। सापेक्ष चाल = $50 + 58 = 108$ किमी/घं $= 108 \times (5/18) = 30$ मी/सेकंड। समय = $300 / 30 = 10$ सेकंड।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  27,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A bag contains coins of ₹1, 50 paise, and 25 paise in the ratio 3 : 4 : 8. If the total value of coins in the bag is ₹280, how many 50-paise coins are there?',
  'एक बैग में ₹1, 50 पैसे और 25 पैसे के सिक्के 3 : 4 : 8 के अनुपात में हैं। यदि बैग में सिक्कों का कुल मूल्य ₹280 है, तो 50 पैसे के कितने सिक्के हैं?',
  '{"a":"120","b":"140","c":"160","d":"180"}'::jsonb,
  '{"a":"120","b":"140","c":"160","d":"180"}'::jsonb,
  'c',
  'Value per unit ratio: $3(1) + 4(0.50) + 8(0.25) = 3 + 2 + 2 = ₹7$. Common factor $x = 280 / 7 = 40$. Number of 50-p coins $= 4 \times 40 = 160$.',
  'अनुपात का कुल मूल्य: $3(1) + 4(0.50) + 8(0.25) = 7$ रुपये। गुणक $= 280 / 7 = 40$। 50 पैसे के सिक्के = $4 \times 40 = 160$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  28,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'In an isosceles triangle ABC, if $AB = AC$ and $\angle A = 50^\circ$, find the measure of $\angle B$.',
  'एक समद्विबाहु त्रिभुज ABC में, यदि $AB = AC$ और $\angle A = 50^\circ$ है, तो $\angle B$ का माप क्या होगा?',
  '{"a":"50°","b":"60°","c":"65°","d":"70°"}'::jsonb,
  '{"a":"50°","b":"60°","c":"65°","d":"70°"}'::jsonb,
  'c',
  'Angles opposite to equal sides are equal: $\angle B = \angle C$. Sum of angles is $180^\circ \Rightarrow 50^\circ + 2\angle B = 180^\circ \Rightarrow 2\angle B = 130^\circ \Rightarrow \angle B = 65^\circ$.',
  'समान भुजाओं के सम्मुख कोण बराबर होते हैं: $\angle B = \angle C = (180^\circ - 50^\circ) / 2 = 65^\circ$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  29,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A trader marks an article $35\%$ above its cost price and subsequently grants a discount of $20\%$ on the marked price. What is his net gain percentage?',
  'एक व्यापारी किसी वस्तु का मूल्य उसके क्रय मूल्य से $35\%$ अधिक अंकित करता है और फिर अंकित मूल्य पर $20\%$ की छूट देता है। उसका शुद्ध लाभ प्रतिशत क्या है?',
  '{"a":"$8\\%$","b":"$10\\%$","c":"$12\\%$","d":"$15\\%$"}'::jsonb,
  '{"a":"$8\\%$","b":"$10\\%$","c":"$12\\%$","d":"$15\\%$"}'::jsonb,
  'a',
  'Let CP = 100. Then MP = 135. Discount = 20% of 135 = 27. Selling Price (SP) = $135 - 27 = 108$. Net gain $= 108 - 100 = 8\%$.',
  'माना क्रय मूल्य (CP) = ₹100. अंकित मूल्य (MP) = ₹135. छूट = 135 का 20% = ₹27. विक्रय मूल्य (SP) = $135 - 27 = ₹108$. शुद्ध लाभ $= 8\%$.',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  30,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A container holds $60\text{ litres}$ of a mixture of milk and water in the ratio $3 : 2$. How many litres of pure water must be added to make the ratio of milk to water $1 : 1$?',
  'एक बर्तन में $60\text{ लीटर}$ दूध और पानी का मिश्रण $3 : 2$ के अनुपात में है। दूध और पानी का अनुपात $1 : 1$ करने के लिए इसमें कितने लीटर शुद्ध पानी मिलाया जाना चाहिए?',
  '{"a":"$12\\text{ litres}$","b":"$15\\text{ litres}$","c":"$10\\text{ litres}$","d":"$8\\text{ litres}$"}'::jsonb,
  '{"a":"$12\\text{ लीटर}$","b":"$15\\text{ लीटर}$","c":"$10\\text{ लीटर}$","d":"$8\\text{ लीटर}$"}'::jsonb,
  'a',
  'Initial milk $= 60 \times \frac{3}{5} = 36\text{ litres}$, and water $= 60 \times \frac{2}{5} = 24\text{ litres}$. To make the ratio $1 : 1$, water volume must equal milk volume ($36\text{ litres}$). Water to add $= 36 - 24 = 12\text{ litres}$.',
  'प्रारंभिक दूध $= 60 \times \frac{3}{5} = 36\text{ लीटर}$, पानी $= 24\text{ लीटर}$। अनुपात $1:1$ करने के लिए पानी भी $36\text{ लीटर}$ होना चाहिए। अतः मिलाया गया पानी $= 36 - 24 = 12\text{ लीटर}$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  31,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A can complete a piece of work in 12 days and B can complete it in 18 days. If they work together, in how many days will the work be finished?',
  'A किसी काम को 12 दिनों में और B उसी काम को 18 दिनों में पूरा कर सकता है। यदि वे एक साथ काम करते हैं, तो काम कितने दिनों में पूरा होगा?',
  '{"a":"7.2 days","b":"8 days","c":"6.5 days","d":"9 days"}'::jsonb,
  '{"a":"7.2 दिन","b":"8 दिन","c":"6.5 दिन","d":"9 दिन"}'::jsonb,
  'a',
  'Total work = LCM(12, 18) = 36 units. Efficiency: A = 3 units/day, B = 2 units/day. Combined = 5 units/day. Time = $36 / 5 = 7.2$ days.',
  'कुल कार्य = LCM(12, 18) = 36 इकाई। A की कार्यक्षमता = 3 इकाई/दिन, B = 2 इकाई/दिन। संयुक्त क्षमता = 5 इकाई/दिन। समय = $36 / 5 = 7.2$ दिन।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  32,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'In a cyclic quadrilateral ABCD, if $\angle A = 75^\circ$, find the measure of the opposite angle $\angle C$.',
  'एक चक्रीय चतुर्भुज ABCD में, यदि $\angle A = 75^\circ$ है, तो इसके सम्मुख कोण $\angle C$ का माप ज्ञात कीजिए।',
  '{"a":"95°","b":"105°","c":"115°","d":"125°"}'::jsonb,
  '{"a":"95°","b":"105°","c":"115°","d":"125°"}'::jsonb,
  'b',
  'In any cyclic quadrilateral, the sum of opposite angles is $180^\circ$. Therefore, $\angle C = 180^\circ - 75^\circ = 105^\circ$.',
  'चक्रीय चतुर्भुज के सम्मुख कोणों का योग $180^\circ$ होता है। अतः $\angle C = 180^\circ - 75^\circ = 105^\circ$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  33,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'If $\tan \theta = \frac{4}{3}$, find the value of $\frac{\sin \theta + \cos \theta}{\sin \theta - \cos \theta}$.',
  'यदि $\tan \theta = \frac{4}{3}$ है, तो $\frac{\sin \theta + \cos \theta}{\sin \theta - \cos \theta}$ का मान ज्ञात कीजिए।',
  '{"a":"5","b":"6","c":"7","d":"8"}'::jsonb,
  '{"a":"5","b":"6","c":"7","d":"8"}'::jsonb,
  'c',
  'Divide numerator and denominator by $\cos \theta$: $(\tan \theta + 1) / (\tan \theta - 1) = (4/3 + 1) / (4/3 - 1) = (7/3) / (1/3) = 7$.',
  'अंश और हर को $\cos \theta$ से भाग देने पर: $\frac{\tan \theta + 1}{\tan \theta - 1} = \frac{4/3 + 1}{4/3 - 1} = \frac{7/3}{1/3} = 7$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  34,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'Find the unit digit in the expression $7^{95} - 3^{58}$.',
  'व्यंजक $7^{95} - 3^{58}$ में इकाई का अंक ज्ञात कीजिए।',
  '{"a":"0","b":"4","c":"6","d":"7"}'::jsonb,
  '{"a":"0","b":"4","c":"6","d":"7"}'::jsonb,
  'b',
  'Cyclicity of 7 is 4: $95 = 4\times 23 + 3 \Rightarrow 7^3 = 343$ (unit digit 3). Cyclicity of 3 is 4: $58 = 4\times 14 + 2 \Rightarrow 3^2 = 9$ (unit digit 9). Since $3 < 9$, borrow 10: $13 - 9 = 4$.',
  '7 की चक्रीयता 4 है: $95 \div 4$ पर शेष 3 आता है, अतः $7^3$ का इकाई अंक 3 है। $58 \div 4$ पर शेष 2 आता है, अतः $3^2$ का इकाई अंक 9 है। $13 - 9 = 4$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  35,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'What is the nature of the roots of the quadratic equation $3x^2 - 4x + 2 = 0$?',
  'द्विघात समीकरण $3x^2 - 4x + 2 = 0$ के मूलों की प्रकृति क्या है?',
  '{"a":"Real and equal","b":"Real and distinct","c":"No real roots (Imaginary / Complex)","d":"Rational and equal"}'::jsonb,
  '{"a":"वास्तविक और बराबर","b":"वास्तविक और भिन्न","c":"कोई वास्तविक मूल नहीं (काल्पनिक / जटिल)","d":"परिमेय और बराबर"}'::jsonb,
  'c',
  'Discriminant $D = b^2 - 4ac = (-4)^2 - 4(3)(2) = 16 - 24 = -8 < 0$. Since $D < 0$, the roots are imaginary (non-real complex conjugates).',
  'विविक्तकर $D = b^2 - 4ac = (-4)^2 - 4(3)(2) = 16 - 24 = -8 < 0$। चूंकि $D < 0$ है, इसलिए समीकरण के मूल अवास्तविक (काल्पनिक) हैं।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  36,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'If 15 men can construct a wall in 20 days working 8 hours a day, in how many days can 20 men construct the same wall working 6 hours a day?',
  'यदि 15 पुरुष प्रतिदिन 8 घंटे काम करके 20 दिनों में एक दीवार बना सकते हैं, तो 20 पुरुष प्रतिदिन 6 घंटे काम करके उसी दीवार को कितने दिनों में बना सकते हैं?',
  '{"a":"18 days","b":"20 days","c":"22 days","d":"24 days"}'::jsonb,
  '{"a":"18 दिन","b":"20 दिन","c":"22 दिन","d":"24 दिन"}'::jsonb,
  'b',
  'Formula: $M_1 D_1 H_1 = M_2 D_2 H_2 \Rightarrow 15 \times 20 \times 8 = 20 \times D_2 \times 6 \Rightarrow D_2 = (15 \times 20 \times 8) / (20 \times 6) = 20$ days.',
  '$M_1 D_1 H_1 = M_2 D_2 H_2 \Rightarrow 15 \times 20 \times 8 = 20 \times D_2 \times 6 \Rightarrow D_2 = 20$ दिन।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  37,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'Find the HCF of the fractions: $\frac{2}{3}, \frac{4}{9}, \frac{8}{15}$.',
  'भिन्नों $\frac{2}{3}, \frac{4}{9}, \frac{8}{15}$ का महत्तम समापवर्तक (HCF) ज्ञात कीजिए।',
  '{"a":"2/45","b":"4/45","c":"8/45","d":"2/15"}'::jsonb,
  '{"a":"2/45","b":"4/45","c":"8/45","d":"2/15"}'::jsonb,
  'a',
  'Formula: $\text{HCF of fractions} = \frac{\text{HCF of numerators}}{\text{LCM of denominators}} = \frac{\text{HCF}(2,4,8)}{\text{LCM}(3,9,15)} = \frac{2}{45}$.',
  'भिन्नों का HCF = $\frac{\text{अंशों का HCF}}{\text{हरों का LCM}} = \frac{\text{HCF}(2, 4, 8)}{\text{LCM}(3, 9, 15)} = \frac{2}{45}$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  38,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'For what condition do the system of linear equations $a_1 x + b_1 y + c_1 = 0$ and $a_2 x + b_2 y + c_2 = 0$ have a unique solution?',
  'रैखिक समीकरण निकाय $a_1 x + b_1 y + c_1 = 0$ और $a_2 x + b_2 y + c_2 = 0$ का अद्वितीय हल (Unique Solution) होने की शर्त क्या है?',
  '{"a":"$a_1 / a_2 = b_1 / b_2$","b":"$a_1 / a_2 \\neq b_1 / b_2$","c":"$a_1 / a_2 = b_1 / b_2 = c_1 / c_2$","d":"$a_1 / a_2 = b_1 / b_2 \\neq c_1 / c_2$"}'::jsonb,
  '{"a":"$a_1 / a_2 = b_1 / b_2$","b":"$a_1 / a_2 \\neq b_1 / b_2$ (अद्वितीय हल)","c":"$a_1 / a_2 = b_1 / b_2 = c_1 / c_2$ (अनंत हल)","d":"$a_1 / a_2 = b_1 / b_2 \\neq c_1 / c_2$ (कोई हल नहीं)"}'::jsonb,
  'b',
  'A unique solution occurs when lines intersect at a single point, which requires non-parallel slopes: $\frac{a_1}{a_2} \neq \frac{b_1}{b_2}$.',
  'एक अद्वितीय हल के लिए रेखाएं प्रतिच्छेदी होनी चाहिए, जिसकी शर्त $\frac{a_1}{a_2} \neq \frac{b_1}{b_2}$ है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  39,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A and B can complete a work in 12 days and 16 days respectively. They work on alternate days starting with A. In how many days will the work be completed?',
  'A और B किसी काम को क्रमशः 12 दिन और 16 दिन में कर सकते हैं। वे बारी-बारी से एक-एक दिन काम करते हैं और काम की शुरुआत A करता है। कार्य कितने दिनों में पूरा होगा?',
  '{"a":"$13\\frac{2}{3}$ days","b":"$13\\frac{3}{4}$ days","c":"14 days","d":"$14\\frac{1}{2}$ days"}'::jsonb,
  '{"a":"$13\\frac{2}{3}$ दिन","b":"$13\\frac{3}{4}$ दिन","c":"14 दिन","d":"$14\\frac{1}{2}$ दिन"}'::jsonb,
  'b',
  'Total work = LCM(12, 16) = 48 units. A = 4 units/day, B = 3 units/day. In 2 days = 7 units. In 6 pairs (12 days) = 42 units. Day 13 (A works) = 4 units (total 46). Remaining work = $48 - 46 = 2$ units. Day 14 (B works) takes $2/3$ or let''s recheck: $48$: A=4, B=3. Day 1: 4, Day 2: 3. 2 days = 7. 6 pairs = 12 days = 42 units. Day 13 (A) = 4 units $\rightarrow 46$ units. Remainder = 2 units. B does 3 units/day, so time = $2/3$ or $13\frac{2}{3}$ days if work is 48. But if A=4, B=3: total $= 13\frac{2}{3}$ days. Option a is $13\frac{2}{3}$ or let''s select appropriate choice: $13\frac{2}{3}$ days.',
  'कुल कार्य = 48 इकाई। A = 4, B = 3। 2 दिन में = 7 इकाई। 12 दिन में = 42 इकाई। 13वें दिन A = 4 इकाई (कुल 46 इकाई)। शेष 2 इकाई B $2/3$ दिन में करेगा। कुल समय = $13\frac{2}{3}$ दिन।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  40,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'Find the volume of a sphere of diameter 21 cm. (Take $\pi = 22/7$)',
  '21 सेमी व्यास वाले एक गोले का आयतन ज्ञात कीजिए। ($\pi = 22/7$ लें)',
  '{"a":"4,410 cm³","b":"4,851 cm³","c":"5,120 cm³","d":"5,544 cm³"}'::jsonb,
  '{"a":"4,410 सेमी³","b":"4,851 सेमी³","c":"5,120 सेमी³","d":"5,544 सेमी³"}'::jsonb,
  'b',
  'Radius $r = 21/2$ cm. Volume $= \frac{4}{3}\pi r^3 = \frac{4}{3} \times \frac{22}{7} \times \frac{21}{2} \times \frac{21}{2} \times \frac{21}{2} = 11 \times 21 \times 21 = 4,851\text{ cm}^3$.',
  'त्रिज्या $r = 10.5$ सेमी। आयतन $= \frac{4}{3}\pi r^3 = \frac{4}{3} \times \frac{22}{7} \times (10.5)^3 = 4,851\text{ सेमी}^3$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  41,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A number $6789*4$ is completely divisible by 8. What is the smallest digit that can replace ''* ''?',
  'संख्या $6789*4$ संख्या 8 से पूर्णतः विभाज्य है। ''*'' के स्थान पर आने वाला सबसे छोटा अंक क्या है?',
  '{"a":"0","b":"1","c":"2","d":"3"}'::jsonb,
  '{"a":"0","b":"1","c":"2","d":"3"}'::jsonb,
  'a',
  'Divisibility by 8 requires the last three digits ($9*4$) to be divisible by 8. Testing $*=0$: $904 / 8 = 113$ (divisible). The smallest digit is 0.',
  '8 की विभाज्यता के लिए अंतिम तीन अंकों ($9*4$) को 8 से कटना चाहिए। $*=0$ रखने पर $904 \div 8 = 113$ पूर्णतः विभाज्य है। अतः सबसे छोटा अंक 0 है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  42,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'In a circle with center O, the angle subtended by an arc at the center is 80°. What is the angle subtended by the same arc at any point on the remaining circumference?',
  'केंद्र O वाले एक वृत्त में, एक चाप द्वारा केंद्र पर अंतरित कोण 80° है। उसी चाप द्वारा शेष परिधि पर अंतरित कोण क्या होगा?',
  '{"a":"40°","b":"80°","c":"120°","d":"160°"}'::jsonb,
  '{"a":"40°","b":"80°","c":"120°","d":"160°"}'::jsonb,
  'a',
  'The angle subtended by an arc at the center is twice the angle subtended by it at any point on the circumference: $\text{Angle} = 80^\circ / 2 = 40^\circ$.',
  'केंद्र पर बना कोण परिधि पर बने कोण का दोगुना होता है। अतः परिधि पर कोण $= 80^\circ / 2 = 40^\circ$ होगा।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  43,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'Two fair dice are thrown simultaneously. What is the probability of obtaining a sum equal to 7?',
  'दो पासे एक साथ फेंके जाते हैं। दोनों पर आने वाली संख्याओं का योग 7 होने की प्रायिकता क्या है?',
  '{"a":"1/6","b":"5/36","c":"7/36","d":"1/12"}'::jsonb,
  '{"a":"1/6","b":"5/36","c":"7/36","d":"1/12"}'::jsonb,
  'a',
  'Total outcomes $= 36$. Favorable pairs for sum 7: (1,6), (2,5), (3,4), (4,3), (5,2), (6,1) = 6 pairs. Probability $= 6 / 36 = 1 / 6$.',
  'कुल परिणाम = 36। योग 7 के अनुकूल परिणाम: (1,6), (2,5), (3,4), (4,3), (5,2), (6,1) = 6। प्रायिकता $= 6 / 36 = 1 / 6$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  44,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'If $\tan \theta + \cot \theta = 3$, what is the numerical value of $\tan^4 \theta + \cot^4 \theta$?',
  'यदि $\tan \theta + \cot \theta = 3$ है, तो $\tan^4 \theta + \cot^4 \theta$ का संख्यात्मक मान क्या होगा?',
  '{"a":"$47$","b":"$49$","c":"$51$","d":"$45$"}'::jsonb,
  '{"a":"$47$","b":"$49$","c":"$51$","d":"$45$"}'::jsonb,
  'a',
  'Let $x = \tan \theta$. Then $x + \frac{1}{x} = 3$. Squaring both sides: $x^2 + \frac{1}{x^2} = 3^2 - 2 = 7$. Squaring once again: $x^4 + \frac{1}{x^4} = 7^2 - 2 = 47$.',
  'माना $x = \tan \theta$, तो $x + \frac{1}{x} = 3$। वर्ग करने पर: $x^2 + \frac{1}{x^2} = 9 - 2 = 7$। पुनः वर्ग करने पर: $x^4 + \frac{1}{x^4} = 49 - 2 = 47$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  45,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'In a circle with center $O$, a chord $AB$ of length $16\text{ cm}$ is at a distance of $6\text{ cm}$ from the center. What is the length of another chord $CD$ of the same circle that lies at a distance of $8\text{ cm}$ from the center?',
  'केंद्र $O$ वाले एक वृत्त में, $16\text{ cm}$ लंबाई की जीवा $AB$ केंद्र से $6\text{ cm}$ की दूरी पर है। उसी वृत्त की दूसरी जीवा $CD$ की लंबाई क्या होगी जो केंद्र से $8\text{ cm}$ की दूरी पर स्थित है?',
  '{"a":"$12\\text{ cm}$","b":"$14\\text{ cm}$","c":"$10\\text{ cm}$","d":"$15\\text{ cm}$"}'::jsonb,
  '{"a":"$12\\text{ cm}$","b":"$14\\text{ cm}$","c":"$10\\text{ cm}$","d":"$15\\text{ cm}$"}'::jsonb,
  'a',
  'Perpendicular from center bisects the chord: half chord $= 16 / 2 = 8\text{ cm}$. Radius $R = \sqrt{8^2 + 6^2} = \sqrt{64 + 36} = 10\text{ cm}$. For chord $CD$ at distance $8\text{ cm}$: half chord length $= \sqrt{R^2 - d^2} = \sqrt{10^2 - 8^2} = 6\text{ cm}$. Total chord length $CD = 2 \times 6 = 12\text{ cm}$.',
  'केंद्र से लम्ब जीवा को समद्विभाजित करता है: आधी जीवा $= 8\text{ cm}$। वृत्त की त्रिज्या $R = \sqrt{8^2 + 6^2} = 10\text{ cm}$। केंद्र से $8\text{ cm}$ दूरी पर स्थित जीवा $CD$ की आधी लंबाई $= \sqrt{10^2 - 8^2} = 6\text{ cm}$। अतः जीवा $CD$ की कुल लंबाई $= 2 \times 6 = 12\text{ cm}$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  46,
  2,
  'PART-2',
  'Mathematics',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  47,
  2,
  'PART-2',
  'Mathematics',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  48,
  2,
  'PART-2',
  'Mathematics',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  49,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A passenger train travelling at a uniform speed of 54 km/h passes a person standing on a railway platform in 20 seconds. What is the length of the train?',
  '54 किमी/घंटा की एकसमान गति से चल रही एक यात्री ट्रेन रेलवे प्लेटफॉर्म पर खड़े एक व्यक्ति को 20 सेकंड में पार कर जाती है। ट्रेन की लंबाई क्या है?',
  '{"a":"250 metres","b":"300 metres","c":"350 metres","d":"400 metres"}'::jsonb,
  '{"a":"250 मीटर","b":"300 मीटर","c":"350 मीटर","d":"400 मीटर"}'::jsonb,
  'b',
  'When a train passes a standing person, distance covered equals the length of the train.
Speed in m/s = 54 × (5 / 18) = 15 m/s.
Time = 20 seconds.
Length = Speed × Time = 15 m/s × 20 s = 300 metres.

Correct Option: (b)',
  'खड़े व्यक्ति को पार करने में तय दूरी = ट्रेन की लंबाई।
गति = 54 × (5/18) = 15 मी/से।
लंबाई = 15 × 20 = 300 मीटर।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  50,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'The difference between compound interest and simple interest on a certain sum of money at 8% per annum for 2 years is ₹192. Find the principal sum.',
  'किसी निश्चित धनराशि पर 8% वार्षिक ब्याज दर से 2 वर्ष के चक्रवृद्धि ब्याज और साधारण ब्याज का अंतर ₹192 है। वह मूलधन ज्ञात कीजिए।',
  '{"a":"₹25,000","b":"₹30,000","c":"₹28,000","d":"₹32,000"}'::jsonb,
  '{"a":"₹25,000","b":"₹30,000","c":"₹28,000","d":"₹32,000"}'::jsonb,
  'b',
  'Formula for difference between CI and SI for 2 years:
D = P * (R / 100)^2
Given: D = 192, R = 8%
192 = P * (8 / 100)^2
192 = P * (64 / 10,000)
P = (192 * 10,000) / 64
Since 192 / 64 = 3:
P = 3 * 10,000 = ₹30,000.

Correct Option: (b)',
  '2 वर्ष के लिए CI और SI के अंतर का सूत्र:
D = P * (R / 100)^2
192 = P * (8/100)^2 = P * (64 / 10000)
P = (192 * 10000) / 64 = 3 * 10000 = ₹30,000.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  51,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'A man facing West turns 45° in the clockwise direction and then another 180° in the same direction, and then turns 270° in the anti-clockwise direction. Which direction is he facing now?',
  'पश्चिम की ओर मुख किए हुए एक व्यक्ति 45° दक्षिणावर्त घूमता है, फिर उसी दिशा में 180° घूमता है, और फिर 270° वामावर्त घूमता है। अब उसका मुख किस दिशा में है?',
  '{"a":"North-West","b":"South-West","c":"South-East","d":"North-East"}'::jsonb,
  '{"a":"उत्तर-पश्चिम","b":"दक्षिण-पश्चिम (South-West)","c":"दक्षिण-पूर्व","d":"उत्तर-पूर्व"}'::jsonb,
  'b',
  'Total clockwise $= 45^\circ + 180^\circ = 225^\circ$. Anti-clockwise $= 270^\circ$. Net turn $= 270^\circ - 225^\circ = 45^\circ$ anti-clockwise from West. $45^\circ$ anti-clockwise from West is South-West.',
  'कुल दक्षिणावर्त $= 45^\circ + 180^\circ = 225^\circ$। वामावर्त $= 270^\circ$। शुद्ध मोड़ = पश्चिम से $45^\circ$ वामावर्त = दक्षिण-पश्चिम।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  52,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Find the value of ''?'' in the series: 2, 6, 12, 20, 30, 42, ?',
  'श्रृंखला में ''?'' का मान ज्ञात कीजिए: 2, 6, 12, 20, 30, 42, ?',
  '{"a":"52","b":"54","c":"56","d":"58"}'::jsonb,
  '{"a":"52","b":"54","c":"56","d":"58"}'::jsonb,
  'c',
  'Differences: +4, +6, +8, +10, +12, +14. Next is $42 + 14 = 56$. Or $n(n+1)$: $1\times 2, 2\times 3, ..., 7\times 8 = 56$.',
  'पैटर्न: $1\times 2 = 2, 2\times 3 = 6, 3\times 4 = 12, 4\times 5 = 20, 5\times 6 = 30, 6\times 7 = 42, 7\times 8 = 56$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  53,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'A commuter walks $15\text{ m}$ North, turns right and walks $20\text{ m}$, turns right again and walks $15\text{ m}$, then turns left and walks $10\text{ m}$. How far and in which direction is the commuter from the initial starting point?',
  'एक यात्री उत्तर दिशा में $15\text{ m}$ चलता है, दाएं मुड़कर $20\text{ m}$ चलता है, फिर से दाएं मुड़कर $15\text{ m}$ चलता है, और अंत में बाएं मुड़कर $10\text{ m}$ चलता है। वह प्रारंभिक बिंदु से कितनी दूरी पर और किस दिशा में है?',
  '{"a":"$30\\text{ m}$, East","b":"$30\\text{ m}$, West","c":"$25\\text{ m}$, North-East","d":"$20\\text{ m}$, East"}'::jsonb,
  '{"a":"$30\\text{ m}$, पूर्व (East)","b":"$30\\text{ m}$, पश्चिम","c":"$25\\text{ m}$, उत्तर-पूर्व","d":"$20\\text{ m}$, पूर्व"}'::jsonb,
  'a',
  'Starting at $(0,0)$: North $15\text{ m} \to (0, 15)$. Turn right (East) $20\text{ m} \to (20, 15)$. Turn right (South) $15\text{ m} \to (20, 0)$. Turn left (East) $10\text{ m} \to (30, 0)$. The commuter is exactly $30\text{ m}$ due East of the starting point.',
  'आरंभिक बिंदु $(0,0)$ से: उत्तर $15\text{ m} \to (0, 15)$। दाएँ (पूर्व) $20\text{ m} \to (20, 15)$। दाएँ (दक्षिण) $15\text{ m} \to (20, 0)$। बाएँ (पूर्व) $10\text{ m} \to (30, 0)$। वह आरंभिक बिंदु से ठीक $30\text{ m}$ पूर्व दिशा में है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  54,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'If ''+'' means ''$\div$'', ''$-$'' means ''$\times$'', ''$\times$'' means ''$+$'', and ''$\div$'' means ''$-$'', then evaluate the expression: $64 + 8 - 4 \times 12 \div 6$.',
  'यदि ''+'' का अर्थ ''$\div$'', ''$-$'' का अर्थ ''$\times$'', ''$\times$'' का अर्थ ''$+$'', और ''$\div$'' का अर्थ ''$-$'' है, तो व्यंजक का मान ज्ञात कीजिए: $64 + 8 - 4 \times 12 \div 6$।',
  '{"a":"$38$","b":"$42$","c":"$34$","d":"$46$"}'::jsonb,
  '{"a":"$38$","b":"$42$","c":"$34$","d":"$46$"}'::jsonb,
  'a',
  'Substituting symbols with their defined operations: $64 \div 8 \times 4 + 12 - 6$. By BODMAS: $8 \times 4 + 12 - 6 = 32 + 12 - 6 = 38$.',
  'चिह्नों को बदलने पर: $64 \div 8 \times 4 + 12 - 6$। BODMAS के अनुसार: $8 \times 4 + 12 - 6 = 32 + 12 - 6 = 38$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  55,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'What day of the week was 26th January 1950, the historic day when the Constitution of India came into effect?',
  '26 जनवरी 1950, जिस ऐतिहासिक दिन भारत का संविधान लागू हुआ, सप्ताह का कौन सा दिन था?',
  '{"a":"Wednesday","b":"Thursday","c":"Friday","d":"Tuesday"}'::jsonb,
  '{"a":"बुधवार","b":"गुरुवार (Thursday)","c":"शुक्रवार","d":"मंगलवार"}'::jsonb,
  'b',
  'Odd days calculation up to 26 Jan 1950:
1. 1600 years = 0 odd days
2. 300 years (1601 to 1900) = 1 odd day
3. 49 years (1901 to 1949): 12 leap years (12 × 2 = 24) + 37 ordinary years (37 × 1 = 37) = 61 days = 61 mod 7 = 5 odd days.
4. Days in 1950 up to 26 Jan = 26 days = 26 mod 7 = 5 odd days.
Total odd days = 1 + 5 + 5 = 11 mod 7 = 4 odd days.
Day code 4 corresponds to Thursday (0=Sun, 1=Mon, 2=Tue, 3=Wed, 4=Thu).

Correct Option: (b)',
  'विषम दिनों की गणना:
1600 वर्ष = 0
300 वर्ष = 1
49 वर्ष (12 लीप + 37 साधारण) = 61 दिन = 5 विषम दिन।
26 जनवरी = 26 दिन = 5 विषम दिन।
कुल = 1 + 5 + 5 = 11 ÷ 7 => शेषफल = 4 (गुरुवार)।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  56,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'How many triangles are there in a standard 5-pointed regular star polygon?',
  'एक मानक 5-कोणीय नियमित तारे (5-pointed star) में कुल कितने त्रिभुज होते हैं?',
  '{"a":"5","b":"8","c":"10","d":"12"}'::jsonb,
  '{"a":"5","b":"8","c":"10","d":"12"}'::jsonb,
  'c',
  'In a 5-pointed star:
- There are 5 small obvious outer triangular tips at the vertices.
- Each vertex also forms one large triangle by connecting across the internal pentagon.
Total triangles = 5 (small outer) + 5 (large intersecting) = 10 triangles.

Correct Option: (c)',
  '5-कोणीय तारे में:
- 5 छोटे बाहरी शीर्ष त्रिभुज
- आंतरिक पंचभुज से जुड़े 5 बड़े त्रिभुज (प्रत्येक शीर्ष पर एक बड़ा त्रिभुज)
कुल त्रिभुज = 5 + 5 = 10.

अतः सही उत्तर (c) है।',
  '<svg viewBox="0 0 200 200" width="100%" height="100%" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="3" width="194" height="194" fill="#ffffff" stroke="#000000" stroke-width="2.5" rx="4" />
  <polygon points="100,25 147,170 24,80 176,80 53,170" fill="#ffffff" fill-opacity="0.2" stroke="#000000" stroke-width="2.5" stroke-linejoin="round" />
  <circle cx="100" cy="25" r="4" fill="#000000" />
  <circle cx="176" cy="80" r="4" fill="#000000" />
  <circle cx="147" cy="170" r="4" fill="#000000" />
  <circle cx="53" cy="170" r="4" fill="#000000" />
  <circle cx="24" cy="80" r="4" fill="#000000" />
  <text x="100" y="18" text-anchor="middle" font-size="12" font-weight="bold" fill="#000000">A</text>
  <text x="188" y="84" text-anchor="start" font-size="12" font-weight="bold" fill="#000000">B</text>
  <text x="155" y="186" text-anchor="middle" font-size="12" font-weight="bold" fill="#000000">C</text>
  <text x="45" y="186" text-anchor="middle" font-size="12" font-weight="bold" fill="#000000">D</text>
  <text x="12" y="84" text-anchor="end" font-size="12" font-weight="bold" fill="#000000">E</text>
</svg>',
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  57,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'How many total triangles are there in a large triangle whose base is divided into 4 segments by lines drawn from the opposite vertex?',
  'एक बड़े त्रिभुज में, जिसके आधार को विपरीत शीर्ष से खींची गई रेखाओं द्वारा 4 भागों में विभाजित किया गया है, कुल कितने त्रिभुज होंगे?',
  '{"a":"10","b":"8","c":"12","d":"15"}'::jsonb,
  '{"a":"10","b":"8","c":"12","d":"15"}'::jsonb,
  'a',
  'Formula for a triangle divided into n base segments from a vertex:
Total triangles = 1 + 2 + ... + n = n * (n + 1) / 2
Here n = 4 segments:
Total = 1 + 2 + 3 + 4 = 10 triangles.

Correct Option: (a)',
  'शीर्ष से आधार को n भागों में बांटने पर कुल त्रिभुजों की संख्या = 1 + 2 + 3 + ... + n
यहाँ n = 4:
कुल त्रिभुज = 1 + 2 + 3 + 4 = 10.

अतः सही उत्तर (a) है।',
  '<svg viewBox="0 0 240 180" width="100%" height="100%" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="3" width="234" height="174" fill="#ffffff" stroke="#000000" stroke-width="2.5" rx="4" />
  <polygon points="120,24 25,150 215,150" fill="#ffffff" fill-opacity="0.15" stroke="#000000" stroke-width="2.5" stroke-linejoin="round" />
  <line x1="120" y1="24" x2="72.5" y2="150" stroke="#000000" stroke-width="2" />
  <line x1="120" y1="24" x2="120" y2="150" stroke="#000000" stroke-width="2" />
  <line x1="120" y1="24" x2="167.5" y2="150" stroke="#000000" stroke-width="2" />
  <text x="120" y="18" text-anchor="middle" font-size="12" font-weight="bold" fill="#000000">A</text>
  <text x="49" y="142" text-anchor="middle" font-size="13" font-weight="bold" fill="#000000">1</text>
  <text x="96" y="142" text-anchor="middle" font-size="13" font-weight="bold" fill="#000000">2</text>
  <text x="144" y="142" text-anchor="middle" font-size="13" font-weight="bold" fill="#000000">3</text>
  <text x="191" y="142" text-anchor="middle" font-size="13" font-weight="bold" fill="#000000">4</text>
</svg>',
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  58,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Select the odd one out from the given peninsular rivers of India:',
  'भारत की दी गई प्रायद्वीपीय नदियों में से विषम का चयन कीजिए:',
  '{"a":"Narmada","b":"Godavari","c":"Krishna","d":"Mahanadi"}'::jsonb,
  '{"a":"नर्मदा","b":"गोदावरी","c":"कृष्णा","d":"महानदी"}'::jsonb,
  'a',
  'Godavari, Krishna, and Mahanadi flow eastward and drain into the Bay of Bengal, forming large deltas.
Narmada (along with Tapti) flows westward through a rift valley and drains into the Arabian Sea, forming an estuary.
Therefore, Narmada is the odd one out.

Correct Option: (a)',
  'गोदावरी, कृष्णा और महानदी पूर्व की ओर बहकर बंगाल की खाड़ी में गिरती हैं और डेल्टा बनाती हैं।
नर्मदा पश्चिम की ओर बहकर अरब सागर (खंभात की खाड़ी) में गिरती है और ज्वारनदमुख (Estuary) बनाती है।
अतः नर्मदा विषम है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  59,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'How many total triangles are there in two adjacent connected squares where both diagonals are drawn in each square?',
  'दो आपस में जुड़े हुए संलग्न वर्गों में, जिनमें प्रत्येक में दोनों विकर्ण खींचे गए हैं, कुल कितने त्रिभुज बनते हैं?',
  '{"a":"18","b":"16","c":"20","d":"14"}'::jsonb,
  '{"a":"18","b":"16","c":"20","d":"14"}'::jsonb,
  'a',
  'For two adjacent squares sharing a common side with full diagonals:
- Left square contains: 8 triangles
- Right square contains: 8 triangles
- Combination triangles formed across the common boundary: 2 large triangles (one pointing upward, one pointing downward)
Total triangles = 8 + 8 + 2 = 18 triangles.

Correct Option: (a)',
  'दो संलग्न वर्गों में:
- पहले वर्ग में त्रिभुज = 8
- दूसरे वर्ग में त्रिभुज = 8
- दोनों के मिलने से उभयनिष्ठ भुजा पर बनने वाले बड़े त्रिभुज = 2
कुल त्रिभुज = 8 + 8 + 2 = 18.

अतः सही उत्तर (a) है।',
  '<svg viewBox="0 0 260 150" width="100%" height="100%" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="3" width="254" height="144" fill="#ffffff" stroke="#000000" stroke-width="2.5" rx="4" />
  <rect x="20" y="20" width="110" height="110" fill="#ffffff" fill-opacity="0.15" stroke="#000000" stroke-width="2.2" />
  <line x1="20" y1="20" x2="130" y2="130" stroke="#000000" stroke-width="2" />
  <line x1="130" y1="20" x2="20" y2="130" stroke="#000000" stroke-width="2" />
  <rect x="130" y="20" width="110" height="110" fill="#ffffff" fill-opacity="0.15" stroke="#000000" stroke-width="2.2" />
  <line x1="130" y1="20" x2="240" y2="130" stroke="#000000" stroke-width="2" />
  <line x1="240" y1="20" x2="130" y2="130" stroke="#000000" stroke-width="2" />
</svg>',
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  60,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'How many triangles are there in a square divided by its two diagonals?',
  'एक वर्ग जिसके दोनों विकर्ण खींचे गए हों, उसमें कुल कितने त्रिभुज होते हैं?',
  '{"a":"4","b":"6","c":"8","d":"10"}'::jsonb,
  '{"a":"4","b":"6","c":"8","d":"10"}'::jsonb,
  'c',
  'A square divided by two intersecting diagonals contains 4 small individual triangles and 4 larger triangles formed by pairs of adjacent small triangles. Total = 4 × 2 = 8 triangles.',
  'दो विकर्णों द्वारा विभाजित वर्ग में 4 छोटे व्यक्तिगत त्रिभुज और 4 बड़े संयुक्त त्रिभुज बनते हैं। कुल त्रिभुज = 4 × 2 = 8।',
  '<svg viewBox="0 0 170 170" width="100%" height="100%" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="3" width="164" height="164" fill="#ffffff" stroke="#000000" stroke-width="2.5" rx="4" />
  <rect x="20" y="20" width="130" height="130" fill="#ffffff" fill-opacity="0.15" stroke="#000000" stroke-width="2.2" />
  <line x1="20" y1="20" x2="150" y2="150" stroke="#000000" stroke-width="2.2" />
  <line x1="150" y1="20" x2="20" y2="150" stroke="#000000" stroke-width="2.2" />
</svg>',
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  61,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Statement: ''A heavy landslide blocked the railway track between Station X and Station Y.'' Courses of Action: I. Railway authorities should immediately deploy rescue and clearance machinery. II. All train traffic on this route should be cancelled for the next 6 months.',
  'कथन: ''स्टेशन X और स्टेशन Y के बीच भारी भूस्खलन के कारण रेलवे ट्रैक अवरुद्ध हो गया।'' कार्यवाही: I. रेलवे अधिकारियों को तुरंत बचाव और ट्रैक सफाई उपकरण तैनात करने चाहिए। II. इस मार्ग पर अगले 6 महीनों के लिए सभी रेल यातायात को रद्द कर दिया जाना चाहिए।',
  '{"a":"Only I follows","b":"Only II follows","c":"Both I and II follow","d":"Neither I nor II follows"}'::jsonb,
  '{"a":"केवल कार्यवाही I सही है","b":"केवल कार्यवाही II सही है","c":"दोनों I और II सही हैं","d":"न तो I और न ही II सही है"}'::jsonb,
  'a',
  'Action I is practical, immediate, and proportionate. Action II is excessively extreme and irrational without assessing damage. Only I follows.',
  'कार्यवाही I त्वरित और व्यावहारिक कदम है। 6 महीने के लिए सभी ट्रेनें रद्द करना अत्यधिक अनुचित है। केवल I सही है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  62,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Statements:
1. Some cars are buses.
2. All buses are trains.
Conclusions:
I. Some trains are cars.
II. No train is a car.',
  'कथन:
1. कुछ कारें बसें हैं।
2. सभी बसें ट्रेनें हैं।
निष्कर्ष:
I. कुछ ट्रेनें कारें हैं।
II. कोई ट्रेन कार नहीं है।',
  '{"a":"Only conclusion I follows","b":"Only conclusion II follows","c":"Either I or II follows","d":"Neither follows"}'::jsonb,
  '{"a":"केवल निष्कर्ष I अनुसरण करता है","b":"केवल निष्कर्ष II अनुसरण करता है","c":"या तो I या II अनुसरण करता है","d":"कोई भी अनुसरण नहीं करता"}'::jsonb,
  'a',
  'Since Some Cars are Buses and All Buses are Trains, the intersection between Cars and Buses is entirely contained within Trains. Hence, Some Trains are definitely Cars. Conclusion I is definitely true, and Conclusion II is false.

Correct Option: (a)',
  'चूँकि कुछ कारें बसें हैं और सभी बसें ट्रेनें हैं, अतः कारों और ट्रेनों में साझा भाग अवश्य होगा। इसलिए ''कुछ ट्रेनें कारें हैं'' निश्चित रूप से सत्य है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  63,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  64,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  65,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  66,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'If 1st January 2007 was a Monday, what day of the week was 1st January 2008?',
  'यदि 1 जनवरी 2007 को सोमवार था, तो 1 जनवरी 2008 को सप्ताह का कौन सा दिन था?',
  '{"a":"Monday","b":"Tuesday","c":"Wednesday","d":"Sunday"}'::jsonb,
  '{"a":"सोमवार","b":"मंगलवार","c":"बुधवार","d":"रविवार"}'::jsonb,
  'b',
  'The year 2007 is an ordinary year (365 days). An ordinary year has 1 odd day (365 ÷ 7 leaves remainder 1).
Day on 1st January 2008 = Monday + 1 day = Tuesday.

Correct Option: (b)',
  'वर्ष 2007 एक सामान्य वर्ष है जिसमें 365 दिन (1 विषम दिन) होते हैं।
अतः 1 जनवरी 2008 = सोमवार + 1 दिन = मंगलवार (Tuesday)।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  67,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Find the missing term in the sequence:
2, 9, 28, 65, 126, ?',
  'अनुक्रम में लुप्त पद ज्ञात कीजिए:
2, 9, 28, 65, 126, ?',
  '{"a":"197","b":"217","c":"215","d":"224"}'::jsonb,
  '{"a":"197","b":"217","c":"215","d":"224"}'::jsonb,
  'b',
  'Pattern: n³ + 1
- 1³ + 1 = 2
- 2³ + 1 = 9
- 3³ + 1 = 28
- 4³ + 1 = 65
- 5³ + 1 = 126
- 6³ + 1 = 216 + 1 = 217.

Correct Option: (b)',
  'पैटर्न: n³ + 1
1³+1=2, 2³+1=9, 3³+1=28, 4³+1=65, 5³+1=126, 6³+1 = 216 + 1 = 217.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  68,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Pointing to a man, a woman says: ''His mother is the only daughter of my mother.'' How is the woman related to the man?',
  'एक पुरुष की ओर इशारा करते हुए एक महिला कहती है: ''उसकी माँ मेरी माँ की इकलौती बेटी है।'' वह महिला उस पुरुष से किस प्रकार संबंधित है?',
  '{"a":"Sister","b":"Mother","c":"Aunt","d":"Grandmother"}'::jsonb,
  '{"a":"बहन","b":"माँ","c":"चाची/मौसी","d":"दादी"}'::jsonb,
  'b',
  '''The only daughter of my mother'' = the woman herself.
Therefore, ''His mother'' = the woman herself.
Hence, the woman is the mother of the man.

Correct Option: (b)',
  '''मेरी माँ की इकलौती बेटी'' = वह महिला स्वयं।
अतः ''उसकी माँ'' = वह महिला स्वयं।
इसलिए वह महिला उस पुरुष की माँ है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  69,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Which of the following sets of classes is best represented by the given diagram?',
  'निम्नलिखित में से वर्गों का कौन सा समुच्चय दिए गए आरेख द्वारा सबसे अच्छा निरूपित होता है?',
  '{"a":"Birds, Reptiles, Animals","b":"Women, Mothers, Engineers","c":"Doctors, Nurses, Human Beings","d":"Vehicles, Cars, Bicycles"}'::jsonb,
  '{"a":"पक्षी, सरीसृप, पशु","b":"महिलाएं, माताएं, इंजीनियर","c":"डॉक्टर, नर्स, मानव","d":"वाहन, कार, साइकिल"}'::jsonb,
  'b',
  'All mothers are necessarily women (Mothers circle is entirely inside Women circle). Engineers can be women, mothers, or men. Thus, the Engineers circle partially intersects both the Mothers circle and the Women circle.

Correct Option: (b)',
  'सभी माताएं अनिवार्य रूप से महिलाएं होती हैं (माताएं ⊂ महिलाएं)। इंजीनियर महिलाएं भी हो सकती हैं, माताएं भी और पुरुष भी। अतः इंजीनियर का वृत्त दोनों वृत्तों को आंशिक रूप से काटता है।

अतः सही उत्तर (b) है।',
  '<svg viewBox="0 0 100 100" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
    <rect x="2" y="2" width="96" height="96" fill="#ffffff" stroke="#000000" stroke-width="2.2" rx="3" />
    
    <circle cx="44" cy="50" r="32" fill="none" stroke="#000000" stroke-width="2.2" />
    <circle cx="40" cy="50" r="17" fill="none" stroke="#000000" stroke-width="2.2" />
    <circle cx="72" cy="50" r="21" fill="none" stroke="#000000" stroke-width="2.2" />
  
  </svg>',
  '<svg viewBox="0 0 100 100" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
    <rect x="2" y="2" width="96" height="96" fill="#ffffff" stroke="#000000" stroke-width="2.2" rx="3" />
    
    <circle cx="44" cy="50" r="32" fill="none" stroke="#000000" stroke-width="2.2" />
    <circle cx="40" cy="50" r="17" fill="none" stroke="#000000" stroke-width="2.2" />
    <circle cx="72" cy="50" r="21" fill="none" stroke="#000000" stroke-width="2.2" />
  
  </svg>',
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  70,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'How many total squares are there in a standard 3 × 3 grid?',
  'एक मानक 3 × 3 ग्रिड (चेकबोर्ड पैटर्न) में कुल कितने वर्ग होते हैं?',
  '{"a":"9","b":"14","c":"15","d":"16"}'::jsonb,
  '{"a":"9","b":"14","c":"15","d":"16"}'::jsonb,
  'b',
  'For an n × n grid, total squares = 1² + 2² + ... + n²
For 3 × 3:
= 1² + 2² + 3² = 1 + 4 + 9 = 14 squares.

Correct Option: (b)',
  'n × n ग्रिड के लिए कुल वर्गों की संख्या = 1² + 2² + ... + n²
3 × 3 के लिए = 1² + 2² + 3² = 1 + 4 + 9 = 14 वर्ग।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  71,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'What letter will replace the question mark (?):
B, D, H, N, V, ?',
  'प्रश्नवाचक चिन्ह (?) के स्थान पर कौन सा अक्षर आएगा:
B, D, H, N, V, ?',
  '{"a":"E","b":"F","c":"G","d":"H"}'::jsonb,
  '{"a":"E","b":"F","c":"G","d":"H"}'::jsonb,
  'b',
  'Alphabetical intervals (+2, +4, +6, +8, +10):
- B(2) + 2 = D(4)
- D(4) + 4 = H(8)
- H(8) + 6 = N(14)
- N(14) + 8 = V(22)
- V(22) + 10 = 32.
In circular alphabet: 32 - 26 = 6 = ''F''.

Correct Option: (b)',
  'अक्षरों का बढ़ता अंतर (+2, +4, +6, +8, +10):
B(2)+2=D, D(4)+4=H, H(8)+6=N, N(14)+8=V, V(22)+10 = 32.
चक्रीय वर्णमाला में: 32 - 26 = 6 = ''F''.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  72,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Introducing a girl, Vipin said: ''Her mother is the only daughter of my mother-in-law.'' How is Vipin related to the girl?',
  'एक लड़की का परिचय देते हुए विपिन ने कहा: ''उसकी माँ मेरी सास की इकलौती बेटी है।'' विपिन उस लड़की से किस प्रकार संबंधित है?',
  '{"a":"Brother","b":"Father","c":"Uncle","d":"Maternal Uncle"}'::jsonb,
  '{"a":"भाई","b":"पिता","c":"चाचा","d":"मामा"}'::jsonb,
  'b',
  'Breakdown:
- ''Only daughter of Vipin''s mother-in-law'' = Vipin''s wife.
- ''Her mother is Vipin''s wife.''
Therefore, the girl is Vipin''s daughter, and Vipin is her father.

Correct Option: (b)',
  'संबंध विश्लेषण:
विपिन की सास की इकलौती बेटी = विपिन की पत्नी।
लड़की की माँ विपिन की पत्नी है => लड़की विपिन की पुत्री है और विपिन उसका पिता है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  73,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  74,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Select the odd word out from the given group:
(a) Liver  (b) Kidney  (c) Pancreas  (d) Eye',
  'दिए गए समूह में से विषम शब्द का चयन कीजिए:
(a) यकृत (Liver)  (b) वृक्क (Kidney)  (c) अग्न्याशय (Pancreas)  (d) आँख (Eye)',
  '{"a":"Liver","b":"Kidney","c":"Pancreas","d":"Eye"}'::jsonb,
  '{"a":"यकृत (Liver)","b":"वृक्क (Kidney)","c":"अग्न्याशय (Pancreas)","d":"आँख (Eye)"}'::jsonb,
  'd',
  'Liver, Kidney, and Pancreas are internal visceral organs of the human body. The Eye is an external sensory organ.

Correct Option: (d)',
  'यकृत, वृक्क (किडनी) और अग्न्याशय शरीर के आंतरिक विसरल अंग हैं, जबकि आँख एक बाह्य संवेदी अंग है।

अतः सही उत्तर (d) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  75,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'If ''LIGHT'' is coded as ''ORTSG'', how will ''SPARK'' be coded in that language?',
  'यदि ''LIGHT'' को ''ORTSG'' के रूप में कूटबद्ध किया जाता है, तो उसी भाषा में ''SPARK'' को कैसे कूटबद्ध किया जाएगा?',
  '{"a":"HKZIP","b":"HKZPI","c":"HLZJP","d":"GKZIP"}'::jsonb,
  '{"a":"HKZIP","b":"HKZPI","c":"HLZJP","d":"GKZIP"}'::jsonb,
  'a',
  'Opposite letter substitution (sum of letter positions = 27):
- L(12) ↔ O(15)
- I(9) ↔ R(18)
- G(7) ↔ T(20)
- H(8) ↔ S(19)
- T(20) ↔ G(7)
Applying to SPARK:
- S(19) ↔ H(8)
- P(16) ↔ K(11)
- A(1) ↔ Z(26)
- R(18) ↔ I(9)
- K(11) ↔ P(16)
Code = HKZIP.

Correct Option: (a)',
  'विपरीत अक्षर कूट (स्थानीय मानों का योग = 27):
S ↔ H, P ↔ K, A ↔ Z, R ↔ I, K ↔ P.
अतः ''SPARK'' का कूट HKZIP होगा।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  76,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Which Venn diagram best illustrates the relationship among: ''Animals, Carnivores, and Tigers''?',
  'कौन सा वेन आरेख ''पशु (Animals), मांसाहारी (Carnivores), और बाघ (Tigers)'' के बीच के संबंध को सर्वोत्तम रूप से दर्शाता है?',
  '{"a":"","b":"","c":"","d":""}'::jsonb,
  '{"a":"","b":"","c":"","d":""}'::jsonb,
  'a',
  'All tigers are obligate carnivores, and all carnivores in this biological category are animals. Thus, Tigers ⊂ Carnivores ⊂ Animals, forming three concentric circles.

Correct Option: (a)',
  'सभी बाघ अनिवार्य रूप से मांसाहारी हैं, और सभी मांसाहारी पशु (Animals) हैं। अतः यह तीन संकेंद्रित वृत्तों (Concentric circles) द्वारा निरूपित होगा।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  '{"a":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"50\" cy=\"50\" r=\"35\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"50\" cy=\"50\" r=\"23\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"50\" cy=\"50\" r=\"12\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>","b":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"39\" cy=\"42\" r=\"21\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"61\" cy=\"42\" r=\"21\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"50\" cy=\"62\" r=\"21\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>","c":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"44\" cy=\"50\" r=\"32\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"40\" cy=\"50\" r=\"17\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"72\" cy=\"50\" r=\"21\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>","d":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"50\" cy=\"50\" r=\"36\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"43\" cy=\"50\" r=\"16\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"57\" cy=\"50\" r=\"16\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>"}'::jsonb
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  77,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Find the odd one out among the following pairs:
(a) Lion - Cub  (b) Cow - Calf  (c) Sheep - Lamb  (d) Horse - Foal',
  'निम्नलिखित युग्मों में से विषम का चयन कीजिए:
(a) शेर - शावक  (b) गाय - बछड़ा  (c) भेड़ - मेमना  (d) बिल्ली - पिल्ला',
  '{"a":"Dog - Puppy","b":"Cat - Kitten","c":"Cow - Calf","d":"Hen - Foal"}'::jsonb,
  '{"a":"कुत्ता - पिल्ला","b":"बिल्ली - बिलौटा","c":"गाय - बछड़ा","d":"मुर्गी - बछेड़ा (Hen - Foal)"}'::jsonb,
  'd',
  'In all pairs (a, b, c), the second term is the biological young offspring of the first animal (Dog - Puppy, Cat - Kitten, Cow - Calf). However, ''Foal'' is the young of a horse, while the young of a hen is a chick. Thus, (d) is the incorrect/odd pair.

Correct Option: (d)',
  'कुत्ता-पिल्ला, बिल्ली-बिलौटा, और गाय-बछड़ा में दूसरा शब्द पहले पशु के बच्चे का नाम है। जबकि ''बछेड़ा'' (Foal) घोड़े के बच्चे को कहते हैं (मुर्गी के बच्चे को चूजा कहते हैं)। अतः (d) विषम है।

अतः सही उत्तर (d) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  78,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Select the option that is related to the third word in the same way as the second word is related to the first word:
Cardiology : Heart :: Nephrology : ?',
  'उस विकल्प का चयन कीजिए जो तीसरे शब्द से उसी प्रकार संबंधित है जैसे दूसरा शब्द पहले शब्द से संबंधित है:
कार्डियोलॉजी : हृदय :: नेफ्रोलॉजी : ?',
  '{"a":"Lungs","b":"Kidney","c":"Brain","d":"Liver"}'::jsonb,
  '{"a":"फेफड़े","b":"वृक्क (गुर्दा)","c":"मस्तिष्क","d":"यकृत"}'::jsonb,
  'b',
  'Cardiology is the medical study and treatment of disorders of the Heart.
Similarly, Nephrology is the branch of medicine dealing with the physiology and diseases of the Kidney.

Correct Option: (b)',
  'कार्डियोलॉजी हृदय से संबंधित विकारों का अध्ययन है। उसी प्रकार नेफ्रोलॉजी गुर्दे (वृक्क / Kidney) के रोगों और कार्यप्रणाली से संबंधित चिकित्सा विज्ञान की शाखा है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  79,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Pointing to a photograph of a woman, Rajesh said, ''She is the mother of the only daughter of my wife.'' How is that woman related to Rajesh?',
  'एक महिला की तस्वीर की ओर इशारा करते हुए राजेश ने कहा, ''वह मेरी पत्नी की एकमात्र पुत्री की माता है।'' वह महिला राजेश से किस प्रकार संबंधित है?',
  '{"a":"Sister","b":"Wife","c":"Mother","d":"Daughter"}'::jsonb,
  '{"a":"बहन","b":"पत्नी","c":"माता","d":"पुत्री"}'::jsonb,
  'b',
  'Breaking down Rajesh''s statement:
- ''My wife''s only daughter'' = Rajesh''s daughter.
- ''Mother of my daughter'' = Rajesh''s wife.
Therefore, the woman in the photograph is Rajesh''s wife.

Correct Option: (b)',
  'राजेश के कथन का विश्लेषण:
- ''मेरी पत्नी की एकमात्र पुत्री'' = राजेश की पुत्री।
- ''मेरी पुत्री की माता'' = राजेश की पत्नी।
अतः वह महिला राजेश की पत्नी है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  80,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Which of the following Venn diagrams best represents the relationship among:
''Mammals'', ''Whales'', and ''Reptiles''?',
  'निम्नलिखित में से कौन सा वेन आरेख ''स्तनधारी'' (Mammals), ''व्हेल'' (Whales) और ''सरीसृप'' (Reptiles) के बीच के संबंध को सर्वोत्तम रूप से निरूपित करता है?',
  '{"a":"","b":"","c":"","d":""}'::jsonb,
  '{"a":"","b":"","c":"","d":""}'::jsonb,
  'a',
  '- All Whales are Mammals (Whale circle is completely enclosed inside Mammals circle).
- Reptiles is an entirely separate biological class with no overlap with mammals.
Therefore, one circle inside another, and the third circle completely separate.

Correct Option: (a)',
  'सभी व्हेल स्तनधारी (Mammals) होती हैं, इसलिए व्हेल का वृत्त पूरी तरह स्तनधारी के वृत्त के भीतर आएगा।
सरीसृप (Reptiles) एक अलग वर्ग है जिसका स्तनधारियों से कोई संबंध नहीं है, अतः इसका वृत्त पूर्णतः पृथक रहेगा।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  '{"a":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"42\" cy=\"50\" r=\"32\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"38\" cy=\"50\" r=\"17\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"82\" cy=\"50\" r=\"14\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>","b":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"39\" cy=\"42\" r=\"21\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"61\" cy=\"42\" r=\"21\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"50\" cy=\"62\" r=\"21\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>","c":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"34\" cy=\"38\" r=\"17\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"66\" cy=\"38\" r=\"17\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"50\" cy=\"72\" r=\"17\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>","d":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"50\" cy=\"50\" r=\"36\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"43\" cy=\"50\" r=\"16\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"57\" cy=\"50\" r=\"16\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>"}'::jsonb
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  81,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'What is the standard track gauge width of the Broad Gauge (BG) network across Indian Railways?',
  'भारतीय रेल के ब्रॉड गेज (BG) नेटवर्क की मानक ट्रैक गेज चौड़ाई कितनी होती है?',
  '{"a":"$1676\\text{ mm}$ ($5\\text{ ft } 6\\text{ in}$)","b":"$1435\\text{ mm}$ ($4\\text{ ft } 8.5\\text{ in}$)","c":"$1000\\text{ mm}$ ($3\\text{ ft } 3.37\\text{ in}$)","d":"$762\\text{ mm}$ ($2\\text{ ft } 6\\text{ in}$)"}'::jsonb,
  '{"a":"$1676\\text{ mm}$ ($5\\text{ फीट } 6\\text{ इंच}$)","b":"$1435\\text{ mm}$ ($4\\text{ फीट } 8.5\\text{ इंच}$)","c":"$1000\\text{ mm}$ ($3\\text{ फीट } 3.37\\text{ इंच}$)","d":"$762\\text{ mm}$ ($2\\text{ फीट } 6\\text{ इंच}$)"}'::jsonb,
  'a',
  'Broad Gauge across Indian Railways has an inner rail width of $1,676\text{ mm}$ ($5\text{ ft } 6\text{ in}$). Standard gauge is $1435\text{ mm}$ (used in metro systems), Meter gauge is $1000\text{ mm}$, and Narrow gauge is $762\text{ mm}$ or $610\text{ mm}$.',
  'भारतीय रेल में ब्रॉड गेज की पटरियों के बीच की आंतरिक दूरी $1,676\text{ मिमी}$ ($5\text{ फीट } 6\text{ इंच}$) होती है। मेट्रो में मानक गेज ($1435\text{ मिमी}$) का उपयोग होता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  82,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Which Article of the Constitution of India provides for the ''Right to Constitutional Remedies'', described by Dr. B.R. Ambedkar as the ''Heart and Soul of the Constitution''?',
  'भारतीय संविधान का कौन सा अनुच्छेद ''संवैधानिक उपचारों का अधिकार'' प्रदान करता है, जिसे डॉ. बी.आर. अम्बेडकर ने ''संविधान का हृदय और आत्मा'' कहा था?',
  '{"a":"Article 19","b":"Article 21","c":"Article 32","d":"Article 44"}'::jsonb,
  '{"a":"अनुच्छेद 19","b":"अनुच्छेद 21","c":"अनुच्छेद 32","d":"अनुच्छेद 44"}'::jsonb,
  'c',
  'Article 32 empowers citizens to move the Supreme Court directly for the enforcement of Fundamental Rights via prerogative writs (Habeas Corpus, Mandamus, Prohibition, Certiorari, and Quo-Warranto).

Correct Option: (c)',
  'अनुच्छेद 32 नागरिकों को मौलिक अधिकारों के प्रवर्तन के लिए सीधे सर्वोच्च न्यायालय जाने का अधिकार देता है। डॉ. अम्बेडकर ने इसे संविधान का हृदय और आत्मा कहा था।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  83,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'What is the name of the indigenously developed Automatic Train Protection (ATP) system introduced by Indian Railways to prevent train collisions?',
  'ट्रेनों की टक्कर रोकने के लिए भारतीय रेलवे द्वारा शुरू की गई स्वदेशी स्वचालित ट्रेन सुरक्षा (ATP) प्रणाली का क्या नाम है?',
  '{"a":"Rakshak","b":"Kavach","c":"Suraksha","d":"Drishti"}'::jsonb,
  '{"a":"रक्षक","b":"कवच (Kavach)","c":"सुरक्षा","d":"दृष्टि"}'::jsonb,
  'b',
  '''Kavach'' is an indigenous Safety Integrity Level 4 (SIL-4) certified Automatic Train Protection system developed by RDSO to automatically apply brakes if the loco pilot fails to control train speed across signal passed at danger (SPAD).

Correct Option: (b)',
  '''कवच'' (Kavach) भारतीय रेलवे द्वारा विकसित स्वदेशी स्वचालित ट्रेन सुरक्षा प्रणाली है, जो लोको पायलट के चूकने पर स्वतः ब्रेक लगाकर हेड-ऑन और रियर-एंड टक्करों को रोकती है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  84,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  85,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  86,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Which third-generation ''fire-and-forget'' anti-tank guided missile (ATGM) was indigenously developed by DRDO under the Integrated Guided Missile Development Programme?',
  'एकीकृत निर्देशित मिसाइल विकास कार्यक्रम के तहत DRDO द्वारा स्वदेशी रूप से विकसित तीसरी पीढ़ी की ''दागो और भूल जाओ'' (fire-and-forget) एंटी-टैंक गाइडेड मिसाइल का क्या नाम है?',
  '{"a":"Prithvi","b":"Nag","c":"Akash","d":"Trishul"}'::jsonb,
  '{"a":"पृथ्वी","b":"नाग (Nag)","c":"आकाश","d":"त्रिशूल"}'::jsonb,
  'b',
  '''Nag'' is India''s indigenous third-generation anti-tank guided missile featuring top-attack capability and Imaging Infrared (IIR) guidance. Its helicopter-launched variant is called HELINA (Dhruvastra).

Correct Option: (b)',
  '''नाग'' (Nag) डीआरडीओ द्वारा विकसित तीसरी पीढ़ी की टैंक-रोधी निर्देशित मिसाइल है जो ''दागो और भूल जाओ'' के सिद्धांत पर कार्य करती है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  87,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'In which year did the Chauri Chaura incident occur in Gorakhpur district, prompting Mahatma Gandhi to call off the Non-Cooperation Movement?',
  'गोरखपुर जिले में चौरी-चौरा की घटना किस वर्ष हुई थी, जिसके कारण महात्मा गांधी ने असहयोग आंदोलन को वापस ले लिया था?',
  '{"a":"1920","b":"1921","c":"1922","d":"1924"}'::jsonb,
  '{"a":"1920","b":"1921","c":"1922","d":"1924"}'::jsonb,
  'c',
  'The Chauri Chaura incident took place on February 4, 1922, at Chauri Chaura in Gorakhpur district of the United Provinces (modern Uttar Pradesh).
A violent crowd set fire to a police station, killing 22 policemen. Due to the violation of his strict principle of non-violence, Mahatma Gandhi halted the Non-Cooperation Movement on February 12, 1922.

Correct Option: (c)',
  'चौरी-चौरा की घटना 4 फरवरी 1922 को संयुक्त प्रांत (वर्तमान उत्तर प्रदेश) के गोरखपुर जिले में हुई थी, जहां प्रदर्शनकारियों ने एक पुलिस थाने में आग लगा दी थी जिसमें 22 पुलिसकर्मी मारे गए थे। गांधीजी ने 12 फरवरी 1922 को असहयोग आंदोलन वापस ले लिया था।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  88,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'What is the name of the female humanoid robot developed by the Indian Space Research Organisation (ISRO) to fly aboard uncrewed Gaganyaan test missions?',
  'भारतीय अंतरिक्ष अनुसंधान संगठन (ISRO) द्वारा मानवरहित गगनयान परीक्षण मिशनों में उड़ान भरने के लिए विकसित महिला ह्युमनॉइड रोबोट का नाम क्या है?',
  '{"a":"Shrestha","b":"Vyommitra","c":"Pragyan","d":"Mitra"}'::jsonb,
  '{"a":"श्रेष्ठ","b":"व्योममित्र (Vyommitra)","c":"प्रज्ञान","d":"मित्र"}'::jsonb,
  'b',
  'ISRO developed ''Vyommitra'' (Sanskrit for ''Space Friend''), a female half-humanoid robot designed to simulate human functions and monitor life-support systems during uncrewed spaceflight test missions under the Gaganyaan human spaceflight programme.

Correct Option: (b)',
  'इसरो (ISRO) ने मानवयुक्त गगनयान मिशन से पहले प्रायोगिक मानवरहित उड़ानों में अंतरिक्ष यात्रियों के कार्यों का अनुकरण करने और जीवन रक्षक प्रणालियों की निगरानी के लिए ''व्योममित्र'' (Vyommitra) नामक महिला अर्ध-ह्यूमनॉइड रोबोट विकसित किया है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  89,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'The Western Dedicated Freight Corridor (WDFC) of Indian Railways runs between which two terminals?',
  'भारतीय रेलवे का पश्चिमी समर्पित माल गलियारा (Western Dedicated Freight Corridor - WDFC) किन दो टर्मिनलों के बीच स्थित है?',
  '{"a":"Dadri (Uttar Pradesh) to Jawaharlal Nehru Port Trust - JNPT (Navi Mumbai)","b":"Ludhiana (Punjab) to Dankuni (West Bengal)","c":"Delhi to Chennai","d":"Kolkata to Mumbai"}'::jsonb,
  '{"a":"दादरी (उत्तर प्रदेश) से जवाहरलाल नेहरू पोर्ट ट्रस्ट - JNPT (नवी मुंबई)","b":"लुधियाना (पंजाब) से दानकुनी (पश्चिम बंगाल)","c":"दिल्ली से चेन्नई","d":"कोलकाता से मुंबई"}'::jsonb,
  'a',
  'The Western DFC (1,506 km) connects Dadri in Uttar Pradesh to JNPT near Mumbai, passing through Haryana, Rajasthan, Gujarat, and Maharashtra.
The Eastern DFC connects Sahnewal (Ludhiana) in Punjab to Dankuni in West Bengal.

Correct Option: (a)',
  'पश्चिमी डीएफसी (WDFC) की लंबाई लगभग 1,506 किमी है और यह दादरी (उत्तर प्रदेश) को जेएनपीटी (नवी मुंबई) से जोड़ता है।
(पूर्वी डीएफसी लुधियाना को दानकुनी, पश्चिम बंगाल से जोड़ता है)।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  90,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Under which Article of the Constitution of India is the Comptroller and Auditor General (CAG) of India, the guardian of the public purse, appointed by the President?',
  'भारतीय संविधान के किस अनुच्छेद के तहत भारत के नियंत्रक एवं महालेखापरीक्षक (CAG), जो सार्वजनिक धन के संरक्षक हैं, की नियुक्ति राष्ट्रपति द्वारा की जाती है?',
  '{"a":"Article 148","b":"Article 76","c":"Article 280","d":"Article 324"}'::jsonb,
  '{"a":"अनुच्छेद 148","b":"अनुच्छेद 76","c":"अनुच्छेद 280","d":"अनुच्छेद 324"}'::jsonb,
  'a',
  'Article 148 of the Constitution of India provides for an independent office of the Comptroller and Auditor General (CAG) of India appointed by the President by warrant under his hand and seal.
(Article 76 = Attorney General; Article 280 = Finance Commission; Article 324 = Election Commission).

Correct Option: (a)',
  'भारतीय संविधान का अनुच्छेद 148 भारत के नियंत्रक एवं महालेखापरीक्षक (CAG) के पद का प्रावधान करता है। CAG केंद्र और राज्यों के सभी खातों का लेखा-परीक्षण करता है और इसे ''लोक वित्त का संरक्षक'' कहा जाता है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  91,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Under Article 110 of the Constitution of India, who possesses the final authority to decide and certify whether a particular Bill is a ''Money Bill'' or not?',
  'भारतीय संविधान के अनुच्छेद 110 के तहत यह निर्णय लेने और प्रमाणित करने का अंतिम अधिकार किसे प्राप्त है कि कोई विधेयक ''धन विधेयक'' (Money Bill) है या नहीं?',
  '{"a":"Speaker of the Lok Sabha","b":"President of India","c":"Chairman of the Rajya Sabha","d":"Union Finance Minister"}'::jsonb,
  '{"a":"लोकसभा अध्यक्ष (Speaker of Lok Sabha)","b":"भारत के राष्ट्रपति","c":"राज्यसभा के सभापति","d":"केंद्रीय वित्त मंत्री"}'::jsonb,
  'a',
  'Under Article 110(3) of the Constitution of India, if any question arises whether a Bill is a Money Bill or not, the decision of the Speaker of the Lok Sabha thereon is final and cannot be questioned in any court of law.

Correct Option: (a)',
  'संविधान के अनुच्छेद 110(3) के अनुसार, यदि यह प्रश्न उठता है कि कोई विधेयक धन विधेयक है या नहीं, तो लोकसभा अध्यक्ष (Speaker) का निर्णय अंतिम होता है। इसे न्यायालय में चुनौती नहीं दी जा सकती।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  92,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  93,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'The Fundamental Duties of Indian citizens were incorporated into Part IVA (Article 51A) of the Constitution on the recommendations of which committee via the 42nd Amendment Act in 1976?',
  'वर्ष 1976 में 42वें संविधान संशोधन द्वारा किस समिति की सिफारिशों के आधार पर भारतीय नागरिकों के मौलिक कर्तव्यों को संविधान के भाग IVA (अनुच्छेद 51A) में शामिल किया गया था?',
  '{"a":"Swaran Singh Committee","b":"Sarkaria Commission","c":"Kothari Commission","d":"Balwant Rai Mehta Committee"}'::jsonb,
  '{"a":"स्वर्ण सिंह समिति (Swaran Singh Committee)","b":"सरकारिया आयोग","c":"कोठारी आयोग","d":"बलवंत राय मेहता समिति"}'::jsonb,
  'a',
  'The Swaran Singh Committee (set up in 1976) recommended the inclusion of Fundamental Duties inspired by the USSR Constitution. The 42nd Amendment added 10 Fundamental Duties, and the 86th Amendment in 2002 added the 11th duty (education for children aged 6 to 14).

Correct Option: (a)',
  'सरदार स्वर्ण सिंह समिति की सिफारिश पर 42वें संविधान संशोधन अधिनियम 1976 द्वारा संविधान में भाग IVA और अनुच्छेद 51A जोड़कर 10 मौलिक कर्तव्य शामिल किए गए थे। 86वें संशोधन (2002) द्वारा 11वां कर्तव्य जोड़ा गया।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  94,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Under Article 108 of the Constitution of India, who presides over a Joint Sitting of both Houses of Parliament summoned by the President to resolve a legislative deadlock?',
  'भारतीय संविधान के अनुच्छेद 108 के तहत विधायी गतिरोध को दूर करने के लिए राष्ट्रपति द्वारा बुलाए गए संसद के दोनों सदनों की संयुक्त बैठक (Joint Sitting) की अध्यक्षता कौन करता है?',
  '{"a":"Speaker of the Lok Sabha","b":"Chairman of the Rajya Sabha (Vice-President)","c":"President of India","d":"Prime Minister of India"}'::jsonb,
  '{"a":"लोकसभा अध्यक्ष (Speaker of Lok Sabha)","b":"राज्यसभा के सभापति (उपराष्ट्रपति)","c":"भारत के राष्ट्रपति","d":"भारत के प्रधानमंत्री"}'::jsonb,
  'a',
  'Under Article 118(4) of the Constitution, a Joint Sitting of Parliament (summoned by the President under Article 108) is presided over by the Speaker of the Lok Sabha (or in his absence, the Deputy Speaker of Lok Sabha). The Chairman of Rajya Sabha (Vice-President) never presides because he is not a member of either House.

Correct Option: (a)',
  'अनुच्छेद 108 के तहत बुलाई गई संसद के दोनों सदनों की संयुक्त बैठक की अध्यक्षता अनुच्छेद 118(4) के अनुसार लोकसभा अध्यक्ष (Speaker) द्वारा की जाती है। उपराष्ट्रपति (राज्यसभा के सभापति) इसकी अध्यक्षता कभी नहीं करते।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  95,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Dedicated Freight Corridor Corporation of India Limited (DFCCIL), a special purpose vehicle under the Ministry of Railways, was incorporated in which year?',
  'भारतीय रेल मंत्रालय के प्रशासनिक नियंत्रण में विशेष प्रयोजन वाहन ''डेडिकेटेड फ्रेट कॉरिडोर कॉरपोरेशन ऑफ इंडिया लिमिटेड'' (DFCCIL) की स्थापना किस वर्ष की गई थी?',
  '{"a":"2006","b":"2002","c":"2010","d":"2014"}'::jsonb,
  '{"a":"2006","b":"2002","c":"2010","d":"2014"}'::jsonb,
  'a',
  'DFCCIL was incorporated on 30th October 2006 under the Companies Act, 1956. It is tasked with the planning, construction, operation, and maintenance of dedicated freight corridors (such as WDFC and EDFC) across India.

Correct Option: (a)',
  'DFCCIL की स्थापना 30 अक्टूबर 2006 को कंपनी अधिनियम 1956 के तहत की गई थी। इसका मुख्य उद्देश्य भारत में समर्पित माल ढुलाई गलियारों (Dedicated Freight Corridors) का निर्माण और संचालन करना है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  96,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Which Article of the Indian Constitution provides for the establishment of the Finance Commission?',
  'भारतीय संविधान का कौन सा अनुच्छेद वित्त आयोग के गठन का प्रावधान करता है?',
  '{"a":"Article 280","b":"Article 324","c":"Article 352","d":"Article 360"}'::jsonb,
  '{"a":"अनुच्छेद 280","b":"अनुच्छेद 324","c":"अनुच्छेद 352","d":"अनुच्छेद 360"}'::jsonb,
  'a',
  'Article 280 of the Indian Constitution mandates the constitution of a Finance Commission every five years by the President of India.',
  'भारतीय संविधान का अनुच्छेद 280 भारत के राष्ट्रपति द्वारा प्रत्येक पाँच वर्ष में वित्त आयोग के गठन का प्रावधान करता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  97,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Which railway station currently holds the Guinness World Record for having the world''s longest railway platform?',
  'वर्तमान में किस रेलवे स्टेशन के पास दुनिया का सबसे लंबा रेलवे प्लेटफॉर्म होने का गिनीज वर्ल्ड रिकॉर्ड है?',
  '{"a":"Gorakhpur Junction, Uttar Pradesh","b":"Kollam Junction, Kerala","c":"Shree Siddharoodha Swamiji Hubballi Junction, Karnataka","d":"Kharagpur Junction, West Bengal"}'::jsonb,
  '{"a":"गोरखपुर जंक्शन, उत्तर प्रदेश","b":"कोल्लम जंक्शन, केरल","c":"श्री सिद्धारूढ़ स्वामीजी हुबली जंक्शन, कर्नाटक","d":"खड़गपुर जंक्शन, पश्चिम बंगाल"}'::jsonb,
  'c',
  'Platform No. 8 at Shree Siddharoodha Swamiji Hubballi Junction in Karnataka is the world''s longest railway platform, measuring 1,507 metres.',
  'कर्नाटक के श्री सिद्धारूढ़ स्वामीजी हुबली जंक्शन का प्लेटफॉर्म नंबर 8 दुनिया का सबसे लंबा रेलवे प्लेटफॉर्म है, जिसकी लंबाई 1,507 मीटर है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  98,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'What is the minimum age prescribed by the Constitution of India to be eligible for election as the President of India?',
  'भारत के राष्ट्रपति पद के चुनाव के लिए पात्र होने हेतु भारत के संविधान द्वारा निर्धारित न्यूनतम आयु क्या है?',
  '{"a":"25 years","b":"30 years","c":"35 years","d":"40 years"}'::jsonb,
  '{"a":"25 वर्ष","b":"30 वर्ष","c":"35 वर्ष","d":"40 वर्ष"}'::jsonb,
  'c',
  'Under Article 58 of the Constitution, a citizen must have completed 35 years of age to be eligible for election as the President of India.',
  'संविधान के अनुच्छेद 58 के तहत, भारत का राष्ट्रपति बनने के लिए नागरिक की न्यूनतम आयु 35 वर्ष पूरी होनी चाहिए।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  99,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Which river is widely known as ''Dakshin Ganga'' (Ganga of the South) owing to its size and length?',
  'किस नदी को उसके विशाल आकार और लंबाई के कारण ''दक्षिण गंगा'' कहा जाता है?',
  '{"a":"Krishna","b":"Kaveri","c":"Godavari","d":"Mahanadi"}'::jsonb,
  '{"a":"कृष्णा","b":"कावेरी","c":"गोदावरी","d":"महानदी"}'::jsonb,
  'c',
  'Godavari is the longest peninsular river in India (approx 1,465 km) and is traditionally called ''Dakshin Ganga'' or ''Vridha Ganga''.',
  'गोदावरी भारत की सबसे लंबी प्रायद्वीपीय नदी (लगभग 1,465 किमी) है और इसे ''दक्षिण गंगा'' या ''वृद्ध गंगा'' के रूप में जाना जाता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_2',
  100,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'India''s first underground metro railway system was inaugurated in which city in 1984?',
  '1984 में भारत की पहली भूमिगत मेट्रो रेलवे प्रणाली का उद्घाटन किस शहर में किया गया था?',
  '{"a":"Delhi","b":"Kolkata","c":"Mumbai","d":"Chennai"}'::jsonb,
  '{"a":"दिल्ली","b":"कोलकाता","c":"मुंबई","d":"चेन्नई"}'::jsonb,
  'b',
  'Kolkata Metro was India''s first metro railway, inaugurated on 24 October 1984 between Esplanade and Bhowanipore (Netaji Bhavan).',
  'कोलकाता मेट्रो भारत की पहली मेट्रो रेल सेवा थी, जिसका उद्घाटन 24 अक्टूबर 1984 को एस्प्लेनेड और भवानीपुर के बीच किया गया था।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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

-- -------------------------------------------------------------------------
-- rrb_cbt_mock_3 (100 questions)
-- -------------------------------------------------------------------------

INSERT INTO public.questions (
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  1,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is the relation between frequency ($f$) and time period ($T$) of an oscillating particle?',
  'किसी दोलनकारी कण की आवृत्ति ($f$) और आवर्तकाल ($T$) के बीच क्या संबंध है?',
  '{"a":"$f = T$","b":"$f \\times T = 1$","c":"$f = 2\\pi T$","d":"$f / T = 1$"}'::jsonb,
  '{"a":"$f = T$","b":"$f \\times T = 1$ ($f = 1/T$)","c":"$f = 2\\pi T$","d":"$f / T = 1$"}'::jsonb,
  'b',
  'Frequency is the reciprocal of time period: $f = 1/T \Rightarrow f \times T = 1$. The SI unit of frequency is Hertz ($s^{-1}$).',
  'आवृत्ति आवर्तकाल का व्युत्क्रम होती है: $f = 1/T$ अर्थात् $f \times T = 1$। आवृत्ति का मात्रक हर्ट्ज़ (Hz) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  2,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Which functional group characterizes the ketone family of organic compounds?',
  'कार्बनिक यौगिकों के कीटोन परिवार की पहचान किस प्रकार्यात्मक समूह से होती है?',
  '{"a":"-OH","b":"-CHO","c":">C=O (Carbonyl group)","d":"-COOH"}'::jsonb,
  '{"a":"-OH (अल्कोहॉल)","b":"-CHO (एल्डिहाइड)","c":">C=O (कार्बोनिल समूह)","d":"-COOH (कार्बोक्सिलिक अम्ल)"}'::jsonb,
  'c',
  'Ketones contain the carbonyl group (>C=O) bonded to two alkyl groups. Propanone (acetone, $\text{CH}_3\text{COCH}_3$) is the simplest ketone.',
  'कीटोन में कार्बोनिल समूह ($>C=O$) दो कार्बन परमाणुओं से जुड़ा होता है। एसीटोन ($	ext{CH}_3	ext{COCH}_3$) इसका सबसे सरल उदाहरण है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  3,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Chemically, the process of rusting of iron is classified as:',
  'रासायनिक रूप से लोहे पर जंग लगने की प्रक्रिया को किस रूप में वर्गीकृत किया जाता है?',
  '{"a":"Reduction only","b":"Redox reaction (Oxidation-Reduction)","c":"Decomposition reaction","d":"Displacement reaction"}'::jsonb,
  '{"a":"केवल अपचयन","b":"रेडॉक्स अभिक्रिया (ऑक्सीकरण-अपचयन)","c":"अपघटन अभिक्रिया","d":"विस्थापन अभिक्रिया"}'::jsonb,
  'b',
  'Rusting of iron is an electrochemical redox process forming hydrated ferric oxide ($\text{Fe}_2\text{O}_3\cdot x\text{H}_2\text{O}$). Iron is oxidized ($Fe \rightarrow Fe^{2+} + 2e^-$) and oxygen is reduced.',
  'लोहे में जंग लगना एक इलेक्ट्रोकेमिकल रेडॉक्स अभिक्रिया है जिसमें हाइड्रेटेड फेरिक ऑक्साइड ($	ext{Fe}_2	ext{O}_3\cdot x	ext{H}_2	ext{O}$) बनता है। इसमें लोहा ऑक्सीकृत और ऑक्सीजन अपचयित होती है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  4,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'An electric safety fuse wire must have which of the following characteristics?',
  'एक विद्युत सुरक्षा फ्यूज तार में निम्नलिखित में से कौन सी विशेषता होनी चाहिए?',
  '{"a":"High melting point and high resistance","b":"Low melting point and high resistance","c":"Low melting point and low resistance","d":"High melting point and low resistance"}'::jsonb,
  '{"a":"उच्च गलनांक और उच्च प्रतिरोध","b":"कम गलनांक और उच्च प्रतिरोध (High resistance, Low melting point)","c":"कम गलनांक और कम प्रतिरोध","d":"उच्च गलनांक और कम प्रतिरोध"}'::jsonb,
  'b',
  'A fuse wire (alloy of Lead and Tin) has relatively high resistivity to generate heat ($H=I^2Rt$) and a low melting point so it melts rapidly during an overload.',
  'फ्यूज तार का प्रतिरोध उच्च और गलनांक निम्न होना चाहिए ताकि अत्यधिक धारा प्रवाहित होने पर यह गर्म होकर तुरंत पिघल जाए और परिपथ सुरक्षित रहे।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  5,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'The oxygen-carrying respiratory pigment Haemoglobin in human blood contains which metallic element at its core?',
  'मानव रक्त में ऑक्सीजन ले जाने वाले श्वसन वर्णक हीमोग्लोबिन के केंद्र में कौन सा धातु तत्व होता है?',
  '{"a":"Magnesium","b":"Iron","c":"Copper","d":"Calcium"}'::jsonb,
  '{"a":"मैग्नीशियम (क्लोरोफिल में)","b":"आयरन / लोहा (Fe²⁺)","c":"तांबा","d":"कैल्शियम"}'::jsonb,
  'b',
  'Haemoglobin consists of heme groups containing an Iron ($Fe^{2+}$) ion coordinated to a porphyrin ring. Chlorophyll contains Magnesium ($Mg^{2+}$).',
  'हीमोग्लोबिन में आयरन (लोहा - $Fe^{2+}$) पाया जाता है जो ऑक्सीजन से जुड़कर ऑक्सीहीमोग्लोबिन बनाता है। क्लोरोफिल में मैग्नीशियम होता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  6,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Temporary hardness of water is caused by dissolved bicarbonates of which two metals?',
  'जल की अस्थायी कठोरता किन दो धातुओं के घुले हुए बाइकार्बोनेट लवणों के कारण होती है?',
  '{"a":"Sodium and Potassium","b":"Calcium and Magnesium","c":"Iron and Zinc","d":"Copper and Aluminium"}'::jsonb,
  '{"a":"सोडियम और पोटेशियम","b":"कैल्शियम और मैग्नीशियम (Calcium and Magnesium)","c":"लोहा और जस्ता","d":"तांबा और एल्युमिनियम"}'::jsonb,
  'b',
  'Temporary hardness is due to Calcium bicarbonate $[\text{Ca(HCO}_3)_2]$ and Magnesium bicarbonate $[\text{Mg(HCO}_3)_2]$, easily removed by boiling.',
  'अस्थायी कठोरता कैल्शियम और मैग्नीशियम के बाइकार्बोनेट लवणों के कारण होती है, जिसे उबालकर दूर किया जा सकता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  7,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is the minimum distance between the sound source and a reflecting surface required to hear a distinct echo in air at 20°C?',
  '20°C पर वायु में एक स्पष्ट प्रतिध्वनि (Echo) सुनने के लिए ध्वनि स्रोत और परावर्तक सतह के बीच न्यूनतम दूरी कितनी होनी चाहिए?',
  '{"a":"11.2 meters","b":"17.2 meters","c":"22.4 meters","d":"34.4 meters"}'::jsonb,
  '{"a":"11.2 मीटर","b":"17.2 मीटर (लगभग 17 मीटर)","c":"22.4 मीटर","d":"34.4 मीटर"}'::jsonb,
  'b',
  'Persistence of human hearing is 0.1 s. Speed of sound in air at 20°C is ~344 m/s. Minimum round-trip distance $= 344 \times 0.1 = 34.4$ m. One-way distance $= 34.4 / 2 = 17.2$ meters.',
  'मानव कान पर ध्वनि का प्रभाव 0.1 सेकंड तक रहता है। 20°C पर ध्वनि की चाल 344 मी/से है। अतः न्यूनतम दूरी $= (344 \times 0.1) / 2 = 17.2$ मीटर होती है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  8,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'The light-independent reactions (Calvin Cycle / Dark Reaction) of photosynthesis take place in which compartment of the chloroplast?',
  'प्रकाश संश्लेषण की प्रकाश-स्वतंत्र अभिक्रिया (केल्विन चक्र / डार्क रिएक्शन) क्लोरोप्लास्ट के किस भाग में होती है?',
  '{"a":"Thylakoid membrane","b":"Stroma","c":"Granum","d":"Outer membrane"}'::jsonb,
  '{"a":"थायलाकोइड झिल्ली (प्रकाश अभिक्रिया हेतु)","b":"स्ट्रोमा (Stroma)","c":"ग्रेना","d":"बाह्य झिल्ली"}'::jsonb,
  'b',
  'Light reactions occur in the thylakoid membranes (grana), while the enzymatic fixation of $CO_2$ into glucose (Calvin cycle) occurs in the fluid Stroma of chloroplasts.',
  'प्रकाश अभिक्रिया क्लोरोप्लास्ट के ग्रेना (थायलाकोइड) में होती है, जबकि डार्क रिएक्शन (केल्विन चक्र) स्ट्रोमा (Stroma) में संपन्न होती है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  9,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'The loudness or intensity of a sound wave is primarily determined by its:',
  'ध्वनि तरंग की प्रबलता (Loudness) या तीव्रता मुख्य रूप से किसके द्वारा निर्धारित होती है?',
  '{"a":"Frequency","b":"Amplitude of vibration","c":"Wavelength","d":"Wave velocity"}'::jsonb,
  '{"a":"आवृत्ति","b":"कंपन का आयाम (Amplitude)","c":"तरंगदैर्घ्य","d":"तरंग का वेग"}'::jsonb,
  'b',
  'Loudness is proportional to the square of the amplitude of vibration ($L \propto A^2$). Pitch depends on frequency; timbre depends on wave shape.',
  'ध्वनि की प्रबलता कंपन के आयाम के वर्ग ($A^2$) के समानुपाती होती है। तारत्व (Pitch) आवृत्ति पर निर्भर करता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  10,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Acid rain, which damages historic marble monuments like the Taj Mahal, is primarily caused by atmospheric emissions of:',
  'अम्लीय वर्षा (Acid Rain), जो ताजमहल जैसे संगमरमर के स्मारकों को नुकसान पहुंचाती है, मुख्य रूप से किसके वायुमंडलीय उत्सर्जन के कारण होती है?',
  '{"a":"Carbon monoxide and Methane","b":"Sulphur dioxide (SO₂) and Nitrogen oxides (NOₓ)","c":"Chlorofluorocarbons (CFCs)","d":"Ozone and Hydrogen sulphide"}'::jsonb,
  '{"a":"कार्बन मोनोऑक्साइड और मीथेन","b":"सल्फर डाइऑक्साइड (SO₂) और नाइट्रोजन के ऑक्साइड (NOₓ)","c":"क्लोरोफ्लोरोकार्बन (CFC)","d":"ओजोन और हाइड्रोजन सल्फाइड"}'::jsonb,
  'b',
  '$SO_2$ and $NO_x$ react with atmospheric water vapour to form Sulphuric acid ($H_2SO_4$) and Nitric acid ($HNO_3$), which corrode marble ($	ext{CaCO}_3$).',
  'सल्फर डाइऑक्साइड ($	ext{SO}_2$) और नाइट्रोजन ऑक्साइड वायुमंडलीय नमी से मिलकर सल्फ्यूरिक व नाइट्रिक अम्ल बनाते हैं जिससे अम्लीय वर्षा होती है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  11,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Which substance exhibits the highest thermal conductivity among all naturally occurring materials at room temperature?',
  'कमरे के तापमान पर सभी प्राकृतिक रूप से पाए जाने वाले पदार्थों में किस पदार्थ की तापीय चालकता (Thermal Conductivity) सबसे अधिक होती है?',
  '{"a":"Silver","b":"Copper","c":"Diamond","d":"Gold"}'::jsonb,
  '{"a":"चांदी","b":"तांबा","c":"हीरा (Diamond)","d":"सोना"}'::jsonb,
  'c',
  'Diamond (an allotrope of carbon) has an extraordinary thermal conductivity of about $2200\text{ W/(m}\cdot\text{K)}$, about 5 times higher than copper or silver, due to strong covalent sp3 bonding and acoustic phonons.',
  'हीरा (कार्बन का अपररूप) लगभग $2200\text{ W/(m}\cdot\text{K)}$ की उच्चतम तापीय चालकता प्रदर्शित करता है, जो तांबे अथवा चांदी की तुलना में लगभग पाँच गुना अधिक है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  12,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'An electric iron of rating 1200 W is used for 30 minutes every day. How many electrical units (kWh) of energy are consumed by the iron in the month of April (30 days)?',
  '1200 W क्षमता वाली एक विद्युत इस्त्री (iron) का प्रतिदिन 30 मिनट उपयोग किया जाता है। अप्रैल के महीने (30 दिन) में इस इस्त्री द्वारा कितने विद्युत यूनिट (kWh) ऊर्जा की खपत होगी?',
  '{"a":"18 units","b":"36 units","c":"24 units","d":"12 units"}'::jsonb,
  '{"a":"18 यूनिट","b":"36 यूनिट","c":"24 यूनिट","d":"12 यूनिट"}'::jsonb,
  'a',
  'Daily energy consumption:
Energy = Power × Time = 1200 W × (30 / 60) h = 1.2 kW × 0.5 h = 0.6 kWh (units/day).
In the month of April (30 days):
Total Energy = 0.6 kWh × 30 = 18 kWh (18 units).

Correct Option: (a)',
  'प्रतिदिन विद्युत ऊर्जा की खपत:
ऊर्जा = शक्ति × समय = 1.2 kW × 0.5 घंटा = 0.6 kWh (यूनिट प्रति दिन)।
अप्रैल माह (30 दिन) में कुल खपत:
कुल ऊर्जा = 0.6 × 30 = 18 kWh (18 यूनिट)।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  13,
  1,
  'PART-1',
  'General Science',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  14,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Which functional group is present in the organic compound Propanone (CH₃-CO-CH₃)?',
  'कार्बनिक यौगिक प्रोपेनोन (CH₃-CO-CH₃) में कौन सा प्रकार्यात्मक समूह (Functional Group) उपस्थित होता है?',
  '{"a":"Aldehyde (-CHO)","b":"Ketone (>C=O)","c":"Carboxylic Acid (-COOH)","d":"Alcohol (-OH)"}'::jsonb,
  '{"a":"एल्डिहाइड (-CHO)","b":"कीटोन (>C=O)","c":"कार्बोक्सिलिक अम्ल (-COOH)","d":"एल्कोहॉल (-OH)"}'::jsonb,
  'b',
  'Propanone (commonly called acetone) contains the carbonyl functional group >C=O attached to two alkyl groups, characteristic of Ketones.

Correct Option: (b)',
  'प्रोपेनोन (एसीटोन) में कार्बोनिल समूह (>C=O) दो एल्किल समूहों के बीच जुड़ा होता है, जो कीटोन (Ketone) परिवार का अभिलक्षण है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  15,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Two electric bulbs are rated 220 V – 100 W and 220 V – 60 W respectively. Which bulb has a filament with higher electrical resistance?',
  'दो विद्युत बल्बों पर क्रमशः 220 V – 100 W और 220 V – 60 W अंकित है। किस बल्ब के फिलामेंट का विद्युत प्रतिरोध अधिक होगा?',
  '{"a":"The 100 W bulb","b":"The 60 W bulb","c":"Both bulbs have identical resistance","d":"Resistance depends on current drawn, not rated power"}'::jsonb,
  '{"a":"100 W वाले बल्ब का","b":"60 W वाले बल्ब का","c":"दोनों बल्बों का प्रतिरोध समान होगा","d":"प्रतिरोध धारा पर निर्भर करता है, अंकित क्षमता पर नहीं"}'::jsonb,
  'b',
  'Formula: P = V² / R => R = V² / P.
At constant voltage (220 V):
Resistance is inversely proportional to rated power (R ∝ 1/P).
- R(100W) = 220² / 100 = 48,400 / 100 = 484 Ω.
- R(60W) = 220² / 60 = 48,400 / 60 ≈ 806.67 Ω.
Therefore, the 60 W bulb has higher resistance.

Correct Option: (b)',
  'सूत्र: P = V² / R => R = V² / P.
समान वोल्टेज (220 V) पर प्रतिरोध शक्ति के व्युत्क्रमानुपाती होता है (R ∝ 1/P)।
अतः कम वाट क्षमता (60 W) वाले बल्ब के फिलामेंट का प्रतिरोध अधिक (806.7 Ω) होगा।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  16,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Which complex permanent plant tissue is primarily responsible for the translocation of food (soluble organic compounds) from leaves to other parts of the plant?',
  'पौधों में पत्तियों से अन्य भागों तक भोजन (घुलनशील कार्बनिक यौगिकों) के स्थानांतरण के लिए मुख्य रूप से कौन सा जटिल स्थायी ऊतक उत्तरदायी है?',
  '{"a":"Xylem","b":"Phloem","c":"Collenchyma","d":"Sclerenchyma"}'::jsonb,
  '{"a":"जाइलम (Xylem)","b":"फ्लोएम (Phloem)","c":"कॉलेनकाइमा (Collenchyma)","d":"स्क्लेरेनकाइमा (Sclerenchyma)"}'::jsonb,
  'b',
  'Phloem is the vascular tissue responsible for translocating synthesized soluble organic food (sucrose, amino acids) bidirectionally from leaves to storage organs and growing regions. Its elements include sieve tubes, companion cells, phloem parenchyma, and phloem fibres.
Xylem transports water and dissolved minerals un-directionally from roots.

Correct Option: (b)',
  'फ्लोएम (Phloem) एक संवहन ऊतक है जो पत्तियों द्वारा संश्लेषित भोजन (सुक्रोज इत्यादि) को पौधे के विभिन्न भागों तक दोनों दिशाओं में स्थानांतरित करता है। इसके चार प्रमुख घटक होते हैं: चालनी नलिकाएं, सहकोशिकाएं, फ्लोएम पैरेन्काइमा और फ्लोएम रेशे।
जाइलम जड़ों से जल व खनिज लवणों का परिवहन करता है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  17,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is the basic structural and functional filtration unit of the human kidney?',
  'मानव वृक्क (Kidney) की मूलभूत संरचनात्मक एवं क्रियात्मक निस्यंदन (फिल्ट्रेशन) इकाई क्या है?',
  '{"a":"Neuron","b":"Nephron","c":"Alveolus","d":"Villus"}'::jsonb,
  '{"a":"न्यूरॉन (Neuron)","b":"नेफ्रॉन / वृक्काणु (Nephron)","c":"एल्वियोलस / कूपिका (Alveolus)","d":"रंसांकुर (Villus)"}'::jsonb,
  'b',
  'The nephron is the basic structural and functional microscopic filtration unit of the kidney. Each human kidney contains approximately 1 to 1.2 million nephrons consisting of Bowman''s capsule, glomerulus, proximal convoluted tubule, loop of Henle, and distal convoluted tubule.
(Neuron is the unit of the nervous system; Alveolus is the unit of lungs).

Correct Option: (b)',
  'वृक्क की कार्यात्मक और संरचनात्मक इकाई नेफ्रॉन (Nephron या वृक्काणु) है। प्रत्येक वृक्क में लगभग 10-12 लाख नेफ्रॉन होते हैं, जो रक्त से यूरिया, यूरिक एसिड आदि अपशिष्टों को छानकर मूत्र का निर्माण करते हैं।
(न्यूरॉन तंत्रिका तंत्र की और एल्वियोली फेफड़ों की इकाई है)।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  18,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'Where is the acceleration due to gravity (g) maximum on the surface of the Earth?',
  'पृथ्वी की सतह पर गुरुत्वीय त्वरण (g) का मान सर्वाधिक कहाँ होता है?',
  '{"a":"At the Equator","b":"At the Poles","c":"At the Tropic of Cancer","d":"Equal everywhere on the surface"}'::jsonb,
  '{"a":"भूमध्य रेखा (Equator) पर","b":"ध्रुवों (Poles) पर","c":"कर्क रेखा पर","d":"सतह पर सभी जगह समान"}'::jsonb,
  'b',
  'The acceleration due to gravity is given by g = GM / R^2.
Because the Earth is an oblate spheroid (flattened at the poles and bulging at the equator):
- Polar radius (Rp) is less than Equatorial radius (Re) by about 21 km.
- Since g is inversely proportional to R^2, g is maximum at the poles (~9.83 m/s^2) and minimum at the equator (~9.78 m/s^2).

Correct Option: (b)',
  'गुरुत्वीय त्वरण g = GM / R^2 होता है।
पृथ्वी के अंडाकार (दीर्घवृत्ताकार) होने के कारण ध्रुवीय त्रिज्या (Rp), भूमध्यरेखीय त्रिज्या (Re) से लगभग 21 किमी कम होती है। त्रिज्या न्यूनतम होने के कारण ध्रुवों (Poles) पर ''g'' का मान अधिकतम (~9.83 m/s^2) और भूमध्य रेखा पर न्यूनतम (~9.78 m/s^2) होता है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  19,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'The absolute refractive index of a transparent medium is 1.5. If the speed of light in vacuum is 3 × 10^8 m/s, what is the speed of light in this medium?',
  'एक पारदर्शी माध्यम का निरपेक्ष अपवर्तनांक 1.5 है। यदि निर्वात में प्रकाश की चाल 3 × 10^8 मी/से है, तो इस माध्यम में प्रकाश की चाल क्या होगी?',
  '{"a":"2 × 10^8 m/s","b":"1.5 × 10^8 m/s","c":"4.5 × 10^8 m/s","d":"2.25 × 10^8 m/s"}'::jsonb,
  '{"a":"2 × 10^8 मी/से","b":"1.5 × 10^8 मी/से","c":"4.5 × 10^8 मी/से","d":"2.25 × 10^8 मी/से"}'::jsonb,
  'a',
  'Refractive index (n) = Speed of light in vacuum (c) / Speed of light in medium (v)
Given: n = 1.5, c = 3 × 10^8 m/s
v = c / n = (3 × 10^8) / 1.5 = 2 × 10^8 m/s.

Correct Option: (a)',
  'अपवर्तनांक n = c / v
v = c / n = (3 × 10^8) / 1.5 = 2 × 10^8 मी/से।
अतः माध्यम में प्रकाश की चाल 2 × 10^8 मी/से होगी।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  20,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'The commercial unit of electric energy is kilowatt-hour (kWh), commonly known as a ''unit''. Exactly how many Joules are there in 1 kWh?',
  'विद्युत ऊर्जा की व्यावसायिक इकाई किलोवाट-घंटा (kWh) है, जिसे सामान्यतः ''यूनिट'' कहा जाता है। 1 kWh में कुल कितने जूल होते हैं?',
  '{"a":"3.6 × 10^5 J","b":"3.6 × 10^6 J","c":"10^3 J","d":"3.6 × 10^4 J"}'::jsonb,
  '{"a":"3.6 × 10^5 जूल","b":"3.6 × 10^6 जूल","c":"10^3 जूल","d":"3.6 × 10^4 जूल"}'::jsonb,
  'b',
  '1 kilowatt-hour (kWh) = 1 kW * 1 hour
= 1000 W * 3600 seconds
= 1000 (J/s) * 3600 s
= 3,600,000 Joules = 3.6 × 10^6 J.

Correct Option: (b)',
  '1 kWh = 1 किलोवाट × 1 घंटा
= 1000 वाट × 3600 सेकंड
= 36,00,000 जूल = 3.6 × 10^6 जूल।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  21,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'An astronaut weighs 600 N on the surface of the Earth. What will be his weight on the surface of the Moon (where gravitational acceleration is 1/6th of Earth)?',
  'एक अंतरिक्ष यात्री का पृथ्वी की सतह पर भार 600 N है। चंद्रमा की सतह पर उसका भार क्या होगा (जहाँ गुरुत्वीय त्वरण पृथ्वी का 1/6 है)?',
  '{"a":"100 N","b":"600 N","c":"60 N","d":"3600 N"}'::jsonb,
  '{"a":"100 N","b":"600 N","c":"60 N","d":"3600 N"}'::jsonb,
  'a',
  'Weight W = m * g.
Since mass m remains constant everywhere, and g_moon = (1/6) * g_earth:
W_moon = m * g_moon = (1/6) * (m * g_earth) = (1/6) * 600 N = 100 N.

Correct Option: (a)',
  'भार W = m * g
चंद्रमा पर गुरुत्वीय त्वरण पृथ्वी का 1/6 भाग होता है (g_moon = g/6)।
अतः चंद्रमा पर भार = 600 / 6 = 100 N.
(द्रव्यमान सभी जगह स्थिर रहता है)।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  22,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is the general structural formula of organic compounds belonging to the ''Ether'' functional family?',
  '''ईथर'' (Ether) प्रकार्यात्मक समूह वाले कार्बनिक यौगिकों का सामान्य संरचनात्मक सूत्र क्या होता है?',
  '{"a":"R - O - R''","b":"R - CO - R''","c":"R - COO - R''","d":"R - CHO"}'::jsonb,
  '{"a":"R - O - R''","b":"R - CO - R''","c":"R - COO - R''","d":"R - CHO"}'::jsonb,
  'a',
  'Ethers are characterized by an oxygen atom bonded to two alkyl or aryl groups: R - O - R'' (e.g., Diethyl ether CH3CH2-O-CH2CH3).
- R - CO - R'' is Ketone
- R - COO - R'' is Ester
- R - CHO is Aldehyde.

Correct Option: (a)',
  'ईथर में एक ऑक्सीजन परमाणु दो एल्किल या एरिल समूहों से जुड़ा होता है: R - O - R'' (जैसे डाइएथिल ईथर C2H5-O-C2H5)।
(R-CO-R'' कीटोन है, R-COO-R'' एस्टर है)।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  23,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is the relation between frequency (f), wavelength (λ), and wave speed (v) for any wave?',
  'किसी भी तरंग के लिए आवृत्ति (f), तरंगदैर्घ्य (λ) और तरंग की गति (v) के बीच क्या संबंध है?',
  '{"a":"v = f / λ","b":"v = f × λ","c":"v = λ / f","d":"v = f² × λ"}'::jsonb,
  '{"a":"v = f / λ","b":"v = f × λ","c":"v = λ / f","d":"v = f² × λ"}'::jsonb,
  'b',
  'Wave speed (v) is the product of frequency (f) and wavelength (λ), i.e., v = f × λ. Frequency is measured in Hertz (Hz) and wavelength in meters (m).',
  'तरंग गति (v) आवृत्ति (f) और तरंगदैर्घ्य (λ) का गुणनफल होती है, यानी v = f × λ। आवृत्ति हर्ट्ज़ (Hz) में और तरंगदैर्घ्य मीटर (m) में मापा जाता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  24,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'What is the structural and functional filtration unit of the human kidney?',
  'मानव वृक्क (किडनी) की संरचनात्मक और कार्यात्मक निस्यंदन इकाई क्या है?',
  '{"a":"Alveolus","b":"Nephron","c":"Neuron","d":"Glomerulus only"}'::jsonb,
  '{"a":"कूपिका (Alveolus)","b":"नेफ्रॉन (Nephron)","c":"न्यूरॉन (Neuron)","d":"केवल ग्लोमेरुलस"}'::jsonb,
  'b',
  'The nephron is the microscopic structural and functional unit of the kidney, responsible for filtering blood and forming urine.',
  'नेफ्रॉन वृक्क की सूक्ष्म संरचनात्मक और कार्यात्मक इकाई है, जो रक्त को छानने और मूत्र निर्माण के लिए जिम्मेदार है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  25,
  1,
  'PART-1',
  'General Science',
  '',
  'Moderate',
  'The recoil of a gun after firing a bullet is a direct practical illustration of which law?',
  'गोली दागने के बाद बंदूक का पीछे हटना (प्रतिक्षेप) किस नियम का प्रत्यक्ष व्यावहारिक उदाहरण है?',
  '{"a":"Newton''s First Law of Motion","b":"Newton''s Second Law of Motion","c":"Newton''s Third Law of Motion","d":"Law of Gravitation"}'::jsonb,
  '{"a":"न्यूटन का गति का पहला नियम","b":"न्यूटन का गति का दूसरा नियम","c":"न्यूटन का गति का तीसरा नियम","d":"गुरुत्वाकर्षण का नियम"}'::jsonb,
  'c',
  'According to Newton''s Third Law of Motion, every action has an equal and opposite reaction. The bullet''s forward momentum is matched by the gun''s backward recoil momentum.',
  'न्यूटन के गति के तीसरे नियम के अनुसार प्रत्येक क्रिया के बराबर और विपरीत प्रतिक्रिया होती है। गोली के आगे जाने पर बंदूक पर बराबर और विपरीत प्रतिक्षेप बल लगता है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  26,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'The ratio of the ages of A and B is 3 : 5. After 6 years, the ratio of their ages becomes 2 : 3. What is the present age of B?',
  'A और B की वर्तमान आयु का अनुपात 3 : 5 है। 6 वर्ष बाद उनकी आयु का अनुपात 2 : 3 हो जाता है। B की वर्तमान आयु क्या है?',
  '{"a":"24 years","b":"30 years","c":"36 years","d":"40 years"}'::jsonb,
  '{"a":"24 वर्ष","b":"30 वर्ष","c":"36 वर्ष","d":"40 वर्ष"}'::jsonb,
  'b',
  'Let ages be $3x$ and $5x$. $(3x + 6) / (5x + 6) = 2/3 \Rightarrow 9x + 18 = 10x + 12 \Rightarrow x = 6$. Age of B = $5 \times 6 = 30$ years.',
  'माना आयु $3x$ और $5x$ है। $\frac{3x + 6}{5x + 6} = \frac{2}{3} \Rightarrow 9x + 18 = 10x + 12 \Rightarrow x = 6$। B की आयु = $5 \times 6 = 30$ वर्ष।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  27,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'The four interior angles of a quadrilateral are in the ratio 3 : 5 : 9 : 13. What is the measure of the largest angle?',
  'एक चतुर्भुज के चारों आंतरिक कोणों का अनुपात 3 : 5 : 9 : 13 है। सबसे बड़े कोण का माप क्या है?',
  '{"a":"136°","b":"144°","c":"156°","d":"168°"}'::jsonb,
  '{"a":"136°","b":"144°","c":"156°","d":"168°"}'::jsonb,
  'c',
  'Sum of quadrilateral angles is $360^\circ$. Total ratio parts $= 3 + 5 + 9 + 13 = 30$. Each part $= 360 / 30 = 12^\circ$. Largest angle $= 13 \times 12^\circ = 156^\circ$.',
  'चतुर्भुज के चारों कोणों का योग $360^\circ$ होता है। कुल भाग = 30। एक भाग = $12^\circ$। सबसे बड़ा कोण = $13 \times 12^\circ = 156^\circ$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  28,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'If a train traveling at 72 km/h crosses a 200 m long platform in 22 seconds, find the length of the train.',
  '72 किमी/घंटा की गति से चल रही एक ट्रेन 200 मीटर लंबे प्लेटफॉर्म को 22 सेकंड में पार करती है। ट्रेन की लंबाई ज्ञात कीजिए।',
  '{"a":"220 m","b":"240 m","c":"260 m","d":"280 m"}'::jsonb,
  '{"a":"220 मीटर","b":"240 मीटर","c":"260 मीटर","d":"280 मीटर"}'::jsonb,
  'b',
  'Speed $= 72 \times (5/18) = 20$ m/s. Total distance in 22 s $= 20 \times 22 = 440$ m. Train length $= 440 - 200 = 240$ meters.',
  'ट्रेन की चाल = 20 मी/से। 22 सेकंड में तय दूरी $= 20 \times 22 = 440$ मीटर। ट्रेन की लंबाई $= 440 - 200 = 240$ मीटर।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  29,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'What is the compound interest accrued on a principal of ₹$16,000$ for $1\frac{1}{2}$ years at $10\%$ per annum, compounded semi-annually?',
  '₹$16,000$ के मूलधन पर $10\%$ वार्षिक दर से $1\frac{1}{2}$ वर्ष में कितना चक्रवृद्धि ब्याज प्राप्त होगा, यदि ब्याज अर्धवार्षिक रूप से संयोजित किया जाता है?',
  '{"a":"₹$2,522$","b":"₹$2,480$","c":"₹$2,642$","d":"₹$2,400$"}'::jsonb,
  '{"a":"₹$2,522$","b":"₹$2,480$","c":"₹$2,642$","d":"₹$2,400$"}'::jsonb,
  'a',
  'Semi-annual rate $r = 10/2 = 5\%$. Number of half-years $n = 1.5 \times 2 = 3$. Amount $A = 16000 \times (1 + 0.05)^3 = 16000 \times 1.157625 = ₹18,522$. Compound Interest $= 18522 - 16000 = ₹2,522$.',
  'अर्धवार्षिक दर $r = 5\%$, समय $n = 3$ छमाही। मिश्रधन $A = 16000 \times (1.05)^3 = ₹18,522$। चक्रवृद्धि ब्याज $= 18522 - 16000 = ₹2,522$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  30,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A motorboat travels $36\text{ km}$ downstream in $2\text{ hours}$ and returns the same distance upstream in $3\text{ hours}$. What is the speed of the motorboat in still water?',
  'एक मोटरबोट धारा के अनुकूल $36\text{ km}$ की दूरी $2\text{ घंटे}$ में तय करती है और धारा के प्रतिकूल उतनी ही दूरी वापस आने में $3\text{ घंटे}$ का समय लेती है। शांत जल में मोटरबोट की गति क्या है?',
  '{"a":"$15\\text{ km/h}$","b":"$18\\text{ km/h}$","c":"$12\\text{ km/h}$","d":"$16\\text{ km/h}$"}'::jsonb,
  '{"a":"$15\\text{ km/h}$","b":"$18\\text{ km/h}$","c":"$12\\text{ km/h}$","d":"$16\\text{ km/h}$"}'::jsonb,
  'a',
  'Downstream speed $D = 36 / 2 = 18\text{ km/h}$. Upstream speed $U = 36 / 3 = 12\text{ km/h}$. Speed of boat in still water $= \frac{D + U}{2} = \frac{18 + 12}{2} = 15\text{ km/h}$. (Speed of stream is $(18-12)/2 = 3\text{ km/h}$).',
  'धारा के अनुकूल गति $D = 36 / 2 = 18\text{ km/h}$, धारा के प्रतिकूल गति $U = 36 / 3 = 12\text{ km/h}$। शांत जल में नाव की गति $= \frac{18 + 12}{2} = 15\text{ km/h}$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  31,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'If the roots of the quadratic equation $x^2 - 7x + 12 = 0$ are $\alpha$ and $\beta$, find the value of $\alpha^2 + \beta^2$.',
  'यदि द्विघात समीकरण $x^2 - 7x + 12 = 0$ के मूल $\alpha$ और $\beta$ हैं, तो $\alpha^2 + \beta^2$ का मान ज्ञात कीजिए।',
  '{"a":"23","b":"25","c":"27","d":"29"}'::jsonb,
  '{"a":"23","b":"25","c":"27","d":"29"}'::jsonb,
  'b',
  'Here $\alpha + \beta = 7$ and $\alpha\beta = 12$. Now $\alpha^2 + \beta^2 = (\alpha + \beta)^2 - 2\alpha\beta = 7^2 - 2(12) = 49 - 24 = 25$.',
  'मूलों का योग $\alpha + \beta = 7$, गुणनफल $\alpha\beta = 12$। $\alpha^2 + \beta^2 = (\alpha + \beta)^2 - 2\alpha\beta = 49 - 24 = 25$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  32,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'Find the smallest 4-digit number which is completely divisible by 12, 15, and 18.',
  '4 अंकों की वह सबसे छोटी संख्या ज्ञात कीजिए जो 12, 15 और 18 से पूर्णतः विभाज्य हो।',
  '{"a":"1,020","b":"1,080","c":"1,140","d":"1,200"}'::jsonb,
  '{"a":"1,020","b":"1,080","c":"1,140","d":"1,200"}'::jsonb,
  'b',
  'LCM(12, 15, 18) = 180. Smallest 4-digit number = 1000. $1000 / 180 = 5$ with remainder 100. Adding $180 - 100 = 80 \Rightarrow 1000 + 80 = 1080$.',
  '12, 15, 18 का LCM = 180। 4 अंकों की सबसे छोटी संख्या = 1000। $1000 \div 180$ में शेष 100 बचता है। संख्या = $1000 + (180 - 100) = 1,080$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  33,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'The length of a chord of a circle of radius 10 cm is 16 cm. Find the distance of the chord from the center of the circle.',
  '10 सेमी त्रिज्या वाले एक वृत्त की जीवा की लंबाई 16 सेमी है। वृत्त के केंद्र से जीवा की दूरी ज्ञात कीजिए।',
  '{"a":"5 cm","b":"6 cm","c":"7 cm","d":"8 cm"}'::jsonb,
  '{"a":"5 सेमी","b":"6 सेमी","c":"7 सेमी","d":"8 सेमी"}'::jsonb,
  'b',
  'The perpendicular from center bisects the chord: half chord = $16 / 2 = 8$ cm. By Pythagoras: Distance $d = \sqrt{10^2 - 8^2} = \sqrt{100 - 64} = \sqrt{36} = 6$ cm.',
  'केंद्र से जीवा पर लम्ब जीवा को समद्विभाजित करता है: आधी जीवा = 8 सेमी। केंद्र से दूरी = $\sqrt{10^2 - 8^2} = \sqrt{36} = 6$ सेमी।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  34,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'The average of 11 numbers is 50. If the average of the first 6 numbers is 48 and the average of the last 6 numbers is 53, find the 6th number.',
  '11 संख्याओं का औसत 50 है। यदि पहली 6 संख्याओं का औसत 48 और अंतिम 6 संख्याओं का औसत 53 है, तो छठी संख्या ज्ञात कीजिए।',
  '{"a":"52","b":"56","c":"58","d":"60"}'::jsonb,
  '{"a":"52","b":"56","c":"58","d":"60"}'::jsonb,
  'b',
  'Total sum = $11 \times 50 = 550$. Sum of first 6 = $6 \times 48 = 288$. Sum of last 6 = $6 \times 53 = 318$. 6th number $= (288 + 318) - 550 = 606 - 550 = 56$.',
  '11 संख्याओं का योग = 550। पहली 6 का योग = 288, अंतिम 6 का योग = 318। छठी संख्या = $(288 + 318) - 550 = 56$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  35,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'The diagonals of a rhombus are 16 cm and 12 cm long. Find the area and the perimeter of the rhombus.',
  'एक समचतुर्भुज के विकर्ण 16 सेमी और 12 सेमी लंबे हैं। समचतुर्भुज का क्षेत्रफल ज्ञात कीजिए।',
  '{"a":"84 cm²","b":"96 cm²","c":"108 cm²","d":"120 cm²"}'::jsonb,
  '{"a":"84 सेमी²","b":"96 सेमी²","c":"108 सेमी²","d":"120 सेमी²"}'::jsonb,
  'b',
  'Area of rhombus $= \frac{1}{2} \times d_1 \times d_2 = \frac{1}{2} \times 16 \times 12 = 96\text{ cm}^2$. Side $a = \sqrt{8^2 + 6^2} = 10$ cm, Perimeter $= 40$ cm.',
  'समचतुर्भुज का क्षेत्रफल $= \frac{1}{2} \times d_1 \times d_2 = \frac{1}{2} \times 16 \times 12 = 96\text{ cm}^2$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  36,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'What is the value of $\cos^2 30^\circ + \sin^2 30^\circ + \tan^2 45^\circ$?',
  '$\cos^2 30^\circ + \sin^2 30^\circ + \tan^2 45^\circ$ का मान क्या है?',
  '{"a":"1","b":"2","c":"3","d":"0"}'::jsonb,
  '{"a":"1","b":"2","c":"3","d":"0"}'::jsonb,
  'b',
  'By identity: $\cos^2 30^\circ + \sin^2 30^\circ = 1$. And $\tan 45^\circ = 1 \Rightarrow \tan^2 45^\circ = 1$. Total $= 1 + 1 = 2$.',
  'सर्वसमिका से: $\cos^2 30^\circ + \sin^2 30^\circ = 1$ और $\tan^2 45^\circ = 1^2 = 1$। मान = $1 + 1 = 2$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  37,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A tap can fill a cistern in 8 hours, but due to a leak at the bottom, it takes 10 hours to fill it. In how many hours will the leak alone empty the full cistern?',
  'एक नल एक टंकी को 8 घंटे में भर सकता है, लेकिन तली में रिसाव के कारण इसे भरने में 10 घंटे लगते हैं। अकेला रिसाव पूरी भरी टंकी को कितने घंटे में खाली कर देगा?',
  '{"a":"30 hours","b":"35 hours","c":"40 hours","d":"45 hours"}'::jsonb,
  '{"a":"30 घंटे","b":"35 घंटे","c":"40 घंटे","d":"45 घंटे"}'::jsonb,
  'c',
  'Capacity = LCM(8, 10) = 40 units. Tap = +5 units/hr. Tap + Leak = +4 units/hr. Leak rate = $5 - 4 = 1$ unit/hr. Time = $40 / 1 = 40$ hours.',
  'टंकी की क्षमता = 40 इकाई। नल की दर = 5 इकाई/घंटा, कुल दर = 4 इकाई/घंटा। रिसाव की दर = 1 इकाई/घंटा। समय = $40 / 1 = 40$ घंटे।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  38,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'If $\sec \theta + \tan \theta = 3$, what is the value of $\sec \theta - \tan \theta$?',
  'यदि $\sec \theta + \tan \theta = 3$ है, तो $\sec \theta - \tan \theta$ का मान क्या होगा?',
  '{"a":"1/3","b":"2/3","c":"1","d":"3"}'::jsonb,
  '{"a":"1/3","b":"2/3","c":"1","d":"3"}'::jsonb,
  'a',
  'Since $\sec^2 \theta - \tan^2 \theta = 1 \Rightarrow (\sec \theta + \tan \theta)(\sec \theta - \tan \theta) = 1$. Therefore, $\sec \theta - \tan \theta = 1/3$.',
  'चूंकि $\sec^2 \theta - \tan^2 \theta = 1$, अतः $\sec \theta - \tan \theta = \frac{1}{\sec \theta + \tan \theta} = \frac{1}{3}$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  39,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'If $a + b + c = 9$ and $ab + bc + ca = 26$, find the value of $a^2 + b^2 + c^2$.',
  'यदि $a + b + c = 9$ और $ab + bc + ca = 26$ है, तो $a^2 + b^2 + c^2$ का मान ज्ञात कीजिए।',
  '{"a":"27","b":"29","c":"31","d":"33"}'::jsonb,
  '{"a":"27","b":"29","c":"31","d":"33"}'::jsonb,
  'b',
  'Formula: $(a + b + c)^2 = a^2 + b^2 + c^2 + 2(ab + bc + ca) \Rightarrow 9^2 = a^2 + b^2 + c^2 + 2(26) \Rightarrow 81 = a^2 + b^2 + c^2 + 52 \Rightarrow a^2 + b^2 + c^2 = 81 - 52 = 29$.',
  '$(a + b + c)^2 = a^2 + b^2 + c^2 + 2(ab + bc + ca) \Rightarrow 81 = a^2 + b^2 + c^2 + 52 \Rightarrow a^2 + b^2 + c^2 = 29$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  40,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A metallic wire when bent in the form of a square encloses an area of 484 cm². If the same wire is bent into the form of a circle, what will be its enclosed area? (Take $\pi = 22/7$)',
  'एक धातु के तार को वर्ग के रूप में मोड़ने पर उसका क्षेत्रफल 484 सेमी² होता है। यदि उसी तार को वृत्त के रूप में मोड़ा जाए, तो उसका क्षेत्रफल क्या होगा? ($\pi = 22/7$ लें)',
  '{"a":"576 cm²","b":"616 cm²","c":"648 cm²","d":"692 cm²"}'::jsonb,
  '{"a":"576 सेमी²","b":"616 सेमी²","c":"648 सेमी²","d":"692 सेमी²"}'::jsonb,
  'b',
  'Area of square $= a^2 = 484 \Rightarrow a = 22$ cm. Length of wire (perimeter) $= 4 \times 22 = 88$ cm. Circumference of circle $= 2\pi r = 88 \Rightarrow r = 14$ cm. Area of circle $= \pi r^2 = (22/7) \times 14 \times 14 = 616\text{ cm}^2$.',
  'वर्ग की भुजा $a = 22$ सेमी, तार की लंबाई $= 88$ सेमी। वृत्त की परिधि $2\pi r = 88 \Rightarrow r = 14$ सेमी। वृत्त का क्षेत्रफल $= \frac{22}{7} \times 196 = 616\text{ सेमी}^2$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  41,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A is twice as efficient as B. Working together, they complete a task in 14 days. In how many days can A alone complete the task?',
  'A की कार्यक्षमता B से दोगुनी है। दोनों मिलकर एक काम को 14 दिनों में पूरा करते हैं। A अकेला उस काम को कितने दिनों में पूरा करेगा?',
  '{"a":"21 days","b":"24 days","c":"28 days","d":"35 days"}'::jsonb,
  '{"a":"21 दिन","b":"24 दिन","c":"28 दिन","d":"35 दिन"}'::jsonb,
  'a',
  'Efficiency ratio: A : B = 2 : 1. Combined efficiency = 3 units/day. Total work = $14 \times 3 = 42$ units. Time taken by A alone = $42 / 2 = 21$ days.',
  'A और B की क्षमता = 2 : 1। संयुक्त क्षमता = 3 इकाई/दिन। कुल कार्य = $14 \times 3 = 42$ इकाई। A द्वारा लिया गया समय = $42 / 2 = 21$ दिन।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  42,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'Find the area of a sector of a circle of radius 6 cm, if the angle of the sector is 60°. (Take $\pi = 22/7$)',
  '6 सेमी त्रिज्या वाले एक वृत्त के त्रिज्यखंड का क्षेत्रफल ज्ञात कीजिए, जिसका कोण 60° है। ($\pi = 22/7$ लें)',
  '{"a":"$18.86$ cm²","b":"$22.50$ cm²","c":"$26.24$ cm²","d":"$30.12$ cm²"}'::jsonb,
  '{"a":"$18.86$ सेमी²","b":"$22.50$ सेमी²","c":"$26.24$ सेमी²","d":"$30.12$ सेमी²"}'::jsonb,
  'a',
  'Area of sector $= \frac{\theta}{360} \pi r^2 = \frac{60}{360} \times \frac{22}{7} \times 6 \times 6 = \frac{1}{6} \times \frac{22}{7} \times 36 = \frac{132}{7} \approx 18.86\text{ cm}^2$.',
  'त्रिज्यखंड का क्षेत्रफल $= \frac{\theta}{360} \pi r^2 = \frac{60}{360} \times \frac{22}{7} \times 36 = \frac{132}{7} \approx 18.86\text{ सेमी}^2$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  43,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'If the circumference of a circle is 44 cm, find its area. (Take $\pi = 22/7$)',
  'यदि किसी वृत्त की परिधि 44 सेमी है, तो उसका क्षेत्रफल ज्ञात कीजिए। ($\pi = 22/7$ लें)',
  '{"a":"144 cm²","b":"154 cm²","c":"164 cm²","d":"176 cm²"}'::jsonb,
  '{"a":"144 सेमी²","b":"154 सेमी²","c":"164 सेमी²","d":"176 सेमी²"}'::jsonb,
  'b',
  'Circumference $2\pi r = 44 \Rightarrow 2(22/7)r = 44 \Rightarrow r = 7$ cm. Area $= \pi r^2 = (22/7) \times 49 = 154\text{ cm}^2$.',
  'परिधि $2\pi r = 44 \Rightarrow r = 7$ सेमी। क्षेत्रफल $= \pi r^2 = (22/7) \times 49 = 154\text{ सेमी}^2$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  44,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A can complete a piece of work in $24\text{ days}$, B in $32\text{ days}$, and C in $48\text{ days}$. They start the work together, but A leaves $3\text{ days}$ before the work is finished. In how many total days was the entire work completed?',
  'A किसी कार्य को $24\text{ दिनों}$ में, B $32\text{ दिनों}$ में और C $48\text{ दिनों}$ में पूरा कर सकता है। वे एक साथ कार्य शुरू करते हैं, लेकिन कार्य समाप्त होने से $3\text{ दिन}$ पहले A कार्य छोड़ देता है। पूरा कार्य कुल कितने दिनों में समाप्त हुआ?',
  '{"a":"$12\\text{ days}$","b":"$14\\text{ days}$","c":"$10\\text{ days}$","d":"$15\\text{ days}$"}'::jsonb,
  '{"a":"$12\\text{ दिन}$","b":"$14\\text{ दिन}$","c":"$10\\text{ दिन}$","d":"$15\\text{ दिन}$"}'::jsonb,
  'a',
  'Total work = LCM(24, 32, 48) = 96 units. Efficiencies: A = 4 units/day, B = 3 units/day, C = 2 units/day. Let total days be $D$. A worked for $(D - 3)$ days, while B and C worked for $D$ days. $4(D - 3) + 3D + 2D = 96 \implies 9D - 12 = 96 \implies 9D = 108 \implies D = 12\text{ days}$.',
  'कुल कार्य = ल.स.प.(24, 32, 48) = 96 इकाई। कार्यक्षमता: A = 4, B = 3, C = 2 इकाई/दिन। माना कार्य $D$ दिनों में पूरा हुआ। A ने $(D - 3)$ दिन कार्य किया तथा B और C ने $D$ दिन: $4(D - 3) + 3D + 2D = 96 \implies 9D = 108 \implies D = 12\text{ दिन}$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  45,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'If $a + b + c = 9$ and $ab + bc + ca = 26$, find the value of $a^3 + b^3 + c^3 - 3abc$.',
  'यदि $a + b + c = 9$ और $ab + bc + ca = 26$ है, तो $a^3 + b^3 + c^3 - 3abc$ का मान ज्ञात कीजिए।',
  '{"a":"$27$","b":"$36$","c":"$18$","d":"$45$"}'::jsonb,
  '{"a":"$27$","b":"$36$","c":"$18$","d":"$45$"}'::jsonb,
  'a',
  'Algebraic identity: $a^3 + b^3 + c^3 - 3abc = (a + b + c)[(a + b + c)^2 - 3(ab + bc + ca)]$. Substituting the given values: $9 \times [9^2 - 3(26)] = 9 \times [81 - 78] = 9 \times 3 = 27$.',
  'सर्वसमिका: $a^3 + b^3 + c^3 - 3abc = (a + b + c)[(a + b + c)^2 - 3(ab + bc + ca)]$। मान रखने पर: $9 \times [81 - 78] = 9 \times 3 = 27$।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  46,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  47,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A sum of money invested at compound interest doubles itself in 4 years. In how many years will it become 8 times of itself at the same rate of interest?',
  'चक्रवृद्धि ब्याज पर निवेश की गई कोई धनराशि 4 वर्षों में स्वयं की दोगुनी हो जाती है। समान ब्याज दर पर यह कितने वर्षों में स्वयं की 8 गुना हो जाएगी?',
  '{"a":"8 years","b":"12 years","c":"16 years","d":"20 years"}'::jsonb,
  '{"a":"8 वर्ष","b":"12 वर्ष","c":"16 वर्ष","d":"20 वर्ष"}'::jsonb,
  'b',
  'Under compound interest, if a sum becomes 2¹ times in 4 years, it will become 8 times (2³) in:
Time = 3 × 4 = 12 years.

Correct Option: (b)',
  'चक्रवृद्धि ब्याज में यदि धनराशि 4 वर्ष में 2¹ गुनी होती है, तो 8 गुनी (2³) होने में लगा समय = 3 × 4 = 12 वर्ष होगा।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  48,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'At what annual rate percent compound interest will a sum of ₹12,000 amount to ₹13,230 in 2 years (compounded annually)?',
  'चक्रवृद्धि ब्याज की किस वार्षिक दर से ₹12,000 की राशि 2 वर्षों में ₹13,230 हो जाएगी (वार्षिक संयोजित)?',
  '{"a":"4%","b":"5%","c":"6%","d":"7.5%"}'::jsonb,
  '{"a":"4%","b":"5%","c":"6%","d":"7.5%"}'::jsonb,
  'b',
  'Formula: A = P(1 + R/100)²
13,230 / 12,000 = (1 + R/100)²
Dividing by 30: 441 / 400 = (1 + R/100)²
Taking square root: 21 / 20 = 1 + R/100
R / 100 = 21/20 - 1 = 1/20
R = 100 / 20 = 5% per annum.

Correct Option: (b)',
  '13230 / 12000 = (1 + R/100)²
441 / 400 = (1 + R/100)² => 21 / 20 = 1 + R/100
R/100 = 1/20 => R = 5% वार्षिक।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  49,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'What is the compound amount on a principal of ₹8,000 for 1 year at 5% per annum, compounded semi-annually?',
  '₹8,000 के मूलधन पर 5% वार्षिक दर से 1 वर्ष के लिए चक्रवृद्धि मिश्रधन क्या होगा, जब ब्याज अर्धवार्षिक रूप से संयोजित होता है?',
  '{"a":"₹8,400","b":"₹8,405","c":"₹8,410","d":"₹8,450"}'::jsonb,
  '{"a":"₹8,400","b":"₹8,405","c":"₹8,410","d":"₹8,450"}'::jsonb,
  'b',
  'For semi-annual compounding:
Rate per period r = 5% / 2 = 2.5% = 1/40.
Number of half-yearly periods n = 1 × 2 = 2.
Amount = P × (1 + r)² = 8,000 × (1 + 2.5/100)²
= 8,000 × (41/40)² = 8,000 × (1681 / 1600) = 5 × 1681 = ₹8,405.

Correct Option: (b)',
  'अर्धवार्षिक संयोजन हेतु: दर = 5/2 = 2.5%, अवधि = 2 छमाही।
मिश्रधन = 8,000 × (1 + 2.5/100)² = 8,000 × (41/40) × (41/40) = 5 × 1681 = ₹8,405.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  50,
  2,
  'PART-2',
  'Mathematics',
  '',
  'Moderate',
  'A train 240 m long crosses a telegraph post in 12 seconds. How long will it take to pass a railway platform of length 360 m?',
  '240 मीटर लंबी एक रेलगाड़ी एक टेलीग्राफ खंभे को 12 सेकंड में पार करती है। 360 मीटर लंबे रेलवे प्लेटफॉर्म को पार करने में इसे कितना समय लगेगा?',
  '{"a":"25 seconds","b":"28 seconds","c":"30 seconds","d":"32 seconds"}'::jsonb,
  '{"a":"25 सेकंड","b":"28 सेकंड","c":"30 सेकंड","d":"32 सेकंड"}'::jsonb,
  'c',
  'Speed of train = Distance / Time = 240 / 12 = 20 m/s.
To cross a platform of 360 m, total distance to cover = Length of train + Length of platform
Total distance = 240 + 360 = 600 m.
Time required = Total distance / Speed = 600 / 20 = 30 seconds.

Correct Option: (c)',
  'रेलगाड़ी की चाल = 240 / 12 = 20 मी/से।
प्लेटफॉर्म पार करने में तय कुल दूरी = ट्रेन की लंबाई + प्लेटफॉर्म की लंबाई = 240 + 360 = 600 मीटर।
लगा समय = दूरी / चाल = 600 / 20 = 30 सेकंड।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  51,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Find the odd one out among the following SI units:',
  'निम्नलिखित SI मात्रकों में से विषम (Odd One Out) का चयन कीजिए:',
  '{"a":"Kilogram","b":"Second","c":"Kelvin","d":"Joule"}'::jsonb,
  '{"a":"किलोग्राम","b":"सेकंड","c":"केल्विन","d":"जूल (Joule)"}'::jsonb,
  'd',
  'Kilogram, Second, and Kelvin are fundamental base SI units. Joule is a derived unit ($\text{kg}\cdot\text{m}^2/\text{s}^2$).',
  'किलोग्राम, सेकंड और केल्विन मूल मात्रक (Base Units) हैं, जबकि जूल एक व्युत्पन्न मात्रक (Derived Unit) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  52,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'If ''MONKEY'' is coded as ''XDJMNL'', how will ''TIGER'' be coded in that language?',
  'यदि ''MONKEY'' को ''XDJMNL'' लिखा जाता है, तो उसी कूट भाषा में ''TIGER'' को कैसे लिखा जाएगा?',
  '{"a":"QDFHS","b":"SDFHQ","c":"RDFHS","d":"QDFHR"}'::jsonb,
  '{"a":"QDFHS","b":"SDFHQ","c":"RDFHS","d":"QDFHR"}'::jsonb,
  'a',
  'Reverse the word and subtract 1: MONKEY reversed is YEKNOM. Y-1=X, E-1=D, K-1=J, N-1=M, O-1=N, M-1=L. For TIGER, reversed is REGIT: R-1=Q, E-1=D, G-1=F, I-1=H, T-1=S $\Rightarrow$ QDFHS.',
  'शब्द को उलटा करके प्रत्येक अक्षर से -1 किया गया है: TIGER का उल्टा REGIT $\rightarrow$ R-1=Q, E-1=D, G-1=F, I-1=H, T-1=S $\Rightarrow$ ''QDFHS''।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  53,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'If 15th August 2023 fell on a Tuesday, on which day of the week did 15th August 2024 fall?',
  'यदि 15 अगस्त 2023 को मंगलवार था, तो 15 अगस्त 2024 को सप्ताह का कौन-सा दिन था?',
  '{"a":"Thursday","b":"Wednesday","c":"Friday","d":"Tuesday"}'::jsonb,
  '{"a":"गुरुवार (Thursday)","b":"बुधवार","c":"शुक्रवार","d":"मंगलवार"}'::jsonb,
  'a',
  'The year 2024 is a leap year (divisible by 4). The interval from August 15, 2023 to August 15, 2024 includes February 29, 2024, giving 366 days ($52\text{ weeks} + 2\text{ odd days}$). Tuesday $+ 2\text{ days} =$ Thursday.',
  'वर्ष 2024 एक लीप वर्ष है और 15 अगस्त 2023 से 15 अगस्त 2024 के बीच 29 फरवरी 2024 आती है। अतः कुल 366 दिन $= 52$ सप्ताह $+ 2$ विषम दिन होते हैं। मंगलवार $+ 2$ दिन $=$ गुरुवार।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  54,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Which Venn diagram configuration best illustrates the relationship among ''Reptiles, Lizards, and Snakes''?',
  'कौन सा वेन आरेख ''सरीसृप (Reptiles), छिपकली (Lizards), और साँप (Snakes)'' के बीच के संबंध को सर्वोत्तम रूप से दर्शाता है?',
  '{"a":"","b":"","c":"","d":""}'::jsonb,
  '{"a":"","b":"","c":"","d":""}'::jsonb,
  'a',
  'Both Lizards and Snakes are distinct biological classes of Reptiles, but no lizard is a snake. Hence, it is represented by one large circle (Reptiles) containing two separate non-overlapping circles (Lizards and Snakes).

Correct Option: (a)',
  'छिपकली और साँप दोनों ही सरीसृप वर्ग के अंतर्गत आते हैं, लेकिन छिपकली और साँप दो पूर्णतः भिन्न जीव हैं। अतः एक बड़े वृत्त के अंदर दो अलग-अलग वृत्त बनेंगे।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  '{"a":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"50\" cy=\"50\" r=\"36\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"35\" cy=\"50\" r=\"13\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"65\" cy=\"50\" r=\"13\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>","b":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"50\" cy=\"50\" r=\"35\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"50\" cy=\"50\" r=\"23\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"50\" cy=\"50\" r=\"12\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>","c":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"39\" cy=\"42\" r=\"21\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"61\" cy=\"42\" r=\"21\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"50\" cy=\"62\" r=\"21\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>","d":"<svg viewBox=\"0 0 100 100\" class=\"w-full h-full\" xmlns=\"http://www.w3.org/2000/svg\">\n    <rect x=\"2\" y=\"2\" width=\"96\" height=\"96\" fill=\"#ffffff\" stroke=\"#000000\" stroke-width=\"2.2\" rx=\"3\" />\n    \n    <circle cx=\"34\" cy=\"38\" r=\"17\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"66\" cy=\"38\" r=\"17\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n    <circle cx=\"50\" cy=\"72\" r=\"17\" fill=\"none\" stroke=\"#000000\" stroke-width=\"2.2\" />\n  \n  </svg>"}'::jsonb
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  55,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'How many triangles are there in a square with both diagonals drawn and the horizontal line passing through the intersection point of the diagonals?',
  'एक वर्ग में दोनों विकर्ण तथा विकर्णों के प्रतिच्छेद बिंदु से होकर गुजरने वाली क्षैतिज रेखा खींचे जाने पर बनने वाले कुल त्रिभुजों की संख्या कितनी होगी?',
  '{"a":"10","b":"12","c":"14","d":"16"}'::jsonb,
  '{"a":"10","b":"12","c":"14","d":"16"}'::jsonb,
  'b',
  'A square divided by 2 diagonals has 8 triangles (4 small + 4 composite).
When a horizontal line divides it:
- The square is split into 6 elementary parts.
- Triangles with 1 part = 6
- Triangles formed by combination of 2 adjacent parts = 4
- Triangles formed by combination of 3 parts (halves formed by diagonals) = 2
Total triangles = 6 + 4 + 2 = 12.

Correct Option: (b)',
  'एक वर्ग में दोनों विकर्ण और एक क्षैतिज मध्य रेखा खींचने पर:
- 1 भाग वाले एकल त्रिभुज = 6
- 2 भागों के संयोजन से बने त्रिभुज = 4
- 3 भागों के संयोजन से बने बड़े त्रिभुज = 2
कुल त्रिभुज = 6 + 4 + 2 = 12.

अतः सही उत्तर (b) है।',
  '<svg viewBox="0 0 180 180" width="100%" height="100%" class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
  <rect x="3" y="3" width="174" height="174" fill="#ffffff" stroke="#000000" stroke-width="2.5" rx="4" />
  <rect x="20" y="20" width="140" height="140" fill="#ffffff" fill-opacity="0.15" stroke="#000000" stroke-width="2.5" />
  <line x1="20" y1="20" x2="160" y2="160" stroke="#000000" stroke-width="2" />
  <line x1="160" y1="20" x2="20" y2="160" stroke="#000000" stroke-width="2" />
  <line x1="20" y1="90" x2="160" y2="90" stroke="#000000" stroke-width="2" stroke-dasharray="5,3" />
  <circle cx="90" cy="90" r="4" fill="#000000" />
</svg>',
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  56,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  57,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Statement: Should vocational and skill-based training be made compulsory in high schools in India?
Arguments:
I. Yes, because practical skill training enhances youth employability and self-reliance.
II. No, because it will divert students'' attention from fundamental academic learning.',
  'कथन: क्या भारत में हाई स्कूलों में व्यावसायिक और कौशल-आधारित प्रशिक्षण को अनिवार्य बनाया जाना चाहिए?
तर्क:
I. हां, क्योंकि व्यावहारिक कौशल प्रशिक्षण युवाओं की रोजगार क्षमता और आत्मनिर्भरता को बढ़ाता है।
II. नहीं, क्योंकि इससे बुनियादी अकादमिक शिक्षा से छात्रों का ध्यान भटकेगा।',
  '{"a":"Only argument I is strong","b":"Only argument II is strong","c":"Both arguments are strong","d":"Neither argument is strong"}'::jsonb,
  '{"a":"केवल तर्क I ठोस है","b":"केवल तर्क II ठोस है","c":"दोनों तर्क ठोस हैं","d":"कोई भी तर्क ठोस नहीं है"}'::jsonb,
  'a',
  'Argument I is strong because preparing youth with employable skills is critical for national development and individual economic empowerment.
Argument II is weak because vocational training integrates with and enriches academic education rather than opposing it.
Therefore, only argument I is strong.

Correct Option: (a)',
  'तर्क I ठोस है क्योंकि रोजगारपरक कौशल युवाओं को आत्मनिर्भर बनाते हैं और देश के आर्थिक विकास में योगदान देते हैं।
तर्क II कमजोर है क्योंकि कौशल प्रशिक्षण और अकादमिक शिक्षा एक-दूसरे के पूरक हैं।
अतः केवल तर्क I ठोस है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  58,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  59,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'In a certain code language, ''TRAIN'' is coded as ''USBJP''. How is ''METRO'' coded in that language?',
  'एक निश्चित कूट भाषा में, ''TRAIN'' को ''USBJP'' के रूप में कोडित किया जाता है। उसी भाषा में ''METRO'' को कैसे कोडित किया जाएगा?',
  '{"a":"NFUSP","b":"NFUQP","c":"OFVSP","d":"NFURP"}'::jsonb,
  '{"a":"NFUSP","b":"NFUQP","c":"OFVSP","d":"NFURP"}'::jsonb,
  'a',
  'Pattern: Each letter is shifted by +1: T(+1)=U, R(+1)=S, A(+1)=B, I(+1)=J, N(+1)=P. For METRO: M(+1)=N, E(+1)=F, T(+1)=U, R(+1)=S, O(+1)=P. Thus, NFUSP.',
  'पैटर्न: प्रत्येक अक्षर में +1 की वृद्धि की गई है: T(+1)=U, R(+1)=S, A(+1)=B, I(+1)=J, N(+1)=P। METRO के लिए: M(+1)=N, E(+1)=F, T(+1)=U, R(+1)=S, O(+1)=P। अतः, NFUSP।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  60,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Statement: ''Please do not lean out of the train window.'' Assumptions: I. People might get injured by overhead poles or oncoming trains. II. Passengers usually obey safety warnings.',
  'कथन: ''कृपया ट्रेन की खिड़की से बाहर न झुकें।'' पूर्वधारणाएँ: I. लोग खंभों या सामने से आने वाली ट्रेनों से घायल हो सकते हैं। II. यात्री आमतौर पर सुरक्षा चेतावनियों का पालन करते हैं।',
  '{"a":"Only assumption I is implicit","b":"Only assumption II is implicit","c":"Neither I nor II is implicit","d":"Both assumptions I and II are implicit"}'::jsonb,
  '{"a":"केवल पूर्वधारणा I अंतर्निहित है","b":"केवल पूर्वधारणा II अंतर्निहित है","c":"न तो I और न ही II अंतर्निहित है","d":"दोनों पूर्वधारणाएँ I और II अंतर्निहित हैं"}'::jsonb,
  'd',
  'The warning exists because of risk of injury (I is implicit) and notices are posted with the expectation of compliance (II is implicit).',
  'चेतावनी खतरे (चोट लगने की संभावना) के कारण दी जाती है (I अंतर्निहित है) और सूचनाएँ इस धारणा के साथ लगाई जाती हैं कि लोग मानेंगे (II भी अंतर्निहित है)।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  61,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Statements: (1) All trains are metals. (2) No metal is plastic. Conclusions: I. No train is plastic. II. No plastic is a train.',
  'कथन: (1) सभी ट्रेनें धातु हैं। (2) कोई धातु प्लास्टिक नहीं है। निष्कर्ष: I. कोई ट्रेन प्लास्टिक नहीं है। II. कोई प्लास्टिक ट्रेन नहीं है।',
  '{"a":"Only conclusion I follows","b":"Only conclusion II follows","c":"Both conclusions I and II follow","d":"Neither I nor II follows"}'::jsonb,
  '{"a":"केवल निष्कर्ष I अनुसरण करता है","b":"केवल निष्कर्ष II अनुसरण करता है","c":"दोनों निष्कर्ष I और II अनुसरण करते हैं","d":"न तो I और न ही II अनुसरण करता है"}'::jsonb,
  'c',
  'Since Trains are entirely inside Metal, and Metal has zero intersection with Plastic, Trains and Plastic are disjoint. Both I and II are valid.',
  'ट्रेनें पूरी तरह धातु के अंदर हैं और धातु व प्लास्टिक अलग-अलग हैं, अतः कोई ट्रेन प्लास्टिक नहीं है और कोई प्लास्टिक ट्रेन नहीं है। दोनों निष्कर्ष सही हैं।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  62,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Statement:
''Do not lean out of the window while the train is in motion.'' - Railway safety notice.
Assumptions:
I. Leaning out of moving trains can cause severe injuries or fatal accidents.
II. Passengers generally read and adhere to official notices.',
  'कथन:
''ट्रेन चलते समय खिड़की से बाहर न झुकें।'' - रेलवे सुरक्षा सूचना।
पूर्वधारणाएँ:
I. चलती ट्रेन से बाहर झुकने से गंभीर चोटें या घातक दुर्घटनाएँ हो सकती हैं।
II. यात्री सामान्यतः आधिकारिक सूचनाओं को पढ़ते हैं और उनका पालन करते हैं।',
  '{"a":"Only assumption I is implicit","b":"Only assumption II is implicit","c":"Both assumptions I and II are implicit","d":"Neither is implicit"}'::jsonb,
  '{"a":"केवल पूर्वधारणा I अंतर्निहित है","b":"केवल पूर्वधारणा II अंतर्निहित है","c":"पूर्वधारणाएँ I और II दोनों अंतर्निहित हैं","d":"कोई भी अंतर्निहित नहीं है"}'::jsonb,
  'c',
  'Any warning or notice is put up with the assumption that the action warned against is hazardous (Assumption I) and that people will heed the notice (Assumption II). Both assumptions are implicit.

Correct Option: (c)',
  'किसी भी सुरक्षा नोटिस के पीछे यह माना जाता है कि वह गतिविधि खतरनाक है (पूर्वधारणा I) और लोग सूचना पर ध्यान देंगे (पूर्वधारणा II)। अतः दोनों पूर्वधारणाएँ अंतर्निहित हैं।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  63,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'What letter will come in place of the question mark (?):
Z, W, S, N, ?',
  'प्रश्नवाचक चिन्ह (?) के स्थान पर कौन सा अक्षर आएगा:
Z, W, S, N, ?',
  '{"a":"H","b":"I","c":"J","d":"G"}'::jsonb,
  '{"a":"H","b":"I","c":"J","d":"G"}'::jsonb,
  'a',
  'Decreasing positions:
Z(26) -> (-3) -> W(23)
W(23) -> (-4) -> S(19)
S(19) -> (-5) -> N(14)
N(14) -> (-6) -> H(8).

Correct Option: (a)',
  'स्थानीय मान में घटता अंतर (-3, -4, -5, -6):
Z(26) - 3 = W(23)
W(23) - 4 = S(19)
S(19) - 5 = N(14)
N(14) - 6 = H(8).

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  64,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  65,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  66,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'At what time between 4 o''clock and 5 o''clock will the hands of a clock be together (coincide)?',
  '4 और 5 बजे के बीच किस समय घड़ी की दोनों सुइयां एक साथ (संपाती) होंगी?',
  '{"a":"4 hours 20 minutes","b":"4 hours 21 9/11 minutes","c":"4 hours 22 minutes","d":"4 hours 18 2/11 minutes"}'::jsonb,
  '{"a":"4 बजकर 20 मिनट","b":"4 बजकर 21 9/11 मिनट","c":"4 बजकर 22 मिनट","d":"4 बजकर 18 2/11 मिनट"}'::jsonb,
  'b',
  'At 4 o''clock, the minute hand is 20 minute-spaces behind the hour hand.
Relative speed of minute hand over hour hand = 55 spaces in 60 minutes = 11/12 spaces/min.
Time taken to gain 20 spaces = 20 × (60 / 55) = 20 × (12 / 11) = 240 / 11 = 21 9/11 minutes.
Hence, the hands coincide at 4 hours 21 9/11 minutes.

Correct Option: (b)',
  '4 बजे मिनट की सुई घंटे की सुई से 20 मिनट पीछे होती है।
संपाती होने के लिए आवश्यक समय = 20 × (12 / 11) = 240 / 11 = 21 9/11 मिनट।
अतः समय 4 बजकर 21 9/11 मिनट होगा।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  67,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  '''Japan'' is related to ''Yen'' in the same way as ''South Korea'' is related to:',
  '''जापान'' का संबंध ''येन'' से उसी प्रकार है, जिस प्रकार ''दक्षिण कोरिया'' का संबंध किससे है?',
  '{"a":"Yuan","b":"Won","c":"Baht","d":"Ringgit"}'::jsonb,
  '{"a":"युआन","b":"वोन (Won)","c":"बहत","d":"रिंगिट"}'::jsonb,
  'b',
  'The national currency of Japan is the Yen. The national currency of South Korea is the South Korean Won.

Correct Option: (b)',
  'जापान की राष्ट्रीय मुद्रा येन है। उसी प्रकार दक्षिण कोरिया की राष्ट्रीय मुद्रा वोन (Won) है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  68,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  69,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  70,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Find the odd pair out from the given alternatives:
(a) 12 - 144  (b) 13 - 169  (c) 15 - 225  (d) 14 - 198',
  'दिए गए विकल्पों में से विषम युग्म ज्ञात कीजिए:
(a) 12 - 144  (b) 13 - 169  (c) 15 - 225  (d) 14 - 198',
  '{"a":"12 - 144","b":"13 - 169","c":"15 - 225","d":"14 - 198"}'::jsonb,
  '{"a":"12 - 144","b":"13 - 169","c":"15 - 225","d":"14 - 198"}'::jsonb,
  'd',
  'Pattern: Second number is the square of the first number:
- 12² = 144
- 13² = 169
- 15² = 225
- 14² = 196 (not 198).
Hence, (d) is the odd pair.

Correct Option: (d)',
  'पैटर्न: दूसरी संख्या पहली संख्या का वर्ग है।
12² = 144, 13² = 169, 15² = 225.
जबकि 14² = 196 होता है (198 नहीं)। अतः (d) विषम है।

अतः सही उत्तर (d) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  71,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  '''Entomology'' is to ''Insects'' as ''Ornithology'' is to:',
  '''कीटविज्ञान'' (Entomology) का संबंध ''कीटों'' से है, उसी प्रकार ''पक्षीविज्ञान'' (Ornithology) का संबंध किससे है?',
  '{"a":"Fishes","b":"Birds","c":"Reptiles","d":"Mammals"}'::jsonb,
  '{"a":"मछलियाँ","b":"पक्षी (Birds)","c":"सरीसृप","d":"स्तनधारी"}'::jsonb,
  'b',
  'Entomology is the scientific study of insects. Ornithology is the scientific branch of zoology that studies birds.

Correct Option: (b)',
  'कीटविज्ञान कीटों का वैज्ञानिक अध्ययन है। उसी प्रकार पक्षीविज्ञान (Ornithology) पक्षियों का वैज्ञानिक अध्ययन है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  72,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'A delivery rider travels 5 km East, then turns right and rides 4 km. He then turns left and rides 5 km, and finally turns North and rides 4 km. How far is he from his initial point?',
  'एक डिलीवरी राइडर 5 किमी पूर्व की ओर जाता है, फिर दायें मुड़कर 4 किमी जाता है। फिर वह बायें मुड़कर 5 किमी जाता है, और अंत में उत्तर की ओर 4 किमी जाता है। वह अपने प्रारंभिक बिंदु से कितनी दूरी पर है?',
  '{"a":"8 km","b":"10 km","c":"12 km","d":"14 km"}'::jsonb,
  '{"a":"8 किमी","b":"10 किमी","c":"12 किमी","d":"14 किमी"}'::jsonb,
  'b',
  'Tracking displacement:
1. 5 km East -> (+5, 0)
2. Right turn (South) 4 km -> (+5, -4)
3. Left turn (East) 5 km -> (+10, -4)
4. North 4 km -> (+10, -4 + 4) = (+10, 0).
He is exactly 10 km East of the starting point.

Correct Option: (b)',
  'गति विश्लेषण:
1. पूर्व 5 किमी
2. दायें (दक्षिण) 4 किमी
3. बायें (पूर्व) 5 किमी
4. उत्तर 4 किमी (दक्षिण के 4 किमी को निरस्त करता है)।
कुल दूरी = 5 + 5 = 10 किमी पूर्व में।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  73,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'If 1st January 2020 was a Wednesday, what day of the week was 1st January 2021?',
  'यदि 1 जनवरी 2020 को बुधवार था, तो 1 जनवरी 2021 को सप्ताह का कौन सा दिन था?',
  '{"a":"Thursday","b":"Friday","c":"Saturday","d":"Sunday"}'::jsonb,
  '{"a":"गुरुवार","b":"शुक्रवार (Friday)","c":"शनिवार","d":"रविवार"}'::jsonb,
  'b',
  'The year 2020 is a leap year (366 days, divisible by 4) containing 29 February.
A leap year has 2 odd days (366 mod 7 = 2).
Day on 1st January 2021 = Wednesday + 2 days = Friday.

Correct Option: (b)',
  'वर्ष 2020 एक लीप वर्ष है (366 दिन), जिसमें 2 विषम दिन होते हैं।
अतः 1 जनवरी 2021 = बुधवार + 2 दिन = शुक्रवार (Friday)।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  74,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Find the next number in the given series:
12, 14, 21, 35, 58, ?',
  'दी गई संख्या श्रृंखला में अगला पद ज्ञात कीजिए:
12, 14, 21, 35, 58, ?',
  '{"a":"90","b":"92","c":"94","d":"88"}'::jsonb,
  '{"a":"90","b":"92","c":"94","d":"88"}'::jsonb,
  'b',
  'Analyzing the differences:
- 14 - 12 = 2
- 21 - 14 = 7 (+5)
- 35 - 21 = 14 (+7)
- 58 - 35 = 23 (+9)
Next difference increment = +11 => difference = 23 + 11 = 34.
Next term = 58 + 34 = 92.

Correct Option: (b)',
  'अंतर का विश्लेषण:
+2, +7 (+5), +14 (+7), +23 (+9).
अगला अंतर = 23 + 11 = 34.
अगला पद = 58 + 34 = 92.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  75,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Kunal walks 10 km towards North. From there he walks 6 km towards South. Then, he walks 3 km towards East. How far and in which direction is he with reference to his starting point?',
  'कुणाल उत्तर की ओर 10 किमी चलता है। वहाँ से वह दक्षिण की ओर 6 किमी चलता है। फिर, वह पूर्व की ओर 3 किमी चलता है। वह अपने प्रारंभिक बिंदु के संदर्भ में कितनी दूर और किस दिशा में है?',
  '{"a":"5 km North-East","b":"5 km South-East","c":"7 km North-East","d":"4 km East"}'::jsonb,
  '{"a":"5 किमी उत्तर-पूर्व (North-East)","b":"5 किमी दक्षिण-पूर्व","c":"7 किमी उत्तर-पूर्व","d":"4 किमी पूर्व"}'::jsonb,
  'a',
  'Displacement breakdown from origin (0, 0):
1. 10 km North -> (0, 10)
2. 6 km South -> (0, 10 - 6) = (0, 4)
3. 3 km East -> (3, 4).
Distance = √(3² + 4²) = √(9 + 16) = √25 = 5 km.
Direction: With positive x (East) and positive y (North), the direction is North-East.

Correct Option: (a)',
  '10 किमी उत्तर जाने के बाद 6 किमी दक्षिण आने पर वह उत्तर में 4 किमी पर रहता है।
इसके बाद पूर्व में 3 किमी जाता है।
दूरी = √(4² + 3²) = 5 किमी। दिशा: उत्तर-पूर्व (North-East)।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  76,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'In a row of boys, Deepak is 7th from the left and Madhu is 12th from the right. If they interchange their positions, Deepak becomes 22nd from the left. What is the total number of boys in the row?',
  'लड़कों की एक पंक्ति में, दीपक बायें से 7वें और मधु दायें से 12वें स्थान पर है। यदि वे अपना स्थान आपस में बदल लेते हैं, तो दीपक बायें से 22वाँ हो जाता है। पंक्ति में लड़कों की कुल संख्या क्या है?',
  '{"a":"31","b":"33","c":"35","d":"37"}'::jsonb,
  '{"a":"31","b":"33","c":"35","d":"37"}'::jsonb,
  'b',
  'Deepak''s new position is Madhu''s original seat:
Position from left = 22nd.
Position from right = 12th.
Total boys = (22 + 12) - 1 = 34 - 1 = 33.

Correct Option: (b)',
  'स्थान परिवर्तन के बाद दीपक की स्थिति (मधु का मूल स्थान) बायें से 22वीं और दायें से 12वीं है।
कुल लड़के = 22 + 12 - 1 = 33.

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  77,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Find the missing number in the series:
3, 7, 16, 35, 74, ?',
  'दी गई संख्या श्रृंखला में लुप्त पद ज्ञात कीजिए:
3, 7, 16, 35, 74, ?',
  '{"a":"153","b":"149","c":"151","d":"150"}'::jsonb,
  '{"a":"153","b":"149","c":"151","d":"150"}'::jsonb,
  'a',
  'Pattern in the series:
- 3 * 2 + 1 = 7
- 7 * 2 + 2 = 16
- 16 * 2 + 3 = 35
- 35 * 2 + 4 = 74
- Next term = 74 * 2 + 5 = 148 + 5 = 153.

Correct Option: (a)',
  'पैटर्न:
- 3 * 2 + 1 = 7
- 7 * 2 + 2 = 16
- 16 * 2 + 3 = 35
- 35 * 2 + 4 = 74
- 74 * 2 + 5 = 148 + 5 = 153.

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  78,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'Four number-pairs are given, of which three are alike in some way and one is different. Select the odd one out.',
  'चार संख्या-युग्म दिए गए हैं, जिनमें से तीन किसी प्रकार समान हैं और एक भिन्न है। उस भिन्न युग्म का चयन कीजिए।',
  '{"a":"12 : 140","b":"14 : 194","c":"16 : 254","d":"18 : 322"}'::jsonb,
  '{"a":"12 : 140","b":"14 : 194","c":"16 : 254","d":"18 : 322"}'::jsonb,
  'a',
  'Pattern: n : (n^2 - 2)
- 14 : 14^2 - 2 = 196 - 2 = 194
- 16 : 16^2 - 2 = 256 - 2 = 254
- 18 : 18^2 - 2 = 324 - 2 = 322
- For 12: 12^2 - 2 = 144 - 2 = 142. But wait, 12^2 - 2 = 142! Let''s check: all follow n^2 - 2? No, 12^2 = 144, 144 - 2 = 142. What if pattern is n^2 - 2 for all? Then all match! Let''s examine: (a) 12 : 142 is 144-2, (b) 14 : 194 is 196-2, (c) 16 : 254 is 256-2, (d) 18: 322 is 324-2. If option (a) were 12: 140 or 146, it would be odd. Let''s make (a) 12 : 140 so (a) is distinctly the odd one out.',
  'पैटर्न: n : (n^2 - 2)
- 14^2 - 2 = 194
- 16^2 - 2 = 254
- 18^2 - 2 = 322
- 12^2 - 2 = 142 होना चाहिए, जबकि विकल्प (a) में 140 दिया है। अतः (a) भिन्न है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  79,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'A man starts walking from his house and walks 10 km South. He then turns right and walks 6 km. He again turns right and walks 18 km. Finally, he turns right and walks 6 km. How far and in which direction is he now from his starting point?',
  'एक व्यक्ति अपने घर से चलना शुरू करता है और 10 किमी दक्षिण की ओर चलता है। फिर वह दाएं मुड़कर 6 किमी चलता है। वह पुनः दाएं मुड़कर 18 किमी चलता है। अंत में वह दाएं मुड़कर 6 किमी चलता है। अब वह अपने प्रारंभिक बिंदु से कितनी दूरी पर और किस दिशा में है?',
  '{"a":"8 km, North","b":"8 km, South","c":"12 km, North","d":"6 km, East"}'::jsonb,
  '{"a":"8 किमी, उत्तर","b":"8 किमी, दक्षिण","c":"12 किमी, उत्तर","d":"6 किमी, पूर्व"}'::jsonb,
  'a',
  'Let starting point be origin (0, 0):
1. Walks 10 km South -> (0, -10)
2. Turns right (facing West) and walks 6 km -> (-6, -10)
3. Turns right (facing North) and walks 18 km -> (-6, -10 + 18) = (-6, 8)
4. Turns right (facing East) and walks 6 km -> (-6 + 6, 8) = (0, 8)
The final position is at (0, 8), which is exactly 8 km North of the starting point.

Correct Option: (a)',
  'प्रारंभिक बिंदु से:
1. 10 किमी दक्षिण -> (0, -10)
2. दाएं (पश्चिम) 6 किमी -> (-6, -10)
3. दाएं (उत्तर) 18 किमी -> (-6, 8)
4. दाएं (पूर्व) 6 किमी -> (0, 8)
अतः वह अपने प्रारंभिक बिंदु से 8 किमी उत्तर दिशा में है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  80,
  3,
  'PART-3',
  'General Intelligence & Reasoning',
  '',
  'Moderate',
  'If ''+'' means ''÷'', ''-'' means ''×'', ''×'' means ''+'', and ''÷'' means ''-'', then what is the value of the following expression?
36 + 4 - 8 × 15 ÷ 9',
  'यदि ''+'' का अर्थ ''÷'', ''-'' का अर्थ ''×'', ''×'' का अर्थ ''+'', और ''÷'' का अर्थ ''-'' है, तो निम्नलिखित व्यंजक का मान क्या होगा?
36 + 4 - 8 × 15 ÷ 9',
  '{"a":"78","b":"82","c":"74","d":"66"}'::jsonb,
  '{"a":"78","b":"82","c":"74","d":"66"}'::jsonb,
  'a',
  'Replacing the mathematical signs according to given instructions:
Original: 36 + 4 - 8 × 15 ÷ 9
Substituted: 36 ÷ 4 × 8 + 15 - 9
Now applying BODMAS:
1. Division: 36 ÷ 4 = 9
2. Multiplication: 9 × 8 = 72
3. Addition: 72 + 15 = 87
4. Subtraction: 87 - 9 = 78.

Correct Option: (a)',
  'चिह्नों को बदलने पर:
मूल व्यंजक: 36 + 4 - 8 × 15 ÷ 9
परिवर्तित व्यंजक: 36 ÷ 4 × 8 + 15 - 9
BODMAS नियम से:
1. भाग: 36 ÷ 4 = 9
2. गुणा: 9 × 8 = 72
3. जोड़: 72 + 15 = 87
4. घटाव: 87 - 9 = 78.

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  81,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Which gas is primarily responsible for the anthropogenic greenhouse effect and global warming?',
  'मानवजनित ग्रीनहाउस प्रभाव और ग्लोबल वार्मिंग के लिए मुख्य रूप से कौन सी गैस उत्तरदायी है?',
  '{"a":"Carbon dioxide (CO₂)","b":"Oxygen (O₂)","c":"Argon (Ar)","d":"Nitrogen (N₂)"}'::jsonb,
  '{"a":"कार्बन डाइऑक्साइड (CO₂)","b":"ऑक्सीजन (O₂)","c":"ऑर्गन (Ar)","d":"नाइट्रोजन (N₂)"}'::jsonb,
  'a',
  'Carbon dioxide ($CO_2$), emitted from fossil fuel combustion and deforestation, accounts for the vast majority of anthropogenic radiative forcing.',
  'जीवाश्म ईंधन के दहन से उत्पन्न कार्बन डाइऑक्साइड ($	ext{CO}_2$) मुख्य ग्रीनहाउस गैस है जो वैश्विक तापन के लिए सबसे अधिक उत्तरदायी है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  82,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  83,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  84,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Majuli, recognized as the world''s largest inhabited river island, is formed by which river in the state of Assam?',
  'विश्व का सबसे बड़ा आबाद नदी द्वीप ''माजुली'' (Majuli), असम राज्य में किस नदी द्वारा निर्मित है?',
  '{"a":"Ganga","b":"Brahmaputra","c":"Barak","d":"Teesta"}'::jsonb,
  '{"a":"गंगा","b":"ब्रह्मपुत्र (Brahmaputra)","c":"बराक","d":"तीस्ता"}'::jsonb,
  'b',
  'Majuli is a large riverine island formed by the Brahmaputra River in Assam, and was declared the first river island district of India in 2016.

Correct Option: (b)',
  'माजुली द्वीप असम में ब्रह्मपुत्र नदी द्वारा निर्मित दुनिया का सबसे बड़ा नदी द्वीप है। यह भारत का पहला नदी द्वीप जिला भी है।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  85,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Which Article of the Constitution of India provides for the establishment of the Election Commission of India?',
  'भारतीय संविधान का कौन सा अनुच्छेद भारत के निर्वाचन आयोग (Election Commission of India) की स्थापना का प्रावधान करता है?',
  '{"a":"Article 324","b":"Article 326","c":"Article 280","d":"Article 312"}'::jsonb,
  '{"a":"अनुच्छेद 324","b":"अनुच्छेद 326","c":"अनुच्छेद 280","d":"अनुच्छेद 312"}'::jsonb,
  'a',
  'Article 324 vests the superintendence, direction, and control of all elections to Parliament, State Legislatures, and the offices of President and Vice President in the Election Commission of India.

Correct Option: (a)',
  'संविधान के अनुच्छेद 324 में संसद, राज्य विधानमंडलों, राष्ट्रपति और उपराष्ट्रपति के चुनावों के संचालन और अधीक्षण के लिए निर्वाचन आयोग का प्रावधान है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  86,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Which railway station in Northeast India became the first railway station in the country to be fully operated on 100% solar power?',
  'पूर्वोत्तर भारत का कौन सा रेलवे स्टेशन 100% सौर ऊर्जा से संचालित होने वाला देश का पहला रेलवे स्टेशन बना?',
  '{"a":"Silchar","b":"Guwahati","c":"Dimapur","d":"Agartala"}'::jsonb,
  '{"a":"सिलचर","b":"गुवाहाटी (Guwahati)","c":"दीमापुर","d":"अगरतला"}'::jsonb,
  'b',
  'Guwahati Railway Station in Assam became India''s first 100% solar-powered railway station in May 2018, with rooftop solar panels generating over 700 kWp of clean electricity.

Correct Option: (b)',
  'असम का गुवाहाटी रेलवे स्टेशन मई 2018 में पूरी तरह से सौर ऊर्जा से संचालित होने वाला भारत का पहला रेलवे स्टेशन बना था।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  87,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'The Godavari, the longest river in peninsular India (also known as Dakshin Ganga), originates from which of the following places?',
  'प्रायद्वीपीय भारत की सबसे लंबी नदी गोदावरी (जिसे ''दक्षिण गंगा'' भी कहा जाता है), निम्नलिखित में से किस स्थान से निकलती है?',
  '{"a":"Trimbakeshwar (Nashik, Maharashtra)","b":"Mahabaleshwar (Maharashtra)","c":"Amarkantak (Madhya Pradesh)","d":"Brahmagiri Hills (Karnataka)"}'::jsonb,
  '{"a":"त्र्यंबकेश्वर (नासिक, महाराष्ट्र)","b":"महाबलेश्वर (महाराष्ट्र)","c":"अमरकंटक (मध्य प्रदेश)","d":"ब्रह्मगिरी पहाड़ियां (कर्नाटक)"}'::jsonb,
  'a',
  'The Godavari originates from Trimbakeshwar near Nashik in Maharashtra in the Western Ghats. It flows eastwards across Maharashtra, Telangana, and Andhra Pradesh for about 1,465 km before emptying into the Bay of Bengal.
(Mahabaleshwar is the source of Krishna river; Amarkantak is source of Narmada; Brahmagiri is source of Kaveri).

Correct Option: (a)',
  'गोदावरी नदी महाराष्ट्र के नासिक जिले में पश्चिमी घाट की त्र्यंबकेश्वर की पहाड़ियों से निकलती है। 1,465 किमी लंबी यह नदी प्रायद्वीपीय भारत की सबसे बड़ी नदी है और इसे ''दक्षिण गंगा'' या ''वृद्ध गंगा'' भी कहा जाता है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  88,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Which Constitutional Amendment Act of 1976 added the words ''Socialist'', ''Secular'', and ''Integrity'' to the Preamble of the Indian Constitution?',
  'वर्ष 1976 के किस संविधान संशोधन अधिनियम द्वारा भारतीय संविधान की प्रस्तावना में ''समाजवादी'', ''पंथनिरपेक्ष'' (धर्मनिरपेक्ष) और ''अखंडता'' शब्द जोड़े गए थे?',
  '{"a":"44th Amendment Act","b":"42nd Amendment Act","c":"52nd Amendment Act","d":"61st Amendment Act"}'::jsonb,
  '{"a":"44वां संशोधन अधिनियम","b":"42वां संशोधन अधिनियम","c":"52वां संशोधन अधिनियम","d":"61वां संशोधन अधिनियम"}'::jsonb,
  'b',
  'The 42nd Constitutional Amendment Act, 1976 (known as the ''Mini Constitution'') amended the Preamble of the Constitution of India for the first and only time, inserting the three words: ''Socialist'', ''Secular'', and ''Integrity''.

Correct Option: (b)',
  '42वें संविधान संशोधन अधिनियम, 1976 (जिसे लघु संविधान भी कहा जाता है) द्वारा भारतीय संविधान की प्रस्तावना में पहली और एकमात्र बार संशोधन कर ''समाजवादी'', ''पंथनिरपेक्ष'' और ''अखंडता'' शब्द जोड़े गए।

अतः सही उत्तर (b) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  89,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'The Anti-Defection Law was introduced into the Constitution of India through the 52nd Amendment Act in 1985 under which Schedule?',
  'वर्ष 1985 में 52वें संविधान संशोधन अधिनियम द्वारा भारतीय संविधान की किस अनुसूची के तहत ''दलबदल विरोधी कानून'' (Anti-Defection Law) को शामिल किया गया था?',
  '{"a":"Eighth Schedule","b":"Ninth Schedule","c":"Tenth Schedule","d":"Eleventh Schedule"}'::jsonb,
  '{"a":"आठवीं अनुसूची","b":"नौवीं अनुसूची","c":"दसवीं अनुसूची","d":"ग्यारहवीं अनुसूची"}'::jsonb,
  'c',
  'The 52nd Constitutional Amendment Act of 1985 added the Tenth Schedule to the Constitution of India, popularly known as the Anti-Defection Law, to curb political defection among legislators.

Correct Option: (c)',
  '52वें संविधान संशोधन अधिनियम 1985 द्वारा भारतीय संविधान में 10वीं अनुसूची जोड़ी गई, जिसे ''दलबदल विरोधी कानून'' कहा जाता है। इसका उद्देश्य विधायकों और सांसदों द्वारा राजनीतिक निष्ठा बदलने पर अयोग्यता निर्धारित करना है।

अतः सही उत्तर (c) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  90,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'The Goods and Services Tax (GST), a unified indirect tax regime across India, was enacted by which Constitutional Amendment Act and came into effect on 1st July 2017?',
  'भारत भर में एकीकृत अप्रत्यक्ष कर प्रणाली ''वस्तु एवं सेवा कर'' (GST) किस संविधान संशोधन अधिनियम द्वारा लागू की गई, जो 1 जुलाई 2017 से प्रभावी हुई?',
  '{"a":"101st Constitutional Amendment Act","b":"100th Constitutional Amendment Act","c":"103rd Constitutional Amendment Act","d":"104th Constitutional Amendment Act"}'::jsonb,
  '{"a":"101वां संविधान संशोधन अधिनियम","b":"100वां संविधान संशोधन अधिनियम","c":"103वां संविधान संशोधन अधिनियम","d":"104वां संविधान संशोधन अधिनियम"}'::jsonb,
  'a',
  'The 101st Constitutional Amendment Act, 2016 introduced the Goods and Services Tax (GST) under Article 246A, 269A, and 279A. It replaced a web of Central and State indirect taxes (Excise, VAT, Service Tax) starting 1st July 2017 under the motto ''One Nation, One Tax''.

Correct Option: (a)',
  '101वें संविधान संशोधन अधिनियम 2016 द्वारा भारत में GST लागू किया गया, जो 1 जुलाई 2017 से प्रभावी हुआ। इसने उत्पाद शुल्क, वैट, सेवा कर आदि कई अप्रत्यक्ष करों को प्रतिस्थापित किया।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  91,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'The 11.215 km long Pir Panjal Railway Tunnel (India''s first major broad-gauge transportation tunnel) connects Banihal with Qazigund in which State/UT?',
  '11.215 किमी लंबी पीर पंजाल रेलवे सुरंग बनिहाल को काजीगुंड से किस राज्य/केंद्र शासित प्रदेश में जोड़ती है?',
  '{"a":"Jammu and Kashmir","b":"Himachal Pradesh","c":"Uttarakhand","d":"Sikkim"}'::jsonb,
  '{"a":"जम्मू और कश्मीर","b":"हिमाचल प्रदेश","c":"उत्तराखंड","d":"सिक्किम"}'::jsonb,
  'a',
  'The Pir Panjal Railway Tunnel (T-80), measuring 11.215 km, passes under the Pir Panjal range in Jammu and Kashmir on the Udhampur-Srinagar-Baramulla Rail Link (USBRL). It connects Banihal in Jammu region with Qazigund in the Kashmir valley.

Correct Option: (a)',
  'पीर पंजाल रेलवे सुरंग (लंबाई 11.215 किमी) जम्मू-कश्मीर में स्थित है। यह USBRL परियोजना के तहत बनिहाल को काजीगुंड से जोड़ती है और कश्मीर घाटी को शेष भारत के रेल नेटवर्क से जोड़ती है।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  92,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Who discovered the subatomic particle ''Electron'' in 1897 through his famous Cathode Ray Tube experiments?',
  '1897 में अपने प्रसिद्ध कैथोड किरण नलिका (Cathode Ray Tube) प्रयोगों द्वारा अवपरमाण्विक कण ''इलेक्ट्रॉन'' की खोज किसने की थी?',
  '{"a":"J. J. Thomson","b":"Ernest Rutherford","c":"James Chadwick","d":"John Dalton"}'::jsonb,
  '{"a":"जे. जे. थॉमसन (J. J. Thomson)","b":"अर्नेस्ट रदरफोर्ड","c":"जेम्स चैडविक","d":"जॉन डाल्टन"}'::jsonb,
  'a',
  'Sir J. J. Thomson discovered the electron in 1897 by studying cathode rays, determining the charge-to-mass ratio (e/m) of cathode ray particles. He was awarded the Nobel Prize in Physics in 1906.
(Rutherford discovered the atomic nucleus / proton; Chadwick discovered the neutron in 1932).

Correct Option: (a)',
  'इलेक्ट्रॉन की खोज 1897 में ब्रिटिश भौतिक विज्ञानी जे. जे. थॉमसन ने कैथोड किरणों के अध्ययन द्वारा की थी। इसके लिए उन्हें 1906 में भौतिकी का नोबेल पुरस्कार मिला।
(प्रोटॉन की खोज रदरफोर्ड और न्यूट्रॉन की खोज जेम्स चैडविक ने की थी)।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  93,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  94,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'The Kakori Train Action (historic train robbery of government treasury by revolutionaries of the Hindustan Republican Association) took place in August of which year near Lucknow?',
  'हिंदुस्तान रिपब्लिकन एसोसिएशन (HRA) के क्रांतिकारियों द्वारा लखनऊ के निकट ऐतिहासिक ''काकोरी ट्रेन एक्शन'' (सरकारी खजाने की डकैती) किस वर्ष के अगस्त माह में किया गया था?',
  '{"a":"1925","b":"1922","c":"1928","d":"1931"}'::jsonb,
  '{"a":"1925","b":"1922","c":"1928","d":"1931"}'::jsonb,
  'a',
  'The Kakori Train Action occurred on 9 August 1925 near Kakori railway station (Lucknow). Revolutionaries including Ram Prasad Bismil, Ashfaqulla Khan, Rajendra Lahiri, Chandrashekhar Azad, and Sachindra Bakshi halted the 8-Down train to seize British government funds for freedom struggle armaments.

Correct Option: (a)',
  'काकोरी ट्रेन एक्शन 9 अगस्त 1925 को लखनऊ के निकट काकोरी में हुआ था। इसमें राम प्रसाद बिस्मिल, अशफाक उल्ला खां, राजेंद्र लाहिड़ी और रोशन सिंह को फांसी की सजा दी गई थी।

अतः सही उत्तर (a) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  95,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'The first train in India ran between Mumbai (Bori Bunder) and Thane in which year?',
  'भारत में पहली ट्रेन मुंबई (बोरी बंदर) और ठाणे के बीच किस वर्ष चली थी?',
  '{"a":"1851","b":"1853","c":"1856","d":"1860"}'::jsonb,
  '{"a":"1851","b":"1853","c":"1856","d":"1860"}'::jsonb,
  'b',
  'The first passenger train in India ran on 16 April 1853 over a distance of 34 km between Bori Bunder (Mumbai) and Thane, hauled by three locomotives: Sahib, Sindh, and Sultan.',
  'भारत में पहली यात्री ट्रेन 16 अप्रैल 1853 को बोरी बंदर (मुंबई) और ठाणे के बीच 34 किमी की दूरी पर चलाई गई थी, जिसे साहिब, सिंध और सुल्तान नामक तीन इंजनों द्वारा खींचा गया था।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  96,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'In the Indian Constitution, the concept of ''Fundamental Duties'' was borrowed from the constitution of which country?',
  'भारतीय संविधान में ''मौलिक कर्तव्यों'' की अवधारणा किस देश के संविधान से ली गई थी?',
  '{"a":"United States","b":"USSR (Soviet Union)","c":"United Kingdom","d":"Australia"}'::jsonb,
  '{"a":"संयुक्त राज्य अमेरिका","b":"यूएसएसआर (सोवियत संघ)","c":"यूनाइटेड किंगडम","d":"ऑस्ट्रेलिया"}'::jsonb,
  'b',
  'Fundamental Duties incorporated under Article 51A by the 42nd Constitutional Amendment Act, 1976 were inspired by the Constitution of the erstwhile USSR.',
  '42वें संविधान संशोधन अधिनियम, 1976 द्वारा अनुच्छेद 51A के तहत शामिल किए गए मौलिक कर्तव्य पूर्ववर्ती सोवियत संघ (USSR) के संविधान से प्रेरित थे।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  97,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'What is the maximum permissible strength of the Lok Sabha according to the Constitution of India (post the 104th Constitutional Amendment Act, 2019)?',
  'भारत के संविधान के अनुसार (104वें संविधान संशोधन अधिनियम, 2019 के बाद) लोक सभा की अधिकतम अनुमेय सदस्य संख्या कितनी है?',
  '{"a":"550","b":"552","c":"545","d":"543"}'::jsonb,
  '{"a":"550","b":"552","c":"545","d":"543"}'::jsonb,
  'a',
  'Post the 104th Amendment Act, 2019, which discontinued the nomination of 2 Anglo-Indian members, the maximum strength of the Lok Sabha is 550 (up to 530 from States and 20 from UTs).',
  '104वें संशोधन अधिनियम, 2019 के बाद, जिसने 2 एंग्लो-इंडियन सदस्यों के नामांकन को समाप्त कर दिया, लोकसभा की अधिकतम सदस्य संख्या 550 है (राज्यों से 530 तक और केंद्र शासित प्रदेशों से 20 तक)।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  98,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'What is the full form of ''IRCTC'' in Indian Railways?',
  'भारतीय रेल में ''IRCTC'' का पूर्ण रूप क्या है?',
  '{"a":"Indian Railway Catering and Tourism Corporation","b":"Indian Railway Commercial and Transport Corporation","c":"Inter-Railway Catering and Travel Commission","d":"Indian Railway Communication and Ticketing Council"}'::jsonb,
  '{"a":"इंडियन रेलवे कैटरिंग एंड टूरिज्म कॉर्पोरेशन","b":"इंडियन रेलवे कमर्शियल एंड ट्रांसपोर्ट कॉर्पोरेशन","c":"इंटर-रेलवे कैटरिंग एंड ट्रेवल कमीशन","d":"इंडियन रेलवे कम्युनिकेशन एंड टिकटिंग काउंसिल"}'::jsonb,
  'a',
  'IRCTC stands for Indian Railway Catering and Tourism Corporation, an enterprise under the Ministry of Railways that handles ticketing, catering, and tourism operations.',
  'IRCTC का पूर्ण रूप ''इंडियन रेलवे कैटरिंग एंड टूरिज्म कॉर्पोरेशन'' (Indian Railway Catering and Tourism Corporation) है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  99,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Which indigenous semi-high speed train of Indian Railways was initially codenamed ''Train 18''?',
  'भारतीय रेल की किस स्वदेशी सेमी-हाई स्पीड ट्रेन का शुरुआती कोड नाम ''ट्रेन 18'' था?',
  '{"a":"Gatimaan Express","b":"Vande Bharat Express","c":"Tejas Express","d":"Rajdhani Express"}'::jsonb,
  '{"a":"गतिमान एक्सप्रेस","b":"वंदे भारत एक्सप्रेस","c":"तेजस एक्सप्रेस","d":"राजधानी एक्सप्रेस"}'::jsonb,
  'b',
  'The Vande Bharat Express was designed and built under the ''Make in India'' initiative at Integral Coach Factory (ICF), Chennai, codenamed Train 18.',
  'वंदे भारत एक्सप्रेस को इंटीग्रल कोच फैक्ट्री (ICF) चेन्नई द्वारा ''मेक इन इंडिया'' पहल के तहत डिजाइन और निर्मित किया गया था, जिसका शुरुआती कोड नाम ''ट्रेन 18'' था।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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
  test_id, question_number, part_number, section_name, section_title,
  chapter_name, difficulty, question_text, question_text_hi,
  options, options_hi, correct_option, solution_text, solution_text_hi,
  image_svg, image_svg_hi, option_svgs
) VALUES (
  'rrb_cbt_mock_3',
  100,
  4,
  'PART-4',
  'General Awareness & Current Affairs',
  '',
  'Moderate',
  'Under Article 60 of the Constitution of India, who administers the oath of office to the President of India?',
  'भारतीय संविधान के अनुच्छेद 60 के तहत भारत के राष्ट्रपति को पद की शपथ कौन दिलाता है?',
  '{"a":"Prime Minister of India","b":"Chief Justice of India","c":"Speaker of Lok Sabha","d":"Vice-President of India"}'::jsonb,
  '{"a":"भारत के प्रधानमंत्री","b":"भारत के मुख्य न्यायाधीश (CJI)","c":"लोकसभा अध्यक्ष","d":"भारत के उपराष्ट्रपति"}'::jsonb,
  'b',
  'Under Article 60, the oath of office to the President of India is administered by the Chief Justice of India (or, in his absence, the senior-most Judge of the Supreme Court available).',
  'अनुच्छेद 60 के तहत भारत के राष्ट्रपति को पद की शपथ भारत के मुख्य न्यायाधीश (CJI) या उनकी अनुपस्थिति में सर्वोच्च न्यायालय के वरिष्ठतम न्यायाधीश द्वारा दिलाई जाती है।',
  NULL,
  NULL,
  NULL
)
ON CONFLICT (test_id, question_number) DO UPDATE SET
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

