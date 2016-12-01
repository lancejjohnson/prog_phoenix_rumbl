Typical web application:

Browser makes request
Server sends response
STATELESS
DONE

Each time the browser makes a request it sends a bucket of data based on session and cookies. The Server compares the data with what it knows to determine how to respond. As soon the response is sent, the connection b/t the browser and the server is done.

Channel == conversation
sends messages
receives messages
keeps state

messages == events

state == struct called a socket

channel/conversation is about a topic
topic maps to app concept like "chat room", "game", "annotations", etc

multiple users can be interested in the same topic

each user conversing on a topic is given a dedicated process on the server

channels are concerned with 3 things:

*   making/breaking connections
*   sending messages
*   receiving messages

To use channels, you need code handling connection/sending/receiving on BOTH the client and the server
