#!/bin/bash
# NS3-AI Installation Script
# Important notes:
# There is a problem with the multi-bss example, in multi-bss.cc line 1786
# The MaxSlrc and MaxSsrc are outdated, the alternative is not clear, I just omitted the burst option

set -e  # Exit on any error

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NS3_VERSION="3.44"
PYTHON_VERSION="3.11"
VENV_FILE="venv_name.txt"
TENSORFLOW_VERSION="2.18.0"
LIBTORCH_VERSION="2.7.0"

# URLs and filenames
TENSORFLOW_CPU_FILENAME="libtensorflow-cpu-linux-x86_64.tar.gz"
TENSORFLOW_GPU_FILENAME="libtensorflow-gpu-linux-x86_64.tar.gz"
TENSORFLOW_CPU_URL="https://storage.googleapis.com/tensorflow/versions/${TENSORFLOW_VERSION}/${TENSORFLOW_CPU_FILENAME}"
TENSORFLOW_GPU_URL="https://storage.googleapis.com/tensorflow/versions/${TENSORFLOW_VERSION}/${TENSORFLOW_GPU_FILENAME}"
LIBTORCH_URL="https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-${LIBTORCH_VERSION}%2Bcpu.zip"
NS3AI_REPO="https://github.com/hust-diangroup/ns3-ai.git"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to validate virtual environment
validate_venv() {
    if [ ! -f "$VENV_FILE" ]; then
        log_error "Virtual environment name file '$VENV_FILE' not found."
        log_info "Please create the file and add the virtual environment name."
        exit 1
    fi

    VENV_NAME=$(cat "$VENV_FILE" | tr -d '\n\r' | xargs)

    if [ -z "$VENV_NAME" ]; then
        log_error "Virtual environment name is empty in '$VENV_FILE'."
        exit 1
    fi

    echo "$VENV_NAME"
}

# Function to activate virtual environment
activate_venv() {
    local venv_name="$1"
    local venv_path="${SCRIPT_DIR}/../$venv_name"

    # Check if the virtual environment exists, create if it doesn't
    if [ ! -d "$venv_path" ]; then
        log_info "Virtual environment '$venv_name' does not exist. Creating it with Python 3.11..."
        if python3.11 -m venv "$venv_path"; then
            log_success "Virtual environment '$venv_name' created successfully with Python 3.11"
        else
            log_error "Failed to create virtual environment '$venv_name' with Python 3.11"
            exit 1
        fi
    else
        log_success "Virtual environment '$venv_name' already exists."
    fi

    if [ -z "$VIRTUAL_ENV" ] || [ "$VIRTUAL_ENV" != "$(realpath "$venv_path")" ]; then
        log_info "Virtual environment is not active."
        log_info "🔗 Activating virtual environment '$venv_name'..."
        source "$venv_path/bin/activate"
    else
        log_success "Virtual environment '$venv_name' is already active."
    fi
}

# Function to setup environment variables
setup_environment() {
    log_info "Setting up environment variables..."
    export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
    export PYTHONPATH=$PYTHONPATH:$(pwd)/contrib/ai/model/gym-interface/py
    log_success "Environment variables configured"
    
    # Add the required directory to PYTHONPATH
    # export PYTHONPATH=$PYTHONPATH:ns-allinone-3.44/ns-3.44/contrib/ai/model/gym-interface/py
}

# Function to check for NVIDIA GPU
check_nvidia_gpu() {
    log_info "Checking for NVIDIA GPU..."
    
    # Check if nvidia-smi is available and working
    if command -v nvidia-smi >/dev/null 2>&1; then
        if nvidia-smi >/dev/null 2>&1; then
            log_success "NVIDIA GPU detected and drivers are working"
            return 0
        else
            log_warning "nvidia-smi found but not working properly"
            return 1
        fi
    fi
    
    # Check for NVIDIA GPU via lspci
    if lspci | grep -i nvidia >/dev/null 2>&1; then
        log_warning "NVIDIA GPU detected but drivers may not be installed"
        return 2
    fi
    
    # No NVIDIA GPU found
    log_info "No NVIDIA GPU detected on this system"
    return 1
}

