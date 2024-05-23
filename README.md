
This Flutter project is a simple CRUD (Create, Read, Update, Delete) application that allows users to manage user information. It includes two main screens:

Home Page: Displays a list of users fetched from an API. Users can be searched, added, edited, and deleted. Additionally, users can update the API key used for fetching data and navigate to a web page.

User Info Form: Allows users to add or edit user information including name and birthdate. The form validates input and saves user data using an API service.

FEAUTURES:
Fetch users from an API and display them in a list.
Search users by name.
Add new users with a name and birthdate.
Edit existing users' information.
Delete users from the list.
Update API key used for fetching data.
Launch a web page within the app.

TECHONOLOGIES USED:

url_launcher: A Flutter plugin for launching URLs in the browser.

shared_preferences: A Flutter plugin for persistent key-value storage.

dio: A powerful HTTP client for Dart, which handles requests and responses and provides many features like interceptors, transformers, and error handling.

DateTimePicker: A Flutter package for picking dates and times.

API Service: A custom service to handle API requests for CRUD operations.

USAGE:
git clone https://github.com/ahmetbekir22/crud-app.git

INSTALL DEPENDICIES:  flutter pub get

RUN THE APP: flutter run

on UI you can click on user name for updating user informations.
