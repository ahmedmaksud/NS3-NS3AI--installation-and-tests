# NS3 and NS3-AI Installation Scripts

A comprehensive, automated installation system for NS3 (Network Simulator 3) and NS3-AI with complete testing and verification capabilities.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![NS3 Version](https://img.shields.io/badge/NS3-3.44-blue.svg)](https://www.nsnam.org/)
[![Python](https://img.shields.io/badge/Python-3.11-green.svg)](https://www.python.org/)

## 📚 Table of Contents

- [Overview](#-overview)
- [What is NS3?](#-what-is-ns3)
- [What is NS3-AI?](#-what-is-ns3-ai)
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Detailed Installation Process](#-detailed-installation-process)
- [Script Documentation](#-script-documentation)
- [Testing and Verification](#-testing-and-verification)
- [Troubleshooting](#-troubleshooting)
- [Educational Resources](#-educational-resources)
- [Contributing](#-contributing)
- [License](#-license)

## 🌟 Overview

This repository provides a complete, automated installation system for NS3 (Network Simulator 3) and NS3-AI. The scripts are designed to handle the complex dependencies, configurations, and testing required for a fully functional NS3-AI development environment.

### 📁 Important Setup Instructions

**Before running the scripts:**

1. Create a main project directory: `mkdir NS3-project`
2. Clone the repository inside the project directory
3. Move all repository contents to the NS3-project folder (outside the repo folder):
   ```bash
   mkdir NS3-project
   cd NS3-project
   git clone https://github.com/ahmedmaksud/NS3-NS3AI--installation-and-tests.git
   mv NS3-NS3AI--installation-and-tests/* .
   rmdir NS3-NS3AI--installation-and-tests
   ```
4. All installations will happen in this NS3-project directory
5. The repository files are now in the project root for clean execution

### 🎯 Key Benefits

- **🚀 Automated Installation**: One-command setup for the entire NS3-AI ecosystem
- **🔧 Robust Configuration**: Handles complex dependencies and environment setup
- **🧪 Comprehensive Testing**: Verifies installation with extensive test suites
- **📊 Detailed Reporting**: Generates installation reports with system information
- **🛡️ Error Handling**: Intelligent error detection and recovery mechanisms
- **📖 Educational**: Extensively documented for learning purposes

## 🌐 What is NS3?

[NS3 (Network Simulator 3)](https://www.nsnam.org/) is a discrete-event network simulator for Internet systems, targeted primarily for research and educational use. NS3 is free, open-source software licensed under the GNU GPLv2 license.

### 🔧 NS3 Key Features

- **Discrete Event Simulation**: High-fidelity network protocol simulation
- **Modular Architecture**: Extensive library of network models
- **Python & C++ APIs**: Flexible programming interfaces
- **Realistic Models**: WiFi, LTE, Internet protocols, and more
- **Visualization Tools**: NetAnim for network animation
- **Research-Grade**: Used in academic and industrial research worldwide

### 📡 Common Use Cases

- **Wireless Network Research**: WiFi, LTE, 5G protocol development
- **Internet Protocol Testing**: TCP/IP, routing protocols
- **IoT Simulations**: Sensor networks, mesh networks
- **Network Performance Analysis**: Throughput, latency, packet loss studies
- **Algorithm Validation**: New networking algorithms and protocols

## 🤖 What is NS3-AI?

[NS3-AI](https://github.com/hust-diangroup/ns3-ai) is a powerful extension that integrates Artificial Intelligence and Machine Learning capabilities with NS3, enabling intelligent network simulations and AI-driven protocol development.

### 🧠 NS3-AI Key Features

- **Deep Learning Integration**: TensorFlow and PyTorch support
- **Reinforcement Learning**: OpenAI Gym compatible interface
- **Real-time AI Decision Making**: AI agents controlling network behavior
- **Multi-Interface Support**: Message passing and Gym interfaces
- **Flexible ML Frameworks**: Support for various ML libraries

### 🎯 NS3-AI Applications

- **Intelligent Routing**: AI-based routing algorithms
- **Resource Management**: ML-driven bandwidth allocation
- **Traffic Prediction**: Deep learning for network traffic forecasting
- **Protocol Optimization**: RL-based protocol parameter tuning
- **Anomaly Detection**: AI-powered network security analysis

## ✨ Features

### 🔄 Automated Installation Pipeline

1. **Environment Preparation** (`a_ns3_prep.sh`)
   - System dependency installation
   - Python virtual environment setup
   - Package management and verification

2. **NS3 Core Installation** (`b_ns3_install.sh`)
   - NS3 download and compilation
   - Python bindings configuration
   - Example testing and verification

3. **NS3-AI Integration** (`c_ns3ai_install.sh`)
   - AI framework installation (TensorFlow, PyTorch)
   - NS3-AI repository integration
   - AI example compilation and testing

4. **Comprehensive Testing** (`run_all_install.sh`)
   - Complete installation orchestration
   - Multi-level testing and verification
   - Detailed reporting and diagnostics

### 🛠️ Advanced Capabilities

- **Smart Dependency Resolution**: Automatic handling of complex package dependencies
- **Version Compatibility**: Ensures compatible versions of all components
- **Environment Isolation**: Virtual environment for clean installations
- **Comprehensive Logging**: Detailed logs for debugging and verification
- **Modular Design**: Each script can be run independently
- **Cross-Platform Support**: Optimized for Ubuntu/Debian systems

## 📋 Prerequisites

### System Requirements

- **Operating System**: Ubuntu 20.04+ or Debian 11+
- **Memory**: Minimum 8GB RAM (16GB recommended)
- **Storage**: At least 10GB free space
- **Network**: Stable internet connection for downloads

### Software Dependencies

- **Python**: 3.11 or higher
- **GCC**: 9.0 or higher
- **CMake**: 3.16 or higher
- **Git**: For repository cloning
- **Sudo Access**: Required for system package installation

## 🚀 Quick Start

### Complete Setup and Installation

```bash
# 1. Create main project directory
mkdir NS3-project
cd NS3-project

# 2. Clone the repository inside the project directory
git clone https://github.com/ahmedmaksud/NS3-NS3AI--installation-and-tests.git

# 3. Change into the directory
cd NS3-NS3AI--installation-and-tests

# 4. Run the complete automated installation (everything installs in NS3-project)
./run_all_install.sh
```

### Alternative: Step-by-Step Installation

```bash
# After completing the setup steps above (creating NS3-project and copying files):
# 1. Environment preparation
./a_ns3_prep.sh

# 2. NS3 installation
./b_ns3_install.sh

# 3. NS3-AI installation
./c_ns3ai_install.sh
```

### 📝 Configuration

Create a `venv_name.txt` file with your preferred virtual environment name:

```bash
echo "EHRL" > venv_name.txt
```

## 📖 Detailed Installation Process

### Phase 1: Environment Preparation (`a_ns3_prep.sh`)

This script establishes the foundation for NS3 and NS3-AI installation:

#### 🔧 System Dependencies Installation

```bash
# Core development tools
gcc git g++ python3 python3-dev pkg-config sqlite3

# Build systems and libraries
cmake ninja-build mercurial

# Graphics and visualization
libgtk-3-dev qtbase5-dev qt5-qmake

# Networking libraries
libdpdk-dev libprotobuf-dev protobuf-compiler

# Documentation tools
doxygen graphviz texlive
```

#### 🐍 Python Environment Setup

```bash
# Virtual environment creation
python3.11 -m venv EHRL

# Essential Python packages
pip install cppyy cmake-format setuptools wheel pyyaml
pip install tensorflow==2.18.0  # Matching C library version
pip install torch torchvision torchaudio  # CPU version
pip install matplotlib pandas tqdm  # Data analysis tools
```

#### 🎯 Key Functions Explained

- **`validate_venv_file()`**: Ensures virtual environment configuration exists
- **`setup_virtual_environment()`**: Creates and activates Python virtual environment
- **`install_python_packages()`**: Installs AI/ML Python libraries
- **`install_system_dependencies()`**: Handles system package installation with error checking

### Phase 2: NS3 Core Installation (`b_ns3_install.sh`)

This script downloads, compiles, and configures NS3 with Python bindings:

#### 📥 NS3 Download and Extraction

```bash
# Download NS3 3.44
wget https://www.nsnam.org/releases/ns-allinone-3.44.tar.bz2

# Extract and navigate
tar xfj ns-allinone-3.44.tar.bz2
cd ns-allinone-3.44/ns-3.44
```

#### ⚙️ Two-Stage Configuration Process

**Stage 1: Basic NS3 Installation**
```bash
# Configure with examples and tests
./ns3 configure --enable-examples --enable-tests

# Run validation examples
./ns3 run first.cc
./ns3 run second.cc
# ... through sixth.cc
```

**Stage 2: Python Bindings Integration**
```bash
# Configure with Python support
./ns3 configure --enable-examples --enable-tests -- \
  -DNS3_PYTHON_BINDINGS=ON \
  -DPython3_EXECUTABLE=../../EHRL/bin/python \
  -DNS3_BINDINGS_INSTALL_DIR=../../EHRL/lib/python3.11/site-packages

# Build and verify
./ns3 build
```

#### 🎯 Key Functions Explained

- **`download_ns3()`**: Handles NS3 download with resume capability
- **`configure_basic_ns3()`**: Sets up basic NS3 configuration
- **`configure_python_ns3()`**: Configures Python bindings with proper paths
- **`run_examples()`**: Validates installation by running test examples

### Phase 3: NS3-AI Integration (`c_ns3ai_install.sh`)

This script integrates AI capabilities with NS3:

#### 🧠 AI Framework Installation

**TensorFlow C Library Setup**
```bash
# Create directory structure
mkdir -p contrib/ai/model/libtensorflow

# Download and extract TensorFlow 2.18.0 C library
wget https://storage.googleapis.com/tensorflow/versions/2.18.0/libtensorflow-gpu-linux-x86_64.tar.gz
sudo tar -C contrib/ai/model/libtensorflow -xzf libtensorflow-gpu-linux-x86_64.tar.gz
```

**PyTorch C Library Setup**
```bash
# Download LibTorch (CPU version for compatibility)
wget https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.7.0%2Bcpu.zip -O libtorch.zip
unzip libtorch.zip -d contrib/ai/model
```

#### 🔗 NS3-AI Repository Integration

```bash
# Clone NS3-AI into NS3 contrib directory
git clone https://github.com/hust-diangroup/ns3-ai.git contrib/ai

# Install Python interfaces
pip install -e contrib/ai/python_utils
pip install -e contrib/ai/model/gym-interface/py
```

#### ⚙️ Advanced Configuration

```bash
# Configure NS3 with AI support and protobuf paths
./ns3 configure --enable-examples --enable-tests -- \
  -DNS3_PYTHON_BINDINGS=ON \
  -DPython3_EXECUTABLE=../../EHRL/bin/python \
  -DNS3_BINDINGS_INSTALL_DIR=../../EHRL/lib/python3.11/site-packages \
  -DPython3_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.11.so \
  -DProtobuf_LIBRARY=/usr/lib/x86_64-linux-gnu/libprotobuf.so \
  -DProtobuf_INCLUDE_DIRS=/usr/include \
  -DProtobuf_DIR=/usr/lib/x86_64-linux-gnu/cmake/protobuf
```

#### 🔧 Bug Fixes and Workarounds

```bash
# Fix known header issue in multi-bss example
sed -i '33i #include <map>' contrib/ai/examples/multi-bss/vr-app/model/burst-sink.h
```

#### 🎯 Key Functions Explained

- **`setup_environment()`**: Configures environment variables for AI libraries
- **`install_cuda_support()`**: Optional CUDA installation for GPU acceleration
- **`clone_ns3ai()`**: Integrates NS3-AI repository into NS3 structure
- **`install_tensorflow()`**: Sets up TensorFlow C library in correct location
- **`install_pytorch()`**: Configures PyTorch C++ library
- **`configure_ns3_ai()`**: Advanced NS3 configuration with AI support
- **`build_all_examples()`**: Compiles all NS3-AI examples

## 🧪 Testing and Verification

### Automated Testing Suite (`run_all_install.sh`)

The master script performs comprehensive testing across multiple levels:

#### 🔍 Test Categories

**1. Basic NS3 Functionality**
```bash
# Tests core NS3 examples
./ns3 run first.cc    # Basic simulation
./ns3 run second.cc   # Point-to-point networks
./ns3 run third.cc    # CSMA networks
./ns3 run fourth.cc   # WiFi networks
./ns3 run fifth.cc    # Mixed networks
./ns3 run sixth.cc    # Mobility models
```

**2. Python Bindings Verification**
```python
# Test Python import capability
import ns3
print('NS3 Python bindings working')
```

**3. NS3-AI Integration Testing**
```bash
# AI Example Categories:
# A-Plus-B Examples (Basic AI integration)
./ns3 build ns3ai_apb_gym        # Gym interface
./ns3 build ns3ai_apb_msg_stru   # Message interface (struct)
./ns3 build ns3ai_apb_msg_vec    # Message interface (vector)

# Multi-BSS Examples (Advanced WiFi scenarios)
./ns3 build ns3ai_multibss       # Complex WiFi networks

# RL-TCP Examples (Reinforcement Learning)
./ns3 build ns3ai_rltcp_gym      # RL with Gym interface
./ns3 build ns3ai_rltcp_msg      # RL with Message interface

# Rate Control Examples (Traffic management)
./ns3 build ns3ai_ratecontrol_constant  # Constant rate control
./ns3 build ns3ai_ratecontrol_ts        # Thompson Sampling

# LTE-CQI Examples (Cellular networks)
./ns3 build ns3ai_ltecqi_msg     # LTE Channel Quality Indicator
```

#### 📊 Reporting System

The testing system generates comprehensive reports including:

- **System Information**: OS, Python, GCC, CMake versions
- **Installation Status**: Directory structure verification
- **Component Testing**: Individual component functionality
- **Error Logs**: Detailed failure analysis
- **Performance Metrics**: Installation timing and resource usage

## 🔧 Script Documentation

### Script Architecture

Each script follows a modular, function-based architecture with comprehensive error handling:

#### Common Design Patterns

**Logging System**
```bash
# Color-coded logging functions
log_info()     # Blue - General information
log_success()  # Green - Success messages
log_warning()  # Yellow - Warning messages
log_error()    # Red - Error messages
log_header()   # Cyan - Section headers
log_test()     # Magenta - Test operations
```

**Error Handling**
```bash
set -e  # Exit on any error
trap cleanup EXIT  # Ensure cleanup on script exit
```

**Configuration Management**
```bash
# Centralized configuration
NS3_VERSION="3.44"
PYTHON_VERSION="3.11"
TENSORFLOW_VERSION="2.18.0"
LIBTORCH_VERSION="2.7.0"
```

### Function Documentation

#### Environment Management Functions

**`validate_venv()`**
- **Purpose**: Validates virtual environment configuration
- **Returns**: Virtual environment name
- **Error Handling**: Creates default configuration if missing

**`activate_venv(venv_name)`**
- **Purpose**: Activates Python virtual environment
- **Parameters**: `venv_name` - Name of virtual environment
- **Behavior**: Creates environment if it doesn't exist

#### Installation Functions

**`install_system_dependencies()`**
- **Purpose**: Installs required system packages
- **Features**: Progress tracking, failure reporting, retry logic
- **Packages**: 50+ development and runtime dependencies

**`download_ns3()`**
- **Purpose**: Downloads and extracts NS3 source code
- **Features**: Resume capability, integrity checking
- **Cleanup**: Removes old installations automatically

#### Configuration Functions

**`configure_python_ns3(venv_name)`**
- **Purpose**: Configures NS3 with Python bindings
- **Parameters**: Virtual environment path
- **CMake Options**: Python executable, installation directory

**`configure_ns3_ai(venv_name)`**
- **Purpose**: Advanced NS3 configuration with AI support
- **Features**: Protobuf path resolution, AI library integration
- **Dependencies**: TensorFlow and PyTorch C libraries

#### Testing Functions

**`run_examples(stage)`**
- **Purpose**: Executes NS3 examples for validation
- **Parameters**: `stage` - Description of testing stage
- **Verification**: Success/failure tracking with detailed reporting

**`test_ns3ai_examples()`**
- **Purpose**: Comprehensive NS3-AI example testing
- **Scope**: Build verification and execution testing
- **Timeout**: 30-second execution limit to prevent hanging

## 🔍 Advanced Configuration

### Environment Variables

The scripts configure several critical environment variables:

```bash
# Library path for shared libraries
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

# Python path for NS3-AI modules
export PYTHONPATH=$PYTHONPATH:$(pwd)/contrib/ai/model/gym-interface/py
```

### CMake Configuration Options

**Basic NS3 Configuration**
```bash
./ns3 configure --enable-examples --enable-tests
```

**Python Bindings Configuration**
```bash
./ns3 configure --enable-examples --enable-tests -- \
  -DNS3_PYTHON_BINDINGS=ON \
  -DPython3_EXECUTABLE=../../EHRL/bin/python \
  -DNS3_BINDINGS_INSTALL_DIR=../../EHRL/lib/python3.11/site-packages
```

**AI Support Configuration**
```bash
./ns3 configure --enable-examples --enable-tests -- \
  -DNS3_PYTHON_BINDINGS=ON \
  -DPython3_EXECUTABLE=../../EHRL/bin/python \
  -DNS3_BINDINGS_INSTALL_DIR=../../EHRL/lib/python3.11/site-packages \
  -DPython3_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.11.so \
  -DProtobuf_LIBRARY=/usr/lib/x86_64-linux-gnu/libprotobuf.so \
  -DProtobuf_INCLUDE_DIRS=/usr/include \
  -DProtobuf_DIR=/usr/lib/x86_64-linux-gnu/cmake/protobuf
```

### Version Compatibility Matrix

| Component | Version | Compatibility |
|-----------|---------|---------------|
| NS3 | 3.44 | Base version |
| Python | 3.11 | Required for TensorFlow 2.18 |
| TensorFlow | 2.18.0 | Matches C library |
| PyTorch | 2.7.0 | CPU version for stability |
| GCC | 9.0+ | C++17 support required |
| CMake | 3.16+ | Modern CMake features |

## 🐛 Troubleshooting

### Common Issues and Solutions

#### 1. Virtual Environment Creation Fails

**Problem**: Python virtual environment creation fails
```bash
Error: Virtual environment creation failed
```

**Solution**:
```bash
# Install Python virtual environment support
sudo apt install python3.11-venv

# Ensure Python 3.11 is installed
sudo apt install python3.11 python3.11-dev
```

#### 2. NS3 Build Failures

**Problem**: NS3 compilation errors
```bash
Error: Build failed with compiler errors
```

**Solutions**:
```bash
# Update build tools
sudo apt update && sudo apt upgrade build-essential

# Install missing dependencies
sudo apt install libc6-dev libc6-dev-i386

# Clean and rebuild
./ns3 clean
./ns3 configure --enable-examples --enable-tests
./ns3 build
```

#### 3. Python Bindings Import Errors

**Problem**: Cannot import ns3 module in Python
```python
ImportError: No module named 'ns3'
```

**Solutions**:
```bash
# Verify Python path
python3 -c "import sys; print('\n'.join(sys.path))"

# Check bindings installation
ls EHRL/lib/python3.11/site-packages/

# Rebuild with correct paths
./ns3 configure --enable-examples --enable-tests -- \
  -DNS3_PYTHON_BINDINGS=ON \
  -DPython3_EXECUTABLE=$(which python3) \
  -DNS3_BINDINGS_INSTALL_DIR=$(python3 -c "import site; print(site.getsitepackages()[0])")
```

#### 4. TensorFlow Integration Issues

**Problem**: TensorFlow C library not found
```bash
Error: Could not find TensorFlow library
```

**Solutions**:
```bash
# Verify TensorFlow installation
ls contrib/ai/model/libtensorflow/

# Check library path
export LD_LIBRARY_PATH=contrib/ai/model/libtensorflow/lib:$LD_LIBRARY_PATH

# Reinstall TensorFlow C library
rm -rf contrib/ai/model/libtensorflow
mkdir -p contrib/ai/model/libtensorflow
wget -q --no-check-certificate https://storage.googleapis.com/tensorflow/versions/2.18.0/libtensorflow-gpu-linux-x86_64.tar.gz
sudo tar -C contrib/ai/model/libtensorflow -xzf libtensorflow-gpu-linux-x86_64.tar.gz
```

#### 5. Multi-BSS Example Compilation Error

**Problem**: burst-sink.h compilation error
```bash
Error: 'map' is not declared in this scope
```

**Solution**: This is automatically handled by the script:
```bash
sed -i '33i #include <map>' contrib/ai/examples/multi-bss/vr-app/model/burst-sink.h
```

### Debugging Tips

#### Enable Verbose Logging

```bash
# Run scripts with bash debug mode
bash -x ./a_ns3_prep.sh

# Check individual log files
ls /tmp/ns3*_test_*.log
ls /tmp/ns3ai_*_*.log
```

#### System Resource Monitoring

```bash
# Monitor memory usage during installation
watch -n 5 free -h

# Check disk space
df -h

# Monitor CPU usage
htop
```

#### Dependency Verification

```bash
# Check Python packages
pip list | grep -E "(tensorflow|torch|ns3ai)"

# Verify system packages
dpkg -l | grep -E "(gcc|cmake|protobuf)"

# Check library paths
ldconfig -p | grep -E "(tensorflow|torch|protobuf)"
```

## 📚 Educational Resources

### Learning NS3

#### Official Documentation
- [NS3 Tutorial](https://www.nsnam.org/docs/tutorial/html/index.html)
- [NS3 Manual](https://www.nsnam.org/docs/manual/html/index.html)
- [NS3 API Documentation](https://www.nsnam.org/doxygen/index.html)

#### Recommended Learning Path

1. **Basic Concepts**
   - Discrete event simulation principles
   - Network protocol fundamentals
   - C++ programming for simulation

2. **NS3 Fundamentals**
   - Node, NetDevice, Channel concepts
   - Application layer programming
   - Protocol stack configuration

3. **Advanced Topics**
   - Custom protocol implementation
   - Performance analysis and statistics
   - Large-scale simulation techniques

### Learning NS3-AI

#### Research Papers
- [NS3-AI: Enabling Artificial Intelligence Algorithms for Networking Research](https://dl.acm.org/doi/10.1145/3389400.3389404)
- [Deep Learning for Network Traffic Prediction](https://ieeexplore.ieee.org/document/8737435)

#### AI/ML Integration Concepts

1. **Reinforcement Learning in Networking**
   - Q-learning for routing optimization
   - Deep Q-Networks (DQN) for resource allocation
   - Multi-agent systems for distributed protocols

2. **Deep Learning Applications**
   - Traffic prediction using LSTM networks
   - Anomaly detection with autoencoders
   - Protocol optimization with neural networks

3. **Framework Integration**
   - TensorFlow for deep learning models
   - PyTorch for research prototyping
   - OpenAI Gym for RL environments

### Example Projects

#### Beginner Projects

1. **Basic WiFi Simulation**
```cpp
// Create nodes
NodeContainer wifiStaNodes;
wifiStaNodes.Create(nWifi);
NodeContainer wifiApNode;
wifiApNode.Create(1);

// Configure WiFi
YansWifiChannelHelper channel = YansWifiChannelHelper::Default();
YansWifiPhyHelper phy = YansWifiPhyHelper::Default();
phy.SetChannel(channel.Create());
```

2. **Simple AI Traffic Prediction**
```python
import ns3ai_gym_env
import tensorflow as tf

# Create environment
env = ns3ai_gym_env.Ns3AiGymEnv()

# Simple neural network
model = tf.keras.Sequential([
    tf.keras.layers.Dense(64, activation='relu'),
    tf.keras.layers.Dense(32, activation='relu'),
    tf.keras.layers.Dense(1)
])
```

#### Intermediate Projects

1. **Intelligent Routing Protocol**
   - Implement Q-learning based routing
   - Compare with traditional protocols
   - Analyze convergence and performance

2. **Dynamic Resource Allocation**
   - Use neural networks for bandwidth allocation
   - Implement fairness constraints
   - Evaluate under various traffic patterns

#### Advanced Projects

1. **Multi-Agent Network Optimization**
   - Distributed AI agents for network control
   - Cooperative and competitive scenarios
   - Large-scale deployment analysis

2. **Real-time Protocol Adaptation**
   - Online learning for protocol parameters
   - Adaptive congestion control
   - Performance optimization in dynamic environments

## 🤝 Contributing

We welcome contributions to improve these installation scripts and documentation!

### How to Contribute

1. **Fork the Repository**
   ```bash
   git fork <repository-url>
   git clone <your-fork-url>
   ```

2. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   - Follow existing code style and patterns
   - Add comprehensive comments
   - Test on clean Ubuntu installation

4. **Submit Pull Request**
   - Provide detailed description of changes
   - Include testing results
   - Reference any related issues

### Contribution Areas

- **Platform Support**: Extend support to other Linux distributions
- **Version Updates**: Support for newer NS3 and AI framework versions
- **Testing Enhancement**: Additional test cases and validation
- **Documentation**: Improve explanations and add examples
- **Bug Fixes**: Address installation issues and edge cases

### Development Setup

```bash
# Setup development environment
git clone <repository-url>
cd founding-scripts

# Create test virtual machine
vagrant init ubuntu/focal64
vagrant up
vagrant ssh

# Test installation scripts
./run_all_install.sh
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Third-Party Licenses

- **NS3**: GNU General Public License v2.0
- **NS3-AI**: Apache License 2.0
- **TensorFlow**: Apache License 2.0
- **PyTorch**: BSD-style license

## 📞 Support and Contact

### Getting Help

1. **Check Documentation**: Review this README and script comments
2. **Search Issues**: Look for existing solutions in GitHub issues
3. **Create Issue**: Submit detailed bug reports or feature requests
4. **Community Support**: Join NS3 and NS3-AI community forums

### Reporting Issues

When reporting issues, please include:

- **System Information**: OS version, hardware specifications
- **Error Messages**: Complete error logs and stack traces
- **Reproduction Steps**: Detailed steps to reproduce the issue
- **Environment**: Virtual environment and dependency versions

### Feature Requests

For feature requests, please provide:

- **Use Case**: Detailed description of the intended use
- **Benefits**: How the feature would help the community
- **Implementation Ideas**: Suggestions for implementation approach

---

## 🙏 Acknowledgments

- **NS3 Development Team**: For creating the excellent network simulation platform
- **NS3-AI Contributors**: For bridging networking and AI research
- **Open Source Community**: For the tools and libraries that make this possible

### Related Projects

- [NS3 Official Repository](https://gitlab.com/nsnam/ns-3-dev)
- [NS3-AI Project](https://github.com/hust-diangroup/ns3-ai)
- [TensorFlow](https://tensorflow.org/)
- [PyTorch](https://pytorch.org/)

---

**Happy Simulating! 🚀**

*For more information about NS3 and network simulation, visit [nsnam.org](https://www.nsnam.org/)*

*For AI integration details, check [NS3-AI GitHub](https://github.com/hust-diangroup/ns3-ai)*
