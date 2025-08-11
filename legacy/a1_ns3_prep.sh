#!/bin/bash
# This script checks for all installs in a convenient way.
# This script performs the following tasks:
# 1. Checks if a virtual environment name is provided in the text file.
# 2. Creates or activates the specified Python virtual environment.
# 3. Installs required Python packages (cppyy, cmake-format).
# 4. Defines a list of system dependencies and checks if they are installed.
# 5. Installs any missing system dependencies using `apt`.
# 6. Outputs the version of `qmake` at the end.

# Please note that this whole thing can be done using yaml file.
# But thats something we will do later.


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


sudo apt update
sudo apt upgrade -y


# Install required Python packages
echo "📦 Installing required Python packages..."
pip install --upgrade pip
pip install cppyy
pip install cmake-format
pip install setuptools
pip install wheel
pip install pyyaml
# VVI: Install same version of torch as the libtorch.
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
# VVI: The python tensorflow version has to match the C (libtensorflow) version.
pip install tensorflow==2.18.0
pip install matplotlib
pip install pandas tqdm

# List of required packages
packages=(
    python3-apt
    gcc git g++ python3 python3-dev pkg-config sqlite3
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
    gir1.2-goocanvas-2.0 python3-gi python3-gi-cairo gir1.2-gtk-3.0 ipython3
    tcpdump wireshark openmpi-bin openmpi-common openmpi-doc
    libopenmpi-dev texlive dvipng latexmk libeigen3-dev
    lxc-utils lxc-templates vtun uml-utilities ebtables bridge-utils libboost-all-dev
    ccache python3-full
    gedit
    tree
)

echo "🔍 Checking and installing missing dependencies..."

sudo apt update

for pkg in "${packages[@]}"; do
    dpkg -s "$pkg" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "📦 Installing $pkg..."
        if ! sudo apt install -y "$pkg"; then
            echo "❌ Failed to install $pkg. Please check your system or package manager."
            exit 1
        fi
    else
        echo "✅ $pkg is already installed"
    fi
done

echo "✅✅✅ All dependencies checked and installed as needed."
qmake --version
