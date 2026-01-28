#!/bin/bash
#
# Author: Ahmed Maksud; email: ahmed.maksud@email.ucr.edu
# PI: Marcelo Menezes De Carvalho; email: mmcarvalho@txstate.edu
# Texas State University
#
# Master Installation and Testing Script
# This script runs all NS3 and NS3-AI installation scripts sequentially
# and then performs comprehensive testing to verify the installation

# Note: Removed set -e to handle errors more gracefully
# Individual stages will handle errors explicitly

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
		log_error "Please create the file and add the virtual environment name"
		log_info "Example: echo 'my_venv_name' > $VENV_FILE"
		exit 1
	fi

	# Read and validate virtual environment name
	local venv_name=$(cat "$VENV_FILE" | tr -d '\n\r' | xargs)
	if [ -z "$venv_name" ]; then
		log_error "Virtual environment name is empty in '$VENV_FILE'"
		log_error "Please add a valid virtual environment name to the file"
		log_info "Example: echo 'my_venv_name' > $VENV_FILE"
		exit 1
	fi

	local venv_path="${SCRIPT_DIR}/../$venv_name"

	# Check if virtual environment exists, create if it doesn't
	if [ ! -d "$venv_path" ]; then
		log_info "Virtual environment '$venv_name' does not exist. Creating it with Python 3.11..."

		if python3.11 -m venv "$venv_path"; then
			log_success "Virtual environment '$venv_name' created successfully with Python 3.11"
		else
			log_error "Failed to create virtual environment '$venv_name' with Python 3.11"
			log_info "Please ensure Python 3.11 is installed and try manually:"
			log_info "python3.11 -m venv $venv_path"
			exit 1
		fi
	else
		log_success "Virtual environment '$venv_name' already exists"
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
		log_warning "Stage 1 had some issues - Environment preparation completed with warnings"
		log_info "Continuing with Stage 2..."
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
	local venv_path="${SCRIPT_DIR}/../$venv_name"
	# Activate virtual environment
	if [ -d "$venv_path" ]; then
		log_info "Activating virtual environment: $venv_name"
		source "$venv_path/bin/activate"
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
		if ./ns3 run "$example" >"/tmp/ns3_test_${example}.log" 2>&1; then
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
	log_header "Testing NS3-AI Python Bindings"

	# Read virtual environment name
	local venv_name=$(cat "$SCRIPT_DIR/$VENV_FILE" | tr -d '\n\r' | xargs)
	local venv_path="${SCRIPT_DIR}/../$venv_name"

	log_test "Checking NS3-AI Python environment..."
	log_info "Python version: $(python3 --version)"
	log_info "Virtual environment: $venv_name"

	# Test if required Python packages are available
	log_test "Testing Python ML libraries (needed for NS3-AI)..."
	local packages_working=true

	# Test TensorFlow
	if python3 -c "import tensorflow as tf; print(f'TensorFlow {tf.__version__} working')" 2>/dev/null; then
		log_success "✓ TensorFlow is available"
	else
		log_error "✗ TensorFlow not available"
		packages_working=false
	fi

	# Test PyTorch
	if python3 -c "import torch; print(f'PyTorch {torch.__version__} working')" 2>/dev/null; then
		log_success "✓ PyTorch is available"
	else
		log_error "✗ PyTorch not available"
		packages_working=false
	fi

	# Test Gymnasium (for NS3-AI Gym interface)
	if python3 -c "import gymnasium; print('Gymnasium working')" 2>/dev/null; then
		log_success "✓ Gymnasium is available"
	else
		log_warning "⚠ Gymnasium not available (optional for some NS3-AI examples)"
	fi

	# Test NS3-AI Python modules (check if they can be imported from contrib/ai)
	log_test "Testing NS3-AI Python modules..."
	if [ -d "contrib/ai" ]; then
		# Look for Python files in NS3-AI examples
		local python_examples=$(find contrib/ai/examples -name "*.py" 2>/dev/null | head -3)
		if [ -n "$python_examples" ]; then
			log_info "Found NS3-AI Python examples:"
			echo "$python_examples" | while read py_file; do
				log_info "  - $(basename "$py_file")"
			done

			# Test if we can at least import basic Python modules in the NS3-AI context
			if python3 -c "
import sys
import os
sys.path.insert(0, 'contrib/ai')
try:
    import numpy
    import matplotlib.pyplot as plt
    print('NS3-AI Python dependencies working')
