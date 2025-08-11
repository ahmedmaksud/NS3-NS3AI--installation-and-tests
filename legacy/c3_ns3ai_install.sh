# Important notes
# There is a problem with the multi-bss example, in multi-bss.cc line 1786
# The MaxSlrc and MaxSsrc are outdated, the alternative is not clear, I just omitted the burst option

#!/bin/bash


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

export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
export PYTHONPATH=$PYTHONPATH:$(pwd)/contrib/ai/model/gym-interface/py



# Add the required directory to PYTHONPATH
# export PYTHONPATH=$PYTHONPATH:ns-allinone-3.44/ns-3.44/contrib/ai/model/gym-interface/py


# Install CUDA for GPU support if needed
sudo apt install nvidia-cuda-toolkit
nvcc --version
nvidia-smi


# Now get on with ns3ai part
cd ../ns-allinone-3.44/ns-3.44
git clone https://github.com/hust-diangroup/ns3-ai.git contrib/ai

# There is a problem with the protocol buffer.
# The protobuf package does not ship with CMake support.
# But the code takes care of that. Do not worry about the warning regarding protobuf.

# Need to get libtensorflow and libtorch
# Make sure to include correct links depending on the hardware
# It is very important to get the correct version of libtorch and libtensorflow

# Need to install tensorflow c library
# this takes some work around
# What the problem was is that the ns3ai was looking for tensorflow in a specific directory.
# But the tensorflow library was not installed in that directory by default.
# So we need to install the tensorflow library in the directory where ns3ai is looking for it.

mkdir -p contrib/ai/model/libtensorflow
FILENAME=libtensorflow-gpu-linux-x86_64.tar.gz
wget -q --no-check-certificate https://storage.googleapis.com/tensorflow/versions/2.18.0/${FILENAME}
sudo tar -C contrib/ai/model/libtensorflow -xzf ${FILENAME}


# Need to install pytorch c library just like tensorflow
# The installation file makes libtorch directory by itself, so drop the mkdir command
# mkdir -p contrib/ai/model/libtorch
# There was one last script that was not working.
# It was due to libtorch not finding python 3.12 or something like that.
# We are now using CPU version of libtorch for now, which works.
# There may be a way around using specific CUDA version mentioned in libtorch.


wget https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.7.0%2Bcpu.zip -O libtorch.zip
# wget https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.5.1%2Bcpu.zip -O libtorch.zip
unzip libtorch.zip -d contrib/ai/model


pip install -e contrib/ai/python_utils
pip install -e contrib/ai/model/gym-interface/py



# Configure and build again
# Apparently there is a problem with the protobuf library.
# The protobuf could not be found, so we added the path to the protobuf library.
# We have checked the protobuf thing. It has built-in moves to ensure that protobuf is on
# Unless there is an error, or some execution fails, we will not worry about it.
./ns3 configure --enable-examples --enable-tests -- \
  -DNS3_PYTHON_BINDINGS=ON \
  -DPython3_EXECUTABLE=../../$VENV_NAME/bin/python \
  -DNS3_BINDINGS_INSTALL_DIR=../../$VENV_NAME/lib/python3.11/site-packages \
  -DPython3_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.11.so \
  -DProtobuf_LIBRARY=/usr/lib/x86_64-linux-gnu/libprotobuf.so \
  -DProtobuf_INCLUDE_DIRS=/usr/include \
  -DProtobuf_DIR=/usr/lib/x86_64-linux-gnu/cmake/protobuf


sed -i '33i #include <map>' contrib/ai/examples/multi-bss/vr-app/model/burst-sink.h
./ns3 build

# While building for the first time, it will fail for the 'burst-sink.h'
# Open and edit it>>#include <map>
# gedit contrib/ai/examples/multi-bss/vr-app/model/burst-sink.h
# Then run the build multiple times. It will come down to the last error.


# build all examples in all versions
./ns3 build ns3ai_apb_gym ns3ai_apb_msg_stru ns3ai_apb_msg_vec ns3ai_multibss ns3ai_rltcp_gym ns3ai_rltcp_msg ns3ai_ratecontrol_constant ns3ai_ratecontrol_ts ns3ai_ltecqi_msg

# build A-Plus-B example
# with Gym interface
./ns3 build ns3ai_apb_gym
# with Message interface - struct based
./ns3 build ns3ai_apb_msg_stru
# with Message interface - vector based
./ns3 build ns3ai_apb_msg_vec

# build Multi-BSS example
# with Message interface - vector based
./ns3 build ns3ai_multibss

# build RL-TCP example
# with Gym interface
./ns3 build ns3ai_rltcp_gym
# with Message interface - struct based
./ns3 build ns3ai_rltcp_msg

# build Rate-Control examples
# constant rate example, with Message interface - struct based
./ns3 build ns3ai_ratecontrol_constant
# Thompson Sampling example, with Message interface - struct based
./ns3 build ns3ai_ratecontrol_ts

# build LTE-CQI example
# with Message interface - struct based
./ns3 build ns3ai_ltecqi_msg
