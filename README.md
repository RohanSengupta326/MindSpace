# MindSpace 

This Flutter web application serves as a comprehensive resource for individuals seeking information and support regarding mental health. It combines informative content with the power of AI-driven conversation to empower users on their journey towards well-being.

**Features**

- **Mental Health Knowledge Base:** Access a curated list of mental health issues along with detailed descriptions and potential remedies. Leverage the API integration to retrieve this information.
- **MindSpace AI Chat:** Engage in a safe and supportive dialogue with MindSpace AI, an OpenAI-powered chatbot trained to provide general mental health insights and resources.
- **User-Friendly Interface:** Navigate the application seamlessly with a clean and intuitive design optimized for web browsers.

## Screenshots :




**Getting Started**

1. **Prerequisites:**
   - Flutter development environment set up (refer to official documentation: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install))
   - An OpenAI API key ([https://openai.com/blog/openai-api](https://openai.com/blog/openai-api))

2. **Installation:**
   - Clone this repository: `git clone https://github.com/RohanSengupta326/MindSpace`
   - Navigate to the project directory: `cd MindSpace`
   - Install dependencies: `flutter pub get`

3. **Configuration:**
   - Replace `YOUR_OPENAI_API_KEY` in `MindSpace/mind_space_app/lib/views/widgets/app_drawer/app_drawer.dart` with your actual OpenAI API key.
     ```
      Future<String> chatWithGPT(String message) async {
        final apiUrl = 'https://api.openai.com/v1/chat/completions';
        final headers = {
          'Content-Type': 'application/json',
          'Authorization':
            'Bearer "YOUR_API_KEY_HERE" ', // insert your api key here. 
          };
     ```

4. **Run the Application:**
   - Start the development server: `flutter run -d web-server`
   - Access the application in your web browser (usually at `http://localhost:8080/`).

**Usage**

1. Explore the mental health knowledge base to learn about different conditions and potential solutions.
2. Initiate a conversation with MindSpace AI by entering your questions or concerns in the chat interface.

**Disclaimer**

This application is intended to provide information and support, but it is not a substitute for professional mental health care. If you are experiencing serious mental health concerns, please seek help from a qualified mental health professional.