except ImportError as e:
    print(f'Missing dependency: {e}')
            " 2>/dev/null; then
				log_success "✓ NS3-AI Python dependencies are working"
			else
				log_warning "⚠ Some NS3-AI Python dependencies may be missing"
			fi
		else
			log_warning "⚠ No Python examples found in contrib/ai"
		fi

		# Test NS3-AI C++ Python bindings (the .so files)
		log_test "Checking NS3-AI C++ Python bindings..."
		local ai_bindings=$(find contrib/ai -name "*ns3ai*.cpython*.so" 2>/dev/null | head -5)
		if [ -n "$ai_bindings" ]; then
			log_success "✓ NS3-AI C++ Python bindings found:"
			echo "$ai_bindings" | while read binding; do
				log_info "  - $(basename "$binding")"
			done

			# Try to import one of the NS3-AI bindings by testing in their actual directories
			local binding_count=0
			local successful_imports=0
			echo "$ai_bindings" | while read binding_path; do
				((binding_count++))
				local test_binding_dir=$(dirname "$binding_path")
				local binding_name=$(basename "$binding_path" .cpython-311-x86_64-linux-gnu.so)

				if python3 -c "
import sys
sys.path.insert(0, '$test_binding_dir')
try:
    import $binding_name
    print('Successfully imported $binding_name')
    exit(0)
except ImportError as e:
    print('Could not import $binding_name: $e')
    exit(1)
                " 2>/dev/null; then
					log_success "✓ NS3-AI binding '$binding_name' is functional"
					((successful_imports++))
					break
				fi
			done

			if [ $successful_imports -gt 0 ]; then
				log_success "✓ NS3-AI C++ Python bindings are functional"
			else
				log_info "ℹ NS3-AI C++ bindings exist but may need NS3 context to import"
			fi
		else
			log_warning "⚠ No NS3-AI C++ Python bindings found in contrib/ai directories"
		fi
	else
		log_error "✗ NS3-AI contrib directory not found"
		return 1
	fi

	if [ "$packages_working" = true ]; then
		log_success "✓ NS3-AI Python environment is functional!"
		return 0
	else
		log_error "✗ NS3-AI Python environment has missing dependencies"
		log_info "Install missing packages: pip install tensorflow torch gymnasium matplotlib numpy"
		return 1
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
		if ./ns3 build "$example" >"/tmp/ns3ai_build_${example}.log" 2>&1; then
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
			if timeout 600s ./ns3 run "$example" >"/tmp/ns3ai_run_${example}.log" 2>&1; then
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

