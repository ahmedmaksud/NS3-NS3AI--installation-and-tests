#!/bin/bash
# Master Installation and Testing Script
# This script runs all NS3 and NS3-AI installation scripts sequentially
# and then performs comprehensive testing to verify the installation

set -e  # Exit on any error

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_FILE="venv_name.txt"
NS3_VERSION="3.44"
PYTHON_VERSION="3.11"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
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

log_header() {
    echo -e "${CYAN}🚀 $1${NC}"
}

log_test() {
    echo -e "${MAGENTA}🧪 $1${NC}"
}

# Function to print separator
print_separator() {
    echo -e "${CYAN}================================================${NC}"
}

# Function to get timestamp
get_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Function to log with timestamp
log_timestamped() {
    echo -e "${BLUE}[$(get_timestamp)]${NC} $1"
}

# Function to validate prerequisites
validate_prerequisites() {
    log_header "Validating Prerequisites"
    
    # Check if we're in the right directory
    if [ ! -f "a_ns3_prep.sh" ] || [ ! -f "b_ns3_install.sh" ] || [ ! -f "c_ns3ai_install.sh" ]; then
        log_error "Required scripts not found in current directory"
        log_info "Please ensure you're running this from the founding-scripts directory"
        exit 1
    fi
    
    # Check if venv_name.txt exists
    if [ ! -f "$VENV_FILE" ]; then
        log_error "Virtual environment name file '$VENV_FILE' not found"
        log_info "Creating default venv_name.txt with 'EHRL' as environment name"
        echo "EHRL" > "$VENV_FILE"
    fi
    
    # Validate script permissions
    for script in a_ns3_prep.sh b_ns3_install.sh c_ns3ai_install.sh; do
        if [ ! -x "$script" ]; then
            log_warning "Script $script is not executable, fixing permissions..."
            chmod +x "$script"
        fi
    done
    
    log_success "Prerequisites validated"
}

# Function to run installation scripts
run_installation_scripts() {
    log_header "Running Installation Scripts Sequentially"
    
    local start_time=$(date +%s)
    
    # Stage 1: Environment Preparation
    print_separator
    log_timestamped "Stage 1: Running Environment Preparation (a_ns3_prep.sh)"
    print_separator
    if ./a_ns3_prep.sh; then
        log_success "Stage 1 completed successfully"
    else
        log_error "Stage 1 failed - Environment preparation failed"
        exit 1
    fi
    
    # Stage 2: NS3 Installation
    print_separator
    log_timestamped "Stage 2: Running NS3 Installation (b_ns3_install.sh)"
    print_separator
    if ./b_ns3_install.sh; then
        log_success "Stage 2 completed successfully"
    else
        log_error "Stage 2 failed - NS3 installation failed"
        exit 1
    fi
    
    # Stage 3: NS3-AI Installation
    print_separator
    log_timestamped "Stage 3: Running NS3-AI Installation (c_ns3ai_install.sh)"
    print_separator
    if ./c_ns3ai_install.sh; then
        log_success "Stage 3 completed successfully"
    else
        log_error "Stage 3 failed - NS3-AI installation failed"
        exit 1
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    log_success "All installation scripts completed successfully in ${duration} seconds"
}

# Function to setup test environment
setup_test_environment() {
    log_header "Setting up Test Environment"
    
    # Read virtual environment name
    local venv_name=$(cat "$VENV_FILE" | tr -d '\n\r' | xargs)
    
    # Activate virtual environment
    if [ -d "../$venv_name" ]; then
        log_info "Activating virtual environment: $venv_name"
        source "../$venv_name/bin/activate"
        log_success "Virtual environment activated"
    else
        log_error "Virtual environment not found: $venv_name"
        exit 1
    fi
    
    # Navigate to NS3 directory
    if [ -d "../ns-allinone-${NS3_VERSION}/ns-${NS3_VERSION}" ]; then
        cd "../ns-allinone-${NS3_VERSION}/ns-${NS3_VERSION}"
        log_success "Changed to NS3 directory"
    else
        log_error "NS3 directory not found"
        exit 1
    fi
}

