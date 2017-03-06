# Sample Sinatra application authenticating using SAML

Based on [sinatra-saml-sample](https://github.com/aibou/sinatra-saml-sample),
uses [ruby-saml](https://github.com/onelogin/ruby-saml). Tested w/ Onelogin.

## Installation

```bash
bundle install
```

Update `config/app.yml` with the settings from your SAML provider.

```bash
rackup
```
