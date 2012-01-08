# Introduction

SkypeMac is a ruby wrapper for the Skype public API using AppleScript.

It allows basic commands to be sent to a running Skype instance, such
as changing the online status of the current user, listing friends or
chat messages, initiating calls and chats etc.

NOTE: At this point, Skype does not support asynchronous commands over the
AppleScript API.

# Installation

    gem install skypemac

# Usage

    require 'skypemac'

### Current user

    user = SkypeMac::User.current_user
    # => echotest123

### Online Status

    SkypeMac::User.status
    # => "ONLINE"
    SkypeMac::User.status = "OFFLINE"
    # => "OFFLINE"

### Calling

    # Call a user
    call = SkypeMac::Call.call('echo123')
    # => #<SkypeMac::Call:0x007fc3b30f30d8 @id="2214381">
    call.status
    # => "INPROGRESS"
    call.partner_dispname
    # "Skype Test Call"

### Chats

    # List recent chats
    chats = SkypeMac::Chat.recent_chats
    # => [ #<SkypeMac::Chat:0x007fc3b3195f68 @id="#test/$zaki001;123456abcdef">, #<SkypeMac::Chat:0x007fc3b3195f40 @id="#test/$zaki;1234556abcdef"> ]
    messages = chats.first.recent_chat_messages
    # => [ #<SkypeMac::ChatMessage:0x007fc3b3854ea8 @id="1234">, #<SkypeMac::ChatMessage:0x007fc3b3854e80 @id="1234"> ]
    messages.map &:body
    # => [ "Hi", "This is a test" ]

    # Send a message to an existing chat
    chats.first.send_message("Hey there")
    # => "CHATMESSAGE 2114633 STATUS SENDING"
    # it is not possible to get an asynchronous delivery notification,
    # if you need to make sure it got sent, you will need to poll:

    message = SkypeMac::ChatMessage.new(2114633)
    message.status
    # => "SENT"

    # Get information about a chat
    chat.topic
    # => "Test chat"


# License

SkypeMac is available under the MIT license.
