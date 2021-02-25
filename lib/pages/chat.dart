import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/message.dart';

class ChatPage extends StatefulWidget {
  final bool scaffold;
  final String title;
  ChatPage(this.scaffold, {this.title}) : super() {
    if (scaffold) {
      assert(title != null);
    }
  }
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageInputHeight = 100.0;
  final _messages = Message.createRandomChat(count: 5);
  final _formKey = GlobalKey<FormState>();
  var _messageIsEmpty = true;
  final _focusNode = FocusNode();

//TODO Implement backend connection
  void sendMessage(BuildContext context, String content) {
    if (content.isEmpty) return;
    print(content);
    _formKey.currentState.reset();
    _messageIsEmpty = true;
    final myMessage =
        Message.createMessage(context, content, Activity.getDefault());
    //TODO send message to backend
    myMessage.isSender = true;
    _messages.insert(0, myMessage);
  }

  void dismissKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    var body = Column(
      children: [
        Expanded(
          child: GestureDetector(
            // onVerticalDragDown: (details) => dismissKeyboard(context),
            onTap: () => dismissKeyboard(context),
            child: ListView(
              padding: EdgeInsets.only(top: 10),
              reverse: true,
              children: [
                // SizedBox(
                //   height: _messageInputHeight + 10,
                // ),
                ..._messages.map(
                  (m) => Container(
                    key: Key(m.hashCode.toString()),
                    child: ChatBubble(
                      alignment: m.isSender
                          ? Alignment.bottomRight
                          : Alignment.bottomLeft,
                      backGroundColor:
                          m.isSender ? Colors.blue : Colors.blueGrey[100],
                      child: Container(
                        child: Text(m.content),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                      ),
                      clipper: ChatBubbleClipper6(
                          type: m.isSender
                              ? BubbleType.sendBubble
                              : BubbleType.receiverBubble),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: _messageInputHeight,
          color: Colors.blueGrey[100],
          padding: EdgeInsets.all(5),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  flex: 20,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          focusNode: _focusNode,
                          onSaved: (message) {
                            setState(() => sendMessage(context, message));
                          },
                          onChanged: (message) {
                            if (message.isNotEmpty && _messageIsEmpty) {
                              setState(() {
                                _messageIsEmpty = false;
                              });
                            } else if (message.isEmpty && !_messageIsEmpty) {
                              setState(() {
                                _messageIsEmpty = true;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                  ),
                ),
                if (!_messageIsEmpty)
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      splashColor: Colors.blue,
                      highlightColor: Colors.blue,
                      icon: Icon(Icons.send),
                      onPressed: () {
                        _formKey.currentState.save();
                      },
                    ),
                  )
              ],
            ),
          ),
        )
      ],
    );

    if (widget.scaffold) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: body,
      );
    } else {
      return body;
    }
  }
}