# Function to install CUDA support
install_cuda_support() {
    log_info "Checking if CUDA installation is needed..."
    
    # Check for NVIDIA GPU
    gpu_status=$(check_nvidia_gpu; echo $?)
    
    case $gpu_status in
        0)
            log_info "NVIDIA GPU with working drivers detected. Installing CUDA support..."
            log_warning "This will install nvidia-cuda-toolkit - may take some time"
            
            sudo apt install -y nvidia-cuda-toolkit
            
            log_info "Checking CUDA installation..."
            nvcc --version
            nvidia-smi
            
            log_success "CUDA installation completed"
            ;;
        2)
            log_warning "NVIDIA GPU detected but drivers not properly installed"
            read -p "Do you want to install CUDA anyway? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                log_info "Installing CUDA support..."
                sudo apt install -y nvidia-cuda-toolkit
                log_success "CUDA installation completed (GPU drivers may need separate installation)"
            else
                log_info "Skipping CUDA installation"
            fi
            ;;
        *)
            log_info "No NVIDIA GPU detected. Skipping CUDA installation."
            log_info "NS3-AI will work with CPU-only TensorFlow and PyTorch libraries"
            ;;
    esac
}


# Function to clone NS3-AI repository
clone_ns3ai() {
    log_info "Now get on with ns3ai part"
    cd "../ns-allinone-${NS3_VERSION}/ns-${NS3_VERSION}"
    
    if [ -d "contrib/ai" ]; then
        log_warning "NS3-AI directory already exists, removing old version..."
        sudo rm -rf contrib/ai
    fi
    
    log_info "Cloning NS3-AI repository..."
    git clone "$NS3AI_REPO" contrib/ai
    log_success "NS3-AI repository cloned successfully"
    
    # There is a problem with the protocol buffer.
    # The protobuf package does not ship with CMake support.
    # But the code takes care of that. Do not worry about the warning regarding protobuf.
}

# Function to install TensorFlow C library
install_tensorflow() {
    log_info "Installing TensorFlow C library..."
    
    # Determine which TensorFlow version to use based on GPU availability
    gpu_status=$(check_nvidia_gpu; echo $?)
    
    if [ $gpu_status -eq 0 ]; then
        log_info "Using GPU-enabled TensorFlow"
        TENSORFLOW_FILENAME="$TENSORFLOW_GPU_FILENAME"
        TENSORFLOW_URL="$TENSORFLOW_GPU_URL"
    else
        log_info "Using CPU-only TensorFlow (no NVIDIA GPU detected or CUDA not available)"
        TENSORFLOW_FILENAME="$TENSORFLOW_CPU_FILENAME"
        TENSORFLOW_URL="$TENSORFLOW_CPU_URL"
    fi
    
    # Need to get libtensorflow and libtorch
    # Make sure to include correct links depending on the hardware
    # It is very important to get the correct version of libtorch and libtensorflow

    # Need to install tensorflow c library
    # this takes some work around
    # What the problem was is that the ns3ai was looking for tensorflow in a specific directory.
    # But the tensorflow library was not installed in that directory by default.
    # So we need to install the tensorflow library in the directory where ns3ai is looking for it.
    
    mkdir -p contrib/ai/model/libtensorflow
    
    if [ -f "$TENSORFLOW_FILENAME" ]; then
        log_info "TensorFlow archive already exists, skipping download"
    else
        log_info "Downloading TensorFlow ${TENSORFLOW_VERSION} ($([ $gpu_status -eq 0 ] && echo "GPU" || echo "CPU") version)..."
        wget -q --no-check-certificate "$TENSORFLOW_URL"
    fi
    
    log_info "Extracting TensorFlow library..."
    sudo tar -C contrib/ai/model/libtensorflow -xzf "$TENSORFLOW_FILENAME"
    log_success "TensorFlow C library installed successfully"
}


