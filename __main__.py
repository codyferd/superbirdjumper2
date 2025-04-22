# Libraries
import os
import sys

# Use script to run the game
script = os.path.join("superbirdjumper2", "assets", "code", "main.py")
os.execv(sys.executable, [sys.executable, script])