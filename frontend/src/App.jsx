import React, { useState, useEffect } from 'react';
import { 
  Home, CloudSun, Users, User, Bell, ChevronRight, 
  Leaf, ArrowLeft, Phone, MapPin, ChevronDown, 
  RefreshCw, Headset, Check, Sprout, Tractor, BrainCircuit,
  Globe, LayoutGrid, Droplet, Maximize, CalendarClock, ThermometerSun, AlertTriangle,
  Menu, Search, Wind, Umbrella, Calendar, CloudRain, BarChart2, SunMedium,
  Map, Settings, Cloud, ThumbsUp, MessageSquare, Share2, Plus,
  Camera, Send, CheckCircle2, Bookmark, Edit3, FileText, ShoppingBag, LogOut,
  HelpCircle, Zap, Grid, Clock, Upload, AlertCircle, ShieldCheck
} from 'lucide-react';
import { fetchWeather, fetchCityName, getCommunityPosts, createPost, predictDisease } from './services/api';
import { FarmerSVG } from './components/FarmerSVG';

export default function App() {
  const [currentScreen, setCurrentScreen] = useState('splash');
  const [activeTab, setActiveTab] = useState('home');
  const [weatherData, setWeatherData] = useState(null);
  const [city, setCity] = useState('Your Location');
  const [posts, setPosts] = useState([]);
  const [diseaseResult, setDiseaseResult] = useState(null);

  // Auto-advance splash screen
  useEffect(() => {
    if (currentScreen === 'splash') {
      const timer = setTimeout(() => setCurrentScreen('login'), 3000);
      return () => clearTimeout(timer);
    }
  }, [currentScreen]);

  // Fetch weather on load
  useEffect(() => {
    navigator.geolocation.getCurrentPosition(
      async ({ coords }) => {
        const [weather, cityName] = await Promise.all([
          fetchWeather(coords.latitude, coords.longitude),
          fetchCityName(coords.latitude, coords.longitude)
        ]);
        setWeatherData(weather);
        setCity(cityName);
      },
      async () => {
        // Default to Ludhiana, Punjab if geolocation denied
        const weather = await fetchWeather(30.9, 75.85);
        setWeatherData(weather);
        setCity('Ludhiana');
      }
    );
    setPosts(getCommunityPosts());
  }, []);

  // ─── SCREENS ────────────────────────────────────────────

  const SplashScreen = () => (
    <div className="flex flex-col items-center justify-center h-full flex-1 bg-gradient-to-b from-[#e1f0e6] via-[#f4f9f6] to-[#e1f0e6] px-6 text-center animate-in fade-in duration-1000">
      <div className="w-[200px] h-[200px] bg-white rounded-full flex flex-col items-center justify-end relative mb-6 shadow-[0_12px_40px_rgba(0,0,0,0.06)] overflow-hidden border-4 border-white">
        <div className="absolute bottom-5 w-[120px] h-[20px] bg-[#d1d5db] rounded-[100%] z-0"></div>
        <FarmerSVG />
      </div>
      <h2 className="text-[#2e7d32] text-[20px] font-bold mb-1.5">Namaste Kisan</h2>
      <div className="w-[50px] h-[4px] bg-[#f97316] rounded-full mb-10"></div>
      <h1 className="text-[32px] font-extrabold text-[#161f2b] mb-4 leading-[1.25] tracking-tight">Smart Crop Disease<br/>Detection</h1>
      <p className="text-[#2e7d32] font-semibold text-[15px]">Smart Farming Powered by AI</p>
    </div>
  );

  const LoginScreen = () => (
    <div className="flex flex-col h-full bg-[#eef4f0] animate-in slide-in-from-right-4 duration-300">
      <div className="flex items-center px-4 h-16 pt-2">
        <button onClick={() => setCurrentScreen('splash')} className="p-2"><ArrowLeft className="w-6 h-6 text-[#161f2b] stroke-[2.5]" /></button>
        <h2 className="flex-1 text-center text-[19px] font-extrabold text-[#161f2b] -ml-6">Create Account</h2>
      </div>
      <div className="px-5 flex-1 overflow-y-auto no-scrollbar pb-6 flex flex-col mt-2">
        <div className="w-full h-[150px] rounded-[14px] mb-8 relative overflow-hidden flex flex-col items-center justify-center shadow-sm">
           <img src="https://images.unsplash.com/photo-1592982537447-6f2a6a0a091c?q=80&w=1000&auto=format&fit=crop" alt="Farm Field" className="absolute inset-0 w-full h-full object-cover opacity-80 mix-blend-luminosity" />
           <div className="absolute inset-0 bg-[#8bc34a]/40 mix-blend-multiply"></div>
           <div className="w-[56px] h-[56px] bg-[#2e7d32] rounded-full flex items-center justify-center z-10 mb-3 shadow-md"><BrainCircuit className="text-white w-7 h-7" strokeWidth={2.5} /></div>
           <span className="z-10 text-[#1b5e20] font-bold text-[16px] tracking-wide drop-shadow-sm">AI Smart Crop Care</span>
        </div>
        <div className="space-y-4">
          <div>
            <label className="block text-[13px] font-extrabold text-[#44505c] mb-2 ml-1">Full Name</label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none"><User className="h-[20px] w-[20px] text-[#2e7d32]" strokeWidth={2.5} /></div>
              <input type="text" placeholder="John Doe" className="w-full pl-12 pr-4 py-4 bg-white border border-transparent rounded-[14px] text-[15px] font-medium focus:border-[#2e7d32] focus:ring-1 focus:ring-[#2e7d32] outline-none shadow-sm text-gray-800 placeholder-[#8a949c]" />
            </div>
          </div>
          <div>
            <label className="block text-[13px] font-extrabold text-[#44505c] mb-2 ml-1">Mobile Number</label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none"><Phone className="h-[20px] w-[20px] text-[#2e7d32]" strokeWidth={2.5} /></div>
              <input type="tel" placeholder="+1 234 567 890" className="w-full pl-12 pr-4 py-4 bg-white border border-transparent rounded-[14px] text-[15px] font-medium focus:border-[#2e7d32] focus:ring-1 focus:ring-[#2e7d32] outline-none shadow-sm text-gray-800 placeholder-[#8a949c]" />
            </div>
          </div>
          <div>
            <label className="block text-[13px] font-extrabold text-[#44505c] mb-2 ml-1">Farm Location</label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none"><MapPin className="h-[20px] w-[20px] text-[#2e7d32]" strokeWidth={2.5} /></div>
              <select className="w-full pl-12 pr-10 py-4 bg-white border border-transparent rounded-[14px] text-[15px] font-medium focus:border-[#2e7d32] focus:ring-1 focus:ring-[#2e7d32] outline-none shadow-sm appearance-none text-[#161f2b]"><option>Select your region</option><option>Punjab</option><option>Haryana</option><option>UP</option><option>MP</option></select>
              <div className="absolute inset-y-0 right-0 pr-4 flex items-center pointer-events-none"><ChevronDown className="h-5 w-5 text-[#8a949c]" strokeWidth={2.5} /></div>
            </div>
          </div>
          <div className="flex items-start mt-6 mb-8 px-1">
            <div className="flex items-center h-5 mt-0.5"><div className="w-5 h-5 border-[1.5px] border-[#c0cbce] bg-white rounded flex items-center justify-center"></div></div>
            <div className="ml-3 text-[12px] text-[#64748b] leading-[18px]">By signing up, you agree to our <span className="text-[#2e7d32] font-bold">Terms of Service</span> and <span className="text-[#2e7d32] font-bold">Privacy Policy</span>.</div>
          </div>
        </div>
        <div className="mt-auto pt-2 pb-2">
          <button onClick={() => setCurrentScreen('otp')} className="w-full bg-[#2e7d32] text-white py-[17px] rounded-[14px] font-bold text-[16px] flex justify-center items-center shadow-md active:scale-[0.98] transition-all">Send OTP <ChevronRight className="w-5 h-5 ml-1" strokeWidth={2.5} /></button>
          <p className="text-center text-[13.5px] text-[#64748b] mt-6 font-medium">Already have an account? <span className="text-[#2e7d32] font-bold">Log In</span></p>
        </div>
      </div>
    </div>
  );

  const OtpScreen = () => (
    <div className="flex flex-col h-full bg-[#eef4f0] animate-in slide-in-from-right-4 duration-300">
      <div className="flex items-center px-4 h-16 pt-2">
        <button onClick={() => setCurrentScreen('login')} className="p-2"><ArrowLeft className="w-6 h-6 text-[#161f2b] stroke-[2.5]" /></button>
        <h2 className="flex-1 text-center text-[19px] font-extrabold text-[#161f2b] -ml-6">Verify Mobile</h2>
      </div>
      <div className="px-6 flex-1 flex flex-col pt-8 pb-8">
        <div className="w-[88px] h-[88px] bg-[#d3ebd9] rounded-full flex justify-center items-center mx-auto mb-8">
          <div className="w-[34px] h-[46px] bg-[#2e7d32] rounded-md relative flex items-center justify-end pr-1">
             <div className="w-2 h-2 bg-[#d3ebd9] rounded-full absolute top-1 left-1"></div>
          </div>
        </div>
        <h2 className="text-[26px] font-extrabold text-[#161f2b] text-center mb-4">Verify Mobile</h2>
        <p className="text-center text-[#556370] mb-10 text-[15px] leading-relaxed px-1">We've sent a 4-digit verification code to your mobile number for secure access to <span className="text-[#2e7d32] font-bold">Smart Crop Detection.</span></p>
        <div className="flex justify-center gap-4 mb-8">
          {[1, 2, 3, 4].map(i => (
            <div key={i} className="w-[60px] h-[64px] bg-white rounded-[14px] flex items-center justify-center shadow-sm border border-[#e2e8f0]"><div className="w-2 h-2 bg-[#718096] rounded-full"></div></div>
          ))}
        </div>
        <button onClick={() => setCurrentScreen('success')} className="w-full bg-[#2e7d32] text-white py-[17px] rounded-[14px] font-bold text-[16px] flex justify-center items-center shadow-md active:scale-[0.98] transition-all mb-8">Verify & Continue <ChevronRight className="w-5 h-5 ml-1" strokeWidth={2.5} /></button>
        <div className="text-center">
          <p className="text-[14px] text-[#64748b] font-medium mb-2">Didn't receive the code?</p>
          <button className="flex items-center justify-center gap-1.5 text-[#2e7d32] font-bold text-[14.5px] mx-auto active:opacity-70"><RefreshCw className="w-4 h-4" strokeWidth={3} /> Resend OTP</button>
        </div>
        <div className="mt-auto pt-10"><div className="bg-[#e2efe6] rounded-[14px] py-[15px] px-4 flex items-center justify-center gap-2 text-[#2e7d32] text-[13px] font-bold"><Headset className="w-[18px] h-[18px]" strokeWidth={2.5} /> Need help? Contact local field agent</div></div>
      </div>
    </div>
  );

  const SuccessScreen = () => (
    <div className="flex flex-col h-full bg-[#eef4f0] animate-in slide-in-from-right-4 duration-300">
      <div className="flex items-center px-4 h-16 pt-2 border-b border-[#e2e8f0]"><button onClick={() => setCurrentScreen('otp')} className="p-2"><ArrowLeft className="w-6 h-6 text-[#161f2b] stroke-[2.5]" /></button><h2 className="flex-1 text-center text-[19px] font-extrabold text-[#161f2b] -ml-6">Verification</h2></div>
      <div className="px-6 flex-1 flex flex-col pt-16 pb-8">
        <div className="w-[110px] h-[110px] bg-[#d3ebd9] rounded-full flex justify-center items-center mx-auto mb-10 relative">
          <div className="w-[76px] h-[76px] bg-[#2e7d32] rounded-full flex justify-center items-center shadow-[0_4px_15px_rgb(46,125,50,0.3)]"><Check className="w-10 h-10 text-white" strokeWidth={4} /></div>
        </div>
        <h2 className="text-[26px] font-extrabold text-[#161f2b] text-center mb-4">Verification Successful!</h2>
        <p className="text-center text-[#556370] mb-12 text-[15px] leading-[1.6] px-2">Your account is now ready. Start your smart farming journey today.</p>
        <div className="w-full h-[150px] bg-[#e4ece7] rounded-[20px] flex items-center justify-center gap-6 shadow-sm border border-white/40 mb-auto">
           <Sprout className="w-[42px] h-[42px] text-[#a1c2a8]" strokeWidth={2} />
           <Tractor className="w-[68px] h-[68px] text-[#8cb995]" strokeWidth={1.5} />
           <Leaf className="w-[42px] h-[42px] text-[#a1c2a8]" strokeWidth={2} />
        </div>
        <div className="mt-auto pt-8">
          <button onClick={() => setCurrentScreen('language')} className="w-full bg-[#2e7d32] text-white py-[17px] rounded-[14px] font-bold text-[16px] flex justify-center items-center shadow-md active:scale-[0.98] transition-all">Go to Dashboard</button>
          <p className="text-center text-[12px] font-bold text-[#7a5e50] mt-5 pb-1">Step into the future of farming</p>
        </div>
      </div>
    </div>
  );

  const LanguageScreen = () => (
    <div className="flex flex-col h-full bg-[#eef4f0] animate-in slide-in-from-right-4 duration-300">
      <div className="flex items-center px-4 h-16 pt-2"><button onClick={() => setCurrentScreen('success')} className="p-2"><ArrowLeft className="w-6 h-6 text-[#161f2b] stroke-[2.5]" /></button><h2 className="flex-1 text-center text-[19px] font-extrabold text-[#161f2b] -ml-6">Settings</h2></div>
      <div className="px-5 flex-1 flex flex-col pt-8 pb-6 overflow-y-auto no-scrollbar">
        <div className="w-[88px] h-[88px] bg-white rounded-[24px] flex justify-center items-center mx-auto mb-8 shadow-sm border border-gray-100"><Globe className="w-12 h-12 text-[#2e7d32]" strokeWidth={2} /></div>
        <h2 className="text-[24px] font-extrabold text-[#161f2b] mb-3 text-center">Select Your Language</h2>
        <p className="text-center text-[#556370] mb-8 text-[14.5px] leading-relaxed px-4">Choose your preferred language to customize your experience.</p>
        <div className="space-y-3 mb-8">
          {[{ id: 'hi', label: 'Hindi', native: 'हिन्दी' }, { id: 'pa', label: 'Punjabi', native: 'ਪੰਜਾਬੀ' }, { id: 'mr', label: 'Marathi', native: 'मराठी' }, { id: 'gu', label: 'Gujarati', native: 'ગુજરાતી' }, { id: 'ta', label: 'Tamil', native: 'தமிழ்' }, { id: 'te', label: 'Telugu', native: 'తెలుగు' }].map((lang) => (
            <button key={lang.id} className="w-full bg-white border border-[#e2e8f0]/80 py-3 px-5 rounded-[16px] flex items-center justify-between shadow-sm active:bg-[#e4ece7] transition-all group">
              <div className="flex flex-col items-start"><span className="font-extrabold text-[#161f2b] text-[17px] mb-0.5">{lang.native}</span><span className="text-[#8a949c] font-bold text-[12px] uppercase tracking-wider">{lang.label}</span></div>
              <ChevronRight className="w-5 h-5 text-[#8a949c] group-active:text-[#2e7d32]" />
            </button>
          ))}
        </div>
        <div className="mt-auto"><button onClick={() => setCurrentScreen('main')} className="w-full bg-[#2e7d32] text-white py-[17px] rounded-[14px] font-bold text-[16px] flex justify-center items-center shadow-md active:scale-[0.98] transition-all">Continue</button></div>
      </div>
    </div>
  );

  const HomeScreen = () => (
    <div className="p-5 pb-36 animate-in fade-in duration-300">
      <div className="flex justify-between items-center mb-6">
        <div className="flex items-center gap-3">
          <div className="w-11 h-11 bg-[#f4dcd6] rounded-full flex items-center justify-center border border-black/5 shadow-sm overflow-hidden"><div className="w-4 h-6 bg-white/90 rounded-sm flex flex-col items-center justify-center gap-[2px] border border-[#dca8a0]/30 shadow-sm"><div className="w-2 h-[2px] bg-[#dca8a0] rounded-full"></div><div className="w-2 h-[2px] bg-[#dca8a0] rounded-full opacity-50"></div></div></div>
          <div className="flex flex-col"><p className="text-[#2e7d32] text-[10px] font-extrabold tracking-widest uppercase mb-0.5">Welcome Back,</p><h2 className="text-[17px] font-extrabold text-[#161f2b] leading-none tracking-tight">Green Acres Farm</h2></div>
        </div>
        <button onClick={() => setActiveTab('alerts')} className="relative p-1 active:scale-95 transition-transform"><Bell className="w-[22px] h-[22px] text-[#161f2b] fill-[#161f2b]" strokeWidth={1} /><span className="absolute top-[2px] right-[2px] w-2.5 h-2.5 bg-[#ef4444] rounded-full border-2 border-[#eef4f0]"></span></button>
      </div>
      <div className="bg-[#439c47] rounded-[18px] p-5 text-white shadow-md relative overflow-hidden mb-8 cursor-pointer" onClick={() => setActiveTab('weather')}>
        <div className="absolute -right-4 top-2 opacity-20 pointer-events-none"><CloudSun className="w-[120px] h-[120px] fill-white text-white" /></div>
        <p className="text-white text-[12px] font-bold mb-1 tracking-wide">Local Weather • {city}</p>
        <div className="flex items-baseline gap-2 mb-3"><h1 className="text-[42px] font-extrabold leading-none tracking-tighter">{weatherData ? `${weatherData.temperature}°C` : '...'}</h1><span className="text-white/95 font-medium text-[15px]">{weatherData ? weatherData.description : 'Loading...'}</span></div>
        <div className="flex items-center gap-1.5 opacity-90"><Droplet className="w-3 h-3 fill-white" /><span className="text-[11px] font-medium tracking-wide">{weatherData ? weatherData.rainProbability : 0}% Chance of rain today</span></div>
      </div>
      <div className="flex items-center gap-2.5 mb-4"><LayoutGrid className="w-6 h-6 text-[#2e7d32]" strokeWidth={2.5} /><h3 className="text-[19px] font-extrabold text-[#161f2b]">Quick Actions</h3></div>
      <div className="bg-white rounded-[16px] p-5 shadow-[0_2px_10px_rgba(0,0,0,0.03)] border border-[#e2e8f0]/60 mb-4 relative overflow-hidden flex items-center gap-4 active:bg-gray-50 transition-colors cursor-pointer" onClick={() => setCurrentScreen('scan')}>
        <div className="absolute right-[-20px] top-[-10px] opacity-[0.04] pointer-events-none"><Sprout className="w-40 h-40 text-[#161f2b] fill-current" /></div>
        <div className="w-14 h-14 bg-[#eef4f0] rounded-[14px] flex items-center justify-center shrink-0"><Maximize className="w-6 h-6 text-[#2e7d32]" strokeWidth={2.5} /></div>
        <div className="z-10"><h4 className="text-[16px] font-extrabold text-[#161f2b] mb-1">Scan Crop Disease</h4><p className="text-[#8a949c] text-[12px] leading-snug font-medium pr-4">Identify pests and diseases instantly</p></div>
      </div>
      <div className="grid grid-cols-2 gap-4 mb-8">
        {[
          { title: "Crop Cycle Tracker", icon: <CalendarClock className="w-6 h-6 text-[#2e7d32]" strokeWidth={2}/>, onClick: () => setActiveTab('tracker') },
          { title: "Weather Forecast", icon: <ThermometerSun className="w-6 h-6 text-[#2e7d32]" strokeWidth={2}/>, onClick: () => setActiveTab('weather') },
          { title: "Smart Alerts", icon: <AlertTriangle className="w-6 h-6 text-[#2e7d32]" strokeWidth={2}/>, onClick: () => setActiveTab('alerts') },
          { title: "Farm Map", icon: <Map className="w-6 h-6 text-[#2e7d32]" strokeWidth={2}/>, onClick: () => setActiveTab('map') }
        ].map((action, idx) => (
          <div key={idx} onClick={action.onClick} className="bg-white rounded-[16px] p-4 shadow-[0_2px_10px_rgba(0,0,0,0.03)] border border-[#e2e8f0]/60 flex flex-col justify-between min-h-[110px] active:bg-gray-50 transition-colors cursor-pointer">
            <div className="w-11 h-11 bg-[#eef4f0] rounded-[12px] flex items-center justify-center mb-4">{action.icon}</div>
            <h4 className="font-bold text-[#161f2b] text-[13.5px] leading-[1.2] pr-2">{action.title}</h4>
          </div>
        ))}
      </div>
    </div>
  );

  const WeatherScreen = () => (
    <div className="h-full bg-gradient-to-b from-[#d1eedb] via-[#e2f1e6] to-[#eef4f0] pb-24 overflow-y-auto no-scrollbar animate-in fade-in duration-300">
      <div className="flex justify-between items-center px-5 pt-6 mb-8">
        <button className="w-10 h-10 bg-[#cce6d4] rounded-full flex items-center justify-center active:scale-95 transition-transform shadow-sm"><Menu className="w-5 h-5 text-[#2e7d32]" strokeWidth={2.5} /></button>
        <div className="flex flex-col items-center">
          <div className="flex items-center gap-1.5 mb-0.5"><MapPin className="w-4 h-4 text-[#161f2b]" strokeWidth={2.5} /><span className="font-extrabold text-[#161f2b] text-[16.5px]">{city}</span></div>
          <span className="text-[#8a949c] text-[12px] font-bold">{weatherData ? weatherData.date.toLocaleDateString(undefined, { weekday: 'long', day: 'numeric', month: 'short' }) : 'Loading...'}</span>
        </div>
        <button className="w-10 h-10 bg-[#cce6d4] rounded-full flex items-center justify-center active:scale-95 transition-transform shadow-sm"><Search className="w-[18px] h-[18px] text-[#2e7d32]" strokeWidth={2.5} /></button>
      </div>
      <div className="flex flex-col items-center mb-10">
        <div className="relative mb-4">
          <svg width="100" height="100" viewBox="0 0 100 100" className="drop-shadow-sm">
            <circle cx="50" cy="50" r="24" fill="#2e7d32" />
            <rect x="46" y="6" width="8" height="10" fill="#2e7d32" rx="2" /><rect x="46" y="84" width="8" height="10" fill="#2e7d32" rx="2" /><rect x="6" y="46" width="10" height="8" fill="#2e7d32" rx="2" /><rect x="84" y="46" width="10" height="8" fill="#2e7d32" rx="2" />
            <rect x="20" y="20" width="10" height="8" fill="#2e7d32" rx="2" transform="rotate(45 25 24)" /><rect x="70" y="70" width="10" height="8" fill="#2e7d32" rx="2" transform="rotate(45 75 74)" />
            <rect x="20" y="70" width="8" height="10" fill="#2e7d32" rx="2" transform="rotate(-45 24 75)" /><rect x="70" y="20" width="8" height="10" fill="#2e7d32" rx="2" transform="rotate(-45 74 25)" />
            <circle cx="80" cy="18" r="6" fill="#facc15" />
          </svg>
        </div>
        <div className="flex items-start"><h1 className="text-[72px] font-extrabold text-[#161f2b] leading-none tracking-tighter">{weatherData ? weatherData.temperature : '--'}</h1><span className="text-[32px] font-extrabold text-[#161f2b] mt-2">°C</span></div>
        <p className="text-[#556370] text-[18px] font-semibold mt-1">{weatherData ? weatherData.description : 'Loading...'}</p>
      </div>
      <div className="grid grid-cols-2 gap-4 px-5 mb-8">
        {[
          { icon: <Droplet className="w-5 h-5 text-[#3b82f6] fill-[#3b82f6]" />, label: "Humidity", val: weatherData ? `${weatherData.humidity}%` : '--', bg: "bg-blue-50" },
          { icon: <Wind className="w-5 h-5 text-[#2e7d32]" strokeWidth={2.5}/>, label: "Wind", val: weatherData ? `${weatherData.windSpeed} km/h` : '--', bg: "bg-[#eef4f0]" },
          { icon: <Umbrella className="w-5 h-5 text-[#8b5cf6]" strokeWidth={2.5}/>, label: "Rain Prob.", val: weatherData ? `${weatherData.rainProbability}%` : '--', bg: "bg-purple-50" },
          { icon: <SunMedium className="w-5 h-5 text-[#f97316]" strokeWidth={2.5}/>, label: "UV Index", val: weatherData ? weatherData.uvIndex : '--', bg: "bg-orange-50" },
        ].map((item, i) => (
          <div key={i} className="bg-white rounded-[20px] p-[18px] flex items-center gap-3.5 shadow-[0_2px_10px_rgba(0,0,0,0.03)] border border-[#e2e8f0]/40">
            <div className={`w-11 h-11 ${item.bg} rounded-full flex items-center justify-center shrink-0`}>{item.icon}</div>
            <div className="flex flex-col"><span className="text-[11.5px] font-bold text-[#8a949c] mb-0.5">{item.label}</span><span className="font-extrabold text-[#161f2b] text-[15px]">{item.val}</span></div>
          </div>
        ))}
      </div>
      <div className="px-5">
        <div className="flex justify-between items-center mb-4 px-1"><h3 className="font-extrabold text-[#161f2b] text-[17px]">7-Day Forecast</h3><Calendar className="w-5 h-5 text-[#2e7d32]" strokeWidth={2.5}/></div>
        <div className="space-y-2.5">
          {weatherData ? weatherData.forecast.slice(0, 5).map((row, i) => (
            <div key={i} className="bg-white rounded-[16px] px-6 py-[18px] flex justify-between items-center shadow-[0_2px_8px_rgba(0,0,0,0.02)] border border-[#e2e8f0]/40">
              <span className="font-extrabold text-[#161f2b] text-[15px] w-12">{row.date.toLocaleDateString(undefined, { weekday: 'short' })}</span>
              <div className="flex-1 flex justify-center"><SunMedium className="w-5 h-5 text-[#2e7d32] fill-[#2e7d32]" /></div>
              <div className="w-16 flex justify-end gap-2.5 text-[15px]"><span className="font-extrabold text-[#161f2b]">{row.tempMax}°</span><span className="font-bold text-[#8a949c]">{row.tempMin}°</span></div>
            </div>
          )) : <p className="text-center text-[#8a949c] font-bold py-4">Loading forecast...</p>}
        </div>
      </div>
    </div>
  );

  const AlertsScreen = () => (
    <div className="h-full bg-[#eef4f0] pb-24 overflow-y-auto no-scrollbar animate-in fade-in duration-300">
      <div className="flex items-center px-4 h-16 pt-2 bg-white/50 backdrop-blur-md sticky top-0 z-10 border-b border-[#e2e8f0]/60">
        <button onClick={() => setActiveTab('weather')} className="p-2"><ArrowLeft className="w-6 h-6 text-[#161f2b] stroke-[2.5]" /></button>
        <h2 className="flex-1 text-center text-[19px] font-extrabold text-[#161f2b]">Smart Alerts</h2>
        <button className="p-2 relative"><Bell className="w-6 h-6 text-[#161f2b] fill-[#161f2b]" strokeWidth={1} /></button>
      </div>
      <div className="p-5 flex flex-col gap-4">
        <div className="bg-[#d3ebd9] rounded-[16px] p-[18px] flex items-center gap-4 shadow-sm">
          <div className="w-11 h-11 bg-[#2e7d32] rounded-full flex items-center justify-center shrink-0"><BarChart2 className="w-5 h-5 text-white" strokeWidth={3} /></div>
          <div><h4 className="font-extrabold text-[#2e7d32] text-[15px] mb-0.5">System Status</h4><p className="text-[#556370] text-[12.5px] font-medium">3 Active alerts requiring attention</p></div>
        </div>
        {weatherData && weatherData.rainProbability > 50 && (
          <div className="bg-white rounded-[16px] shadow-[0_2px_12px_rgba(0,0,0,0.04)] overflow-hidden relative border border-[#e2e8f0]/60">
            <div className="absolute left-0 top-0 bottom-0 w-[5px] bg-[#da3b3b]"></div>
            <div className="p-4 pl-5">
              <div className="flex items-start gap-3.5 w-full">
                <div className="w-11 h-11 bg-red-50 rounded-[12px] flex items-center justify-center shrink-0"><CloudRain className="w-6 h-6 text-[#da3b3b]" strokeWidth={2.5}/></div>
                <div className="flex-1">
                  <div className="flex justify-between items-center w-full mb-0.5"><p className="text-[#da3b3b] text-[10px] font-extrabold tracking-widest uppercase">Critical</p><span className="text-[11px] font-bold text-[#8a949c]">Just now</span></div>
                  <h4 className="font-extrabold text-[#161f2b] text-[17px] leading-snug mb-1.5">Heavy Rainfall Warning</h4>
                  <p className="text-[#556370] text-[13px] leading-[1.6] mb-4 pr-1">Intense rain expected ({weatherData.rainProbability}% probability). Ensure drainage systems are clear to prevent field flooding.</p>
                  <div className="flex justify-end"><button className="bg-[#da3b3b] text-white px-5 py-2.5 rounded-[10px] font-bold text-[13px] shadow-sm active:scale-95 transition-transform">Take Action</button></div>
                </div>
              </div>
            </div>
          </div>
        )}
        <div className="bg-white rounded-[16px] shadow-[0_2px_12px_rgba(0,0,0,0.04)] overflow-hidden relative border border-[#e2e8f0]/60">
          <div className="absolute left-0 top-0 bottom-0 w-[5px] bg-[#da3b3b]"></div>
          <div className="p-4 pl-5">
            <div className="flex items-start gap-3.5 w-full">
              <div className="w-11 h-11 bg-red-50 rounded-[12px] flex items-center justify-center shrink-0"><CloudRain className="w-6 h-6 text-[#da3b3b]" strokeWidth={2.5}/></div>
              <div className="flex-1">
                <div className="flex justify-between items-center w-full mb-0.5"><p className="text-[#da3b3b] text-[10px] font-extrabold tracking-widest uppercase">Critical</p><span className="text-[11px] font-bold text-[#8a949c]">Just now</span></div>
                <h4 className="font-extrabold text-[#161f2b] text-[17px] leading-snug mb-1.5">Heavy Rainfall Warning</h4>
                <p className="text-[#556370] text-[13px] leading-[1.6] mb-4 pr-1">Intense rain expected within 2 hours. Ensure drainage systems are clear to prevent field flooding.</p>
                <div className="flex justify-end"><button className="bg-[#da3b3b] text-white px-5 py-2.5 rounded-[10px] font-bold text-[13px] shadow-sm active:scale-95 transition-transform">Take Action</button></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );

  const CropTrackerScreen = () => (
    <div className="h-full bg-[#f8faf9] pb-24 overflow-y-auto no-scrollbar animate-in fade-in duration-300">
      <div className="flex items-center justify-between px-5 pt-6 pb-4 bg-white border-b border-[#e2e8f0]/60 sticky top-0 z-10">
        <h2 className="text-[19px] font-extrabold text-[#161f2b]">Crop Cycle</h2>
        <button className="bg-[#eef4f0] text-[#2e7d32] p-2 rounded-full"><Plus size={18} strokeWidth={3} /></button>
      </div>
      <div className="p-5">
        <div className="flex gap-3 mb-6 overflow-x-auto no-scrollbar pb-1">
          <button className="bg-[#2e7d32] text-white px-5 py-2 rounded-full text-[14px] font-bold shadow-sm whitespace-nowrap">Wheat (Field A)</button>
          <button className="bg-white border border-[#e2e8f0] text-[#556370] px-5 py-2 rounded-full text-[14px] font-bold whitespace-nowrap">Corn (Field B)</button>
        </div>
        <div className="bg-white rounded-[24px] p-5 shadow-sm border border-[#e2e8f0]/60 mb-6">
          <div className="flex justify-between items-start mb-6">
            <div><h3 className="font-extrabold text-[#161f2b] text-[18px] mb-1">Wheat</h3><p className="text-[#8a949c] text-[13px] font-bold">Planted: 12 Nov, 2023</p></div>
            <div className="bg-[#eef4f0] px-3 py-1.5 rounded-[8px] flex flex-col items-center"><span className="text-[#2e7d32] font-extrabold text-[16px] leading-none mb-0.5">Day 45</span><span className="text-[#64748b] text-[9px] font-extrabold uppercase tracking-widest">of 120</span></div>
          </div>
          <div className="relative mb-8 pt-2 px-2">
            <div className="absolute top-1/2 left-4 right-4 h-1.5 bg-[#e2e8f0] rounded-full -translate-y-1/2"></div>
            <div className="absolute top-1/2 left-4 h-1.5 bg-[#2e7d32] rounded-full -translate-y-1/2 w-[35%]"></div>
            <div className="relative flex justify-between">
              <div className="flex flex-col items-center gap-2"><div className="w-5 h-5 rounded-full bg-[#2e7d32] border-4 border-white shadow-sm z-10"></div><span className="text-[10px] font-extrabold text-[#2e7d32] uppercase tracking-wide">Sowing</span></div>
              <div className="flex flex-col items-center gap-2"><div className="w-5 h-5 rounded-full bg-[#2e7d32] border-4 border-white shadow-sm z-10"></div><span className="text-[10px] font-extrabold text-[#2e7d32] uppercase tracking-wide">Tillering</span></div>
              <div className="flex flex-col items-center gap-2"><div className="w-5 h-5 rounded-full bg-[#e2e8f0] border-4 border-white shadow-sm z-10"></div><span className="text-[10px] font-extrabold text-[#8a949c] uppercase tracking-wide">Heading</span></div>
              <div className="flex flex-col items-center gap-2"><div className="w-5 h-5 rounded-full bg-[#e2e8f0] border-4 border-white shadow-sm z-10"></div><span className="text-[10px] font-extrabold text-[#8a949c] uppercase tracking-wide">Harvest</span></div>
            </div>
          </div>
          <h4 className="font-extrabold text-[#161f2b] text-[15px] mb-3">Today's Recommendations</h4>
          <div className="space-y-3">
            <div className="flex items-start gap-3 bg-blue-50/50 p-3 rounded-[12px] border border-blue-100/50"><Droplet className="w-5 h-5 text-blue-500 fill-blue-500 mt-0.5 shrink-0" /><div><h5 className="font-bold text-[#161f2b] text-[14px]">Irrigation Needed</h5><p className="text-[#556370] text-[12.5px] leading-snug">Soil moisture is low (22%). Schedule light irrigation by evening.</p></div></div>
            <div className="flex items-start gap-3 bg-yellow-50/50 p-3 rounded-[12px] border border-yellow-100/50"><Wind className="w-5 h-5 text-yellow-600 mt-0.5 shrink-0" strokeWidth={2.5}/><div><h5 className="font-bold text-[#161f2b] text-[14px]">High Winds Expected</h5><p className="text-[#556370] text-[12.5px] leading-snug">Delay pesticide spraying due to {weatherData ? `${weatherData.windSpeed} km/h` : 'high'} winds.</p></div></div>
          </div>
        </div>
      </div>
    </div>
  );

  const MapScreen = () => (
    <div className="h-full bg-[#eef4f0] pb-24 flex flex-col animate-in fade-in duration-300">
      <div className="flex items-center px-4 h-16 pt-2 bg-white/50 backdrop-blur-md sticky top-0 z-10 border-b border-[#e2e8f0]/60">
        <button onClick={() => setActiveTab('home')} className="p-2"><ArrowLeft className="w-6 h-6 text-[#161f2b] stroke-[2.5]" /></button>
        <h2 className="flex-1 text-center text-[19px] font-extrabold text-[#161f2b] -ml-6">Farm View</h2>
      </div>
      <div className="flex-1 relative overflow-hidden">
        <img src="https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=1000&auto=format&fit=crop" className="w-full h-full object-cover opacity-60" alt="Map" />
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="bg-white/90 backdrop-blur-md p-6 rounded-[24px] shadow-xl border border-white flex flex-col items-center gap-4">
            <div className="w-12 h-12 bg-[#2e7d32]/10 rounded-full flex items-center justify-center animate-bounce"><MapPin className="text-[#2e7d32] w-6 h-6" strokeWidth={2.5}/></div>
            <div className="text-center"><h3 className="font-extrabold text-[#161f2b] text-[16px] mb-1">Interactive Map</h3><p className="text-[#64748b] text-[13px] font-medium">Coming soon! View your fields<br/>and health zones from satellite.</p></div>
          </div>
        </div>
      </div>
    </div>
  );

  const ScanScreen = () => (
    <div className="flex flex-col h-full bg-[#f8faf9] animate-in slide-in-from-right-4 duration-300">
      <div className="flex items-center justify-between px-4 h-16 pt-2 shrink-0">
        <button onClick={() => setCurrentScreen('main')} className="p-2"><ArrowLeft className="w-6 h-6 text-[#161f2b] stroke-[2.5]" /></button>
        <h2 className="text-[19px] font-extrabold text-[#161f2b]">Disease Detection</h2>
        <button className="p-2"><HelpCircle className="w-6 h-6 text-[#161f2b]" strokeWidth={2} /></button>
      </div>
      <div className="flex-1 px-5 pt-2 pb-6 flex flex-col">
        <div className="relative w-full h-[340px] rounded-[24px] overflow-hidden mb-6 shadow-sm border border-[#e2e8f0]/60">
          <img src="https://images.unsplash.com/photo-1592841200221-a6898f307baa?q=80&w=800&auto=format&fit=crop" alt="Leaf" className="absolute inset-0 w-full h-full object-cover" />
          <div className="absolute inset-0 bg-black/10"></div>
          <div className="absolute top-5 left-1/2 -translate-x-1/2 bg-black/40 backdrop-blur-md rounded-full px-6 py-2.5 flex items-center gap-8">
            <Zap className="w-[18px] h-[18px] text-white fill-white" />
            <RefreshCw className="w-4 h-4 text-white" strokeWidth={3} />
            <Grid className="w-4 h-4 text-white" strokeWidth={2.5} />
          </div>
          <div className="absolute inset-x-8 top-20 bottom-16 border-2 border-dashed border-white/60 rounded-[12px]">
            <div className="absolute -top-0.5 -left-0.5 w-6 h-6 border-t-4 border-l-4 border-[#2e7d32] rounded-tl-[12px]"></div>
            <div className="absolute -top-0.5 -right-0.5 w-6 h-6 border-t-4 border-r-4 border-[#2e7d32] rounded-tr-[12px]"></div>
            <div className="absolute -bottom-0.5 -left-0.5 w-6 h-6 border-b-4 border-l-4 border-[#2e7d32] rounded-bl-[12px]"></div>
            <div className="absolute -bottom-0.5 -right-0.5 w-6 h-6 border-b-4 border-r-4 border-[#2e7d32] rounded-br-[12px]"></div>
          </div>
          <p className="absolute bottom-4 w-full text-center text-white font-bold text-[13.5px] drop-shadow-md">Align the affected leaf within the frame</p>
        </div>
        <div className="flex flex-col items-center flex-1 justify-between px-2">
          <div className="flex justify-between w-full px-4 mb-4">
            <div className="flex flex-col items-center gap-2"><div className="w-[52px] h-[52px] bg-[#eef4f0] rounded-full flex items-center justify-center"><Zap className="w-5 h-5 text-[#2e7d32] fill-[#2e7d32]" /></div><span className="text-[12px] font-extrabold text-[#161f2b]">Auto Flash</span></div>
            <div className="flex flex-col items-center gap-2"><div className="w-[52px] h-[52px] bg-[#eef4f0] rounded-full flex items-center justify-center"><RefreshCw className="w-5 h-5 text-[#2e7d32]" strokeWidth={2.5} /></div><span className="text-[12px] font-extrabold text-[#161f2b]">Switch Cam</span></div>
          </div>
          <div className="flex justify-between items-center w-full mb-4 px-1">
            <div className="flex flex-col items-center gap-2"><div className="w-[52px] h-[52px] rounded-[14px] overflow-hidden shadow-sm border border-[#e2e8f0]/80"><img src="https://images.unsplash.com/photo-1592841200221-a6898f307baa?q=80&w=200&auto=format&fit=crop" alt="Gallery" className="w-full h-full object-cover" /></div><span className="text-[10px] font-extrabold text-[#64748b] tracking-widest uppercase">Gallery</span></div>
            <button onClick={() => { setCurrentScreen('diagnosis'); setDiseaseResult(null); predictDisease().then(r => setDiseaseResult(r)); }} className="w-[88px] h-[88px] rounded-full border-[5px] border-[#2e7d32] p-[3px] flex items-center justify-center active:scale-95 transition-transform bg-white shadow-md">
              <div className="w-full h-full bg-[#2e7d32] rounded-full flex items-center justify-center"><Camera className="w-[34px] h-[34px] text-white" strokeWidth={2.5}/></div>
            </button>
            <div className="flex flex-col items-center gap-2"><div className="w-[52px] h-[52px] bg-[#eef4f0] rounded-full flex items-center justify-center border border-[#e2e8f0]/40"><Clock className="w-6 h-6 text-[#8a949c]" strokeWidth={2.5} /></div><span className="text-[10px] font-extrabold text-[#64748b] tracking-widest uppercase">History</span></div>
          </div>
          <button className="w-full bg-[#eef4f0] text-[#2e7d32] py-[16px] rounded-[14px] font-extrabold text-[15px] flex justify-center items-center gap-2 active:bg-[#e4ece7] transition-colors border border-[#e2e8f0]/60">
            <Upload className="w-[18px] h-[18px]" strokeWidth={3} /> Upload from Gallery
          </button>
        </div>
      </div>
    </div>
  );

  const DiagnosisScreen = () => (
    <div className="flex flex-col h-[100dvh] bg-[#f8faf9] animate-in fade-in duration-300 relative">
      <div className="flex items-center px-4 h-16 pt-2 shrink-0 bg-white/50 backdrop-blur-md sticky top-0 z-10">
        <button onClick={() => setCurrentScreen('scan')} className="p-2"><ArrowLeft className="w-6 h-6 text-[#2e7d32] stroke-[2.5]" /></button>
        <h2 className="flex-1 text-center text-[19px] font-extrabold text-[#161f2b] pr-8">Diagnosis Result</h2>
      </div>
      <div className="flex-1 overflow-y-auto no-scrollbar pb-24 px-5 pt-4">
        {diseaseResult ? (
          <>
            <div className="relative w-full h-[220px] rounded-[24px] overflow-hidden mb-5 shadow-[0_8px_30px_rgba(0,0,0,0.06)] border-[4px] border-white">
              <img src="https://images.unsplash.com/photo-1592841200221-a6898f307baa?q=80&w=800&auto=format&fit=crop" alt="Scanned Leaf" className="w-full h-full object-cover" />
              <div className="absolute top-4 right-4 bg-[#ef4444] text-white text-[10px] font-extrabold tracking-widest uppercase px-3 py-1.5 rounded-full flex items-center gap-1 shadow-md"><AlertTriangle className="w-3.5 h-3.5 fill-white" strokeWidth={2.5}/> ISSUE DETECTED</div>
            </div>
            <div className="text-center mb-6"><h1 className="text-[28px] font-extrabold text-[#161f2b] mb-1 tracking-tight">{diseaseResult.disease}</h1><p className="text-[#2e7d32] font-extrabold text-[15px]">{diseaseResult.scientificName}</p></div>
            <div className="grid grid-cols-2 gap-4 mb-8">
              <div className="bg-white border border-[#e2e8f0]/80 rounded-[20px] py-4 flex flex-col items-center justify-center shadow-sm"><div className="flex items-center gap-1.5 mb-1"><CheckCircle2 className="w-4 h-4 text-[#2e7d32]" /><span className="text-[10px] font-extrabold text-[#64748b] tracking-widest uppercase">Confidence</span></div><h3 className="text-[22px] font-extrabold text-[#161f2b]">{diseaseResult.confidence}%</h3></div>
              <div className="bg-white border border-[#e2e8f0]/80 rounded-[20px] py-4 flex flex-col items-center justify-center shadow-sm"><div className="flex items-center gap-1.5 mb-1"><AlertCircle className="w-4 h-4 text-[#556370]" /><span className="text-[10px] font-extrabold text-[#64748b] tracking-widest uppercase">Severity</span></div><h3 className="text-[22px] font-extrabold text-[#161f2b]">{diseaseResult.severity}</h3></div>
            </div>
            <h3 className="text-[19px] font-extrabold text-[#161f2b] mb-6">Treatment Plan</h3>
            <div className="relative pl-2.5 space-y-7 mb-8">
              <div className="absolute left-[25px] top-[15px] bottom-[15px] w-[2px] bg-[#cce6d4]"></div>
              {diseaseResult.treatment.map((t, i) => (
                <div key={i} className="relative flex items-start gap-4">
                  <div className="w-8 h-8 bg-[#4ade80] rounded-full flex items-center justify-center text-white font-extrabold text-[14px] z-10 shrink-0 shadow-sm">{i + 1}</div>
                  <div className="pt-1"><h4 className="font-extrabold text-[#161f2b] text-[15px] mb-1.5">{t.title}</h4><p className="text-[#64748b] text-[13.5px] leading-[1.6]">{t.desc}</p></div>
                </div>
              ))}
            </div>
            <div className="bg-[#1b3b22] rounded-[20px] p-6 shadow-md text-white border border-[#2e7d32]">
              <h3 className="text-[17px] font-extrabold text-[#4ade80] flex items-center gap-2.5 mb-5"><ShieldCheck className="w-[22px] h-[22px] text-[#4ade80]" strokeWidth={2.5} /> Preventive Measures</h3>
              <ul className="space-y-4">{diseaseResult.preventive.map((p, i) => (<li key={i} className="flex items-start gap-3"><CheckCircle2 className="w-4 h-4 text-[#4ade80] shrink-0 mt-0.5" strokeWidth={3}/><span className="text-[13.5px] text-[#d1eedb] leading-[1.5] font-medium">{p}</span></li>))}</ul>
            </div>
          </>
        ) : (
          <div className="flex flex-col items-center justify-center h-full gap-4">
            <div className="w-16 h-16 border-4 border-[#2e7d32] border-t-transparent rounded-full animate-spin"></div>
            <p className="text-[#556370] font-bold">Analyzing with AI Model...</p>
            <p className="text-[13px] text-[#8a949c] text-center">Connecting to crop disease detection model...</p>
          </div>
        )}
      </div>
      <div className="absolute bottom-0 left-0 w-full bg-white border-t border-[#e2e8f0]/80 pb-4 pt-2 px-6 flex justify-evenly items-center shadow-[0_-10px_20px_rgba(0,0,0,0.03)] z-50 h-[68px]">
        <button onClick={() => { setActiveTab('home'); setCurrentScreen('main'); }} className="flex flex-col items-center flex-1 justify-center h-12 text-[#2e7d32]"><Home size={22} fill="currentColor" /><span className="text-[9px] font-extrabold tracking-wide mt-1">HOME</span></button>
        <button onClick={() => setCurrentScreen('scan')} className="flex flex-col items-center flex-1 justify-center h-12 text-[#8a949c]"><Maximize size={22} /><span className="text-[9px] font-extrabold tracking-wide mt-1">IDENTIFY</span></button>
        <button className="flex flex-col items-center flex-1 justify-center h-12 text-[#8a949c]"><Clock size={22} strokeWidth={2.5} /><span className="text-[9px] font-extrabold tracking-wide mt-1">HISTORY</span></button>
      </div>
    </div>
  );

  const CommunityScreen = () => (
    <div className="h-full bg-[#f8faf9] pb-24 overflow-y-auto no-scrollbar animate-in fade-in duration-300">
      <div className="flex items-center justify-between px-5 pt-6 pb-4 bg-white border-b border-[#e2e8f0]/60 sticky top-0 z-10">
        <div className="flex items-center gap-2.5">
          <div className="w-[34px] h-[34px] bg-[#e6f4ea] rounded-[10px] flex items-center justify-center"><Sprout className="w-[18px] h-[18px] text-[#2e7d32]" fill="#2e7d32" /></div>
          <h2 className="text-[19px] font-extrabold text-[#161f2b]">Community Feed</h2>
        </div>
        <div className="flex items-center gap-4"><Search className="w-[22px] h-[22px] text-[#4b5563]" strokeWidth={2.5} /><div className="relative"><Bell className="w-[22px] h-[22px] text-[#4b5563] fill-[#4b5563]" strokeWidth={1} /><span className="absolute top-[2px] right-[2px] w-2.5 h-2.5 bg-[#ef4444] rounded-full border-2 border-white"></span></div></div>
      </div>
      <div className="flex gap-2.5 px-5 py-4 overflow-x-auto no-scrollbar bg-white">
        <button className="bg-[#2e7d32] text-white px-4 py-2 rounded-full text-[13px] font-bold whitespace-nowrap shadow-sm">All Crops</button>
        <button className="bg-white border border-[#e2e8f0] text-[#161f2b] px-4 py-2 rounded-full text-[13px] font-bold whitespace-nowrap flex items-center gap-1 shadow-sm">Wheat <ChevronDown className="w-3.5 h-3.5 text-[#8a949c]"/></button>
        <button className="bg-white border border-[#e2e8f0] text-[#161f2b] px-4 py-2 rounded-full text-[13px] font-bold whitespace-nowrap flex items-center gap-1 shadow-sm">Corn <ChevronDown className="w-3.5 h-3.5 text-[#8a949c]"/></button>
        <button className="bg-white border border-[#e2e8f0] text-[#161f2b] px-4 py-2 rounded-full text-[13px] font-bold whitespace-nowrap shadow-sm">Rice</button>
      </div>
      <div className="p-4 space-y-4">
        {posts.map(post => (
          <div key={post.id} className="bg-white rounded-[16px] p-4 shadow-[0_2px_12px_rgba(0,0,0,0.03)] border border-[#e2e8f0]/60">
            <div className="flex justify-between items-start mb-3">
              <div className="flex items-center gap-3 cursor-pointer" onClick={() => setCurrentScreen('farmer_profile')}>
                <img src={post.authorAvatar} alt={post.authorName} className="w-11 h-11 rounded-full object-cover bg-gray-200" />
                <div><h4 className="font-extrabold text-[#161f2b] text-[15px]">{post.authorName}</h4><p className="text-[#8a949c] text-[12px] font-bold flex items-center gap-1"><MapPin className="w-3 h-3"/> {post.location} • {post.timeAgo}</p></div>
              </div>
              <span className="bg-[#e6f4ea] text-[#2e7d32] text-[10px] font-extrabold px-2.5 py-1 rounded-[6px] tracking-wider uppercase">{post.cropType}</span>
            </div>
            <p className="text-[#4b5563] text-[14px] leading-relaxed mb-4">{post.content}</p>
            {post.image && <img src={post.image} alt="Crop" className="w-full h-48 object-cover rounded-[12px] mb-4" />}
            <div className="flex items-center justify-between border-t border-[#e2e8f0]/50 pt-3">
              <div className="flex items-center gap-5">
                <button className="flex items-center gap-1.5 text-[#556370] font-bold text-[14px]"><ThumbsUp className="w-5 h-5 fill-[#556370]" /> {post.likes}</button>
                <button onClick={() => setCurrentScreen('post_discussion')} className="flex items-center gap-1.5 text-[#556370] font-bold text-[14px]"><MessageSquare className="w-5 h-5 fill-[#556370]" /> {post.comments}</button>
              </div>
              <button className="flex items-center gap-1.5 text-[#556370] font-bold text-[14px]"><Share2 className="w-5 h-5" strokeWidth={2.5}/> Share</button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  const CreatePostScreen = () => (
    <div className="flex flex-col h-full bg-[#f8faf9] animate-in slide-in-from-bottom-4 duration-300">
      <div className="flex items-center justify-between px-4 h-16 pt-2 bg-white border-b border-[#e2e8f0]/60 shrink-0">
        <button onClick={() => setCurrentScreen('main')} className="p-2"><ArrowLeft className="w-6 h-6 text-[#161f2b] stroke-[2.5]" /></button>
        <h2 className="text-[19px] font-extrabold text-[#161f2b]">New Post</h2>
        <button onClick={() => { createPost({ content: 'Just shared on the forum!', cropType: 'General' }); setPosts(getCommunityPosts()); setCurrentScreen('main'); setActiveTab('community'); }} className="bg-[#2e7d32] text-white px-4 py-1.5 rounded-full text-[13px] font-bold flex items-center gap-1"><Send className="w-3.5 h-3.5"/> Post</button>
      </div>
      <div className="flex-1 p-5 overflow-y-auto no-scrollbar">
        <div className="flex items-center gap-3 mb-6"><div className="w-10 h-10 bg-[#f4dcd6] rounded-full flex items-center justify-center border border-black/5 overflow-hidden shrink-0"><div className="w-3 h-5 bg-white/90 rounded-sm border border-[#dca8a0]/30"></div></div><span className="font-extrabold text-[#161f2b] text-[15px]">Green Acres Farm</span></div>
        <textarea placeholder="What's happening in your field?" className="w-full bg-transparent border-none outline-none text-[16px] text-[#161f2b] placeholder-[#8a949c] font-medium resize-none min-h-[120px]" autoFocus></textarea>
        <div className="flex gap-3 mb-6"><button className="flex items-center gap-1.5 text-[#2e7d32] bg-[#e6f4ea] px-3.5 py-2 rounded-full text-[13px] font-bold"><Zap className="w-4 h-4" fill="currentColor"/> Ask AI</button></div>
        <div className="border-2 border-dashed border-[#e2e8f0] rounded-[16px] p-8 flex flex-col items-center justify-center gap-2 bg-white/50 cursor-pointer">
          <div className="w-12 h-12 bg-[#eef4f0] rounded-full flex items-center justify-center mb-2"><Camera className="w-6 h-6 text-[#2e7d32]" strokeWidth={2}/></div>
          <span className="font-bold text-[#161f2b] text-[15px]">Add Photo</span>
          <span className="text-[12px] text-[#8a949c] font-medium text-center">Capture affected crops for better help</span>
        </div>
      </div>
    </div>
  );

  const PostDiscussionScreen = () => (
    <div className="flex flex-col h-full bg-[#f8faf9] animate-in slide-in-from-right-4 duration-300">
      <div className="flex items-center px-4 h-16 pt-2 bg-white border-b border-[#e2e8f0]/60 shrink-0 sticky top-0 z-10">
        <button onClick={() => setCurrentScreen('main')} className="p-2"><ArrowLeft className="w-6 h-6 text-[#161f2b] stroke-[2.5]" /></button>
        <h2 className="flex-1 text-center text-[19px] font-extrabold text-[#161f2b] -ml-6">Discussion</h2>
      </div>
      <div className="flex-1 overflow-y-auto no-scrollbar pb-[80px]">
        <div className="bg-white p-5 border-b border-[#e2e8f0]/60 mb-2">
          <p className="text-[#4b5563] text-[14.5px] leading-relaxed mb-4">My wheat crop is showing yellow spots on the lower leaves. Is this rust or a nutrient deficiency?</p>
          <img src="https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?q=80&w=800&auto=format&fit=crop" alt="Wheat Crop" className="w-full h-48 object-cover rounded-[12px] mb-4" />
        </div>
        <div className="p-5 flex flex-col gap-4">
          <h3 className="font-extrabold text-[#161f2b] text-[15px] mb-1">Replies (12)</h3>
          <div className="bg-white p-4 rounded-[16px] shadow-sm border border-[#e2e8f0]/40">
            <div className="flex justify-between items-start mb-2"><div className="flex items-center gap-2"><div className="w-8 h-8 rounded-full bg-[#e6f4ea] flex items-center justify-center"><CloudSun className="w-4 h-4 text-[#2e7d32]"/></div><span className="font-extrabold text-[#161f2b] text-[14px]">Agri Expert AI</span></div><span className="text-[#8a949c] text-[11px] font-bold">1h ago</span></div>
            <p className="text-[#4b5563] text-[13.5px] leading-relaxed mb-3 pl-[40px]">Based on visual analysis, this appears to be early-stage Yellow Rust. Consider applying a propiconazole-based fungicide.</p>
          </div>
        </div>
      </div>
      <div className="absolute bottom-0 left-0 w-full bg-white border-t border-[#e2e8f0] p-3 z-20">
        <div className="flex items-center gap-2 relative">
          <input type="text" placeholder="Add a reply..." className="flex-1 bg-[#f4f7f5] rounded-full py-3 pl-4 pr-12 text-[14px] font-medium text-[#161f2b] outline-none" />
          <button className="absolute right-1.5 w-9 h-9 bg-[#2e7d32] rounded-full flex items-center justify-center active:scale-95"><Send className="w-4 h-4 text-white"/></button>
        </div>
      </div>
    </div>
  );

  const FarmerProfileScreen = () => (
    <div className="h-full bg-[#f8faf9] pb-24 overflow-y-auto no-scrollbar animate-in slide-in-from-right-4 duration-300">
      <div className="relative h-[140px] bg-[#e6f4ea] overflow-hidden"><div className="absolute inset-0 opacity-20"><img src="https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=1000&auto=format&fit=crop" className="w-full h-full object-cover" alt="Farm" /></div><div className="flex items-center px-4 h-16 pt-2 relative z-10"><button onClick={() => setCurrentScreen('main')} className="p-2 bg-white/40 backdrop-blur-sm rounded-full"><ArrowLeft className="w-5 h-5 text-[#161f2b] stroke-[2.5]" /></button></div></div>
      <div className="px-5 relative -mt-12 flex flex-col items-center mb-6">
        <div className="w-24 h-24 rounded-full border-4 border-[#f8faf9] overflow-hidden mb-3 shadow-sm bg-white"><img src="https://i.pravatar.cc/150?img=11" alt="Rajesh" className="w-full h-full object-cover" /></div>
        <h2 className="text-[22px] font-extrabold text-[#161f2b] leading-tight">Rajesh Kumar</h2>
        <p className="text-[#556370] text-[13.5px] font-medium flex items-center gap-1 mb-3"><MapPin className="w-3.5 h-3.5"/> Ludhiana, Punjab</p>
        <div className="flex gap-4 w-full">
          <button className="flex-1 bg-[#2e7d32] text-white py-2.5 rounded-full font-bold text-[14px] shadow-sm flex items-center justify-center gap-1.5"><User className="w-4 h-4" /> Follow</button>
          <button className="flex-1 bg-white border border-[#2e7d32] text-[#2e7d32] py-2.5 rounded-full font-bold text-[14px] flex items-center justify-center gap-1.5"><MessageSquare className="w-4 h-4" /> Message</button>
        </div>
      </div>
      <div className="flex px-5 gap-4 mb-6"><div className="flex-1 bg-white p-3 rounded-[14px] border border-[#e2e8f0]/60 text-center"><h4 className="font-extrabold text-[#161f2b] text-[18px]">2.4K</h4><span className="text-[11px] font-bold text-[#8a949c] uppercase tracking-wide">Followers</span></div><div className="flex-1 bg-white p-3 rounded-[14px] border border-[#e2e8f0]/60 text-center"><h4 className="font-extrabold text-[#161f2b] text-[18px]">156</h4><span className="text-[11px] font-bold text-[#8a949c] uppercase tracking-wide">Following</span></div><div className="flex-1 bg-white p-3 rounded-[14px] border border-[#e2e8f0]/60 text-center"><h4 className="font-extrabold text-[#161f2b] text-[18px]">42</h4><span className="text-[11px] font-bold text-[#8a949c] uppercase tracking-wide">Posts</span></div></div>
    </div>
  );

  const ProfileScreen = () => (
    <div className="h-full bg-[#f8faf9] pb-24 overflow-y-auto no-scrollbar animate-in fade-in duration-300">
      <div className="flex items-center justify-between px-5 pt-8 pb-6 bg-[#2e7d32] text-white rounded-b-[32px] shadow-md relative overflow-hidden">
        <div className="flex items-center gap-4 z-10 w-full">
          <div className="w-16 h-16 bg-[#f4dcd6] rounded-full flex items-center justify-center border-2 border-white shadow-sm shrink-0"></div>
          <div className="flex-1"><h2 className="text-[20px] font-extrabold leading-tight mb-0.5">Green Acres Farm</h2><p className="text-[#cce6d4] text-[13px] font-medium flex items-center gap-1"><MapPin className="w-3.5 h-3.5"/> +91 98765 43210</p></div>
          <button className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center"><Settings className="w-5 h-5 text-white" strokeWidth={2.5}/></button>
        </div>
      </div>
      <div className="px-5 pt-6 space-y-6">
        <div className="grid grid-cols-3 gap-3">
          <div className="bg-white rounded-[16px] p-4 text-center border border-[#e2e8f0]/60 shadow-sm"><div className="w-8 h-8 bg-[#eef4f0] rounded-full flex items-center justify-center mx-auto mb-2"><BarChart2 className="w-4 h-4 text-[#2e7d32]"/></div><h4 className="font-extrabold text-[#161f2b] text-[16px]">12</h4><span className="text-[10px] font-bold text-[#8a949c] uppercase tracking-wide">Scans</span></div>
          <div className="bg-white rounded-[16px] p-4 text-center border border-[#e2e8f0]/60 shadow-sm"><div className="w-8 h-8 bg-[#eef4f0] rounded-full flex items-center justify-center mx-auto mb-2"><Bookmark className="w-4 h-4 text-[#2e7d32]"/></div><h4 className="font-extrabold text-[#161f2b] text-[16px]">5</h4><span className="text-[10px] font-bold text-[#8a949c] uppercase tracking-wide">Saved</span></div>
          <div className="bg-white rounded-[16px] p-4 text-center border border-[#e2e8f0]/60 shadow-sm"><div className="w-8 h-8 bg-[#eef4f0] rounded-full flex items-center justify-center mx-auto mb-2"><MessageSquare className="w-4 h-4 text-[#2e7d32]"/></div><h4 className="font-extrabold text-[#161f2b] text-[16px]">28</h4><span className="text-[10px] font-bold text-[#8a949c] uppercase tracking-wide">Posts</span></div>
        </div>
        <div>
          <h3 className="font-extrabold text-[#161f2b] text-[14px] uppercase tracking-wider mb-3 px-1">Account & Settings</h3>
          <div className="bg-white rounded-[20px] border border-[#e2e8f0]/60 overflow-hidden">
            <button className="w-full flex items-center gap-3.5 p-4 border-b border-[#e2e8f0]/60 active:bg-gray-50 text-left"><div className="w-9 h-9 bg-gray-50 rounded-[10px] flex items-center justify-center shrink-0"><User className="w-[18px] h-[18px] text-[#556370]" strokeWidth={2.5}/></div><span className="flex-1 font-bold text-[#161f2b] text-[15px]">Personal Information</span><ChevronRight className="w-5 h-5 text-[#8a949c]" /></button>
            <button onClick={() => setActiveTab('map')} className="w-full flex items-center gap-3.5 p-4 border-b border-[#e2e8f0]/60 active:bg-gray-50 text-left"><div className="w-9 h-9 bg-gray-50 rounded-[10px] flex items-center justify-center shrink-0"><Map className="w-[18px] h-[18px] text-[#556370]" strokeWidth={2.5}/></div><span className="flex-1 font-bold text-[#161f2b] text-[15px]">Farm Details & Location</span><ChevronRight className="w-5 h-5 text-[#8a949c]" /></button>
            <button onClick={() => setCurrentScreen('language')} className="w-full flex items-center gap-3.5 p-4 active:bg-gray-50 text-left"><div className="w-9 h-9 bg-gray-50 rounded-[10px] flex items-center justify-center shrink-0"><Globe className="w-[18px] h-[18px] text-[#556370]" strokeWidth={2.5}/></div><span className="flex-1 font-bold text-[#161f2b] text-[15px]">App Language</span><div className="flex items-center gap-2"><span className="text-[#8a949c] text-[13px] font-bold uppercase">English</span><ChevronRight className="w-5 h-5 text-[#8a949c]" /></div></button>
          </div>
        </div>
        <div>
          <h3 className="font-extrabold text-[#161f2b] text-[14px] uppercase tracking-wider mb-3 px-1">Support & Others</h3>
          <div className="bg-white rounded-[20px] border border-[#e2e8f0]/60 overflow-hidden">
            <button className="w-full flex items-center gap-3.5 p-4 border-b border-[#e2e8f0]/60 active:bg-gray-50 text-left"><div className="w-9 h-9 bg-gray-50 rounded-[10px] flex items-center justify-center shrink-0"><HelpCircle className="w-[18px] h-[18px] text-[#556370]" strokeWidth={2.5}/></div><span className="flex-1 font-bold text-[#161f2b] text-[15px]">Help Center & FAQs</span><ChevronRight className="w-5 h-5 text-[#8a949c]" /></button>
            <button onClick={() => setCurrentScreen('splash')} className="w-full flex items-center gap-3.5 p-4 active:bg-red-50 text-left"><div className="w-9 h-9 bg-red-50 rounded-[10px] flex items-center justify-center shrink-0"><LogOut className="w-[18px] h-[18px] text-[#da3b3b]" strokeWidth={2.5}/></div><span className="flex-1 font-bold text-[#da3b3b] text-[15px]">Log Out</span></button>
          </div>
        </div>
      </div>
    </div>
  );

  // ─── NAVIGATION ─────────────────────────────────────

  const PottedPlantIcon = ({ size }) => (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" strokeWidth="1">
      <path d="M12 10v4" strokeWidth="2.5" strokeLinecap="round"/>
      <path d="M7 14h10l-1.5 6h-7z" strokeLinejoin="round" />
      <path d="M12 10a3 3 0 0 1-3-3 3 3 0 0 1 3-3 3 3 0 0 1 3 3 3 3 0 0 1-3 3z" />
    </svg>
  );

  const NavItem = ({ id, icon, label, isCommunity }) => {
    const isActive = activeTab === id;
    return (
      <button onClick={() => { setActiveTab(id); setCurrentScreen('main'); }} className={`flex flex-col items-center flex-1 transition-all duration-200 ${isCommunity ? 'justify-end h-full pb-1' : 'justify-center h-12'}`} style={{ color: isActive ? '#2e7d32' : '#8a949c' }}>
        <div className={`mb-1 transition-transform duration-200 ${isActive ? 'transform scale-110' : ''}`}>{icon}</div>
        <span className="text-[9px] font-extrabold tracking-wide">{label}</span>
      </button>
    );
  };

  const BottomNav = () => {
    if (['weather', 'map', 'alerts'].includes(activeTab)) {
      return (
        <div className="absolute bottom-0 left-0 w-full bg-white border-t border-[#e2e8f0]/80 pb-4 pt-2 px-1 flex justify-evenly items-center shadow-[0_-10px_20px_rgba(0,0,0,0.03)] z-50 h-[68px]">
          <NavItem id="home" icon={<Home size={22} fill="currentColor" />} label="HOME" />
          <NavItem id="weather" icon={<CloudSun size={22} fill="currentColor" />} label="WEATHER" />
          <NavItem id="map" icon={<Map size={22} fill="currentColor" />} label="MAP" />
          <NavItem id="alerts" icon={<Bell size={22} fill="currentColor" />} label="ALERTS" />
        </div>
      );
    }
    if (activeTab === 'community') {
      return (
        <div className="absolute bottom-0 left-0 w-full bg-white border-t border-[#e2e8f0] pb-5 pt-3 px-2 flex justify-evenly items-end shadow-[0_-10px_20px_rgba(0,0,0,0.03)] z-50 h-[76px]">
          <NavItem id="home" icon={<Home size={22} fill="currentColor" />} label="HOME" isCommunity />
          <NavItem id="community" icon={<Users size={22} fill="currentColor" />} label="FEED" isCommunity />
          <div className="relative -top-3 flex justify-center flex-1">
            <button onClick={() => setCurrentScreen('create_post')} className="w-[56px] h-[56px] bg-[#2e7d32] rounded-full flex items-center justify-center shadow-[0_8px_20px_rgba(46,125,50,0.4)] border-[4px] border-[#eef4f0] text-white active:scale-95 transition-transform">
              <Plus className="w-8 h-8" strokeWidth={2.5}/>
            </button>
          </div>
          <NavItem id="profile" icon={<User size={22} fill="currentColor" />} label="PROFILE" isCommunity />
        </div>
      );
    }
    return (
      <div className="absolute bottom-0 left-0 w-full bg-white border-t border-[#e2e8f0]/80 pb-4 pt-2 px-1 flex justify-evenly items-center shadow-[0_-10px_20px_rgba(0,0,0,0.03)] z-50 h-[68px]">
        <NavItem id="home" icon={<Home size={22} fill="currentColor" />} label="HOME" />
        <NavItem id="tracker" icon={<PottedPlantIcon size={22} />} label="TRACKER" />
        <NavItem id="weather" icon={<CloudSun size={22} fill="currentColor" />} label="WEATHER" />
        <NavItem id="community" icon={<Users size={22} fill="currentColor" />} label="COMMUNITY" />
        <NavItem id="profile" icon={<User size={22} fill="currentColor" />} label="PROFILE" />
      </div>
    );
  };

  const renderScreen = () => {
    if (currentScreen === 'splash') return <SplashScreen />;
    if (currentScreen === 'login') return <LoginScreen />;
    if (currentScreen === 'otp') return <OtpScreen />;
    if (currentScreen === 'success') return <SuccessScreen />;
    if (currentScreen === 'language') return <LanguageScreen />;
    if (currentScreen === 'create_post') return <CreatePostScreen />;
    if (currentScreen === 'post_discussion') return <PostDiscussionScreen />;
    if (currentScreen === 'farmer_profile') return <FarmerProfileScreen />;
    if (currentScreen === 'scan') return <ScanScreen />;
    if (currentScreen === 'diagnosis') return <DiagnosisScreen />;
    return (
      <>
        <div className="flex-1 overflow-y-auto no-scrollbar bg-[#eef4f0]">
          {activeTab === 'home' && <HomeScreen />}
          {activeTab === 'tracker' && <CropTrackerScreen />}
          {activeTab === 'weather' && <WeatherScreen />}
          {activeTab === 'community' && <CommunityScreen />}
          {activeTab === 'profile' && <ProfileScreen />}
          {activeTab === 'alerts' && <AlertsScreen />}
          {activeTab === 'map' && <MapScreen />}
        </div>
        {activeTab === 'home' && (
          <div className="absolute bottom-[80px] left-1/2 transform -translate-x-1/2 z-40 pointer-events-auto">
            <button onClick={() => setCurrentScreen('scan')} className="w-[64px] h-[64px] bg-[#2e7d32] rounded-full flex items-center justify-center shadow-[0_8px_24px_rgba(46,125,50,0.5)] border-[4px] border-[#eef4f0] active:scale-95 transition-transform">
              <Maximize className="w-7 h-7 text-white" strokeWidth={2.5}/>
            </button>
          </div>
        )}
        <BottomNav />
      </>
    );
  };

  return (
    <div className="h-[100dvh] w-full max-w-md mx-auto font-sans relative overflow-hidden shadow-2xl flex flex-col select-none sm:border-x sm:border-gray-200 bg-[#eef4f0]">
      <style dangerouslySetInnerHTML={{__html: `
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
        input[type="number"]::-webkit-inner-spin-button,
        input[type="number"]::-webkit-outer-spin-button { -webkit-appearance: none; margin: 0; }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; }
      `}} />
      {renderScreen()}
    </div>
  );
}
