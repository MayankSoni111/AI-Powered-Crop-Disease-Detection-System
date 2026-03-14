"""
update_app.py — Dev utility for AI-Powered Crop Disease Detection System

This script checks that App.jsx has all the necessary API integrations.
Run it to verify the frontend is correctly wired to the backend services.
"""

import os
import sys

APP_PATH = os.path.join(os.path.dirname(__file__), "src", "App.jsx")

REQUIRED_IMPORTS = [
    "fetchWeather",
    "fetchCityName",
    "getCommunityPosts",
    "createPost",
    "predictDisease",
]

REQUIRED_HOOKS = [
    "setWeatherData",
    "setCity",
    "setPosts",
    "setDiseaseResult",
]

def check_app():
    if not os.path.exists(APP_PATH):
        print(f"[ERROR] App.jsx not found at: {APP_PATH}")
        sys.exit(1)

    with open(APP_PATH, "r", encoding="utf-8") as f:
        content = f.read()

    print(f"[OK] App.jsx found ({len(content)} bytes)")

    all_ok = True

    for token in REQUIRED_IMPORTS:
        if token in content:
            print(f"[OK] API import found: {token}")
        else:
            print(f"[MISSING] API import missing: {token}")
            all_ok = False

    for hook in REQUIRED_HOOKS:
        if hook in content:
            print(f"[OK] State hook found: {hook}")
        else:
            print(f"[MISSING] State hook missing: {hook}")
            all_ok = False

    if all_ok:
        print("\n✅  All API integrations are in place. App is ready!")
    else:
        print("\n⚠️  Some integrations may be missing. Check the output above.")

if __name__ == "__main__":
    check_app()