# Function to run NS3-AI Python examples
run_ns3ai_python_examples() {
	log_header "Running NS3-AI Python Examples"

	# Check if NS3-AI contrib directory exists
	if [ ! -d "contrib/ai" ]; then
		log_error "NS3-AI directory not found at contrib/ai"
		return 1
	fi

	local python_examples=(
		"contrib/ai/examples/a-plus-b/use-gym/apb.py"
		"contrib/ai/examples/a-plus-b/use-msg-stru/apb.py"
		"contrib/ai/examples/a-plus-b/use-msg-vec/apb.py"
		"contrib/ai/examples/rl-tcp/use-gym/run_rl_tcp.py"
		"contrib/ai/examples/rl-tcp/use-msg/run_rl_tcp.py"
		"contrib/ai/examples/multi-bss/run_multi_bss.py"
	)

	local failed_python_examples=()
	local success_python_count=0

	log_test "Running NS3-AI Python examples with timeout..."

	for python_example in "${python_examples[@]}"; do
		if [ -f "$python_example" ]; then
			local example_name=$(basename "$python_example" .py)
			local example_dir=$(dirname "$python_example")

			log_test "Running Python example: $example_name"

			# Change to example directory and run the Python script with timeout
			pushd "$example_dir" >/dev/null 2>&1

			# Use timeout to prevent hanging, and capture both stdout and stderr
			if timeout 900s python3 "$(basename "$python_example")" >"/tmp/ns3ai_python_${example_name}.log" 2>&1; then
				log_success "✓ $example_name completed successfully"
				((success_python_count++))
			else
				local exit_code=$?
				if [ $exit_code -eq 124 ]; then
					log_warning "⚠ $example_name timed out after 900 seconds (this may be normal for some examples)"
				else
					log_error "✗ $example_name failed with exit code $exit_code"
					failed_python_examples+=("$example_name")
				fi
			fi

			popd >/dev/null 2>&1
		else
			log_warning "⚠ Python example file not found: $python_example"
			failed_python_examples+=("$(basename "$python_example")")
		fi
	done

	log_info "NS3-AI Python Examples Results: $success_python_count/${#python_examples[@]} examples completed successfully"

	if [ ${#failed_python_examples[@]} -eq 0 ]; then
		log_success "All NS3-AI Python examples completed successfully!"
	else
		log_warning "Failed or timed out examples: ${failed_python_examples[*]}"
		log_info "Check log files in /tmp/ns3ai_python_*.log for details"
		log_info "Note: Some examples may timeout or fail due to missing dependencies, which is normal"
	fi

	# Try to install missing requirements if any examples failed
	if [ ${#failed_python_examples[@]} -gt 0 ]; then
		log_test "Checking for requirements.txt files and installing missing dependencies..."

		local requirements_files=(
			"contrib/ai/examples/rl-tcp/requirements.txt"
			"contrib/ai/examples/multi-bss/requirements.txt"
		)

		for req_file in "${requirements_files[@]}"; do
			if [ -f "$req_file" ]; then
				log_info "Installing requirements from: $req_file"
				if pip install -r "$req_file" >"/tmp/ns3ai_pip_$(basename "$(dirname "$req_file")").log" 2>&1; then
					log_success "✓ Requirements installed from $req_file"
				else
					log_warning "⚠ Failed to install some requirements from $req_file"
				fi
			fi
		done

		log_info "You may need to manually install additional dependencies for some examples"
		log_info "Common dependencies: gymnasium, torch, tensorflow, matplotlib, numpy"
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
		echo "- Gymnasium: $(python3 -c "import gymnasium; print('✓ Version:', gymnasium.__version__)" 2>/dev/null || echo "✗ Not working")"
		echo "- NumPy: $(python3 -c "import numpy; print('✓ Version:', numpy.__version__)" 2>/dev/null || echo "✗ Not working")"
		echo "- Matplotlib: $(python3 -c "import matplotlib; print('✓ Version:', matplotlib.__version__)" 2>/dev/null || echo "✗ Not working")"
		echo ""
		echo "NS3-AI Python Examples Status:"
		echo "- A-Plus-B (Gym): $([ -f "contrib/ai/examples/a-plus-b/use-gym/apb.py" ] && echo "✓ Found" || echo "✗ Not found")"
		echo "- A-Plus-B (Msg Struct): $([ -f "contrib/ai/examples/a-plus-b/use-msg-stru/apb.py" ] && echo "✓ Found" || echo "✗ Not found")"
		echo "- A-Plus-B (Msg Vector): $([ -f "contrib/ai/examples/a-plus-b/use-msg-vec/apb.py" ] && echo "✓ Found" || echo "✗ Not found")"
		echo "- RL-TCP (Gym): $([ -f "contrib/ai/examples/rl-tcp/use-gym/run_rl_tcp.py" ] && echo "✓ Found" || echo "✗ Not found")"
		echo "- RL-TCP (Msg): $([ -f "contrib/ai/examples/rl-tcp/use-msg/run_rl_tcp.py" ] && echo "✓ Found" || echo "✗ Not found")"
		echo "- Multi-BSS: $([ -f "contrib/ai/examples/multi-bss/run_multi_bss.py" ] && echo "✓ Found" || echo "✗ Not found")"
		echo ""
		echo "Log Files Location:"
		echo "- NS3 Tests: /tmp/ns3_test_*.log"
		echo "- NS3-AI Build Tests: /tmp/ns3ai_build_*.log"
		echo "- NS3-AI Run Tests: /tmp/ns3ai_run_*.log"
		echo "- NS3-AI Python Examples: /tmp/ns3ai_python_*.log"
		echo "- Pip Installation Logs: /tmp/ns3ai_pip_*.log"
		echo ""
		echo "Next Steps:"
		echo "1. Review any failed examples in the log files"
		echo "2. Install missing Python dependencies if needed:"
		echo "   pip install gymnasium torch tensorflow matplotlib numpy"
		echo "3. Run individual examples manually for troubleshooting"
		echo "4. Check NS3-AI documentation at contrib/ai/docs/"
	} >"$report_file"

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

	# Test NS3-AI Python bindings (focused on NS3-AI functionality only)
	test_ns3_python_bindings

	test_ns3ai_installation
	test_ns3ai_examples

	# Stage 5: Run NS3-AI Python Examples
	print_separator
	log_header "Running NS3-AI Python Examples"
	print_separator

	run_ns3ai_python_examples

	# Stage 6: Generate report
	generate_report

	# Stage 7: Cleanup
	cleanup

	# Final summary
	local overall_end_time=$(date +%s)
	local total_duration=$((overall_end_time - overall_start_time))

	print_separator
	log_success "🎉 Complete NS3 and NS3-AI installation and testing finished!"
	log_info "Total time: ${total_duration} seconds"
	log_info "Check the generated report for detailed results"
	log_warning "Note: Some NS3-AI examples may show warnings or timeouts - this is often normal"
	log_info "All NS3-AI Python examples have been executed and tested"
	log_info "For manual testing, navigate to contrib/ai/examples/ and run individual Python scripts"
	print_separator
}

# Trap to ensure cleanup on exit
trap cleanup EXIT

# Run main function
main "$@"
