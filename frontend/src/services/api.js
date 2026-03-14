// api.js

// ─── Weather API (Open-Meteo) ──────────────────────────
// Open-Meteo doesn't require an API key and provides real weather data
export const fetchWeather = async (lat, lon) => {
  try {
    const url = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,relative_humidity_2m,relative_humidity_2m,is_day,precipitation,rain,showers,snowfall,weather_code,cloud_cover,pressure_msl,surface_pressure,wind_speed_10m,wind_direction_10m,wind_gusts_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max,precipitation_sum,rain_sum,showers_sum,snowfall_sum,precipitation_hours,precipitation_probability_max,wind_speed_10m_max,wind_gusts_10m_max,wind_direction_10m_dominant,shortwave_radiation_sum,et0_fao_evapotranspiration&timezone=auto`;
    const response = await fetch(url);
    if (!response.ok) throw new Error('Network response was not ok');
    const data = await response.json();
    
    // Map Open-Meteo weather codes to a basic description
    const weatherCode = data.current.weather_code;
    let description = 'Clear';
    if (weatherCode >= 1 && weatherCode <= 3) description = 'Partly Cloudy';
    if (weatherCode >= 45 && weatherCode <= 48) description = 'Foggy';
    if (weatherCode >= 51 && weatherCode <= 67) description = 'Rainy';
    if (weatherCode >= 71 && weatherCode <= 77) description = 'Snowy';
    if (weatherCode >= 80 && weatherCode <= 82) description = 'Rain Showers';
    if (weatherCode >= 95 && weatherCode <= 99) description = 'Thunderstorm';

    return {
      temperature: Math.round(data.current.temperature_2m),
      humidity: data.current.relative_humidity_2m,
      windSpeed: data.current.wind_speed_10m,
      rainProbability: data.daily.precipitation_probability_max[0] || 0,
      uvIndex: data.daily.uv_index_max[0] || 0,
      description: description,
      date: new Date(data.current.time),
      forecast: data.daily.time.slice(1, 8).map((time, index) => ({
        date: new Date(time),
        tempMax: Math.round(data.daily.temperature_2m_max[index + 1]),
        tempMin: Math.round(data.daily.temperature_2m_min[index + 1]),
        weatherCode: data.daily.weather_code[index + 1],
      }))
    };
  } catch (error) {
    console.error("Failed to fetch real weather, using fallback:", error);
    // Fallback data if API fails
    return {
      temperature: 24,
      humidity: 45,
      windSpeed: 12,
      rainProbability: 15,
      uvIndex: 7,
      description: 'Partly Cloudy',
      date: new Date(),
      forecast: Object.keys(new Array(7).fill(null)).map(i => ({
        date: new Date(Date.now() + (i + 1) * 86400000),
        tempMax: 30 + (i % 3), tempMin: 20 + (i % 2), weatherCode: 1
      }))
    };
  }
};

// ─── Reverse Geocoding API ──────────────────────────
export const fetchCityName = async (lat, lon) => {
  try {
    const url = `https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lon}&format=json`;
    const response = await fetch(url);
    if (!response.ok) throw new Error('Geocoding failed');
    const data = await response.json();
    return data.address.city || data.address.town || data.address.village || data.address.county || 'Unknown Location';
  } catch (err) {
    return 'Your Location';
  }
};

// ─── Community Feed API (Mocked with LocalStorage) ──────────
const INITIAL_POSTS = [
  {
    id: 'post_1',
    authorName: 'Rajesh Kumar',
    authorAvatar: 'https://i.pravatar.cc/150?img=11',
    location: 'Punjab',
    timeAgo: '2h ago',
    cropType: 'Wheat',
    content: 'My wheat crop is showing these unusual yellow spots on the lower leaves. Is this rust or just a nutrient deficiency? Need help identifying!',
    image: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?q=80&w=800&auto=format&fit=crop',
    likes: 24,
    comments: 12,
  },
  {
    id: 'post_2',
    authorName: 'Sunita Devi',
    authorAvatar: 'https://i.pravatar.cc/150?img=5',
    location: 'Haryana',
    timeAgo: '5h ago',
    cropType: 'Corn',
    content: 'Incredible growth after the last rain! The soil moisture levels are perfect. Using organic fertilizers this season seems to be paying off.',
    image: 'https://images.unsplash.com/photo-1599930113854-d6d7fd521f10?q=80&w=800&auto=format&fit=crop',
    likes: 56,
    comments: 8,
  }
];

export const getCommunityPosts = () => {
  const stored = localStorage.getItem('community_posts');
  if (stored) return JSON.parse(stored);
  localStorage.setItem('community_posts', JSON.stringify(INITIAL_POSTS));
  return INITIAL_POSTS;
};

export const createPost = (post) => {
  const posts = getCommunityPosts();
  const newPost = {
    id: 'post_' + Date.now(),
    authorName: 'Current User', // Example
    authorAvatar: 'https://i.pravatar.cc/150?img=12',
    location: 'My Farm',
    timeAgo: 'Just now',
    cropType: post.cropType || 'General',
    content: post.content,
    image: post.image || null,
    likes: 0,
    comments: 0,
  };
  posts.unshift(newPost);
  localStorage.setItem('community_posts', JSON.stringify(posts));
  return newPost;
};

// ─── Disease Model API (Simulated Network Call) ─────────────
// Simulating the "teammate's model" as it'll be connected later on another device
export const predictDisease = async (imageFile) => {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve({
        disease: 'Leaf Rust',
        scientificName: 'Puccinia triticina',
        confidence: 95,
        severity: 'Moderate',
        treatment: [
          { title: "Apply Fungicide", desc: "Use a copper-based fungicide or sulfur spray. Ensure thorough coverage on both sides of the leaves." },
          { title: "Prune Affected Areas", desc: "Remove and destroy heavily infected leaves to stop the spores from spreading to healthy tissues." },
          { title: "Isolate Plant", desc: "If possible, move the infected plant away from healthy neighbors to prevent cross-contamination." }
        ],
        preventive: [
          "Water at the base of the plant to keep foliage dry.",
          "Ensure proper spacing for good air circulation.",
          "Regularly monitor plants for early signs of yellowing."
        ]
      });
    }, 2500); // simulate 2.5s model processing time
  });
};
