## Create folder structure
```
mkdir -p app/templates
cd app
touch app.py templates/app.html requirements.txt Dockerfile run.sh build.sh
chmod a+x *.sh
```
## Docker scripts
In `run.sh`, add:
```
docker run --name simple_chat -p 5000:5000 -v $(pwd):/app -d simple_chat
```
In `build.sh`, add:
```
docker build -t simple_chat .
```
In `Dockerfile`, add:
```
FROM ubuntu:16.04
RUN apt-get update -y \
  && apt-get install -o Acquire::ForceIPv4=true -y python-pip python-dev build-essential
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```

## Requirements
In `requirements.txt`, add:
```
flask
flask-socketio
eventlet
```
## App files
In `app.py`, add:
```
from flask import Flask, render_template
from flask_socketio import SocketIO, emit

# https://flask-socketio.readthedocs.io/en/latest/
# https://github.com/socketio/socket.io-client

app = Flask(__name__)

app.config['SECRET_KEY'] = 'jsbcfsbfjefebw237u3gdbdc'
socketio = SocketIO(app)

@app.route('/')
def hello():
  return render_template('app.html')

def messageRecived():
  print('message was received!!!')

@socketio.on('my event')
def handle_my_custom_event(json):
  print( 'recived my event: ' + str(json))
  socketio.emit('my response', json, callback=messageRecived)

if __name__ == '__main__':
  socketio.run(app, debug=True, host='0.0.0.0')
```
In `templates/tapp.html`, add:
```
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Simple chat</title>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" 
    integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

    <style>
      div.msg_bbl {
        background-color: #ddd;
        padding: 5px 10px;
        border-radius: 10px;
        color: #555;
        margin-bottom: 5px;
      }
    </style>
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
    <div class="text-center well"><b>Simple Chat</b></div>
    <div class="container">
      <div class="col-sm-8">
        <div class="no_message">
          <h1 style='color: #ccc'>No message yet..</h1>
          <div class="message_holder"></div>
        </div>
      </div>
      <div class="col-sm-4">
        <form action="" method="POST">
          <b>Type your message below <span class="glyphicon glyphicon-arrow-down"></span></b>
          <div class="clearfix" style="margin-top: 5px;"></div>
          <input type="text" class="username form-control" placeholder="User Name">
          <div style="padding-top: 5px;"></div>
          <input type="text" class="message form-control" placeholder="Messages">
          <div style="padding-top: 5px;"></div>
          <button type="submit" class="btn btn-success btn-block"><span class="glyphicon glyphicon-send"></span> Send</button>
        </form>
      </div>
    </div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/1.7.3/socket.io.min.js"></script>
    <script>
      var socket = io.connect('http://' + document.domain + ':' + location.port);
      // broadcast a message
      socket.on('connect', function() {
        socket.emit('my event', { data: 'User Connected' });
        var form = $('form').on('submit', function(e) {
          e.preventDefault();
          let user_name = $('input.username').val();
          let user_input = $('input.message').val();
          socket.emit('my event', {
            user_name : user_name,
            message : user_input
          });
          // empty the input field
          $('input.message').val('').focus();
        })
      });
      // capture message
      socket.on('my response', function(msg) {
        console.log(msg);
        if(typeof msg.user_name !== 'undefined') {
          $('h1').remove();
          $('div.message_holder').append('<div class="msg_bbl"><b style="color: #000">'+msg.user_name+'</b> '+msg.message+'</div>');
        }
      });
    </script>
  </body>
</html>
```
