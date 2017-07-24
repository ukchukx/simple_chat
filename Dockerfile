FROM ubuntu:16.04
RUN apt-get update -y \
  && apt-get install -o Acquire::ForceIPv4=true -y python-pip python-dev build-essential
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
CMD ["python", "app.py"]