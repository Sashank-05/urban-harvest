# Urban Harvest: Setting up the Project Guide

Urban Harvest is a project aimed at facilitating urban gardening and plant/seed trading. Below is a comprehensive guide on setting up the project both on the cloud and locally.

## Setting up on Cloud

1. **Create a New Project on Google Cloud/Firebase:**
    - Begin by creating a new project on Google Cloud or Firebase, depending on your preference and requirements.

2. **Enable Authentication and Firestore APIs:**
    - Within your project settings, navigate to the APIs & Services section and enable both the Authentication and Firestore APIs.

3. **Configure Authentication Settings:**
    - In the Authentication section, enable Google Sign-in and Email Single Sign-On (SSO) to allow users to authenticate via Google accounts or email addresses.

4. **Setup Firestore Database Collections:**
    - Create three collections in your Firestore database: "Users", "Locations", and "Trades". These collections will store user data, location information, and trade details respectively.

5. **Enable Google Maps API:**
    - Enable the Google Maps API in the Google Cloud Console and save the API key for later use. This API key will be utilized for integrating maps into the application.

   The final structure of your database should resemble the following:

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

## Setting up Locally

### Install Required Command Line Tools

- **Firebase CLI:**
    - Log into Firebase using your Google account by running `firebase login` in your terminal.

- **FlutterFire CLI:**
    - Install the FlutterFire CLI globally by running `dart pub global activate flutterfire_cli` in your terminal.

### Configure Your Apps to Use Firebase

- From your Flutter project directory, initiate the app configuration workflow by running `flutterfire configure`.
- Select the project previously set up for Urban Harvest. This command ensures that your Flutter app's Firebase configuration is up-to-date and adds any required Gradle plugins automatically.

### Google Maps API Integration

- Create a `secrets.properties` file in the android folder of your Flutter project.
- Add the following content to `secrets.properties`:

  ```
  MAPS_API_KEY=YOUR_API_KEY
  ```

  Replace `YOUR_API_KEY` with the API key obtained from the Google Cloud Platform for the Google Maps API.

### Additional Steps

- Run `install.bat` to install any required TensorFlow Lite binaries if necessary for your project.

By following these steps, you'll have Urban Harvest set up both on the cloud and locally, ready for development and deployment.