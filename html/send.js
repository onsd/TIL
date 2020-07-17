const mqtt = require('mqtt');
const getRandomInt = (max) => {
    return Math.floor(Math.random() * Math.floor(max)) + 1;
}
const client = mqtt.connect('mqtt://16276edb:3bae86e0b5f8ae36@broker.shiftr.io', {
    clientId: 'javascript'
})

client.on('connect', function(){
    console.log('client has connected!');
  
    client.subscribe('/moisture');
    // client.unsubscribe('/example');
  
    setInterval(function(){
        const temperature = (getRandomInt(40) + 10).toString()
        const humidity = getRandomInt(70).toString()
        const lightValue = getRandomInt(70).toString()
        const moisture = getRandomInt(70).toString()

        const payload = `{"temperature":${temperature},"humidity":${humidity},"lightValue":${lightValue},"moisture":${moisture}}`

        client.publish('/moisture', payload);
        console.log('send message :', payload )
    }, 1000);
});
  
//   client.on('message', function(topic, message) {
//     console.log('new message:', topic, message.toString());
//   });
