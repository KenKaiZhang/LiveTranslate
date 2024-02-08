# Live Translate

An iOS application focused on translating conversation between two people.

There are two modes:
1. Manual
2. Automatic

### Manual
By clicking on the microphone icon under the language, the application should automatically detect the language and transcribe it live.

It will automatically detect when a person stops speaking (for 1s).

After detecting silence, it should translate the transcription and then save it into a history.

### Automatic (in development)
By clicking on the microphone icon for this mode (**Auto**), the application should automatically detect whether the language is source or target language.

Methods of detecting:
- Record the sound, transcribe it with both language, and see which one has a higher confidence
- Get both speech recognizers to detect it live (don’t know how)

---

The applications should allow users to also
- Choose language to translate to and from
- Pick color scheme
  - Color wheel?
  - Color picker?
- Pick between light and dark mode
- Scroll through conversation history like reading through a text message

---

## Progress
### ??? - 02/06/2024

Live recognition and transcription for source and target language is working.

History of conversation in a “iMessage” like format is implemented.

Seamless switching between modes is working.

### 02/07/2024

Added a "good for now" color picker.

Code is kind of messy and **definetly needs some cleaning up**, but color for button and text bubbles will change according to the theme selected.

Need to add a light/dark mode and make sure that bubble text color adheres to the proper accent color.
