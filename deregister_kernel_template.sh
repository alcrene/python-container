echo "Deregistering the kernel will make it unavailable to Jupyter."
echo "To completely remove it for your system, delete the virtual environment after it has been deregistered."
echo ""

# Change to the script's directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Switching to directory $DIR"
cd "$DIR"

source venv/bin/activate
yes | jupyter kernelspec remove $KERNELNAME
deactivate
