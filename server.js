'use strict';

const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3001;
const DATA_FILE = path.join(__dirname, 'data', 'download-requests.json');

app.use(cors());
app.use(express.json());

function ensureDataFile() {
  const dir = path.dirname(DATA_FILE);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
  if (!fs.existsSync(DATA_FILE)) {
    fs.writeFileSync(DATA_FILE, '[]', 'utf8');
  }
}

function readRequests() {
  ensureDataFile();
  return JSON.parse(fs.readFileSync(DATA_FILE, 'utf8'));
}

function writeRequests(requests) {
  ensureDataFile();
  fs.writeFileSync(DATA_FILE, JSON.stringify(requests, null, 2), 'utf8');
}

app.post('/api/download-requests', (req, res) => {
  const entry = req.body.data || req.body;

  if (!entry.name || !entry.email) {
    return res.status(400).json({ error: 'name and email are required' });
  }

  const record = {
    id: Date.now(),
    name: String(entry.name).substring(0, 200),
    email: String(entry.email).substring(0, 200),
    document: String(entry.document || '').substring(0, 500),
    url: String(entry.url || '').substring(0, 1000),
    date: entry.date || new Date().toISOString(),
    language: String(entry.language || '').substring(0, 5),
  };

  const requests = readRequests();
  requests.push(record);
  writeRequests(requests);

  res.json({ data: record });
});

app.get('/api/download-requests', (req, res) => {
  res.json({ data: readRequests() });
});

app.listen(PORT, () => {
  console.log(`Download API running on port ${PORT}`);
});
