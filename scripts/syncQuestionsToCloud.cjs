const fs = require('fs');
const path = require('path');
const https = require('https');

const API_ENDPOINT = "https://zgxskpqsjylbwrhhrzim.supabase.co/rest/v1";
const API_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpneHNrcHFzanlsYndyaGhyemltIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODczODY0MDIsImV4cCI6MjEwMjk2MjQwMn0.1RSVtWx8gxJhQcmDfJMvRfRLMvl4ju9GuwxgiKn5f8w";

function postChunk(url, payload) {
  return new Promise((resolve, reject) => {
    const data = JSON.stringify(payload);
    const parsedUrl = new URL(url);
    const req = https.request({
      hostname: parsedUrl.hostname,
      path: parsedUrl.pathname + parsedUrl.search,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(data),
        'apikey': API_KEY,
        'Authorization': 'Bearer ' + API_KEY,
        'Prefer': 'resolution=merge-duplicates'
      }
    }, (res) => {
      let body = '';
      res.on('data', d => body += d);
      res.on('end', () => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          resolve({ status: res.statusCode, body });
        } else {
          resolve({ status: res.statusCode, error: body });
        }
      });
    });
    req.on('error', reject);
    req.write(data);
    req.end();
  });
}

async function syncAll() {
  const mocks = [
    { num: 1, testId: 'rrb_cbt_mock_1', file: 'mock1.json' },
    { num: 2, testId: 'rrb_cbt_mock_2', file: 'mock2.json' },
    { num: 3, testId: 'rrb_cbt_mock_3', file: 'mock3.json' }
  ];

  console.log("Starting cloud database questions sync...");
  let grandTotal = 0;

  for (const mock of mocks) {
    const filePath = path.join(__dirname, '..', 'src', 'data', mock.file);
    const questions = JSON.parse(fs.readFileSync(filePath, 'utf8'));

    const records = questions.map(q => {
      const qNum = q.question_number;
      const partNum = q.part_number || (qNum <= 25 ? 1 : qNum <= 50 ? 2 : qNum <= 80 ? 3 : 4);
      const isSci = partNum === 1 || qNum <= 25;

      return {
        test_id: mock.testId,
        question_number: qNum,
        part_number: partNum,
        section_name: q.section_name || `PART-${partNum}`,
        section_title: q.section_title || (partNum === 1 ? 'General Science' : partNum === 2 ? 'Mathematics' : partNum === 3 ? 'General Intelligence & Reasoning' : 'General Awareness'),
        chapter_name: q.chapter_name || '',
        difficulty: q.difficulty || 'Moderate',
        question_text: q.question_text || '',
        question_text_hi: q.question_text_hi || q.question_text || '',
        options: q.options || {},
        options_hi: q.options_hi || q.options || {},
        correct_option: (q.correct_option || 'a').toLowerCase(),
        solution_text: q.solution_text || '',
        solution_text_hi: q.solution_text_hi || q.solution_text || '',
        image_svg: isSci ? null : (q.image_svg || null),
        image_svg_hi: isSci ? null : (q.image_svg_hi || null),
        option_svgs: isSci ? null : (q.option_svgs || null)
      };
    });

    // Chunk in batches of 25
    const CHUNK_SIZE = 25;
    for (let i = 0; i < records.length; i += CHUNK_SIZE) {
      const chunk = records.slice(i, i + CHUNK_SIZE);
      const url = `${API_ENDPOINT}/questions?on_conflict=test_id,question_number`;
      const res = await postChunk(url, chunk);
      if (res.status >= 200 && res.status < 300) {
        grandTotal += chunk.length;
        console.log(`[${mock.testId}] Synced questions ${i + 1} to ${i + chunk.length}`);
      } else {
        console.warn(`[${mock.testId}] Notice for questions ${i + 1}-${i + chunk.length} (Status ${res.status}):`, res.error || 'Check schema columns in database');
      }
    }
  }

  console.log(`Sync process completed. Total synced: ${grandTotal}/300.`);
  console.log("Note: If schema columns (image_svg, option_svgs) are pending in the remote database, please execute src/sql/migrate_questions_with_svgs.sql in your database SQL editor.");
}

syncAll().catch(console.error);

