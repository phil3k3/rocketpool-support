#!/bin/bash

# Define the name of the virtual environment
venv_name="rocketpool-venv"

# Check if the virtual environment already exists
if [ -d "$venv_name" ]; then
  echo "Virtual environment '$venv_name' already exists. Activating..."
  source "$venv_name/bin/activate"
else
  echo "Creating and activating virtual environment '$venv_name'..."

  # Create the virtual environment
  python3 -m venv "$venv_name"

  # Activate the virtual environment
  source "$venv_name/bin/activate"

  pip install -r requirements.txt
  echo "Requirements installed from requirements.txt"
fi

# Verify that the virtual environment is active
if [ "$VIRTUAL_ENV" != "" ]; then
  echo "Virtual environment '$VIRTUAL_ENV' is now active."
  ansible-playbook -i inventory.ini rocketpool.yaml -vvvv
  deactivate
else
  echo "Failed to activate the virtual environment. Check your setup."
fi


