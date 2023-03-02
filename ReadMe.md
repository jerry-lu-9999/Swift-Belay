#  Belay feature list

- [x] App Logo
- [x] Launch Screen
- [x] email log in, and maintain logged in consistency between app launches
- [ ] phone number
- [x] facebook log in
- [x] google log in
- [ ] authentication error handling
- [x] prompt to remind user of last used authentication method

- [x] email sign up
- [ ] email link authentication

- [ ] forget the password? 
- [ ] reset the password
- [ ] link multiple social network together
- [ ] change the email address in profile page

- [ ] profile setup process

- [ ] create a domain for our app

## Issues

* Currently using FB/Google Sign In will import user's first name and last name, but signing up with email will not include those

## Useful links

* [Authentication docu](https://firebase.google.com/docs/auth/ios/errors?authuser=0)

## Packages we use

* [Facebook](http://github.com/facebook/facebook-ios-sdk)
* [GoogleSignIn](http://github.com/google/GoogleSignIn-iOS)
* [Firebase](https://github.com/firebase/firebase-ios-sdk)

## Database

We use [Realtime Database](https://firebase.google.com/docs/database/ios/start?authuser=0) from Firebase, which means it will be in the form of JSON
Our database looks like this
```
{
    "<user email>": {
        "first_name" : 
        "last_name" :
    }
}
```

