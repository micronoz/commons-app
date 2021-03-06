import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/message.dart';
import 'package:provider/provider.dart';

final String getMessagesQuery = r'''
  query GetMessagesForActivity($id: String!) {
    activity(id: $id) {
      messageConnections {  
        id
        message
        createdAt
        sender {
          id
          handle
        }
      }
    }
  }
''';

final sendMessageMutation = r'''
  mutation SendMessage($message: String!, $activityId: String!) {
    createMessage(message: $message, activityId: $activityId) {
      id
      message
      createdAt
      sender {
        id
        handle
      }
    }
  }
''';

class ChatPage extends StatefulWidget {
  final bool scaffold;
  final String title;
  final String activityId;
  ChatPage(this.scaffold, this.activityId, {this.title}) : super() {
    if (scaffold) {
      assert(title != null);
    }
  }
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageInputHeight = 100.0;
  var _messages = <Message>[];
  final _formKey = GlobalKey<FormState>();
  var _messageIsEmpty = true;
  final _focusNode = FocusNode();
  ObservableQuery _observableMessageQuery;
  StreamSubscription<QueryResult> messageStream;

  @override
  void dispose() {
    _observableMessageQuery.close();
    messageStream.cancel();
    super.dispose();
  }

  void sendMessage(BuildContext context, String content) async {
    if (content.isEmpty) return;
    _formKey.currentState.reset();
    _messageIsEmpty = true;
    final result = await GraphQLProvider.of(context).value.mutate(
          MutationOptions(
            document: gql(sendMessageMutation),
            variables: {
              'message': content,
              'activityId': widget.activityId,
            },
          ),
        );
    if (result.hasException) {
      print(result.exception);
      return;
    }
    final myMessage = Message.fromJson(result.data['createMessage']);
    myMessage.isSender = true;
    _messages.insert(0, myMessage);
    if (mounted) {
      setState(() {});
    }
  }

  void dismissKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_observableMessageQuery == null) {
      _observableMessageQuery = GraphQLProvider.of(context).value.watchQuery(
            WatchQueryOptions(
                document: gql(getMessagesQuery),
                fetchPolicy: FetchPolicy.cacheAndNetwork,
                variables: {'id': widget.activityId}),
          );
      _observableMessageQuery.startPolling(Duration(seconds: 5));
      messageStream = _observableMessageQuery.stream.listen((result) {
        if (!result.isLoading && result.data != null) {
          if (mounted) {
            setState(() {
              _messages = (result.data['activity']['messageConnections']
                      as List<dynamic>)
                  .map((json) {
                final currentMessage = Message.fromJson(json);
                currentMessage.isSender =
                    context.read<AppUser>().profile == currentMessage.sender;
                return currentMessage;
              }).toList();
              _messages.sort((first, second) =>
                  second.timestamp.compareTo(first.timestamp));
            });
          }
        }
      }, onError: (error, stack) => print(error));
      _observableMessageQuery.fetchResults();
    }
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
                        child: Text(m.message),
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
                          onSaved: (message) async {
                            await sendMessage(context, message);
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
