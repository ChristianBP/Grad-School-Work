## Knowledge base description
## Examples that work and their explanations

### Meat
A customer buys bacon if they order
    California Club Sandwich or
    Club Royale or
    Deli Club or
    Smokey Jack Panini

A customer buys chicken breast if they order
    Chicken Panini or
    Chicken Tenders or
    Chipotle Chicken & Avocado Panini

A customer buys corned beef if they order
    New York Yankee

A customer buys nitrite-free ham if they order
    Club Royale or
    Deli Club

A customer buys nitrite-free smoked turkey breast if they order
    Club Royale or
    Smokey Jack Panini

A customer buys pastrami if they order
    New York Yankee

A customer buys roasted turkey breast if they order
    California Club Sandwich or
    Deli Club

A customer buys roast beef if they order
    Beefeater

A customer buys Wild Alaska sockeye salmon if they order
    Wild Salmon-wich


### Cheese
A customer buys cheddar if they order
    Club Royale or
    Deli Club or
    Grilled Cheese

A customer buys fresh mozzarella if they order
    Caprese Panini

A customer buys jalapeño pepper jack if they order
    Chipotle Chicken & Avocado Panini or
    Smokey Jack Panini

A customer buys provolone if they order
    Beefeater
    Chicken Panini

A customer buys Swiss if they order
    California Club Sandwich or
    Club Royale or
    Deli Club or
    New York Yankee


### Fruit
A customer buys Roma tomatoes if they order
    Caprese Panini

A customer buys sliced avocado if they order
    Chipotle Chicken & Avocado Panini

A customer buys tomato if they order
    Chicken Panini or
    Club Royale or
    Deli Club or
    Smokey Jack Panini or
    Wild Salmon-wich


### Vegetables
A customer buys leafy lettuce if they order
    Club Royale or
    Deli Club or
    Wild Salmon-wich

A customer buys organic field greens if they order
    California Club Sandwich

A customer buys organic spinach if they order
    Caprese Panini or
    Chicken Panini

A customer buys pickled red onions if they order
    Chipotle Chicken & Avocado Panini


### Spreads and Sauces
A customer buys 1000 Island if they order
    Smokey Jack Panini

A customer buys balsamic vinaigrette if they order
    Wild Salmon-wich

A customer buys chipotle aioli if they order
    Chipotle Chicken & Avocado Panini or
    Wild Salmon-wich

A customer buys guacamole if they order
    California Club Sandwich or
    Smokey Jack Panini or
    Wild Salmon-wich
    
A customer buys honey mustard if they order
    Club Royale

A customer buys lemon crema if they order
    Chipotle Chicken & Avocado Panini

A customer buys mayo if they order
    Beefeater
    California Club Sandwich or
    Deli Club

A customer buys pesto aioli if they order
    Caprese Panini or
    Chicken Panini


### Bread
A customer buys croissant if they order
    California Club Sandwich or
    Club Royale

A customer buys herb focaccia if they order
    Caprese Panini or
    Wild Salmon-wich

A customer buys Marbled Rye if they order
    New York Yankee
    
A customer buys Mexican-style roll if they order
    Chipotle Chicken & Avocado Panini

A customer buys multigrain wheat if they order
    Deli Club or
    Grilled Cheese

A customer buys New Orleans French if they order
    Beefeater

A customer buys sourdough if they order
    Chicken Panini or
    Smokey Jack Panini


### Sides
A customer buys a side if they order
    California Club Sandwich or
    Wild Salmon-wich
    
A customer buys a cup of au jus if they order
    Beefeater

Did the customer buy X?
```
?- buys(john, X).
X = 'chicken breast' ;
X = 'jalapeÃ±o pepper jack' ;
X = 'sliced avocado' ;
X = 'pickled red onions' ;
X = 'chipotle aioli' ;
X = 'lemon crema' ;
false.
```
```
?- buys(john, 'chicken breast').
true.
```

### Put food in proper categories
A food is meat if it is
    bacon or
    chicken breast or
    corned beef or
    nitrite-free ham or
    nitrite-free smoked turkey breast or
    pastrami or
    roast beef or
    roasted turkey breast

