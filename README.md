# Urban Harvest

## Setting up the project

### Setting up on cloud

1. Create a new Google Cloud/Firebase project.
2. Enable Authentication and Firestore APIs.
3. Enable Google Sign in and Email SSO in Authentication.
4. Setup the firestore Database Collections with names "Users", "Location" and "Trades"
5. Enable the Google Maps API and save the API key for later

The final Database structure will look like this
```
Users
|----- User1 => {displayName: "Username", "Plants": [array of plants]}
|----- User2

Locations
|----- Country
          |
          | ----- CityName => [array of geopoints]

Trades
|----- TradeID => {Information}
```

## Setting up locally

<b>Install the required command line tools</b>

Log into Firebase using your Google account by running the following command:

`firebase login`

Install the FlutterFire CLI by running the following command from any directory:

`dart pub global activate flutterfire_cli`

<b>Configure your apps to use Firebase</b>


From your Flutter project directory, run the following command to start the app configuration workflow
Select the Project which you have setup for this application.

`flutterfire configure`

Re-running the command ensures that your Flutter app's Firebase configuration is up-to-date and automatically adds any required Gradle plugins to your app.

<b> Google MAPS API</b>

Create a secrets.properties file in android folder and make the contents like this

`MAPS_API_KEY=YOUR_API_KEY`

Replace API key with the API key from Google Cloud Platform

### You might have to run install.bat to install the required tensorflow Lite binaries

