#!/bin/bash
#SBATCH --job-name=ollama-client
#SBATCH --partition=cpu # or bigmem, the client does not need a gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4 # number of cpus to use
#SBATCH --mem=16G # amount of ram to request
#SBATCH --time=5-00:00:00 # time to run, max is five days shown here
#SBATCH --output=ollama-client.out # standard output/error location

# Set the base location for your Ollama installation/project
export OLLAMA_DIR=/mnt/projects/hpcuser1_project/ollama

# This adds the ollama binary location to your session PATH
export PATH=$PATH:$OLLAMA_DIR/bin/

# Source the connection details from the server into this session
source $OLLAMA_DIR/connection.txt

# Echo out the ollama host
echo ""
echo "Using Ollama server located at: $OLLAMA_HOST"
echo ""

# pull a model, in this case gemma3
# list of models is available here: https://ollama.com/library
echo "Pulling gemma3..."
echo ""
ollama pull gemma3
echo ""

# source our python environment with the ollama client installed
source $OLLAMA_DIR/venv/bin/activate

# run our python script
python sky-blue.py
