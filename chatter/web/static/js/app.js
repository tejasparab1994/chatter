
import 'phoenix_html';
import { Socket, Presence } from 'phoenix';

// Socket
let user = document.getElementById('User').innerText; //getting username
let socket = new Socket('/socket', { params: { user: user } });

//new socket created and pulling from backend and connecting to it through js
socket.connect();

// Presence
let presences = {}; //handle presence to see users as they login

let formatTimestamp = (timestamp) => {

  //converting the milli_seconds answer to string and making it human readable
  let date = new Date(timestamp);
  return date.toLocaleTimeString();
};

let listBy = (user, { metas: metas }) => {

  //creating a user object consisting of user and time
  return {
    user: user,
    onlineAt: formatTimestamp(metas[0].online_at),
  };
};

let userList = document.getElementById('UserList');
let render = (presences) => {
  userList.innerHTML = Presence.list(presences, listBy)
    .map(presence => `
      <li>
        <b>${presence.user}</b>
        <br><small>online since ${presence.onlineAt}</small>
      </li>
    `)
    .join('');
};

// Channels
let room = socket.channel('room:lobby', {}); //tell js about our channel
//presence_state: after server sends state of everybody
//who is online(first connect or ever disconnet)
room.on('presence_state', state => {
  presences = Presence.syncState(presences, state);
  render(presences);
});

//when somebody joins in when we in app add him to list
room.on('presence_diff', diff => {
  presences = Presence.syncDiff(presences, diff);
  render(presences);
});

room.join();

// Chat
let messageInput = document.getElementById('NewMessage');
messageInput.addEventListener('keypress', (e) => {
  if (e.keyCode == 13 && messageInput.value != '') { //keypress enter and value not equal to empty
    room.push('message:new', messageInput.value); // push new message back to server
    messageInput.value = ''; // and clear the input
  }
});

let messageList = document.getElementById('MessageList');
let renderMessage = (message) => {
  let messageElement = document.createElement('li');
  messageElement.innerHTML = `
    <b>${message.user}</b>
    <i>${formatTimestamp(message.timestamp)}</i>
    <p>${message.body}</p>
  `;
  messageList.appendChild(messageElement);
  messageList.scrollTop = messageList.scrollHeight;
};//appending new messages to the list of messages using appendchild

room.on('message:new', message => renderMessage(message));
