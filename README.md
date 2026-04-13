# Trevor's Blog & Fraud Detection Suite

This is a full-stack web development project that helps educate users on fraud such that they're aware of schemes. There is interactive decision trees as well as TF-IDF algorithm to help categorize the type of fraud the person is going through (when inputting their scenario into the fraud detection feature).

## 1. Project Mission
	a. The purpose of this web-app is to provide users with more information on how to detect fraud and protect themselves from potential fraud scenarios. 
	b. I collaborated with a domain expert, Trevor Balthrop, in the development of this project. I provided the algorithms and web site while he maintains responsibility for the content.

## 2. Core Features
	a. The decision tree is open to everyone as it's built as a simple algorithm that does not rely on the OpenAI API key. Thus, this is no cost to use. 
	b. The TF-IDF Classifier requires an account since the feature is used in conjunction with the OpenAI API key. The TF-IDF is used as a "Pre-classifier" to determine the fraud category if the user selects an option indicating that they're unsure of what type of fraud. The OpenAI API is used to submit the user's prompt along with the internal prompt (set up by Trevor) to generate personalized safety recommendations.
	c. The blog provides educational content, allowing the domain expert to provide information on fraud patterns or fraud areas that he has noticed and feels that the reader should know about.
	d. There is a content management system that allows an admin to upload and edit new fraud scenarios (JSON files) on the fly, the ability to add/edit blog posts and capability to send out notification emails once a new blog or decision tree has been added.

## 3. The Logic Engines (Technical)
	a. TF-IDF is a statistical measure used to evaluate how relevant a word is to a document in a collection (corpus). Keywords such as 'bank' will be more frequent in a collection of documents indicating Bank Fraud. Similarly, keywords such as 'airline' will be more frequent in a collection of documents indicating Airline Fraud. 
	b. The decision tree algorithm uses parsing to find the "Root Node". I used session based tracking to remember what path a user took so that we can show them a summary at the end. The purpose of the use of sessions was to maintain state across a stateless web environment. The "End ID" lets the algorithm know that the decision tree is done and to present the end results to the end user.

## 4. Full-Stack Systems
	a. Automated Notification System: there is an ability to send notification emails to users that have opted in to receive notification emails. The system will scan the users with this setting set to true and use a Mailer to send updates. This is an event-driven system that occurs when the admin clicks a button to notify users.
	b. File Management: the blogs, decision trees and user data are all stored in a PostgreSQL database.

## 5. Learning & Evolution:
	a. Deterministic: the project (TF-IDF and Decision tree) follows an exact set of rules (If A, then B). The TF-IDF is traditional AI, NLP specifically.
