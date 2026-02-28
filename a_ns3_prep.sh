#!/bin/bash
#
# Author: Ahmed Maksud; email: ahmed.maksud@email.ucr.edu
# PI: Marcelo Menezes De Carvalho; email: mmcarvalho@txstate.edu
# Texas State University
#
# NS3 Environment Preparation Script
# This script checks for all installs in a convenient way.
# This script performs the following tasks:
# 1. Checks if a virtual environment name is provided in the text file.
# 2. Creates or activates the specified Python virtual environment.
# 3. Installs required Python packages (cppyy, cmake-format).
# 4. Defines a list of system dependencies and checks if they are installed.
# 5. Installs any missing system dependencies using `apt`.
# 6. Outputs the version of `qmake` at the end.

# Please note that this whole thing can be done using yaml file.

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_FILE="venv_name.txt"
PYTHON_VERSION="3.11"

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

# Function to validate virtual environment name file
validate_venv_file() {
	if [ ! -f "$VENV_FILE" ]; then
		log_error "Virtual environment name file '$VENV_FILE' not found."
		log_error "Please create the file and add the virtual environment name."
		log_info "Example: echo 'my_venv_name' > $VENV_FILE"
		exit 1
	fi

	VENV_NAME=$(cat "$VENV_FILE" | tr -d '\n\r' | xargs)

	if [ -z "$VENV_NAME" ]; then
		log_error "Virtual environment name is empty in '$VENV_FILE'."
		log_error "Please add a valid virtual environment name to the file."
		log_info "Example: echo 'my_venv_name' > $VENV_FILE"
		exit 1
	fi

	echo "$VENV_NAME"
}

# Function to setup virtual environment
setup_virtual_environment() {
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

	# Check if the virtual environment is already active
	if [ -z "$VIRTUAL_ENV" ] || [ "$VIRTUAL_ENV" != "$(realpath "$venv_path")" ]; then
		log_info "Virtual environment is not active."
		log_info "🔗 Activating virtual environment '$venv_name'..."
		source "$venv_path/bin/activate"
	else
		log_success "Virtual environment '$venv_name' is already active."
	fi
}

# Function to update system
update_system() {
	log_info "Updating system packages..."
	sudo apt update
	sudo apt upgrade -y
	log_success "System update completed"
}

