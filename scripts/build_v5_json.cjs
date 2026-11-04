const fs = require('fs');
const path = require('path');

// 1. Load base questions from mock_test_1_v4.json
const v4Path = path.join(__dirname, '..', 'RRB_NTPC_GRADUATE_MOCK', 'mock_test_1_v4.json');
const questions = JSON.parse(fs.readFileSync(v4Path, 'utf8'));

// Helper to ensure monochrome
function cleanMonochrome(svg) {
  if (!svg || typeof svg !== 'string') return svg;
  return svg
    .replace(/stroke=(\\?["'])(?!none|#000000|#000|black)[^\\"']+(\\?["'])/gi, (m, q1, q2) => `stroke=${q1}#000000${q2}`)
    .replace(/fill=(\\?["'])(#f8fafc|#f1f5f9|#e2e8f0|#e6f7f9|#f0fdf4|#eff6ff|#fafafa|#ffffff|white|#fff|#fef3c7|#f3e8ff|#dcfce7)(\\?["'])/gi, (m, q1, c, q2) => `fill=${q1}#ffffff${q2}`)
    .replace(/fill=(\\?["'])(?!none|#ffffff|#fff|white|#000000|#000|black)[^\\"']+(\\?["'])/gi, (m, q1, q2) => `fill=${q1}#000000${q2}`)
    .replace(/stroke:\s*(?!none|#000000|#000|black)[^;"]+/gi, 'stroke: #000000')
    .replace(/fill:\s*(?!none|#ffffff|#fff|white|#000000|#000|black)[^;"]+/gi, 'fill: #000000')
    .replace(/color:\s*(?!#000000|#000|black)[^;"]+/gi, 'color: #000000')
    .replace(/background:\s*[^;"]+/gi, 'background:#ffffff');
}

// -------------------------------------------------------------
// QUESTION 35: Triangle Counting (Clean Monochrome & Concise Options)
// -------------------------------------------------------------
const q35 = questions.find(q => q.question_number === 35);
if (q35) {
  q35.question_text = 'How many triangles are there in the given geometric figure?';
  q35.question_text_hi = 'दी गई ज्यामितीय आकृति में कुल कितने त्रिभुज हैं?';
  q35.options = { a: '12', b: '10', c: '14', d: '16' };
  q35.options_hi = { a: '12', b: '10', c: '14', d: '16' };
  q35.correct_option = 'a';
  q35.image_svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 340 240" width="100%" height="auto" style="max-width:340px; display:block; margin:10px auto; background:#ffffff;">
  <rect width="340" height="240" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <text x="170" y="24" text-anchor="middle" font-family="Arial, sans-serif" font-size="13" font-weight="bold" fill="#000000">Question Figure / प्रश्न आकृति</text>
  <!-- Main Outer Triangle ABC -->
  <polygon points="170,45 50,210 290,210" fill="none" stroke="#000000" stroke-width="2.5"/>
  <!-- Two internal division lines from Apex A (170,45) to base BC -->
  <line x1="170" y1="45" x2="130" y2="210" stroke="#000000" stroke-width="2"/>
  <line x1="170" y1="45" x2="210" y2="210" stroke="#000000" stroke-width="2"/>
  <!-- Horizontal dividing line DE parallel to base -->
  <line x1="110" y1="127" x2="230" y2="127" stroke="#000000" stroke-width="2"/>
  <!-- Vertex Labels -->
  <text x="170" y="38" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">A</text>
  <text x="40" y="215" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">B</text>
  <text x="300" y="215" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">C</text>
  <text x="98" y="132" text-anchor="middle" font-family="Arial, sans-serif" font-size="11" font-weight="bold" fill="#000000">D</text>
  <text x="242" y="132" text-anchor="middle" font-family="Arial, sans-serif" font-size="11" font-weight="bold" fill="#000000">E</text>
</svg>`;
  q35.image_svg_hi = q35.image_svg;
  q35.option_svgs = null;
  q35.solution_text = `Step 1: Formula for counting triangles in a partitioned triangle with apex A:
Base BC is divided into 3 segments: 1 + 2 + 3 = 6 triangles on base BC.
Step 2: Horizontal line DE forms an upper identical tier with base DE divided into 3 segments: 1 + 2 + 3 = 6 triangles on base DE.
Step 3: Total number of triangles = 6 (on base BC) + 6 (on base DE) = 12 triangles.

Correct Option: (a)`;
  q35.solution_text_hi = `चरण 1: शीर्ष A से आधार BC को 3 भागों में विभाजित करने पर बनने वाले त्रिभुज: 1 + 2 + 3 = 6 त्रिभुज।
चरण 2: क्षैतिज रेखा DE के आधार पर बनने वाले त्रिभुज: 1 + 2 + 3 = 6 त्रिभुज।
चरण 3: कुल त्रिभुजों की संख्या = 6 + 6 = 12 त्रिभुज।

अतः सही उत्तर विकल्प (a) है।`;
}

// -------------------------------------------------------------
// QUESTION 38: Unfolded Cube Net (Monochrome & Opposite Face 2)
// -------------------------------------------------------------
const q38 = questions.find(q => q.question_number === 38);
if (q38) {
  q38.question_text = "In the given unfolded net of a cube, which number will appear on the face opposite to the face with number '2' when the net is folded to form a cube?";
  q38.question_text_hi = "पासे के दिए गए खुले जाल (net) में, पासा बनाने के लिए जाल को मोड़ने पर संख्या '2' वाले फलक के विपरीत फलक पर कौन-सी संख्या होगी?";
  q38.options = { a: '4', b: '3', c: '5', d: '6' };
  q38.options_hi = { a: '4', b: '3', c: '5', d: '6' };
  q38.correct_option = 'a';
  q38.image_svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 340 250" width="100%" height="auto" style="max-width:340px; display:block; margin:10px auto; background:#ffffff;">
  <rect width="340" height="250" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <text x="170" y="24" text-anchor="middle" font-family="Arial, sans-serif" font-size="13" font-weight="bold" fill="#000000">Unfolded Cube Net / पासे का खुला जाल</text>
  <!-- Face 1 (Top Tab above Face 3) -->
  <rect x="145" y="40" width="50" height="50" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <text x="170" y="72" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">1</text>
  <!-- Middle Strip: Faces 2, 3, 4, 5 -->
  <!-- Face 2 -->
  <rect x="95" y="90" width="50" height="50" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <text x="120" y="122" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">2</text>
  <!-- Face 3 -->
  <rect x="145" y="90" width="50" height="50" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <text x="170" y="122" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">3</text>
  <!-- Face 4 -->
  <rect x="195" y="90" width="50" height="50" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <text x="220" y="122" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">4</text>
  <!-- Face 5 -->
  <rect x="245" y="90" width="50" height="50" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <text x="270" y="122" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">5</text>
  <!-- Face 6 (Bottom Tab below Face 3) -->
  <rect x="145" y="140" width="50" height="50" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <text x="170" y="172" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">6</text>
  <!-- Dashed Interior Fold Lines -->
  <line x1="145" y1="90" x2="195" y2="90" stroke="#000000" stroke-width="2" stroke-dasharray="4,3"/>
  <line x1="145" y1="140" x2="195" y2="140" stroke="#000000" stroke-width="2" stroke-dasharray="4,3"/>
  <line x1="145" y1="90" x2="145" y2="140" stroke="#000000" stroke-width="2" stroke-dasharray="4,3"/>
  <line x1="195" y1="90" x2="195" y2="140" stroke="#000000" stroke-width="2" stroke-dasharray="4,3"/>
  <line x1="245" y1="90" x2="245" y2="140" stroke="#000000" stroke-width="2" stroke-dasharray="4,3"/>
  <!-- Caption -->
  <text x="170" y="222" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" font-style="italic" fill="#000000">[ Strip: 2-3-4-5 | Tabs: 1 (Top), 6 (Bottom) ]</text>
</svg>`;
  q38.image_svg_hi = q38.image_svg;
  q38.option_svgs = null;
  q38.solution_text = `Step 1: Rule of opposite faces in an unfolded cube net:
In a straight strip of consecutive squares, alternate faces (separated by one square) are opposite to each other.

Step 2: Analyze the 4-face horizontal strip [2, 3, 4, 5]:
- Face 2 is alternate to Face 4 => 2 is opposite to 4.
- Face 3 is alternate to Face 5 => 3 is opposite to 5.

Step 3: Analyze the remaining top and bottom flaps:
- Face 1 is opposite to Face 6.

Therefore, the face opposite to face '2' is 4.
Correct Option: (a)`;
  q38.solution_text_hi = `चरण 1: पासे के खुले जाल में विपरीत फलकों का नियम:
किसी सीधी पट्टी में एक छोड़कर अगला फलक (एकांतर फलक) एक-दूसरे के विपरीत होता है।

चरण 2: क्षैतिज पट्टी [2, 3, 4, 5] का विश्लेषण:
- फलक 2 और फलक 4 एकांतर हैं => फलक 2 के विपरीत 4 है।
- फलक 3 और फलक 5 एकांतर हैं => फलक 3 के विपरीत 5 है।

चरण 3: शेष ऊपर और नीचे के फलक:
- फलक 1 के विपरीत फलक 6 है।

अतः संख्या '2' वाले फलक के विपरीत फलक पर '4' होगा।
सही उत्तर विकल्प (a) है।`;
}

// -------------------------------------------------------------
// QUESTION 39: Venn Diagram (Pure Monochrome & Concise Options)
// -------------------------------------------------------------
const q39 = questions.find(q => q.question_number === 39);
if (q39) {
  q39.question_text = "In the given Venn diagram, the Circle represents 'Engineers', the Rectangle represents 'Musicians', and the Triangle represents 'Chess Players'. Which number represents individuals who are both Engineers and Chess Players, but NOT Musicians?";
  q39.question_text_hi = "दिए गए वेन आरेख में, वृत्त 'अभियंताओं' को, आयत 'संगीतकारों' को, और त्रिभुज 'शतरंज खिलाड़ियों' को दर्शाता है। कौन सी संख्या उन व्यक्तियों को दर्शाती है जो अभियंता और शतरंज खिलाड़ी दोनों हैं, लेकिन संगीतकार नहीं हैं?";
  q39.options = { a: '8', b: '7', c: '9', d: '11' };
  q39.options_hi = { a: '8', b: '7', c: '9', d: '11' };
  q39.correct_option = 'a';
  q39.image_svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 420 280" width="100%" height="auto" style="max-width:420px; display:block; margin:10px auto; background:#ffffff;">
  <rect width="420" height="280" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <text x="210" y="24" text-anchor="middle" font-family="Arial, sans-serif" font-size="13" font-weight="bold" fill="#000000">Venn Diagram / वेन आरेख</text>
  
  <!-- Circle: Engineers -->
  <circle cx="160" cy="140" r="70" fill="none" stroke="#000000" stroke-width="2.5"/>
  <text x="110" y="62" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">Engineers (Circle)</text>
  
  <!-- Triangle: Chess Players -->
  <polygon points="230,55 140,210 320,210" fill="none" stroke="#000000" stroke-width="2.5"/>
  <text x="250" y="52" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">Chess Players (Triangle)</text>
  
  <!-- Rectangle: Musicians -->
  <rect x="70" y="140" width="280" height="90" fill="none" stroke="#000000" stroke-width="2" stroke-dasharray="6,3"/>
  <text x="210" y="250" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">Musicians (Rectangle)</text>
  
  <!-- Region Numbers -->
  <!-- Only Engineers: 14 -->
  <text x="120" y="115" font-family="Arial, sans-serif" font-size="16" font-weight="bold" fill="#000000">14</text>
  <!-- Engineers & Chess Players (outside Musicians): 8 -->
  <text x="185" y="125" font-family="Arial, sans-serif" font-size="18" font-weight="bold" fill="#000000">8</text>
  <!-- Only Chess Players (above rectangle): 11 -->
  <text x="235" y="115" font-family="Arial, sans-serif" font-size="16" font-weight="bold" fill="#000000">11</text>
  <!-- Engineers, Chess Players & Musicians: 7 -->
  <text x="185" y="170" font-family="Arial, sans-serif" font-size="16" font-weight="bold" fill="#000000">7</text>
  <!-- Engineers & Musicians only: 9 -->
  <text x="130" y="185" font-family="Arial, sans-serif" font-size="16" font-weight="bold" fill="#000000">9</text>
  <!-- Chess Players & Musicians only: 5 -->
  <text x="245" y="185" font-family="Arial, sans-serif" font-size="16" font-weight="bold" fill="#000000">5</text>
  <!-- Musicians only: 15 -->
  <text x="315" y="185" font-family="Arial, sans-serif" font-size="16" font-weight="bold" fill="#000000">15</text>
</svg>`;
  q39.image_svg_hi = q39.image_svg;
  q39.option_svgs = null;
  q39.solution_text = `Venn diagram region analysis:
- Circle = Engineers
- Triangle = Chess Players
- Rectangle = Musicians

Condition: Individuals who are both Engineers and Chess Players, but NOT Musicians.
- Intersection of Circle (Engineers) and Triangle (Chess Players) = regions 8 and 7.
- Region 7 falls inside the Rectangle (Musicians) and must be excluded.
- Region 8 falls completely outside the Rectangle.
Therefore, the number is 8.
Correct Option: (a)`;
  q39.solution_text_hi = `वेन आरेख का विश्लेषण:
- वृत्त = अभियंता (Engineers)
- त्रिभुज = शतरंज खिलाड़ी (Chess Players)
- आयत = संगीतकार (Musicians)

शर्त: वे व्यक्ति जो अभियंता और शतरंज खिलाड़ी दोनों हैं, लेकिन संगीतकार नहीं हैं।
- वृत्त और त्रिभुज का उभयनिष्ठ भाग = क्षेत्र 8 और 7।
- क्षेत्र 7 आयत (संगीतकार) के भीतर आता है, अतः इसे छोड़ देंगे।
- क्षेत्र 8 आयत के बाहर स्थित है।
अतः अभीष्ट संख्या 8 है।
सही उत्तर विकल्प (a) है।`;
}

// -------------------------------------------------------------
// QUESTION 53: Missing Number Matrix (Pure Monochrome Grid & Clean Math)
// -------------------------------------------------------------
const q53 = questions.find(q => q.question_number === 53);
if (q53) {
  q53.question_text = "Select the missing number from the given options that will replace the question mark (?) in the number matrix:";
  q53.question_text_hi = "दिए गए संख्या आव्यूह (matrix) में प्रश्न चिह्न (?) को प्रतिस्थापित करने वाली लुप्त संख्या का चयन करें:";
  q53.options = { a: '47', b: '51', c: '45', d: '49' };
  q53.options_hi = { a: '47', b: '51', c: '45', d: '49' };
  q53.correct_option = 'a';
  q53.image_svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 340 250" width="100%" height="auto" style="max-width:340px; display:block; margin:10px auto; background:#ffffff;">
  <rect width="340" height="250" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <text x="170" y="24" text-anchor="middle" font-family="Arial, sans-serif" font-size="13" font-weight="bold" fill="#000000">Number Matrix / संख्या आव्यूह</text>
  
  <!-- Outer Table Border (3 columns x 4 rows) -->
  <rect x="40" y="38" width="260" height="190" fill="#ffffff" stroke="#000000" stroke-width="2.5"/>
  
  <!-- Column Grid Lines (3 columns, width ~86.6px) -->
  <line x1="127" y1="38" x2="127" y2="228" stroke="#000000" stroke-width="1.8"/>
  <line x1="213" y1="38" x2="213" y2="228" stroke="#000000" stroke-width="1.8"/>
  
  <!-- Row Grid Lines (4 rows, height ~47.5px) -->
  <line x1="40" y1="85" x2="300" y2="85" stroke="#000000" stroke-width="1.8"/>
  <line x1="40" y1="133" x2="300" y2="133" stroke="#000000" stroke-width="1.8"/>
  <line x1="40" y1="180" x2="300" y2="180" stroke="#000000" stroke-width="1.8"/>
  
  <!-- Numbers Row 1 -->
  <text x="83" y="68" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">7</text>
  <text x="170" y="68" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">9</text>
  <text x="257" y="68" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">11</text>
  
  <!-- Numbers Row 2 -->
  <text x="83" y="115" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">4</text>
  <text x="170" y="115" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">5</text>
  <text x="257" y="115" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">6</text>
  
  <!-- Numbers Row 3 -->
  <text x="83" y="162" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">13</text>
  <text x="170" y="162" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">28</text>
  <text x="257" y="163" text-anchor="middle" font-family="Arial, sans-serif" font-size="24" font-weight="bold" fill="#000000">?</text>
  
  <!-- Numbers Row 4 -->
  <text x="83" y="210" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">33</text>
  <text x="170" y="210" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">53</text>
  <text x="257" y="210" text-anchor="middle" font-family="Arial, sans-serif" font-size="20" font-weight="bold" fill="#000000">73</text>
</svg>`;
  q53.image_svg_hi = q53.image_svg;
  q53.option_svgs = null;
  q53.solution_text = `Column-wise mathematical operation analysis:

Column 1:
- Row 3 = (Row 1 × Row 2) - 15 = (7 × 4) - 15 = 28 - 15 = 13.
- Row 4 = Row 3 + (Row 2 × 5) = 13 + (4 × 5) = 13 + 20 = 33.

Column 2:
- Row 3 = (Row 1 × Row 2) - 17 = (9 × 5) - 17 = 45 - 17 = 28.
- Row 4 = Row 3 + (Row 2 × 5) = 28 + (5 × 5) = 28 + 25 = 53.

Column 3:
- The subtraction constant increases by 2: (15 -> 17 -> 19).
- Row 3 = (Row 1 × Row 2) - 19 = (11 × 6) - 19 = 66 - 19 = 47.
- Row 4 check: Row 1 has difference +2 (7, 9, 11); Row 4 has difference +20 (33, 53, 73).

Therefore, the missing number replacing (?) is 47.
Correct Option: (a)`;
  q53.solution_text_hi = `स्तंभ-वार गणितीय संक्रिया का विश्लेषण:

स्तंभ 1 (Col 1):
- पंक्ति 3 = (पंक्ति 1 × पंक्ति 2) - 15 = (7 × 4) - 15 = 28 - 15 = 13
- पंक्ति 4 = पंक्ति 3 + (पंक्ति 2 × 5) = 13 + (4 × 5) = 13 + 20 = 33

स्तंभ 2 (Col 2):
- पंक्ति 3 = (पंक्ति 1 × पंक्ति 2) - 17 = (9 × 5) - 17 = 45 - 17 = 28
- पंक्ति 4 = पंक्ति 3 + (पंक्ति 2 × 5) = 28 + (5 × 5) = 28 + 25 = 53

स्तंभ 3 (Col 3):
- घटाने वाली संख्या 2 बढ़ती है: 15 -> 17 -> 19
- पंक्ति 3 = (पंक्ति 1 × पंक्ति 2) - 19 = (11 × 6) - 19 = 66 - 19 = 47
- पंक्ति 4 का सत्यापन: 33 + 20 = 53, 53 + 20 = 73 (सटीक AP)।

अतः प्रश्न चिह्न (?) का मान 47 होगा।
सही उत्तर विकल्प (a) है।`;
}

// -------------------------------------------------------------
// QUESTION 55: Mirror Image across Line MN (Visual Cards & Monochrome)
// -------------------------------------------------------------
const q55 = questions.find(q => q.question_number === 55);
if (q55) {
  q55.question_text = "Select the correct mirror image of the given figure when the vertical plane mirror is placed along the line MN as shown:";
  q55.question_text_hi = "दिए गए चित्र का सही दर्पण प्रतिबिम्ब चुनिए जब एक ऊर्ध्वाधर समतल दर्पण को दर्शाए अनुसार रेखा MN के अनुदिश रखा जाता है:";
  q55.options = { a: 'Figure (A)', b: 'Figure (B)', c: 'Figure (C)', d: 'Figure (D)' };
  q55.options_hi = { a: 'आकृति (A)', b: 'आकृति (B)', c: 'आकृति (C)', d: 'आकृति (D)' };
  q55.correct_option = 'a';
  q55.image_svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 440 220" width="100%" height="auto" style="max-width:440px; display:block; margin:10px auto; background:#ffffff;">
  <rect width="440" height="220" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  
  <!-- Left Box: Object / मूल आकृति -->
  <g transform="translate(45, 30)">
    <rect x="0" y="0" width="120" height="120" fill="#ffffff" stroke="#000000" stroke-width="2.5"/>
    <!-- Diagonal partition from top-left to bottom-right -->
    <line x1="0" y1="0" x2="120" y2="120" stroke="#000000" stroke-width="2"/>
    <!-- Top-Right Half: Flagpole & Flag pointing Right -->
    <line x1="80" y1="50" x2="80" y2="18" stroke="#000000" stroke-width="2"/>
    <polygon points="80,18 112,28 80,38" fill="#000000" stroke="#000000" stroke-width="1"/>
    <!-- Bottom-Left Half: Clock showing 9 o'clock -->
    <circle cx="40" cy="85" r="18" fill="#ffffff" stroke="#000000" stroke-width="2"/>
    <line x1="40" y1="85" x2="40" y2="71" stroke="#000000" stroke-width="2.5"/>
    <line x1="40" y1="85" x2="28" y2="85" stroke="#000000" stroke-width="2.5"/>
    <!-- Bottom-Right Corner: Solid black triangle -->
    <polygon points="90,120 120,90 120,120" fill="#000000"/>
    <text x="60" y="145" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">Object / मूल आकृति</text>
  </g>
  
  <!-- Vertical Mirror Line MN -->
  <line x1="220" y1="20" x2="220" y2="180" stroke="#000000" stroke-width="2.5" stroke-dasharray="6,4"/>
  <text x="220" y="14" text-anchor="middle" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">M</text>
  <text x="220" y="196" text-anchor="middle" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="#000000">N</text>
  
  <!-- Right Box: Mirror Image Question Frame -->
  <g transform="translate(275, 30)">
    <rect x="0" y="0" width="120" height="120" fill="#ffffff" stroke="#000000" stroke-width="2" stroke-dasharray="5,4"/>
    <text x="60" y="78" text-anchor="middle" font-family="Arial, sans-serif" font-size="44" font-weight="bold" fill="#000000">?</text>
    <text x="60" y="145" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" font-weight="bold" fill="#000000">Mirror Image / दर्पण प्रतिबिम्ब</text>
  </g>
</svg>`;
  q55.image_svg_hi = q55.image_svg;

  // Four visual option SVGs for Question 55
  q55.option_svgs = {
    // Option A: EXACT CORRECT REFLECTION
    a: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100%" height="100%" style="background:#ffffff;">
  <rect x="5" y="5" width="90" height="90" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <!-- Reflected diagonal: top-right to bottom-left -->
  <line x1="95" y1="5" x2="5" y2="95" stroke="#000000" stroke-width="1.8"/>
  <!-- Reflected flag: in top-left, pointing LEFT -->
  <line x1="40" y1="42" x2="40" y2="18" stroke="#000000" stroke-width="1.8"/>
  <polygon points="40,18 16,26 40,34" fill="#000000"/>
  <!-- Reflected clock: in bottom-right, minute hand up (12), hour hand right (3 o'clock) -->
  <circle cx="68" cy="68" r="14" fill="#ffffff" stroke="#000000" stroke-width="1.8"/>
  <line x1="68" y1="68" x2="68" y2="57" stroke="#000000" stroke-width="2"/>
  <line x1="68" y1="68" x2="77" y2="68" stroke="#000000" stroke-width="2"/>
  <!-- Reflected solid corner triangle: in bottom-left -->
  <polygon points="5,72 28,95 5,95" fill="#000000"/>
</svg>`,

    // Option B: DISTRACTOR 1 (Water Image / Upside Down)
    b: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100%" height="100%" style="background:#ffffff;">
  <rect x="5" y="5" width="90" height="90" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <line x1="5" y1="95" x2="95" y2="5" stroke="#000000" stroke-width="1.8"/>
  <!-- Flag upside down at bottom -->
  <line x1="60" y1="58" x2="60" y2="82" stroke="#000000" stroke-width="1.8"/>
  <polygon points="60,82 84,74 60,66" fill="#000000"/>
  <!-- Clock at top-left -->
  <circle cx="32" cy="32" r="14" fill="#ffffff" stroke="#000000" stroke-width="1.8"/>
  <line x1="32" y1="32" x2="32" y2="43" stroke="#000000" stroke-width="2"/>
  <line x1="32" y1="32" x2="23" y2="32" stroke="#000000" stroke-width="2"/>
  <polygon points="72,5 95,5 95,28" fill="#000000"/>
</svg>`,

    // Option C: DISTRACTOR 2 (Partial reflection: diagonal unreflected)
    c: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100%" height="100%" style="background:#ffffff;">
  <rect x="5" y="5" width="90" height="90" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <!-- Unreflected diagonal (top-left to bottom-right) -->
  <line x1="5" y1="5" x2="95" y2="95" stroke="#000000" stroke-width="1.8"/>
  <line x1="40" y1="42" x2="40" y2="18" stroke="#000000" stroke-width="1.8"/>
  <polygon points="40,18 16,26 40,34" fill="#000000"/>
  <circle cx="68" cy="68" r="14" fill="#ffffff" stroke="#000000" stroke-width="1.8"/>
  <line x1="68" y1="68" x2="68" y2="57" stroke="#000000" stroke-width="2"/>
  <line x1="68" y1="68" x2="77" y2="68" stroke="#000000" stroke-width="2"/>
  <polygon points="5,72 28,95 5,95" fill="#000000"/>
</svg>`,

    // Option D: DISTRACTOR 3 (Flag pointing right & clock unreflected showing 9 o'clock)
    d: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100%" height="100%" style="background:#ffffff;">
  <rect x="5" y="5" width="90" height="90" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <line x1="95" y1="5" x2="5" y2="95" stroke="#000000" stroke-width="1.8"/>
  <!-- Flag at top-left but pointing RIGHT (incorrect lateral flip) -->
  <line x1="25" y1="42" x2="25" y2="18" stroke="#000000" stroke-width="1.8"/>
  <polygon points="25,18 49,26 25,34" fill="#000000"/>
  <!-- Clock at bottom-right showing 9 o'clock (unreflected hands) -->
  <circle cx="68" cy="68" r="14" fill="#ffffff" stroke="#000000" stroke-width="1.8"/>
  <line x1="68" y1="68" x2="68" y2="57" stroke="#000000" stroke-width="2"/>
  <line x1="68" y1="68" x2="59" y2="68" stroke="#000000" stroke-width="2"/>
  <polygon points="5,72 28,95 5,95" fill="#000000"/>
</svg>`
  };

  q55.solution_text = `Lateral inversion across vertical mirror line MN:
1. Diagonal Partition: The diagonal runs from top-left (0,0) to bottom-right (120,120). In a vertical mirror reflection, this inverts laterally to run from top-right to bottom-left.
2. Flag: Originally in the top-right quadrant pointing right. In the mirror image, it shifts to the top-left quadrant and points LEFT.
3. Clock: Originally in the bottom-left quadrant showing 9 o'clock (minute hand at 12, hour hand at 9). In the mirror image, it shifts to the bottom-right quadrant; the minute hand remains at 12 while the hour hand inverts horizontally to point at 3 (showing 3 o'clock).
4. Shaded Triangle: Originally in the bottom-right corner. It inverts laterally to the bottom-left corner.

All four transformations match Figure (A) exactly.
Correct Option: (a)`;
  q55.solution_text_hi = `ऊर्ध्वाधर दर्पण रेखा MN के अनुदिश पार्श्व परिवर्तन (Lateral Inversion):
1. विकर्ण विभाजन: मूल आकृति में विकर्ण ऊपर-बाएँ से नीचे-दाएँ है। दर्पण में यह ऊपर-दाएँ से नीचे-बाएँ हो जाएगा।
2. झंडा (Flag): मूल आकृति में ऊपर-दाएँ भाग में दाएँ इंगित कर रहा है। दर्पण में यह ऊपर-बाएँ भाग में आ जाएगा और बाएँ इंगित करेगा।
3. घड़ी (Clock): मूल आकृति में नीचे-बाएँ भाग में 9 बजा रही है (घंटे की सुई बाएँ)। दर्पण में यह नीचे-दाएँ भाग में आ जाएगी और 3 बजाएगी (घंटे की सुई दाएँ)।
4. छायांकित त्रिभुज (Shaded Corner): नीचे-दाएँ कोने से बदलकर नीचे-बाएँ कोने में आ जाएगा।

ये सभी परिवर्तन आकृति (A) से पूर्णतः मेल खाते हैं।
अतः सही उत्तर विकल्प (a) है।`;
}

// -------------------------------------------------------------
// QUESTION 60: 3x3 Transformation Matrix (Visual Cards & Monochrome)
// -------------------------------------------------------------
const q60 = questions.find(q => q.question_number === 60);
if (q60) {
  q60.question_text = "Select the figure that will replace the question mark (?) in the 3x3 transformation matrix:";
  q60.question_text_hi = "3x3 रूपांतरण आव्यूह (transformation matrix) में प्रश्न चिह्न (?) को प्रतिस्थापित करने वाली आकृति का चयन करें:";
  q60.options = { a: 'Figure (A)', b: 'Figure (B)', c: 'Figure (C)', d: 'Figure (D)' };
  q60.options_hi = { a: 'आकृति (A)', b: 'आकृति (B)', c: 'आकृति (C)', d: 'आकृति (D)' };
  q60.correct_option = 'a';
  q60.image_svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 340 340" width="100%" height="auto" style="max-width:340px; display:block; margin:10px auto; background:#ffffff;">
  <rect width="340" height="340" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  
  <!-- Outer 3x3 Grid Box (270 x 270) -->
  <rect x="35" y="25" width="270" height="270" fill="#ffffff" stroke="#000000" stroke-width="2.5"/>
  <line x1="125" y1="25" x2="125" y2="295" stroke="#000000" stroke-width="1.8"/>
  <line x1="215" y1="25" x2="215" y2="295" stroke="#000000" stroke-width="1.8"/>
  <line x1="35" y1="115" x2="305" y2="115" stroke="#000000" stroke-width="1.8"/>
  <line x1="35" y1="205" x2="305" y2="205" stroke="#000000" stroke-width="1.8"/>
  
  <!-- Row 1: Outer Circles; Pointer rotating +45° CW (Up, Up-Right, Right) -->
  <!-- Cell (1,1): Circle, Pointer Up (12 o'clock) -->
  <circle cx="80" cy="70" r="24" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <line x1="80" y1="70" x2="80" y2="50" stroke="#000000" stroke-width="2.5"/>
  <circle cx="80" cy="50" r="2.5" fill="#000000"/>
  
  <!-- Cell (1,2): Circle, Pointer Up-Right (+45° / 1:30) -->
  <circle cx="170" cy="70" r="24" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <line x1="170" y1="70" x2="184" y2="56" stroke="#000000" stroke-width="2.5"/>
  <circle cx="184" cy="56" r="2.5" fill="#000000"/>
  
  <!-- Cell (1,3): Circle, Pointer Right (+45° / 3 o'clock) -->
  <circle cx="260" cy="70" r="24" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <line x1="260" y1="70" x2="280" y2="70" stroke="#000000" stroke-width="2.5"/>
  <circle cx="280" cy="70" r="2.5" fill="#000000"/>
  
  <!-- Row 2: Outer Squares; Pointer rotating +45° CW (Right, Down-Right, Down) -->
  <!-- Cell (2,1): Square, Pointer Right (3 o'clock) -->
  <rect x="58" y="138" width="44" height="44" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <line x1="80" y1="160" x2="100" y2="160" stroke="#000000" stroke-width="2.5"/>
  <circle cx="100" cy="160" r="2.5" fill="#000000"/>
  
  <!-- Cell (2,2): Square, Pointer Down-Right (+45° / 4:30) -->
  <rect x="148" y="138" width="44" height="44" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <line x1="170" y1="160" x2="184" y2="174" stroke="#000000" stroke-width="2.5"/>
  <circle cx="184" cy="174" r="2.5" fill="#000000"/>
  
  <!-- Cell (2,3): Square, Pointer Down (+45° / 6 o'clock) -->
  <rect x="238" y="138" width="44" height="44" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <line x1="260" y1="160" x2="260" y2="180" stroke="#000000" stroke-width="2.5"/>
  <circle cx="260" cy="180" r="2.5" fill="#000000"/>
  
  <!-- Row 3: Outer Triangles; Pointer rotating +45° CW (Down, Down-Left, ?) -->
  <!-- Cell (3,1): Triangle, Pointer Down (6 o'clock) -->
  <polygon points="80,222 56,272 104,272" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <line x1="80" y1="252" x2="80" y2="272" stroke="#000000" stroke-width="2.5"/>
  <circle cx="80" cy="272" r="2.5" fill="#000000"/>
  
  <!-- Cell (3,2): Triangle, Pointer Down-Left (+45° / 7:30) -->
  <polygon points="170,222 146,272 194,272" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <line x1="170" y1="252" x2="156" y2="266" stroke="#000000" stroke-width="2.5"/>
  <circle cx="156" cy="266" r="2.5" fill="#000000"/>
  
  <!-- Cell (3,3): Question Mark Box -->
  <rect x="225" y="215" width="70" height="70" fill="#ffffff" stroke="#000000" stroke-width="2" stroke-dasharray="5,4"/>
  <text x="260" y="260" text-anchor="middle" font-family="Arial, sans-serif" font-size="36" font-weight="bold" fill="#000000">?</text>
  
  <!-- Caption -->
  <text x="170" y="320" text-anchor="middle" font-family="Arial, sans-serif" font-size="12" font-style="italic" fill="#000000">[ 3x3 Transformation Matrix / 3x3 आकृति आव्यूह ]</text>
</svg>`;
  q60.image_svg_hi = q60.image_svg;

  // Four visual option SVGs for Question 60
  q60.option_svgs = {
    // Option A: CORRECT - Equilateral Triangle with pointer pointing directly LEFT (West / 9:00)
    a: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 90 90" width="100%" height="100%" style="background:#ffffff;">
  <polygon points="45,15 18,72 72,72" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <circle cx="45" cy="52" r="3" fill="#000000"/>
  <line x1="45" y1="52" x2="23" y2="52" stroke="#000000" stroke-width="2.5"/>
  <circle cx="23" cy="52" r="2.5" fill="#000000"/>
</svg>`,

    // Option B: DISTRACTOR 1 (Square with pointer Up)
    b: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 90 90" width="100%" height="100%" style="background:#ffffff;">
  <rect x="22" y="22" width="46" height="46" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <circle cx="45" cy="45" r="3" fill="#000000"/>
  <line x1="45" y1="45" x2="45" y2="25" stroke="#000000" stroke-width="2.5"/>
  <circle cx="45" cy="25" r="2.5" fill="#000000"/>
</svg>`,

    // Option C: DISTRACTOR 2 (Circle with pointer Down-Left)
    c: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 90 90" width="100%" height="100%" style="background:#ffffff;">
  <circle cx="45" cy="45" r="24" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <circle cx="45" cy="45" r="3" fill="#000000"/>
  <line x1="45" y1="45" x2="28" y2="62" stroke="#000000" stroke-width="2.5"/>
  <circle cx="28" cy="62" r="2.5" fill="#000000"/>
</svg>`,

    // Option D: DISTRACTOR 3 (Triangle with pointer pointing Up-Right)
    d: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 90 90" width="100%" height="100%" style="background:#ffffff;">
  <polygon points="45,15 18,72 72,72" fill="#ffffff" stroke="#000000" stroke-width="2"/>
  <circle cx="45" cy="52" r="3" fill="#000000"/>
  <line x1="45" y1="52" x2="62" y2="35" stroke="#000000" stroke-width="2.5"/>
  <circle cx="62" cy="35" r="2.5" fill="#000000"/>
</svg>`
  };

  q60.solution_text = `Two independent transformation rules govern the 3x3 matrix:
1. Outer Geometric Shape Rule:
   - Row 1: Outer shape is a Circle.
   - Row 2: Outer shape is a Square.
   - Row 3: Outer shape is an Equilateral Triangle. Therefore, the figure replacing (?) must be an Equilateral Triangle.

2. Inner Pointer Direction Rule (45° Clockwise Rotation):
   - Row 1: Up (12:00) -> Up-Right (1:30, +45°) -> Right (3:00, +45°).
   - Row 2: Right (3:00) -> Down-Right (4:30, +45°) -> Down (6:00, +45°).
   - Row 3: Down (6:00) -> Down-Left (7:30, +45°) -> Left (9:00, +45°).

Thus, the missing figure is an Equilateral Triangle with an inner pointer pointing directly Left (West). This matches Figure (A) exactly.
Correct Option: (a)`;
  q60.solution_text_hi = `3x3 आव्यूह (Matrix) के दो स्वतंत्र नियम:
1. बाहरी ज्यामितीय आकृति का नियम:
   - पंक्ति 1: प्रत्येक सेल में वृत्त (Circle) है।
   - पंक्ति 2: प्रत्येक सेल में वर्ग (Square) है।
   - पंक्ति 3: प्रत्येक सेल में समबाहु त्रिभुज (Equilateral Triangle) है। अतः लुप्त आकृति भी समबाहु त्रिभुज होगी।

2. आंतरिक संकेतक (Pointer) की घूर्णन दिशा (+45° दक्षिणावर्त / CW):
   - पंक्ति 1: ऊपर (12:00) -> उत्तर-पूर्व (1:30) -> पूर्व/दाएँ (3:00)
   - पंक्ति 2: पूर्व/दाएँ (3:00) -> दक्षिण-पूर्व (4:30) -> दक्षिण/नीचे (6:00)
   - पंक्ति 3: दक्षिण/नीचे (6:00) -> दक्षिण-पश्चिम (7:30) -> पश्चिम/बाएँ (9:00)

अतः प्रश्न चिह्न (?) वाली आकृति एक समबाहु त्रिभुज होगी जिसके भीतर संकेतक ठीक बाएँ (पश्चिम दिशा) में होगा। यह आकृति (A) से पूर्णतः मेल खाती है।
सही उत्तर विकल्प (a) है।`;
}

// -------------------------------------------------------------
// ENFORCE MONOCHROME ACROSS ALL 100 QUESTIONS
// -------------------------------------------------------------
questions.forEach(q => {
  if (q.image_svg) q.image_svg = cleanMonochrome(q.image_svg);
  if (q.image_svg_hi) q.image_svg_hi = cleanMonochrome(q.image_svg_hi);
  if (q.option_svgs && typeof q.option_svgs === 'object') {
    for (const key of Object.keys(q.option_svgs)) {
      q.option_svgs[key] = cleanMonochrome(q.option_svgs[key]);
    }
  }
});

// 2. Save to RRB_NTPC_GRADUATE_MOCK/mock_test_1_v5.json
const v5Path = path.join(__dirname, '..', 'RRB_NTPC_GRADUATE_MOCK', 'mock_test_1_v5.json');
fs.writeFileSync(v5Path, JSON.stringify(questions, null, 2), 'utf8');
console.log(`Saved 100 questions to ${v5Path}`);
