#!/bin/sh

# TODO: choose whether to use editable install

# Change to the script's directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Switching to directory $DIR"
cd "$DIR"

# Make sure dedicated environment exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment under 'venv'."
    python3 -m venv venv
fi

# Infer the Jupyter kernel name
# Get containing directory name, not whole path  (so "/home/alex/research/scripts/project" -> "project")
DIRNAME=${PWD##*/}
DISPLAYNAME="${DIRNAME//_/\ }"  # Replace underscores with spaces
DISPLAYNAME="Python (""$DISPLAYNAME"")"  # Dislay kernel as "Python ([kernel])"
KERNELNAME="${DIRNAME//\ /_}"   # Replace spaces with underscores
KERNELNAME="$(echo "$DIRNAME" | tr '[:upper:]' [':lower:'])"  #Make kernel name lower case

# Change the `activate` script so it shows a more meaningful name in prompt
sed -i "s/(venv)/($KERNELNAME)/g" venv/bin/activate

# Abort if virtual environment was not created, to avoid clobbering system install
if [ ! -e "venv/bin/activate" ]; then
    echo "Aborted setting up the environment: `venv/bin/activate` does not exist."
    echo "Check that you have permission to write to this directory."
    exit 1
fi

# Activate dedicated environment
echo "Activating virtual environment."
source venv/bin/activate

# Initial virtual environment typically has a really old pip version
echo "Updating pip..."
pip install --upgrade pip

# Install code and its dependencies
echo "Installing project dependencies..."
pip install -r requirements.txt
# Install any bundled library dependencies
if [ -d "lib" ] && [ -n "$(ls "lib")" ]; then
    # TODO: Set a flag and print this at the end
    echo "You have bundled dependencies in the 'lib' directory."
    echo "This is intended for development only; when deploying, specify all dependencies in 'requirements.txt'"
    for package in $(ls lib); do
        pip install -e "lib/$package"
    done
fi
if [ -e "setup.py" ]; then  # Only install if there is project-specific code
    echo "Installing project code..."
    pip install -e .
fi

echo "Registering IPython kernel for use in Jupyter."
python -m ipykernel install --user --name $KERNELNAME --display-name "$DISPLAYNAME"

echo "Configuring Jupyter widgets..."
jupyter nbextension enable --py widgetsnbextension
jupyter labextension install @jupyter-widgets/jupyterlab-manager

deactivate
echo "Deactivated virtual environment."

echo "Updating kernel deregistration script..."
sed "s/\$KERNELNAME/$KERNELNAME/g" deregister_kernel_template.sh > deregister_kernel.sh
chmod a+x deregister_kernel.sh

echo "Making launch script executable."
chmod a+x launch.py
