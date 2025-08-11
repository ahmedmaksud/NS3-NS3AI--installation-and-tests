#!/bin/bash
# This script install ns3 only.
# It first install basic ns3 and runs all tests ans examples.
# Then it does the same using python bindings.
# Finally it goes back to the root directory.


# File to store the virtual environment name
VENV_FILE="venv_name.txt"

# Check if the virtual environment name file exists
if [ ! -f "$VENV_FILE" ]; then
    echo "❌ Error: Virtual environment name file '$VENV_FILE' not found."
    echo "Please create the file and add the virtual environment name."
    exit 1
fi

# Read the virtual environment name from the file
VENV_NAME=$(cat "$VENV_FILE")

if [ -z "$VENV_NAME" ]; then
    echo "❌ Error: Virtual environment name is empty in '$VENV_FILE'."
    exit 1
fi

# Check if the virtual environment already exists
if [ ! -d "../$VENV_NAME" ]; then
    echo "Virtual environment '$VENV_NAME' does not exist."
    echo "🚀 Creating virtual environment '$VENV_NAME'..."
    python3.11 -m venv "../$VENV_NAME"
else
    echo "✅ Virtual environment '$VENV_NAME' already exists."
fi

# Check if the virtual environment is already active
if [ -z "$VIRTUAL_ENV" ] || [ "$VIRTUAL_ENV" != "$(realpath "../$VENV_NAME")" ]; then
    echo "Virtual environment is not active."
    echo "🔗 Activating virtual environment '$VENV_NAME'..."
    source "../$VENV_NAME/bin/activate"
else
    echo "✅ Virtual environment '$VENV_NAME' is already active."
fi


# Download the ns3 version 44 and go to the ns3 directory
wget https://www.nsnam.org/releases/ns-allinone-3.44.tar.bz2 -O ../ns-allinone-3.44.tar.bz2
tar xfj ../ns-allinone-3.44.tar.bz2 -C ../
cd ../ns-allinone-3.44/ns-3.44


# First just plain ns3
./ns3 configure --enable-examples --enable-tests
# So far everything looks good. Now run some tests.
# ./test.py
./ns3 run first.cc
./ns3 run second.cc
./ns3 run third.cc
./ns3 run fourth.cc
./ns3 run fifth.cc
./ns3 run sixth.cc
echo "All examples ran successfully."


# We now configure the ns3 with the python bindings. This is a must.
# There will be warnings about uninitialized values; let's not worry about that for now.
./ns3 configure --enable-examples --enable-tests -- \
  -DNS3_PYTHON_BINDINGS=ON \
  -DPython3_EXECUTABLE=../../$VENV_NAME/bin/python \
  -DNS3_BINDINGS_INSTALL_DIR=../../$VENV_NAME/lib/python3.11/site-packages

./ns3 build

# Check if everything is ok. Consult copilot if necessary.
# Lets run the example scripts again
# ./test.py
./ns3 run first.cc
./ns3 run second.cc
./ns3 run third.cc
./ns3 run fourth.cc
./ns3 run fifth.cc
./ns3 run sixth.cc
echo "All examples ran successfully."

# Go back to the root directory
cd ../../founding-scripts

rm ../ns-allinone-3.44.tar.bz2