# Function to install Python packages
install_python_packages() {
	log_info "📦 Installing required Python packages..."

	local python_packages=(
		"pip --upgrade"
		"setuptools"
		"wheel"
		"pyyaml"
		"cmake-format"
		"tqdm"
		"pandas"
		"matplotlib"
		"tensorflow==2.18.0"
		"cppyy"
	)

	local failed_python_packages=()

	# Upgrade pip first
	log_info "Installing Python package: pip --upgrade"
	if ! pip install --upgrade pip; then
		log_warning "Failed to upgrade pip, but continuing..."
		failed_python_packages+=("pip")
	fi

	# Install other packages
	for pkg in "${python_packages[@]:1}"; do
		log_info "Installing Python package: $pkg"
		if ! pip install $pkg; then
			echo ""
			echo "🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨"
			echo "❌ PYTHON PACKAGE INSTALLATION FAILED: $pkg"
			echo "🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨"
			echo ""
			failed_python_packages+=("$pkg")
		fi
	done

	# VVI: Install same version of torch as the libtorch.
	log_info "Installing PyTorch (CPU version)..."
	if ! pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu; then
		echo ""
		echo "🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨"
		echo "❌ PYTORCH INSTALLATION FAILED"
		echo "🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨"
		echo ""
		failed_python_packages+=("torch torchvision torchaudio")
	fi

	if [ ${#failed_python_packages[@]} -gt 0 ]; then
		echo ""
		echo "========================================================"
		echo "🚨🚨🚨 PYTHON PACKAGE FAILURES DETECTED 🚨🚨🚨"
		echo "========================================================"
		log_error "Failed to install ${#failed_python_packages[@]} Python packages:"
		for pkg in "${failed_python_packages[@]}"; do
			echo "❌❌❌ FAILED: $pkg ❌❌❌"
		done
		echo "========================================================"
		echo "⚠️  CONTINUING INSTALLATION DESPITE FAILURES ⚠️"
		echo "========================================================"
		log_info "Failed Python packages list saved to: /tmp/ns3_failed_python_packages.txt"
		printf '%s\n' "${failed_python_packages[@]}" >/tmp/ns3_failed_python_packages.txt
		echo ""
	fi

	log_success "Python package installation phase completed"
}

# Function to define system packages
define_system_packages() {
	# List of required packages
	local packages=(
		python3-apt
		gcc git g++ python3 python3-dev python3.11-dev pkg-config sqlite3
		python3-setuptools python3-numpy python3-pygraphviz python3-pip
		mercurial cmake libc6-dev libc6-dev-i386
		gdb valgrind gsl-bin libgsl-dev libgsl27 libgslcblas0
		libsqlite3-dev libxml2 libxml2-dev libgtk-3-dev
		uncrustify doxygen graphviz imagemagick texlive texlive-extra-utils
		texlive-latex-extra texlive-font-utils python3-sphinx dia
		curl asciidoc source-highlight libgtk2.0-0 libgtk2.0-dev
		python3-pybind11
		ninja-build
		# The QT5 gives a lot of troubles. To go around we install them in parts.
		qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools
		libdpdk-dev
		libprotobuf-dev protobuf-compiler
		pybind11-dev
		libabsl-dev
		libclang-dev llvm-dev
		gir1.2-goocanvas-2.0 python3-gi python3-gi-cairo gir1.2-gtk-3.0 ipython3
		tcpdump wireshark openmpi-bin openmpi-common openmpi-doc
		libopenmpi-dev texlive dvipng latexmk libeigen3-dev
		lxc-utils lxc-templates vtun uml-utilities ebtables bridge-utils libboost-all-dev
		ccache python3-full
		gedit
		tree
	)
	echo "${packages[@]}"
}

# Function to install system dependencies
install_system_dependencies() {
	local packages=($(define_system_packages))

	log_info "🔍 Checking and installing missing dependencies..."

	sudo apt update

	local failed_packages=()
	local installed_count=0
	local already_installed_count=0

	for pkg in "${packages[@]}"; do
		# Skip comments
		[[ "$pkg" =~ ^#.*$ ]] && continue

		if dpkg -s "$pkg" >/dev/null 2>&1; then
			log_success "$pkg is already installed"
			((already_installed_count++))
		else
			log_info "📦 Installing $pkg..."
			if sudo apt install -y "$pkg"; then
				log_success "Successfully installed $pkg"
				((installed_count++))
			else
				echo ""
				echo "🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨"
				echo "❌ PACKAGE INSTALLATION FAILED: $pkg"
				echo "🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨"
				echo ""
				failed_packages+=("$pkg")
			fi
		fi
	done

	# Summary
	log_success "Installation summary:"
	log_info "  - Already installed: $already_installed_count packages"
	log_info "  - Newly installed: $installed_count packages"

	if [ ${#failed_packages[@]} -gt 0 ]; then
		echo ""
		echo "========================================================"
		echo "🚨🚨🚨 PACKAGE INSTALLATION FAILURES DETECTED 🚨🚨🚨"
		echo "========================================================"
		log_error "Failed to install ${#failed_packages[@]} packages:"
		for pkg in "${failed_packages[@]}"; do
			echo "❌❌❌ FAILED: $pkg ❌❌❌"
		done
		echo "========================================================"
		echo "⚠️  CONTINUING INSTALLATION DESPITE FAILURES ⚠️"
		echo "========================================================"
		log_warning "Some packages failed to install, but continuing..."
		log_info "You may need to install these packages manually later."
		log_info "Failed packages list saved to: /tmp/ns3_failed_packages.txt"
		printf '%s\n' "${failed_packages[@]}" >/tmp/ns3_failed_packages.txt
		echo ""
	fi
}

# Function to verify installation
verify_installation() {
	log_info "Verifying installation..."
	if command -v qmake >/dev/null 2>&1; then
		log_success "All dependencies checked and installed as needed."
		qmake --version
	else
		log_warning "qmake not found. Some QT packages may not be installed properly."
		log_info "This may not prevent NS3 installation from proceeding."
	fi
}

# Main execution function
main() {
	log_info "Starting NS3 environment preparation..."

	# Validate and setup virtual environment
	local venv_name=$(validate_venv_file)
	setup_virtual_environment "$venv_name"

	# Update system
	update_system

	# Install system dependencies first (required for some Python packages like cppyy)
	install_system_dependencies

	# Install Python packages
	install_python_packages

	# Verify installation
	verify_installation

	# Check for any failure summaries
	echo ""
	echo "========================================================"
	echo "🎯 INSTALLATION SUMMARY"
	echo "========================================================"

	if [ -f "/tmp/ns3_failed_python_packages.txt" ] || [ -f "/tmp/ns3_failed_packages.txt" ]; then
		echo "⚠️  SOME PACKAGES FAILED TO INSTALL:"
		if [ -f "/tmp/ns3_failed_python_packages.txt" ]; then
			echo "   📋 Python packages: /tmp/ns3_failed_python_packages.txt"
		fi
		if [ -f "/tmp/ns3_failed_packages.txt" ]; then
			echo "   📋 System packages: /tmp/ns3_failed_packages.txt"
		fi
		echo ""
		echo "🔧 MANUAL INSTALLATION REQUIRED:"
		echo "   Please install the failed packages manually before proceeding"
		echo "   with NS3 compilation."
		echo ""
		log_warning "NS3 environment preparation completed WITH WARNINGS!"
	else
		log_success "NS3 environment preparation completed successfully!"
	fi
	echo "========================================================"
}

# Run main function
main "$@"
