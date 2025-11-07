#!/bin/bash
#SBATCH --job-name=ollama-server
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8 # number of cpus to use
#SBATCH --mem=32G # amount of ram to request
#SBATCH --gpus-per-node=1 # request a gpu of any type
#SBATCH --time=5-00:00:00 # time to run, max is five days shown here
#SBATCH --output=ollama-server.out # standard output location
#SBATCH --dependency=singleton # two jobs with same name cannot run (don't run two instances of the same ollama server)
#SBATCH --signal=B:SIGINT@120 # two minutes before job ends, send the equivalent of Ctrl-C to ollama so it can cleanly shutdown

# Set the base location for your Ollama installation/project
export OLLAMA_DIR=/mnt/projects/hpcuser1_project/ollama

# Add the ollama binary location to your session PATH
export PATH=$PATH:$OLLAMA_DIR/bin/

# Set a location for model storage
export OLLAMA_MODELS=$OLLAMA_DIR/models

# Randomize the Ollama port
export OLLAMA_PORT=$(shuf -i 10000-30000 -n 1) # select a random port to run on
export OLLAMA_HOST=0.0.0.0:$OLLAMA_PORT

# Output the connection details to a file
echo "export OLLAMA_HOST=$(hostname):$OLLAMA_PORT" > $OLLAMA_DIR/connection.txt

echo ""
echo "----------------------------------------------------------------------------------------"
echo ""
echo "  Ollama Server Connection Details:"
echo ""
echo "      Server: $(hostname)"
echo "        Port: $OLLAMA_PORT"
echo ""
echo "  This job will end at $(squeue --noheader -j $SLURM_JOBID -o %e)."
echo "  Ollama server will gracefully terminate two minutes before the end of the job."
echo ""
echo "  To connect to this instance from outside of Clipper using SSH port forwarding:"
echo ""
echo "  ssh -t -t $USER@clipper.gvsu.edu -L 11434:localhost:$OLLAMA_PORT ssh $(hostname) -L $OLLAMA_PORT:localhost:$OLLAMA_PORT"
echo ""
echo "  This command will forward all requests on port 11434 from your local machine"
echo "  to the Ollama server instance running on $(hostname)."
echo "  Please note this command will change for every submission of this job."
echo "  Check this output for the correct ports to forward each time this job is submitted."
echo ""
echo "----------------------------------------------------------------------------------------"
echo ""

# run ollama server
ollama serve
