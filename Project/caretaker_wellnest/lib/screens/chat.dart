import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Chat extends StatefulWidget {
  final String caretakerId;
  final String familyMemberId;

  const Chat(
      {super.key, required this.caretakerId, required this.familyMemberId});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
    listenForMessages();
  }

  /// Fetch chat history between caretaker and family member
  Future<void> fetchMessages() async {
    final response = await supabase
        .from('tbl_chat')
        .select()
        .or('chat_fromcid.eq.${widget.caretakerId}, chat_fromfid.eq.${widget.familyMemberId}')
        .or('chat_tocid.eq.${widget.caretakerId}, chat_tofid.eq.${widget.familyMemberId}')
        .order('datetime', ascending: true);

    if (mounted) {
      setState(() {
        messages =
            response.map((msg) => Map<String, dynamic>.from(msg)).toList();
      });
    }
  }

  /// Listen for new messages in real time
  void listenForMessages() {
    supabase
        .from('tbl_chat')
        .stream(primaryKey: ['chat_id'])
        .order('datetime', ascending: true)
        .listen((snapshot) {
          if (mounted) {
            setState(() {
              // Clear the existing messages list to avoid duplicates
              messages.clear();

              // Add all messages from the snapshot to the list
              messages.addAll(
                  snapshot.map((msg) => Map<String, dynamic>.from(msg)));

              // Sort the messages by datetime
              messages.sort((a, b) => a['datetime'].compareTo(b['datetime']));
            });
          }
        });
  }

  /// Send a new message
  Future<void> sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    await supabase.from('tbl_chat').insert({
      'chat_fromcid': widget.caretakerId,
      'chat_fromfid': null,
      'chat_tocid': null,
      'chat_tofid': widget.familyMemberId,
      'chat_content': messageText,
      'datetime': DateTime.now().toIso8601String(),
    });
    listenForMessages();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['chat_fromcid'] == widget.caretakerId;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.greenAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['chat_content'] ?? '',
                      style:
                          TextStyle(color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
