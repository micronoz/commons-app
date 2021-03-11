import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/message.dart';
import 'package:provider/provider.dart';

final String getMessagesQuery = r'''
  query GetMessagesForActivity($id: String!) {
    activity(id: $id) {
      id
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
  final _formKey = GlobalKey<FormState>();
  var _messageIsEmpty = true;
  final _outgoingMessages = <Map<String, dynamic>>[];
  var _incomingMessages = [];
  Function _refetch;

  void sendMessage(BuildContext context, String content) async {
    if (content.isEmpty) return;
    _formKey.currentState.reset();
    _messageIsEmpty = true;
    final resultFuture = GraphQLProvider.of(context).value.mutate(
          MutationOptions(
            document: gql(sendMessageMutation),
            variables: {
              'message': content,
              'activityId': widget.activityId,
            },
          ),
        );
    setState(
      () => _outgoingMessages.add(
        {
          'future': resultFuture.then((value) {
            if (_refetch != null) {
              _refetch();
            }
            return value;
          }),
          'message': content
        },
      ),
    );
  }

  void dismissKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = Expanded(
      child: GestureDetector(
        onTap: () => dismissKeyboard(context),
        onVerticalDragStart: (details) => dismissKeyboard(context),
        child: Query(
          options: WatchQueryOptions(
              pollInterval: Duration(seconds: 5),
              document: gql(getMessagesQuery),
              fetchPolicy: FetchPolicy.cacheAndNetwork,
              variables: {'id': widget.activityId}),
          builder: (result, {fetchMore, refetch}) {
            _refetch = refetch;
            // print(
            //     '${result.isConcrete}, ${result.isLoading}, ${result.isNotLoading}, ${result.isOptimistic}');
            if (result.hasException) {
              return Text('Error');
            }
            if (!result.isConcrete && _incomingMessages.isEmpty) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (result.isConcrete) {
              final incomingMessages = (result.data['activity']
                      ['messageConnections'] as List<dynamic>)
                  .map((json) {
                final currentMessage = Message.fromJson(json);
                currentMessage.isSender =
                    context.read<AppUser>().profile == currentMessage.sender;
                return currentMessage;
              }).toList();
              incomingMessages.sort((first, second) =>
                  second.timestamp.compareTo(first.timestamp));
              _incomingMessages = incomingMessages;
            }

            return ListView(
              padding: EdgeInsets.only(top: 10),
              reverse: true,
              children: [
                ..._outgoingMessages.map((pair) {
                  return FutureBuilder(
                      future: pair['future'],
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.done) {
                          final result = (snap.data as QueryResult);
                          if (result.hasException) {
                            print(result.exception.toString());
                            return const SizedBox();
                          }
                          final message =
                              Message.fromJson(result.data['createMessage']);
                          if (_incomingMessages.contains(message)) {
                            _outgoingMessages.remove(pair);
                            return const SizedBox();
                          }
                        }
                        return Stack(
                          children: [
                            ChatBubble(
                              alignment: Alignment.bottomRight,
                              backGroundColor: Colors.blue,
                              clipper: ChatBubbleClipper6(
                                  type: BubbleType.sendBubble),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Text(
                                  pair['message'] as String,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          ],
                        );
                      });
                }),
                ..._incomingMessages.map(
                  (m) => Container(
                    key: Key(m.hashCode.toString()),
                    child: ChatBubble(
                      alignment: m.isSender
                          ? Alignment.bottomRight
                          : Alignment.bottomLeft,
                      backGroundColor:
                          m.isSender ? Colors.blue : Colors.blueGrey[100],
                      clipper: ChatBubbleClipper6(
                          type: m.isSender
                              ? BubbleType.sendBubble
                              : BubbleType.receiverBubble),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Text(
                          m.message,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    var body = Column(
      children: [
        messages,
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
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
