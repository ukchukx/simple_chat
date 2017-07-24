#!/bin/bash
docker run --name simple_chat -p 5000:5000 -v $(pwd):/app -d simple_chat