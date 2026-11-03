/**
 * Automated Reusable Runner for RRB NTPC Graduate Level Mocks
 * Usage:
 *   node scripts/syncNtpcMock.cjs --file=RRB_NTPC_GRADUATE_MOCK/mock_test_1_v2.json --mock=1
 *   node scripts/syncNtpcMock.cjs --file=RRB_NTPC_GRADUATE_MOCK/mock_test_2.json --mock=2
 */

const fs = require('fs');
const path = require('path');
const https = require('https');

// Remote database configuration
const API_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpneHNrcHFzanlsYndyaGhyemltIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODczODY0MDIsImV4cCI6MjEwMjk2MjQwMn0.1RSVtWx8gxJhQcmDfJMvRfRLMvl4ju9GuwxgiKn5f8w';
const BASE_HOST = 'zgxskpqsjylbwrhhrzim.supabase.co';

// Parse command line arguments
const args = process.argv.slice(2);
let filePath = null;
let mockNumber = null;

for (const arg of args) {
  if (arg.startsWith('--file=')) filePath = arg.split('=')[1];
  else if (arg.startsWith('--mock=')) mockNumber = parseInt(arg.split('=')[1], 10);
}

if (!filePath) {
  if (fs.existsSync('RRB_NTPC_GRADUATE_MOCK/mock_test_1_v2.json')) {
    filePath = 'RRB_NTPC_GRADUATE_MOCK/mock_test_1_v2.json';
  } else {
    filePath = 'RRB_NTPC_GRADUATE_MOCK/mock_test_1.json';
  }
}
if (!mockNumber) {
  const match = filePath.match(/mock_test_(\d+)/i) || filePath.match(/mock_(\d+)/i);
  mockNumber = match ? parseInt(match[1], 10) : 1;
}

const resolvedPath = path.resolve(filePath);
if (!fs.existsSync(resolvedPath)) {
  console.error(`Error: Question JSON file not found at: ${resolvedPath}`);
  process.exit(1);
}

const rawQuestions = JSON.parse(fs.readFileSync(resolvedPath, 'utf8'));
const testId = `rrb_ntpc_graduate_mock_${mockNumber}`;
const testTitle = `RRB NTPC (Graduate Level) CBT-1 Mock Test 0${mockNumber}`;

console.log(`================================================================`);
console.log(`Syncing RRB NTPC Graduate Mock Test (Fresh Version)`);
console.log(`  Test ID:       ${testId}`);
console.log(`  Test Title:    ${testTitle}`);
console.log(`  Source File:   ${resolvedPath}`);
console.log(`  Questions:     ${rawQuestions.length}`);
console.log(`================================================================`);

function apiRequest(endpoint, method, payload = null) {
  return new Promise((resolve, reject) => {
    const postData = payload ? JSON.stringify(payload) : null;
    const req = https.request({
      hostname: BASE_HOST,
      path: endpoint,
      method: method,
      headers: {
        'apikey': API_KEY,
        'Authorization': `Bearer ${API_KEY}`,
        'Content-Type': 'application/json',
        'Prefer': 'resolution=merge-duplicates,return=representation',
        ...(postData ? { 'Content-Length': Buffer.byteLength(postData) } : {})
      }
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        resolve({ status: res.statusCode, data });
      });
    });

    req.on('error', reject);
    if (postData) req.write(postData);
    req.end();
  });
}

async function run() {
  try {
    // 1. Ensure test is registered in mock_tests table
    console.log(`Registering/updating test ${testId} in mock_tests...`);
    const regRes = await apiRequest(`/rest/v1/mock_tests?on_conflict=id`, 'POST', [{
      id: testId,
      title: testTitle,
      total_questions: rawQuestions.length,
      total_time_minutes: 90,
      sectional_time_minutes: 0,
      has_sectional_timing: false
    }]);
    console.log(`Test metadata status: ${regRes.status}`);

    // 2. Clean slate: Delete existing questions for this test to ensure 100% fresh questions
    console.log(`Cleaning old questions for ${testId}...`);
    const delRes = await apiRequest(`/rest/v1/questions?test_id=eq.${testId}`, 'DELETE');
    console.log(`Delete prior questions status: ${delRes.status}`);

    // 3. Format questions according to remote database schema
    const formatted = rawQuestions.map((q, idx) => {
      const qNum = q.question_number || (idx + 1);
      const partNum = q.part_number || (qNum <= 30 ? 1 : qNum <= 60 ? 2 : 3);
      const secName = q.section_name || `PART-${partNum}`;
      const secTitle = q.section_title || (partNum === 1 ? 'Mathematics' : partNum === 2 ? 'General Intelligence & Reasoning' : 'General Awareness');

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

      const imageSvg = q.image_svg || q.svg_content || extractedSvgEn || extractedSvgHi || null;
      const imageSvgHi = q.image_svg_hi || extractedSvgHi || imageSvg || null;

      return {
        test_id: testId,
        question_number: qNum,
        part_number: partNum,
        section_name: secName,
        section_title: secTitle,
        chapter_name: q.chapter_name || q.topic || '',
        difficulty: q.difficulty || 'Moderate',
        question_text: qText,
        question_text_hi: qTextHi,
        options: q.options,
        options_hi: q.options_hi || q.options,
        correct_option: (q.correct_option || 'A').toLowerCase(),
        solution_text: q.solution_text || '',
        solution_text_hi: q.solution_text_hi || q.solution_text || '',
        image_svg: imageSvg,
        image_svg_hi: imageSvgHi,
        option_svgs: q.option_svgs || null
      };
    });

    // 4. Upload fresh questions in chunks of 25
    const CHUNK_SIZE = 25;
    for (let i = 0; i < formatted.length; i += CHUNK_SIZE) {
      const chunk = formatted.slice(i, i + CHUNK_SIZE);
      const range = `${i + 1} - ${Math.min(i + CHUNK_SIZE, formatted.length)}`;
      process.stdout.write(`Uploading fresh questions ${range}... `);

      const res = await apiRequest(`/rest/v1/questions?on_conflict=test_id,question_number`, 'POST', chunk);
      if (res.status === 201 || res.status === 200) {
        console.log(`[OK ${res.status}]`);
      } else {
        console.log(`[Error ${res.status}]: ${res.data.slice(0, 200)}`);
      }
    }

    console.log(`\nSuccessfully synced all ${formatted.length} fresh questions from mock_test_1_v2.json to remote database!`);
  } catch (err) {
    console.error('Fatal sync error:', err);
    process.exit(1);
  }
}

run();
