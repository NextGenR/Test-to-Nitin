import React, { useState, useEffect, useMemo } from 'react';
import Navbar from '../components/Navbar';
import MathRenderer from '../components/MathRenderer';
import { savePyqResponse, fetchCandidatePyqResponses } from '../services/apiService';
import { 
  BookOpen, CheckCircle, XCircle, ArrowLeft, Search, Filter, 
  Sparkles, Award, Eye, EyeOff, Bookmark, BookmarkCheck,
  ChevronLeft, ChevronRight, Layers, FileText, Check, HelpCircle,
  Clock, Hash, Image as ImageIcon, Flame, RotateCcw, AlertCircle
} from 'lucide-react';

export default function PYQPage({ candidate, onBackToDashboard, onLogout }) {
  const [chapters, setChapters] = useState([]);
  const [allQuestions, setAllQuestions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedChapterId, setSelectedChapterId] = useState('all');
  const [filterVisualOnly, setFilterVisualOnly] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [lang, setLang] = useState('en'); // 'en' | 'hi'

  // Candidate practice interaction state (offline-first localStorage + remote sync)
  const candidateKey = candidate?.mobile ? candidate.mobile : 'guest';
  const [userAnswers, setUserAnswers] = useState(() => {
    try {
      const saved = localStorage.getItem('rrb_pyq_answers_' + candidateKey);
      return saved ? JSON.parse(saved) : {};
    } catch (e) {
      return {};
    }
  });
  const [statusFilter, setStatusFilter] = useState('all'); // 'all' | 'attempted' | 'unattempted' | 'incorrect' | 'bookmarked'
  const [revealedSolutions, setRevealedSolutions] = useState({});
  const [bookmarkedIds, setBookmarkedIds] = useState(() => {
    try {
      const saved = localStorage.getItem('rrb_pyq_bookmarks');
      return saved ? JSON.parse(saved) : [];
    } catch (e) {
      return [];
    }
  });

  // Pagination
  const [currentPageNum, setCurrentPageNum] = useState(1);
  const pageSize = 15;

  // Load dataset
  useEffect(() => {
    async function loadData() {
      setLoading(true);
      try {
        // Load chapters index
        const chapRes = await fetch('./data/pyq_chapters_index.json');
        if (chapRes.ok) {
          const chapData = await chapRes.json();
          setChapters(chapData);
        }

        // Load 990 questions dataset
        const qRes = await fetch('./data/pyq_reasoning_990.json');
        if (qRes.ok) {
          const qData = await qRes.json();
          setAllQuestions(qData);
        }

        // Fetch saved responses from Remote Database if logged in
        if (candidate?.mobile) {
          const remoteAnswers = await fetchCandidatePyqResponses(candidate.mobile);
          if (remoteAnswers && Object.keys(remoteAnswers).length > 0) {
            setUserAnswers(prev => {
              const merged = { ...prev, ...remoteAnswers };
              try {
                localStorage.setItem('rrb_pyq_answers_' + candidate.mobile, JSON.stringify(merged));
              } catch (e) {}
              return merged;
            });
          }
        }
      } catch (err) {
        console.error('Failed to load PYQ dataset:', err);
      } finally {
        setLoading(false);
      }
    }
    loadData();
  }, []);

  // Save bookmarks
  const toggleBookmark = (id) => {
    setBookmarkedIds(prev => {
      const next = prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id];
      localStorage.setItem('rrb_pyq_bookmarks', JSON.stringify(next));
      return next;
    });
  };

  const handleSelectOption = (questionId, optionLetter) => {
    const nextAnswers = { ...userAnswers, [questionId]: optionLetter };
    setUserAnswers(nextAnswers);
    try {
      localStorage.setItem('rrb_pyq_answers_' + candidateKey, JSON.stringify(nextAnswers));
    } catch (e) {}

    // Remote database sync
    const targetQ = allQuestions.find(item => item.id === questionId);
    if (candidate?.mobile && targetQ) {
      savePyqResponse({
        candidateName: candidate.name || 'Candidate',
        candidateMobile: candidate.mobile,
        questionId: targetQ.id,
        subject: targetQ.subject || 'General Intelligence & Reasoning',
        chapterId: targetQ.chapter_id || '',
        chapterName: targetQ.chapter_name || '',
        correctAnswer: targetQ.correct_option || '',
        hisAnswer: optionLetter
      });
    }
  };

  const handleResetProgress = () => {
    if (window.confirm('Are you sure you want to clear your recorded answers for this practice session?')) {
      setUserAnswers({});
      try {
        localStorage.removeItem('rrb_pyq_answers_' + candidateKey);
      } catch (e) {}
    }
  };

  const toggleSolution = (questionId) => {
    setRevealedSolutions(prev => ({
      ...prev,
      [questionId]: !prev[questionId]
    }));
  };

  // Filtered Questions
  const filteredQuestions = useMemo(() => {
    return allQuestions.filter(q => {
      // Chapter filter
      if (selectedChapterId !== 'all' && q.chapter_id !== selectedChapterId) {
        return false;
      }
      // Visual filter
      if (filterVisualOnly && !(q.has_image || q.svg_content || q.option_svgs)) {
        return false;
      }
      // Search filter
      if (searchQuery.trim()) {
        const query = searchQuery.toLowerCase();
        const textEn = (q.question_text || '').toLowerCase();
        const textHi = (q.question_text_hi || '').toLowerCase();
        const subtopic = (q.subtopic || '').toLowerCase();
        const tag = (q.exam_tag || '').toLowerCase();
        if (!textEn.includes(query) && !textHi.includes(query) && !subtopic.includes(query) && !tag.includes(query)) {
          return false;
        }
      }

      // Status filter
      if (statusFilter === 'attempted' && !userAnswers[q.id]) {
        return false;
      }
      if (statusFilter === 'unattempted' && userAnswers[q.id]) {
        return false;
      }
      if (statusFilter === 'incorrect') {
        const ans = userAnswers[q.id];
        if (!ans) return false;
        if (ans.toLowerCase() === (q.correct_option || '').toLowerCase()) return false;
      }
      if (statusFilter === 'bookmarked' && !bookmarkedIds.includes(q.id)) {
        return false;
      }

      return true;
    });
  }, [allQuestions, selectedChapterId, filterVisualOnly, searchQuery, statusFilter, userAnswers, bookmarkedIds]);

  // Reset pagination when filter changes
  useEffect(() => {
    setCurrentPageNum(1);
  }, [selectedChapterId, filterVisualOnly, searchQuery, statusFilter]);

  // Paginated questions
  const totalPages = Math.ceil(filteredQuestions.length / pageSize) || 1;
  const paginatedQuestions = useMemo(() => {
    const start = (currentPageNum - 1) * pageSize;
    return filteredQuestions.slice(start, start + pageSize);
  }, [filteredQuestions, currentPageNum, pageSize]);

  // Stats
  const answeredCount = Object.keys(userAnswers).length;
  const correctCount = Object.entries(userAnswers).filter(([qId, ans]) => {
    const q = allQuestions.find(item => item.id === qId);
    return q && q.correct_option && q.correct_option.toLowerCase() === ans.toLowerCase();
  }).length;
  const incorrectCount = answeredCount - correctCount;
  const accuracyPercent = answeredCount > 0 ? ((correctCount / answeredCount) * 100).toFixed(0) : 0;

  return (
    <div className="min-h-screen bg-[#f1f5f9] text-slate-800 flex flex-col font-sans">
      <Navbar candidate={candidate} onLogout={onLogout} />

      {/* Hero Subheader */}
      <div className="bg-[#1e293b] text-white border-b border-slate-700 py-4 px-4 sm:px-6">
        <div className="max-w-7xl mx-auto flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <button
              onClick={onBackToDashboard}
              className="p-2 bg-slate-800 hover:bg-slate-700 border border-slate-600 rounded-lg text-slate-300 hover:text-white transition flex items-center gap-1.5 text-xs font-semibold"
            >
              <ArrowLeft className="w-4 h-4" />
              <span>Dashboard</span>
            </button>
            <div>
              <div className="flex items-center gap-2">
                <span className="bg-amber-500 text-slate-900 text-[10px] font-black uppercase px-2 py-0.5 rounded tracking-wider flex items-center gap-1">
                  <Flame className="w-3 h-3 fill-slate-900" /> Official PYQ Bank
                </span>
                <span className="text-xs text-slate-400">RRB NTPC Graduate Level</span>
              </div>
              <h1 className="text-lg sm:text-xl font-bold tracking-tight text-white flex items-center gap-2">
                General Intelligence & Reasoning
                <span className="text-amber-400 text-sm font-normal">({allQuestions.length} Questions)</span>
              </h1>
            </div>
          </div>

          {/* Practice Progress Pill */}
          <div className="flex items-center gap-3 bg-slate-800/90 px-4 py-2 rounded-xl border border-slate-700">
            <div className="text-right">
              <div className="text-xs text-slate-400">Attempted</div>
              <div className="text-sm font-bold text-emerald-400">{answeredCount} / {allQuestions.length}</div>
            </div>
            <div className="w-px h-8 bg-slate-700"></div>
            <div className="text-right">
              <div className="text-xs text-slate-400">Accuracy</div>
              <div className="text-sm font-bold text-amber-400">{accuracyPercent}%</div>
            </div>
            <div className="w-px h-8 bg-slate-700"></div>
            {/* Bilingual Toggle */}
            <button
              onClick={() => setLang(l => l === 'en' ? 'hi' : 'en')}
              className="px-3 py-1 bg-amber-500 hover:bg-amber-400 text-slate-900 font-bold text-xs rounded-lg transition"
            >
              {lang === 'en' ? 'हिन्दी में देखें' : 'View in English'}
            </button>
          </div>
        </div>
      </div>

      {/* Main Content Layout */}
      <div className="max-w-7xl mx-auto w-full px-4 sm:px-6 py-6 flex-1 flex flex-col lg:flex-row gap-6">
        
        {/* Left Sidebar: Chapter Navigator */}
        <aside className="w-full lg:w-72 shrink-0">
          <div className="bg-white rounded-xl shadow-xs border border-slate-200 p-4 sticky top-20">
            <div className="flex items-center justify-between mb-3">
              <h2 className="font-bold text-sm text-slate-900 flex items-center gap-2">
                <Layers className="w-4 h-4 text-amber-500" />
                Chapters ({chapters.length})
              </h2>
              <span className="text-xs font-semibold text-slate-500">{filteredQuestions.length} Qs</span>
            </div>

            {/* All Chapters Button */}
            <button
              onClick={() => setSelectedChapterId('all')}
              className={`w-full text-left px-3 py-2 rounded-lg text-xs font-semibold mb-2 transition flex items-center justify-between ${
                selectedChapterId === 'all'
                  ? 'bg-amber-500 text-slate-900 shadow-xs font-bold'
                  : 'bg-slate-50 hover:bg-slate-100 text-slate-700 border border-slate-200'
              }`}
            >
              <span>All 19 Chapters</span>
              <span className="px-1.5 py-0.5 rounded text-[10px] bg-slate-900/10">{allQuestions.length}</span>
            </button>

            {/* Chapter List */}
            <div className="space-y-1 max-h-[60vh] overflow-y-auto pr-1 text-xs">
              {chapters.map(c => {
                const isSelected = selectedChapterId === c.id;
                return (
                  <button
                    key={c.id}
                    onClick={() => setSelectedChapterId(c.id)}
                    className={`w-full text-left px-3 py-2 rounded-lg transition flex items-center justify-between ${
                      isSelected
                        ? 'bg-indigo-600 text-white font-bold shadow-xs'
                        : 'hover:bg-slate-100 text-slate-700'
                    }`}
                  >
                    <span className="truncate pr-2">{c.number}. {c.name}</span>
                    <span className={`px-1.5 py-0.5 rounded text-[10px] shrink-0 ${
                      isSelected ? 'bg-indigo-700 text-white' : 'bg-slate-100 text-slate-500 font-semibold'
                    }`}>
                      {c.total_questions}
                    </span>
                  </button>
                );
              })}
            </div>
          </div>
        </aside>

        {/* Center/Right: Questions Feed */}
        <main className="flex-1 space-y-4 min-w-0">
          
          {/* Filters Bar */}
          <div className="bg-white p-3.5 rounded-xl border border-slate-200 shadow-xs space-y-3">
            <div className="flex flex-wrap items-center justify-between gap-3">
              {/* Search Input */}
              <div className="relative flex-1 min-w-[220px]">
                <Search className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={e => setSearchQuery(e.target.value)}
                  placeholder="Search PYQs by keyword, subtopic, or shift..."
                  className="w-full pl-9 pr-3 py-1.5 text-xs bg-slate-50 border border-slate-200 rounded-lg focus:outline-hidden focus:ring-2 focus:ring-amber-500/50"
                />
              </div>

              {/* Visual Questions Toggle */}
              <button
                onClick={() => setFilterVisualOnly(v => !v)}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold border transition ${
                  filterVisualOnly
                    ? 'bg-purple-600 text-white border-purple-600 shadow-xs'
                    : 'bg-white hover:bg-slate-50 text-slate-700 border-slate-200'
                }`}
              >
                <ImageIcon className="w-3.5 h-3.5" />
                <span>Diagrams (301)</span>
              </button>

              {/* Clear / Reset Progress */}
              {answeredCount > 0 && (
                <button
                  onClick={handleResetProgress}
                  className="flex items-center gap-1 px-2.5 py-1.5 text-xs font-semibold text-slate-500 hover:text-red-600 hover:bg-red-50 rounded-lg border border-slate-200 transition"
                  title="Clear all recorded responses"
                >
                  <RotateCcw className="w-3 h-3" />
                  <span>Reset Progress</span>
                </button>
              )}
            </div>

            {/* Practice Status Tabs (All, Attempted, Incorrect, Unattempted, Bookmarked) */}
            <div className="flex flex-wrap items-center justify-between gap-2 pt-2 border-t border-slate-100 text-xs">
              <div className="flex flex-wrap items-center gap-1.5">
                <button
                  onClick={() => setStatusFilter('all')}
                  className={`px-2.5 py-1 rounded-md font-semibold transition ${
                    statusFilter === 'all'
                      ? 'bg-slate-800 text-white'
                      : 'bg-slate-100 hover:bg-slate-200 text-slate-700'
                  }`}
                >
                  All ({allQuestions.length})
                </button>
                <button
                  onClick={() => setStatusFilter('attempted')}
                  className={`px-2.5 py-1 rounded-md font-semibold transition flex items-center gap-1 ${
                    statusFilter === 'attempted'
                      ? 'bg-emerald-600 text-white'
                      : 'bg-slate-100 hover:bg-slate-200 text-slate-700'
                  }`}
                >
                  <CheckCircle className="w-3 h-3" />
                  <span>Attempted ({answeredCount})</span>
                </button>
                <button
                  onClick={() => setStatusFilter('incorrect')}
                  className={`px-2.5 py-1 rounded-md font-semibold transition flex items-center gap-1 ${
                    statusFilter === 'incorrect'
                      ? 'bg-red-600 text-white'
                      : 'bg-slate-100 hover:bg-slate-200 text-slate-700'
                  }`}
                >
                  <XCircle className="w-3 h-3" />
                  <span>Mistakes ({incorrectCount})</span>
                </button>
                <button
                  onClick={() => setStatusFilter('unattempted')}
                  className={`px-2.5 py-1 rounded-md font-semibold transition ${
                    statusFilter === 'unattempted'
                      ? 'bg-amber-600 text-white'
                      : 'bg-slate-100 hover:bg-slate-200 text-slate-700'
                  }`}
                >
                  Unattempted ({allQuestions.length - answeredCount})
                </button>
                <button
                  onClick={() => setStatusFilter('bookmarked')}
                  className={`px-2.5 py-1 rounded-md font-semibold transition flex items-center gap-1 ${
                    statusFilter === 'bookmarked'
                      ? 'bg-indigo-600 text-white'
                      : 'bg-slate-100 hover:bg-slate-200 text-slate-700'
                  }`}
                >
                  <Bookmark className="w-3 h-3" />
                  <span>Bookmarked ({bookmarkedIds.length})</span>
                </button>
              </div>

              {/* Showing count */}
              <div className="text-xs text-slate-500 font-medium">
                Showing <span className="font-bold text-slate-800">{paginatedQuestions.length}</span> of {filteredQuestions.length} Qs
              </div>
            </div>
          </div>

          {/* Loading State */}
          {loading && (
            <div className="bg-white p-12 rounded-xl text-center border border-slate-200">
              <div className="inline-block animate-spin rounded-full h-8 w-8 border-4 border-amber-500 border-t-transparent mb-3"></div>
              <p className="text-sm font-semibold text-slate-600">Loading 990 RRB NTPC Reasoning PYQs...</p>
            </div>
          )}

          {/* Empty State */}
          {!loading && paginatedQuestions.length === 0 && (
            <div className="bg-white p-12 rounded-xl text-center border border-slate-200">
              <HelpCircle className="w-12 h-12 text-slate-300 mx-auto mb-3" />
              <h3 className="font-bold text-base text-slate-700">No questions match your current filter</h3>
              <p className="text-xs text-slate-500 mt-1">Try clearing your search query or selecting "All Chapters".</p>
              <button
                onClick={() => { setSelectedChapterId('all'); setSearchQuery(''); setFilterVisualOnly(false); }}
                className="mt-4 px-4 py-2 bg-amber-500 hover:bg-amber-400 text-slate-900 text-xs font-bold rounded-lg transition"
              >
                Reset Filters
              </button>
            </div>
          )}

          {/* Question Cards Feed */}
          {!loading && paginatedQuestions.map((q, idx) => {
            const qIndex = (currentPageNum - 1) * pageSize + idx + 1;
            const isBookmarked = bookmarkedIds.includes(q.id);
            const userChoice = userAnswers[q.id];
            const isAnswered = !!userChoice;
            const isCorrect = isAnswered && userChoice.toLowerCase() === (q.correct_option || '').toLowerCase();
            const showSolution = revealedSolutions[q.id];

            const qText = (lang === 'hi' && q.question_text_hi) ? q.question_text_hi : q.question_text;
            const qOptions = (lang === 'hi' && q.options_hi) ? q.options_hi : q.options;
            const qSolution = (lang === 'hi' && q.solution_text_hi) ? q.solution_text_hi : q.solution_text;

            return (
              <div 
                key={q.id || idx} 
                className={`bg-white rounded-xl border-2 transition shadow-xs overflow-hidden ${
                  isAnswered 
                    ? (isCorrect ? 'border-emerald-300' : 'border-red-300') 
                    : 'border-slate-200 hover:border-slate-300'
                }`}
              >
                {/* Question Header Card */}
                <div className="bg-slate-50 px-4 py-2.5 border-b border-slate-200 flex flex-wrap items-center justify-between gap-2 text-xs">
                  <div className="flex items-center gap-2">
                    <span className="font-extrabold px-2 py-0.5 bg-slate-200 text-slate-800 rounded text-[11px]">
                      Q.{qIndex}
                    </span>
                    <span className="font-bold text-slate-700">{q.chapter_name}</span>
                    {q.subtopic && (
                      <span className="hidden sm:inline-block text-slate-500">
                        • {q.subtopic}
                      </span>
                    )}
                  </div>

                  <div className="flex items-center gap-2">
                    {/* Official Exam Tag Pill */}
                    {q.exam_tag && (
                      <span className="px-2 py-0.5 bg-amber-100 text-amber-900 border border-amber-300 rounded text-[10px] font-semibold truncate max-w-[200px]" title={q.exam_tag}>
                        {q.exam_tag}
                      </span>
                    )}
                    {/* Bookmark Button */}
                    <button
                      onClick={() => toggleBookmark(q.id)}
                      className={`p-1 rounded hover:bg-slate-200 transition ${
                        isBookmarked ? 'text-amber-500' : 'text-slate-400'
                      }`}
                      title={isBookmarked ? "Remove Bookmark" : "Bookmark Question"}
                    >
                      {isBookmarked ? <BookmarkCheck className="w-4 h-4" /> : <Bookmark className="w-4 h-4" />}
                    </button>
                  </div>
                </div>

                {/* Question Body */}
                <div className="p-4 sm:p-5">
                  <div className="text-sm font-semibold text-slate-900 leading-relaxed">
                    <MathRenderer text={qText} />
                  </div>

                  {/* Main SVG Vector Diagram (if present) */}
                  {(q.svg_content || q.image_svg) && (
                    <div className="my-4 p-2 bg-slate-50 border border-slate-200 rounded-lg flex items-center justify-center max-w-lg mx-auto">
                      <div 
                        className="w-full flex items-center justify-center [&>svg]:max-h-[260px] [&>svg]:w-auto [&>svg]:max-w-full"
                        dangerouslySetInnerHTML={{ __html: q.svg_content || q.image_svg }}
                      />
                    </div>
                  )}

                  {/* Options List */}
                  {qOptions && (
                    <div className="mt-4 grid grid-cols-1 sm:grid-cols-2 gap-2.5">
                      {['a', 'b', 'c', 'd'].map((letterKey) => {
                        const optText = qOptions[letterKey];
                        if (optText === undefined && !q.option_svgs) return null;
                        const optLetter = letterKey.toUpperCase();
                        const isThisSelected = userChoice === letterKey;
                        const isThisCorrect = (q.correct_option || '').toLowerCase() === letterKey;
                        const svgOpt = q.option_svgs ? q.option_svgs[letterKey] : null;

                        let optBtnStyle = 'border-slate-200 bg-white hover:border-slate-300 hover:bg-slate-50';
                        if (isAnswered) {
                          if (isThisCorrect) {
                            optBtnStyle = 'border-emerald-500 bg-emerald-50 text-emerald-900 ring-1 ring-emerald-500 font-semibold';
                          } else if (isThisSelected && !isThisCorrect) {
                            optBtnStyle = 'border-red-500 bg-red-50 text-red-900 ring-1 ring-red-500';
                          } else {
                            optBtnStyle = 'border-slate-200 bg-white opacity-60';
                          }
                        }

                        return (
                          <button
                            key={letterKey}
                            onClick={() => !isAnswered && handleSelectOption(q.id, letterKey)}
                            disabled={isAnswered}
                            className={`p-3 rounded-lg border-2 text-left text-xs transition flex items-center gap-3 ${optBtnStyle} ${
                              isAnswered ? 'cursor-default' : 'cursor-pointer'
                            }`}
                          >
                            <span className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold shrink-0 ${
                              isAnswered && isThisCorrect
                                ? 'bg-emerald-600 text-white'
                                : isAnswered && isThisSelected
                                ? 'bg-red-600 text-white'
                                : 'bg-slate-100 text-slate-700 border border-slate-300'
                            }`}>
                              {optLetter}
                            </span>

                            {/* Option SVG if present */}
                            {svgOpt && (
                              <div 
                                className="w-16 h-16 shrink-0 bg-white rounded p-1 border border-slate-200 flex items-center justify-center [&>svg]:w-full [&>svg]:h-full"
                                dangerouslySetInnerHTML={{ __html: svgOpt }}
                              />
                            )}

                            {optText && (
                              <span className="flex-1 font-medium leading-snug">
                                <MathRenderer text={optText} />
                              </span>
                            )}
                          </button>
                        );
                      })}
                    </div>
                  )}

                  {/* Actions & Solution Reveal */}
                  <div className="mt-4 pt-3 border-t border-slate-100 flex items-center justify-between">
                    <button
                      onClick={() => toggleSolution(q.id)}
                      className="text-xs font-semibold text-indigo-600 hover:text-indigo-800 flex items-center gap-1.5 transition"
                    >
                      {showSolution ? <EyeOff className="w-3.5 h-3.5" /> : <Eye className="w-3.5 h-3.5" />}
                      <span>{showSolution ? 'Hide Solution' : 'View Step-by-Step Solution'}</span>
                    </button>

                    {isAnswered && (
                      <span className={`text-xs font-bold flex items-center gap-1 ${
                        isCorrect ? 'text-emerald-600' : 'text-red-600'
                      }`}>
                        {isCorrect ? <CheckCircle className="w-4 h-4" /> : <XCircle className="w-4 h-4" />}
                        {isCorrect ? 'Correct Answer' : `Incorrect (Correct: Option ${q.correct_option?.toUpperCase()})`}
                      </span>
                    )}
                  </div>

                  {/* Detailed Solution Drawer */}
                  {showSolution && (
                    <div className="mt-3 p-4 bg-indigo-50/70 border border-indigo-200 rounded-lg text-xs leading-relaxed text-indigo-950 animate-fadeIn">
                      <div className="font-bold text-indigo-900 mb-1 flex items-center gap-1.5">
                        <Sparkles className="w-3.5 h-3.5 text-amber-500" />
                        Official Explanation & Logical Derivation (Correct Option: {q.correct_option?.toUpperCase()}):
                      </div>
                      <div className="whitespace-pre-wrap font-sans text-slate-800">
                        <MathRenderer text={qSolution || 'No written solution provided.'} />
                      </div>

                      {q.solution_svg && (
                        <div className="mt-3 p-2 bg-white rounded border border-indigo-100 flex items-center justify-center">
                          <div 
                            className="max-h-[220px] [&>svg]:max-h-[220px] [&>svg]:w-auto"
                            dangerouslySetInnerHTML={{ __html: q.solution_svg }}
                          />
                        </div>
                      )}
                    </div>
                  )}

                </div>
              </div>
            );
          })}

          {/* Pagination Controls */}
          {!loading && totalPages > 1 && (
            <div className="bg-white p-3 rounded-xl border border-slate-200 flex items-center justify-between mt-6">
              <button
                onClick={() => setCurrentPageNum(p => Math.max(1, p - 1))}
                disabled={currentPageNum === 1}
                className="px-3 py-1.5 bg-slate-100 hover:bg-slate-200 disabled:opacity-40 text-xs font-bold rounded-lg transition flex items-center gap-1"
              >
                <ChevronLeft className="w-4 h-4" /> Previous
              </button>

              <div className="text-xs font-semibold text-slate-600">
                Page <span className="font-bold text-slate-900">{currentPageNum}</span> of {totalPages}
              </div>

              <button
                onClick={() => setCurrentPageNum(p => Math.min(totalPages, p + 1))}
                disabled={currentPageNum === totalPages}
                className="px-3 py-1.5 bg-slate-100 hover:bg-slate-200 disabled:opacity-40 text-xs font-bold rounded-lg transition flex items-center gap-1"
              >
                Next <ChevronRight className="w-4 h-4" />
              </button>
            </div>
          )}

        </main>
      </div>
    </div>
  );
}

