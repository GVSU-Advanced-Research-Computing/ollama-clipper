#!/usr/bin/env python3

from ollama import chat
from ollama import ChatResponse

response: ChatResponse = chat(model='gemma3', messages=[
  {
    'role': 'user',
    'content': 'Why is the sky blue?',
  },
])

print("")
print(response['message']['content'])
print("")
