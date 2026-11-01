import React, { useRef, useState, useEffect } from 'react';
import { X, RotateCcw, Trash2, Edit2, Eraser, Move } from 'lucide-react';

export default function ScratchpadModal({ isOpen, onClose }) {
  const canvasRef = useRef(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [tool, setTool] = useState('pen'); // 'pen' | 'eraser'
  const [color, setColor] = useState('#0f172a'); // default black
  const [lineWidth, setLineWidth] = useState(2);

  // Initialize canvas
  useEffect(() => {
    if (!isOpen) return;

    const timer = setTimeout(() => {
      const canvas = canvasRef.current;
      if (!canvas) return;
      const rect = canvas.getBoundingClientRect();
      canvas.width = rect.width;
      canvas.height = rect.height;

      const ctx = canvas.getContext('2d');
      ctx.lineCap = 'round';
      ctx.lineJoin = 'round';
    }, 100);

    return () => clearTimeout(timer);
  }, [isOpen]);

  if (!isOpen) return null;

  const startDrawing = (e) => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const rect = canvas.getBoundingClientRect();
    const x = (e.clientX || (e.touches && e.touches[0].clientX)) - rect.left;
    const y = (e.clientY || (e.touches && e.touches[0].clientY)) - rect.top;

    ctx.beginPath();
    ctx.moveTo(x, y);
    setIsDrawing(true);
  };

  const draw = (e) => {
    if (!isDrawing) return;
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const rect = canvas.getBoundingClientRect();
    const x = (e.clientX || (e.touches && e.touches[0].clientX)) - rect.left;
    const y = (e.clientY || (e.touches && e.touches[0].clientY)) - rect.top;

    ctx.lineWidth = tool === 'eraser' ? lineWidth * 6 : lineWidth;
    ctx.strokeStyle = tool === 'eraser' ? '#ffffff' : color;
    ctx.lineTo(x, y);
    ctx.stroke();
  };

  const stopDrawing = () => {
    if (!isDrawing) return;
    const canvas = canvasRef.current;
    if (canvas) {
      const ctx = canvas.getContext('2d');
      ctx.closePath();
    }
    setIsDrawing(false);
  };

  const clearCanvas = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-xs p-3">
      <div className="bg-white rounded-xl shadow-2xl border border-slate-300 w-full max-w-2xl h-[75vh] flex flex-col overflow-hidden animate-in zoom-in-95 duration-150">
        
        {/* Top Header */}
        <div className="bg-[#1e293b] text-white px-4 py-2.5 flex items-center justify-between border-b border-amber-500">
          <div className="flex items-center gap-2">
            <Edit2 className="w-4 h-4 text-amber-400" />
            <h3 className="font-bold text-sm tracking-wide">
              Digital Rough Sheet & Scratchpad
            </h3>
          </div>

          <button
            onClick={onClose}
            className="text-slate-300 hover:text-white p-1 rounded hover:bg-slate-700 transition"
            title="Close Scratchpad"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Toolbar */}
        <div className="bg-slate-100 border-b border-slate-200 px-4 py-2 flex flex-wrap items-center justify-between gap-3 text-xs">
          
          {/* Tools */}
          <div className="flex items-center gap-2">
            <button
              onClick={() => setTool('pen')}
              className={`flex items-center gap-1 px-2.5 py-1 rounded font-semibold transition ${
                tool === 'pen' ? 'bg-blue-600 text-white shadow-xs' : 'bg-white text-slate-700 border border-slate-300'
              }`}
            >
              <Edit2 className="w-3 h-3" />
              <span>Pen</span>
            </button>

            <button
              onClick={() => setTool('eraser')}
              className={`flex items-center gap-1 px-2.5 py-1 rounded font-semibold transition ${
                tool === 'eraser' ? 'bg-blue-600 text-white shadow-xs' : 'bg-white text-slate-700 border border-slate-300'
              }`}
            >
              <Eraser className="w-3 h-3" />
              <span>Eraser</span>
            </button>
          </div>

          {/* Color Palette */}
          {tool === 'pen' && (
            <div className="flex items-center gap-1.5">
              {[
                { hex: '#0f172a', label: 'Black' },
                { hex: '#1d4ed8', label: 'Blue' },
                { hex: '#dc2626', label: 'Red' },
                { hex: '#16a34a', label: 'Green' }
              ].map((c) => (
                <button
                  key={c.hex}
                  onClick={() => setColor(c.hex)}
                  className={`w-5 h-5 rounded-full transition transform hover:scale-110 ${
                    color === c.hex ? 'ring-2 ring-blue-500 ring-offset-1' : ''
                  }`}
                  style={{ backgroundColor: c.hex }}
                  title={c.label}
                />
              ))}
            </div>
          )}

          {/* Stroke Width */}
          <div className="flex items-center gap-1.5">
            <span className="text-[11px] text-slate-500">Size:</span>
            {[1.5, 3, 5].map((w) => (
              <button
                key={w}
                onClick={() => setLineWidth(w)}
                className={`w-6 h-6 rounded flex items-center justify-center font-bold text-[10px] ${
                  lineWidth === w ? 'bg-slate-300 text-slate-900' : 'bg-white text-slate-600 border border-slate-200'
                }`}
              >
                {w === 1.5 ? 'S' : w === 3 ? 'M' : 'L'}
              </button>
            ))}
          </div>

          {/* Clear Button */}
          <button
            onClick={clearCanvas}
            className="flex items-center gap-1 px-2.5 py-1 bg-red-50 hover:bg-red-100 text-red-700 font-semibold rounded border border-red-200 transition"
          >
            <Trash2 className="w-3 h-3" />
            <span>Clear</span>
          </button>
        </div>

        {/* Canvas Area */}
        <div className="flex-1 bg-white relative cursor-crosshair touch-none">
          <canvas
            ref={canvasRef}
            onMouseDown={startDrawing}
            onMouseMove={draw}
            onMouseUp={stopDrawing}
            onMouseLeave={stopDrawing}
            onTouchStart={startDrawing}
            onTouchMove={draw}
            onTouchEnd={stopDrawing}
            className="w-full h-full block"
          />
        </div>

        {/* Footer */}
        <div className="bg-slate-50 border-t border-slate-200 px-4 py-2 flex items-center justify-between text-[11px] text-slate-500">
          <span>Use mouse or touch to solve calculations. Rough sheet resets on test submission.</span>
          <button
            onClick={onClose}
            className="px-3 py-1 bg-slate-700 text-white rounded font-medium hover:bg-slate-800 transition"
          >
            Done
          </button>
        </div>

      </div>
    </div>
  );
}
