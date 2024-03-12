# MindSpace 

This Flutter web application serves as a comprehensive resource for individuals seeking information and support regarding mental health. It combines informative content with the power of AI-driven conversation to empower users on their journey towards well-being.

Access the site @ https://mindspaceuniverse.netlify.app/

**Features**

- **Mental Health Knowledge Base:** Access a curated list of mental health issues along with detailed descriptions and potential remedies. Leverage the API integration to retrieve this information.
- **MindSpace AI Chat:** Engage in a safe and supportive dialogue with MindSpace AI, an OpenAI-powered chatbot trained to provide general mental health insights and resources.
- **User-Friendly Interface:** Navigate the application seamlessly with a clean and intuitive design optimized for web browsers.

## Screenshots :
![Screenshot_2024-03-12_11-27-58](https://github.com/RohanSengupta326/MindSpace/assets/64458868/de44bd57-eca0-4124-85b6-9e94564ac119)
![Screenshot_2024-03-12_11-28-18](https://github.com/RohanSengupta326/MindSpace/assets/64458868/1249a149-792a-4541-b5c4-eb67aa5b2f90)
![Screenshot_2024-03-12_11-28-08](https://github.com/RohanSengupta326/MindSpace/assets/64458868/92f8ba91-fae0-4c2f-bc4c-c261af0e49f0)
![Screenshot_2024-03-12_11-23-49](https://github.com/RohanSengupta326/MindSpace/assets/64458868/a6840516-b211-4247-b3e2-1e231760d8ba)
![Screenshot_2024-03-12_10-31-12](https://github.com/RohanSengupta326/MindSpace/assets/64458868/4d13c238-aeb2-4061-ae16-8c8559f09030)
![Screenshot_2024-03-12_10-30-30](https://github.com/RohanSengupta326/MindSpace/assets/64458868/eb426e61-e507-43ac-b639-39561cdcd499)
![Screenshot_2024-03-12_10-29-41](https://github.com/RohanSengupta326/MindSpace/assets/64458868/35a9540f-c52f-47e5-acc4-50533e43c61e)



**Getting Started**

1. **Prerequisites:**
   - Flutter development environment set up (refer to official documentation: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install))
   - An OpenAI API key ([https://openai.com/blog/openai-api](https://openai.com/blog/openai-api))

2. **Installation:**
   - Clone this repository: `git clone https://github.com/RohanSengupta326/MindSpace`
   - Navigate to the project directory: `cd MindSpace`
   - install ` fvm ` and install the required version of flutter ( check version here : /MindSpace/mind_space_app/.fvm/fvm_config.json )
   - Install dependencies: `fvm flutter pub get`

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
   - Start the development server: `fvm flutter run -d web-server`
   - Access the application in your web browser (usually at `http://localhost:8080/`).

**Usage**

1. Explore the mental health knowledge base to learn about different conditions and potential solutions.
2. Initiate a conversation with MindSpace AI by entering your questions or concerns in the chat interface.

**Disclaimer**

This application is intended to provide information and support, but it is not a substitute for professional mental health care. If you are experiencing serious mental health concerns, please seek help from a qualified mental health professional.


