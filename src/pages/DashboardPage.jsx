import React, { useState, useEffect } from 'react';
import Navbar from '../components/Navbar';
import InstructionsModal from '../components/InstructionsModal';
import { Play, RotateCcw, Clock, Award, BookOpen, CheckCircle, BarChart3, AlertCircle, FileCheck2, Sparkles } from 'lucide-react';
import { getTestAttempt } from '../services/apiService';

const MOCK_TESTS_CATALOG = [
  {
    id: 1,
    testId: 'rrb_cbt_mock_1',
    title: 'RRB Group D CBT Mock Test 01',
    description: 'Based on official Railway Recruitment Board pattern with high-yield General Science and Math.',
    questionsCount: 100,
    durationMins: 90,
    responseTable: 'RRB_MOCK_1_responses'
  },
  {
    id: 2,
    testId: 'rrb_cbt_mock_2',
    title: 'RRB Group D CBT Mock Test 02',
    description: 'Comprehensive evaluation covering Physics, Chemistry, Reasoning series, and Railway GK.',
    questionsCount: 100,
    durationMins: 90,
    responseTable: 'RRB_MOCK_2_responses'
  },
  {
    id: 3,
    testId: 'rrb_cbt_mock_3',
    title: 'RRB Group D CBT Mock Test 03',
    description: 'Advanced full-length test simulation with authentic TCS iON timing and negative marking.',
    questionsCount: 100,
    durationMins: 90,
    responseTable: 'RRB_MOCK_3_responses'
  }
];

