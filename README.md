# AI-Powered Conversational Sales Chatbot

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Google Gemini](https://img.shields.io/badge/Google_Gemini-8E44AD?style=for-the-badge&logo=google&logoColor=white)
![Express.js](https://img.shields.io/badge/Express.js-000000?style=for-the-badge&logo=express&logoColor=white)

This repository contains a fully functional, AI-powered sales call chatbot. The application features a responsive frontend built with Flutter and a robust backend powered by Node.js, Express, and the Google Gemini API. The chatbot, "Martin," is designed to simulate a B2B sales executive, engaging users in a natural conversation to qualify leads and book demos for a fictional SaaS product, "LeadMate CRM."

---

## 🌟 Key Features

- **Intelligent Conversation**: Powered by the Google Gemini API for natural, context-aware, and human-like sales conversations.
- **Dynamic Sales Flow**: Guides the user through a complete sales cycle: introduction, qualification, objection handling, and closing.
- **Automatic Meeting Scheduling**: The AI can identify when a user wants to book a meeting and will gather the necessary details.
- **Backend Meeting Management**: The server automatically parses meeting requests, creates calendar links, and stores meeting details.
- **RESTful API**: A clean API for managing chat sessions and scheduled meetings (view, reschedule, cancel).
- **Responsive UI**: A beautiful and responsive user interface built with Flutter, ensuring a great experience on any device.
- **Real-time Feedback**: Includes typing indicators and animated UI elements for an engaging user experience.
- **Elegant Design**: Features a custom animated particle background for a modern aesthetic.

---

## 🏗️ Architecture & Code Structure

The application follows a client-server architecture, with the Flutter app acting as the client and the Node.js application as the server.

### 📁 Backend (`/backend`)

The backend is a Node.js application using the Express.js framework. It handles all business logic, including communication with the Google Gemini API and meeting management.

**Key Files & Logic:**

-   `index.js`: The main entry point for the server. It sets up the Express app, defines middleware (`cors`, `express.json`), and configures all API routes.
-   **Environment Variables**: Uses `dotenv` to manage sensitive information like the `GEMINI_API_KEY`.
-   **AI Integration**: Utilizes the `@google/generative-ai` SDK to connect to and interact with the Gemini API.
-   **In-Memory Storage**: Uses a JavaScript `Map` to store scheduled meetings for the demo. In a production environment, this would be replaced with a database.
-   **Core Functions**:
    -   `validateAndCleanHistory()`: Sanitizes the conversation history sent from the client to match the format required by the Gemini API.
    -   `parseMeetingRequest()`: Uses regex to detect and extract meeting details from the AI's response when it uses the special `[SCHEDULE_MEETING]` format.
    -   `createMeetingLink()` & `generateCalendarInvite()`: Utility functions to generate placeholder meeting and Google Calendar links.

### 📱 Frontend (`/ass_app`)

The frontend is a cross-platform application built with Flutter. It is responsible for rendering the user interface and communicating with the backend via HTTP requests.

```
lib/
├── constants       # App-wide constants (e.g., colors)
│   └── ColorConstants.dart
├── core            # Core UI widgets (e.g., animated background)
│   └── ParticularBg.dart
├── main.dart       # Main application entry point
├── models          # Data models for structuring app data
│   ├── chatmessage.dart
│   ├── meetingInfo.dart
│   └── particule.dart
├── screens         # Main UI screens of the app
│   └── ChatScreen.dart
├── services        # Business logic, primarily for API communication
│   └── ChatService.dart
└── widgets         # Reusable UI components
    ├── buildInputArea.dart
    ├── meetingcard.dart
    ├── messbubble.dart
    └── typeInd.dart
```

---

## 🚀 Getting Started

Follow these instructions to get a local copy up and running for development and testing.

### Prerequisites

-   [Node.js](https://nodejs.org/en/) (v18 or newer)
-   [Flutter SDK](https://docs.flutter.dev/get-started/install)
-   A code editor like [VS Code](https://code.visualstudio.com/)

### ⚙️ Backend Setup

1.  **Navigate to the backend directory:**
    ```bash
    cd backend
    ```
2.  **Install dependencies:**
    ```bash
    npm install
    ```
3.  **Create a `.env` file** in the `backend` root directory and add your Google Gemini API key:
    ```
    GEMINI_API_KEY=YOUR_API_KEY_HERE
    ```
4.  **Start the server:**
    ```bash
    npm start
    ```
    The server will be running on `http://localhost:3000`.

### 📱 Frontend Setup

1.  **Navigate to the frontend directory:**
    ```bash
    cd ass_app
    ```
2.  **Get Flutter packages:**
    ```bash
    flutter pub get
    ```
3.  **Update the API URL:**
    Open `lib/services/ChatService.dart` and ensure the `_baseUrl` points to your running backend server (by default, it should be `http://localhost:3000`).
4.  **Run the app:**
    Select your target device (e.g., Chrome, iOS Simulator, Android Emulator) and run the app:
    ```bash
    flutter run
    ```

---

## 🤖 Prompt Engineering

The effectiveness of the chatbot relies heavily on a well-crafted **system prompt**. This prompt defines the AI's persona, objectives, rules, and conversational style.

<details>
<summary><strong>Click to view the full System Prompt</strong></summary>

```
You are Martin, an experienced B2B sales executive at LeadMate CRM. You're conducting an outbound sales call via chat to help businesses understand the value of our advanced CRM solution.

Your personality and approach:
- Professional, friendly, and conversational
- Genuinely interested in helping prospects solve their problems
- Skilled at asking qualifying questions
- Confident but not pushy
- Empathetic to business challenges
- Goal-oriented but relationship-focused

Your objective: Book a demo or follow-up call by the end of the conversation.

Meeting Scheduling Protocol:
When a user expresses interest in scheduling a meeting, demo, or call (phrases like "let's have a meet", "schedule a demo", "book a call", "set up a meeting", etc.), you should:

1. Express enthusiasm about scheduling the meeting
2. Ask for their preferred time/date
3. Confirm their contact details (name, email, phone)
4. Use the special format: [SCHEDULE_MEETING] followed by the meeting details

Meeting request format:
[SCHEDULE_MEETING]
Name: [User's name]
Email: [User's email]
Phone: [User's phone]
Preferred Date: [Date they mentioned]
Preferred Time: [Time they mentioned]
Meeting Type: [Demo/Call/Consultation]
Notes: [Any additional notes]
[/SCHEDULE_MEETING]

Conversation Flow:
1. Cold Call Introduction: Warm, personalized opening
2. Qualifying Questions: Understand their current situation and pain points
3. Value Proposition: Present relevant benefits based on their needs
4. Objection Handling: Address concerns professionally
5. Closing: Guide toward scheduling a demo

Guidelines:
- Keep responses concise (2-3 sentences max initially)
- Ask one question at a time
- Always move the conversation forward
- If they object, acknowledge and redirect
- Be persistent but respectful
- When scheduling, collect all necessary details before confirming

Remember: This is a professional sales interaction. Stay focused on business value and building trust.
```

</details>

This structured approach allows the backend to reliably parse the AI's output and trigger specific actions, like creating a meeting, without breaking the conversational flow.

---

## 🔌 API Endpoints

The backend exposes the following RESTful endpoints:

| Method | Endpoint          | Description                                    |
| :----- | :---------------- | :--------------------------------------------- |
| `POST` | `/chat`           | Send a message and get the AI's response.      |
| `GET`  | `/meetings`       | Retrieve a list of all scheduled meetings.     |
| `GET`  | `/meetings/:id`   | Get details for a specific meeting by its ID.  |
| `PUT`  | `/meetings/:id`   | Reschedule a meeting.                          |
| `DELETE`| `/meetings/:id`   | Cancel a scheduled meeting.                    |

#### Example: `POST /chat`

**Request Body:**

```json
{
  "message": "Can you tell me more about your pricing?",
  "history": [
    {
      "role": "user",
      "content": "Hi there"
    },
    {
      "role": "assistant",
      "content": "Hello! I'm Martin from LeadMate CRM. How are you today?"
    }
  ]
}
```

**Success Response (with meeting scheduled):**

```json
{
  "message": "✅ Perfect! I've scheduled your demo for tomorrow at 2 PM. \n\n📅 **Meeting Details:**...",
  "meeting": {
    "id": "a1b2c3d4-e5f6-7890-g1h2-i3j4k5l6m7n8",
    "meetingLink": "[https://meet.leadmate.com/join/a1b2c3d4](https://meet.leadmate.com/join/a1b2c3d4)...",
    "calendarLink": "[https://calendar.google.com/calendar/render](https://calendar.google.com/calendar/render)?...",
    "scheduledFor": "tomorrow at 2 PM",
    "meetingType": "Demo"
  }
}
