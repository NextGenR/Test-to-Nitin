import React from 'react';
import katex from 'katex';
import 'katex/dist/katex.min.css';

/**
 * Clean up text encoding artifacts & common units
 */
function sanitizeText(raw) {
  if (!raw || typeof raw !== 'string') return '';
  return raw
    .replace(/m\/s\uFFFD/g, 'm/s²')
    .replace(/m\/sA/g, 'm/s²')
    .replace(/\uFFFDC/g, '°C')
    .replace(/\s*C(?=[,\.\s]|$)/g, '°C')
    .replace(/\uFFFD/g, '');
}

/**
 * MathRenderer component: Parses LaTeX ($...$, $$...$$, or raw math symbols) and renders crisp KaTeX math.
 * Fallback gracefully to clean text if parsing fails.
 */
export default function MathRenderer({ text, className = '' }) {
  if (!text) return null;

  const sanitized = sanitizeText(text);

  // Check if text already has $...$ or $$...$$
  const hasDelimiters = /\$([^$]+)\$/.test(sanitized);

  let processedText = sanitized;

  // If there are no $ delimiters, but the entire string is a math formula (like 'f \times T = 1' or '2\pi r')
  if (!hasDelimiters) {
    const isShortFormula = sanitized.length < 80 && /(\\[a-zA-Z]+|\^|\_|[=<>+\-*/])/.test(sanitized);
    const hasLatexCommands = /\\[a-zA-Z]+/.test(sanitized);
    if (hasLatexCommands && isShortFormula) {
      processedText = `$${sanitized}$`;
    }
  }

  // Split by $...$ (inline math) and $$...$$ (display math)
  const tokens = [];
  const regex = /(\$\$[\s\S]*?\$\$|\$[^$\n]+?\$)/g;
  let lastIndex = 0;
  let match;

  while ((match = regex.exec(processedText)) !== null) {
    // Plain text preceding match
    if (match.index > lastIndex) {
      tokens.push({
        type: 'text',
        content: processedText.slice(lastIndex, match.index)
      });
    }

    const rawToken = match[0];
    const isDisplay = rawToken.startsWith('$$');
    let mathContent = isDisplay ? rawToken.slice(2, -2).trim() : rawToken.slice(1, -1).trim();

    try {
      const renderedHtml = katex.renderToString(mathContent, {
        displayMode: isDisplay,
        throwOnError: false,
        strict: 'ignore', // Crucial: avoid breaking on ₹, Unicode, or unknown text symbols
        trust: true
      });
      tokens.push({
        type: 'html',
        content: renderedHtml
      });
    } catch (e) {
      tokens.push({
        type: 'text',
        content: mathContent
      });
    }

    lastIndex = regex.lastIndex;
  }

  // Trailing plain text
  if (lastIndex < processedText.length) {
    tokens.push({
      type: 'text',
      content: processedText.slice(lastIndex)
    });
  }

  return (
    <span className={`inline-block ${className}`}>
      {tokens.map((token, idx) => {
        if (token.type === 'html') {
          return (
            <span
              key={idx}
              className="inline-math mx-0.5 align-middle"
              dangerouslySetInnerHTML={{ __html: token.content }}
            />
          );
        }
        return <span key={idx}>{token.content}</span>;
      })}
    </span>
  );
}
