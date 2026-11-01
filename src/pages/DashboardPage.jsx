import React, { useState, useEffect } from 'react';
import Navbar from '../components/Navbar';
import InstructionsModal from '../components/InstructionsModal';
import { Play, RotateCcw, Clock, Award, BookOpen, CheckCircle, BarChart3, AlertCircle, FileCheck2, Sparkles, Trophy, Medal, Users, TrendingUp, Target } from 'lucide-react';
import { getTestAttempt, fetchLeaderboard } from '../services/apiService';

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
  const [leaderboardFilter, setLeaderboardFilter] = useState('all');
  const [leaderboardData, setLeaderboardData] = useState([]);
  const [loadingLeaderboard, setLoadingLeaderboard] = useState(false);

  useEffect(() => {
    if (activeTab === 'leaderboard') {
      setLoadingLeaderboard(true);
      fetchLeaderboard(leaderboardFilter).then((data) => {
        setLeaderboardData(data);
        setLoadingLeaderboard(false);
      });
    }
  }, [activeTab, leaderboardFilter]);

  // Leaderboard statistics computation
  const rankedList = leaderboardData.filter(d => d.score !== undefined && d.score !== null);
  const totalRanked = rankedList.length;
  const highestScore = totalRanked > 0 ? Math.max(...rankedList.map(d => Number(d.score || 0))) : 0;
  const avgScore = totalRanked > 0
    ? rankedList.reduce((acc, cur) => acc + Number(cur.score || 0), 0) / totalRanked
    : 0;

  let myRank = -1;
  let myScore = 0;
  let myAccuracy = 0;
  let myPercentile = 0;

  if (candidate?.mobile_number && totalRanked > 0) {
    const idx = rankedList.findIndex(d => d.candidate_mobile === candidate.mobile_number);
    if (idx >= 0) {
      myRank = idx + 1;
      myScore = Number(rankedList[idx].score || 0);
      myAccuracy = Number(rankedList[idx].accuracy || 0);
      myPercentile = (((totalRanked - myRank + 1) / totalRanked) * 100).toFixed(1);
    }
  }

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
    const existing = savedAttempts[selectedMock.id];
    const isRetake = existing && existing.status === 'completed';
    onStartExam({
      mockNumber: selectedMock.id,
      testId: selectedMock.testId,
      title: selectedMock.title,
      defaultLang,
      isRetake
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

        {/* Tab: Live Leaderboard & All-India Rank */}
        {activeTab === 'leaderboard' && (
          <div className="space-y-6">
            
            {/* Header & Filter Controls */}
            <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 flex flex-wrap items-center justify-between gap-4">
              <div>
                <div className="flex items-center gap-2 mb-1">
                  <Trophy className="w-6 h-6 text-amber-500" />
                  <h3 className="text-xl font-black text-slate-900">
                    All-India CBT Leaderboard & Rank
                  </h3>
                </div>
                <p className="text-xs text-slate-500">
                  Live All-India ranking across candidates based on score and accuracy.
                </p>
              </div>

              {/* Filter Pills */}
              <div className="flex items-center gap-1.5 bg-slate-100 p-1 rounded-xl text-xs font-bold">
                <button
                  onClick={() => setLeaderboardFilter('all')}
                  className={`px-3 py-1.5 rounded-lg transition ${
                    leaderboardFilter === 'all'
                      ? 'bg-blue-600 text-white shadow-sm'
                      : 'text-slate-600 hover:text-slate-900'
                  }`}
                >
                  All Mocks
                </button>
                <button
                  onClick={() => setLeaderboardFilter('rrb_cbt_mock_1')}
                  className={`px-3 py-1.5 rounded-lg transition ${
                    leaderboardFilter === 'rrb_cbt_mock_1'
                      ? 'bg-blue-600 text-white shadow-sm'
                      : 'text-slate-600 hover:text-slate-900'
                  }`}
                >
                  Mock 1
                </button>
                <button
                  onClick={() => setLeaderboardFilter('rrb_cbt_mock_2')}
                  className={`px-3 py-1.5 rounded-lg transition ${
                    leaderboardFilter === 'rrb_cbt_mock_2'
                      ? 'bg-blue-600 text-white shadow-sm'
                      : 'text-slate-600 hover:text-slate-900'
                  }`}
                >
                  Mock 2
                </button>
                <button
                  onClick={() => setLeaderboardFilter('rrb_cbt_mock_3')}
                  className={`px-3 py-1.5 rounded-lg transition ${
                    leaderboardFilter === 'rrb_cbt_mock_3'
                      ? 'bg-blue-600 text-white shadow-sm'
                      : 'text-slate-600 hover:text-slate-900'
                  }`}
                >
                  Mock 3
                </button>
              </div>
            </div>

            {/* Metric Cards Grid */}
            <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
              <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-blue-100 text-blue-600 flex items-center justify-center">
                  <Users className="w-5 h-5" />
                </div>
                <div>
                  <div className="text-xs text-slate-500 font-medium">Candidates Ranked</div>
                  <div className="text-xl font-bold text-slate-900">{totalRanked}</div>
                </div>
              </div>

              <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-amber-100 text-amber-600 flex items-center justify-center">
                  <Trophy className="w-5 h-5" />
                </div>
                <div>
                  <div className="text-xs text-slate-500 font-medium">Highest Score</div>
                  <div className="text-xl font-bold text-amber-600">
                    {highestScore.toFixed(2)} <span className="text-xs text-slate-400 font-normal">/ 100</span>
                  </div>
                </div>
              </div>

              <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-emerald-100 text-emerald-600 flex items-center justify-center">
                  <TrendingUp className="w-5 h-5" />
                </div>
                <div>
                  <div className="text-xs text-slate-500 font-medium">Batch Average</div>
                  <div className="text-xl font-bold text-slate-900">{avgScore.toFixed(2)}</div>
                </div>
              </div>

              <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-purple-100 text-purple-600 flex items-center justify-center">
                  <Target className="w-5 h-5" />
                </div>
                <div>
                  <div className="text-xs text-slate-500 font-medium">Your Standing</div>
                  <div className="text-xl font-bold text-purple-600">
                    {myRank > 0 ? `#${myRank} (${myPercentile}%)` : 'Not Ranked'}
                  </div>
                </div>
              </div>
            </div>

            {/* Candidate Standing Banner (if ranked) */}
            {myRank > 0 && (
              <div className="bg-gradient-to-r from-blue-900 to-indigo-900 rounded-2xl p-5 text-white flex flex-wrap items-center justify-between gap-4 shadow-md">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 rounded-xl bg-amber-400/20 border border-amber-400/40 text-amber-300 flex items-center justify-center font-black text-xl">
                    #{myRank}
                  </div>
                  <div>
                    <div className="text-xs text-blue-200 uppercase tracking-wider font-semibold">
                      Your Official Ranking
                    </div>
                    <div className="text-base sm:text-lg font-bold">
                      {candidate?.name} &bull; Roll: <span className="font-mono text-amber-300">{candidate?.roll_number}</span>
                    </div>
                  </div>
                </div>

                <div className="flex items-center gap-6 text-sm">
                  <div>
                    <div className="text-[11px] text-blue-200">Percentile</div>
                    <div className="text-xl font-black text-emerald-400">{myPercentile}%</div>
                  </div>
                  <div>
                    <div className="text-[11px] text-blue-200">Your Score</div>
                    <div className="text-xl font-black text-amber-300">{myScore.toFixed(2)}</div>
                  </div>
                  <div>
                    <div className="text-[11px] text-blue-200">Accuracy</div>
                    <div className="text-xl font-black text-sky-300">{myAccuracy.toFixed(1)}%</div>
                  </div>
                </div>
              </div>
            )}

            {/* Top 10 Table */}
            <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
              <div className="p-4 sm:p-5 border-b border-slate-200 flex items-center justify-between">
                <h4 className="font-bold text-slate-900 text-sm flex items-center gap-2">
                  <Medal className="w-4 h-4 text-amber-500" />
                  <span>Top 10 Performers Leaderboard</span>
                </h4>
                <span className="text-xs text-slate-500">
                  Sorted by Score & Accuracy
                </span>
              </div>

              {loadingLeaderboard ? (
                <div className="p-12 text-center text-slate-500">
                  <div className="w-8 h-8 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-2"></div>
                  <p className="text-xs">Fetching live All-India rankings...</p>
                </div>
              ) : rankedList.length === 0 ? (
                <div className="p-12 text-center text-slate-500">
                  <FileCheck2 className="w-12 h-12 text-slate-300 mx-auto mb-2" />
                  <p className="text-sm font-semibold text-slate-700">No attempts ranked yet for this test.</p>
                  <p className="text-xs text-slate-400 mt-1">Complete a mock test to appear on the All-India leaderboard.</p>
                </div>
              ) : (
                <div className="overflow-x-auto">
                  <table className="w-full text-left text-xs">
                    <thead className="bg-slate-50 text-slate-600 uppercase font-semibold text-[11px] border-b border-slate-200">
                      <tr>
                        <th className="px-4 py-3 text-center w-16">Rank</th>
                        <th className="px-4 py-3">Candidate Name</th>
                        <th className="px-4 py-3">Roll Number</th>
                        <th className="px-4 py-3">Test</th>
                        <th className="px-4 py-3 text-center">Score</th>
                        <th className="px-4 py-3 text-center">Accuracy</th>
                        <th className="px-4 py-3 text-right">Status</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-100">
                      {rankedList.slice(0, 10).map((item, idx) => {
                        const rank = idx + 1;
                        const isMe = candidate?.mobile_number && item.candidate_mobile === candidate.mobile_number;

                        return (
                          <tr
                            key={idx}
                            className={`transition hover:bg-slate-50 ${
                              isMe ? 'bg-blue-50/70 font-semibold' : ''
                            }`}
                          >
                            <td className="px-4 py-3 text-center">
                              {rank === 1 ? (
                                <span className="inline-flex items-center justify-center w-7 h-7 rounded-full bg-amber-100 text-amber-800 font-black text-sm shadow-sm ring-1 ring-amber-300">
                                  🥇 1
                                </span>
                              ) : rank === 2 ? (
                                <span className="inline-flex items-center justify-center w-7 h-7 rounded-full bg-slate-200 text-slate-700 font-black text-sm shadow-sm ring-1 ring-slate-300">
                                  🥈 2
                                </span>
                              ) : rank === 3 ? (
                                <span className="inline-flex items-center justify-center w-7 h-7 rounded-full bg-amber-50 text-amber-900 font-black text-sm shadow-sm ring-1 ring-amber-400">
                                  🥉 3
                                </span>
                              ) : (
                                <span className="font-bold text-slate-500">#{rank}</span>
                              )}
                            </td>

                            <td className="px-4 py-3">
                              <div className="flex items-center gap-2">
                                <span className="text-slate-900 font-bold">{item.candidate_name || 'Candidate'}</span>
                                {isMe && (
                                  <span className="px-2 py-0.5 bg-blue-600 text-white text-[10px] font-black rounded-full uppercase tracking-wider">
                                    You
                                  </span>
                                )}
                              </div>
                            </td>

                            <td className="px-4 py-3 font-mono text-slate-600">
                              {item.roll_number || (item.candidate_mobile ? `RRB26***${item.candidate_mobile.slice(-3)}` : 'ANONYMOUS')}
                            </td>

                            <td className="px-4 py-3 text-slate-600">
                              {item.test_id === 'rrb_cbt_mock_1'
                                ? 'Mock 01'
                                : item.test_id === 'rrb_cbt_mock_2'
                                ? 'Mock 02'
                                : item.test_id === 'rrb_cbt_mock_3'
                                ? 'Mock 03'
                                : item.test_id}
                            </td>

                            <td className="px-4 py-3 text-center">
                              <span className="font-black text-blue-700 text-sm">
                                {Number(item.score || 0).toFixed(2)}
                              </span>
                            </td>

                            <td className="px-4 py-3 text-center">
                              <span className="font-bold text-emerald-600">
                                {Number(item.accuracy || 0).toFixed(1)}%
                              </span>
                            </td>

                            <td className="px-4 py-3 text-right">
                              <span className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider ${
                                item.status === 'completed'
                                  ? 'bg-emerald-100 text-emerald-800'
                                  : 'bg-amber-100 text-amber-800'
                              }`}>
                                {item.status || 'completed'}
                              </span>
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                </div>
              )}
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
