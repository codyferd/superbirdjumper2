# Libraries
import os # Sys Library
import subprocess # Sys Library
import sys # Sys Library

# Defining installation function
def install(libraries):
    subprocess.check_call([sys.executable, "-m", "pip", "install", libraries])

# Automatically import all required libraries
required = ["arcade", "numba", "screeninfo"]
for libraries in required:
    try:
        __import__(libraries)
    except ImportError:
        install(libraries)

# Use script to run the game
script = os.path.join("superbirdjumper2", "assets", "code", "main.py")
os.execv(sys.executable, [sys.executable, script])