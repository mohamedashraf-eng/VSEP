#!/bin/bash

# Install depends
pip install -r fota/requirements.txt

# Run the server
echo Running the website 
python3 fota/manage.py runserver