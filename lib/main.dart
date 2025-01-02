import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi-Agent Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
        useMaterial3: true,
      ),
      home: const MultiAgentChatApp(),
    );
  }
}

class MultiAgentChatApp extends StatefulWidget {
  const MultiAgentChatApp({super.key});

  @override
  State<MultiAgentChatApp> createState() => _MultiAgentChatAppState();
}

class _MultiAgentChatAppState extends State<MultiAgentChatApp>
    with SingleTickerProviderStateMixin {
  final List<String> agentKeys = ["Agent 1", "Agent 2", "Agent 3"];
  final Map<String, String> agentAPIs = {
    "Agent 1": "https://api.agent1.com",
    "Agent 2": "https://api.agent2.com",
    "Agent 3": "https://api.agent3.com",
  };

  final Map<String, String> agentNames = {
    "Agent 1": "Default Agent 1",
    "Agent 2": "Default Agent 2",
    "Agent 3": "Default Agent 3",
  };

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Animated Header
          AnimatedOpacity(
            opacity: 1.0, // Start with full opacity for debugging
            duration: const Duration(seconds: 2),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "🤖 Multi-Agent Chatbot 🤖",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Chat with multiple agents in parallel!",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Inputs for Agents (Header Section)
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.deepPurple[50],
            child: Column(
              children: agentKeys.map((key) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            hintText: 'Name for $key',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                          ),
                          onChanged: (value) {
                            setState(() {
                              agentNames[key] =
                                  value.isNotEmpty ? value : "Default $key";
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            hintText: 'API for $key',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                          ),
                          onChanged: (value) {
                            setState(() {
                              agentAPIs[key] = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Chatbot Cards
          Expanded(
            child: screenWidth > 600
                ? Row(
                    children: agentKeys.map((key) {
                      return Expanded(
                        child: ChatbotCard(
                            agentKey: key,
                            agentNames: agentNames,
                            agentAPIs: agentAPIs),
                      );
                    }).toList(),
                  )
                : Column(
                    children: agentKeys.map((key) {
                      return Expanded(
                        child: ChatbotCard(
                            agentKey: key,
                            agentNames: agentNames,
                            agentAPIs: agentAPIs),
                      );
                    }).toList(),
                  ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.deepPurple[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "👨‍💻 Nadav Chen",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // GitHub Link
                    GestureDetector(
                      onTap: () {
                        launchCustomUrl("https://github.com/Nadav23AnT");
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.code, color: Colors.black),
                          SizedBox(width: 4),
                          Text(
                            "GitHub",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    // LinkedIn Link
                    GestureDetector(
                      onTap: () {
                        launchCustomUrl(
                            "https://www.linkedin.com/in/nadavchen97/");
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.link, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            "LinkedIn",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> launchCustomUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ChatbotCard extends StatefulWidget {
  final String agentKey;
  final Map<String, String> agentNames;
  final Map<String, String> agentAPIs;

  const ChatbotCard(
      {super.key,
      required this.agentKey,
      required this.agentNames,
      required this.agentAPIs});

  @override
  State<ChatbotCard> createState() => _ChatbotCardState();
}

class _ChatbotCardState extends State<ChatbotCard> {
  final List<Map<String, String>> messages = [];
  final TextEditingController messageController = TextEditingController();

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({'user': 'You', 'text': messageController.text});
      messageController.clear();

      // Simulated API call (Replace with real API interaction)
      final agentAPI = widget.agentAPIs[widget.agentKey] ?? 'API not set';
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          messages.add({
            'user': widget.agentNames[widget.agentKey] ?? widget.agentKey,
            'text': 'Response from $agentAPI'
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.2 * 255).toInt()),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.agentNames[widget.agentKey] ?? widget.agentKey,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: widget.agentKey,
                items: widget.agentAPIs.keys.map((key) {
                  return DropdownMenuItem(value: key, child: Text(key));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      widget.agentAPIs[widget.agentKey] =
                          widget.agentAPIs[value] ?? '';
                    });
                  }
                },
              ),
            ],
          ),
          const Divider(color: Colors.grey),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message['user'] == 'You'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: message['user'] == 'You'
                          ? Colors.deepPurple[50]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text('${message['user']}: ${message['text']}'),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    filled: true,
                    fillColor: Color.fromARGB(255, 184, 184, 184),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: sendMessage,
                child: const Text('Send'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
