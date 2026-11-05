/**
 * Push migrate_pyq_reasoning.sql directly to the Remote PostgreSQL Database via terminal
 * 
 * Usage options:
 *   node scripts/pushPyqSql.cjs --password="YOUR_DB_PASSWORD"
 *   node scripts/pushPyqSql.cjs --url="postgresql://postgres.zgxskpqsjylbwrhhrzim:YOUR_PASSWORD@aws-0-ap-south-1.pooler.supabase.com:6543/postgres"
 */

const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

const args = process.argv.slice(2);
let dbPassword = null;
let customUrl = null;
let host = 'aws-0-ap-south-1.pooler.supabase.com'; // Default pooler or db host
let projectRef = 'zgxskpqsjylbwrhhrzim';

for (const arg of args) {
  if (arg.startsWith('--password=')) dbPassword = arg.split('=')[1];
  else if (arg.startsWith('--url=')) customUrl = arg.split('=')[1];
  else if (arg.startsWith('--host=')) host = arg.split('=')[1];
  else if (arg.startsWith('--project=')) projectRef = arg.split('=')[1];
}

const sqlPath = path.resolve(__dirname, '..', 'migrate_pyq_reasoning.sql');
if (!fs.existsSync(sqlPath)) {
  console.error(`Error: SQL file not found at ${sqlPath}`);
  process.exit(1);
}

let connectionString = customUrl;
if (!connectionString) {
  if (!dbPassword) {
    console.error('===================================================================');
    console.error('ERROR: Database password or connection URL required.');
    console.error('Usage:');
    console.error('  node scripts/pushPyqSql.cjs --password="YOUR_DATABASE_PASSWORD"');
    console.error('Or:');
    console.error('  node scripts/pushPyqSql.cjs --url="postgresql://postgres.[REF]:[PASS]@[HOST]:6543/postgres"');
    console.error('===================================================================');
    process.exit(1);
  }
  // Try transaction pooler connection first (port 6543)
  connectionString = `postgresql://postgres.${projectRef}:${encodeURIComponent(dbPassword)}@${host}:6543/postgres?sslmode=require`;
}

async function run() {
  console.log('===================================================================');
  console.log('Pushing PYQ Reasoning SQL Migration to Remote Database');
  console.log(`Source File: ${sqlPath} (${(fs.statSync(sqlPath).size / 1024 / 1024).toFixed(2)} MB)`);
  console.log('===================================================================');

  const client = new Client({
    connectionString,
    ssl: { rejectUnauthorized: false }
  });

  try {
    console.log('Connecting to Remote PostgreSQL Database...');
    await client.connect();
    console.log('Connected successfully!\n');

    console.log('Reading SQL file...');
    const fullSql = fs.readFileSync(sqlPath, 'utf8');
    console.log(`Loaded ${fullSql.length} characters.`);

    console.log('Executing SQL migration in progress (this may take 1-2 minutes for 990 questions)...');
    const startTime = Date.now();

    await client.query(fullSql);

    const duration = ((Date.now() - startTime) / 1000).toFixed(1);
    console.log(`\nMigration completed successfully in ${duration} seconds!`);

    // Verify row count
    const res = await client.query('SELECT count(*) FROM public.rrb_ntpc_graduate_pyqs;');
    console.log(`Total verified rows in public.rrb_ntpc_graduate_pyqs: ${res.rows[0].count}`);

    await client.end();
    console.log('Connection closed. All 990 PYQs are live on Remote Database!');
  } catch (err) {
    console.error('\nDatabase Execution Error:', err.message);
    if (err.message.includes('password authentication failed')) {
      console.error('\nPlease double check your database password in Project Settings -> Database.');
    }
    await client.end().catch(() => {});
    process.exit(1);
  }
}

run();
