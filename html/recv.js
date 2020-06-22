const mqtt = require('mqtt');

const client = mqtt.connect('mqtt://16276edb:3bae86e0b5f8ae36@broker.shiftr.io', {
    clientId: 'javascript'
})

client.on('connect', function(){
    console.log('client has connected!');
  
    client.subscribe('/moisture');
    // client.unsubscribe('/example');
  
    // setInterval(function(){
    //     client.publish('/example', 'world');
    // }, 1000);
});
  
client.on('message', function(topic, message) {
    console.log('new message:', topic, message.toString());
});