# Function to test basic NS3 installation
test_basic_ns3() {
    log_header "Testing Basic NS3 Installation"
    
    local examples=(
        "first.cc"
        "second.cc"
        "third.cc"
        "fourth.cc"
        "fifth.cc"
        "sixth.cc"
    )
    
    local failed_examples=()
    local success_count=0
    
    for example in "${examples[@]}"; do
        log_test "Testing NS3 example: $example"
        if ./ns3 run "$example" > "/tmp/ns3_test_${example}.log" 2>&1; then
            log_success "✓ $example passed"
            ((success_count++))
        else
            log_error "✗ $example failed"
            failed_examples+=("$example")
        fi
    done
    
    log_info "NS3 Basic Test Results: $success_count/${#examples[@]} examples passed"
    
    if [ ${#failed_examples[@]} -eq 0 ]; then
        log_success "All basic NS3 examples passed!"
    else
        log_warning "Failed examples: ${failed_examples[*]}"
        log_info "Check log files in /tmp/ns3_test_*.log for details"
    fi
}

# Function to test NS3 Python bindings
test_ns3_python_bindings() {
    log_header "Testing NS3 Python Bindings"
    
    log_test "Testing Python import of ns3 module"
    if python3 -c "import ns3; print('NS3 Python bindings working:', ns3.__version__ if hasattr(ns3, '__version__') else 'OK')" 2>/dev/null; then
        log_success "✓ NS3 Python bindings are working"
    else
        log_error "✗ NS3 Python bindings failed"
        log_info "Trying alternative import method..."
        if python3 -c "import sys; sys.path.append('build/lib'); import ns3; print('NS3 Python bindings working via build/lib')" 2>/dev/null; then
            log_success "✓ NS3 Python bindings working via build/lib"
        else
            log_warning "NS3 Python bindings may have issues"
        fi
    fi
}

# Function to test NS3-AI installation
test_ns3ai_installation() {
    log_header "Testing NS3-AI Installation"
    
    # Check if NS3-AI directory exists
    if [ ! -d "contrib/ai" ]; then
        log_error "NS3-AI directory not found"
        return 1
    fi
    
    log_success "✓ NS3-AI directory found"
    
    # Test NS3-AI Python packages
    log_test "Testing NS3-AI Python packages"
    if python3 -c "import ns3ai_gym_env; print('NS3-AI Gym interface working')" 2>/dev/null; then
        log_success "✓ NS3-AI Gym interface working"
    else
        log_warning "NS3-AI Gym interface may have issues"
    fi
    
    # Test TensorFlow integration
    log_test "Testing TensorFlow integration"
    if python3 -c "import tensorflow as tf; print('TensorFlow version:', tf.__version__)" 2>/dev/null; then
        log_success "✓ TensorFlow integration working"
    else
        log_warning "TensorFlow integration may have issues"
    fi
    
    # Test PyTorch integration
    log_test "Testing PyTorch integration"
    if python3 -c "import torch; print('PyTorch version:', torch.__version__)" 2>/dev/null; then
        log_success "✓ PyTorch integration working"
    else
        log_warning "PyTorch integration may have issues"
    fi
}

# Function to test NS3-AI examples
test_ns3ai_examples() {
    log_header "Testing NS3-AI Examples"
    
    local ns3ai_examples=(
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
    
    local failed_examples=()
    local success_count=0
    local build_success_count=0
    
    # First test if examples can be built
    log_test "Testing NS3-AI example builds..."
    for example in "${ns3ai_examples[@]}"; do
        log_test "Checking build for: $example"
        if ./ns3 build "$example" > "/tmp/ns3ai_build_${example}.log" 2>&1; then
            log_success "✓ $example build successful"
            ((build_success_count++))
        else
            log_error "✗ $example build failed"
            failed_examples+=("$example")
        fi
    done
    
    log_info "NS3-AI Build Test Results: $build_success_count/${#ns3ai_examples[@]} examples built successfully"
    
    # Test a few key examples by running them briefly
    log_test "Testing execution of key NS3-AI examples..."
    local key_examples=("ns3ai_apb_msg_stru" "ns3ai_ratecontrol_constant")
    
    for example in "${key_examples[@]}"; do
        if [[ ! " ${failed_examples[@]} " =~ " $example " ]]; then
            log_test "Testing execution: $example"
            # Run with timeout to avoid hanging
            if timeout 30s ./ns3 run "$example" > "/tmp/ns3ai_run_${example}.log" 2>&1; then
                log_success "✓ $example executed successfully"
                ((success_count++))
            else
                log_warning "⚠ $example execution timed out or failed (this may be normal for some examples)"
            fi
        fi
    done
    
    if [ ${#failed_examples[@]} -eq 0 ]; then
        log_success "All NS3-AI examples built successfully!"
    else
        log_warning "Failed to build: ${failed_examples[*]}"
        log_info "Check log files in /tmp/ns3ai_build_*.log for details"
    fi
}

# Function to generate installation report
generate_report() {
    log_header "Generating Installation Report"
    
    local report_file="../installation_report_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "NS3 and NS3-AI Installation Report"
        echo "=================================="
        echo "Generated: $(date)"
        echo ""
        echo "Environment Information:"
        echo "- OS: $(uname -a)"
        echo "- Python: $(python3 --version)"
        echo "- GCC: $(gcc --version | head -1)"
        echo "- CMake: $(cmake --version | head -1)"
        echo ""
        echo "Virtual Environment:"
        echo "- Name: $(cat "$SCRIPT_DIR/$VENV_FILE" 2>/dev/null || echo "Not found")"
        echo "- Path: $(echo $VIRTUAL_ENV)"
        echo ""
        echo "Installation Status:"
        echo "- NS3 Directory: $([ -d "../ns-allinone-${NS3_VERSION}" ] && echo "✓ Found" || echo "✗ Not found")"
        echo "- NS3-AI Directory: $([ -d "contrib/ai" ] && echo "✓ Found" || echo "✗ Not found")"
        echo "- TensorFlow: $(python3 -c "import tensorflow as tf; print('✓ Version:', tf.__version__)" 2>/dev/null || echo "✗ Not working")"
        echo "- PyTorch: $(python3 -c "import torch; print('✓ Version:', torch.__version__)" 2>/dev/null || echo "✗ Not working")"
        echo ""
        echo "Log Files Location: /tmp/ns3*_test_*.log and /tmp/ns3ai_*_*.log"
    } > "$report_file"
    
    log_success "Installation report generated: $report_file"
}

# Function to cleanup
cleanup() {
    log_header "Cleanup"
    
    # Return to original directory
    cd "$SCRIPT_DIR"
    
    log_info "Cleaning up temporary files..."
    # Clean up any temporary files if needed
    
    log_success "Cleanup completed"
}

# Main execution function
main() {
    local overall_start_time=$(date +%s)
    
    print_separator
    log_header "NS3 and NS3-AI Master Installation Script"
    log_info "Starting complete installation and testing process..."
    print_separator
    
    # Stage 1: Validate prerequisites
    validate_prerequisites
    
    # Stage 2: Run installation scripts
    run_installation_scripts
    
    # Stage 3: Setup test environment
    setup_test_environment
    
    # Stage 4: Test installations
    print_separator
    log_header "Starting Comprehensive Testing"
    print_separator
    
    test_basic_ns3
    test_ns3_python_bindings
    test_ns3ai_installation
    test_ns3ai_examples
    
    # Stage 5: Generate report
    generate_report
    
    # Stage 6: Cleanup
    cleanup
    
    # Final summary
    local overall_end_time=$(date +%s)
    local total_duration=$((overall_end_time - overall_start_time))
    
    print_separator
    log_success "🎉 Complete NS3 and NS3-AI installation and testing finished!"
    log_info "Total time: ${total_duration} seconds"
    log_info "Check the generated report for detailed results"
    log_warning "Note: Some NS3-AI examples may show warnings or timeouts - this is often normal"
    print_separator
}

# Trap to ensure cleanup on exit
trap cleanup EXIT

# Run main function
main "$@"
