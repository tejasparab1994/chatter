defmodule Chatter.RoomChannel do
  use Chatter.Web, :channel #specifies we want this to be our channel
  alias Chatter.Presence #for easy access to the Presence module


  def join("room:lobby", _, socket) do
    send self(), :after_join #where self is the user and create a callback function that refers to this atom
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do #the callback function that has the same atom and the socket
    Presence.track(socket, socket.assigns.user, %{ #track the socket and using assigns.user and time to give it to presence
      online_at: :os.system_time(:milli_seconds)
      })
      push socket, "presence_state", Presence.list(socket) #update the list with push where our list is list of users
      {:noreply, socket}
  end

  def handle_in("message:new", message, socket) do #listen on socket for "message:new"
    broadcast! socket, "message:new", %{ #then broadcast that message to everyone using the format given below
      user: socket.assigns.user,
      body: message,
      timestamp: :os.system_time(:milli_seconds)
    }
    {:noreply, socket}
  end
end