# Function to install PyTorch C library
install_pytorch() {
    log_info "Installing PyTorch C library..."
    
    # Need to install pytorch c library just like tensorflow
    # The installation file makes libtorch directory by itself, so drop the mkdir command
    # mkdir -p contrib/ai/model/libtorch
    # There was one last script that was not working.
    # It was due to libtorch not finding python 3.12 or something like that.
    # We are now using CPU version of libtorch for now, which works.
    # There may be a way around using specific CUDA version mentioned in libtorch.
    
    if [ -f "libtorch.zip" ]; then
        log_info "LibTorch archive already exists, skipping download"
    else
        log_info "Downloading LibTorch ${LIBTORCH_VERSION} (CPU version)..."
        wget "$LIBTORCH_URL" -O libtorch.zip
        # wget https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.5.1%2Bcpu.zip -O libtorch.zip
    fi
    
    log_info "Extracting LibTorch..."
    unzip libtorch.zip -d contrib/ai/model
    log_success "PyTorch C library installed successfully"
}

# Function to fix LibTorch linking issues
fix_libtorch_linking() {
    log_info "Fixing LibTorch linking issues (excluding problematic libtorch_python.so)..."
    
    cd contrib/ai
    
    # Create backup of original CMakeLists.txt
    cp CMakeLists.txt CMakeLists.txt.backup
    
    # Replace the file glob with specific essential libraries to avoid Python compatibility issues
    sed -i 's/file(GLOB Torch_LIBRARIES "${Libtorch_LIBRARY_DIR}\/\*\.so" "${Libtorch_LIBRARY_DIR}\/\*\.dylib")/set(Torch_LIBRARIES\n            "${Libtorch_LIBRARY_DIR}\/libtorch.so"\n            "${Libtorch_LIBRARY_DIR}\/libtorch_cpu.so"\n            "${Libtorch_LIBRARY_DIR}\/libc10.so"\n            "${Libtorch_LIBRARY_DIR}\/libshm.so"\n            "${Libtorch_LIBRARY_DIR}\/libtorch_global_deps.so"\n        )/' CMakeLists.txt
    
    cd ../..
    
    log_success "LibTorch linking configuration fixed"
    log_warning "Excluded libtorch_python.so to avoid Python 3.12 compatibility issues"
}


# Function to install Python NS3-AI packages
install_python_ns3ai_packages() {
    log_info "Installing Python NS3-AI packages..."
    
    pip install -e contrib/ai/python_utils
    pip install -e contrib/ai/model/gym-interface/py
    
    log_success "Python NS3-AI packages installed successfully"
}



# Function to configure NS3 with AI support
configure_ns3_ai() {
    local venv_name="$1"
    
    log_info "Configuring NS3 with AI support..."
    log_warning "This may show warnings about protobuf - these can be ignored"
    
    # Configure and build again
    # Apparently there is a problem with the protobuf library.
    # The protobuf could not be found, so we added the path to the protobuf library.
    # We have checked the protobuf thing. It has built-in moves to ensure that protobuf is on
    # Unless there is an error, or some execution fails, we will not worry about it.
    ./ns3 configure --enable-examples --enable-tests -- \
      -DNS3_PYTHON_BINDINGS=ON \
      -DPython3_EXECUTABLE="../../$venv_name/bin/python" \
      -DNS3_BINDINGS_INSTALL_DIR="../../$venv_name/lib/python${PYTHON_VERSION}/site-packages" \
      -DPython3_LIBRARY="/usr/lib/x86_64-linux-gnu/libpython${PYTHON_VERSION}.so" \
      -DProtobuf_LIBRARY="/usr/lib/x86_64-linux-gnu/libprotobuf.so" \
      -DProtobuf_INCLUDE_DIRS="/usr/include" \
      -DProtobuf_DIR="/usr/lib/x86_64-linux-gnu/cmake/protobuf"
    
    log_success "NS3 AI configuration completed"
}


# Function to fix burst-sink header and build
fix_and_build() {
    log_info "Fixing burst-sink.h header issue..."
    
    # While building for the first time, it will fail for the 'burst-sink.h'
    # Open and edit it>>#include <map>
    # gedit contrib/ai/examples/multi-bss/vr-app/model/burst-sink.h
    # Then run the build multiple times. It will come down to the last error.
    
    sed -i '33i #include <map>' contrib/ai/examples/multi-bss/vr-app/model/burst-sink.h
    log_success "Fixed burst-sink.h header"
    
    log_info "Building NS3 with AI support..."
    ./ns3 build
    log_success "NS3 AI build completed successfully"
}


