import React from 'react';
import katex from 'katex';
import 'katex/dist/katex.min.css';

/**
 * Clean up text encoding artifacts
 */
function sanitizeText(raw) {
  if (!raw || typeof raw !== 'string') return '';
  return raw
    .replace(/m\/s\uFFFD/g, 'm/s²')
    .replace(/m\/sA/g, 'm/s²')
    .replace(/\uFFFDC/g, '°C')
    .replace(/\s*C/g, '°C')
    .replace(/\uFFFD/g, '');
}

/**
 * MathRenderer component: Parses LaTeX ($...$, $$...$$, or raw math symbols) and renders crisp KaTeX math
 */
export default function MathRenderer({ text, className = '' }) {
  if (!text) return null;

  const sanitized = sanitizeText(text);

  // If text contains math delimiters like $...$ or $$...$$
  const hasDelimiters = /\$([^$]+)\$/.test(sanitized);

  // If text doesn't have $ delimiters but has LaTeX commands like \times, \pi, \frac, \sqrt, \theta
  const hasRawLatex = !hasDelimiters && /(\\[a-zA-Z]+|\^|\_)/.test(sanitized);

  let processedText = sanitized;

  if (hasRawLatex) {
    processedText = `$${sanitized}$`;
  }

  // Split by $...$ (inline math) and $$...$$ (display math)
  const tokens = [];
  const regex = /(\$\$[\s\S]*?\$\$|\$[^$\n]+?\$)/g;
  let lastIndex = 0;
  let match;

  while ((match = regex.exec(processedText)) !== null) {
    // Plain text before match
    if (match.index > lastIndex) {
      tokens.push({
        type: 'text',
        content: processedText.slice(lastIndex, match.index)
      });
    }

    const rawToken = match[0];
    const isDisplay = rawToken.startsWith('$$');
    const mathContent = isDisplay ? rawToken.slice(2, -2).trim() : rawToken.slice(1, -1).trim();

    try {
      const renderedHtml = katex.renderToString(mathContent, {
        displayMode: isDisplay,
        throwOnError: false
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
              className="inline-math mx-0.5"
              dangerouslySetInnerHTML={{ __html: token.content }}
            />
          );
        }
        return <span key={idx}>{token.content}</span>;
      })}
    </span>
  );
}
