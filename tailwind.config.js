/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        tcs: {
          header: '#30475e',
          accent: '#222831',
          primary: '#1d638a',
          secondary: '#337ab7',
          answered: '#5cb85c',
          notAnswered: '#d9534f',
          notVisited: '#e0e0e0',
          review: '#7b1fa2',
          reviewAnswered: '#512da8'
        }
      }
    },
  },
  plugins: [],
}
