Usage:

Set enabled credit card types:
Denetron.CreditCard.setEnabledCardTypes(['master', 'visa']);

The javascript will automatically bind the jquery plugin to any fields matching: <input name="*_card_number" />


Testing:
The included spec/ folder contains tests pulled from the Ruby on Rails project where this code was written, and is written for the Jasmine javascript testing suite.