# Function to build all NS3-AI examples
build_all_examples() {
    log_info "Building all NS3-AI examples..."
    
    # Define all example targets
    local all_examples=(
        "ns3ai_apb_gym"
        "ns3ai_apb_msg_stru" 
        "ns3ai_apb_msg_vec"
        "ns3ai_multibss"
        "ns3ai_rltcp_gym"
        "ns3ai_rltcp_msg"
        "ns3ai_ratecontrol_constant"
        "ns3ai_ratecontrol_ts"
        "ns3ai_ltecqi_msg"
    )
    
    # build all examples in all versions
    log_info "Building all examples in batch..."
    ./ns3 build "${all_examples[@]}"
    
    log_success "All examples built in batch"
}

# Function to build individual examples with documentation
build_individual_examples() {
    log_info "Building individual examples with detailed documentation..."
    
    # build A-Plus-B example
    log_info "Building A-Plus-B examples..."
    # with Gym interface
    log_info "  - Building A-Plus-B with Gym interface..."
    ./ns3 build ns3ai_apb_gym
    # with Message interface - struct based
    log_info "  - Building A-Plus-B with Message interface (struct-based)..."
    ./ns3 build ns3ai_apb_msg_stru
    # with Message interface - vector based
    log_info "  - Building A-Plus-B with Message interface (vector-based)..."
    ./ns3 build ns3ai_apb_msg_vec
    
    # build Multi-BSS example
    log_info "Building Multi-BSS example..."
    # with Message interface - vector based
    log_info "  - Building Multi-BSS with Message interface (vector-based)..."
    ./ns3 build ns3ai_multibss
    
    # build RL-TCP example
    log_info "Building RL-TCP examples..."
    # with Gym interface
    log_info "  - Building RL-TCP with Gym interface..."
    ./ns3 build ns3ai_rltcp_gym
    # with Message interface - struct based
    log_info "  - Building RL-TCP with Message interface (struct-based)..."
    ./ns3 build ns3ai_rltcp_msg
    
    # build Rate-Control examples
    log_info "Building Rate-Control examples..."
    # constant rate example, with Message interface - struct based
    log_info "  - Building Rate-Control constant rate with Message interface (struct-based)..."
    ./ns3 build ns3ai_ratecontrol_constant
    # Thompson Sampling example, with Message interface - struct based
    log_info "  - Building Rate-Control Thompson Sampling with Message interface (struct-based)..."
    ./ns3 build ns3ai_ratecontrol_ts
    
    # build LTE-CQI example
    log_info "Building LTE-CQI example..."
    # with Message interface - struct based
    log_info "  - Building LTE-CQI with Message interface (struct-based)..."
    ./ns3 build ns3ai_ltecqi_msg
    
    log_success "All individual examples built successfully"
}

# Main execution
main() {
    log_info "Starting NS3-AI installation script..."
    
    # Validate and activate virtual environment
    VENV_NAME=$(validate_venv)
    activate_venv "$VENV_NAME"
    
    # Setup environment variables
    setup_environment
    
    # Check for NVIDIA GPU and install CUDA support if available
    install_cuda_support
    
    # Clone NS3-AI repository
    clone_ns3ai
    
    # Install TensorFlow C library (CPU or GPU version based on hardware)
    install_tensorflow
    
    # Install PyTorch C library
    install_pytorch
    
    # Fix LibTorch linking issues
    fix_libtorch_linking
    
    # Install Python NS3-AI packages
    install_python_ns3ai_packages
    
    # Configure NS3 with AI support
    configure_ns3_ai "$VENV_NAME"
    
    # Fix header issue and build
    fix_and_build
    
    # Build all examples
    build_all_examples
    
    # Build individual examples with documentation
    build_individual_examples
    
    log_success "NS3-AI installation completed successfully!"
    log_info "All NS3-AI examples have been built and are ready to use"
    log_warning "Remember: Multi-BSS example has known issues with MaxSlrc and MaxSsrc (burst option omitted)"
    
    # Display final hardware configuration info
    gpu_status=$(check_nvidia_gpu; echo $?)
    if [ $gpu_status -eq 0 ]; then
        log_info "Installation completed with GPU support enabled"
    else
        log_info "Installation completed with CPU-only support (no NVIDIA GPU detected)"
    fi
}

# Run main function
main "$@"
