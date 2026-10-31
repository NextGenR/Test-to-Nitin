import React, { useState, useEffect } from 'react';
import LoginPage from './pages/LoginPage';
import DashboardPage from './pages/DashboardPage';
import CBTExamPage from './pages/CBTExamPage';
import { getCachedCandidate, clearCandidateSession, getTestAttempt } from './services/apiService';

const ACTIVE_PAGE_KEY = 'rrb_active_page';
const ACTIVE_CONFIG_KEY = 'rrb_active_exam_config';

export default function App() {
  const [currentPage, setCurrentPage] = useState('login'); // 'login' | 'dashboard' | 'exam'
  const [activeCandidate, setActiveCandidate] = useState(null);
  const [activeExamConfig, setActiveExamConfig] = useState(null);
  const [initialAttemptData, setInitialAttemptData] = useState(null);

  // Check cached session on mount & restore active exam if candidate refreshed while taking test
  useEffect(() => {
    const cached = getCachedCandidate();
    if (cached && cached.mobile_number) {
      setActiveCandidate(cached);

      const savedPage = localStorage.getItem(ACTIVE_PAGE_KEY);
      const savedConfigRaw = localStorage.getItem(ACTIVE_CONFIG_KEY);

      if (savedPage === 'exam' && savedConfigRaw) {
        try {
          const config = JSON.parse(savedConfigRaw);
          setActiveExamConfig(config);

          // Restore saved attempt from localStorage/DB
          getTestAttempt(cached.mobile_number, config.testId || `rrb_cbt_mock_${config.mockNumber || 1}`).then((attempt) => {
            if (attempt) {
              setInitialAttemptData(attempt);
            }
            setCurrentPage('exam');
          });
          return;
        } catch (e) {
          console.warn("Failed to parse saved exam config:", e);
        }
      }

      setCurrentPage('dashboard');
    } else {
      setCurrentPage('login');
    }
  }, []);

  const handleLoginSuccess = (candidate) => {
    setActiveCandidate(candidate);
    localStorage.setItem(ACTIVE_PAGE_KEY, 'dashboard');
    setCurrentPage('dashboard');
  };

  const handleLogout = () => {
    clearCandidateSession();
    localStorage.removeItem(ACTIVE_PAGE_KEY);
    localStorage.removeItem(ACTIVE_CONFIG_KEY);
    setActiveCandidate(null);
    setActiveExamConfig(null);
    setInitialAttemptData(null);
    setCurrentPage('login');
  };

  const handleStartExam = (config = {}) => {
    const examConfig = {
      mockNumber: config.mockNumber || 1,
      testId: config.testId || `rrb_cbt_mock_${config.mockNumber || 1}`,
      title: config.title || `RRB Group D CBT Mock Test 0${config.mockNumber || 1}`,
      defaultLang: config.defaultLang || 'en'
    };

    setActiveExamConfig(examConfig);
    setInitialAttemptData(null);
    localStorage.setItem(ACTIVE_PAGE_KEY, 'exam');
    localStorage.setItem(ACTIVE_CONFIG_KEY, JSON.stringify(examConfig));
    setCurrentPage('exam');
  };

  const handleResumeExam = (savedAttempt, mock) => {
    const examConfig = {
      mockNumber: mock?.id || 1,
      testId: mock?.testId || `rrb_cbt_mock_${mock?.id || 1}`,
      title: mock?.title || `RRB Group D CBT Mock Test 0${mock?.id || 1}`,
      defaultLang: 'en'
    };

    setActiveExamConfig(examConfig);
    setInitialAttemptData(savedAttempt);
    localStorage.setItem(ACTIVE_PAGE_KEY, 'exam');
    localStorage.setItem(ACTIVE_CONFIG_KEY, JSON.stringify(examConfig));
    setCurrentPage('exam');
  };

  const handleFinishExam = () => {
    localStorage.setItem(ACTIVE_PAGE_KEY, 'dashboard');
    localStorage.removeItem(ACTIVE_CONFIG_KEY);
    setActiveExamConfig(null);
    setInitialAttemptData(null);
    setCurrentPage('dashboard');
  };

  return (
    <div className="w-full min-h-screen font-sans bg-[#f4f7f9]">
      {currentPage === 'login' && (
        <LoginPage onLoginSuccess={handleLoginSuccess} />
      )}

      {currentPage === 'dashboard' && (
        <DashboardPage
          candidate={activeCandidate}
          onStartExam={handleStartExam}
          onResumeExam={handleResumeExam}
          onLogout={handleLogout}
        />
      )}

      {currentPage === 'exam' && (
        <CBTExamPage
          candidate={activeCandidate}
          initialAttempt={initialAttemptData}
          mockNumber={activeExamConfig?.mockNumber || 1}
          testId={activeExamConfig?.testId || 'rrb_cbt_mock_1'}
          testTitle={activeExamConfig?.title || 'RRB Group D CBT Mock Test 01'}
          defaultLang={activeExamConfig?.defaultLang || 'en'}
          onFinishExam={handleFinishExam}
        />
      )}
    </div>
  );
}
