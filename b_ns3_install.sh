#!/bin/bash
# NS3 Installation Script
# This script install ns3 only.
# It first install basic ns3 and runs all tests and examples.
# Then it does the same using python bindings.
# Finally it goes back to the root directory.

set -e  # Exit on any error

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NS3_VERSION="3.44"
NS3_ARCHIVE="ns-allinone-${NS3_VERSION}.tar.bz2"
NS3_URL="https://www.nsnam.org/releases/${NS3_ARCHIVE}"
PYTHON_VERSION="3.11"
VENV_FILE="venv_name.txt"

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

    if [ ! -d "$venv_path" ]; then
        log_error "Virtual environment '$venv_name' does not exist."
        log_info "🚀 Creating virtual environment '$venv_name'..."
        python3.11 -m venv "$venv_path"
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


# Function to download and extract NS3
download_ns3() {
    local archive_path="../$NS3_ARCHIVE"
    
    if [ -f "$archive_path" ]; then
        log_info "NS3 archive already exists, skipping download"
    else
        log_info "Downloading NS3 ${NS3_VERSION}..."
        wget "$NS3_URL" -O "$archive_path"
        log_success "NS3 ${NS3_VERSION} downloaded successfully"
    fi

    if [ -d "../ns-allinone-${NS3_VERSION}" ]; then
        log_warning "NS3 directory already exists, removing old version..."
        rm -rf "../ns-allinone-${NS3_VERSION}"
    fi

    log_info "Extracting NS3 archive..."
    tar xfj "$archive_path" -C ../
    log_success "NS3 archive extracted successfully"
}

# Function to run example programs
run_examples() {
    local stage="$1"
    log_info "Running example programs (${stage})..."
    
    local examples=(
        "first.cc"
        "second.cc"
        "third.cc"
        "fourth.cc"
        "fifth.cc"
        "sixth.cc"
    )

    for example in "${examples[@]}"; do
        log_info "Running example: $example"
        if ./ns3 run "$example"; then
            log_success "Example $example completed successfully"
        else
            log_error "Example $example failed"
            return 1
        fi
    done

    log_success "All examples ran successfully (${stage})"
}


# Function to configure NS3 basic installation
configure_basic_ns3() {
    log_info "Configuring NS3 with examples and tests..."
    ./ns3 configure --enable-examples --enable-tests
    log_success "NS3 basic configuration completed"
}

# Function to configure NS3 with Python bindings
configure_python_ns3() {
    local venv_name="$1"
    
    log_info "Configuring NS3 with Python bindings..."
    log_warning "There will be warnings about uninitialized values; let's not worry about that for now."
    
    # We now configure the ns3 with the python bindings. This is a must.
    ./ns3 configure --enable-examples --enable-tests -- \
      -DNS3_PYTHON_BINDINGS=ON \
      -DPython3_EXECUTABLE="${SCRIPT_DIR}/../$venv_name/bin/python" \
      -DNS3_BINDINGS_INSTALL_DIR="${SCRIPT_DIR}/../$venv_name/lib/python${PYTHON_VERSION}/site-packages"
    
    log_success "NS3 Python bindings configuration completed"
}

# Function to build NS3
build_ns3() {
    log_info "Building NS3..."
    ./ns3 build
    log_success "NS3 build completed successfully"
}

# Function to cleanup temporary files
cleanup() {
    local archive_path="../$NS3_ARCHIVE"
    
    if [ -f "$archive_path" ]; then
        log_info "Cleaning up temporary files..."
        rm "$archive_path"
        log_success "Cleanup completed"
    fi
}

# Main execution
main() {
    log_info "Starting NS3 installation script..."
    
    # Validate and activate virtual environment
    VENV_NAME=$(validate_venv)
    activate_venv "$VENV_NAME"
    
    # Download and extract NS3
    download_ns3
    
    # Navigate to NS3 directory
    cd "../ns-allinone-${NS3_VERSION}/ns-${NS3_VERSION}"
    
    # Stage 1: Basic NS3 installation
    log_info "=== Stage 1: Basic NS3 Installation ==="
    configure_basic_ns3
    run_examples "basic installation"
    
    # Stage 2: NS3 with Python bindings
    log_info "=== Stage 2: NS3 with Python Bindings ==="
    configure_python_ns3 "$VENV_NAME"
    build_ns3
    # Check if everything is ok. Consult copilot if necessary.
    # Lets run the example scripts again
    # ./test.py
    run_examples "with Python bindings"
    
    # Go back to the root directory
    cd "../../founding-scripts"
    
    # Cleanup
    cleanup
    
    log_success "NS3 installation completed successfully!"
    log_info "NS3 ${NS3_VERSION} is now installed with Python bindings"
}

# Run main function
main "$@"
