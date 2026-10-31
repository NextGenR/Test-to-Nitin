// Remote Backend API Configuration
export const API_ENDPOINT = "https://zgxskpqsjylbwrhhrzim.supabase.co/rest/v1";
export const API_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpneHNrcHFzanlsYndyaGhyemltIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODczODY0MDIsImV4cCI6MjEwMjk2MjQwMn0.1RSVtWx8gxJhQcmDfJMvRfRLMvl4ju9GuwxgiKn5f8w";

export const getHeaders = () => ({
  "Content-Type": "application/json",
  "apikey": API_KEY,
  "Authorization": `Bearer ${API_KEY}`,
  "Prefer": "return=representation"
});
