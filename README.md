# flirty-host

## For when you need to be safe... but not _too_ safe!

Sometimes you need to show someone some web pages. And you need to make sure only that the chosen person sees it. FlirtyHost will host a folder of static web content for you, and protect it with a simple username and password.

This is **_not_** intended for top secret projects. This is for convenience only!

## Getting Started
Install the module with: `npm install flirty-host`

### From your code

```javascript
var FlirtyHost, app;

FlirtyHost = require('flirty-host');

app = FlirtyHost.host('./public', {
  username: 'bert',
  password: 'earnie',
  maxAge: 600000
});

app.listen(3333, function(err) {
  return console.log("server active on 3333");
});
```

### From the command line

Install globally, `npm install -g flirty-host`

Then type `flirt` and you'll be prompted to provide the folder, port and login credentials you want to use.

## Documentation
### Options
`FlirtyHost.host(<folder>, <options>);`

- folder: The path to the folder you want to host. Defaults to the current folder
- options: A hash describing the following
	- username 	
	- password
	- maxAge: How long a login session lasts in milliseconds

If you don't provide a username and password the content will be hosted without the need to login.

## Examples
_(Coming soon)_

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [grunt](https://github.com/gruntjs/grunt).

## Release History
_(Nothing yet)_

## License
Copyright (c) 2013 Darren Wallace  
Licensed under the MIT license.