A food is fish if it is
    Wild Alaska sockeye salmon

A food is cheese if it is
    cheddar or
    fresh mozzarella or
    jalapeño pepper jack or
    provolone or
    Swiss

A food is tomato if it is
    Roma tomatoes or
    tomato

A food is fruit if it is
    sliced avocado or
    tomato

A food is vegetables if it is
    leafy lettuce or
    organic field greens or
    organic spinach or
    pickled red onions

A food is spread or sauce if it is
    1000 Island or
    balsamic vinaigrette or
    chipotle aioli or
    guacamole or
    honey mustard or
    lemon crema or
    mayo or
    pesto aioli

A food is bread if it is
    croissant or
    herb focaccia or
    Marbled Rye or
    Mexican-style roll or
    multigrain wheat or
    New Orleans French or
    sourdough

A food is toasted if it is
    croissant or
    herb focaccia or
    Marbled Rye or
    multigrain wheat or
    New Orleans French or

An item is food if it is
    meat or
    fish or
    cheese or
    fruit or
    vegetables or
    spreadorsauce or
    bread or
    tomato

Is a food meat, vegetable, fruit, etc?
```
?- meat('chicken breast').
true.
```
```
?- vegetable('chicken breast').
false.
```
```
?- fruit('chicken breast').
false.
```

Did John have toasted bread?
```
?- hadToastedBread(john).     
true .
```


The California Club Sandwich has 690 calories
The Club Royale has 680 calories
The Deli Club has 800 calories
The Caprese Panini has 740 calories
The Smokey Jack Panini has 770 calories
The Chicken Panini has 770 calories
The Chipotle Chicken & Avocado Panini has 930 calories
The Beefeater has 840 calories
The Wild Salmon-wich has 600 calories
The New York Yankee has 1100 calories
The Grilled Cheese has 450 calories
The Chicken Tenders has 240 calories

It takes (calories / 100) miles of running to burn off a meal
How many miles does John have to run to burn off his meal(s)?
```
?- milesToBurnOffMeal(john, Miles, yesterday).
Miles = 9.3.
```

The California Club Sandwich costs $10.69
The Club Royale costs $10.69
The Deli Club costs $10.69
The Caprese Panini costs $9.19
The Smokey Jack Panini costs $10.39
The Chicken Panini costs $10.29
The Chipotle Chicken & Avocado Panini costs $10.29
The Beefeater costs $11.79
The Wild Salmon-wich costs $12.39
The New York Yankee costs $14.39
The Grilled Cheese costs $4.29
The Chicken Tenders costs $5.19

What was the most expensive order a customer placed in a certain time period?
```
?- mostExpensive(john, Item, Price, yesterday).
Item = 'Chipotle Chicken & Avocado Panini',
Price = 10.29 ;
false.
```

What was the most expensive item ordered yesterday?
```
?- mostExpensive(_, Item, Price, yesterday).
Item = 'Chipotle Chicken & Avocado Panini',
Price = 10.29 ;
false.
```

South Coit Road's Jason's Deli opens at 10am and closes at 10pm

The wait time for food is 10 minutes from 10am-12pm and 2-4pm, and 8-10pm
The wait time for food is 20 minutes from 12-2pm, 4-6pm
The wait time for food is 30 minutes from 6-8pm

What is the wait time at South Coit Road's Jason's Deli at 3:33pm?
```
?- waitTime('South Coit Road\'s Jason\'s Deli', Wait, 1533).
Wait = 10 ;
false.
```

How many orders were placed by a specific customer?
```
?- totalOrders(john, _, Count).    
Count = 1.
```
How many orders were placed in a certain time period?
```
?- totalOrders(_, yesterday, Count).
Count = 1.
```
How many orders were placed by a specific customer in a certain time period?
```
?- totalOrders(john, yesterday, Count).
Count = 1.
```

How much money was spent by a specific customer?
```
?- totalSpent(john, _, Dollars).
Dollars = 10.29.
```
How much money was spent in a certain time period?
```
?- totalSpent(_, yesterday, Dollars).
Dollars = 10.29.
```
How much money was spent by a specific customer in a certain time period?
```
?- totalSpent(john, yesterday, Dollars).
Dollars = 10.29.
```