export default function DashboardPage({
  candidate,
  onStartExam,
  onResumeExam,
  onLogout
}) {
  const [activeTab, setActiveTab] = useState('rrb-series');
  const [savedAttempts, setSavedAttempts] = useState({});
  const [selectedMock, setSelectedMock] = useState(MOCK_TESTS_CATALOG[0]);
  const [showInstructions, setShowInstructions] = useState(false);
  const [defaultLang, setDefaultLang] = useState('en');

  // Load attempts for all 3 mocks
  useEffect(() => {
    if (candidate?.mobile_number) {
      MOCK_TESTS_CATALOG.forEach((mock) => {
        getTestAttempt(candidate.mobile_number, mock.testId).then((attempt) => {
          if (attempt) {
            setSavedAttempts((prev) => ({ ...prev, [mock.id]: attempt }));
          }
        });
      });
    }
  }, [candidate]);

  const handleStartClick = (mock) => {
    setSelectedMock(mock);
    setShowInstructions(true);
  };

  const handleInstructionsProceed = () => {
    setShowInstructions(false);
    onStartExam({
      mockNumber: selectedMock.id,
      testId: selectedMock.testId,
      title: selectedMock.title,
      defaultLang
    });
  };

  const handleResumeClick = (mock) => {
    const attempt = savedAttempts[mock.id];
    onResumeExam(attempt, mock);
  };

  return (
    <div className="min-h-screen bg-[#f1f5f9] flex flex-col text-slate-800">
      
      {/* Top Navbar */}
      <Navbar candidate={candidate} onLogout={onLogout} />

      {/* Main Container */}
      <main className="max-w-7xl mx-auto w-full px-4 sm:px-6 py-6 sm:py-8 flex-1 space-y-6">
        
        {/* Candidate Welcome Banner */}
        <div className="bg-gradient-to-r from-[#1d638a] via-[#285375] to-[#30475e] rounded-2xl p-6 sm:p-8 text-white shadow-lg relative overflow-hidden">
          <div className="absolute right-0 top-0 bottom-0 opacity-10 pointer-events-none flex items-center pr-10 font-black text-9xl text-white select-none">
            RRB
          </div>
          <div className="relative z-10 max-w-2xl">
            <span className="inline-block px-3 py-1 bg-amber-500/90 text-slate-900 text-xs font-black uppercase rounded-full tracking-wider mb-3">
              Official CBT Examination Portal
            </span>
            <h2 className="text-2xl sm:text-3xl font-extrabold tracking-tight mb-2">
              Welcome back, {candidate?.name || 'Candidate'}!
            </h2>
            <p className="text-sm text-slate-200 leading-relaxed">
              Mobile: <span className="font-mono text-amber-300 font-bold">{candidate?.mobile_number}</span> &bull; Roll Number: <span className="font-mono text-amber-300 font-bold">{candidate?.roll_number}</span>. All three RRB Mock Tests are available below.
            </p>
          </div>
        </div>

        {/* Quick Stats Grid */}
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
          <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-blue-100 text-blue-600 flex items-center justify-center">
              <BookOpen className="w-5 h-5" />
            </div>
            <div>
              <div className="text-xs text-slate-500 font-medium">Available Mocks</div>
              <div className="text-lg font-bold text-slate-900">3 Full Length Tests</div>
            </div>
          </div>

          <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-emerald-100 text-emerald-600 flex items-center justify-center">
              <Clock className="w-5 h-5" />
            </div>
            <div>
              <div className="text-xs text-slate-500 font-medium">Total Duration</div>
              <div className="text-lg font-bold text-slate-900">90 Minutes Each</div>
            </div>
          </div>

          <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-purple-100 text-purple-600 flex items-center justify-center">
              <BarChart3 className="w-5 h-5" />
            </div>
            <div>
              <div className="text-xs text-slate-500 font-medium">Questions & Marks</div>
              <div className="text-lg font-bold text-slate-900">100 Qs / 100 Marks</div>
            </div>
          </div>

          <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-amber-100 text-amber-600 flex items-center justify-center">
              <Award className="w-5 h-5" />
            </div>
            <div>
              <div className="text-xs text-slate-500 font-medium">Evaluation Rule</div>
              <div className="text-lg font-bold text-slate-900">+1.0 / -0.33 Mark</div>
            </div>
          </div>
        </div>

        {/* Navigation Tabs */}
        <div className="border-b border-slate-300">
          <div className="flex space-x-6">
            <button
              onClick={() => setActiveTab('rrb-series')}
              className={`pb-3 font-bold text-sm tracking-wide transition border-b-2 ${
                activeTab === 'rrb-series'
                  ? 'border-blue-600 text-blue-600'
                  : 'border-transparent text-slate-500 hover:text-slate-800'
              }`}
            >
              Test Series : RRB Mock Test (3 Tests)
            </button>
            <button
              onClick={() => setActiveTab('history')}
              className={`pb-3 font-bold text-sm tracking-wide transition border-b-2 ${
                activeTab === 'history'
                  ? 'border-blue-600 text-blue-600'
                  : 'border-transparent text-slate-500 hover:text-slate-800'
              }`}
            >
              My Attempt History & Scorecard
            </button>
          </div>
        </div>

        {/* Tab 1: 3 Mock Tests Cards */}
        {activeTab === 'rrb-series' && (
          <div className="space-y-6">
            <div className="grid grid-cols-1 gap-5">
              {MOCK_TESTS_CATALOG.map((mock) => {
                const attempt = savedAttempts[mock.id];
                const isPaused = attempt && attempt.status === 'paused';
                const isCompleted = attempt && attempt.status === 'completed';

                return (
                  <div
                    key={mock.id}
                    className={`bg-white rounded-2xl border-2 p-6 shadow-sm transition hover:shadow-md ${
                      mock.id === 1 ? 'border-blue-500' : 'border-slate-300'
                    }`}
                  >
                    <div className="flex flex-wrap items-start justify-between gap-4 mb-4">
                      <div>
                        <div className="flex items-center gap-2 mb-1.5">
                          <span className="px-2.5 py-0.5 bg-blue-100 text-blue-800 font-bold text-[11px] rounded-full uppercase tracking-wider">
                            Mock Test 0{mock.id}
                          </span>
                          <span className="px-2.5 py-0.5 bg-emerald-100 text-emerald-800 font-bold text-[11px] rounded-full uppercase tracking-wider">
                            Bilingual (English + हिंदी)
                          </span>
                          <span className="px-2.5 py-0.5 bg-slate-100 text-slate-700 font-mono text-[11px] rounded-full">
                            Table: {mock.responseTable}
                          </span>
                          {isPaused && (
                            <span className="px-2.5 py-0.5 bg-amber-500 text-slate-900 font-black text-[11px] rounded-full animate-pulse uppercase tracking-wider">
                              Paused (In Progress)
                            </span>
                          )}
                          {isCompleted && (
                            <span className="px-2.5 py-0.5 bg-purple-100 text-purple-800 font-bold text-[11px] rounded-full uppercase tracking-wider">
                              Completed (Score: {attempt.score?.toFixed(2)})
                            </span>
                          )}
                        </div>

                        <h3 className="text-xl sm:text-2xl font-black text-slate-900">
                          {mock.title}
                        </h3>
                        <p className="text-xs text-slate-600 mt-1">
                          {mock.description}
                        </p>
                      </div>

                      <div className="flex items-center gap-3">
                        {isPaused ? (
                          <button
                            onClick={() => handleResumeClick(mock)}
                            className="flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-700 hover:to-teal-700 text-white font-bold text-sm uppercase tracking-wider rounded-xl shadow-md transition transform active:scale-95"
                          >
                            <Play className="w-4 h-4 fill-current" />
                            <span>Resume Test</span>
                          </button>
                        ) : (
                          <button
                            onClick={() => handleStartClick(mock)}
                            className="flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-blue-600 to-indigo-700 hover:from-blue-700 hover:to-indigo-800 text-white font-bold text-sm uppercase tracking-wider rounded-xl shadow-md transition transform active:scale-95"
                          >
                            <Play className="w-4 h-4 fill-current" />
                            <span>{isCompleted ? "Re-Take Test" : "Start Mock Test"}</span>
                          </button>
                        )}
                      </div>
                    </div>

                    {/* Section Breakdown Grid */}
                    <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 pt-4 border-t border-slate-200 text-xs">
                      <div className="p-2.5 bg-slate-50 rounded-lg border border-slate-200">
                        <span className="text-slate-500 block text-[11px]">Section 1</span>
                        <strong className="text-slate-800 text-xs">General Science</strong>
                        <div className="text-slate-600 font-mono text-[11px] mt-0.5">25 Qs &bull; 25 Marks</div>
                      </div>

                      <div className="p-2.5 bg-slate-50 rounded-lg border border-slate-200">
                        <span className="text-slate-500 block text-[11px]">Section 2</span>
                        <strong className="text-slate-800 text-xs">Mathematics</strong>
                        <div className="text-slate-600 font-mono text-[11px] mt-0.5">25 Qs &bull; 25 Marks</div>
                      </div>

                      <div className="p-2.5 bg-slate-50 rounded-lg border border-slate-200">
                        <span className="text-slate-500 block text-[11px]">Section 3</span>
                        <strong className="text-slate-800 text-xs">Reasoning</strong>
                        <div className="text-slate-600 font-mono text-[11px] mt-0.5">30 Qs &bull; 30 Marks</div>
                      </div>

                      <div className="p-2.5 bg-slate-50 rounded-lg border border-slate-200">
                        <span className="text-slate-500 block text-[11px]">Section 4</span>
                        <strong className="text-slate-800 text-xs">General Awareness</strong>
                        <div className="text-slate-600 font-mono text-[11px] mt-0.5">20 Qs &bull; 20 Marks</div>
                      </div>
                    </div>

                    <div className="mt-4 flex flex-wrap items-center gap-4 text-xs text-slate-500 pt-2 border-t border-slate-100">
                      <span className="flex items-center gap-1">
                        <Clock className="w-3.5 h-3.5 text-blue-500" /> 90 Mins Total Duration
                      </span>
                      <span className="flex items-center gap-1">
                        <CheckCircle className="w-3.5 h-3.5 text-emerald-500" /> +1.0 for Correct Answer
                      </span>
                      <span className="flex items-center gap-1">
                        <AlertCircle className="w-3.5 h-3.5 text-red-500" /> -0.33 (1/3rd) Negative Marking
                      </span>
                      <span className="flex items-center gap-1">
                        <Sparkles className="w-3.5 h-3.5 text-purple-500" /> Submits to table: {mock.responseTable}
                      </span>
                    </div>

                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* Tab 2: Attempt History */}
        {activeTab === 'history' && (
          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 space-y-4">
            <h3 className="font-bold text-base text-slate-900">
              Exam Performance History
            </h3>

            {Object.keys(savedAttempts).length > 0 ? (
              <div className="space-y-3">
                {Object.entries(savedAttempts).map(([mockId, attempt]) => (
                  <div key={mockId} className="p-4 bg-slate-50 border border-slate-200 rounded-xl space-y-2">
                    <div className="flex items-center justify-between">
                      <div>
                        <h4 className="font-bold text-slate-900 text-sm">
                          RRB Group D CBT Mock Test 0{mockId}
                        </h4>
                        <span className="text-xs text-slate-500">
                          Status: <strong className="capitalize">{attempt.status}</strong> &bull; Synced to <span className="font-mono">RRB_MOCK_{mockId}_responses</span>
                        </span>
                      </div>
                      <span className="text-lg font-black text-blue-700">
                        Score: {attempt.score?.toFixed(2) || '0.00'} / 100
                      </span>
                    </div>

                    <div className="grid grid-cols-3 gap-2 text-center text-xs">
                      <div className="bg-emerald-50 border border-emerald-200 p-2 rounded">
                        <span className="text-slate-500 block text-[10px]">Correct</span>
                        <strong className="text-emerald-700 font-bold">{attempt.correctCount || 0}</strong>
                      </div>
                      <div className="bg-red-50 border border-red-200 p-2 rounded">
                        <span className="text-slate-500 block text-[10px]">Incorrect</span>
                        <strong className="text-red-700 font-bold">{attempt.incorrectCount || 0}</strong>
                      </div>
                      <div className="bg-sky-50 border border-sky-200 p-2 rounded">
                        <span className="text-slate-500 block text-[10px]">Accuracy</span>
                        <strong className="text-sky-700 font-bold">{attempt.accuracy?.toFixed(1) || 0}%</strong>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-10 text-slate-500 text-sm">
                <FileCheck2 className="w-12 h-12 text-slate-300 mx-auto mb-2" />
                <p>No completed test attempts yet. Start any mock test to see your performance history.</p>
              </div>
            )}
          </div>
        )}

      </main>

      {/* Pre-Exam Instructions & Declaration Modal */}
      <InstructionsModal
        isOpen={showInstructions}
        onClose={() => setShowInstructions(false)}
        onStartExam={handleInstructionsProceed}
        isPreExam={true}
        defaultLang={defaultLang}
        onChangeDefaultLang={setDefaultLang}
      />

      {/* Footer */}
      <footer className="bg-slate-200 border-t border-slate-300 py-3 text-center text-xs text-slate-600">
        RRB Mock Test Portal &bull; Official TCS iON Computer-Based Test Engine
      </footer>

    </div>
  );
}
