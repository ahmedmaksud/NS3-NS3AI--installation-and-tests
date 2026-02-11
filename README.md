# NS3 and NS3-AI Installation Scripts

**Author:** Ahmed Maksud (ahmed.maksud@email.ucr.edu)  
**PI:** Marcelo Menezes De Carvalho (mmcarvalho@txstate.edu)  
**Institution:** Texas State University

A comprehensive automated installation system for NS3 (Network Simulator 3) and NS3-AI (Python Wrapper) with complete testing and verification capabilities.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![NS3 Version](https://img.shields.io/badge/NS3-3.44-blue.svg)](https://www.nsnam.org/)
[![Python](https://img.shields.io/badge/Python-3.11-green.svg)](https://www.python.org/)
[![TensorFlow](https://img.shields.io/badge/TensorFlow-2.18.0-orange.svg)](https://tensorflow.org/)
[![PyTorch](https://img.shields.io/badge/PyTorch-2.8.0-red.svg)](https://pytorch.org/)

> This installation system has been extensively tested and refined through challenges such as complex dependency conflicts, Python binding issues, and C++ library compatibility problems.

*For more information about NS3 and network simulation, visit [nsnam.org](https://www.nsnam.org/)*

*For AI integration details, check [NS3-AI GitHub](https://github.com/hust-diangroup/ns3-ai)*

## Quick Start

### **IMPORTANT: Prerequisites Check**

**Before starting, ensure you have installed:**
- **Python 3.11** (`python3.11 --version`)
- **Git** (`git --version`)

> **GitHub Codespaces Users**: Run the following commands to install Python 3.11:
> ```bash
> # Add Python 3.11 repository and install
> sudo add-apt-repository -y ppa:deadsnakes/ppa
> sudo mv /etc/apt/sources.list.d/yarn.list /etc/apt/sources.list.d/yarn.list.disabled
> sudo apt update
> sudo apt install -y python3.11 python3.11-venv python3.11-dev git
> ```

If any of these are missing, please install them first using the commands in the [Prerequisites](#-prerequisites) section.

### Complete Setup and Installation

```bash
# 1. Create main project directory
mkdir NS3-project
cd NS3-project

# 2. Clone the repository inside the project directory
git clone https://github.com/ahmedmaksud/NS3-NS3AI--installation-and-tests.git

# 3. Change into the directory
cd NS3-NS3AI--installation-and-tests

# 4. Verify prerequisites are installed
python3.11 --version && git --version

# 5. Run the complete automated installation (everything installs in NS3-project)
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

## Table of Contents

- [Overview](#-overview)
- [What is NS3?](#-what-is-ns3)
- [What is NS3-AI?](#-what-is-ns3-ai)
- [Repository Features](#-repository-features)
- [Prerequisites](#-prerequisites)
- [Testing and Verification](#-testing-and-verification)
- [Troubleshooting](#-troubleshooting)
- [Educational Resources](#-educational-resources)
- [License](#-license)
- [Development Journey](#development-journey-optional-reading) *(optional)*

## Overview

This repository provides a complete automated installation system for NS3 (Network Simulator 3) and NS3-AI. The scripts have been refined through extensive testing and debugging to handle complex dependency conflicts, Python binding issues, and C++ library compatibility problems that commonly occur in NS3-AI installations.

**What Makes This Different**: Unlike simple installation scripts, this system has been developed through solving actual deployment challenges including LibTorch conflicts, Python binding failures, and version compatibility matrices.

### Key Features

- **Thoroughly Tested Installation**: Solved real-world LibTorch conflicts, Python binding issues, and dependency problems
- **Robust Configuration**: Handles complex NS3-AI Python binding detection and library compatibility
- **Comprehensive Testing**: Multi-level validation including NS3-AI specific binding verification
- **Intelligent Reporting**: Detailed installation reports with system diagnostics and troubleshooting guidance
- **Error Recovery**: Graceful handling of common issues like core NS3 Python binding failures
- **Production-Ready**: Extensively documented with real-world deployment insights and debugging strategies

## What is NS3?

[NS3 (Network Simulator 3)](https://www.nsnam.org/) is a discrete-event network simulator for Internet systems, targeted primarily for research and educational use. NS3 is free, open-source software licensed under the GNU GPLv2 license.

### NS3 Key Features

- **Discrete Event Simulation**: High-fidelity network protocol simulation
- **Modular Architecture**: Extensive library of network models
- **Python & C++ APIs**: Flexible programming interfaces
- **Realistic Models**: WiFi, LTE, Internet protocols, and more
- **Visualization Tools**: NetAnim for network animation
- **Research-Grade**: Used in academic and industrial research worldwide

### Common Use Cases

- **Wireless Network Research**: WiFi, LTE, 5G protocol development
- **Internet Protocol Testing**: TCP/IP, routing protocols
- **IoT Simulations**: Sensor networks, mesh networks
- **Network Performance Analysis**: Throughput, latency, packet loss studies
- **Algorithm Validation**: New networking algorithms and protocols

## What is NS3-AI?

[NS3-AI](https://github.com/hust-diangroup/ns3-ai) is a powerful extension that integrates Artificial Intelligence and Machine Learning capabilities with NS3, enabling intelligent network simulations and AI-driven protocol development.

### NS3-AI Key Features

- **Deep Learning Integration**: TensorFlow and PyTorch support
- **Reinforcement Learning**: OpenAI Gym compatible interface
- **Real-time AI Decision Making**: AI agents controlling network behavior
- **Multi-Interface Support**: Message passing and Gym interfaces
- **Flexible ML Frameworks**: Support for various ML libraries

### NS3-AI Applications

- **Intelligent Routing**: AI-based routing algorithms
- **Resource Management**: ML-driven bandwidth allocation
- **Traffic Prediction**: Deep learning for network traffic forecasting
- **Protocol Optimization**: RL-based protocol parameter tuning
- **Anomaly Detection**: AI-powered network security analysis

## Repository Features

### Automated Installation Pipeline

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

### Advanced Capabilities

- **Smart Dependency Resolution**: Automatic handling of complex package dependencies
- **Version Compatibility**: Ensures compatible versions of all components
- **Environment Isolation**: Virtual environment for clean installations
- **Comprehensive Logging**: Detailed logs for debugging and verification
- **Modular Design**: Each script can be run independently
- **Cross-Platform Support**: Optimized for Ubuntu/Debian systems

## Prerequisites

### System Requirements

- **Operating System**: Ubuntu 20.04+ or Debian 11+
- **Memory**: Minimum 8GB RAM (16GB recommended)
- **Storage**: At least 10GB free space
- **Network**: Stable internet connection for downloads

### **CRITICAL: Pre-Installation Requirements**

**Before running any scripts, you MUST install these tools manually:**

#### **1. Python 3.11 (REQUIRED)**
This project explicitly requires Python 3.11 for TensorFlow 2.18.0 compatibility.

```bash
# Ubuntu/Debian installation
sudo apt update
sudo apt install python3.11 python3.11-dev python3.11-venv

# Verify installation
python3.11 --version
# Should output: Python 3.11.x
```

#### **2. Git (REQUIRED)**
Required for cloning repositories.

```bash
# Ubuntu/Debian installation
sudo apt install git

# Verify installation
git --version
# Should output: git version 2.x.x
```

### Software Dependencies (Auto-installed by scripts)

- **GCC**: 9.0 or higher
- **CMake**: 3.16 or higher
- **Sudo Access**: Required for system package installation

## Testing and Verification

### Automated Testing Suite (`run_all_install.sh`)

The master script performs comprehensive testing across multiple levels:

#### Test Categories

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

#### Reporting System

The testing system generates comprehensive reports including:

- **System Information**: OS, Python, GCC, CMake versions
- **Installation Status**: Directory structure verification
- **Component Testing**: Individual component functionality
- **Error Logs**: Detailed failure analysis
- **Performance Metrics**: Installation timing and resource usage

## Troubleshooting

### Common Issues and Solutions (Extensively Tested)

> These solutions were discovered through extensive real-world debugging sessions and are proven to work.

#### 0. Prerequisites Not Installed (most common issue)

**Problem**: Scripts fail immediately or show "command not found" errors
```bash
Error: python3.11: command not found
Error: git: command not found
```

**Solution**: *(Install required tools first)*
```bash
# Install Python 3.11
sudo apt update
sudo apt install python3.11 python3.11-dev python3.11-venv

# Install Git
sudo apt install git

# Verify all tools are installed
python3.11 --version && git --version
```

#### 1. Virtual Environment Creation Fails

**Problem**: Python virtual environment creation fails
```bash
Error: Virtual environment creation failed
```

**Solution**: *(Tested solution)*
```bash
# Install Python virtual environment support
sudo apt install python3.11-venv

# Ensure Python 3.11 is installed (CRITICAL for TensorFlow compatibility)
sudo apt install python3.11 python3.11-dev
```

#### 2. NS3 Build Failures

**Problem**: NS3 compilation errors
```bash
Error: Build failed with compiler errors
```

**Solutions**: *(Multiple fallback strategies)*
```bash
# Update build tools
sudo apt update && sudo apt upgrade build-essential

# Install missing dependencies (discovered during testing)
sudo apt install libc6-dev libc6-dev-i386

# Clean and rebuild (always works)
./ns3 clean
./ns3 configure --enable-examples --enable-tests
./ns3 build
```

#### 3. NS3-AI Python Bindings Not Found

**Problem**: Script reports no NS3-AI Python bindings found
```bash
No NS3-AI C++ Python bindings found in build directory
```

**Root Cause Discovery**: Bindings have `.cpython-311-x86_64-linux-gnu.so` extension, not simple `.so`

**Solution**:
```bash
# Updated search pattern in scripts
find contrib/ai -name "*ns3ai*.cpython*.so"

# Bindings are located in example subdirectories:
# contrib/ai/examples/a-plus-b/use-msg-stru/ns3ai_apb_py_stru.cpython-311-x86_64-linux-gnu.so
# contrib/ai/examples/a-plus-b/use-msg-vec/ns3ai_apb_py_vec.cpython-311-x86_64-linux-gnu.so
# ... etc.

# Test imports from correct directories
cd contrib/ai/examples/a-plus-b/use-msg-stru
python3 -c "import ns3ai_apb_py_stru; print('Success!')"
```

#### 4. Core NS3 Python Bindings Import Errors

**Problem**: Cannot import ns3 module in Python
```python
ImportError: list index out of range
# Core NS3 v3.44 Python bindings have parsing issues
```

**Key Discovery**:
```bash
# Core NS3 Python bindings in v3.44 have library name parsing issues
# However, NS3-AI has its own independent pybind11-based binding system!
```

**Solution**:
```bash
# Don't fix core NS3 bindings - use NS3-AI bindings instead
# NS3-AI Python bindings work perfectly without core NS3 bindings
# Focus testing on: ns3ai_apb_py_stru, ns3ai_gym_msg_py, etc.
```

#### 5. LibTorch Integration Issues

**Problem**: LibTorch C library causes segmentation faults
```bash
Error: Could not find TensorFlow library
cmake: undefined reference to torch::jit symbols
Segmentation fault in libtorch_python.so
```

**Root Cause**: libtorch_python.so conflicts with PyTorch pip installation

**Solution**: *(Proven fix)*
```bash
# Automatic fix applied by c_ns3ai_install.sh
# Modifies CMakeLists.txt to exclude problematic library:

# In contrib/ai/CMakeLists.txt:
if(LIBTORCH_PYTHON_LIBRARY)
    list(REMOVE_ITEM LIBTORCH_LIBRARIES "${LIBTORCH_PYTHON_LIBRARY}")
endif()
```

#### 6. TensorFlow C Library Version Mismatch

**Problem**: TensorFlow Python/C library version conflicts
```bash
ImportError: incompatible TensorFlow version
```

**Solution**:
```bash
# Use exactly these versions together:
Python 3.11 + TensorFlow 2.18.0 (pip) + TensorFlow 2.18.0 (C library)

# Verify correct installation:
python3 -c "import tensorflow as tf; print(f'TensorFlow {tf.__version__}')"
# Should output: TensorFlow 2.18.0

# C library location:
ls contrib/ai/model/libtensorflow/lib/
# Should contain: libtensorflow.so.2
```

#### 7. Multi-BSS Example Issues **Partial Fix**

**Problem 1**: burst-sink.h compilation error  
```bash
Error: 'map' is not declared in this scope
```
**Solution**: *(Automatically handled by script)*
```bash
# Fixed automatically in c_ns3ai_install.sh:
sed -i '33i #include <map>' contrib/ai/examples/multi-bss/vr-app/model/burst-sink.h
```

**Problem 2**: WiFi API deprecation at runtime *(Not auto-fixed)*
```bash
Attribute 'MaxSlrc' is obsolete, with no fallback: Use WifiMac::FrameRetryLimit instead
```
**Root Cause**: Lines 1787-1790 in multi-bss.cc use deprecated `MaxSlrc` and `MaxSsrc` attributes removed in NS3 v3.44

**Status**: Example compiles but fails at runtime due to NS3 API changes. Requires updating WiFi configuration to use `WifiMac::FrameRetryLimit`

## Educational Resources

### Learning NS3

#### Official Documentation
- [NS3 Tutorial](https://www.nsnam.org/docs/tutorial/html/index.html)
- [NS3 Manual](https://www.nsnam.org/docs/manual/html/index.html)
- [NS3 API Documentation](https://www.nsnam.org/doxygen/index.html)

### Learning NS3-AI

#### Research Papers
- [NS3-AI: Enabling Artificial Intelligence Algorithms for Networking Research](https://dl.acm.org/doi/10.1145/3389400.3389404)
- [Deep Learning for Network Traffic Prediction](https://ieeexplore.ieee.org/document/8737435)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Third-Party Licenses

- **NS3**: GNU General Public License v2.0
- **NS3-AI**: Apache License 2.0
- **TensorFlow**: Apache License 2.0
- **PyTorch**: BSD-style license


## Development Journey (Optional Reading)

> This section documents the development process and lessons learned—serving as a reference log for future troubleshooting.

### The Challenge

**Goal**: Create a one-click installation system for NS3-AI with comprehensive testing.

What seemed straightforward became a deep dive into dependency conflicts, version matrices, and binding system intricacies.

### Key Problems & Solutions

| Problem | Root Cause | Solution |
|---------|------------|----------|
| **Core NS3 Python bindings fail** | NS3 v3.44 has parsing bugs (`list index out of range`) | Pivot to NS3-AI's independent pybind11 bindings |
| **LibTorch segmentation faults** | `libtorch_python.so` conflicts with pip PyTorch | Exclude from CMake: `list(REMOVE_ITEM LIBTORCH_LIBRARIES ...)` |
| **TensorFlow version mismatch** | Mixed Python 3.10/3.11 environments | Enforce Python 3.11 + TensorFlow 2.18.0 throughout |
| **Bindings not found** | Wrong search pattern (`*.so` vs `*.cpython*.so`) | Use `find contrib/ai -name "*ns3ai*.cpython*.so"` |
| **Multi-BSS runtime failure** | WiFi API deprecation: `MaxSlrc`/`MaxSsrc` removed in v3.44 | Update to `WifiMac::FrameRetryLimit` (requires NS3-AI upstream fix) |

### Major Breakthrough

**NS3-AI operates independently of core NS3 Python bindings.**

This discovery changed everything:
- Core NS3 v3.44 bindings have unfixable issues—but NS3-AI uses its own pybind11-based system
- All 9 C++ examples compile successfully
- Python ML environment (TensorFlow, PyTorch, Gymnasium) fully functional
- Stop debugging what can't be fixed; focus on what works

### Tested Component Versions

```
Python 3.11 + TensorFlow 2.18.0 + PyTorch 2.8.0+cpu + NS3 3.44
```

This combination was discovered through extensive testing.

### Lessons Learned

1. **Version pinning matters** — Latest versions often conflict; tested combinations are golden
2. **Component isolation** — Test parts independently before integration  
3. **Graceful degradation** — When something doesn't work, focus on what does
4. **Comprehensive logging** — Enables rapid issue identification