### Q1
A customer is a child if they order only kids meals.
A customer is an adult if they order at least one meal that isn't a kids meal.
Is John a child or an adult?
```
?- child(john).
false.
```
```
?- adult(john).
true.
```

### Q2
### Already mostly answered this one by categorizing food but
### need to clarify that the person eats any food they buy
A person eats any food they buy.

Did John eat any vegetables yesterday?
```
?- eats(john, Food), vegetables(Food). 
Food = 'pickled red onions' .
```

### Q3
Did John buy any meat?
```
?- buys(john, Food), meat(Food).
Food = 'chicken breast' .
```

### Q4
If the customer buys something then they must have brought cash or a credit card to pay for it.

Did John bring money or a credit card to the deli?
```
?- brings(john, Money, 'South Coit Road\'s Jason\'s Deli').
Money = cash ;
Money = 'credit card'.
```

### Q5
Orders happen while the customer who is ordering is at the location
The customer has less money after they order
If event A happens after B and event C happens during B, then C is also true after A.

Did John have less money after going to the deli?
```
?- after(hasless(john, money), at(john, 'South Coit Road\'s Jason\'s Deli', yesterday)).
true .
```

### Q6
If someone orders from a location at a certain time then there must be staff there to prepare the order
If a customer orders then they must be at the location at the time they order

Are there other people at Jason’s deli while John is there?
```
?- at(john, Location, Time), at(X, Location, Time), Location = 'South Coit Road\'s Jason\'s Deli', people(X).
Location = 'South Coit Road\'s Jason\'s Deli',
Time = yesterday,
X = staff ;
false.
```

### Q7
A customer is a vegetarian if they eat at least one thing and nothing they eat is meat or fish
A customer is a pescetarian if they eat at least one thing and nothing they eat is meat
If the customer does not eat anything then we don't know if the customer is a vegetarian, pescetarian, or neither

Is John a vegetarian?
```
?- vegetarian(john).
false.
```

Is John a pescetarian?
```
?- pescetarian(john).
false.
```

### Q8
A customer eats at least an ounce of roast beef if they eat roast beef. The only option on the menu for roast beef is 8 ounces.
If a customer eats some food then you can also say they have that food.

Did John have an ounce of roast beef?
```
?- have(john, ounce('roast beef')).
false.
```

## Examples that don't work and their explanations
### Q9
The knowledge base does not include the weights of the individual items or the total weight John might be able to carry.
carry(Customer, Y),
Y = aggregate_all(sum(Weight), (buys(Customer, Item), weighs(Item, Weight)), Weight).


The knowledge base does not include all of the items on the Jason's Deli menu
orders(john, 'Bigger Better BLT', 'South Coit Road\'s Jason\'s Deli', yesterday).
```
?- buys(john, 'bacon').
false.
```


The knowledge base treats every time variable that is entered into orders(Customer, Item, Location, Time) as it's own point in time, unrelated to any other points in time.
yesterday = today - 2400.


## What I learned
- I learned all about prolog for this assignment. I originally was tracking each topping a person had ordered by using a series of OR statements. While reading about prolog more, I learned that I could more effectively represent this by stating that a customer buys a topping if that topping is a member of the group of items that includes that topping.
- To know if a customer is an adult, I said that they must have ordered at least one meal that isn't a children's meal. The code I was writing at first was instead going through each meal and saying whether it was an adult or children's meal. I learned that it was easier to write the child axiom as, a customer is a child if they order a meal and every meal they order only includes things from the children's menu. Then I just said that an adult is the inverse of a child and got the intended results.
- I also learned how quickly axioms could exponentiate when I tried to represent different concepts. Just thinking about representing time, I'd have to select a time standard and create axioms that could appropriately represent a variety of concepts within that time standard. I'd have to assign numbers to specific time units including years, months, days, hours, and seconds. And then I'd have to say how the units relate to days or the week, yesterday, today, tomorrow, next year, etc. Then I'd have to use my new system to represent what it means for staff to be at the restaurant from 10am-10pm M-F. This could quickly become 50-100 axioms or more.